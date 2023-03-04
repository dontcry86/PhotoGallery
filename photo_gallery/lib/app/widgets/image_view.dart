import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class ImageView extends StatelessWidget {
  final String url;
  final Color? color;
  final double? width, height, borderRadius;
  final BoxFit fit;
  final BaseCacheManager? cacheManager;
  final Widget? placeHolder;
  final Widget? errorWidget;
  final VoidCallback? errorCallback;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final Duration? placeholderFadeInDuration;
  final Alignment? alignment;

  /// Support JPEG, PNG, GIF, Animated GIF, WebP, Animated WebP, BMP, SVG
  /// and WBMP
  /// You can use link to asset in app or url link
  ///
  /// ex:
  ///
  /// assets/images/ic_24system_info_ink1.png
  ///
  /// assets/images/ic_24system_info_ink1.svg
  ///
  ///  https://vietnambusinessinsider.vn/wp-content/uploads/2020/10/TCBC1.jpg
  ///
  /// [fadeInDuration] [fadeOutDuration] [placeholderFadeInDuration] use for
  /// CacheImageNetwork when url is http image url
  const ImageView({
    super.key,
    this.url = '',
    this.color,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.cacheManager,
    this.placeHolder,
    this.errorWidget,
    this.errorCallback,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.placeholderFadeInDuration,
    this.alignment,
  });

  Widget _placeHolder() => LayoutBuilder(
        builder: (context, constraint) => const Text('loading'),
      );

  Widget _errorWidget() => LayoutBuilder(
        builder: (context, constraint) => Container(
          height: double.infinity,
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                '',
                width: _resolvePlaceholerImageSize(
                    constraint.maxWidth, constraint.maxHeight),
                height: _resolvePlaceholerImageSize(
                    constraint.maxWidth, constraint.maxHeight),
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget item;

    if (url.isEmpty) {
      voidErrorCallback();
      item = errorWidget ?? _errorWidget();
    } else if (url.contains('.svg')) {
      item = SvgCaching(
        path: url,
        fit: fit,
        placeHolder: placeHolder ?? _placeHolder(),
        errorWidget: errorWidget ?? _errorWidget(),
        color: color,
        errorCallback: errorCallback,
      );
    } else if (url.contains('.json')) {
      item = Lottie.network(url,
          fit: fit, alignment: alignment ?? Alignment.center);
    } else {
      final isValidLink = Uri.parse(url).isAbsolute;
      item = isValidLink
          ? CachedNetworkImage(
              color: color,
              imageUrl: url,
              fit: fit,
              cacheManager: cacheManager,
              placeholder: (context, url) => placeHolder ?? _placeHolder(),
              errorWidget: (context, url, error) {
                voidErrorCallback();
                return errorWidget ?? _errorWidget();
              },
              fadeInDuration:
                  fadeInDuration ?? const Duration(milliseconds: 500),
              fadeOutDuration:
                  fadeOutDuration ?? const Duration(milliseconds: 1000),
              placeholderFadeInDuration: placeholderFadeInDuration,
              alignment: alignment ?? Alignment.center,
            )
          : FutureBuilder<bool>(
              future: isAssetExists(url),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  voidErrorCallback();
                  return errorWidget ?? _errorWidget();
                }
                if (snapshot.hasData == false) {
                  return placeHolder ?? _placeHolder();
                }
                final assetExists = snapshot.data;
                if (assetExists == false) {
                  voidErrorCallback();
                  return errorWidget ?? _errorWidget();
                }

                return Image.asset(url,
                    color: color,
                    fit: fit,
                    alignment: alignment ?? Alignment.center,
                    errorBuilder: (_, __, ___) {
                  voidErrorCallback();
                  return _errorWidget();
                });
              });
    }

    item = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: item,
    );

    if (width != null && height != null) {
      return SizedBox(
        height: height!,
        width: width!,
        child: item,
      );
    }
    return item;
  }

  void voidErrorCallback() {
    if (errorCallback != null) {
      errorCallback!();
    }
  }

  double _resolvePlaceholerImageSize(double width, double height) {
    final double minSize = height > width ? width : height;

    if (minSize > 40 && minSize <= 64) {
      return 40;
    }
    if (minSize > 64 && minSize <= 80) {
      return 64;
    }
    if (minSize > 80) {
      return 80;
    }
    return 16;
  }
}

Future<bool> isAssetExists(String path) async {
  try {
    await rootBundle.load(path);
    return true;
  } catch (_) {
    return false;
  }
}

class SvgCaching extends StatelessWidget {
  final String path;
  final Color? color;
  final Widget? placeHolder;
  final Widget? errorWidget;
  final BoxFit fit;
  final VoidCallback? errorCallback;
  final AlignmentGeometry? alignment;
  const SvgCaching(
      {required this.path,
      Key? key,
      this.color,
      this.placeHolder,
      this.errorWidget,
      this.fit = BoxFit.contain,
      this.alignment,
      this.errorCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Uri.parse(path).isAbsolute
      ? FutureBuilder(
          future: _loadFileSvg(path),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              voidErrorCallback();
              return errorWidget ?? const SizedBox();
            }
            if (snapshot.data == null) {
              return placeHolder ?? const SizedBox();
            }
            _checkAvailableFile(snapshot.data as File, context);
            final file = SvgPicture.file(
              snapshot.data as File,
              fit: fit,
            );
            return file;
          })
      : FutureBuilder<bool>(
          future: isAssetExists(path),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              voidErrorCallback();
              return errorWidget ?? const SizedBox();
            }
            if (snapshot.hasData == false) {
              return placeHolder ?? const SizedBox();
            }
            final assetExists = snapshot.data;
            if (assetExists == false) {
              voidErrorCallback();
              return errorWidget ?? const SizedBox();
            }
            return SvgPicture.asset(
              path,
              fit: fit,
              alignment: alignment ?? Alignment.center,
              placeholderBuilder: (_) => placeHolder ?? const SizedBox(),
            );
          });

  void voidErrorCallback() {
    if (errorCallback != null) {
      errorCallback!();
    }
  }

  // this function is work-around because
  // lib svg dont use PictureErrorListener for handling error cases
  void _checkAvailableFile(File file, BuildContext context) {
    // final PictureProvider pictureProvider =
    //     FilePicture(SvgPicture.svgByteDecoderBuilder, file);
    // if (pictureProvider != null) {
    //   pictureProvider.resolve(
    //     createLocalPictureConfiguration(context),
    //     onError: (exception, stackTrace) {
    //       voidErrorCallback();
    //     },
    //   );
    // }
  }

  Future<File> _loadFileSvg(String path) =>
      DefaultCacheManager().getSingleFile(path);
}
