import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livechat/screens/map_view/components/reposition_button.dart';
import 'package:provider/provider.dart';
import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/top_bar.dart';
import 'components/ranking/bar_menu.dart';
import 'components/map_wiget.dart';

class MapViewScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MapViewScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static List<Friends> friendsOnMap = [
    Friends('andreanapoli01', 5000, 44.4949, 11.3426,
        "https://www.shareicon.net/data/512x512/2016/05/29/772559_user_512x512.png"), // Bologna
    Friends('franco', 7000, 40.7128, -74.0060,
        "https://banner2.cleanpng.com/20180512/jae/kisspng-social-media-computer-icons-avatar-user-internet-5af70494b87405.5995767715261380047555.jpg"), // New York
    Friends('alessia', 3000, 35.6895, 139.6917,
        "https://media.istockphoto.com/id/1227618808/it/vettoriale/icona-avatar-volto-umano-profilo-per-social-network-uomo-illustrazione-vettoriale.jpg?s=170667a&w=0&k=20&c=-5yFBP2wWT2lsrijzJQdKn6JXc69BQB41ymRqTpCpr0="), // Tokyo
    Friends('Utente 4', 1000, 51.5074, -0.1278,
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8MdZ3lU8j1rFwUh92B7XCORJIIDKahAiFxW7UUM3iuBAA3RwiFNI81piyuajGfSCBYVw&usqp=CAU"), // London
    Friends('alice98', 4500, -33.8688, 151.2093,
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrJzbkfEZyEqpehc6f3xq_goRfRZ2UfYMhm1TV7cy7_3p5bT14qvLjcvxT73N7p64kBm0&usqp=CAU"), // Sydney
    Friends('peterpan', 8000, 37.7749, -122.4194,
        "https://img.favpng.com/21/4/9/portable-network-graphics-avatar-computer-icons-image-social-media-png-favpng-r3ez8qWcYdM8jGVn2b5TGhvS8.jpg"), // San Francisco
    Friends('giovanna23', 2000, -22.9068, -43.1729,
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXT9bJ7D2vy32FeXWvteA09uw0hJoYLsM_6FNQ8HpILJRTaISWyWN-Y099Nms17MpYCwo&usqp=CAU"), // Rio de Janeiro
    Friends('mariorossi', 12000, 55.7558, 37.6176,
        "https://banner2.cleanpng.com/20180623/iqh/kisspng-computer-icons-avatar-social-media-blog-font-aweso-avatar-icon-5b2e99c40ce333.6524068515297806760528.jpg"), // Moscow
    Friends('giuliasmith', 6000, -34.6037, -58.3816,
        "https://www.shutterstock.com/image-vector/cool-profile-avatar-social-media-260nw-1567986070.jpg"), // Buenos Aires
    Friends('lucamoretti', 4000, 48.8566, 2.3522,
        "https://w7.pngwing.com/pngs/716/469/png-transparent-social-media-computer-icons-social-network-avatar-social-media-computer-network-social-media-data.png"), // Paris
    Friends('sara85', 5500, 1.3521, 103.8198,
        "https://cdn.dribbble.com/users/3874089/screenshots/6976974/media/8f948bc82d0d6ce65e6a2f408a4ea5f5.jpg?compress=1&resize=400x300&vertical=center"), // Singapore
    Friends('michele72', 9000, 35.6894, 139.6921,
        "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/213245707/original/66a67e36fe8227d15c8c310cc112b60e74af5d6f/design-avatar-cartoon-for-business-gaming-social-media.jpg"), // Yokohama
    Friends('veronicabianchi', 3500, 52.5200, 13.4050,
        "https://img.freepik.com/premium-vector/avatar-female-social-network-media-design_24877-17894.jpg"), // Berlin
    Friends('matteo03', 7500, -37.8136, 144.9631,
        "https://cdn-icons-png.flaticon.com/512/1176/1176433.png"), // Melbourne
    Friends('elenaverdi', 1000, 55.6761, 12.5683,
        "https://i.pinimg.com/originals/e3/63/16/e36316cfd05ca21e44d8fabcf1a192be.jpg"), // Copenhagen
    Friends('paolacosta', 11000, -33.4489, -70.6693,
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKOojyNLumm6AOFWO4yZOqTArySpHS76vVgw&usqp=CAU"), // Santiago
    Friends('davidebianchi', 6500, 35.6897, 139.6922,
        "https://media.gettyimages.com/id/1227618794/it/vettoriale/icona-avatar-volto-umano-profilo-per-social-network-uomo-illustrazione-vettoriale.jpg?s=1024x1024&w=gi&k=20&c=Tqx21PXWhYr2fEKQbtTFoxu9a70VSTLHkcY__605g4A="), // Kawasaki
    Friends('laurarossi', 2500, 19.4326, -99.1332,
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWQl7yO47-dHWDsf9m_yCC5djlv80ccIKfJQ&usqp=CAU"), // Mexico City
    Friends('gabrielemarino', 9500, 37.9838, 23.7275,
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg_Eljgob-sraLE58jr_WfyZ_AM9rakoTYfA&usqp=CAU"), // Athens
    Friends('silvia89', 1500, -33.9258, 18.4232,
        "https://media.gettyimages.com/id/1227937549/it/vettoriale/icona-avatar-volto-umano-profilo-per-social-network-donna-illustrazione-vettoriale.jpg?s=1024x1024&w=gi&k=20&c=wfIkutGuWLyhEG_qvrmva3BNu2UIayytf1_1bbtYDso="), // Cape Town
  ];
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    AuthUser authUser = authProvider.authUser!;
    double userLat = 44.546082;
    double userLong = 11.193692;
    int steps = 11200;
   

    return Scaffold(
      key: _scaffoldKey,
      appBar: const TopBar(),
      body: Stack(
        children: [
          MapWidget(mapController: _mapController, userLat: userLat, userLong: userLong, authUser: authUser, steps: steps, friendsOnMap: friendsOnMap),
          BarMenu(mapController: _mapController, friendsOnMap: friendsOnMap),
          RepositionButton(mapController: _mapController, userLat: userLat, userLong: userLong)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Friends {
  final String name;
  final int steps;
  final double latitude;
  final double longitude;
  final String img;

  Friends(this.name, this.steps, this.latitude, this.longitude, this.img);
}
