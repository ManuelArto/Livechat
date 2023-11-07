import 'package:flutter/material.dart';
import 'package:livechat/providers/web3/news_sharing_provider.dart';
import 'package:livechat/providers/web3/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Web3TestingPage extends StatefulWidget {
  static const routeName = "/trusted";
  const Web3TestingPage({super.key});

  @override
  State<Web3TestingPage> createState() => _Web3TestingPageState();
}

class _Web3TestingPageState extends State<Web3TestingPage> {
  late WalletProvider walletProvider;
  late NewsSharingProvider newsSharingProvider;

  @override
  Widget build(BuildContext context) {
    newsSharingProvider = Provider.of<NewsSharingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trusted"),
      ),
      body: ChangeNotifierProvider(
        create: (context) => WalletProvider(),
        builder: (context, child) {
          walletProvider = Provider.of<WalletProvider>(context);
          return FutureBuilder(
            future: walletProvider.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // ..._buildWalletConnectSection(),
                      ..._buildNewsSharingInteractions()
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildNewsSharingInteractions() {
    return [
      const Text("News sharing"),
      ElevatedButton(
        onPressed: () => newsSharingProvider.getNews(1),
        child: const Text("Get news by id 1"),
      ),
      ElevatedButton(
        onPressed: () =>
            newsSharingProvider.createNews("TITLE", "CHATNAME", 0),
        child: const Text("Create a static news"),
      ),
    ];
  }

  List<Widget> _buildWalletConnectSection() {
    return [
      Visibility(
        visible: !walletProvider.isConnected,
        child: W3MNetworkSelectButton(
          service: walletProvider.w3mService,
        ),
      ),
      W3MConnectWalletButton(service: walletProvider.w3mService),
      const Divider(height: 0.0),
      Visibility(
        visible: walletProvider.isConnected,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox.square(dimension: 12.0),
            W3MAccountButton(service: walletProvider.w3mService),
            TextButton(
              onPressed: walletProvider.w3mService.launchConnectedWallet,
              child: const Text("Launch Connected Wallet"),
            ),
            const SizedBox.square(dimension: 12.0),
          ],
        ),
      ),
    ];
  }
}
