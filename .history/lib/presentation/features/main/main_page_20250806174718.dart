// presentation/features/main/main_page.dart

import 'package:flutter/material.dart';
import '../dungeon/dungeon_page.dart';
import '../encounters/encounters_page.dart';
import '../ermos/ermos_page.dart';
import '../turn_monitor/turn_monitor_page.dart';
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
    const ErmosPage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Masmorras',
      icon: Icons.castle,
      page: const DungeonPage(),
    ),
    NavigationItem(
      title: 'Encontros',
      icon: Icons.shield,
      page: const EncountersPage(),
    ),
    NavigationItem(title: 'Ermos', icon: Icons.forest, page: const ErmosPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildResponsiveNavigation(),
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
    );
  }

  Widget _buildResponsiveNavigation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: isMobile
              ? _buildMobileNavigation(isMobile)
              : _buildDesktopNavigation(isMobile, isTablet),
        );
      },
    );
  }

  Widget _buildMobileNavigation(bool isMobile) {
    return Column(
      children: [
        // Logo e título em linha única
        Row(
          children: [
            Image.asset(
              ImagePath.swords,
              width: 28,
              height: 28,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Dungeon Forge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Old Dragon 2',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Navegação em botões horizontais
        Row(
          children: _navigationItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _currentIndex == index;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < _navigationItems.length - 1 ? 8 : 0,
                ),
                child: _buildMobileNavigationButton(item, index, isSelected),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDesktopNavigation(bool isMobile, bool isTablet) {
    return Row(
      children: [
        // Logo e título
        Row(
          children: [
            Image.asset(
              ImagePath.swords,
              width: isTablet ? 30 : 32,
              height: isTablet ? 30 : 32,
              color: AppColors.primary,
            ),
            SizedBox(width: isTablet ? 10 : 12),
            Text(
              'Dungeon Forge',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: isTablet ? 6 : 8),
            Text(
              'Old Dragon 2',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: isTablet ? 12 : 14,
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
              padding: EdgeInsets.only(left: isTablet ? 6 : 8),
              child: _buildNavigationButton(item, index, isSelected, isTablet),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMobileNavigationButton(
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selected : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    NavigationItem item,
    int index,
    bool isSelected,
    bool isTablet,
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
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 16,
            vertical: isTablet ? 10 : 12,
          ),
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
                size: isTablet ? 18 : 20,
              ),
              SizedBox(width: isTablet ? 6 : 8),
              Text(
                item.title,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: isTablet ? 13 : 14,
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

  NavigationItem({required this.title, required this.icon, required this.page});
}
