import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livechat/providers/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../widgets/top_bar.dart';
import 'components/map_friends_list.dart';
import 'components/map_widget.dart';
import 'components/reposition_button.dart';

class MapViewScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MapViewScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MapController _mapController = MapController();
  final PanelController _panelController = PanelController();

  void onLocationError() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: const TopBar(),
      body: FutureBuilder(
        future: locationProvider.getCurrentPosition(onLocationError),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if ((snapshot.hasError && snapshot.error is String)) {
            return _buildNoPermissionPage(snapshot.error as String);
          } else {
            return SlidingUpPanel(
              backdropEnabled: true,
              color: Theme.of(context).cardColor,
              controller: _panelController,
              minHeight: size.height * 0.05,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40.0)),
              body: Padding(
                padding:
                    const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                child: Stack(
                  children: [
                    MapWidget(mapController: _mapController),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                size.height * 0.1 + kBottomNavigationBarHeight),
                        child: RepositionButton(mapController: _mapController),
                      ),
                    )
                  ],
                ),
              ),
              panel: MapFriendsList(
                mapController: _mapController,
                panelController: _panelController,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildNoPermissionPage(String errorMessage) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
            ),
          ),
            TextButton(
              onPressed: () => setState(() {}),
              child: const Text("Reload"),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
