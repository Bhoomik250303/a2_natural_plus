import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class LocationServices {
  final location = Location();
  var locationData;
  gettingLocationData() async {
    locationData = await Location().getLocation();
  }

  checkingServiceAvailability() async {
    var isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      isEnabled = await location.requestService();
      if (!isEnabled) {
        Fluttertoast.showToast(msg: 'Allow Location');
        return;
      }
    }
  }

  gettingPermission() async {
    var _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if (_permission != PermissionStatus.granted) {
        return;
      }
    }
  }
}
