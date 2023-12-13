import 'package:ank_app/entity/app_setting_entity.dart';
import 'package:get/get.dart';

class SettingState {
  RxList<AppSettingEntity> settingList = <AppSettingEntity>[].obs;

  SettingState() {
    ///Initialize variables
  }
}
