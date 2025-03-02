import 'package:flutter/material.dart';

import '../../core/constants/routes.dart';
import '../../custom/components/list_builder.dart';
import '../../init.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    currentPath = historyPageRoute;
    return listBuilder(context, historyDatabase);
  }
}
