import 'package:dio/dio.dart';
import 'package:fe_capstone/constant/base_constant.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/models/parking_lot_model.dart';

class DataService {
  final Dio _dio = Dio();

  Future<List<ParkingLot>> searchParkingLots() async {
    try {
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
          "keyword": ""
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('[API] Success with ${data.length} items');

        return data.map((e) => ParkingLot.fromJson(e)).toList();
      } else {
        print('[API] Error - Status: ${response.statusCode} | Data: ${response.data}');
        throw Exception('Failed to load parking lots: ${response.statusCode}');
      }
    } catch (e) {
      print('[API] Exception: ${e.toString()}');
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Car>> getCarsOfCustomer(int customerId) async {
    try {
      print('[API] Calling: ${BaseConstants.BASE_URL}/Car/GetCarsOfCustomer?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Car/GetCarsOfCustomer',
        queryParameters: {'customerId': customerId},
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('[API] Success with ${data.length} cars');
        return data.map((e) => Car.fromJson(e)).toList();
      } else {
        print('[API] Error - Status: ${response.statusCode} | Data: ${response.data}');
        throw Exception('Failed to load cars: ${response.statusCode}');
      }
    } catch (e) {
      print('[API] Exception: ${e.toString()}');
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
      final response = await _dio.put(
        '${BaseConstants.BASE_URL}/Car/Update',
        data: car.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return Car.fromJson(response.data);
    } catch (e) {
      throw Exception('Error updating car: ${e.toString()}');
    }
  }

  Future<Car> addCar(Car car) async {
    try {
      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Car/Add',
        data: car.toJson(),
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


}