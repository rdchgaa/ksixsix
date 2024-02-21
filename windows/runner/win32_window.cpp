#include "win32_window.h"

#include <flutter_windows.h>

#include "resource.h"

#define ID_TIMER 10010

namespace {

#define WM_USER_NOTIFY  WM_USER + 200
#define IDR_OUIT  0
#define IDR_OPEN  1

	constexpr const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

	// The number of Win32Window objects that currently exist.
	static int g_active_window_count = 0;

	using EnableNonClientDpiScaling = BOOL __stdcall(HWND hwnd);

	// Scale helper to convert logical scaler values to physical using passed in
	// scale factor
	int Scale(int source, double scale_factor) {
		return static_cast<int>(source * scale_factor);
	}

	// Dynamically loads the |EnableNonClientDpiScaling| from the User32 module.
	// This API is only needed for PerMonitor V1 awareness mode.
	void EnableFullDpiSupportIfAvailable(HWND hwnd) {
		HMODULE user32_module = LoadLibraryA("User32.dll");
		if (!user32_module) {
			return;
		}
		auto enable_non_client_dpi_scaling =
			reinterpret_cast<EnableNonClientDpiScaling*>(
				GetProcAddress(user32_module, "EnableNonClientDpiScaling"));
		if (enable_non_client_dpi_scaling != nullptr) {
			enable_non_client_dpi_scaling(hwnd);
			FreeLibrary(user32_module);
		}
	}

}  // namespace

// Manages the Win32Window's window class registration.
class WindowClassRegistrar {
public:
	~WindowClassRegistrar() = default;

	// Returns the singleton registar instance.
	static WindowClassRegistrar* GetInstance() {
		if (!instance_) {
			instance_ = new WindowClassRegistrar();
		}
		return instance_;
	}

	// Returns the name of the window class, registering the class if it hasn't
	// previously been registered.
	const wchar_t* GetWindowClass();

	// Unregisters the window class. Should only be called if there are no
	// instances of the window.
	void UnregisterWindowClass();

private:
	WindowClassRegistrar() = default;

	static WindowClassRegistrar* instance_;

	bool class_registered_ = false;
};

WindowClassRegistrar* WindowClassRegistrar::instance_ = nullptr;

const wchar_t* WindowClassRegistrar::GetWindowClass() {
	if (!class_registered_) {
		WNDCLASS window_class{};
		window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
		window_class.lpszClassName = kWindowClassName;
		window_class.style = CS_HREDRAW | CS_VREDRAW;
		window_class.cbClsExtra = 0;
		window_class.cbWndExtra = 0;
		window_class.hInstance = GetModuleHandle(nullptr);
		window_class.hIcon =
			LoadIcon(window_class.hInstance, MAKEINTRESOURCE(IDI_APP_ICON));
		window_class.hbrBackground = 0;
		window_class.lpszMenuName = nullptr;
		window_class.lpfnWndProc = Win32Window::WndProc;
		RegisterClass(&window_class);
		class_registered_ = true;
	}
	return kWindowClassName;
}

void WindowClassRegistrar::UnregisterWindowClass() {
	UnregisterClass(kWindowClassName, nullptr);
	class_registered_ = false;
}

Win32Window::Win32Window() {
	++g_active_window_count;
}

Win32Window::~Win32Window() {
	--g_active_window_count;
	Destroy();
}

bool Win32Window::CreateAndShow(const std::wstring& title,
	const Point& origin,
	const Size& size) {
	Destroy();

	const wchar_t* window_class =
		WindowClassRegistrar::GetInstance()->GetWindowClass();

	const POINT target_point = { static_cast<LONG>(origin.x),
								static_cast<LONG>(origin.y) };
	HMONITOR monitor = MonitorFromPoint(target_point, MONITOR_DEFAULTTONEAREST);
	UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
	double scale_factor = dpi / 96.0;

	//WS_OVERLAPPED | \
    //    WS_CAPTION | \
    //    WS_SYSMENU | \
    //    WS_THICKFRAME | \
    //    WS_MINIMIZEBOX | \
    //    WS_MAXIMIZEBOX


	HWND window = CreateWindow(
		window_class, title.c_str(), WS_SYSMENU | WS_MINIMIZEBOX | WS_OVERLAPPED | WS_CAPTION | WS_VISIBLE | WS_MAXIMIZEBOX | WS_THICKFRAME,
		Scale(origin.x, scale_factor), Scale(origin.y, scale_factor),
		Scale(size.width, scale_factor), Scale(size.height, scale_factor),
		nullptr, nullptr, GetModuleHandle(nullptr), this);

	if (!window) {
		return false;
	}

	return OnCreate();
}

// static
LRESULT CALLBACK Win32Window::WndProc(HWND const window,
	UINT const message,
	WPARAM const wparam,
	LPARAM const lparam) noexcept {
	if (message == WM_NCCREATE) {
		auto window_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
		SetWindowLongPtr(window, GWLP_USERDATA,
			reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));

		auto that = static_cast<Win32Window*>(window_struct->lpCreateParams);
		EnableFullDpiSupportIfAvailable(window);
		that->window_handle_ = window;
	}
	else if (Win32Window* that = GetThisFromHandle(window)) {
		return that->MessageHandler(window, message, wparam, lparam);
	}

	return DefWindowProc(window, message, wparam, lparam);
}

