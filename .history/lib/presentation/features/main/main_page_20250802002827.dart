// presentation/features/main/main_page.dart

import 'package:flutter/material.dart';
import '../dungeon/dungeon_page.dart';
import '../encounters/encounters_page.dart';
import '../../../constants/image_path.dart';
import '../../../theme/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DungeonPage(),
    const EncountersPage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Masmorras',
      icon: Icons.castle,
      page: const DungeonPage(),
    ),
    NavigationItem(
      title: 'Encontros',
      icon: Icons.shor,
      page: const EncountersPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildWebNavigation(),
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildWebNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo e título
          Row(
            children: [
              Image.asset(
                ImagePath.swords,
                width: 32,
                height: 32,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              const Text(
                'Dungeon Forge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Old Dragon 2',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Navegação
          Row(
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _currentIndex == index;

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildNavigationButton(item, index, isSelected),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
    NavigationItem item,
    int index,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selected : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                item.title,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final Widget page;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}
