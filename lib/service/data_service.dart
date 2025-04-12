import 'package:dio/dio.dart';
import 'package:fe_capstone/models/Contract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_capstone/constant/base_constant.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/models/customer_model.dart';
import 'package:fe_capstone/models/parking_lot_model.dart';

class DataService {
  final Dio _dio = Dio();

  // Helper method to get customer ID from SharedPreferences (bỏ dấu _ để thành public)
  Future<int> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getInt('ownerId');
    if (customerId == null) {
      throw Exception('User not logged in or customer ID not found');
    }
    return customerId;
  }

  Future<List<ParkingLot>> searchParkingLots() async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/ParkingLot/Search');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/ParkingLot/Search',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {"keyword": "", "customerId": customerId},
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
      final customerId = await getCustomerId();
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
      final customerId = await getCustomerId();
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
      final customerId = await getCustomerId();

      // Chuyển đổi registedDate sang định dạng ISO 8601
      String formattedDate;
      try {
        final dateParts = car.registedDate.split('/');
        if (dateParts.length == 3) {
          // Giả sử định dạng nhập là dd/mm/yyyy
          formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}T00:00:00.000Z';
        } else {
          formattedDate = DateTime.now().toIso8601String(); // Mặc định nếu định dạng sai
        }
      } catch (e) {
        formattedDate = DateTime.now().toIso8601String(); // Fallback nếu lỗi
      }

      // Tạo payload chỉ với các trường server yêu cầu
      final payload = {
        'customerId': customerId,
        'model': car.model, // Nếu server chỉ cần brand, có thể cần tách từ car.model
        'color': car.color,
        'licensePlate': car.licensePlate,
        'registedDate': formattedDate,
        'status': car.status,
      };

      print("Data addcar: $payload");
      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Car/Add',
        data: payload,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Car.fromJson(response.data);
      } else {
        throw Exception('Failed to add car: ${response.statusCode} - ${response.data}');
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
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetContractsOfCustomer?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetContractsOfCustomer',
        queryParameters: {'customerId': customerId}, // Sửa lỗi hardcode 1
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

  Future<List<ParkingLot>> searchAvailableParkingForContract({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final requestData = {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };

      print('[API] Calling: ${BaseConstants.BASE_URL}/ParkingLot/SearchAvailablesForContract');
      print('[API] Request data: $requestData');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/ParkingLot/SearchAvailablesForContract',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: requestData,
      );

      print('[API] Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ParkingLot.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load available parking lots: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      print('Request: ${e.requestOptions.method} ${e.requestOptions.path}');
      print('Request data: ${e.requestOptions.data}');
      throw Exception('Failed to search parking: ${e.message}');
    } catch (e) {
      print('Error searching available parking: $e');
      throw Exception('Error occurred: $e');
    }
  }

  Future<List<Contract>> getPendingContracts() async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetPendingContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetPendingContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load pending contracts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getApprovedContracts() async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetApprovedContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetApprovedContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load approved contracts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getPaidContracts() async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetPaidContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetPaidContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load paid contracts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getActivatedContracts() async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetActivatedContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetActivatedContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load activated contracts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getRejectedContracts() async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetRejectedContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetRejectedContracts', // Sửa endpoint đúng
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load rejected contracts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<void> payContract(int paymentContractId) async {
    try {
      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/Pay/$paymentContractId');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Contract/Pay/$paymentContractId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Payment successful');
      } else {
        throw Exception('Payment failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error during payment: $e');
      throw Exception('Payment error: $e');
    }
  }

  Future<Contract?> addContract({
    required int carId,
    required int parkingLotId,
    required DateTime startDate,
    required DateTime endDate,
    String note = "Đăng ký hợp đồng",
  }) async {
    try {
      final requestData = {
        "carId": carId,
        "parkingLotId": parkingLotId,
        "startDate": startDate.toIso8601String().split('T')[0],
        "endDate": endDate.toIso8601String().split('T')[0],
        "note": note,
      };

      print('[API] Calling: ${BaseConstants.BASE_URL}/contract/AddContract');
      print('[API] Request data: $requestData');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/contract/AddContract',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Contract.fromJson(response.data);
      } else {
        throw Exception('Failed to add contract: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      if (e.response?.statusCode == 500) {
        final errorMessage = e.response?.data['message'] ?? 'Unknown server error';
        if (errorMessage.contains('object cycle was detected')) {
          print('Circular reference detected in server response');
          return null;
        }
      }
      throw Exception('Failed to add contract: ${e.message}');
    } catch (e) {
      print('Error adding contract: $e');
      throw Exception('Error occurred: $e');
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      print('[API] Calling: ${BaseConstants.BASE_URL}/Customer/Register');
      print('[API] Request body: {'
          '"firstName": "$firstName", '
          '"lastName": "$lastName", '
          '"phone": "$phone", '
          '"email": "$email", '
          '"username": "$username", '
          '"password": "$password"}');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Customer/Register',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500; // Chấp nhận tất cả status code dưới 500
          },
        ),
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'email': email,
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('[API] Error response: ${response.data}');
        final errorMessage = response.data['message'] ?? 'Đăng ký thất bại';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('[API] Exception: $e');
      throw Exception(e.toString().contains('Exception') ? e.toString().replaceFirst('Exception: ', '') : 'Đăng ký thất bại: ${e.toString()}');
    }
  }

}