import 'package:flutter/material.dart';

import '../../core/constants/routes.dart';
import '../../core/constants/strings.dart';
import '../../init.dart';

NavigationBar navBar(int? currentIndex, void Function(int) onItemTapped) {
  return NavigationBar(
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    destinations: navBarsItems(),
    selectedIndex: currentIndex!,
    onDestinationSelected: onItemTapped,
  );
}

List<NavigationDestination> navBarsItems() {
  NavigationDestination editOrAddRequestButton =
      (currentPath == editRequestPageRoute)
          ? const NavigationDestination(
              icon: Icon(
                Icons.edit_outlined,
                color: Colors.greenAccent,
              ),
              label: editRequest,
            )
          : const NavigationDestination(
              icon: Icon(
                Icons.add_outlined,
                color: Colors.greenAccent,
              ),
              label: addRequest,
            );

  return <NavigationDestination>[
    const NavigationDestination(
      icon: Icon(
        Icons.history,
        color: Colors.redAccent,
      ),
      label: history,
    ),
    editOrAddRequestButton,
    const NavigationDestination(
      icon: Icon(
        Icons.list_alt_outlined,
        color: Colors.blueAccent,
      ),
      label: collections,
    ),
  ];
}
