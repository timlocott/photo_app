import 'package:flutter/material.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PhotoApp());
}

class PhotoApp extends StatelessWidget {
  const PhotoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 24, 61, 33)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Liz Cottrell Photography'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var showNavRail = false;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        // page = _buildGallery();
        page = const GalleryPage();
        break;
      case 2:
        page = const FavoritesPage();
        break;
      case 3:
        () async {
          String email = Uri.encodeComponent("timlocott@hotmail.com");
          String subject = Uri.encodeComponent("Help Request");
          String body = Uri.encodeComponent("Hi Liz! I need help with...");
          Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
          if (await launchUrl(mail, mode: LaunchMode.externalApplication)) {
            //email app opened
            print('Email app opened');
          } else {
            //email app is not opened
            print('Email app not opened');
          }
        };
        page = const HomePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        // body: Row(
        //   children: [
        //     SafeArea(
        //       child: NavigationRail(
        //         leading: const Text('LC'),
        //         extended: constraints.maxWidth >= 600,
        //         destinations: const [
        //           NavigationRailDestination(
        //             icon: Icon(Icons.home),
        //             label: Text('Home'),
        //           ),
        //           NavigationRailDestination(
        //             icon: Icon(Icons.photo_library),
        //             label: Text('Gallery'),
        //           ),
        //         ],
        //         selectedIndex: selectedIndex,
        //         onDestinationSelected: (value) {
        //           setState(() {
        //             selectedIndex = value;
        //           });
        //         },
        //       ),
        //     ),
        //     Expanded(
        //       child: Container(
        //         color: Theme.of(context).colorScheme.primaryContainer,
        //         child: page,
        //       ),
        //     ),
        //   ],
        // ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
            SafeArea(
              child: NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.photo_library),
                    label: 'Gallery',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.email),
                    label: 'Email',
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

Widget _buildGallery() => GridView.extent(
      maxCrossAxisExtent: 300,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileList(2),
    );

List<Container> _buildGridTileList(int count) => List.generate(
    count,
    (index) => Container(
            child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/pic$index.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                onPressed: () {
                  print('Favorite Pressed');
                },
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
            ),
          ],
        )));

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home'));
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicHeightGridView(
          itemCount: 2,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          builder: (context, index) {
            return Container(
                child: Stack(
              children: [
                Image.asset(
                  'images/pic$index.jpg',
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      print('Favorite Pressed');
                    },
                    icon:
                        const Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ),
              ],
            ));
          }),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favorites'));
  }
}
