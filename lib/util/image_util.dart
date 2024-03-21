// import 'dart:io';
//
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
//
//
// class ImageUtil {
//   ImageUtil._();
//
//
//   static Widget assetImage(
//     String res, {
//     double width,
//     double height,
//     BoxFit fit,
//     Color color,
//   }) =>
//       Image.asset(
//         res,
//         width: width,
//         height: height,
//         fit: fit,
//         color: color,
//       );
//
//   static Widget networkImage({
//     String url,
//     double width,
//     double height,
//     int cacheWidth,
//     int cacheHeight,
//     BoxFit fit =BoxFit.cover,
//     bool loadProgress = true,
//     bool clearMemoryCacheWhenDispose = false,
//     bool lowMemory = false,
//     Widget errorWidget,
//     BorderRadius borderRadius,
//     Alignment alignment = Alignment.center,
//   }) =>
//       ExtendedImage.network(
//         url,
//         width: width,
//         height: height,
//         fit: fit,
//         borderRadius: borderRadius,
//         cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
//         cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
//         cache: true,
//         alignment: alignment,
//         clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
//         handleLoadingProgress: true,
//         clearMemoryCacheIfFailed: true,
//         loadStateChanged: (ExtendedImageState state) {
//           switch (state.extendedImageLoadState) {
//             case LoadState.loading:
//               {
//                 final ImageChunkEvent loadingProgress = state.loadingProgress;
//                 final double progress =
//                     loadingProgress?.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes
//                         : null;
//                 // CupertinoActivityIndicator()
//                 return SizedBox(
//                   width: 15.0,
//                   height: 15.0,
//                   child: loadProgress
//                       ? Center(
//                           child: SizedBox(
//                             width: 15.0,
//                             height: 15.0,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 1.5,
//                               value: progress,
//                             ),
//                           ),
//                         )
//                       : null,
//                 );
//               }
//             case LoadState.completed:
//               return null;
//             case LoadState.failed:
//               // remove memory cached
//               state.imageProvider.evict();
//               return errorWidget ??
//                   Image.asset('assets/images/default_head.png',width: width,height: height,fit: BoxFit.fill,);
//           }
//         },
//       );
//
//   static Widget fileImage({
//     File file,
//     double width,
//     double height,
//     int cacheWidth,
//     int cacheHeight,
//     BoxFit fit,
//     bool loadProgress = true,
//     bool clearMemoryCacheWhenDispose = false,
//     bool lowMemory = false,
//     Widget errorWidget,
//     BorderRadius borderRadius,
//   }) =>
//       ExtendedImage.file(
//         file,
//         width: width,
//         height: height,
//         fit: fit,
//         borderRadius: borderRadius,
//         cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
//         cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
//         clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
//         clearMemoryCacheIfFailed: true,
//         loadStateChanged: (ExtendedImageState state) {
//           switch (state.extendedImageLoadState) {
//             case LoadState.loading:
//               {
//                 final ImageChunkEvent loadingProgress = state.loadingProgress;
//                 final double progress =
//                     loadingProgress?.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes
//                         : null;
//                 // CupertinoActivityIndicator()
//                 return SizedBox(
//                   width: 15.0,
//                   height: 15.0,
//                   child: loadProgress
//                       ? Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 1.5,
//                             value: progress,
//                           ),
//                         )
//                       : null,
//                 );
//               }
//             case LoadState.completed:
//               return null;
//             case LoadState.failed:
//               // remove memory cached
//               state.imageProvider.evict();
//               return errorWidget ?? Image.asset('assets/images2/image_no_data.webp');
//           }
//         },
//       );
//
//   static int _calculateCacheWidth(
//     double width,
//     int cacheWidth,
//     bool lowMemory,
//   ) {
//     if (!lowMemory) return null;
//     if (null != cacheWidth) return cacheWidth;
//     final maxW = .6;
//     return (width == null ? maxW : (width < maxW ? width : maxW)).toInt();
//   }
//
//   static int _calculateCacheHeight(
//     double height,
//     int cacheHeight,
//     bool lowMemory,
//   ) {
//     if (!lowMemory) return null;
//     if (null != cacheHeight) return cacheHeight;
//     final maxH = .6;
//     return (height == null ? maxH : (height < maxH ? height : maxH)).toInt();
//   }
// }
