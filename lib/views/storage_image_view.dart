import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageImageView extends StatelessWidget {
  final String imageUrl;

  const StorageImageView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('error: $error');
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        headers: {
          'X-Appwrite-Project': dotenv.get('APPWRITE_PROJECT_ID'),
        },
      ),
    );
  }
}
