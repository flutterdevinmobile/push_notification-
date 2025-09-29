import 'base_exception.dart';

class UnauthorizedException extends BaseException {
  const UnauthorizedException({
    required super.message,
    super.origin,
    required super.stackTrace,
  });
}
