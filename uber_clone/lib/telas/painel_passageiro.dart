import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uber_clone/gerador_rotas.dart';
import 'package:uber_clone/model/destino_viagem.dart';
import 'package:uber_clone/model/marcador_mapa.dart';
import 'package:uber_clone/model/requisicao_viagem.dart';
import 'package:uber_clone/util/status_requisicao.dart';
import 'package:uber_clone/util/usuario_firebase.dart';

class PainelPassageiro extends StatefulWidget {
  const PainelPassageiro({Key? key}) : super(key: key);
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  var _controllerDestino = TextEditingController();
  final itensMenu = ["Configurações", "Deslogar"];
  final Completer<GoogleMapController> _controller = Completer();
  var _posicaoCamera = const CameraPosition(
    target: LatLng(-23.563999, -46.653256),
  );
  Set<Marker> _marcadores = {};
  late String _idRequisicao;
  late Position? _localPassageiro;
  late Map<String, dynamic> _dadosRequisicao;
  StreamSubscription<DocumentSnapshot?>? _streamSubscriptionRequisicoes;

  //Controles para exibição na tela
  late bool _exibirCaixaEnderecoDestino;
  late String _textoBotao;
  late Color _corBotao;
  late Function _funcaoBotao;

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, GeradorDeRotas.homePage);
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configurações":
        break;
    }
  }

  _onMapCreated(GoogleMapController controller) =>
      _controller.complete(controller);

  _adicionarListenerLocalizacao() {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((position) {
      if (_idRequisicao.isNotEmpty) {
        //Atualiza local do passageiro
        UsuarioFirebase.atualizarDadosLocalizacao(
            _idRequisicao, position.latitude, position.longitude, "passageiro");
      } else {
        setState(() {
          _localPassageiro = position;
        });
        _statusUberNaoChamado();
      }
    });
  }

  _recuperaUltimaLocalizacaoConhecida() async {
    var posicao = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);

    var position = LatLng(posicao!.latitude, posicao.longitude);

    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);

        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _localPassageiro = posicao;
        _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    var googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcadorPassageiro(LatLng local) async {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/passageiro.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
          markerId: const MarkerId("marcador-passageiro"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: const InfoWindow(title: "Meu local"),
          icon: icone);

      setState(() {
        _marcadores.add(marcadorPassageiro);
      });
    });
  }

  _chamarUber() async {
    var enderecoDestino = _controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      var local = GeocodingPlatform.instance;
      var listaLatLng = await local.locationFromAddress(enderecoDestino);

      if (listaLatLng.isNotEmpty) {
        var coordenadas = listaLatLng[0];

        var listaEnderecos = await local.placemarkFromCoordinates(
            coordenadas.latitude, coordenadas.longitude);
        var endereco = listaEnderecos[0];

        var viagem = Destino();
        viagem.cidade = endereco.administrativeArea;
        viagem.numero = endereco.subThoroughfare;
        viagem.rua = endereco.thoroughfare;
        viagem.bairro = endereco.subLocality;
        viagem.cep = endereco.postalCode;

        viagem.latitude = coordenadas.latitude;
        viagem.longitude = coordenadas.longitude;

        var confirmacaoViagem = 'Cidade:  ${viagem.cidade}';
        confirmacaoViagem += '\n Bairro:  ${viagem.bairro}';
        confirmacaoViagem += '\n Rua:  ${viagem.rua}';
        confirmacaoViagem += '\n Nº:  ${viagem.numero}';

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Confirmação do Endereço'),
                content: Text(confirmacaoViagem),
                contentPadding: const EdgeInsets.all(16),
                actions: [
                  TextButton(
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      _salvarRequisicao(viagem);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  _salvarRequisicao(Destino destino) async {
    var passageiro = await UsuarioFirebase.getDadosUsuarioLogado();
    passageiro.latitude = _localPassageiro!.latitude;
    passageiro.longitude = _localPassageiro!.longitude;

    var requisicao = Requisicao();
    requisicao.destino = destino;
    requisicao.passageiro = passageiro;
    requisicao.status = StatusRequisicao.aguardando;

    var banco = FirebaseFirestore.instance;

    //salvar requisição
    banco.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

    //Salvar requisição ativa
    Map<String, dynamic> dadosRequisicaoAtiva = {};
    dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = passageiro.idUsuario;
    dadosRequisicaoAtiva["status"] = StatusRequisicao.aguardando;

    banco
        .collection("requisicao_ativa")
        .doc(passageiro.idUsuario)
        .set(dadosRequisicaoAtiva);

    //Adicionar listener requisicao
    if (_streamSubscriptionRequisicoes == null) {
      _adicionarListenerRequisicao(requisicao.id);
    }
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _statusUberNaoChamado() {
    _exibirCaixaEnderecoDestino = true;

    _alterarBotaoPrincipal("Chamar uber", const Color(0xff1ebbd8), () {
      _chamarUber();
    });

    if (_localPassageiro != null) {
      var position = LatLng(
        _localPassageiro!.latitude,
        _localPassageiro!.longitude,
      );
      _exibirMarcadorPassageiro(position);
      var cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      _movimentarCamera(cameraPosition);
    }
  }

  _statusAguardando() {
    _exibirCaixaEnderecoDestino = false;

    _alterarBotaoPrincipal("Cancelar", Colors.red, () {
      _cancelarUber();
    });

    double passageiroLat = _dadosRequisicao["passageiro"]["latitude"];
    double passageiroLon = _dadosRequisicao["passageiro"]["longitude"];
    var position = LatLng(passageiroLat, passageiroLon);
    _exibirMarcadorPassageiro(position);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _movimentarCamera(cameraPosition);
  }

  _statusACaminho() {
    _exibirCaixaEnderecoDestino = false;

    _alterarBotaoPrincipal("Motorista a caminho", Colors.grey, () {});

    double latitudeDestino = _dadosRequisicao["passageiro"]["latitude"];
    double longitudeDestino = _dadosRequisicao["passageiro"]["longitude"];

    double latitudeOrigem = _dadosRequisicao["motorista"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["motorista"]["longitude"];

    Marcador marcadorOrigem = Marcador(LatLng(latitudeOrigem, longitudeOrigem),
        "imagens/motorista.png", "Local motorista");

    Marcador marcadorDestino = Marcador(
        LatLng(latitudeDestino, longitudeDestino),
        "imagens/passageiro.png",
        "Local destino");

    _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
  }

  _statusEmViagem() {
    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Em viagem", Colors.grey, () => null);

    double latitudeDestino = _dadosRequisicao["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao["motorista"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["motorista"]["longitude"];

    Marcador marcadorOrigem = Marcador(LatLng(latitudeOrigem, longitudeOrigem),
        "imagens/motorista.png", "Local motorista");

    Marcador marcadorDestino = Marcador(
        LatLng(latitudeDestino, longitudeDestino),
        "imagens/destino.png",
        "Local destino");

    _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
  }

  _exibirCentralizarDoisMarcadores(
      Marcador marcadorOrigem, Marcador marcadorDestino) {
    double latitudeOrigem = marcadorOrigem.local.latitude;
    double longitudeOrigem = marcadorOrigem.local.longitude;

    double latitudeDestino = marcadorDestino.local.latitude;
    double longitudeDestino = marcadorDestino.local.longitude;

    //Exibir dois marcadores
    _exibirDoisMarcadores(marcadorOrigem, marcadorDestino);

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

  _statusFinalizada() async {
    //Calcula valor da corrida
    double latitudeDestino = _dadosRequisicao["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao["origem"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["origem"]["longitude"];

    double distanciaEmMetros = Geolocator.distanceBetween(
        latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

    //Converte para KM
    double distanciaKm = distanciaEmMetros / 1000;

    //8 é o valor cobrado por KM
    double valorViagem = distanciaKm * 8;

    //Formatar valor viagem
    var f = NumberFormat("#,##0.00", "pt_BR");
    var valorViagemFormatado = f.format(valorViagem);

    _alterarBotaoPrincipal(
        "Total - R\$ $valorViagemFormatado", Colors.green, () {});

    _marcadores = {};
    var position = LatLng(latitudeDestino, longitudeDestino);
    _exibirMarcador(position, "imagens/destino.png", "Destino");

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);

    _movimentarCamera(cameraPosition);
  }

  _statusConfirmada() {
    if (_streamSubscriptionRequisicoes != null) {
      _streamSubscriptionRequisicoes!.cancel();
      _streamSubscriptionRequisicoes = null;
    }

    _exibirCaixaEnderecoDestino = true;
    _alterarBotaoPrincipal("Chamar uber", const Color(0xff1ebbd8), () {
      _chamarUber();
    });

    //Exibe local do passageiro
    double passageiroLat = _dadosRequisicao["passageiro"]["latitude"];
    double passageiroLon = _dadosRequisicao["passageiro"]["longitude"];
    var position = LatLng(passageiroLat, passageiroLon);
    _exibirMarcadorPassageiro(position);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _movimentarCamera(cameraPosition);

    _dadosRequisicao = {};
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

  _movimentarCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _exibirDoisMarcadores(Marcador marcadorOrigem, Marcador marcadorDestino) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    LatLng latLngOrigem = marcadorOrigem.local;
    LatLng latLngDestino = marcadorDestino.local;

    Set<Marker> _listaMarcadores = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            marcadorOrigem.caminhoImagem)
        .then((BitmapDescriptor icone) {
      Marker mOrigem = Marker(
          markerId: MarkerId(marcadorOrigem.caminhoImagem),
          position: LatLng(latLngOrigem.latitude, latLngOrigem.longitude),
          infoWindow: InfoWindow(title: marcadorOrigem.titulo),
          icon: icone);
      _listaMarcadores.add(mOrigem);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            marcadorDestino.caminhoImagem)
        .then((BitmapDescriptor icone) {
      Marker mDestino = Marker(
          markerId: MarkerId(marcadorDestino.caminhoImagem),
          position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
          infoWindow: InfoWindow(title: marcadorDestino.titulo),
          icon: icone);
      _listaMarcadores.add(mDestino);
    });

    setState(() {
      _marcadores = _listaMarcadores;
    });
  }

  _cancelarUber() async {
    var firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    var banco = FirebaseFirestore.instance;
    banco
        .collection("requisicoes")
        .doc(_idRequisicao)
        .update({"status": StatusRequisicao.cancelada}).then((_) {
      banco.collection("requisicao_ativa").doc(firebaseUser!.uid).delete();

      _statusUberNaoChamado();

      _streamSubscriptionRequisicoes != null
          ? _streamSubscriptionRequisicoes!.cancel()
          : _streamSubscriptionRequisicoes = null;
    });
  }

  _recuperaRequisicaoAtiva() async {
    var firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    var banco = FirebaseFirestore.instance;
    var documentSnapshot =
        await banco.collection("requisicao_ativa").doc(firebaseUser!.uid).get();

    if (documentSnapshot.data() != null) {
      var dados = documentSnapshot.data();
      _idRequisicao = dados?["id_requisicao"];
      _adicionarListenerRequisicao(_idRequisicao);
    } else {
      _statusUberNaoChamado();
    }
  }

  _adicionarListenerRequisicao(String idRequisicao) async {
    var banco = FirebaseFirestore.instance;
    _streamSubscriptionRequisicoes = banco
        .collection("requisicoes")
        .doc(idRequisicao)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        var dados = snapshot.data();
        _dadosRequisicao = dados!;
        var status = dados["status"];
        _idRequisicao = dados["id"];

        switch (status) {
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
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //adicionar listener para requisicao ativa
    _recuperaRequisicaoAtiva();

    //_recuperaUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel passageiro"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _posicaoCamera,
            onMapCreated: _onMapCreated,
            //myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _marcadores,
            //-23,559200, -46,658878
          ),
          Visibility(
            visible: _exibirCaixaEnderecoDestino,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          icon: Container(
                            margin: const EdgeInsets.only(left: 20),
                            width: 10,
                            height: 10,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                          ),
                          hintText: "Meu local",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                            top: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 55,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white),
                      child: TextField(
                        controller: _controllerDestino,
                        decoration: InputDecoration(
                            icon: Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 10,
                              height: 10,
                              child: const Icon(
                                Icons.local_taxi,
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Digite o destino",
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.only(left: 15, top: 16)),
                      ),
                    ),
                  ),
                )
              ],
            ),
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
                onPressed: _funcaoBotao(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionRequisicoes!.cancel();
    _streamSubscriptionRequisicoes = null;
  }
}
