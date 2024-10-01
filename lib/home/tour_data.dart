import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SelectTourData extends StatefulWidget {
  const SelectTourData({super.key});

  @override
  State<SelectTourData> createState() => _SelectTourDataState();
}

class _SelectTourDataState extends State<SelectTourData> {
  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    // Initialize the HomeController here
    homeController = Get.put(HomeController());

    // Fetch data after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Select Tour ID'),
        body: GetBuilder<HomeController>(
          // Use the initialized instance of HomeController
          init: homeController,
          builder: (homeController) {
            // Loading indicator while data is being fetched
            if (homeController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            // Check if there are no tour IDs available
            if (homeController.onlineTourList.isEmpty) {
              return const Center(
                child: Text(
                  'No Tour IDs Available',
                  style: TextStyle(fontSize: 16, color: AppColors.onBackground),
                ),
              );
            }

            // Display the list of tour IDs
            return SizedBox(
              height: 700,
              child: ListView.builder(
                itemCount: homeController.onlineTourList.length,
                itemBuilder: (BuildContext context, int index) {
                  final tour = homeController.onlineTourList[index];

                  return ListTile(
                    leading: Icon(Icons.tour, color: AppColors.primary),
                    title: Text(
                      'Tour ID: ${tour.tourId ?? "N/A"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Associated Schools: ${tour.allSchool ?? "N/A"}',
                      style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
                    ),

                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}