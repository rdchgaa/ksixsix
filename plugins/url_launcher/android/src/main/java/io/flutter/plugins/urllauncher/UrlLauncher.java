// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.urllauncher;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Browser;
import android.text.TextUtils;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import java.io.File;
import java.util.HashMap;
import java.util.Locale;

/** Launches components for URLs. */
class UrlLauncher {
  private static final HashMap<String, String> mapSimple = new HashMap<>();

  private final Context applicationContext;
  @Nullable private Activity activity;

  /**
   * Uses the given {@code applicationContext} for launching intents.
   *
   * <p>It may be null initially, but should be set before calling {@link #launch}.
   */
  UrlLauncher(Context applicationContext, @Nullable Activity activity) {
    this.applicationContext = applicationContext;
    this.activity = activity;
    mapSimple.put(".apk", "application/vnd.android.package-archive");
    mapSimple.put(".asf", "video/x-ms-asf");
    mapSimple.put(".avi", "video/x-msvideo");
    mapSimple.put(".bin", "application/octet-stream");
    mapSimple.put(".bmp", "image/bmp");
    mapSimple.put(".c", "text/plain");
    mapSimple.put(".chm", "application/x-chm");
    mapSimple.put(".class", "application/octet-stream");
    mapSimple.put(".conf", "text/plain");
    mapSimple.put(".cpp", "text/plain");
    mapSimple.put(".doc", "application/msword");
    mapSimple.put(".docx", "application/msword");
    mapSimple.put(".exe", "application/octet-stream");
    mapSimple.put(".gif", "image/gif");
    mapSimple.put(".gtar", "application/x-gtar");
    mapSimple.put(".gz", "application/x-gzip");
    mapSimple.put(".h", "text/plain");
    mapSimple.put(".htm", "text/html");
    mapSimple.put(".html", "text/html");
    mapSimple.put(".jar", "application/java-archive");
    mapSimple.put(".java", "text/plain");
    mapSimple.put(".jpeg", "image/jpeg");
    mapSimple.put(".jpg", "image/jpeg");
    mapSimple.put(".js", "application/x-javascript");
    mapSimple.put(".log", "text/plain");
    mapSimple.put(".m3u", "audio/x-mpegurl");
    mapSimple.put(".m4a", "audio/mp4a-latm");
    mapSimple.put(".m4b", "audio/mp4a-latm");
    mapSimple.put(".m4p", "audio/mp4a-latm");
    mapSimple.put(".m4u", "video/vnd.mpegurl");
    mapSimple.put(".m4v", "video/x-m4v");
    mapSimple.put(".mov", "video/quicktime");
    mapSimple.put(".mp2", "audio/x-mpeg");
    mapSimple.put(".mp3", "audio/x-mpeg");
    mapSimple.put(".mp4", "video/mp4");
    mapSimple.put(".mpc", "application/vnd.mpohun.certificate");
    mapSimple.put(".mpe", "video/mpeg");
    mapSimple.put(".mpeg", "video/mpeg");
    mapSimple.put(".mpg", "video/mpeg");
    mapSimple.put(".mpg4", "video/mp4");
    mapSimple.put(".mpga", "audio/mpeg");
    mapSimple.put(".msg", "application/vnd.ms-outlook");
    mapSimple.put(".ogg", "audio/ogg");
    mapSimple.put(".pdf", "application/pdf");
    mapSimple.put(".png", "image/png");
    mapSimple.put(".pps", "application/vnd.ms-powerpoint");
    mapSimple.put(".ppt", "application/vnd.ms-powerpoint");
    mapSimple.put(".pptx", "application/vnd.ms-powerpoint");
    mapSimple.put(".prop", "text/plain");
    mapSimple.put(".rar", "application/x-rar-compressed");
    mapSimple.put(".rc", "text/plain");
    mapSimple.put(".rmvb", "audio/x-pn-realaudio");
    mapSimple.put(".rtf", "application/rtf");
    mapSimple.put(".sh", "text/plain");
    mapSimple.put(".tar", "application/x-tar");
    mapSimple.put(".tgz", "application/x-compressed");
    mapSimple.put(".txt", "text/plain");
    mapSimple.put(".wav", "audio/x-wav");
    mapSimple.put(".wma", "audio/x-ms-wma");
    mapSimple.put(".wmv", "audio/x-ms-wmv");
    mapSimple.put(".wps", "application/vnd.ms-works");
    mapSimple.put(".xml", "text/plain");
    mapSimple.put(".xls", "application/vnd.ms-excel");
    mapSimple.put(".xlsx", "application/vnd.ms-excel");
    mapSimple.put(".z", "application/x-compress");
    mapSimple.put(".zip", "application/zip");
    mapSimple.put("", "*/*");
  }

