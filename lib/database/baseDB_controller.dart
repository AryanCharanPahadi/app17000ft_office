// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app17000ft_new/base_client/baseClient_controller.dart';
import 'package:get/get.dart';

class BaseDBController extends GetxController with BaseController {
  var table = 'stateDistrict';
  var districtTable = 'districtBlock';
//delete record

  // filter block by district name
  List<DistrictBlockCustom> filterDistrictBlock = [];
  List<String> blockList = [];
  List<String> get getBlockList => blockList;
}

class StateDistrictCustom {
  String? state;
  String? district;

  StateDistrictCustom({this.state, this.district});

  factory StateDistrictCustom.fromJson(Map<String, dynamic> json) {
    return StateDistrictCustom(
      state: json['state'] as String?,
      district: json['district'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'district': district,
    };
  }
}

class DistrictBlockCustom {
  String? district;
  String? block;

  DistrictBlockCustom({this.district, this.block});

  factory DistrictBlockCustom.fromJson(Map<String, dynamic> json) {
    return DistrictBlockCustom(
      district: json['district'] as String?,
      block: json['block'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'block': block,
    };
  }
}
