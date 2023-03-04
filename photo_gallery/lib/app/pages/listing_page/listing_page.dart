import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/app/bloc/bloc.dart';
import 'package:photo_gallery/app/widgets/base_page.dart';
import 'package:photo_gallery/app/widgets/image_view.dart';
import 'package:photo_gallery/common/cache_handler.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/di.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_gallery/domain/entities/photos_with_selected_index.dart';
import 'package:photo_gallery/router.dart';

class ListingPage extends BasePage {
  final Function(bool) isHideBottomNavBar;
  const ListingPage({Key? key, required this.isHideBottomNavBar})
      : super(key: key);

  @override
  _ListingPageState createState() {
    return _ListingPageState();
  }
}

class _ListingPageState extends BasePageState<ListingPage>
    with AutomaticKeepAliveClientMixin<ListingPage> {
  PhotoBloc _bloc = getIt.get();

  bool isFirstTimeFetching = false;
  bool isBookmarkMode = false;

  @override
  void onViewReady() {
    super.onViewReady();
    if (!isFirstTimeFetching) {
      isFirstTimeFetching = !isFirstTimeFetching;
      _refresh();
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _refresh() {
    _bloc.getPhotos();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            widget.isHideBottomNavBar(true);
            break;
          case ScrollDirection.reverse:
            widget.isHideBottomNavBar(false);
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: 'Photos',
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

  void _bookmarkOnTapped() {
    setState(() {
      isBookmarkMode = !isBookmarkMode;
    });
  }

  Widget _buildBody() {
    if (isBookmarkMode) {
      final markedPhotos = CacheHandler().markedPhotos;
      if (markedPhotos.isEmpty) {
        return _buildNoContentPage();
      } else {
        return _buildMainPage(context, photos: markedPhotos);
      }
    } else {
      return BlocListener<PhotoBloc, BaseState>(
        bloc: _bloc,
        listener: (BuildContext context, BaseState state) {
          if (state is BaseErrorState) {
            // popup a toast.
            toast(state.errorMessage ?? '');
          }
        },
        child: BlocBuilder<PhotoBloc, BaseState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is BaseErrorState) {
              return _buildErrorPage();
            } else if (state is PhotoSuccessState) {
              final photos = state.result ?? [];
              if (photos.isEmpty) {
                return _buildNoContentPage();
              } else {
                _checkCacheAndMerge(photos);
                return _buildMainPage(context, photos: photos);
              }
            }

            return _buildSkeletonPage();
          },
        ),
      );
    }
  }

  void _checkCacheAndMerge(List<Photo> photos) {
    final markedPhotos = CacheHandler().markedPhotos;
    for (final markedItem in markedPhotos) {
      for (final photo in photos) {
        if (markedItem.id == photo.id) {
          photo.isBookmark = true;
          break;
        }
      }
    }
  }

  Widget _buildMainPage(BuildContext context, {required List<Photo> photos}) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: GridView.builder(
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
              onTapBookmark: () {
                final isBookmark = photo.isBookmark ?? false;

                if (isBookmark) {
                  CacheHandler().bookmarkPhoto(photo);
                } else {
                  CacheHandler().unBookmarkPhoto(photo);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoContentPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: '',
      ),
      body: buildNoContentWidget(() {}),
    );
  }

  Widget _buildSkeletonPage() {
    //double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: '',
      ),
      body: Text('Loading'),
    );
  }

  Widget _buildErrorPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: '',
      ),
      body: buildErrorWidget(
        () {
          _refresh();
        },
      ),
    );
  }

  Widget _buildNoInternetPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: '',
      ),
      body: buildNoInternetWidget(
        () {
          _refresh();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CardPhotoWidget extends StatefulWidget {
  final Photo photo;
  final VoidCallback? onTap;
  final VoidCallback? onTapBookmark;

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
            ImageView(url: widget.photo.thumbnailUrl ?? ''),
            InkWell(
              onTap: () {
                setState(() {
                  widget.photo.isBookmark = !(widget.photo.isBookmark ?? false);
                });
                widget.onTapBookmark;
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
