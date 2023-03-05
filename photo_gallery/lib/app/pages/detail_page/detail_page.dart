import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/app/widgets/base_page.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/domain/entities/photos_with_selected_index.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DetailPage extends BasePage {
  final PhotosWithSelectedIndex? data;
  const DetailPage({Key? key, this.data}) : super(key: key);

  @override
  BasePageState<DetailPage> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends BasePageState<DetailPage> {
  String title = 'Photo Detail';

  @override
  void onViewReady() {
    final selectedIndex = widget.data?.selectedIndex ?? 0;
    final photos = widget.data?.photos ?? [];
    if (selectedIndex < photos.length) {
      setState(() {
        title = 'Photo title: ${photos[selectedIndex].title ?? ''}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        appBarColor: Colors.white10,
        title: title,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GalleryPhotoViewWrapper(
      galleryItems: widget.data?.photos ?? [],
      backgroundDecoration: const BoxDecoration(
        color: Colors.white,
      ),
      initialIndex: widget.data?.selectedIndex ?? 0,
      scrollDirection: Axis.horizontal,
      updateTitleCallback: (value) {
        setState(() {
          title = value;
        });
      },
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
    this.updateTitleCallback,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Photo> galleryItems;
  final Axis scrollDirection;
  final Function(String)? updateTitleCallback;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      final title = widget.galleryItems[currentIndex].title ?? '';
      widget.updateTitleCallback?.call(title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Photo index: ${currentIndex + 1}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Photo item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.url ?? ''),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 2,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id ?? 0),
    );
  }
}
