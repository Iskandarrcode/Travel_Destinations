// import 'package:dars8/controller/destanation_controller.dart';
// import 'package:dars8/services/location_services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       await LocationServices.getCurrentLocation();
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         centerTitle: true,
//         title: const Text("My travel destinations"),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: context.read<DestanationController>().destinations,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (!snapshot.hasData) {
//             return const Center(
//               child: Text("Couldn't fetch destinations."),
//             );
//           }

//           if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("No destinations found."),
//             );
//           }

//           final destinations = snapshot.data!.docs;

//           return ListView.builder(
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Image.network(destination.imageUrl),
//                 title: Text(destination.title),
//                 subtitle:
//                     Text("lat: ${destination.lat}\nlong: ${destination.long}"),
//                 isThreeLine: true,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars8/controller/destanation_controller.dart';
import 'package:dars8/views/widgets/alert_dialog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assuming you are using Provider for state management
import 'package:dars8/services/location_services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLocation();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text("My travel destinations"),
        actions: [
          IconButton(
            onPressed: () => showDialog(
          context: context,
          builder: (context) => const AlertDialogWidgets(),
        ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<DestinationsController>().destinations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Couldn't fetch destinations."),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No destinations found."),
            );
          }

          final destinations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              var destination = destinations[index];
              return ListTile(
                leading: Image.network(destination['imageUrl']),
                title: Text(destination['title']),
                subtitle: Text(
                    "lat: ${destination['lat']}\nlong: ${destination['long']}"),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
