// ignore_for_file: use_build_context_synchronously

import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_event.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/views/main_popup_menu_button.dart';
import 'package:bloc_tutorial/views/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends StatelessWidget {
  const PhotoGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    final images = context.watch<AppBloc>().state.images ??
        []; // Now correctly handling URLs

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image == null) return;
              context
                  .read<AppBloc>()
                  .add(AppEventUploadImage(filePathToUpload: image.path));
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: images.isEmpty
          ? const Center(child: Text("No images uploaded yet."))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return StorageImageView(
                    imageUrl: images[index]); // Pass URL directly
              },
            ),
    );
  }
}
