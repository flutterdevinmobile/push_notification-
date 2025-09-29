import '../../../../shared/domain/domain.dart';

final class SetInfoModel extends Model {
  final String message;

  const SetInfoModel({required this.message});

  @override
  List<String> get props => [
        "message: $message",
      ];
}
