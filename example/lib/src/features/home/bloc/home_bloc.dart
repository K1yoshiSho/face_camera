import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:face_camera_example/src/features/home/models/user.dart';
import 'package:face_camera_example/src/features/home/resource/home_repository.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepositoryImpl repository = HomeRepositoryImpl();
  HomeBloc() : super(const HomeInitial()) {
    on<PostImage>((event, emit) => repository.postImage(event, emit));

    on<ChangeState>((event, emit) => emit(event.state));
  }
}
