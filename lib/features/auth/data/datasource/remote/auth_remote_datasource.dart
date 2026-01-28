import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:quick_menu/core/api/api_client.dart';
import 'package:quick_menu/core/api/api_endpoint.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'package:quick_menu/features/auth/data/datasource/auth_datasource.dart';
import 'package:quick_menu/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.customerLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final token = response.data['token'] as String?;
      if (token != null) {
        // Decode JWT token to get user ID
        final decodedToken = JwtDecoder.decode(token);
        final userId = decodedToken['id'] as String;

        // Save token
        await _userSessionService.saveToken(token);

        // Get user data from backend response
        final userData = response.data['data'] as Map<String, dynamic>?;

        // Get stored data as fallback
        final storedFullName = _userSessionService.getCurrentUserFullName();
        final storedPhoneNumber = _userSessionService
            .getCurrentUserPhoneNumber();

        // Use backend data if available, otherwise use stored data
        final fullName = userData?['name'] as String? ?? storedFullName ?? '';
        final phoneNumber =
            userData?['phoneNumber'] as String? ?? storedPhoneNumber;
        final photoUrl = userData?['photoUrl'] as String?;

        // Create user object with data from backend and stored data
        final user = AuthApiModel(
          id: userId,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          password: null,
          photoUrl: photoUrl,
        );

        // Update stored session with latest info including photoUrl
        await _userSessionService.saveUserSession(
          userId: userId,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
        );

        return user;
      }
    }

    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.customerRegister,
      data: user.toJson(),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);

      // Save user data locally for future login
      await _userSessionService.saveUserSession(
        userId: registeredUser.id!,
        email: registeredUser.email,
        fullName: registeredUser.fullName,
        phoneNumber: registeredUser.phoneNumber,
      );

      return registeredUser;
    } else {
      throw Exception(response.data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<AuthApiModel> uploadUserPhoto(String userId, String photoPath) async {
    try {
      print('\n📤 ========== PHOTO UPLOAD START =========');
      print('📤 User ID: $userId');
      print('📤 Photo path: $photoPath');

      // Step 1: Verify file exists
      final photoFile = File(photoPath);
      if (!await photoFile.exists()) {
        final error = 'Photo file not found: $photoPath';
        print('❌ $error');
        throw Exception(error);
      }

      final fileSize = await photoFile.length();
      final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);
      print('✅ File exists - Size: $fileSizeKB KB');

      // Step 2: Extract filename
      final fileName = photoPath.split(RegExp(r'[\\/]')).last;
      print('✅ File name extracted: $fileName');

      // Step 3: Create FormData
      print('📦 Creating FormData...');
      final formData = FormData();
      final multipartFile = await MultipartFile.fromFile(
        photoPath,
        filename: fileName,
      );
      formData.files.add(MapEntry('profilePicture', multipartFile));
      print('✅ FormData created with field name: "profilePicture"');

      // Step 4: Prepare endpoint
      final endpoints = ['${ApiEndpoints.baseUrl}/customers/upload-image'];

      Response? response;

      for (final endpoint in endpoints) {
        try {
          print('\n📤 Attempting upload to: $endpoint');
          response = await _apiClient.post(endpoint, data: formData);
          print('✅ Request sent successfully');
          break; // Success, exit loop
        } on DioException catch (e) {
          print('❌ Endpoint failed: ${e.message}');
          print('❌ Status code: ${e.response?.statusCode}');
          if (endpoint == endpoints.last) {
            // Last endpoint also failed
            rethrow;
          }
          // Try next endpoint
          continue;
        }
      }

      if (response == null) {
        throw Exception('No successful upload endpoint found');
      }

      // Step 5: Parse response
      print('\n📥 Response received');
      print('📥 Status code: ${response.statusCode}');
      print('📥 Response type: ${response.data.runtimeType}');
      print('📥 Response body: ${response.data}');

      // Validate response format
      if (response.data is! Map<String, dynamic>) {
        final error =
            'Invalid response format: expected Map, got ${response.data.runtimeType}';
        print('❌ $error');
        throw Exception(error);
      }

      final responseMap = response.data as Map<String, dynamic>;
      final success = responseMap['success'] == true;
      print('📥 Success flag: $success');

      if (!success) {
        final message =
            responseMap['message'] ?? 'Server returned success:false';
        print('❌ Server error: $message');
        throw Exception(message);
      }

      // Step 6: Extract user data
      final userData = responseMap['data'];
      print('📥 Data field type: ${userData.runtimeType}');

      if (userData is! Map<String, dynamic>) {
        final error =
            'Invalid data format: expected Map, got ${userData.runtimeType}';
        print('❌ $error');
        throw Exception(error);
      }

      // Step 7: Parse to model
      final apiModel = AuthApiModel.fromJson(userData);
      print('✅ Photo URL: ${apiModel.photoUrl}');
      print('✅ User ID: ${apiModel.id}');
      print('✅ User name: ${apiModel.fullName}');
      print('📤 ========== PHOTO UPLOAD SUCCESS =========\n');

      return apiModel;
    } on DioException catch (e) {
      print('\n❌ ========== DIO EXCEPTION ==========');
      print('❌ Type: ${e.type}');
      print('❌ Message: ${e.message}');
      print('❌ Status code: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');
      print('❌ Request URL: ${e.requestOptions.path}');
      print('❌ Request method: ${e.requestOptions.method}');
      print('❌ ===================================\n');
      rethrow;
    } catch (e) {
      print('\n❌ ========== GENERAL EXCEPTION ==========');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ ===================================\n');
      rethrow;
    }
  }
}
