import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/src/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MapState();
}

class _MapState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("El maperi"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: GoogleMap(
        mapToolbarEnabled: false,
        mapType: provider.mapType,
        zoomControlsEnabled: false,
        initialCameraPosition: provider.coordinates,
        onMapCreated: (GoogleMapController controller) {
          provider.mapController = controller;
        },
        markers: provider.markers,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => provider.modalTypeMap(context),
            backgroundColor: Colors.green,
            child: const Icon(Icons.map),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () => provider.modalUbication(context),
            backgroundColor: Colors.green,
            child: const Icon(Icons.route_outlined),
          ),
        ],
      ),
      bottomNavigationBar: (provider.latLongTime?["dateTime"] != null)
          ? Text(
              "Fecha de consulta:\n ${provider.latLongTime!["dateTime"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          : null,
    );
  }
}
