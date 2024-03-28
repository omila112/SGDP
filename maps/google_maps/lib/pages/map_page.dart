import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng pGoogleplex = LatLng(6.9271, 79.8612);
  static const LatLng pApplePark = LatLng(6.8301, 79.8801);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: GoogleMap(
          initialCameraPosition:CameraPosition(
            target: pGoogleplex,
            zoom: 15
          ),
          markers: {
            Marker(
              markerId: MarkerId("_currentlocation"), 
              icon: BitmapDescriptor.defaultMarker,
              position: pGoogleplex)
             ignore: const_set_element_type_implements_equals
             
             Marker(
              markerId: MarkerId("_sourcelocation"), 
              icon: BitmapDescriptor.defaultMarker,
              position: pApplePark)
              
          },
        )
     );
  }
}
