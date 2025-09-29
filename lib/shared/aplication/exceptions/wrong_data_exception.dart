import '../aplication.dart';

final class WrongDataException extends BaseException {
  final String description;
  const WrongDataException({
    required super.message,
    required this.description,
    super.origin,
    required super.stackTrace,
  });

  @override
  List<Object> get props => [
        "title: $message",
        'description: $description',
        'origin: $origin',
        'stackTrace: $stackTrace',
      ];
}
