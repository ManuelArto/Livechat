// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

import '../../constants.dart';

class WalletProvider extends ChangeNotifier {
  late W3MService w3mService;
  late Web3App web3App;
  bool isConnected = false;

  Future<void> init() async {
    await initWeb3App();
    await initializeService();
  }

  Future<void> initWeb3App() async {
    web3App = await Web3App.createInstance(
      projectId: WALLET_CONNECT_ID,
      metadata: const PairingMetadata(
        name: APP_INFO_NAME,
        description: APP_INFO_DESCRIPTION,
        url: "https://www.walletconnect.com/",
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );

    web3App.onSessionPing.subscribe(_onSessionPing);
    web3App.onSessionEvent.subscribe(_onSessionEvent);
    web3App.onSessionConnect.subscribe(_onWeb3AppConnect);
    web3App.onSessionDelete.subscribe(_onWeb3AppDisconnect);
  }

  Future<void> initializeService() async {
    w3mService = W3MService(
      web3App: web3App,
      logLevel: LogLevel.error,
      // featuredWalletIds: {
      //   'f2436c67184f158d1beda5df53298ee84abfc367581e4505134b5bcf5f46697d',
      //   '8a0ee50d1f22f6651afcae7eb4253e52a3310b90af5daef78a8c4929a9bb99d4',
      //   'f5b4eeb6015d66be3f5940a895cbaa49ef3439e518cd771270e6b553b48f31d2',
      // },
    );

    // See https://docs.walletconnect.com/web3modal/flutter/custom-chains
    // W3MChainPresets.chains.putIfAbsent('42220', () => myCustomChain);
    // W3MChainPresets.chains.putIfAbsent('11155111', () => sepoliaTestnet);
    await w3mService.init();
    // w3mService.selectChain(myCustomChain);

    isConnected = web3App.sessions.getAll().isNotEmpty;
  }

  void _onSessionPing(SessionPing? args) {
    debugPrint('[$runtimeType] Received Ping: $args');
  }

  void _onSessionEvent(SessionEvent? args) {
    debugPrint('[$runtimeType] Received Event: $args');
  }

  void _onWeb3AppConnect(SessionConnect? args) {
    // If we connect, default to barebones
    isConnected = true;
    notifyListeners();
  }

  void _onWeb3AppDisconnect(SessionDelete? args) {
    isConnected = false;
    notifyListeners();
  }

}
