part of '../data.dart';

class DioClient {
  final HiveLocalSource hiveLocalSource;
  final Talker talker;

  /// Bu flag modal faqat bir marta ochilishi uchun
  static bool _isLoginModalOpen = false;

  DioClient({required this.hiveLocalSource, required this.talker});

  Dio createDioClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://185.225.233.197:8001/api",
        contentType: "application/json",
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = hiveLocalSource.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final currentLocale =
              EasyLocalization.of(rootNavigatorKey.currentContext!)?.locale;
          if (currentLocale != null) {
            options.headers['Accept-Language'] = currentLocale.languageCode;
          }

          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final context = rootNavigatorKey.currentContext;

            if (context != null && !_isLoginModalOpen) {
              _isLoginModalOpen = true;

              Future.microtask(() async {
                await LoginRequiredBottomSheet.show(context);
                _isLoginModalOpen = false; // yopilgandan keyin reset qilamiz
              });
            }
          }
          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          hiddenHeaders: {"Authorization"},
        ),
      ),
    );

    return dio;
  }
}
