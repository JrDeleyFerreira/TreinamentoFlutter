import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uber_clone/util/status_requisicao.dart';
import 'package:uber_clone/util/usuario_firebase.dart';

// ignore: must_be_immutable
class Corrida extends StatefulWidget {
  Object? idRequisicao;
  Corrida(this.idRequisicao, {Key? key}) : super(key: key);
  @override
  _CorridaState createState() => _CorridaState();
}

class _CorridaState extends State<Corrida> {
  final Completer<GoogleMapController> _controller = Completer();
  final _posicaoDaCamera = const CameraPosition(
    target: LatLng(-23.563999, -46.653256),
    zoom: 16,
  );
  late Set<Marker> _marcadores;
  late Map<String, dynamic>? _dadosRequisicao;
  late String _idRequisicao;
  late Position? _localMotorista;
  var _statusRequisicao = StatusRequisicao.aguardando;

  //Controles para exibição na tela
  late String _textoBotao;
  late Color _corBotao;
  late Function _funcaoBotao;
  String _mensagemStatus = "";

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarListenerLocalizacao() {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((position) {
      if (_idRequisicao.isNotEmpty) {
        if (_statusRequisicao != StatusRequisicao.aguardando) {
          //Atualiza local do passageiro
          UsuarioFirebase.atualizarDadosLocalizacao(_idRequisicao,
              position.latitude, position.longitude, "motorista");
        } else {
          //aguardando
          setState(() {
            _localMotorista = position;
          });
          _statusAguardando();
        }
      }
    });
  }