LRESULT
Win32Window::MessageHandler(HWND hwnd,
	UINT const message,
	WPARAM const wparam,
	LPARAM const lparam) noexcept {
	switch (message) 
	{
	case WM_TIMER:
		TwinkleNotify(hwnd);
		break;
	case WM_DESTROY:
		window_handle_ = nullptr;
		Destroy();
		if (quit_on_close_) {
			PostQuitMessage(0);
		}
		return 0;

	case WM_DPICHANGED: {
		auto newRectSize = reinterpret_cast<RECT*>(lparam);
		LONG newWidth = newRectSize->right - newRectSize->left;
		LONG newHeight = newRectSize->bottom - newRectSize->top;

		SetWindowPos(hwnd, nullptr, newRectSize->left, newRectSize->top, newWidth,
			newHeight, SWP_NOZORDER | SWP_NOACTIVATE);

		return 0;
	}
	case WM_SIZE: {
		RECT rect = GetClientArea();
		if (child_content_ != nullptr) {
			// Size and position the child window.
			MoveWindow(child_content_, rect.left, rect.top, rect.right - rect.left,
				rect.bottom - rect.top, TRUE);
		}
		return 0;
	}
	case WM_ACTIVATE:
		if (child_content_ != nullptr) {
			SetFocus(child_content_);
		}
		return 0;
	case WM_CREATE:
		CreateNotify(hwnd);
		break;

	case WM_USER_NOTIFY:
		switch (lparam)
		{
		case WM_LBUTTONDOWN:
			ShowWindow(hwnd);
			break;
		case WM_RBUTTONDOWN:
			CreateNotifyMenu(hwnd);
			break;
		}
		break;
	case WM_COMMAND:
		switch (wparam) {
		case IDR_OPEN:
			ShowWindow(hwnd);
			break;
		case IDR_OUIT:
			Shell_NotifyIcon(NIM_DELETE, &m_notify);
			return DefWindowProc(window_handle_, WM_CLOSE, wparam, lparam);
		default:
			break;
		}
		break;

	case WM_CLOSE:
		HideWindow(hwnd);
		return 0;
	case WM_GETMINMAXINFO:
        LPMINMAXINFO lpMMI = (LPMINMAXINFO)lparam;
        lpMMI->ptMinTrackSize.x = 420;
        lpMMI->ptMinTrackSize.y = 760;
		return 0;
	}

	return DefWindowProc(window_handle_, message, wparam, lparam);
}

void Win32Window::HideWindow(HWND hWND) {
	::ShowWindow(hWND, SW_HIDE);
}

void Win32Window::ShowWindow(HWND hWND) {
	::SetForegroundWindow(hWND);
	::ShowWindow(hWND, SW_SHOWNOACTIVATE);
}

void Win32Window::CreateNotifyMenu(HWND hWND) {
	POINT pt;
	GetCursorPos(&pt);
	HMENU hMenu = CreatePopupMenu();
	AppendMenu(hMenu, MF_STRING, IDR_OPEN, L"Open UTalk");
	AppendMenu(hMenu, MF_STRING, IDR_OUIT, L"Quit UTalk");
	TrackPopupMenu(hMenu, TPM_RIGHTBUTTON, pt.x, pt.y, NULL, hWND, NULL);
}
void Win32Window::CreateNotify(HWND hWND)
{
	m_notify_icon = (HICON)LoadImage(NULL, TEXT("app_icon.ico"), IMAGE_ICON, 0, 0, LR_LOADFROMFILE);
	const auto name = L"UTalk";
	m_notify.hIcon = m_notify_icon;
	m_notify.hWnd = hWND;
	m_notify.uID = 1;
	m_notify.uFlags = NIF_GUID | NIF_ICON | NIF_MESSAGE | NIF_TIP;
	m_notify.uCallbackMessage = WM_USER_NOTIFY;
	wcsncpy_s(m_notify.szTip, name, 6);
	Shell_NotifyIcon(NIM_ADD, &m_notify);

}


//����ͼ����˸���� 
void Win32Window::TwinkleNotify(HWND hWND) {
	if (m_notify_status) {
		if (m_notify.hIcon == 0) {
			m_notify.hIcon = m_notify_icon;
		}
		else {
			m_notify.hIcon = 0;
		}
		Shell_NotifyIcon(NIM_MODIFY, &m_notify);
	}
}

void Win32Window::Destroy() {
	OnDestroy();

	if (window_handle_) {
		DestroyWindow(window_handle_);
		window_handle_ = nullptr;
	}
	if (g_active_window_count == 0) {
		WindowClassRegistrar::GetInstance()->UnregisterWindowClass();
	}
}

Win32Window* Win32Window::GetThisFromHandle(HWND const window) noexcept {
	return reinterpret_cast<Win32Window*>(
		GetWindowLongPtr(window, GWLP_USERDATA));
}

void Win32Window::SetChildContent(HWND content) {
	child_content_ = content;
	SetParent(content, window_handle_);
	RECT frame = GetClientArea();

	MoveWindow(content, frame.left, frame.top, frame.right - frame.left,
		frame.bottom - frame.top, true);

	SetFocus(child_content_);
}

RECT Win32Window::GetClientArea() {
	RECT frame;
	GetClientRect(window_handle_, &frame);
	return frame;
}

HWND Win32Window::GetHandle() {
	return window_handle_;
}

void Win32Window::SetQuitOnClose(bool quit_on_close) {
	quit_on_close_ = quit_on_close;
}

bool Win32Window::OnCreate() {
	SetTimer(window_handle_, ID_TIMER, 500, NULL);
	return true;
}

void Win32Window::OnDestroy() {
	KillTimer(window_handle_, ID_TIMER);
}

void Win32Window::SetNotify(bool status)
{
	m_notify_status = status;
	m_notify.hIcon = m_notify_icon;
	Shell_NotifyIcon(NIM_MODIFY, &m_notify);
}

void Win32Window::SetNotifyName(std::wstring name)
{
	size_t size = name.size();
	if (size > 128) {
		size = 128;
	}
	wcsncpy_s(m_notify.szTip, name.c_str(), size);
	Shell_NotifyIcon(NIM_MODIFY, &m_notify);
}
