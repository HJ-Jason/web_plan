import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_plan/widgets/routes/menuConnexion/menu_connexion.dart';
import '../eventList/event_list.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    if (result == null) {
      return const ChoiceLogin();
    }
    return const EventList();
  }
}
