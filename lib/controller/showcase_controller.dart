import 'package:flutter/cupertino.dart';

class ShowcaseController extends ChangeNotifier {
  bool _isActive = true;

  bool get isActive => _isActive;

  disableShowcaseOnCreatePage() {
    _isActive = false;
  }
}
