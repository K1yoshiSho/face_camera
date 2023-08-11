part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();
  @override
  List<Object?> get props => [];
}

final class HomeFetched extends HomeState {
  final User user;
  final File file;
  const HomeFetched({required this.user, required this.file});
  @override
  List<Object?> get props => [];
}

final class HomeFailure extends HomeState {
  final String error;
  final DioException? errorDio;
  const HomeFailure({
    required this.error,
    this.errorDio,
  });

  @override
  List<Object> get props => [error, errorDio ?? ''];
}
