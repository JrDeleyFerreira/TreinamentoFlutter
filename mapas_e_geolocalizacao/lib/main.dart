import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MaterialApp(
      title: 'Mapas e Geolocalização',
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _completerController = Completer();

  /// Cria o controlador que captura as ações, dentro do onMapCreated: do
  /// GoogleMap()
  _onMapCreated(GoogleMapController controller) {
    _completerController.complete(controller);
  }

  /// Movimentações da câmera através do clique em um botão
  /// Nesse caso, um floatingActionButton:
  _movimentaCamera() async {
    var googleController = await _completerController.future;
    googleController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(-23.562436, -46.655005),
      tilt: 30,
      bearing: 60,
    )));
  }

  /// Criando marcadores que serão exibidos no mapa
  Set<Marker> _marcadores = {};
  _carregarMarcadores() {
    Set<Marker> _marcadoresLocais = {};
    Marker marcadorShopping = Marker(
      markerId: MarkerId('marcador-shopping'),
      position: LatLng(-23.562436, -46.655005),
      infoWindow: InfoWindow(
        title: 'Nome da Localização',
        onTap: () {},
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      onTap: () {},
    );
    _marcadoresLocais.add(marcadorShopping);
    setState(() {
      _marcadores = _marcadoresLocais;
    });
  }

  /// Criando polígonos - formas - dentro do mapa
  Set<Polygon> _setPolygons = {};
  _poligonos() {
    Set<Polygon> listaPoligons = {};
    Polygon polygon = Polygon(
        polygonId: PolygonId('polygon1'),
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 10,
        points: [
          LatLng(-23.562436, -46.655005),
          LatLng(-23.562436, -46.655005),
          LatLng(-23.562436, -46.655005),
        ]);
    listaPoligons.add(polygon);
    setState(() {
      _setPolygons = listaPoligons;
    });
  }

  /// Desenhando linhas dentro do mapa
  Set<Polyline> _setPolyline = {};
  _polylines() {
    Set<Polyline> listPolylines = {};
    Polyline polyline = Polyline(
      polylineId: PolylineId('polyline'),
      color: Colors.red,
      width: 10,
      points: [
        LatLng(-23.562436, -46.655005),
        LatLng(-23.562436, -46.655005),
        LatLng(-23.562436, -46.655005),
      ],
      startCap: Cap.squareCap,
    );
    listPolylines.add(polyline);
    setState(() {
      _setPolyline = listPolylines;
    });
  }

  /// Recupera a localização do usuário em tempo real
  CameraPosition _posicaoInicial = CameraPosition(
    target: LatLng(-23.562436, -46.655005),
    zoom: 16,
  );
  _recuperaLocalizacaoAtual() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _posicaoInicial = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
      );
    });
  }

  /// Acompanha a movimentação do usuário em tempo real
  _monitoraLocalizacaoTmpReal() {
    var geolocator = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((position) {
      setState(() {
        _posicaoInicial = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
        );
      });
    });
    print(geolocator);
  }

  _recuperaLocalParaEndereco() async {
    var local = GeocodingPlatform.instance;

    /// Através de um endereço literal, recuperamos latitude, longitude e horário
    var listaEnderecos = await local.locationFromAddress('Av. Paulosta, 1372');
    if (listaEnderecos.length > 0) {
      Location endereco = listaEnderecos[0];
      print('${endereco.latitude}');
      print('${endereco.longitude}');
      print('${endereco.timestamp}');
    }

    /// Através da latitude e longitude, recuperamos todas as informações a respeito
    var listagem = await local.placemarkFromCoordinates(-23.562436, -46.655005);
    if (listagem.length > 0) {
      Placemark placemark = listagem[0];
      print('${placemark.administrativeArea}');
      print('${placemark.subAdministrativeArea}');
      print('${placemark.locality}');
      print('${placemark.subLocality}');
      print('${placemark.thoroughfare}');
      print('${placemark.subThoroughfare}');
      print('${placemark.postalCode}');
      print('${placemark.country}');
      print('${placemark.isoCountryCode}');
      print('${placemark.name}');
      print('${placemark.street}');
    }
  }

  /// Carregando previamente os marcadores no mapa
  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
    _recuperaLocalizacaoAtual();
    _monitoraLocalizacaoTmpReal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapas e Geolocalização')),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoInicial,
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _setPolygons,
          polylines: _setPolyline,
          myLocationEnabled: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentaCamera,
      ),
    );
  }
}
