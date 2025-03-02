import 'package:flutter/material.dart';

import '../../core/constants/routes.dart';
import '../../custom/components/list_builder.dart';
import '../../init.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    currentPath = collectionsPageRoute;
    return listBuilder(context, collectionsDatabase);
  }
}
