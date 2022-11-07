

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStauts{
  Online,
  Offline,
  Connecting
}

class Socket with ChangeNotifier{

  ServerStauts _serverStauts = ServerStauts.Connecting;
  late IO.Socket _socket;
  ServerStauts get serverStauts => this._serverStauts;
  IO.Socket get socket => this._socket;


  Socket(){
    _initConfig();
  }

  void _initConfig(){

    print("intentadno conectar");
    _socket = IO.io('http://localhost:5020',{
      'transports':['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      _serverStauts = ServerStauts.Online;
      notifyListeners();
    });
    
    _socket.onDisconnect((_) {
      _serverStauts = ServerStauts.Offline;
      notifyListeners();
    });
  }
}