part of 'set_info_bloc.dart';

sealed class SetInfoEvent extends Equatable {
  const SetInfoEvent();

  @override
  List<Object> get props => [];
}

final class SetInfoStarted extends SetInfoEvent {
  final String name;
  final String? description;

  const SetInfoStarted({
    required this.name,
    this.description,
  });

  @override
  List<Object> get props => [
        "name: $name",
        "description: $description",
      ];
}
