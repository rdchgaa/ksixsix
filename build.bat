start /WAIT cmd /C flutter clean

start /WAIT cmd /C flutter pub get

start /WAIT cmd /C dart run windows/update_version.dart

start /WAIT cmd /C flutter build windows --release lib/profile.dart
start /WAIT cmd /C flutter build apk --release lib/profile.dart

copy  ".\sqlite3.dll" ".\build\windows\runner\Release\sqlite3.dll"


