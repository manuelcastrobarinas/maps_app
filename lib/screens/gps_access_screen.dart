import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';


class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            print("@DEBUG ESTADO DEL GPS $state ");
            return !state.isGpsEnabled
              ? const _EnableGPSmessage() 
              : const _AccessButton();
          }
        ),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Es necesario el acceso a GPS'),
      MaterialButton(
        color: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        onPressed: () {
          final gpsBloc = BlocProvider.of<GpsBloc>(context);
          gpsBloc.askGpsAccess(); 
        },
        child: const Text('Solicitar Acceso',
            style: TextStyle(color: Colors.white)))
    ]);
  }
}

class _EnableGPSmessage extends StatelessWidget {
  const _EnableGPSmessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Debe habilitar el GPS"));
  }
}
