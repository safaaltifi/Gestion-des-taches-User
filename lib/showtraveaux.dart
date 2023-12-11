// page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'traveaux_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class ShowTraveaux extends StatefulWidget {
  final String identifiant;
  final String mdp;
  final List<Traveaux> travauxList;
  final Function(Traveaux traveau)? onEdit;


  ShowTraveaux({
    Key? key,
    required this.identifiant,
    required this.mdp,
    required this.travauxList,
    this.onEdit
  }) : super(key: key);

  @override
  _ShowTraveauxState createState() => _ShowTraveauxState();
}

class _ShowTraveauxState extends State<ShowTraveaux> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travaux de ${widget.identifiant}'),
      ),
      body: ListView.builder(
        itemCount: widget.travauxList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.travauxList[index].titre),
            subtitle: Text(widget.travauxList[index].desc),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editTraveau(widget.travauxList[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    _displayTraveau(widget.travauxList[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editTraveau(Traveaux traveau) async{
    // Trigger the onEdit callback to edit the traveau
    if (widget.onEdit != null) {
      await widget.onEdit!(traveau);
    } else {
      // If onEdit is not provided, navigate to the EditTraveauPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTraveauPage(traveau: traveau),
        ),
      );
    }


  }


  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // Delete the user from the server
                try {
                  await apiService.deleteTrav(widget.travauxList[index].id  );
                } catch (e) {
                  print('Error deleting traveau: $e');
                  // Handle error, show a message, etc.
                }

                // Remove the user from the local list
                setState(() {
                  widget.travauxList.removeAt(index);
                });

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  void _displayTraveau(Traveaux traveau) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Traveau Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Titre: ${traveau.titre}'),
              Text('Description: ${traveau.desc}'),
              Text('Type: ${traveau.type}'),
              Text('Position: ${traveau.position}'),
              // ... Add more details as needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}



class EditTraveauPage extends StatefulWidget {
  final Traveaux traveau;

  EditTraveauPage({required this.traveau});

  @override
  _EditTraveauPageState createState() => _EditTraveauPageState();
}

class _EditTraveauPageState extends State<EditTraveauPage> {
  final TextEditingController titreController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController descRemarqueController = TextEditingController();
  final TextEditingController photosRemarqueController = TextEditingController();
  final TextEditingController positionRemarqueController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();


  List<String> selectedPhotos = [];

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current values
    titreController.text = widget.traveau.titre;
    descController.text = widget.traveau.desc;
    typeController.text = widget.traveau.type;
    positionController.text = widget.traveau.position;
    // Initialize remark-related text controllers with current values
    descRemarqueController.text = widget.traveau.remarque.desc;
    selectedPhotos = List.from(widget.traveau.remarque.photos);
    photosRemarqueController.text = selectedPhotos.join(', ');
    positionRemarqueController.text = widget.traveau.remarque.position;
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Convert the picked image to base64
      List<int> imageBytes = await pickedImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        selectedPhotos.add(pickedImage.path);
        photosRemarqueController.text = selectedPhotos.join(', ');
      });

    }
  }

  // Function to take a photo using the camera
  Future<void> _takePhoto() async {
    final XFile? takenPhoto = await _imagePicker.pickImage(source: ImageSource.camera);
    if (takenPhoto != null) {
      setState(() {
        selectedPhotos.add(takenPhoto.path);
        photosRemarqueController.text = selectedPhotos.join(', ');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Traveau'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: positionController,
              decoration: InputDecoration(labelText: 'Position'),
            ),
            SizedBox(height: 16),
            // Add UI components for editing remark properties
            Text('Remarque:'),
            TextField(
              controller: descRemarqueController,
              decoration: InputDecoration(labelText: 'Description Remarque'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _takePhoto();
              },
              child: Text('Take Photo'),
            ),
            TextField(
              controller: positionRemarqueController,
              decoration: InputDecoration(labelText: 'Position Remarque'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    // Get the modified values from text controllers
    String modifiedTitre = titreController.text;
    String modifiedDesc = descController.text;
    String modifiedType = typeController.text;
    String modifiedPosition = positionController.text;
    // Get the modified values for the remark
    String modifiedDescRemarque = descRemarqueController.text;
    String modifiedPositionRemarque = positionRemarqueController.text;

    // Create a new Traveaux object with modified values
    Traveaux modifiedTraveau = widget.traveau.copyWith(
      titre: modifiedTitre,
      desc: modifiedDesc,
      type: modifiedType,
      position: modifiedPosition,
      remarque: Remarque(
        desc: modifiedDescRemarque,
        photos: selectedPhotos,
        position: modifiedPositionRemarque,
      ),
    );

    // Call the API service to update the traveau
    try {
      await ApiService().editTraveau(widget.traveau.id, modifiedTraveau);
      // If the update is successful, you can notify the user or perform any other actions.
      print('Traveau updated successfully');
    } catch (e) {
      // Handle error, show a message, etc.
      print('Error updating traveau: $e');
    }

    // You can also pop the current screen to navigate back
    Navigator.pop(context);
  }
}
