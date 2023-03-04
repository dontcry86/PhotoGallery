import 'package:flutter/material.dart';
import 'package:photo_gallery/app/widgets/base_page.dart';

class LoginPage extends BasePage {
  final String? data;
  const LoginPage({Key? key, this.data}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends BasePageState<LoginPage> {
  @override
  void onViewReady() {
    super.onViewReady();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: 'Login page',
      ),
      body: const SafeArea(child: Text('Login page')),
    );
  }
}
