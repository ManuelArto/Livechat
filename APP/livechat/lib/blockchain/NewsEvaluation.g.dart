// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"name":"NewsEvaluation_NewsAlreadyValidated","type":"error"},{"inputs":[],"name":"NewsEvaluation_NewsValidationNotStarted","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"id","type":"uint256"},{"indexed":true,"internalType":"address","name":"evaluator","type":"address"},{"indexed":false,"internalType":"bool","name":"evaluation","type":"bool"},{"indexed":false,"internalType":"uint256","name":"confidence","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"evaluationsCount","type":"uint256"}],"name":"NewsEvaluated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"id","type":"uint256"},{"indexed":true,"internalType":"address","name":"initiator","type":"address"},{"indexed":false,"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"NewsValidationStarted","type":"event"},{"inputs":[],"name":"DEADLINE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"newsId","type":"uint256"},{"internalType":"bool","name":"evaluation","type":"bool"},{"internalType":"uint256","name":"confidence","type":"uint256"}],"name":"evaluateNews","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"newsId","type":"uint256"}],"name":"getNewsValidation","outputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"enum DataTypes.EvaluationStatus","name":"","type":"uint8"},{"components":[{"internalType":"bool","name":"evaluation","type":"bool"},{"internalType":"uint256","name":"confidence","type":"uint256"}],"internalType":"struct DataTypes.Evaluation","name":"","type":"tuple"},{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"newsId","type":"uint256"}],"name":"startNewsValidation","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'NewsEvaluation',
);

class NewsEvaluation extends _i1.GeneratedContract {
  NewsEvaluation({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> DEADLINE({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, 'a082c86e'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> evaluateNews(
    BigInt newsId,
    bool evaluation,
    BigInt confidence, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '8746fe00'));
    final params = [
      newsId,
      evaluation,
      confidence,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetNewsValidation> getNewsValidation(
    BigInt newsId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'a7e4130e'));
    final params = [newsId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return GetNewsValidation(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> startNewsValidation(
    BigInt newsId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'e1532082'));
    final params = [newsId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all NewsEvaluated events emitted by this contract.
  Stream<NewsEvaluated> newsEvaluatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('NewsEvaluated');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return NewsEvaluated(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all NewsValidationStarted events emitted by this contract.
  Stream<NewsValidationStarted> newsValidationStartedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('NewsValidationStarted');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return NewsValidationStarted(
        decoded,
        result,
      );
    });
  }
}

class GetNewsValidation {
  GetNewsValidation(List<dynamic> response)
      : var1 = (response[0] as _i1.EthereumAddress),
        var2 = (response[1] as BigInt),
        var3 = (response[2] as BigInt),
        var4 = (response[3] as dynamic),
        var5 = (response[4] as BigInt);

  final _i1.EthereumAddress var1;

  final BigInt var2;

  final BigInt var3;

  final dynamic var4;

  final BigInt var5;
}

class NewsEvaluated {
  NewsEvaluated(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        evaluator = (response[1] as _i1.EthereumAddress),
        evaluation = (response[2] as bool),
        confidence = (response[3] as BigInt),
        evaluationsCount = (response[4] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress evaluator;

  final bool evaluation;

  final BigInt confidence;

  final BigInt evaluationsCount;

  final _i1.FilterEvent event;
}

class NewsValidationStarted {
  NewsValidationStarted(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        initiator = (response[1] as _i1.EthereumAddress),
        deadline = (response[2] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress initiator;

  final BigInt deadline;

  final _i1.FilterEvent event;
}
