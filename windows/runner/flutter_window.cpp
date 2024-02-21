#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"
#include <flutter/ephemeral/cpp_client_wrapper/include/flutter/method_channel.h>
#include <flutter/ephemeral/cpp_client_wrapper/include/flutter/standard_method_codec.h>
#include "device_id.h"

// Converts the given UTF-16 string to UTF-8.
std::string Utf8FromUtf16(const std::wstring& utf16_string) {
	if (utf16_string.empty()) {
		return std::string();
	}
	int target_length = ::WideCharToMultiByte(
		CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string.data(),
		static_cast<int>(utf16_string.length()), nullptr, 0, nullptr, nullptr);
	if (target_length == 0) {
		return std::string();
	}
	std::string utf8_string;
	utf8_string.resize(target_length);
	int converted_length = ::WideCharToMultiByte(
		CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string.data(),
		static_cast<int>(utf16_string.length()), utf8_string.data(),
		target_length, nullptr, nullptr);
	if (converted_length == 0) {
		return std::string();
	}
	return utf8_string;
}

// Converts the given UTF-8 string to UTF-16.
std::wstring Utf16FromUtf8(const std::string& utf8_string) {
	if (utf8_string.empty()) {
		return std::wstring();
	}
	int target_length =
		::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, utf8_string.data(),
			static_cast<int>(utf8_string.length()), nullptr, 0);
	if (target_length == 0) {
		return std::wstring();
	}
	std::wstring utf16_string;
	utf16_string.resize(target_length);
	int converted_length =
		::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, utf8_string.data(),
			static_cast<int>(utf8_string.length()),
			utf16_string.data(), target_length);
	if (converted_length == 0) {
		return std::wstring();
	}
	return utf16_string;
}

// 

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
	: project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
	if (!Win32Window::OnCreate()) {
		return false;
	}

	RECT frame = GetClientArea();

	// The size here must match the window dimensions to avoid unnecessary surface
	// creation / destruction in the startup path.
	flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
		frame.right - frame.left, frame.bottom - frame.top, project_);
	// Ensure that basic setup of the controller was successful.
	if (!flutter_controller_->engine() || !flutter_controller_->view()) {
		return false;
	}
	RegisterPlugins(flutter_controller_->engine());
	SetChildContent(flutter_controller_->view()->GetNativeWindow());

	flutter_channel_ = std::make_unique<flutter::MethodChannel<>>(
		flutter_controller_->engine()->messenger(), "flutter/application",
		&flutter::StandardMethodCodec::GetInstance());

	flutter_channel_->SetMethodCallHandler(
		[this](const auto& call, auto result) {
			this->HandleMethodCall(call, std::move(result));
		});

	return true;
}

std::string GetPathArgument(const flutter::MethodCall<>& method_call) {
	std::string url;
	const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
	if (arguments) {
		auto url_it = arguments->find(flutter::EncodableValue("path"));
		if (url_it != arguments->end()) {
			url = std::get<std::string>(url_it->second);
		}
	}
	return url;
}


void FlutterWindow::SetNotify(const flutter::MethodCall<>& method_call)
{
	const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
	if (arguments) {
		auto url_it = arguments->find(flutter::EncodableValue("status"));
		if (url_it != arguments->end()) {
			Win32Window::SetNotify(std::get<bool>(url_it->second));
		}
	}
}

void FlutterWindow::SetTitle(const flutter::MethodCall<>& method_call)
{
	const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
	if (arguments) {
		auto title_it = arguments->find(flutter::EncodableValue("title"));
		if (title_it != arguments->end()) {
			std::string titleUTF8 = std::get<std::string>(title_it->second);
			std::wstring titleUTF16 = Utf16FromUtf8(titleUTF8);
			SetWindowText(this->GetHandle(), titleUTF16.c_str());
			Win32Window::SetNotifyName(titleUTF16);
		}
	}
}

void FlutterWindow::CheckTitle(const flutter::MethodCall<>& method_call,std::unique_ptr<flutter::MethodResult<>> result)
{
	const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
	if (arguments) {
		auto title_it = arguments->find(flutter::EncodableValue("title"));
		if (title_it != arguments->end()) {
			std::string titleUTF8 = std::get<std::string>(title_it->second);
			std::wstring titleUTF16 = Utf16FromUtf8(titleUTF8);
			HWND hWnd = ::FindWindow(L"FLUTTER_RUNNER_WIN32_WINDOW", titleUTF16.c_str());
			result->Success(flutter::EncodableValue(hWnd > 0));
			return;
		}
	}
	result->Success(flutter::EncodableValue(false));
}

