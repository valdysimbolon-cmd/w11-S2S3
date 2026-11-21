import 'package:flutter/material.dart';
import '../widgets/banner_ad_widget.dart';
import 'campus_map.dart';
import 'notes_screen.dart';
import 'weather_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _pages = <Widget>[
    NotesScreen(),
    const _MapPage(),
    const WeatherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.note), label: 'Catatan'),
              NavigationDestination(icon: Icon(Icons.map), label: 'Peta'),
              NavigationDestination(icon: Icon(Icons.cloud), label: 'Cuaca'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPage extends StatelessWidget {
  const _MapPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peta kampus')),
      body: const CampusMap(),
    );
  }
}