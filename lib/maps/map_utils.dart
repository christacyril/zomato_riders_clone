import 'package:url_launcher/url_launcher.dart';

class MapUtils {


  MapUtils._();

  static void launchMapFromSourceToDestination(sourceLat, sourceLng, destinationLat, destinationLng) async{
    final uri = Uri(
      scheme: "google.navigation",
      queryParameters :{
        'q' : '$destinationLat, $destinationLng'
      }
    );

    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    } else {
      print("An error occurred");
    }
  }

}
