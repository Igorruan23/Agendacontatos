import 'package:agendacontatos/agenda_app.dart';
import 'package:flutter/material.dart';

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      //alterei para carregar login ao inves da homepage
      home: AgendaPage(),
    );
  }
}
