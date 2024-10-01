import 'dart:convert';

// Function to convert a JSON string to a list of TourDetails
List<TourDetails> tourDetailsFromJson(String str) {
    // Decode the JSON string to a dynamic type
    final jsonData = json.decode(str);

    // Check if jsonData is a List
    if (jsonData is List) {
        return List<TourDetails>.from(jsonData.map((x) => TourDetails.fromJson(x)));
    } else {
        throw Exception("Expected a list of TourDetails");
    }
}

// Function to convert a list of TourDetails to a JSON string
String tourDetailsToJson(List<TourDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TourDetails {
    String? tourId;
    String? allSchool;

    // Constructor with required fields
    TourDetails({
        this.tourId,
        this.allSchool,
    });

    // Factory constructor for creating a new TourDetails instance from a JSON map
    factory TourDetails.fromJson(Map<String, dynamic> json) {
        // Check for the existence of keys and provide default values if necessary
        return TourDetails(
            tourId: json["tourId"] ?? "", // Default to empty string if key doesn't exist
            allSchool: json["AllSchool"] ?? "", // Default to empty string if key doesn't exist
        );
    }

    // Method to convert TourDetails instance to JSON map
    Map<String, dynamic> toJson() => {
        "tourId": tourId,
        "AllSchool": allSchool,
    };
}