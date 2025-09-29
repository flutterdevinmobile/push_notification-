import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../shared/aplication/exceptions/base_exception.dart';
import '../../../../../shared/aplication/exceptions/connection_exception.dart';
import '../../../../../shared/aplication/utils/safed.dart';
import '../../dto/fcm_user_dto.dart';
import '../../requests/fcm_number_request.dart';

final class FcmRemoteSource {
  final FirebaseFirestore firestore;

  FcmRemoteSource({required this.firestore});

  Future<Safed<BaseException, FcmUserDto>> createOrUpdateUser({
    required FcmNumberRequest request,
  }) async {
    try {
      final docRef = firestore.collection("users").doc(request.fcmNumber);

      await docRef.set(
        {
          "deviceTokens": FieldValue.arrayUnion([request.deviceToken]),
          "isActive": true,
        },
        SetOptions(merge: true),
      );

      final snapshot = await docRef.get();
      final json = snapshot.data() ?? {};

      return Success(FcmUserDto.fromJson(json));
    } catch (e, st) {
      return Failure(
        NetworkException(
          title: "Firestore Error",
          description: e.toString(),
          code: -1,
          origin: e,
          stackTrace: st,
        ),
      );
    }
  }
}
