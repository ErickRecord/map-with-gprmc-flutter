import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/src/widgets/text_field_widget.dart';

class HomeProvider extends ChangeNotifier {
  // Form
  GlobalKey<FormState> form = GlobalKey<FormState>();

  // Controllers
  final TextEditingController latitudeController = TextEditingController(
      // text: "20.370640"
      );
  final TextEditingController longController = TextEditingController(
      // text: "-102.022097"
      );

  // Map controller
  GoogleMapController? mapController;

  MapType mapType = MapType.normal;

  CameraPosition coordinates = const CameraPosition(
    target: LatLng(20.364851, -102.040803),
    zoom: 14.4746,
  );

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
    latitudeController.clear();
    longController.clear();
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("Selecciona las coordenadas"),
              content: Material(
                color: Colors.transparent,
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      TextFieldWidget(
                          controller: latitudeController,
                          fieldName: "Latitud",
                          textInputAction: TextInputAction.next),
                      TextFieldWidget(
                          controller: longController,
                          fieldName: "Longitud",
                          textInputAction: TextInputAction.done)
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
      final double lat = double.tryParse(latitudeController.text) ?? 0.0;
      final double lng = double.tryParse(longController.text) ?? 0.0;
      final newCoordinates =
          CameraPosition(target: LatLng(lat, lng), zoom: 17.0);
      _addMarker(lat, lng);
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

  @override
  void dispose() {
    super.dispose();
    latitudeController.dispose();
    longController.dispose();
    mapController!.dispose();
  }
}
