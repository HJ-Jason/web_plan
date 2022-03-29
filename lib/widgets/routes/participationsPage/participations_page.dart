import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_plan/widgets/routes/loadingScreen/loading_screen.dart';
import '../profilePage/profile_page.dart';
import 'package:web_plan/responsive_layout.dart';
import '../../slideBar/slide_Bar.dart';

class ParticipationPage extends StatefulWidget {
  const ParticipationPage({Key? key}) : super(key: key);

  @override
  State<ParticipationPage> createState() => _ParticipationPage();
}

class _ParticipationPage extends State<ParticipationPage> {
  late String _headline;
  AssetImage _avatarImg = AssetImage('../assets/logoWeb.png');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    final CollectionReference _events = FirebaseFirestore.instance
        .collection('User')
        .doc(result!.uid)
        .collection('MyEvent');
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(36, 45, 165, 1),
        elevation: 0.0,
        title: const Text(
          'Participations :',
          style: TextStyle(
              fontSize: 35,
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.w900),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(36, 45, 165, 1),
                Color.fromRGBO(39, 50, 207, 1),
                Color.fromRGBO(13, 19, 102, 1)
              ]),
        ),
        child: Row(
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(
                  maxWidth: double.infinity,
                  minWidth: 100,
                ),
                // color : Colors.green,
                child: SlideBar()),
            Expanded(
              flex: 1,
              child: Container(
                alignment: const FractionalOffset(0.3, 0.4),
                // color : Colors.purple,
                height: MediaQuery.of(context).size.height * 1.0,
                // child: Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: _body(size, context),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(Size size, BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    final CollectionReference _events = FirebaseFirestore.instance
        .collection('User')
        .doc(result!.uid)
        .collection('MyEvent');

    return StreamBuilder(
        stream: _events.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> Streamsnapshot) {
          if (Streamsnapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (Streamsnapshot.hasData) {
            return Container(
              constraints: const BoxConstraints(
                minHeight: 500.0,
                minWidth: 500.0,
                maxHeight: 800.0,
                maxWidth: 10000,
              ),
              child: ListView.builder(
                  itemCount: Streamsnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ResponsiveLayout(
                      mobileBody: MyCustomMobileContent(
                        idEventParticipation:
                            Streamsnapshot.data!.docs[index].id.toString(),
                      ),
                      desktopBody: MyCustomDesktopContent(
                        idEventParticipation:
                            Streamsnapshot.data!.docs[index].id.toString(),
                      ),
                    );
                  }),
            );
          }
          return const LoadingScreen();
        });
  }
}

class MyCustomMobileContent extends StatelessWidget {
  String? idEventParticipation;
  MyCustomMobileContent({Key? key, this.idEventParticipation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _event = FirebaseFirestore.instance.collection('Event');
    return FutureBuilder<DocumentSnapshot>(
        future: _event.doc(idEventParticipation).get(),
        builder: (context, snapshot) {
          print("1" + snapshot.toString());
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              height: 360,
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 2,
              ),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 42, 42, 43),
                      blurRadius: 4,
                      offset: Offset(4, 8),
                    )
                  ]),
              child: Column(children: [
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.perm_contact_calendar_outlined,
                          color: Color.fromARGB(255, 39, 39, 39),
                        ),
                        Text(
                          "${data['Title']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 39, 39, 39),
                          ),
                        ),
                      ],
                    ),

                    // ---------- Container des informations de l'event ----------
                    //
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(children: [
                            const Icon(Icons.calendar_today),
                            Text(
                              " ${data['Date'].toDate().toString().split(" ")[0]}",
                              style: const TextStyle(fontSize: 16),
                            )
                          ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.people_alt),
                              Text(
                                  " ${data['Users'].length}/${data['PeopleLimit']}",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(Icons.place),
                              Text("${data['Location']}",
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: Text(
                              "${data['Description']}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/details',
                                    arguments: idEventParticipation.toString(),
                                  );
                                },
                                icon: const Icon(Icons.more),
                                label: const Text("Plus d'infos"),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromRGBO(140, 140, 140, 1),
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              myEvent(idEvent: idEventParticipation.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            );
          }
          return const Text("");
        });
  }
}

