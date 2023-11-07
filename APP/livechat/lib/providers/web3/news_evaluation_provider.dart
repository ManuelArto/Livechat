import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../../constants.dart';

class NewsEvaluationProvider with ChangeNotifier {
  late DeployedContract _newsEvaluationContract;

  NewsEvaluationProvider() {
    init();
  }

  void init() async {
    // Load ABI from assets folder
    String abiString = await rootBundle.loadString("assets/abis/NewsEvaluation.abi.json");
    List abi = jsonDecode(abiString)["abi"];
    _newsEvaluationContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi), "NewsEvaluation"),
        EthereumAddress.fromHex(NEWS_SHARING_CONTRACT_ADDRESS));
  }

}
