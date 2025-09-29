import '../../../../shared/shared.dart';
import '../models/login_model.dart';
import '../models/resend_otp_model.dart';
import '../models/set_info_model.dart';
import '../models/verify_otp_model.dart';
import '../payloads/login_payload.dart';
import '../payloads/resend_otp_payload.dart';
import '../payloads/set_info_payload.dart';
import '../payloads/verify_otp_payload.dart';

abstract class AuthRepository extends Repository {
  Future<Safed<BaseException, LoginModel>> login({
    required LoginPayload payload,
  });

  Future<Safed<BaseException, VerifyOtpModel>> verifyOtp({
    required VerifyOtpPayload payload,
  });

  Future<Safed<BaseException, ResendOtpModel>> resendOtp({
    required ResendOtpPayload payload,
  });

  Future<Safed<BaseException, SetInfoModel>> setInfo({
    required SetInfoPayload payload,
  });
}
