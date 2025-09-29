import '../../../../../shared/aplication/exceptions/base_exception.dart';
import '../../../../../shared/aplication/utils/safed.dart';
import '../../../../../shared/data/data.dart';
import '../../dto/login_dto.dart';
import '../../dto/resend_otp_dto.dart';
import '../../dto/set_info_dto.dart';
import '../../dto/verify_otp_dto.dart';
import '../../requests/login_request.dart';
import '../../requests/resend_otp_request.dart';
import '../../requests/set_info_request.dart';
import '../../requests/verify_otp_request.dart';

final class AuthRemoteSource extends RemoteSource {
  AuthRemoteSource({required super.client});

  Future<Safed<BaseException, LoginDto>> login({
    required LoginRequest request,
  }) async {
    return await apiPost(path: "/login", request: request).map(
      success: dataFactory(LoginDto.fromJson),
    );
  }

  Future<Safed<BaseException, VerifyOtpDto>> verifyOtp({
    required VerifyOtpRequest request,
  }) async {
    return await apiPost(path: "/verify-otp", request: request).map(
      success: dataFactory(VerifyOtpDto.fromJson),
    );
  }

  Future<Safed<BaseException, ResendOtpDto>> resendOtp({
    required ResendOtpRequest request,
  }) async {
    return await apiPost(path: "/resend-otp", request: request).map(
      success: dataFactory(ResendOtpDto.fromJson),
    );
  }

  Future<Safed<BaseException, SetInfoDto>> setInfo({
    required SetInfoRequest request,
  }) async {
    return await apiPost(path: "/set-info", request: request).map(
      success: dataFactory(SetInfoDto.fromJson),
    );
  }
}
