import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class NetworkService {
  Future<void> saveImageToGallery(String imageUrl) async {
    // HTTP isteği ile resmi indir
    var response = await http.get(Uri.parse(imageUrl));

    // Uygulamanın dökümanlar dizini yolunu al
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Dosyanın adını belirle
    String fileName = imageUrl.split('/').last;

    // Galeriye kaydedilecek dosyanın tam yolu
    String filePath = '${appDocDir.path}/$fileName';

    // Dosyayı oluştur ve içeriğini kaydet
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    // Galeriye eklemek için dosyayı medya taramasına bildir
    await ImageGallerySaver.saveFile(filePath);
  }

  Future<Uint8List> downloadImage(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Resim indirilemedi. HTTP kodu: ${response.statusCode}');
    }
  }
}
