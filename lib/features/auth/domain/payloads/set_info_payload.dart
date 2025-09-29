import '../../../../shared/domain/domain.dart';

final class SetInfoPayload extends Payload {
  final String name;
  final String? description;

  const SetInfoPayload({
    this.description,
    required this.name,
  });

  @override
  List<Object> get props => [
        "name: $name",
        "description: $description",
      ];
}
