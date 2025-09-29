import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rentify_nitification/features/auth/domain/payloads/fcm_number_payload.dart';

import '../../../../shared/aplication/exceptions/base_exception.dart';
import '../../../../shared/aplication/utils/safed.dart';
import '../../../../shared/data/data.dart';
import '../../domain/models/login_model.dart';
import '../../domain/models/resend_otp_model.dart';
import '../../domain/models/set_info_model.dart';
import '../../domain/models/verify_otp_model.dart';
import '../../domain/payloads/login_payload.dart';
import '../../domain/payloads/resend_otp_payload.dart';
import '../../domain/payloads/set_info_payload.dart';
import '../../domain/payloads/verify_otp_payload.dart';
import '../../domain/repository/auth_repository.dart';
import '../requests/fcm_number_request.dart';
import '../requests/login_request.dart';
import '../requests/resend_otp_request.dart';
import '../requests/set_info_request.dart';
import '../requests/verify_otp_request.dart';
import '../source/remote/auth_remote_source.dart';
import '../source/remote/fcm_remote_source.dart';

final class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteSource remote;
  final FcmRemoteSource remoteFcm;
  final HiveLocalSource local;

  AuthRepositoryImpl(
      {required this.remote, required this.local, required this.remoteFcm});
  @override
  Future<Safed<BaseException, LoginModel>> login({
    required LoginPayload payload,
  }) async {
    return await remote
        .login(
          request: LoginRequest.fromPayload(payload),
        )
        .map(
          success: (dto) => dto.model(),
        );
  }

  @override
  Future<Safed<BaseException, ResendOtpModel>> resendOtp({
    required ResendOtpPayload payload,
  }) async {
    return await remote
        .resendOtp(
          request: ResendOtpRequest.fromPayload(payload),
        )
        .map(
          success: (dto) => dto.model(),
        );
  }

  @override
  Future<Safed<BaseException, VerifyOtpModel>> verifyOtp({
    required VerifyOtpPayload payload,
  }) async {
    final Safed<BaseException, VerifyOtpModel> response = await remote
        .verifyOtp(
          request: VerifyOtpRequest.fromPayload(payload),
        )
        .map(
          success: (dto) => dto.model(),
        );

    await response.when(
      success: (model) async {
        await local.saveToken(model.token);

        final deviceToken = await FirebaseMessaging.instance.getToken();

        if (deviceToken != null) {
          await remoteFcm.createOrUpdateUser(
            request: FcmNumberRequest.fromPayload(
              FcmNumberPayload(
                  fcmNumber: "+998940460100", deviceToken: deviceToken),
            ),
          );
        }
      },
      failure: (_) async {},
    );

    return response;
  }

  @override
  Future<Safed<BaseException, SetInfoModel>> setInfo({
    required SetInfoPayload payload,
  }) async {
    return await remote
        .setInfo(
          request: SetInfoRequest.fromPayload(payload),
        )
        .map(
          success: (dto) => dto.model(),
        );
  }
}
