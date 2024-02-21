@REM start /WAIT cmd /C flutter clean

@REM start /WAIT cmd /C flutter pub get

start /WAIT cmd /C flutter build apk --release lib/main.dart

java -jar .\RePluginAsm-1.0-SNAPSHOT.jar ^
-z "C:\Users\Administrator\AppData\Local\Android\Sdk\build-tools\33.0.0\zipalign.exe" ^
-g "C:\Users\Administrator\AppData\Local\Android\Sdk\build-tools\33.0.0\apksigner.bat" ^
-i "F:\project\a_bao\zhaoping_abao\ima2_HabeesJobs\build\app\outputs\flutter-apk\app-release.apk" ^
-o "F:\project\a_bao\zhaoping_abao\ima2_HabeesJobs\bin\habeesjob.apk" ^
-k "F:\project\a_bao\zhaoping_abao\ima2_HabeesJobs\android\key\keys.jks" ^
-s "bs9dqec6E8Z6" ^
-a "habeesjoba" ^
-p "bs9dqec6E8Z6"

@REM ./build_test.bat