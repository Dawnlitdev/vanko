import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import '../constants/constants.dart';

class ApiService {
  // Fetch data from a specific table
  Future<List<Map<String, dynamic>>> fetchData(String table) async {
    String endpoint;
    switch (table) {
      case 'UpperWancho':
        endpoint = ENDPOINT_UPPER_WANCHO;
        break;
      case 'MiddleWancho':
        endpoint = ENDPOINT_MIDDLE_WANCHO;
        break;
      case 'LowerWancho':
        endpoint = ENDPOINT_LOWER_WANCHO;
        break;
      default:
        throw Exception('Unknown table: $table');
    }

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data from $table');
    }
  }

  // Fetch data from all tables
  Future<List<Map<String, dynamic>>> fetchAllTablesData() async {
    final response = await http.get(Uri.parse(ENDPOINT_ALL_TABLES));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data from all tables');
    }
  }

  // Method to check if updates are available
  static Future<bool> checkForUpdates(String currentVersion) async {
    try {
      final response = await http.get(Uri.parse(ENDPOINT_ALL_TABLES));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

        // Find the maximum version number in the response
        double maxServerVersion = 0;
        for (var entry in responseData) {
          if (entry['Version'] != null &&
              entry['Version'].toString().isNotEmpty) {
            double? version = double.tryParse(entry['Version'].toString());
            if (version != null && version > maxServerVersion) {
              maxServerVersion = version;
            }
          }
        }

        // Convert currentVersion to double for comparison
        double currentVersionDouble = double.tryParse(currentVersion) ?? 0;

        // Compare versions
        return maxServerVersion > currentVersionDouble;
      } else {
        throw Exception('Failed to check for updates');
      }
    } catch (e) {
      throw Exception('Error checking for updates: $e');
    }
  }

  // Method to fetch and apply updates
  static Future<void> fetchAndApplyUpdates() async {
    try {
      final response = await http.get(Uri.parse(ENDPOINT_ALL_TABLES));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(data);

        // Clear the existing data in the local database
        await DatabaseHelper.instance.clearTable('UpperWancho');
        await DatabaseHelper.instance.clearTable('MiddleWancho');
        await DatabaseHelper.instance.clearTable('LowerWancho');

        // Insert new data into the local database
        for (var entry in newData) {
          String? tableName = entry['table']; // Ensure table is not null
          if (tableName != null && tableName.isNotEmpty) {
            await DatabaseHelper.instance.insertData(tableName, entry);
          }
        }

        // Update the local version in the database
        double maxVersion = newData
                .map((e) => double.tryParse(e['Version']?.toString() ?? '0'))
                .reduce((a, b) =>
                    (a != null && b != null) ? (a > b ? a : b) : (a ?? b)) ??
            1.0;

        await DatabaseHelper.instance.updateVersion(maxVersion.toString());
      } else {
        throw Exception('Failed to fetch updates');
      }
    } catch (e) {
      throw Exception('Error applying updates: $e');
    }
  }
}
