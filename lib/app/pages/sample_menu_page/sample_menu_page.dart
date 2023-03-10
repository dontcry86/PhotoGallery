import 'package:flutter/material.dart';
import 'package:photo_gallery/router.dart';

class SampleMenuPage extends StatefulWidget {
  const SampleMenuPage({super.key});

  @override
  State<SampleMenuPage> createState() {
    return _SampleMenuPageState();
  }
}

class _SampleMenuPageState extends State<SampleMenuPage> {
  List<String> listMenu = [
    RoutePaths.listing,
    RoutePaths.detail,
    '/photo_gallery/test_wrong_route',
  ];

  Widget _getItemGrid(String name, VoidCallback? onTap) {
    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          name,
          style: const TextStyle(fontSize: 16).apply(color: Colors.black),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample menu', style: TextStyle(fontSize: 18)),
      ),
      body: GridView.builder(
        itemCount: listMenu.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: _getItemGrid(listMenu[index], () async {
            switch (listMenu[index]) {
              case RoutePaths.detail:
                Navigator.pushNamed(context, RoutePaths.detail,
                    arguments: null);
                break;
              default:
                Navigator.pushNamed(
                  context,
                  listMenu[index],
                );
                break;
            }
          }));
        },
      ),
    );
  }
}
