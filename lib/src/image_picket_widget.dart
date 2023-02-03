import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fancy_form_inputs/src/fancy_inputs_config.dart';
import 'package:fancy_form_inputs/src/switch_widget.dart';
import 'package:fancy_form_inputs/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FancyImagePickerWidget extends ConsumerWidget {
  String? labelText = "";

  TextEditingController? textEditingController;
  String? errorText;
  ValueChanged<dynamic>? onChanged;
  ValueChanged<File>? onFileChanged;
  File? file;

  FancyInputConfig? config;
  void Function()? trigger;
  bool allow_gallary = true;
  bool allow_image_capture = true;

  FancyImagePickerWidget({
    @required this.labelText,
    this.textEditingController,
    this.errorText,
    this.onChanged,
    this.onFileChanged,
    this.file,
    this.config,
    this.trigger,
    this.allow_gallary = true,
    this.allow_image_capture = true,
  });

  Widget build(BuildContext context, watch) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              config!.labelText!,
              style: TextStyle(
                  // color: Cc.TEXT_SECONDARY,
                  ),
            )),
        SizedBox(
          height: 5,
        ),
        DottedBorder(
          // color: Cc.black,
          strokeWidth: 0.5,
          dashPattern: [5, 3],
          child: Center(
            child: GestureDetector(
              onTap: () async {
                if (allow_image_capture) {
                  //add exception

                  if (!allow_gallary) {
                    // bool accepted = await _hasAcceptedPermissions();
                    bool accepted = true;
                    if (accepted) {
                      _imgFromCamera(context);
                    } else {
                      Util.showErrorNotification(context, "Permissions Error",
                          "Permissions not granted");
                    }
                  } else {
                    _showPicker(context);
                  }
                }
              },
              child: CircleAvatar(
                radius: 55,
                // backgroundColor: Cc.bgColor,
                child: config!.file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          config!.file!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            // color: Cc.BG_FRONT,
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          // color: Cc.TEXT_HINT,
                        ),
                      ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        config!.error != null
            ? Text(
                config!.error!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              )
            : SizedBox(),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  _requestPermission(Permission permission) async {
    return await permission.request().isGranted;
  }

  /*Future<bool> _hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;

      if (sdkInt == 29) {
        if (await _requestPermission(Permission
                .storage) */ /*&&
            // access media location needed for android 10/Q
            await _requestPermission(Permission.accessMediaLocation)*/ /*
            ) {
          return true;
        } else {
          return false;
        }
      } else if (sdkInt > 29) {
        if (await _requestPermission(Permission.storage) &&
            // access media location needed for android 10/Q
            await _requestPermission(Permission.accessMediaLocation) &&
            // manage external storage needed for android 11/R
            await _requestPermission(Permission.manageExternalStorage)) {
          return true;
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.storage)) {
          return true;
        } else {
          return false;
        }
      }
    }
    if (Platform.isIOS) {
      if (await _requestPermission(Permission.photos)) {
        return true;
      } else {
        return false;
      }
    } else {
      // not android or ios
      return false;
    }
  }*/

  Future<void> _showPicker(context) async {
    // bool accepted = await _hasAcceptedPermissions();
    bool accepted = true;
    if (accepted) {
      // Either the permission was already granted before or the user just granted it.
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    allow_gallary
                        ? new ListTile(
                            leading: new Icon(Icons.photo_library),
                            title: new Text('Photo Library'),
                            onTap: () {
                              _imgFromGallery();
                              Navigator.of(context).pop();
                            })
                        : SizedBox.shrink(),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera(context);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      Util.showErrorNotification(
          context, "Permissions Error", "Permissions not granted");
    }
  }

  _imgFromCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    // print("12222");
    /*final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );*/

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    final image = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => TakePictureScreen(
                // Pass the appropriate camera to the TakePictureScreen widget.
                camera: firstCamera,
              )),
    );

    // print("1344444");

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              // toolbarColor: Cc.BG_APP_BAR,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Image Cropper',
          )
        ],
      );
      if (croppedFile != null) {
        // print("it was cropped");
        if (textEditingController != null) {
          List<int> imageBytes = await image.readAsBytes();
          textEditingController!.text = base64Encode(imageBytes);
        }

        if (config != null) {
          List<int> imageBytes = await croppedFile.readAsBytes();
          config!.onValueChanged(base64Encode(imageBytes));
          config!.onFileChange(new File(croppedFile.path));

          if (trigger != null) {
            trigger!();
          }
        }
      }
    }
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              // toolbarColor: Cc.BG_APP_BAR,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Image Cropper',
          )
        ],
      );

      if (croppedFile != null) {
        /* if (textEditingController != null) {
        List<int> imageBytes = await image.readAsBytes();
        textEditingController!.text = base64Encode(imageBytes);
      }*/

        if (config != null) {
          List<int> imageBytes = await croppedFile.readAsBytes();
          config!.onValueChanged(base64Encode(imageBytes));
          config!.onFileChange(new File(croppedFile.path));

          if (trigger != null) {
            trigger!();
          }
        }
      }
    }
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Baridi Camera')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                CameraPreview(_controller),
                FancySwitchInput(
                  labelText: "Light",
                  initialValue: true,
                  textOn: "On",
                  textOff: "Off",
                  onChanged: (b) {
                    if (b) {
                      _controller.setFlashMode(FlashMode.always);
                    } else {
                      _controller.setFlashMode(FlashMode.off);
                    }

                    /* hasServiceTag.onValueChanged(b);
                    setState(() {});*/
                  },
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            // If the picture was taken, display it on a new screen.
            /*await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );*/

            Navigator.pop(context, image);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
/*class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}*/
