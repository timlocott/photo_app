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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
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
        page = const GalleryPage();
        break;
      case 2:
        page = const FavoritesPage();
        break;
      case 3:
        page = const ContactPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
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
                    label: 'Contact Us',
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home'),
    );
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

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.email),
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Default Mail App Opened'),
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  _openEmailApp();
                },
                label: const Text('Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.message),
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Default Texting App Opened'),
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  _openSMSApp();
                },
                label: const Text('Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_openEmailApp() async {
  final Uri url = Uri.parse(
      "mailto:timlocott@hotmail.com?subject=EmailTest&body=BodyofEmail");
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

_openSMSApp() async {
  final Uri url = Uri.parse("sms:8015161371?body=Hey+Liz!");
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