class MyCustomDesktopContent extends StatelessWidget {
  String? idEventParticipation;
  MyCustomDesktopContent({Key? key, this.idEventParticipation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _event = FirebaseFirestore.instance.collection('Event');
    return FutureBuilder<DocumentSnapshot>(
        future: _event.doc(idEventParticipation).get(),
        builder: (context, snapshot) {
          print("1" + snapshot.toString());
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              height: 360,
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 2,
              ),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 42, 42, 43),
                      blurRadius: 4,
                      offset: Offset(4, 8),
                    )
                  ]),
              child: Column(children: [
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.perm_contact_calendar_outlined,
                          color: Color.fromARGB(255, 39, 39, 39),
                        ),
                        Text(
                          "${data['Title']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 39, 39, 39),
                          ),
                        ),
                      ],
                    ),

                    // ---------- Container des informations de l'event ----------
                    //
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                width: 450,
                                height: 300,
                                decoration: BoxDecoration(color: Colors.black),
                              )
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                          ),
                          Column(
                            children: [
                              Row(children: [
                                const Icon(Icons.calendar_today),
                                Text(
                                  " ${data['Date'].toDate().toString().split(" ")[0]}",
                                  style: const TextStyle(fontSize: 16),
                                )
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.people_alt),
                                  Text(
                                      " ${data['Users'].length}/${data['PeopleLimit']}",
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(Icons.place),
                                  Text("${data['Location']}",
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.20,
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: Text(
                                  "${data['Description']}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/details',
                                        arguments:
                                            idEventParticipation.toString(),
                                      );
                                    },
                                    icon: const Icon(Icons.more),
                                    label: const Text("Plus d'infos"),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(140, 140, 140, 1),
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  myEvent(
                                      idEvent: idEventParticipation.toString()),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            );
          }
          return const Text("");
        });
  }
}

class myEvent extends StatefulWidget {
  String? idEvent;
  myEvent({Key? key, required this.idEvent}) : super(key: key);

  @override
  State<myEvent> createState() => _myEventState();
}

class _myEventState extends State<myEvent> {
  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    CollectionReference userRef = FirebaseFirestore.instance
        .collection('User')
        .doc(result!.uid)
        .collection('MyEvent');

    Text dialog = const Text('');
    Text unsubDialog = const Text('Désinscription');
    Text subDialog = const Text('Inscription');

    Text question = const Text('');
    Text unsubQuestion = const Text('Quitter cet événement ?');
    Text subQuestion = const Text('S\'inscrire à cet évenement ?');

    Text buttonText = const Text('');
    Text unsubButtonText = const Text('Se désinscrire');
    Text subButtonText = const Text('S\'inscire');

    Icon icon = const Icon(Icons.circle);
    Icon unsubIcon = const Icon(Icons.remove_circle_outlined);
    Icon subIcon = const Icon(Icons.remove_circle_outlined);

    var buttonColor =
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 172, 160, 160));

    var subButtonColor =
        MaterialStateProperty.all<Color>(const Color.fromARGB(255, 7, 194, 54));

    var unsubButtonColor = MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 233, 17, 17));

    return FutureBuilder(
        future: userRef.doc(widget.idEvent.toString()).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              dialog = unsubDialog;
              question = unsubQuestion;
              buttonText = unsubButtonText;
              buttonColor = unsubButtonColor;
              icon = unsubIcon;
              return TextButton.icon(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: dialog,
                    content: question,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          deleteEvent(widget.idEvent);
                          deleteCountEvent(widget.idEvent);
                          Navigator.pop(context, 'Oui !');
                          setState(() {});
                        },
                        child: const Text('Oui...'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Non !'),
                        child: const Text('Non !'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.remove_circle_outlined),
                label: buttonText,
                style: ButtonStyle(
                  backgroundColor: buttonColor,
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              );
            } else {
              dialog = subDialog;
              question = subQuestion;
              buttonText = subButtonText;
              buttonColor = subButtonColor;
              icon = subIcon;
              return TextButton.icon(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: dialog,
                    content: question,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          addEvent(widget.idEvent);
                          addCountEvent(widget.idEvent);
                          Navigator.pop(context, 'Oui !');
                          setState(() {});
                        },
                        child: const Text('Oui...'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Non !'),
                        child: const Text('Non !'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.remove_circle_outlined),
                label: buttonText,
                style: ButtonStyle(
                  backgroundColor: buttonColor,
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              );
            }
          } else {
            return const Text("");
          }
        });
  }
}

Future<void> addEvent(idEvent) {
  User? result = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance
      .collection('User')
      .doc(result!.uid)
      .collection('MyEvent');
  return users
      .doc(idEvent)
      .set({
        'idEvent': idEvent,
      })
      .then((value) => print("IdEvent Added"))
      .catchError((error) => print("Failed to add : $error"));
}

Future<void> addCountEvent(idEvent) {
  User? result = FirebaseAuth.instance.currentUser;
  CollectionReference event = FirebaseFirestore.instance.collection('Event');
  return event
      .doc(idEvent)
      .update({
        'Users': FieldValue.arrayUnion([result!.uid])
      })
      .then((value) => print("Event Updated User"))
      .catchError((error) => print("Failed to update event: $error"));
  ;
}

Future<void> deleteEvent(idEvent) {
  User? result = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance
      .collection('User')
      .doc(result!.uid)
      .collection('MyEvent');
  return users
      .doc(idEvent)
      .delete()
      .then((value) => print("IdEvent delete"))
      .catchError((error) => print("Failed to delete : $error"));
}

Future<void> deleteCountEvent(idEvent) {
  User? result = FirebaseAuth.instance.currentUser;
  CollectionReference event = FirebaseFirestore.instance.collection('Event');
  return event
      .doc(idEvent)
      .update({
        'Users': FieldValue.arrayRemove([result!.uid])
      })
      .then((value) => print("Event Updated User"))
      .catchError((error) => print("Failed to update event: $error"));
}
