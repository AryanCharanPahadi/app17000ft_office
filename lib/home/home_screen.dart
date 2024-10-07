import 'package:app17000ft_new/components/circular_indicator.dart';
import 'package:app17000ft_new/components/custom_drawer.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_form.dart';
import 'package:app17000ft_new/forms/inPerson_qualitative_form/inPerson_qualitative_form.dart';
import 'package:app17000ft_new/forms/in_person_quantitative/in_person_quantitative.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment.dart';
import 'package:app17000ft_new/forms/school_recce_form/school_recce_form.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../components/custom_confirmation.dart';
import '../forms/alfa_observation_form/alfa_observation_form.dart';
import '../forms/cab_meter_tracking_form/cab_meter.dart';
import '../forms/issue_tracker/issue_tracker_form.dart';
import '../forms/school_facilities_&_mapping_form/SchoolFacilitiesForm.dart';
import '../forms/school_staff_vec_form/school_vec_from.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOnline = (result != ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkInitialConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = (result != ConnectivityResult.none);
    });
  }

  Future<void> _refreshStatus() async {
    // Check connectivity again when the user pulls to refresh
    ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = (result != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return WillPopScope(
      onWillPop:() async {
        IconData icon = Icons.check_circle;
        bool shouldExit = await showDialog(
            context: context,
            builder: (_) => Confirmation(
                iconname: icon,
                title: 'Exit Confirmation',
                yes: 'Ok',

                desc: 'To leave this screen you have to close the app',
                onPressed: () async {

                }));
        return shouldExit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Home',
              style: AppStyles.appBarTitle(context, AppColors.onPrimary)
          ),
          backgroundColor: AppColors.primary,
          actions: [
            Row(
              children: [
                Icon(
                  _isOnline ? Icons.wifi : Icons.wifi_off,
                  color: _isOnline ? Colors.white : Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: _isOnline ? Colors.white : Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 20), // Adjust spacing between connectivity and logout button
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Get.to(() => LoginScreen());
                  },
                ),
              ],
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        drawer: const CustomDrawer(),
        body: RefreshIndicator(
          onRefresh: _refreshStatus,
          child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (homeController) {
              if (homeController.isLoading) {
                return const Center(
                  child: TextWithCircularProgress(
                    text: 'Loading...',
                    indicatorColor: AppColors.primary,
                    fontsize: 14,
                    strokeSize: 2,
                  ),
                );
              }

              // Check if there are any tasks in offlineTaskList
              if (homeController.offlineTaskList.isNotEmpty) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.inverseOnSurface,
                        AppColors.outlineVariant,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsive.responsiveValue(small: 10.0, medium: 15.0, large: 20.0)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(responsive.responsiveValue(small: 8.0, medium: 10.0, large: 12.0)),
                            itemCount: homeController.offlineTaskList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: responsive.responsiveValue(small: 2, medium: 3, large: 4),
                              crossAxisSpacing: responsive.responsiveValue(small: 10.0, medium: 20.0, large: 30.0),
                              childAspectRatio: 1.3,
                              mainAxisSpacing: responsive.responsiveValue(small: 10.0, medium: 20.0, large: 30.0),
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  // Navigate to the correct form based on the offlineTaskList item
                                  _navigateToForm(homeController.offlineTaskList[index], homeController);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.background,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(responsive.responsiveValue(small: 8.0, medium: 10.0, large: 12.0)),
                                      child: Text(
                                        homeController.offlineTaskList[index],
                                        textAlign: TextAlign.center,
                                        style: AppStyles.captionText(
                                          context,
                                          AppColors.onBackground,
                                          responsive.responsiveValue(small: 12, medium: 14, large: 16), // Use responsive sizes here
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.onSurface,
                        AppColors.tertiaryFixedDim,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: const Center(child: Text('No Data Found')),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // Method to handle navigation based on the selected form
  void _navigateToForm(String task, HomeController homeController) {
    switch (task) {
      case 'School Enrollment Form':
        Get.to(() => SchoolEnrollmentForm(userid: homeController.empId));
        break;
      case 'Cab Meter Tracing Form':
        Get.to(() => CabMeterTracingForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'In Person Monitoring Quantitative':
        Get.to(() => InPersonQuantitative(userid: homeController.empId, office: homeController.office));
        break;
      case 'School Facilities Mapping Form':
        Get.to(() => SchoolFacilitiesForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'School Staff & SMC/VEC Details':
        Get.to(() => SchoolStaffVecForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'Issue Tracker (New)':
        Get.to(() => IssueTrackerForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'ALfA Observation Form':
        Get.to(() => AlfaObservationForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'FLN Observation Form':
        Get.to(() => FlnObservationForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'In Person Monitoring Qualitative':
        Get.to(() => InPersonQualitativeForm(userid: homeController.empId, office: homeController.office));
        break;
      case 'School Recce Form':
        Get.to(() => SchoolRecceForm(userid: homeController.empId, office: homeController.office));
        break;
      default:
        Get.snackbar('Error', 'Unknown task: $task');
        break;
    }
  }
}

