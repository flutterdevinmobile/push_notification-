import '../../shared.dart';

final class NetworkException extends BaseException {
  final String title;

  final String? description;

  final int code;

  const NetworkException({
    required this.title,
    required this.description,
    required this.code,
    super.origin,
    required super.stackTrace,
  }) : super(message: title);

  @override
  String get message => title + (description != null ? ":\n$description" : "");

  @override
  List<Object> get props => [
        "title: $title",
        "description: $description",
        'code: $code',
        'origin: $origin',
        'stackTrace: $stackTrace',
      ];
}
