// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';

// class ImageFirebaseServices {
//   final _destinationsCollection =
//       FirebaseFirestore.instance.collection("destinations");
//   final _destnationsStorage = FirebaseStorage.instance;

//   Stream<QuerySnapshot> getDestinations() async* {
//     yield* _destinationsCollection.snapshots();
//   }

//   Future<void> addDestinations({
//     required File imageFile,
//     required String title,
//     required String lat,
//     required String long,
//   }) async {
//     final imageRef = _destnationsStorage
//         .ref()
//         .child("destinations")
//         .child("${DateTime.now().microsecondsSinceEpoch}.jpg");

//     final uploadTask = imageRef.putFile(imageFile);

//     uploadTask.snapshotEvents.listen((status) {
//       debugPrint("Uploading status: ${status.state}");
//       double percentage =
//           (status.bytesTransferred / imageFile.lengthSync()) * 100;
//       debugPrint("Uploading percentage: $percentage");
//     });

//     await uploadTask.whenComplete(
//       () async {
//         final imageUrl = await imageRef.getDownloadURL();
//         await _destinationsCollection.add(
//           {
//             "title": title,
//             "imageUrl": imageUrl,
//             "lan": lat,
//             "long": long,
//           },
//         );
//       },
//     );
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageFirebaseServices {
  final _destinationsCollection =
      FirebaseFirestore.instance.collection("destinations");
  final _destinationsStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getDestinations() async* {
    yield* _destinationsCollection.snapshots();
  }

  Future<void> addDestination({
    required File imageFile,
    required String title,
    required String lat,
    required String long,
  }) async {
    final imageRef = _destinationsStorage
        .ref()
        .child("destinations")
        .child("${DateTime.now().microsecondsSinceEpoch}.jpg");

    final uploadTask = imageRef.putFile(imageFile);

    uploadTask.snapshotEvents.listen((status) {
      debugPrint("Uploading status: ${status.state}");
      double percentage =
          (status.bytesTransferred / imageFile.lengthSync()) * 100;
      debugPrint("Uploading percentage: $percentage");
    });

    await uploadTask.whenComplete(
      () async {
        final imageUrl = await imageRef.getDownloadURL();
        await _destinationsCollection.add(
          {
            "title": title,
            "imageUrl": imageUrl,
            "lat": lat,
            "long": long,
          },
        );
      },
    );
  }

  Future<void> editDestination({
    required String docId,
    File? imageFile,
    required String title,
    required String lat,
    required String long,
  }) async {
    String? imageUrl;

    if (imageFile != null) {
      final imageRef = _destinationsStorage
          .ref()
          .child("destinations")
          .child("${DateTime.now().microsecondsSinceEpoch}.jpg");

      final uploadTask = imageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((status) {
        debugPrint("Uploading status: ${status.state}");
        double percentage =
            (status.bytesTransferred / imageFile.lengthSync()) * 100;
        debugPrint("Uploading percentage: $percentage");
      });

      await uploadTask.whenComplete(
        () async {
          imageUrl = await imageRef.getDownloadURL();
        },
      );
    }

    final data = {
      "title": title,
      "lat": lat,
      "long": long,
    };

    if (imageUrl != null) {
      data["imageUrl"] = imageUrl!;
    }

    await _destinationsCollection.doc(docId).update(data);
  }

  Future<void> deleteDestination(String docId) async {
    final docSnapshot = await _destinationsCollection.doc(docId).get();

    if (docSnapshot.exists) {
      final imageUrl = docSnapshot["imageUrl"] as String?;
      if (imageUrl != null) {
        final ref = _destinationsStorage.refFromURL(imageUrl);
        await ref.delete();
      }

      await _destinationsCollection.doc(docId).delete();
    }
  }
}
