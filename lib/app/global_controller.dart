// app/global_controller.dart

import 'package:get/get.dart';

class GlobalController extends GetxController {
  // Example global reactive variables
  var level = 3.obs;
  var theme = 'Recuperar artefato'.obs;

  void setLevel(int l) => level.value = l;
  void setTheme(String t) => theme.value = t;
}
