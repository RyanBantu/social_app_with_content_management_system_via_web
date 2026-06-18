import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders a bundled asset path or remote Firebase Storage URL.
class ContentImage extends StatelessWidget {
  final String src;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const ContentImage({
    super.key,
    required this.src,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.semanticLabel,
    this.errorBuilder,
  });

  bool get _isRemote =>
      src.startsWith('http://') || src.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isRemote) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: fit,
        width: width,
        height: height,
        errorWidget: (ctx, _, err) =>
            errorBuilder?.call(ctx, err, StackTrace.current) ??
            const Icon(Icons.broken_image),
      );
    }

    return Image.asset(
      src,
      fit: fit,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
      errorBuilder: errorBuilder,
    );
  }
}
