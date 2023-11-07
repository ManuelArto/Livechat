import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livechat/services/web3_client_service.dart';
import 'package:web3dart/web3dart.dart';

import '../../constants.dart';

class NewsSharingProvider with ChangeNotifier {
  late DeployedContract _newsSharingContract;
  late Web3Client _web3client;

  NewsSharingProvider() {
    _web3client = Web3ClientService.instance.web3client;
    init();
  }

  void init() async {
    // Load ABI from assets folder
    String abiString =
        await rootBundle.loadString("assets/abis/NewsSharing.abi.json");
    List abi = jsonDecode(abiString)["abi"];
    _newsSharingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi), "NewsSharing"),
        EthereumAddress.fromHex(NEWS_SHARING_CONTRACT_ADDRESS));
  }

  void getNews(int id) async {
    try {
      final res = await _web3client.call(
        contract: _newsSharingContract,
        function: _newsSharingContract.function("getNews"),
        params: [BigInt.from(id)],
      );
      for (var element in (res.first as List)) {
        debugPrint(element.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<int> createNews(String title, String chatName, int parentId) async {
    Credentials credentials = EthPrivateKey.fromHex(PRIVATE_KEY);

    final String txHash = await _web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: _newsSharingContract,
        function: _newsSharingContract.function("createNews"),
        parameters: [title, '', chatName, BigInt.from(parentId)],
      ),
      chainId: 1337,
      fetchChainIdFromNetworkId: false,
    );

    final id = await _getIdFromTxHashAndEvent(txHash);
    return id;
  }

  Future<int> _getIdFromTxHashAndEvent(String txHash) async {
    // Wait for the transaction to be mined to get the receipt
    final TransactionReceipt receipt = (await _web3client.getTransactionReceipt(txHash))!;

    // Filter the logs for the 'NewsCreated' event
    final event = receipt.logs[0];

    // Decode the event data to get the 'id'
    final newsEvent = _newsSharingContract
        .event("NewsCreated")
        .decodeResults(event.topics!, event.data!);
    debugPrint('NewsCreated with id: ${newsEvent[0]}');

    return newsEvent[0].toInt();
  }

}
