import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/app/bloc/bloc.dart';
import 'package:photo_gallery/app/widgets/base_page.dart';
import 'package:photo_gallery/app/utils/cache_handler.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/di.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_gallery/domain/entities/photos_with_selected_index.dart';
import 'package:photo_gallery/router.dart';

class ListingPage extends BasePage {
  const ListingPage({Key? key}) : super(key: key);

  @override
  BasePageState<ListingPage> createState() {
    return _ListingPageState();
  }
}

class _ListingPageState extends BasePageState<ListingPage>
    with AutomaticKeepAliveClientMixin<ListingPage> {
  final PhotoBloc _bloc = getIt.get();
  bool isBookmarkMode = false;

  @override
  void onViewReady() {
    CacheHandler().getCaches();
    _refresh();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (!isBookmarkMode) {
      _bloc.getPhotosFromAPI();
    }
  }

  void _bookmarkOnTapped() {
    setState(() {
      isBookmarkMode = !isBookmarkMode;
      if (isBookmarkMode) {
        _bloc.switchToBookmarkView();
      } else {
        _bloc.switchBackPhotoGalleryView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: isBookmarkMode ? 'Bookmark' : 'Photos',
        showLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmarks,
                color: isBookmarkMode ? Colors.blue : Colors.black26),
            onPressed: _bookmarkOnTapped,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocListener<PhotoBloc, BaseState>(
      bloc: _bloc,
      listener: (BuildContext context, BaseState state) {
        if (state is BaseErrorState) {
          // show a notification at bottom of screen.
          showSimpleNotification(const Text('Fetching failed!'),
              background: Colors.redAccent,
              position: NotificationPosition.bottom);
        } else if (state is FetchingPhotoSuccessState) {
          // showSimpleNotification(const Text('Fetching successfully!'),
          //     background: Colors.green, position: NotificationPosition.bottom);
        }
      },
      child: BlocBuilder<PhotoBloc, BaseState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is BaseErrorState) {
            return buildErrorWidget(() {
              _refresh();
            });
          } else if (state is FetchingPhotoSuccessState) {
            final photos = state.result ?? [];
            if (photos.isEmpty) {
              return buildNoContentWidget(() {
                _refresh();
              });
            } else {
              return _buildMainWidget(context, photos: photos);
            }
          } else if (state is FetchingBookmarkSuccessState) {
            final photos = state.result ?? [];
            if (photos.isEmpty) {
              return buildNoContentWidget(() {
                _refresh();
              });
            } else {
              return _buildMainWidget(context, photos: photos);
            }
          }

          return _buildSkeletonWidget();
        },
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context, {required List<Photo> photos}) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: GridView.builder(
          itemCount: photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            final photo = photos[index];
            return CardPhotoWidget(
              photo,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.detail,
                  arguments: PhotosWithSelectedIndex(
                      photos: photos, selectedIndex: index),
                );
              },
              onTapBookmark: (newBookmarkStatus) {
                if (newBookmarkStatus) {
                  _bloc.bookmarkAPhoto(photo);
                } else {
                  _bloc.unBookmarkAPhoto(photo, isBookmarkMode);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonWidget() {
    return const Center(child: Text('Loading...'));
  }

  @override
  bool get wantKeepAlive => true;
}

class CardPhotoWidget extends StatefulWidget {
  final Photo photo;
  final VoidCallback? onTap;
  final Function(bool isBookmark)? onTapBookmark;

  const CardPhotoWidget(
    this.photo, {
    super.key,
    this.onTap,
    this.onTapBookmark,
  });

  @override
  State<StatefulWidget> createState() => _CardPhotoWidgetState();
}

class _CardPhotoWidgetState extends State<CardPhotoWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            CachedNetworkImage(
              imageUrl: widget.photo.thumbnailUrl ?? '',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  final currentBookmarkStatus =
                      widget.photo.isBookmark ?? false;
                  final newBookmarkStatus = !currentBookmarkStatus;
                  widget.onTapBookmark?.call(newBookmarkStatus);
                });
              },
              child: Container(
                width: 27,
                height: 27,
                color: Colors.white30,
                child: Icon(Icons.bookmark,
                    color: ((widget.photo.isBookmark ?? false) == false)
                        ? Colors.black12
                        : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
