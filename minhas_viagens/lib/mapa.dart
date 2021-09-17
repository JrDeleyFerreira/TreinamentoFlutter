import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class Mapa extends StatefulWidget {
  String? idViagem;

  Mapa({Key? key, this.idViagem}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final Completer<GoogleMapController> _completerController = Completer();
  Set<Marker> _listaMarcadores = {};
  CameraPosition _posicaoCamera = const CameraPosition(
    target: LatLng(-23.562436, -46.655005),
    zoom: 18,
  );
  final FirebaseFirestore _banco = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _recuperarViagemID(widget.idViagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: GoogleMap(
        initialCameraPosition: _posicaoCamera,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        onLongPress: _adicionarMarcador,
        markers: _listaMarcadores,
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) =>
      _completerController.complete(controller);

  _adicionarMarcador(LatLng latLng) async {
    var locais = GeocodingPlatform.instance;
    var listaEnderecos = await locais.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);

    if (listaEnderecos.isNotEmpty) {
      var endereco = listaEnderecos[0];
      var rua = endereco.thoroughfare;

      Marker marcador = Marker(
        markerId: MarkerId('${latLng.latitude}|${latLng.longitude}'),
        position: latLng,
        infoWindow: InfoWindow(title: rua),
      );
      setState(() {
        _listaMarcadores.add(marcador);

        Map<String, dynamic> viagem = {};
        viagem['titulo'] = rua;
        viagem['latitude'] = latLng.latitude;
        viagem['longitude'] = latLng.longitude;
        _banco.collection('viagens').add(viagem);
      });
    }
  }

  _adicionarLitenerLocalizacao() {
    var geolocator =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
            .listen((position) => setState(() {
                  _posicaoCamera = CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                  );
                  _movimentaCamera();
                }));
  }

  _movimentaCamera() async {
    var googleMapController = await _completerController.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _recuperarViagemID(String? idViagem) async {
    if (idViagem != null) {
      var docSnapshot = await _banco.collection('viagens').doc(idViagem).get();
      var dados = docSnapshot.data();
      var titulo = dados?['titulo'];
      var latLng = LatLng(dados?['latitude'], dados?['longitude']);

      setState(() {
        Marker marcador = Marker(
          markerId: MarkerId('${latLng.latitude}|${latLng.longitude}'),
          position: latLng,
          infoWindow: InfoWindow(title: titulo),
        );
        _listaMarcadores.add(marcador);
        _posicaoCamera = CameraPosition(target: latLng, zoom: 18);
        _movimentaCamera();
      });
    } else {
      _adicionarLitenerLocalizacao();
    }
  }
}
