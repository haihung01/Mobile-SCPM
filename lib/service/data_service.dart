import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/models/payment_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_capstone/constant/base_constant.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/models/customer_model.dart';
import 'package:fe_capstone/models/parking_lot_model.dart';

class DataService {
  final Dio _dio = Dio();

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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Parking lots not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Car>> getCarsOfCustomer() async {
    try {
      final customerId = await getCustomerId();
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Car/GetCarsOfCustomer?customerId=$customerId');

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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Cars not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
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

      if (response.statusCode == 200) {
        return Car.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch car: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Car not found');
        }
      }
      throw Exception('Error fetching car details: ${e.toString()}');
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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Car not found for update');
        }
      }
      print("❌ Lỗi khi cập nhật xe: ${e.toString()}");
      throw Exception('Error updating car: ${e.toString()}');
    } catch (e, stacktrace) {
      print("❌ Lỗi khi cập nhật xe: ${e.toString()}");
      print("🔍 Stacktrace: $stacktrace");
      throw Exception('Error updating car: ${e.toString()}');
    }
  }

  Future<Car> addCar(Car car) async {
    try {
      final customerId = await getCustomerId();

      String formattedDate;
      try {
        final dateParts = car.registedDate.split('/');
        if (dateParts.length == 3) {
          formattedDate =
          '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}T00:00:00.000Z';
        } else {
          formattedDate = DateTime.now().toIso8601String();
        }
      } catch (e) {
        formattedDate = DateTime.now().toIso8601String();
      }

      final payload = {
        'customerId': customerId,
        'model': car.model,
        'color': car.color,
        'thumbnail': car.thumbnail ?? '',
        'licensePlate': car.licensePlate,
        'registedDate': formattedDate,
        'status': car.status,
        'brand': car.brand,
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
        throw Exception(
            'Failed to add car: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Biển số xe đã tồn tại trong hệ thống';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Resource not found');
        }
      }
      throw Exception('Error adding car: ${e.toString()}');
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
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Login failed';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'User not found');
        }
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<Map<String, dynamic>> getCustomerById(int id) async {
    try {
      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Customer/GetById',
        queryParameters: {'id': id},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch customer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Customer not found');
        }
      }
      throw Exception('Error fetching customer: ${e.toString()}');
    } catch (e) {
      throw Exception('Error fetching customer: ${e.toString()}');
    }
  }

  Future<List<Contract>> getCustomerContracts() async {
    try {
      final customerId = await getCustomerId();
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetContractsOfCustomer?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetContractsOfCustomer',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Contracts not found');
        }
      }
      print('Error getting contracts: ${e.toString()}');
      throw Exception('Error occurred: ${e.toString()}');
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

      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/ParkingLot/SearchAvailablesForContract');
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
        throw Exception(
            'Failed to load available parking lots: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'No available parking lots found');
        }
      }
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
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetPendingContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetPendingContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load pending contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Pending contracts not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getApprovedContracts() async {
    try {
      final customerId = await getCustomerId();
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetApprovedContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetApprovedContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load approved contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Approved contracts not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getPaidContracts() async {
    try {
      final customerId = await getCustomerId();
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetPaidContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetPaidContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load paid contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Paid contracts not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getActivatedContracts() async {
    try {
      final customerId = await getCustomerId();
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetActivatedContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetActivatedContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load activated contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Activated contracts not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<List<Contract>> getRejectedContracts() async {
    try {
      final customerId = await getCustomerId();
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/GetRejectedContracts?customerId=$customerId');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/GetRejectedContracts',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Contract.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load rejected contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Rejected contracts not found');
        }
      }
      throw Exception('Error occurred: ${e.toString()}');
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }

  Future<void> payContract(int paymentContractId) async {
    try {
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/Pay/$paymentContractId');

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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Payment failed';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Contract not found for payment');
        }
      }
      print('❌ Error during payment: $e');
      throw Exception('Payment error: $e');
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
        throw Exception(
            'Failed to add contract: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Car or parking lot not found');
        } else if (e.response!.statusCode == 500) {
          final errorMessage =
              e.response?.data['message'] ?? 'Unknown server error';
          if (errorMessage.contains('object cycle was detected')) {
            print('Circular reference detected in server response');
            return null;
          }
        }
      }
      print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Failed to add contract: ${e.message}');
    } catch (e) {
      print('Error adding contract: $e');
      throw Exception('Error occurred: $e');
    }
  }

  Future<String?> redirectToVNPay(int paymentContractId) async {
    try {
      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Payment/create',
        queryParameters: {
          'paymentContractId': paymentContractId,
          'platform': 'mobile',
        },
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final String url =
            "${BaseConstants.BASE_URL}/Payment/create?paymentContractId=$paymentContractId&platform=mobile";
        print('✅ URL thanh toán: $url');
        return url;
      } else {
        throw Exception('Failed to create payment: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Payment contract not found');
        }
      }
      print('❌ Lỗi khi gọi API tạo thanh toán: $e');
      throw Exception('Error creating payment: $e');
    } catch (e) {
      print('❌ Lỗi khi gọi API tạo thanh toán: $e');
      throw Exception('Error creating payment: $e');
    }
  }

  Future<String?> checkPaymentSuccess(int paymentContractId) async {
    try {
      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Payment/success',
        queryParameters: {
          'paymentContractId': paymentContractId,
        },
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final String url =
            "${BaseConstants.BASE_URL}/Payment/success?paymentContractId=$paymentContractId";
        print('✅ URL thanh toán thành công: $url');
        return url;
      } else {
        throw Exception('Failed to check payment: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Payment contract not found');
        }
      }
      print('❌ Lỗi khi gọi API kiểm tra thanh toán: $e');
      throw Exception('Error checking payment: $e');
    } catch (e) {
      print('❌ Lỗi khi gọi API kiểm tra thanh toán: $e');
      throw Exception('Error checking payment: $e');
    }
  }

  Future<void> renewContract({
    required int contractId,
    required int numberMonth,
  }) async {
    try {
      final requestData = {
        'contractId': contractId,
        'numberMonth': numberMonth,
      };

      print('[API] Calling: ${BaseConstants.BASE_URL}/Contract/Renew');
      print('[API] Request body: $requestData');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Contract/Renew',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Gia hạn hợp đồng thành công');
      } else {
        throw Exception('Gia hạn thất bại: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Gia hạn thất bại';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Contract not found for renewal');
        }
      }
      print('❌ Lỗi khi gọi API gia hạn: $e');
      throw Exception('Lỗi gia hạn: $e');
    } catch (e) {
      print('❌ Lỗi khi gọi API gia hạn: $e');
      throw Exception('Lỗi gia hạn: $e');
    }
  }

  // feedback

