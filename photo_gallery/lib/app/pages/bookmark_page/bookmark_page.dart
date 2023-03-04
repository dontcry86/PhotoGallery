import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_gallery/app/bloc/bloc.dart';
import 'package:photo_gallery/app/widgets/base_page.dart';
import 'package:photo_gallery/app/widgets/image_view.dart';
import 'package:photo_gallery/common/cache_handler.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/di.dart';

class BookmarkPage extends BasePage {
  final String? data;
  const BookmarkPage({Key? key, this.data}) : super(key: key);

  @override
  _BookmarkPageState createState() {
    return _BookmarkPageState();
  }
}

class _BookmarkPageState extends BasePageState<BookmarkPage> {
  PhotoBloc _bloc = getIt.get();

  @override
  void onViewReady() {
    super.onViewReady();
    _bloc.getPhotos();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: 'Bookmark',
        showLeading: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
              final data = state.result ?? [];
              if (data.isEmpty) {
                return _buildNoContentPage();
              } else {
                return _buildMainPage(context, photos: data);
              }
            }

            return _buildSkeletonPage();
          },
        ));
  }

  Widget _buildMainPage(BuildContext context, {required List<Photo> photos}) {
    final markedPhotos = CacheHandler().markedPhotos;

    return Scaffold(
      body: Center(
        child: GridView.builder(
          itemCount: markedPhotos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            final photo = markedPhotos[index];
            return Card(
              child: _buildItemWidget(photo, onTap: () {}),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemWidget(Photo photo, {VoidCallback? onTap}) {
    return Stack(
      children: [
        ImageView(url: photo.thumbnailUrl ?? ''),
        InkWell(
          onTap: onTap,
          child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 27,
                height: 27,
                color: Colors.white30,
                child: const Icon(Icons.bookmark, color: Colors.red),
              )),
        ),
      ],
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
        () {},
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
        () {},
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
