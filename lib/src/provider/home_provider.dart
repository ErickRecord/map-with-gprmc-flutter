import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/src/widgets/text_field_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeProvider extends ChangeNotifier {
  // Form
  GlobalKey<FormState> form = GlobalKey<FormState>();

  // Controllers
  final TextEditingController gpsController = TextEditingController();

  // Map controller
  GoogleMapController? mapController;

  MapType mapType = MapType.normal;

  CameraPosition coordinates = const CameraPosition(
    target: LatLng(20.364851, -102.040803),
    zoom: 14.4746,
  );

  Map? latLongTime;

  // Default marker
  final Set<Marker> markers = {
    const Marker(
      markerId: MarkerId("location"),
      position: LatLng(20.364851, -102.040803),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: "Ubicación"),
    )
  };

  void modalTypeMap(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("Selecciona El tipo de mapa"),
              content: Material(
                color: Colors.transparent,
                child: Form(
                  key: form,
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.green,
                          ),
                        ),
                        errorStyle: TextStyle(fontWeight: FontWeight.bold),
                        hintText: "",
                      ),
                      value: mapType,
                      items: getDropdownMenuItems(),
                      onChanged: (MapType? value) {
                        mapType = value!;
                        notifyListeners();
                        Navigator.pop(context);
                      }),
                ),
              ),
            ));
  }

  List<DropdownMenuItem<MapType>> getDropdownMenuItems() {
    List<DropdownMenuItem<MapType>> dropdownMenuItem = [];
    final List<String> map = ["Normal", "Satelital", "Terreno", "Hibrido"];
    final List<MapType> mapType = [
      MapType.normal,
      MapType.satellite,
      MapType.terrain,
      MapType.hybrid
    ];
    for (int i = 0; i < map.length; i++) {
      dropdownMenuItem.add(DropdownMenuItem(
        value: mapType[i],
        child: Text(map[i]),
      ));
    }
    return dropdownMenuItem;
  }

  void modalUbication(BuildContext context) {
    gpsController.clear();
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("Ingresa el GPRMC"),
              content: Material(
                color: Colors.transparent,
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      ChangeNotifierProvider.value(
                          value: this,
                          child: TextFieldWidget(controller: gpsController)),
                    ],
                  ),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => _setLatLng(context),
                    child: const Text("Cargar"))
              ],
            ));
  }

  void _setLatLng(BuildContext context) {
    if (form.currentState!.validate()) {
      latLongTime = ubication(gpsController.text);
      final lat = double.parse(latLongTime!["lat"]);
      final long = double.parse(latLongTime!["long"]);

      final newCoordinates =
          CameraPosition(target: LatLng(lat, long), zoom: 17.0);
      _addMarker(lat, long);
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(newCoordinates));
      Navigator.pop(context);
    }
  }

  void _addMarker(double lat, double lng) {
    const MarkerId markerId = MarkerId("location");

    // First, we delete the previous marker if it exists
    markers.removeWhere((marker) => marker.markerId == markerId);

    final Marker marker = Marker(
      markerId: const MarkerId("location"),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(title: "Ubicación"),
    );

    markers.add(marker); // Add the new bookmark to the bookmark list
    notifyListeners(); // Redraw
  }

  Map<String, dynamic>? ubication(String gpgga) {
    // We create a list to store the divided elements
    List<String> array = [];

    // We create a temporary chain to build each element
    String element = "";

    // We traverse the input string character by character
    for (int i = 0; i < gpgga.length; i++) {
      String character = gpgga[i];

      // If we find a comma, it is an element delimiter
      if (character == ',') {
        // We add the element built up to this point to the list
        array.add(element);
        // We reset the element chain
        element = "";
      }
      // If it is not a comma, we simply add the character to the current element
      else {
        element += character;
      }
    }

    // We add the last element to the array if it is not empty
    if (element.isNotEmpty) {
      array.add(element);
    }

    if (array[0] == r"$GPRMC") {
      final isNorth = (array[4] == "N") ? 1 : -1;
      final isWest = (array[6] == "W") ? -1 : 1;

      final lat = array[3];
      final long = array[5];

      final latFinal = (int.parse(lat.substring(0, 2)) +
              (double.parse(lat.substring(2)) / 60)) *
          isNorth;
      final longFinal = (int.parse(long.substring(0, 3)) +
              (double.parse(long.substring(3)) / 60)) *
          isWest;

      // Extract time (HHMMSS.SSS)
      final time = array[1];

      // Extract date
      final date = array[9];

// Get day, month and year from date string
      String day = date.substring(0, 2);
      String month = date.substring(2, 4);
      String year = date.substring(4, 6);

      // Parse time string in "HHmmss" format
      String hours = time.substring(0, 2);
      String minutes = time.substring(2, 4);
      String seconds = time.substring(4, 6);

      // I format the date
      String formattedDate = "20$year-$month-$day";
      String formattedTime = "$hours:$minutes:${seconds}Z";

      final dateTimeFormatted = DateFormat('dd-MM-yyyy hh:mm:ss a')
          .format(DateTime.parse('$formattedDate $formattedTime').toLocal());

      return {
        "lat": latFinal.toStringAsFixed(6),
        "long": longFinal.toStringAsFixed(6),
        "dateTime": dateTimeFormatted
      };
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    gpsController.dispose();
    mapController!.dispose();
  }
}
