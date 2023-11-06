import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../blockchain/NewsEvaluation.g.dart';
import '../../constants.dart';

class NewsEvaluationProvider with ChangeNotifier {
  Web3Client? web3client;

  late NewsEvaluation newsEvaluation;

  // Called everytime WalletProvider changes
  void update(Web3Client? web3client) {
    this.web3client = web3client;
    if (web3client != null) {
      newsEvaluation = NewsEvaluation(
        address: EthereumAddress.fromHex(NEWS_EVALUATION_CONTRACT_ADDRESS),
        client: this.web3client!,
      );
    }
  }

}
