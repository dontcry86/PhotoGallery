import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EmptyStateView extends StatefulWidget {
  final String? _image, _title, _btnTitle, _message;
  final VoidCallback _onBtnPressed;
  final bool _showImage, _showButton;
  final double? btnWidth;
  final int? _messageMaxLine;

  const EmptyStateView._(
      this._image,
      this._title,
      this._btnTitle,
      this._message,
      this._onBtnPressed,
      this._showImage,
      this._showButton,
      this.btnWidth,
      this._messageMaxLine);

  factory EmptyStateView(
          {String? image,
          String? title,
          String? btnTitle,
          String? message,
          VoidCallback? onBtnPressed,
          bool? showImage,
          bool? showButton,
          double? btnWidth,
          int? messageMaxLine = 3}) =>
      EmptyStateView._(
          image ?? '',
          title ?? '',
          btnTitle ?? '',
          message ?? '',
          onBtnPressed ?? () {},
          showImage ?? true,
          showButton ?? true,
          btnWidth,
          messageMaxLine);

  @override
  _EmptyStateViewState createState() => _EmptyStateViewState();
}

class _EmptyStateViewState extends State<EmptyStateView> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_image, _title, _message, _button],
        ),
      );

  Widget get _image => widget._showImage
      ? Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: CachedNetworkImage(
            width: 192,
            height: 192,
            imageUrl: widget._image ?? '',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        )
      : const SizedBox();

  Widget get _title => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Text(
          widget._title ?? '',
          style: const TextStyle(fontSize: 20).apply(color: Colors.black),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );

  Widget get _message => Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Text(
          widget._message ?? '',
          style: const TextStyle(fontSize: 20).apply(color: Colors.black),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: widget._messageMaxLine,
        ),
      );

  Widget get _button => widget._showButton
      ? TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: widget._onBtnPressed,
          child: Text(widget._btnTitle ?? ''),
        )
      : const SizedBox();
}
