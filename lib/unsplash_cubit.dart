import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:unsplash_gallery_cubit/models/photo.dart';

// Define the states
abstract class UnsplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnsplashInitialState extends UnsplashState {}

class UnsplashLoadingState extends UnsplashState {}

class UnsplashLoadedState extends UnsplashState {
  final List<Photo> photos;

  UnsplashLoadedState(this.photos);

  @override
  List<Object?> get props => [photos];
}

class UnsplashErrorState extends UnsplashState {}

// Define the Cubit
class UnsplashCubit extends Cubit<UnsplashState> {
  UnsplashCubit() : super(UnsplashInitialState());

  Future<void> fetchPhotos() async {
    emit(UnsplashLoadingState());

    try {
      //get the data  by using API, I'm providing here my access key
      final response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos/random?client_id=HmYgS_74GVha43Gy1hUhWM408tO9YVLLPXA5D7gsbDo&count=10'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Photo> photos =
            data.map((item) => Photo.fromJson(item)).toList();

        emit(UnsplashLoadedState(photos));
      } else {
        emit(UnsplashErrorState());
      }
    } catch (e) {
      emit(UnsplashErrorState());
    }
  }
}
