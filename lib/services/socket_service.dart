import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    _socket = IO.io(
        'http://192.168.1.85:3005',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      _socket.emit('msg', 'test');
      notifyListeners();
    });

    // socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('fromServer', (payload) {
      print('Nombre del Servidor:' + payload['nombre']);
      print('Mensaje del Servidor:' + payload['mensaje']);
      print(payload.containsKey('mensaje2')
          ? payload['mensaje2']
          : 'SIN MENSAJE 2');
    });


  }
}
