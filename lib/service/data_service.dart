import 'package:dio/dio.dart';
import 'package:fe_capstone/models/Contract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_capstone/constant/base_constant.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/models/customer_model.dart';
import 'package:fe_capstone/models/parking_lot_model.dart';

class DataService {
  final Dio _dio = Dio();

  // Helper method to get customer ID from SharedPreferences
  Future<int> _getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getInt('ownerId');
    if (customerId == null) {
      throw Exception('User not logged in or customer ID not found');
    }
    return customerId;
  }

  Future<List<ParkingLot>> searchParkingLots() async {
    try {
      final customerId = await _getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/ParkingLot/Search');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/ParkingLot/Search',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "keyword": "",
          "customerId": customerId
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ParkingLot.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load parking lots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Car>> getCarsOfCustomer() async {
    try {
      final customerId = await _getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Car/GetCarsOfCustomer?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Car/GetCarsOfCustomer',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Car.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load cars: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<Car> getCarById(int carId) async {
    try {
      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Car/GetById',
        queryParameters: {'id': carId},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return Car.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching car details: ${e.toString()}');
    }
  }

  Future<Car> updateCar(Car car) async {
    try {
      final customerId = await _getCustomerId();
      final updatedCar = car.copyWith(customerId: customerId);

      print("🚀 Đang gửi request cập nhật xe...");
      print("📝 Dữ liệu gửi đi: ${updatedCar.toJson()}");

      final response = await _dio.put(
        '${BaseConstants.BASE_URL}/Car/Update',
        data: updatedCar.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("✅ Phản hồi từ server: ${response.data}");
      return Car.fromJson(response.data);
    } catch (e, stacktrace) {
      print("❌ Lỗi khi cập nhật xe: ${e.toString()}");
      print("🔍 Stacktrace: $stacktrace");
      throw Exception('Error updating car: ${e.toString()}');
    }
  }

  Future<Car> addCar(Car car) async {
    try {
      final customerId = await _getCustomerId();
      final newCar = car.copyWith(customerId: customerId);

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Car/Add',
        data: newCar.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return Car.fromJson(response.data);
      } else {
        throw Exception('Failed to add car: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding car: ${e.toString()}');
    }
  }

  Future<Customer> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Customer/Login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final customer = Customer.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt('ownerId', customer.ownerId);
        await prefs.setString('username', customer.username);
        await prefs.setBool('isLoggedIn', true);

        return customer;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<List<Contract>> getCustomerContracts() async {
    try {
      final customerId = await _getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetContractsOfCustomer?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetContractsOfCustomer',
        queryParameters: {'customerId': 1},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load contracts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting contracts: ${e.toString()}');
      throw Exception('Error occurred: ${e.toString()}');
    }
  }
}