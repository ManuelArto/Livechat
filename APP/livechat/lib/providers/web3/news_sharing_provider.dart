import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../../blockchain/NewsSharing.g.dart';
import '../../constants.dart';

class NewsSharingProvider with ChangeNotifier {
  // final WalletConnectService walletConnectService = WalletConnectService.instance;
  Web3Client web3client = Web3Client(RPC_URL, Client());

  late NewsSharing newsSharing;

  // Called everytime WalletProvider changes
  NewsSharingProvider() {
    newsSharing = NewsSharing(
      address: EthereumAddress.fromHex(NEWS_SHARING_CONTRACT_ADDRESS),
      client: web3client,
      // chainId: CHAIN_ID,
    );
  }

  void getNews(int id) async {
    try {
      final res = await newsSharing.getNews(BigInt.from(id));
      debugPrint(res);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void createNews(String title, String ipfsCid, String chatName, int parentId) async {
    Credentials credentials = EthPrivateKey.fromHex(PRIVATE_KEY);

    const abi = [
      {"inputs": [], "stateMutability": "nonpayable", "type": "constructor"},
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "uint256",
            "name": "id",
            "type": "uint256"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "sender",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "string",
            "name": "title",
            "type": "string"
          },
          {
            "indexed": false,
            "internalType": "string",
            "name": "ipfsCid",
            "type": "string"
          },
          {
            "indexed": false,
            "internalType": "string",
            "name": "chatName",
            "type": "string"
          },
          {
            "indexed": false,
            "internalType": "uint256",
            "name": "parentNews",
            "type": "uint256"
          }
        ],
        "name": "NewsCreated",
        "type": "event"
      },
      {
        "inputs": [
          {"internalType": "string", "name": "title", "type": "string"},
          {"internalType": "string", "name": "ipfsCid", "type": "string"},
          {"internalType": "string", "name": "chatName", "type": "string"},
          {"internalType": "uint256", "name": "parentId", "type": "uint256"}
        ],
        "name": "createNews",
        "outputs": [
          {"internalType": "uint256", "name": "id", "type": "uint256"}
        ],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint256", "name": "index", "type": "uint256"}
        ],
        "name": "getNews",
        "outputs": [
          {
            "components": [
              {"internalType": "string", "name": "title", "type": "string"},
              {"internalType": "string", "name": "ipfsCid", "type": "string"},
              {"internalType": "string", "name": "chatName", "type": "string"},
              {"internalType": "address", "name": "sharer", "type": "address"}
            ],
            "internalType": "struct DataTypes.News",
            "name": "news",
            "type": "tuple"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ];

    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi), "NewsSharing"),
        EthereumAddress.fromHex(NEWS_SHARING_CONTRACT_ADDRESS));

    final res = await web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("createNews"),
        parameters: [title, ipfsCid, chatName, BigInt.from(parentId)],
      ),
      chainId: 1337,
      fetchChainIdFromNetworkId: false,
    );
    debugPrint(res);

    // await newsSharing.createNews(
    //   title,
    //   ipfsCid,
    //   chatName,
    //   BigInt.from(parentId),
    //   credentials: credentials,
    // );
  }
}
