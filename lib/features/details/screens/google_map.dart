import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapMerchant extends StatefulWidget {
  final List<double>? latlon;
  final String? placeTitle;
  const GoogleMapMerchant({super.key, this.latlon, this.placeTitle});

  @override
  State<GoogleMapMerchant> createState() => _GoogleMapMerchantState();
}

class _GoogleMapMerchantState extends State<GoogleMapMerchant> {
  Completer<GoogleMapController> mapController = Completer();
  List<Marker> marker = [];

  @override
  void initState() {
    marker.add(
      Marker(
        markerId: const MarkerId('1'),
        position: LatLng(
          widget.latlon![0],
          widget.latlon![1],
        ),
        infoWindow: InfoWindow(title: widget.placeTitle),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              context.pop();
            },
            iconSize: 20),
      ),
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.latlon![0],
            widget.latlon![1],
          ),
          zoom: 14,
        ),
        mapType: MapType.normal,
        markers: Set<Marker>.of(marker),
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
        },
      ),
    );
  }
}