  void setActivity(@Nullable Activity activity) {
    this.activity = activity;
  }

  /** Returns whether the given {@code url} resolves into an existing component. */
  boolean canLaunch(String url) {
    Intent launchIntent = new Intent(Intent.ACTION_VIEW);
    launchIntent.setData(Uri.parse(url));
    ComponentName componentName =
        launchIntent.resolveActivity(applicationContext.getPackageManager());

    return componentName != null
        && !"{com.android.fallback/com.android.fallback.Fallback}"
            .equals(componentName.toShortString());
  }

  /**
   * Attempts to launch the given {@code url}.
   *
   * @param headersBundle forwarded to the intent as {@code Browser.EXTRA_HEADERS}.
   * @param useWebView when true, the URL is launched inside of {@link WebViewActivity}.
   * @param enableJavaScript Only used if {@param useWebView} is true. Enables JS in the WebView.
   * @param enableDomStorage Only used if {@param useWebView} is true. Enables DOM storage in the
   * @return {@link LaunchStatus#NO_ACTIVITY} if there's no available {@code applicationContext}.
   *     {@link LaunchStatus#ACTIVITY_NOT_FOUND} if there's no activity found to handle {@code
   *     launchIntent}. {@link LaunchStatus#OK} otherwise.
   */
  LaunchStatus launch(
      String url,
      Bundle headersBundle,
      boolean useWebView,
      boolean enableJavaScript,
      boolean enableDomStorage) {
    if (activity == null) {
      return LaunchStatus.NO_ACTIVITY;
    }

    if(!url.startsWith("http")){
      return openFile(new File(url));
    }

    Intent launchIntent;
    if (useWebView) {
      launchIntent =
          WebViewActivity.createIntent(
              activity, url, enableJavaScript, enableDomStorage, headersBundle);
    } else {
      launchIntent =
          new Intent(Intent.ACTION_VIEW)
              .setData(Uri.parse(url))
              .putExtra(Browser.EXTRA_HEADERS, headersBundle);
    }

    try {
      activity.startActivity(launchIntent);
    } catch (ActivityNotFoundException e) {
      return LaunchStatus.ACTIVITY_NOT_FOUND;
    }

    return LaunchStatus.OK;
  }

  private LaunchStatus openFile(File file) {
    Intent intent = new Intent(Intent.ACTION_VIEW);
    //intent.addCategory(Intent.CATEGORY_DEFAULT);
    Uri uriForFile;
    if (Build.VERSION.SDK_INT > 23){
      //Android 7.0之后
      uriForFile = FileProvider.getUriForFile(activity, applicationContext.getPackageName() + ".flutter.url_launcher_file_provider", file);
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);//给目标文件临时授权
    }else {
      uriForFile = Uri.fromFile(file);
    }
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);//系统会检查当前所有已创建的Task中是否有该要启动的Activity的Task;
    // 若有，则在该Task上创建Activity；若没有则新建具有该Activity属性的Task，并在该新建的Task上创建Activity。
    intent.setDataAndType(uriForFile, getMimeTypeFromFile(file));
    activity.startActivity(intent);

    return LaunchStatus.OK;
  }
  /**
   * 使用自定义方法获得文件的MIME类型
   */
  private static String getMimeTypeFromFile(File file) {
    String type = "*/*";
    String fName = file.getName();
    int dotIndex = fName.lastIndexOf(".");
    if (dotIndex > 0) {
      String end = fName.substring(dotIndex).toLowerCase(Locale.getDefault());

      if (!TextUtils.isEmpty(end) && mapSimple.keySet().contains(end)) {
        type = mapSimple.get(end);
      }
    }
    return type;
  }

  /** Closes any activities started with {@link #launch} {@code useWebView=true}. */
  void closeWebView() {
    applicationContext.sendBroadcast(new Intent(WebViewActivity.ACTION_CLOSE));
  }

  /** Result of a {@link #launch} call. */
  enum LaunchStatus {
    /** The intent was well formed. */
    OK,
    /** No activity was found to launch. */
    NO_ACTIVITY,
    /** No Activity found that can handle given intent. */
    ACTIVITY_NOT_FOUND,
  }
}
