import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars8/services/image_firebase_services.dart';
import 'package:flutter/foundation.dart';

class DestinationsController extends ChangeNotifier {
  final _destinationsService = ImageFirebaseServices();

  Stream<QuerySnapshot> get destinations async* {
    yield* _destinationsService.getDestinations();
  }

  Future<void> addDestination({
    required File imageFile,
    required String title,
    required String lat,
    required String long,
  }) async {
    await _destinationsService.addDestinations(
      imageFile: imageFile,
      title: title,
      lat: lat,
      long: long,
    );
  }
}