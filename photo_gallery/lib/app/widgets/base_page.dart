import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_gallery/app/widgets/empty_state_wiew.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
      icon = Icon(Icons.arrow_back, color: color);
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
            title: 'Hệ thống có chút vấn đề nhỏ',
            image: '',
            message: 'Bạn vui lòng thử lại sau',
            btnTitle: 'Thử lại',
            btnWidth: 248.0,
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
            title: 'Không có kết nối mạng',
            image: '',
            message: 'Vui lòng kiểm tra lại tín hiệu Wifi hoặc 3G/4G bạn nhé',
            btnTitle: 'Thử lại',
            btnWidth: 248.0,
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
        title: 'Không tìm thấy nội dung',
        image: '',
        message: 'Nội dung này không tồn tại',
        btnTitle: 'Thử lại',
        btnWidth: 248.0,
        onBtnPressed: () {
          if (ctaOnTap != null) {
            ctaOnTap();
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void showToast({String? message, required bool isSuccess}) {
    if (isSuccess) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message:
              'This is an example error message that will be shown in the body of snackbar!',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message:
              'This is an example error message that will be shown in the body of snackbar!',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}
