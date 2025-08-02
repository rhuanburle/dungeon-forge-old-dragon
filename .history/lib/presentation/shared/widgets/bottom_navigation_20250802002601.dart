// presentation/shared/widgets/bottom_navigation.dart

import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF1a1a1a),
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.castle),
          label: 'Masmorras',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.Shi),
          label: 'Encontros',
        ),
      ],
    );
  }
}
