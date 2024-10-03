import 'dart:convert';
import 'package:app17000ft_new/base_client/app_exception.dart';
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/tourDetails/tour_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://mis.17000ft.org/apis/fast_apis/';
  List<TourDetails> _tourList = [];
  List<TourDetails> get tourList => _tourList;

  // Fetch tour ids
  Future<List<TourDetails>> fetchTourIds(String? office) async {
    print('Fetching Tour IDs for office: $office');
    _tourList = [];

    var request = {'office': office ?? ''};
    print('Request payload: $request');

    var response;
    try {
      response = await BaseClient().post(baseUrl, 'tourIds.php', request);
      print('Response received: $response');
    } catch (error) {
      if (error is BadRequestException) {
        // Decode and print the API error
        var apiError = json.decode(error.message!);
        print('API Error: $apiError');
      } else {
        // Print other errors
        print('An unexpected error occurred: ${error.toString()}');
      }
      return [];  // Return an empty list on error
    }

    if (response == null) {
      print('No response received from the API.');
      return [];
    }

    try {
      _tourList = tourDetailsFromJson(response);
      print('Parsed tour details: $_tourList');
    } catch (e) {
      print('Error parsing response to TourDetails: $e');
      return [];  // Return an empty list if parsing fails
    }

    // Check if there are any tour details to write to the local database
    if (_tourList.isNotEmpty) {
      print('Deleting existing tour details from the local database...');
      await SqfliteDatabaseHelper().delete('tour_details');
      for (var tour in _tourList) {
        print('Adding tour detail to local database: $tour');
        await LocalDbController().addData(tourDetails: tour);
      }
      print('All tour details saved to local database.');
    } // Removed else clause to suppress output when no tour details are available

    return _tourList; // Return the list, whether empty or populated
  }

  // Clear tour details upon logout
  Future<void> clearTourDetailsOnLogout() async {
    print('Clearing tour details on logout...');
    await SqfliteDatabaseHelper().delete('tour_details');  // Clear from local DB
    _tourList.clear();  // Clear in-memory list
    print('Tour details cleared.');
  }

  // Refresh tour details on login
  Future<void> refreshTourDetailsOnLogin(String? office) async {
    print('Refreshing tour details on login...');
    await fetchTourIds(office);  // Fetch fresh data and update local storage
  }
}