  _recuperaUltimaLocalizacaoConhecida() async {
    var position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      //Atualizar localização em tempo real do motorista
    }
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcador(LatLng local, String icone, String infoWindow) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio), icone)
        .then((BitmapDescriptor bitmapDescriptor) {
      Marker marcador = Marker(
          markerId: MarkerId(icone),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: infoWindow),
          icon: bitmapDescriptor);

      setState(() {
        _marcadores.add(marcador);
      });
    });
  }

  _recuperarRequisicao() async {
    String idRequisicao = widget.idRequisicao.toString();
    var banco = FirebaseFirestore.instance;
    await banco.collection("requisicoes").doc(idRequisicao).get();
  }

  _adicionarListenerRequisicao() async {
    FirebaseFirestore banco = FirebaseFirestore.instance;

    banco
        .collection("requisicoes")
        .doc(_idRequisicao)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        _dadosRequisicao = snapshot.data();

        Map<String, dynamic>? dados = snapshot.data();
        _statusRequisicao = dados!["status"];

        switch (_statusRequisicao) {
          case StatusRequisicao.aguardando:
            _statusAguardando();
            break;
          case StatusRequisicao.aCaminho:
            _statusACaminho();
            break;
          case StatusRequisicao.emViagem:
            _statusEmViagem();
            break;
          case StatusRequisicao.finalizada:
            _statusFinalizada();
            break;
          case StatusRequisicao.confirmada:
            _statusConfirmada();
            break;
          case StatusRequisicao.cancelada:
            // TODO: Handle this case.
            break;
        }
      }
    });
  }

  _statusAguardando() {
    _alterarBotaoPrincipal(
        "Aceitar corrida", const Color(0xff1ebbd8), () => _aceitarCorrida());

    if (_localMotorista != null) {
      double motoristaLat = _localMotorista!.latitude;
      double motoristaLon = _localMotorista!.longitude;

      var position = LatLng(motoristaLat, motoristaLon);
      _exibirMarcador(position, "imagens/motorista.png", "Motorista");

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);

      _movimentarCamera(cameraPosition);
    }
  }

  _statusACaminho() {
    _mensagemStatus = "A caminho do passageiro";
    _alterarBotaoPrincipal("Iniciar corrida", const Color(0xff1ebbd8), () {
      _iniciarCorrida();
    });

    double latitudePassageiro = _dadosRequisicao!["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao!["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao!["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao!["motorista"]["longitude"];

    //Exibir dois marcadores
    _exibirDoisMarcadores(
      LatLng(latitudeMotorista, longitudeMotorista),
      LatLng(latitudePassageiro, longitudePassageiro),
    );

    //'southwest.latitude <= northeast.latitude': is not true
    double nLat, nLon, sLat, sLon;

    if (latitudeMotorista <= latitudePassageiro) {
      sLat = latitudeMotorista;
      nLat = latitudePassageiro;
    } else {
      sLat = latitudePassageiro;
      nLat = latitudeMotorista;
    }

    if (longitudeMotorista <= longitudePassageiro) {
      sLon = longitudeMotorista;
      nLon = longitudePassageiro;
    } else {
      sLon = longitudePassageiro;
      nLon = longitudeMotorista;
    }
    //-23.560925, -46.650623
    _movimentarCameraBounds(LatLngBounds(
        northeast: LatLng(nLat, nLon), //nordeste
        southwest: LatLng(sLat, sLon) //sudoeste
        ));
  }

  _finalizarCorrida() {
    var banco = FirebaseFirestore.instance;
    banco
        .collection("requisicoes")
        .doc(_idRequisicao)
        .update({"status": StatusRequisicao.finalizada});

    String idPassageiro = _dadosRequisicao!["passageiro"]["idUsuario"];
    banco
        .collection("requisicao_ativa")
        .doc(idPassageiro)
        .update({"status": StatusRequisicao.finalizada});

    String idMotorista = _dadosRequisicao!["motorista"]["idUsuario"];
    banco
        .collection("requisicao_ativa_motorista")
        .doc(idMotorista)
        .update({"status": StatusRequisicao.finalizada});
  }

  _statusFinalizada() async {
    //Calcula valor da corrida
    double latitudeDestino = _dadosRequisicao!["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao!["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao!["origem"]["latitude"];
    double longitudeOrigem = _dadosRequisicao!["origem"]["longitude"];

    double distanciaEmMetros = Geolocator.distanceBetween(
        latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

    //Converte para KM
    double distanciaKm = distanciaEmMetros / 1000;

    //8 é o valor cobrado por KM
    double valorViagem = distanciaKm * 8;

    //Formatar valor viagem
    var f = NumberFormat("#,##0.00", "pt_BR");
    var valorViagemFormatado = f.format(valorViagem);

    _mensagemStatus = "Viagem finalizada";
    _alterarBotaoPrincipal("Confirmar - R\$ $valorViagemFormatado",
        const Color(0xff1ebbd8), () => _confirmarCorrida());

    _marcadores = {};
    var position = LatLng(latitudeDestino, longitudeDestino);
    _exibirMarcador(position, "imagens/destino.png", "Destino");

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);

    _movimentarCamera(cameraPosition);
  }

  _statusConfirmada() {
    Navigator.pushReplacementNamed(context, "/painel-motorista");
  }

  _confirmarCorrida() {
    var banco = FirebaseFirestore.instance;
    banco
        .collection("requisicoes")
        .doc(_idRequisicao)
        .update({"status": StatusRequisicao.confirmada});

    String idPassageiro = _dadosRequisicao!["passageiro"]["idUsuario"];
    banco.collection("requisicao_ativa").doc(idPassageiro).delete();

    String idMotorista = _dadosRequisicao!["motorista"]["idUsuario"];
    banco.collection("requisicao_ativa_motorista").doc(idMotorista).delete();
  }

  _statusEmViagem() {
    _mensagemStatus = "Em viagem";
    _alterarBotaoPrincipal("Finalizar corrida", const Color(0xff1ebbd8), () {
      _finalizarCorrida();
    });

    double latitudeDestino = _dadosRequisicao!["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao!["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao!["motorista"]["latitude"];
    double longitudeOrigem = _dadosRequisicao!["motorista"]["longitude"];

    //Exibir dois marcadores
    _exibirDoisMarcadores(LatLng(latitudeOrigem, longitudeOrigem),
        LatLng(latitudeDestino, longitudeDestino));

    //'southwest.latitude <= northeast.latitude': is not true
    double nLat, nLon, sLat, sLon;

    if (latitudeOrigem <= latitudeDestino) {
      sLat = latitudeOrigem;
      nLat = latitudeDestino;
    } else {
      sLat = latitudeDestino;
      nLat = latitudeOrigem;
    }

    if (longitudeOrigem <= longitudeDestino) {
      sLon = longitudeOrigem;
      nLon = longitudeDestino;
    } else {
      sLon = longitudeDestino;
      nLon = longitudeOrigem;
    }
    //-23.560925, -46.650623
    _movimentarCameraBounds(LatLngBounds(
        northeast: LatLng(nLat, nLon), //nordeste
        southwest: LatLng(sLat, sLon) //sudoeste
        ));
  }

  _iniciarCorrida() {
    var banco = FirebaseFirestore.instance;
    banco.collection("requisicoes").doc(_idRequisicao).update({
      "origem": {
        "latitude": _dadosRequisicao!["motorista"]["latitude"],
        "longitude": _dadosRequisicao!["motorista"]["longitude"]
      },
      "status": StatusRequisicao.emViagem
    });

    String idPassageiro = _dadosRequisicao!["passageiro"]["idUsuario"];
    banco
        .collection("requisicao_ativa")
        .doc(idPassageiro)
        .update({"status": StatusRequisicao.emViagem});

    String idMotorista = _dadosRequisicao!["motorista"]["idUsuario"];
    banco
        .collection("requisicao_ativa_motorista")
        .doc(idMotorista)
        .update({"status": StatusRequisicao.emViagem});
  }

  _movimentarCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _exibirDoisMarcadores(LatLng latLngMotorista, LatLng latLngPassageiro) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    Set<Marker> _listaMarcadores = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/motorista.png")
        .then((BitmapDescriptor icone) {
      Marker marcador1 = Marker(
          markerId: const MarkerId("marcador-motorista"),
          position: LatLng(latLngMotorista.latitude, latLngMotorista.longitude),
          infoWindow: const InfoWindow(title: "Local motorista"),
          icon: icone);
      _listaMarcadores.add(marcador1);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/passageiro.png")
        .then((BitmapDescriptor icone) {
      Marker marcador2 = Marker(
          markerId: const MarkerId("marcador-passageiro"),
          position:
              LatLng(latLngPassageiro.latitude, latLngPassageiro.longitude),
          infoWindow: const InfoWindow(title: "Local passageiro"),
          icon: icone);
      _listaMarcadores.add(marcador2);
    });

    setState(() {
      _marcadores = _listaMarcadores;
    });
  }

  _aceitarCorrida() async {
    //Recuperar dados do motorista
    var motorista = await UsuarioFirebase.getDadosUsuarioLogado();
    motorista.latitude = _localMotorista!.latitude;
    motorista.longitude = _localMotorista!.longitude;

    var banco = FirebaseFirestore.instance;
    String idRequisicao = _dadosRequisicao!["id"];

    banco.collection("requisicoes").doc(idRequisicao).update({
      "motorista": motorista.toMap(),
      "status": StatusRequisicao.aCaminho,
    }).then((_) {
      //atualiza requisicao ativa
      String idPassageiro = _dadosRequisicao!["passageiro"]["idUsuario"];
      banco.collection("requisicao_ativa").doc(idPassageiro).update({
        "status": StatusRequisicao.aCaminho,
      });

      //Salvar requisicao ativa para motorista
      String idMotorista = motorista.idUsuario;
      banco.collection("requisicao_ativa_motorista").doc(idMotorista).set({
        "id_requisicao": idRequisicao,
        "id_usuario": idMotorista,
        "status": StatusRequisicao.aCaminho,
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _idRequisicao = widget.idRequisicao.toString();

    // adicionar listener para mudanças na requisicao
    _adicionarListenerRequisicao();

    //_recuperaUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel corrida - " + _mensagemStatus),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _posicaoDaCamera,
            onMapCreated: _onMapCreated,
            //myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _marcadores,
            //-23,559200, -46,658878
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Padding(
              padding: Platform.isIOS
                  ? const EdgeInsets.fromLTRB(20, 10, 20, 25)
                  : const EdgeInsets.all(10),
              child: ElevatedButton(
                  child: Text(
                    _textoBotao,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: _corBotao,
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  ),
                  onPressed: _funcaoBotao()),
            ),
          )
        ],
      ),
    );
  }
}