// get
  Future<List<Map<String, dynamic>>> getFeedbacksOfCustomer(
      int customerId) async {
    try {
      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Feedback/GetFeedbacksOfCustomer',
        queryParameters: {'customerId': customerId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load feedbacks: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting feedbacks: $e');
      throw Exception('Error occurred: $e');
    }
  }

// add
  Future<void> sendFeedback(int customerId, String message) async {
    try {
      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Feedback/Add',
        data: {
          'customerId': customerId,
          'message': message,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Feedback sent successfully');
      } else {
        throw Exception('Failed to send feedback: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error sending feedback: $e');
      throw Exception('Error sending feedback: $e');
    }
  }

  // update
  Future<void> updateFeedback(int feedbackId, String message) async {
    try {
      await _dio.put(
        '${BaseConstants.BASE_URL}/Feedback/Update',
        data: {
          'feedbackId': feedbackId,
          'message': message,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
    } catch (e) {
      throw Exception('Error updating feedback: $e');
    }
  }

  // xóa
  Future<void> deleteFeedback(int feedbackId) async {
    try {
      final response = await _dio.delete(
        '${BaseConstants.BASE_URL}/Feedback/$feedbackId',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // print('✅ Xóa feedback thành công');
      } else {
        throw Exception('Xóa feedback thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Lỗi xóa feedback: $e');
      throw Exception('Error deleting feedback: $e');
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
            return status! < 500;
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
        final responseData = response.data;
        String errorMessage = 'Đăng ký thất bại';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Đăng ký thất bại';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Registration endpoint not found');
        }
      }
      print('[API] Exception: $e');
      throw Exception(e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Đăng ký thất bại: ${e.toString()}');
    } catch (e) {
      print('[API] Exception: $e');
      throw Exception(e.toString().contains('Exception')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Đăng ký thất bại: ${e.toString()}');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      print('[API] Calling: ${BaseConstants.BASE_URL}/Car/UploadImage');
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        'imageFile': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Car/UploadImage',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Image uploaded successfully: ${response.data}');
        final responseData = response.data as Map<String, dynamic>;
        final imageUrl = responseData['pathFull'] as String;
        return imageUrl;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error uploading image';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Image upload endpoint not found');
        }
      }
      print('❌ Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    } catch (e) {
      print('❌ Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<double> getParkingLotPrice(int parkingLotId) async {
    try {
      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/ParkingLot/GetById',
        queryParameters: {'id': parkingLotId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return (response.data['pricePerMonth'] as num).toDouble();
      } else {
        throw Exception('Failed to load parking lot price');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error fetching parking lot price';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Parking lot not found');
        }
      }
      throw Exception('Error fetching parking lot price: ${e.toString()}');
    } catch (e) {
      throw Exception('Error fetching parking lot price: ${e.toString()}');
    }
  }

  Future<List<PaymentContract>> getPaymentContracts(int contractId) async {
    try {
      print(
          '[API] Calling: ${BaseConstants.BASE_URL}/Contract/$contractId/PaymentContracts');

      final response = await _dio.get(
        '${BaseConstants.BASE_URL}/Contract/$contractId/PaymentContracts',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => PaymentContract.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load payment contracts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Payment contracts not found');
        }
      }
      throw Exception('Error fetching payment contracts: ${e.toString()}');
    } catch (e) {
      throw Exception('Error fetching payment contracts: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      print('[API] Calling: ${BaseConstants.BASE_URL}/Customer/ForgotPassword');
      print('[API] Request body: {"email": "$email"}');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Customer/ForgotPassword',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Password reset request successful');
      } else {
        throw Exception(
            'Failed to request password reset: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Yêu cầu đặt lại mật khẩu thất bại';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(
              errorMessage.isNotEmpty ? errorMessage : 'Email không tồn tại');
        }
      }
      print('❌ Lỗi khi gọi API quên mật khẩu: $e');
      throw Exception('Lỗi yêu cầu đặt lại mật khẩu: $e');
    } catch (e) {
      print('❌ Lỗi khi gọi API quên mật khẩu: $e');
      throw Exception('Lỗi yêu cầu đặt lại mật khẩu: $e');
    }
  }

  Future<void> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final customerId = await getCustomerId();
      print('[API] Calling: ${BaseConstants.BASE_URL}/Customer/ChangePassword');
      print(
          '[API] Request body: {"customerId": $customerId, "newPassword": "$newPassword", "confirmPassword": "$confirmPassword"}');

      final response = await _dio.post(
        '${BaseConstants.BASE_URL}/Customer/ChangePassword',
        data: {
          'customerId': customerId,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Password changed successfully');
      } else {
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Đổi mật khẩu thất bại';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        if (e.response!.statusCode == 400) {
          throw Exception(errorMessage);
        } else if (e.response!.statusCode == 404) {
          throw Exception(errorMessage.isNotEmpty
              ? errorMessage
              : 'Người dùng không tồn tại');
        }
      }
      print('❌ Lỗi khi gọi API đổi mật khẩu: $e');
      throw Exception('Lỗi đổi mật khẩu: $e');
    } catch (e) {
      print('❌ Lỗi khi gọi API đổi mật khẩu: $e');
      throw Exception('Lỗi đổi mật khẩu: $e');
    }
  }
}