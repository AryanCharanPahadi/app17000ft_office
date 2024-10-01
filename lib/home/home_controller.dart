import 'package:app17000ft_new/database/baseDB_controller.dart';
import 'package:app17000ft_new/helper/api_services.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/helper/shared_prefernce.dart';
import 'package:app17000ft_new/tourDetails/tour_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<String> _offlineTaskList = [];
  List<String> get offlineTaskList => _offlineTaskList;

  final List<String> _onlineTaskList = [];
  List<String> get onlineTaskList => _onlineTaskList;

  String? _username;
  String? get username => _username;

  String? _email;
  String? get email => _email;

  String? _phone;
  String? get phone => _phone;
  String? _office;
  String? get office => _office;
  String? _empId;
  String? get empId => _empId;

  List<TourDetails> _onlineTourList =[];
  List<TourDetails> get onlineTourList => _onlineTourList;

  bool isLoading = true; // Added loading state

  @override
  void onInit() {
    print('homeController is initialized');
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    print('get Data is calleed');
    try {
      isLoading = true;
      update(); // Notify listeners about the loading state

      var userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) return;

      var user = userData['user'];
      if (user == null) throw Exception("User data is missing");
      print(user);

      var offlineTask = user['offlineTask'] as String? ?? '';
      _office = user['office_name'] as String?;
      _onlineTourList =   await  ApiService().fetchTourIds(_office);
      print('this is onlineTourList ${_onlineTourList.length}}');
      _username = user['name'] as String?;
      _email = user['email'] as String?;
      _phone = user['phone'] as String?;


      _empId = user['emp_id'] as String?;



      _offlineTaskList = offlineTask.isNotEmpty ? offlineTask.split(',') : [];
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load user data: $e');
    } finally {
      isLoading = false;
      update(); // Notify listeners about the updated state
    }
  }
}