void FlutterWindow::GetDeviceId(const flutter::MethodCall<>& method_call, std::unique_ptr<flutter::MethodResult<>> result)
{
	std::string id = Utf8FromUtf16(getDeviceID());
	result->Success(flutter::EncodableValue(id));
}


void FlutterWindow::HandleMethodCall(
	const flutter::MethodCall<>& method_call,
	std::unique_ptr<flutter::MethodResult<>> result) {

	if (method_call.method_name().compare("CopyImage") == 0) {
		this->CopyImage(method_call);
		result->Success();
		return;
	}

	if (method_call.method_name().compare("setNotify") == 0) {
		this->SetNotify(method_call);
		result->Success();
		return;
	}
	
	if (method_call.method_name().compare("setTitle") == 0) {
		this->SetTitle(method_call);
		result->Success();
		return;
	}

	if (method_call.method_name().compare("checkTitle") == 0) {
		this->CheckTitle(method_call, std::move(result));
		return;
	}

	if (method_call.method_name().compare("getDeviceId") == 0) {
		this->GetDeviceId(method_call, std::move(result));
		return;
	}

	result->NotImplemented();
}

typedef struct tagColor {
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;
}Color;

void FlutterWindow::CopyImage(const flutter::MethodCall<>& method_call) {
	const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
	if (!arguments) {
		return;
	}

	int width = 0;
	auto width_it = arguments->find(flutter::EncodableValue("width"));
	if (width_it != arguments->end()) {
		width = std::get<int>(width_it->second);
	}


	int height = 0;
	auto height_it = arguments->find(flutter::EncodableValue("height"));
	if (height_it != arguments->end()) {
		height = std::get<int>(height_it->second);
	}


	std::vector<int32_t> data;
	auto data_it = arguments->find(flutter::EncodableValue("data"));
	if (data_it != arguments->end()) {
		data = std::get<std::vector<int32_t>>(data_it->second);
	}

	auto buffer = ::GlobalAlloc(GMEM_DDESHARE, (SIZE_T)width * height * 4);
	if (nullptr == buffer) {
		return;
	}

    (uint8_t*)::GlobalLock(buffer);
	Color* color = (Color*)buffer;
	for (auto item = data.begin(); item != data.end(); item++) {
		int32_t value = *item;
		color->a = ((Color*)&value)->a;
		color->r = ((Color*)&value)->b;
		color->g = ((Color*)&value)->g;
		color->b = ((Color*)&value)->r;
		color++;
	}
	::GlobalUnlock(buffer);

	BITMAPINFO        pbmi;
	memset(&pbmi, 0, sizeof(BITMAPINFO));
	pbmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	pbmi.bmiHeader.biWidth = width;
	pbmi.bmiHeader.biHeight = -height;
	pbmi.bmiHeader.biPlanes = 1;
	pbmi.bmiHeader.biBitCount = 32;
	pbmi.bmiHeader.biCompression = BI_RGB;
	pbmi.bmiHeader.biSizeImage = width * height * 4;

	HDC hdc = ::GetDC(NULL);
	HBITMAP hbitmap = ::CreateDIBitmap(hdc,&pbmi.bmiHeader,CBM_INIT, buffer,&pbmi,DIB_RGB_COLORS);
	::ReleaseDC(NULL, hdc);


	if (!::OpenClipboard(NULL)) {
		::DeleteObject(hbitmap);
		::GlobalFree(buffer);
		return;
	}

	::EmptyClipboard();
	::SetClipboardData(CF_BITMAP, hbitmap);
	::CloseClipboard();

	::DeleteObject(hbitmap);
	::GlobalFree(buffer);
}



void FlutterWindow::OnDestroy() {
	if (flutter_controller_) {
		flutter_controller_ = nullptr;
	}

	Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
	WPARAM const wparam,
	LPARAM const lparam) noexcept {
	// Give Flutter, including plugins, an opportunity to handle window messages.
	if (flutter_controller_) {
		std::optional<LRESULT> result =
			flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
				lparam);
		if (result) {
			return *result;
		}
	}

	switch (message) {
	case WM_FONTCHANGE:
		flutter_controller_->engine()->ReloadSystemFonts();
		break;
	case WM_ACTIVATE:
		if (nullptr != flutter_channel_.get()) {
			auto value = std::make_unique<flutter::EncodableValue>();
			flutter_channel_->InvokeMethod("onActivate", std::move(value));
		}
		break;
	case WM_MDIMAXIMIZE:
		if (nullptr != flutter_channel_.get()) {
			auto value = std::make_unique<flutter::EncodableValue>();
			flutter_channel_->InvokeMethod("onActivate", std::move(value));
		}
		break;
	}

	return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
