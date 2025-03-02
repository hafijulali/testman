import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keymap/keymap.dart';

import '../../init.dart';

List<KeyAction> keyBindings = [
  KeyAction(LogicalKeyboardKey.keyU, 'Goto UpcomingTodoPage', () {
    pageController
        .jumpToPage(routes.keys.toList().indexOf('/UpcomingTodoPage'));
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.digit1, 'Goto UpcomingTodoPage', () {
    pageController.jumpToPage(0);
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.keyN, 'Goto AddTodoPage', () {
    pageController.jumpToPage(routes.keys.toList().indexOf('/AddTodoPage'));
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.digit2, 'Goto AddTodoPage', () {
    pageController.jumpToPage(1);
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.keyA, 'Goto DoneTodoPage', () {
    pageController.jumpToPage(routes.keys.toList().indexOf('/DoneTodoPage'));
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.digit3, 'Goto DoneTodoPage', () {
    pageController.jumpToPage(2);
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.keyQ, 'Close App', () {
    exit(0);
  }, isControlPressed: true),
  KeyAction(LogicalKeyboardKey.keyF, 'SearchBar focus', () {},
      isControlPressed: true),
  KeyAction(LogicalKeyboardKey.keyS, 'Goto SettingsPage', () {},
      isControlPressed: true),
  KeyAction(LogicalKeyboardKey.backspace, 'Goto previous screen', () {
    ('backsp');
  }, isControlPressed: true),
];
