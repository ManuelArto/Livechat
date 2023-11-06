// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"id","type":"uint256"},{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"string","name":"title","type":"string"},{"indexed":false,"internalType":"string","name":"ipfsCid","type":"string"},{"indexed":false,"internalType":"string","name":"chatName","type":"string"},{"indexed":false,"internalType":"uint256","name":"parentNews","type":"uint256"}],"name":"NewsCreated","type":"event"},{"inputs":[{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"ipfsCid","type":"string"},{"internalType":"string","name":"chatName","type":"string"},{"internalType":"uint256","name":"parentId","type":"uint256"}],"name":"createNews","outputs":[{"internalType":"uint256","name":"id","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"getNews","outputs":[{"components":[{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"ipfsCid","type":"string"},{"internalType":"string","name":"chatName","type":"string"},{"internalType":"address","name":"sharer","type":"address"}],"internalType":"struct DataTypes.News","name":"news","type":"tuple"}],"stateMutability":"view","type":"function"}]',
  'NewsSharing',
);

class NewsSharing extends _i1.GeneratedContract {
  NewsSharing({
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

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> createNews(
    String title,
    String ipfsCid,
    String chatName,
    BigInt parentId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'a651bca5'));
    final params = [
      title,
      ipfsCid,
      chatName,
      parentId,
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
  Future<dynamic> getNews(
    BigInt index, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'ba53911b'));
    final params = [index];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// Returns a live stream of all NewsCreated events emitted by this contract.
  Stream<NewsCreated> newsCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('NewsCreated');
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
      return NewsCreated(
        decoded,
        result,
      );
    });
  }
}

class NewsCreated {
  NewsCreated(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        sender = (response[1] as _i1.EthereumAddress),
        title = (response[2] as String),
        ipfsCid = (response[3] as String),
        chatName = (response[4] as String),
        parentNews = (response[5] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress sender;

  final String title;

  final String ipfsCid;

  final String chatName;

  final BigInt parentNews;

  final _i1.FilterEvent event;
}
