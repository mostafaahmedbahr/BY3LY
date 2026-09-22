import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../features/layout/presentation/view_model/layout_cubit.dart';
import '../../errors/failure.dart';
import '../../routing/app_router.dart';
import '../../routing/routes.dart';
import '../local_services/cache_helper.dart';
import '../local_services/cache_token.dart';
import 'end_points.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = EndPoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Attach interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add default headers
          options.headers["Accept"] = "application/json";
          options.headers["Content-Type"] = "application/json";

          // Add user token if available
          if (CacheTokenManger.userToken != null &&
              CacheTokenManger.userToken!.isNotEmpty) {
            options.headers["Authorization"] =
                "Bearer ${CacheTokenManger.userToken}";
          }

          debugPrint("➡️ [REQUEST] ${options.method} ${options.uri}");
          debugPrint("Headers: ${options.headers}");
          debugPrint("Data: ${options.data}");
          debugPrint("Query: ${options.queryParameters}");

          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          debugPrint(
            "✅ [RESPONSE] [${response.statusCode}] ${response.requestOptions.uri}",
          );
          debugPrint("Response Data: ${response.data}");
          return handler.next(response); // continue
        },
        onError: (DioException error, handler) async {
          debugPrint("❌ [ERROR] ${error.message}");
          debugPrint("Request: ${error.requestOptions.uri}");
          // Example: handle token expiration (401 Unauthorized)
          final failure = ServerFailure.fromDioError(error);
          debugPrint("❌ [ERROR] ${failure.errMessage}");
          if (error.response?.statusCode == 401) {
            // for some reasons the token can be invalidated before it is expired by the backend.
            // then we should navigate the user back to login page
            _performLogout();
          }
          return handler.reject(error.copyWith(error: failure));
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<void> _performLogout() async {
    CacheTokenManger.userToken = null;
    CacheTokenManger.clearUserToken();
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    await CacheHelper.clearUserData();
    LayoutCubit.pageIndex = 0;
    
    // Show error toast and navigate to login
    if (getIt<AppRouter>().navigatorKey.currentContext != null) {
      Toast.showErrorToast(
        msg: LocaleKeys.youLoggedOutPleaseLoginAgain.tr(),
        context: getIt<AppRouter>().navigatorKey.currentContext!
      );
      getIt<AppRouter>().navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.loginView,
        (route) => false,
      );
    }
  }
  // Now no need to manually add headers everywhere
  Future<Response> postData({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? query,
    bool isMultipart = false,
  }) async {
    if (isMultipart) {
      _dio.options.headers["Content-Type"] = "multipart/form-data";
    }
    return await _dio.post(endPoint, data: data, queryParameters: query);
  }

  Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    return await _dio.get(endPoint, queryParameters: query);
  }

  Future<Response> putData({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return await _dio.put(endPoint, data: data, queryParameters: query);
  }

  Future<Response> deleteData({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return await _dio.delete(endPoint, data: data, queryParameters: query);
  }
}
