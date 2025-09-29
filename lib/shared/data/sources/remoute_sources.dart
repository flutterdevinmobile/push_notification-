part of '../data.dart';

abstract class RemoteSource {
  @protected
  final Dio client;

  RemoteSource({required this.client});

  @protected
  D Function(Json json) dataFactory<D extends JsonDto>(
    D Function(Json json) factory,
  ) {
    return (json) => factory(switch (json) {
          {"data": Json data} => data,
          _ => json,
        });
  }

  @protected
  Future<Safed<BaseException, Json>> apiGet({
    required String path,
    required RemoteRequest request,
  }) async {
    return apiFetch(
      path: path,
      method: 'GET',
      request: request,
    );
  }

  @protected
  Future<Safed<BaseException, Json>> apiPost({
    required String path,
    required RemoteRequest request,
  }) async {
    return apiFetch(
      path: path,
      method: 'POST',
      request: request,
    );
  }

  @protected
  Future<Safed<BaseException, Json>> apiPatch({
    required String path,
    required RemoteRequest request,
  }) async {
    return apiFetch(
      path: path,
      method: 'PATCH',
      request: request,
    );
  }

  @protected
  Future<Safed<BaseException, Json>> apiPut({
    required String path,
    required RemoteRequest request,
  }) async {
    return apiFetch(
      path: path,
      method: 'PUT',
      request: request,
    );
  }

  @protected
  Future<Safed<BaseException, Json>> apiPostMultipart({
    required String path,
    required FormData formData,
  }) async {
    try {
      final response = await client.post<Json>(
        path,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.data case Json json) return Success(json);

      return Failure(
        NetworkException(
          title: "Invalid response",
          description: "The response is not a valid JSON object"
              ":\n${response.data}",
          code: response.statusCode ?? 0,
          origin: response.data,
          stackTrace: StackTrace.current,
        ),
      );
    } on DioException catch (e, stack) {
      return Failure(
        NetworkException(
          title: "Network error",
          description: e.message ?? 'Unknown error',
          code: e.response?.statusCode ?? 0,
          origin: e,
          stackTrace: stack,
        ),
      );
    } catch (e, stackTrace) {
      return Failure(
        NetworkException(
          title: "Unknown error",
          description: e.toString(),
          code: 0,
          origin: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @protected
  Future<Safed<BaseException, Json>> apiDelete({
    required String path,
    required RemoteRequest request,
  }) async {
    return apiFetch(path: path, method: 'DELETE', request: request);
  }

  @protected
  Future<Safed<BaseException, Json>> apiFetch({
    required String path,
    required String method,
    required RemoteRequest request,
  }) async {
    try {
      final computedPath = request.path().entries.fold(
            path,
            (computed, entry) =>
                computed.replaceAll('{${entry.key}}', entry.value),
          );

      final response = await client.fetch<Json>(
        Options(method: method, responseType: ResponseType.json).compose(
          client.options,
          computedPath,
          queryParameters: request.query(),
          data: method.toLowerCase() == "get" ? null : request.data(),
        ),
      );

      if (response.data case Json json) return Success(json);

      return Failure(
        NetworkException(
          title: "Invalid response",
          description: "The response is not a valid JSON object"
              ":\n${response.data}",
          code: response.statusCode ?? 0,
          origin: response.data,
          stackTrace: StackTrace.current,
        ),
      );
    } on DioException catch (e, stack) {
      String? serverMessage;

      // Swagger formatini tekshirish
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('error') && data['error'] is Map) {
          final err = data['error'];
          if (err['message'] is String) {
            serverMessage = err['message'] as String;
          }
        } else if (data.containsKey('detail') && data['detail'] is String) {
          serverMessage = data['detail'] as String;
        }
      }
      final statusCode = e.response?.statusCode ?? 0;

      // 400 Bad Request bo‘lsa WrongDataException qaytarish
      if (statusCode == 400 && serverMessage != null) {
        return Failure(
          WrongDataException(
            message: serverMessage,
            description: '',
            origin: e,
            stackTrace: stack,
          ),
        );
      }

      // 401 Unauthorized bo‘lsa maxsus Exception qaytarish
      if (statusCode == 401) {
        return Failure(
          UnauthorizedException(
            message: serverMessage ?? 'Unauthorized',
            origin: e,
            stackTrace: stack,
          ),
        );
      }

      return Failure(
        NetworkException(
          title: "Network error",
          description: serverMessage ?? e.message ?? 'Unknown error',
          code: e.response?.statusCode ?? 0,
          origin: e,
          stackTrace: stack,
        ),
      );
    } catch (e, stackTrace) {
      return Failure(
        NetworkException(
          title: "Unknown error",
          description: e.toString(),
          code: 0,
          origin: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
