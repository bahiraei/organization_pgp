part of 'phone_bloc.dart';

abstract class PhoneEvent extends Equatable {
  const PhoneEvent();
}

class PhoneStarted extends PhoneEvent {
  final bool isRefreshing;
  final String? searchTag;

  const PhoneStarted({
    required this.isRefreshing,
    required this.searchTag,
  });

  @override
  List<Object?> get props => [
        isRefreshing,
        searchTag,
      ];
}
