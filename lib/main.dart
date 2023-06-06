import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_gallery_cubit/unsplash_cubit.dart';
import 'package:unsplash_gallery_cubit/models/photo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(UnsplashGalleryApp());
}

class UnsplashGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unsplash Gallery by Dilfina',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: BlocProvider(
        create: (context) => UnsplashCubit(),
        child: GalleryScreen(),
      ),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unsplashCubit = context.read<UnsplashCubit>();
    unsplashCubit.fetchPhotos();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text('Unsplash Gallery by Dilfina'),
      ),
      body: BlocBuilder<UnsplashCubit, UnsplashState>(
        builder: (context, state) {
          if (state is UnsplashInitialState || state is UnsplashLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UnsplashLoadedState) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                final photo = state.photos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imageUrl: photo.url,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: photo.url,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is UnsplashErrorState) {
            return const Center(
                child: Text('Error occurred while loading photos.'));
          }

          return Container();
        },
      ),
    );
  }
}

//Created this widget to show the image in full screen when clicking
class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  final double minScale = 1;
  final double maxScale = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        //this widget enables to zoom images by specifiying below parameters!
        child: InteractiveViewer(
          panEnabled: false,
          minScale: minScale,
          maxScale: maxScale,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.imageUrl), fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
