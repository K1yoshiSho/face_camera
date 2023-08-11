part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

final class PostImage extends HomeEvent {
  final FormData formData;
  final File file;
  const PostImage({required this.formData, required this.file});
  @override
  List<Object?> get props => [];
}
