import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/helpers/show_loading_message.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SosNotificationScreen extends StatelessWidget {
  static const String sosroute = 'sos_notification';
  const SosNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //recupera el argumentos
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String nombre = args['nombre'];
    String nombreLimitado =
        nombre.length <= 10 ? nombre : '${nombre.substring(0, 12)}...';

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final counterBloc = BlocProvider.of<NavigatorBloc>(context);
    LatLng? end;
    // const String number = '911';

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: false,
          title: const Text('SOS',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          elevation: 0.5,
        ),
        body: Column(
          //spacebetween
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: const [],
            ),
            Center(
              child: SvgPicture.asset(
                "assets/info/advertencia.svg",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.30,
                color: const Color(0xFF6165FA),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '$nombreLimitado necesitas ayuda',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      searchBloc.add(const IsActiveNotification(true));
                      final start = locationBloc.state.lastKnownLocation;
                      if (start == null) return;
                      end = LatLng(args['latitud'], args['longitud']);
                      if (end == null) return;
                      searchBloc.add(OnActivateManualMarkerEvent());
                      showLoadingMessage(context);
                      final destination =
                          await searchBloc.getCoorsStartToEnd(start, end!);
                      await mapBloc.drawRoutePolyline(destination);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      counterBloc.add(const NavigatorIndexEvent(index: 0));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF6165FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.mapLocation,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Ver mapa',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
