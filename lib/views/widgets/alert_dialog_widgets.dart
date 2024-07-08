// import 'dart:io';

// import 'package:dars8/controller/destanation_controller.dart';
// import 'package:dars8/services/location_services.dart';
// import 'package:dars8/utils/show_loader.dart';
// import 'package:dars8/views/widgets/textFormFields.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class AlertDialogWidgets extends StatefulWidget {
//   const AlertDialogWidgets({super.key});

//   @override
//   State<AlertDialogWidgets> createState() => _AlertDialogWidgetsState();
// }

// class _AlertDialogWidgetsState extends State<AlertDialogWidgets> {
//   final _titleController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   File? _imageFile;
//   var myLocation = LocationService.currentLocation;

//   void openGallery() async {
//     final imagePicker = ImagePicker();
//     final XFile? pickedImage = await imagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       requestFullMetadata: false,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   void openCamera() async {
//     final imagePicker = ImagePicker();
//     final XFile? pickedImage = await imagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 50,
//       requestFullMetadata: false,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   void addCategory() async {
//     Messages.showLoadingDialog(context);
//     await context
//         .read<DestinationsController>()
//         .addDestination(
//           imageFile: _imageFile!,
//           title: _titleController.text,
//           lat: myLocation!.latitude.toString(),
//           long: myLocation!.longitude.toString(),
//         )
//         .then(
//       (value) {
//         _titleController.clear();
//         Navigator.pop(context);
//         Navigator.pop(context);
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(
//       Duration.zero,
//       () async {
//         await LocationService.getCurrentLocation().then((_) => setState(() {}));
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       scrollable: true,
//       title: const Text("Add a destination"),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             MyTextFormField(
//               label: "Destination title",
//               controller: _titleController,
//               validator: (value) {
//                 if (value!.trim().isEmpty) {
//                   return "Please, enter title of destination!";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Add picture",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton.icon(
//                   onPressed: openCamera,
//                   label: const Text("Camera"),
//                   icon: const Icon(Icons.camera),
//                 ),
//                 TextButton.icon(
//                   onPressed: openGallery,
//                   label: const Text("Gallery"),
//                   icon: const Icon(Icons.image),
//                 ),
//               ],
//             ),
//             if (_imageFile != null)
//               SizedBox(
//                 height: 150,
//                 child: Image.file(
//                   _imageFile!,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                     "Lat: ${myLocation?.latitude?.toStringAsFixed(3)}\nLong: ${myLocation?.longitude?.toStringAsFixed(3)}"),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await LocationService.getCurrentLocation();
//                     setState(() {});
//                   },
//                   child: Text("Get location"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text("Cancel"),
//         ),
//         FilledButton(
//           onPressed: addCategory,
//           child: const Text("Add"),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';

import 'package:dars8/controller/destanation_controller.dart';
import 'package:dars8/services/location_services.dart';
import 'package:dars8/utils/show_loader.dart';
import 'package:dars8/views/widgets/textFormFields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AlertDialogWidgets extends StatefulWidget {
  const AlertDialogWidgets({super.key});

  @override
  State<AlertDialogWidgets> createState() => _AlertDialogWidgetsState();
}

class _AlertDialogWidgetsState extends State<AlertDialogWidgets> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  var myLocation = LocationService.currentLocation;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
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
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void addCategory() async {
    print("-------");
    print(myLocation);
    if (_formKey.currentState!.validate() &&
        _imageFile != null &&
        myLocation != null) {
      Messages.showLoadingDialog(context);
      try {
        await context
            .read<DestinationsController>()
            .addDestination(
              imageFile: _imageFile!,
              title: _titleController.text,
              lat: myLocation!.latitude.toString(),
              long: myLocation!.longitude.toString(),
            )
            .then((value) {
          _titleController.clear();
          Navigator.pop(context); // Close the loading dialog
          Navigator.pop(context); // Close the alert dialog
        });
      } catch (e) {
        // Handle error
        Navigator.pop(context); // Close the loading dialog
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
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        await LocationService.getCurrentLocation().then(
          (_) => setState(() {}),
        );
      },
    );
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
      title: const Text("Add a destination"),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormField(
              label: "Destination title",
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
            if (_imageFile != null)
              SizedBox(
                height: 150,
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Lat: ${myLocation?.latitude?.toStringAsFixed(3)}\nLong: ${myLocation?.longitude?.toStringAsFixed(3)}"),
                ElevatedButton(
                  onPressed: () async {
                    await LocationService.getCurrentLocation();
                    setState(() {});
                  },
                  child: const Text("Get location"),
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
          onPressed: addCategory,
          child: const Text("Add"),
        ),
      ],
    );
  }
}
