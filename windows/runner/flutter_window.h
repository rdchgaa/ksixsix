#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/ephemeral/cpp_client_wrapper/include/flutter/method_channel.h>

#include <memory>

#include "win32_window.h"

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void HandleMethodCall(const flutter::MethodCall<>& method_call, std::unique_ptr<flutter::MethodResult<>> result);
  void CopyImage(const flutter::MethodCall<>& method_call);
  void SetNotify(const flutter::MethodCall<>& method_call);
  void SetTitle(const flutter::MethodCall<>& method_call);
  void CheckTitle(const flutter::MethodCall<>& method_call, std::unique_ptr<flutter::MethodResult<>> result);
  void GetDeviceId(const flutter::MethodCall<>& method_call, std::unique_ptr<flutter::MethodResult<>> result);
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;

  std::unique_ptr<flutter::MethodChannel<>> flutter_channel_;

};

#endif  // RUNNER_FLUTTER_WINDOW_H_