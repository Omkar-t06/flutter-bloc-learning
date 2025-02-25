import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as devtool show log;

class StorageService {
  final Client client = Client();
  late final Storage _storage;
  final String bucketId = dotenv.get('APPWRITE_BUCKET_ID');

  StorageService() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(dotenv.get('APPWRITE_PROJECT_ID'));
    _storage = Storage(client);
  }

  Storage get storage => _storage;

  /// Uploads an image to Appwrite Storage and returns the file ID.
  Future<String?> uploadImage({
    required String filePath,
    required String userId,
  }) async {
    try {
      final fileId = ID.unique();
      await _storage.createFile(
        bucketId: bucketId,
        fileId: fileId,
        file: InputFile.fromPath(path: filePath),
      );
      return fileId;
    } catch (e) {
      devtool.log('Upload error: $e');
      return null;
    }
  }

  /// Fetches user's uploaded images and returns a list of file preview URLs.
  Future<List<String>> getUserImages(String userId) async {
    try {
      final result = await _storage.listFiles(bucketId: bucketId);
      final imageUrls = result.files
          .map((file) => getFilePreview(
                file.$id,
              ))
          .toList();
      return imageUrls;
    } catch (e) {
      devtool.log('Error fetching images: $e');
      return [];
    }
  }

  /// Returns the file preview URL
  String getFilePreview(String fileId) {
    return "https://cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/view?project=${dotenv.get('APPWRITE_PROJECT_ID')}";
  }
}
