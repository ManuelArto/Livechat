import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../constants.dart';

class Web3ClientService {
  // SINGLETON
  static Web3ClientService? _instance;
  static Web3ClientService get instance {
    _instance ??= Web3ClientService._();
    return _instance!;
  }

  Web3ClientService._();

  final Web3Client _web3client = Web3Client(
    RPC_URL,
    Client(),
    socketConnector: () {
      return IOWebSocketChannel.connect(WS_URL).cast<String>();
    },
  );

  get web3client => _web3client;
  
}