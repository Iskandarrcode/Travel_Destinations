import 'dart:io';
import 'package:dars8/controller/destanation_controller.dart';
import 'package:dars8/services/location_services.dart';
import 'package:dars8/utils/show_loader.dart';
import 'package:dars8/views/widgets/textFormFields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AlertDialogWidgets extends StatefulWidget {
  final bool isEdit;
  final String? docId;
  final String? initialTitle;
  final String? initialImageUrl;
  final String? initialLat;
  final String? initialLong;

  const AlertDialogWidgets({
    super.key,
    required this.isEdit,
    this.docId,
    this.initialTitle,
    this.initialImageUrl,
    this.initialLat,
    this.initialLong,
  });

  @override
  State<AlertDialogWidgets> createState() => _AlertDialogWidgetsState();
}

class _AlertDialogWidgetsState extends State<AlertDialogWidgets> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  var myLocation = LocationService.currentLocation;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _titleController.text = widget.initialTitle ?? '';
      // Additional initialization for editing
    }
    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLocation();
      setState(() {});
    });
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void addOrEditDestination() async {
    if (_formKey.currentState!.validate() && (_imageFile != null || widget.isEdit) && myLocation != null) {
      Messages.showLoadingDialog(context);
      try {
        if (widget.isEdit) {
          await context.read<DestinationsController>().editDestination(
                docId: widget.docId!,
                imageFile: _imageFile,
                title: _titleController.text,
                lat: myLocation!.latitude.toString(),
                long: myLocation!.longitude.toString(),
              );
        } else {
          await context.read<DestinationsController>().addDestination(
                imageFile: _imageFile!,
                title: _titleController.text,
                lat: myLocation!.latitude.toString(),
                long: myLocation!.longitude.toString(),
              );
        }
        _titleController.clear();
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the loading dialog
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the alert dialog
      } catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the loading dialog
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding destination: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and select an image.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: widget.isEdit
          ? const Text("Edit destination")
          : const Text("Add a destination"),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormField(
              label:
                  widget.isEdit ? "New Destination title" : "Destination title",
              controller: _titleController,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Please, enter the title of the destination!";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Add picture",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: openCamera,
                  label: const Text("Camera"),
                  icon: const Icon(Icons.camera),
                ),
                TextButton.icon(
                  onPressed: openGallery,
                  label: const Text("Gallery"),
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
            if (_imageFile != null || widget.initialImageUrl != null)
              SizedBox(
                height: 150,
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.initialImageUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lat: ${myLocation?.latitude?.toStringAsFixed(3)}\nLong: ${myLocation?.longitude?.toStringAsFixed(3)}",
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () async {
            await LocationService.getCurrentLocation();
            addOrEditDestination();
          },
          child: widget.isEdit ? const Text("Edit") : const Text("Add"),
        ),
      ],
    );
  }
}
