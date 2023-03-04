import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_gallery/app/widgets/empty_state_wiew.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BasePageState();
  }
}

class BasePageState<T extends BasePage> extends State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onViewReady();
    });
  }

  void onViewReady() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(''),
    );
  }

  Widget _buildLeading(
      {bool isCloseIcon = false,
      Color? color = Colors.black,
      VoidCallback? onPressed}) {
    Icon icon;
    if (isCloseIcon) {
      icon = Icon(Icons.close, color: color);
    } else {
      icon = Icon(Icons.arrow_back_ios_new_rounded, color: color);
    }

    return IconButton(
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
      icon: icon,
    );
  }

  PreferredSizeWidget buildAppBar({
    SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle.dark,
    Color appBarColor = Colors.white,
    bool isLeadingCloseIcon = false,
    Color leadingColor = Colors.black,
    bool showElevation = false,
    bool showLeading = true,
    String? title,
    Color titleColor = Colors.black,
    VoidCallback? backOnPressed,
    List<Widget> actions = const [],
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      systemOverlayStyle: systemOverlayStyle,
      backgroundColor: appBarColor,
      elevation: showElevation ? 1.0 : 0.0,
      centerTitle:
          (Theme.of(context).platform) == TargetPlatform.iOS ? true : false,
      title: Text(title ?? '',
          style: const TextStyle(fontSize: 20).apply(color: titleColor)),
      leading: showLeading
          ? _buildLeading(
              isCloseIcon: isLeadingCloseIcon,
              color: leadingColor,
              onPressed: backOnPressed)
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  Widget buildErrorWidget(VoidCallback? ctaOnTap) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyStateView(
            title: 'SOMETHING WENT WRONG!',
            message: 'Please try again later.',
            btnTitle: 'Retry',
            btnWidth: 248.0,
            showImage: false,
            onBtnPressed: ctaOnTap,
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget buildNoInternetWidget(VoidCallback ctaOnTap) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyStateView(
            title: 'NO INTERNET CONNNECTION!',
            message:
                'Please check the signal of your Wifi or 3G/LTE connection.',
            btnTitle: 'Retry',
            btnWidth: 248.0,
            showImage: false,
            onBtnPressed: ctaOnTap,
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget buildNoContentWidget(VoidCallback? ctaOnTap) {
    return SafeArea(
      child: EmptyStateView(
        title: 'EMPTY!',
        message: 'You have no photo.',
        showImage: false,
        showButton: false,
        onBtnPressed: () {
          if (ctaOnTap != null) {
            ctaOnTap();
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
