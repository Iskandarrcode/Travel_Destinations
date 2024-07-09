import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars8/controller/destanation_controller.dart';
import 'package:dars8/views/widgets/alert_dialog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              builder: (context) => const AlertDialogWidgets(isEdit: false),
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
              var data = destination.data() as Map<String, dynamic>?;
              var imageUrl = data != null && data.containsKey('imageUrl')
                  ? data['imageUrl']
                  : 'default_image_url';
              var title = data != null && data.containsKey('title')
                  ? data['title']
                  : 'No title available';
              var lat = data != null && data.containsKey('lan')
                  ? data['lan']
                  : 'No latitude available';
              var long = data != null && data.containsKey('long')
                  ? data['long']
                  : 'No longitude available';

              return ListTile(
                leading: Container(
                  width: 55,
                  height: 66,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(title),
                subtitle: Text("lat: $lat\nlong: $long"),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialogWidgets(
                          isEdit: true,
                          docId: destination.id,
                          initialTitle: title,
                          initialImageUrl: imageUrl,
                          initialLat: lat,
                          initialLong: long,
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await context
                            .read<DestinationsController>()
                            .deleteDestination(destination.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
