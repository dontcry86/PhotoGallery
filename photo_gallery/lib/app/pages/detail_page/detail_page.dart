import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  @override
  void onViewReady() {
    super.onViewReady();
    1;
  }

  @override
  void dispose() {
    super.dispose();
    1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: 'Detail page',
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
    );

    // return Container(
    //     child: PhotoViewGallery.builder(
    //   scrollPhysics: const BouncingScrollPhysics(),
    //   builder: (BuildContext context, int index) {
    //     final imageUrl = widget.photos[index].url ?? '';
    //     final imageId = widget.photos[index].id ?? 0;

    //     return PhotoViewGalleryPageOptions(
    //       imageProvider: NetworkImage(imageUrl),
    //       initialScale: PhotoViewComputedScale.contained * 0.8,
    //       heroAttributes: PhotoViewHeroAttributes(tag: imageId),
    //     );
    //   },
    //   itemCount: widget.photos.length,
    //   loadingBuilder: (context, event) => Center(
    //     child: Container(
    //       width: 20.0,
    //       height: 20.0,
    //       child: CircularProgressIndicator(
    //         value: event == null
    //             ? 0
    //             : event.cumulativeBytesLoaded / event.expectedTotalBytes,
    //       ),
    //     ),
    //   ),
    //   backgroundDecoration: widget.backgroundDecoration,
    //   pageController: widget.pageController,
    //   onPageChanged: onPageChanged,
    // ));
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Photo> galleryItems;
  final Axis scrollDirection;

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
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image index: ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
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
    return true
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: CachedNetworkImage(
                imageUrl: item.url ?? '',
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id ?? 0),
          )
        : PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(item.url ?? ''),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id ?? 0),
          );
  }
}
