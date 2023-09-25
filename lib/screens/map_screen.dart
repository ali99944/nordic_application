import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/services/map_service.dart';
import 'package:car_app/services/zones_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart' as MX;
import 'package:permission_handler/permission_handler.dart';

class MapsScreen extends StatefulWidget {
  static const String route = '/maps';
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Map? zone;
  late Future future;


  void initializePermission() async{
    if(await Permission.location.isDenied){
      Permission.location.request();
    }
  }

  void initializeZone(Future xc) async{
    zone = (await future).first;

    setState(() {});
  }

  @override
  void initState() {
    future = ZoneService.getAllZones();
    initializePermission();
    super.initState();
    initializeZone(future);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              'Velg Sone først',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.data != null) {
                  List zones = snapshot.data;
                  if (zones.isEmpty) {
                    return Center(
                      child: Text('Ingen soner ennå'),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: zones.map((e) {
                        return Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                zone = e;
                              });

                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeHelper.buttonPrimaryColor,
                                minimumSize: Size(110, 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            child: Text(
                              e['name'],
                              style: TextStyle(
                                  fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }

                return Container();
              },
            ),
              if(zone != null)
              Expanded(
                child: MapSample(zone: zone),
              ),
          ],
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  final Map? zone;
  const MapSample({super.key, required this.zone});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _controller;
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Marker> _markers = Set<Marker>();



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MapService.downloadMapFeatures(widget.zone!['_id']),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString().replaceAll('"', ''),style: TextStyle(
              fontSize: 20
            ),),
          );
        }
        if (snapshot.data != null) {
          _markers.clear();
          _polygons.clear();
          final geoJsonText = snapshot.data['data'];
          final geoJson = jsonDecode(geoJsonText);

          List features = geoJson['features'];
          print(features.length.toString());
          for(var feature in features){
            if(feature['geometry']['type'] == 'Polygon'){
              var coords = feature['geometry']['coordinates'];
              List<LatLng> points = [];
              for(var coord in coords[0]){
                points.add(LatLng(coord[1],coord[0]));
              }
              Polygon polygon = Polygon(
                polygonId: PolygonId('${Random().nextInt(100000000).toString()}'),
                points: points,
                fillColor: HexColor.fromHex(feature['properties']['color'] ?? "#5088DD").withOpacity(0.3),
                strokeWidth: 0,
                onTap: () async{
                  final availableMaps = await MX.MapLauncher.installedMaps;
                  print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                  await availableMaps.first.showMarker(
                    coords: MX.Coords(points[0].latitude, points[0].longitude),
                    title: "Ocean Beach",
                  );
                },
                consumeTapEvents: true,
                zIndex: 5,

              );

              // setState(() {
                _polygons.add(polygon);
              // });
            }else if(feature['geometry']['type'] == 'Point'){

              final List<dynamic> markerData = feature['geometry']['coordinates'];
              final LatLng markerLatLng = LatLng(
                double.parse(markerData[1].toString()),
                double.parse(markerData[0].toString()),
              );

              Marker marker = Marker(
                markerId: MarkerId('${Random().nextInt(100000000).toString()}'),
                position: markerLatLng,
                // Add other marker properties as needed
                infoWindow: InfoWindow(
                    title: feature['properties']['title'] ?? 'Tittel',
                    snippet: feature['properties']['body'] ?? 'Markeringsutdrag',
                    onTap: () async{
                      final availableMaps = await MX.MapLauncher.installedMaps;
                      print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                      await availableMaps.first.showMarker(
                        coords: MX.Coords(markerData[1], markerData[0]),
                        title: "Nordic",
                      );
                    }
                ),
              );

              // setState(() {
                _markers.add(marker);
              // });
            }
          }

          return GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(snapshot.data['latitude'].toString()),
                    double.parse(snapshot.data['longitude'].toString())),
                zoom: 12),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) async{
              _controller = controller;
            },
            polygons: _polygons,

            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
    );
        }

        return Container();
      },
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
