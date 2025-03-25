import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class CreateRecordingScreen extends StatefulWidget {
const CreateRecordingScreen({super.key});

@override
State<CreateRecordingScreen> createState() => CreateRecordingScreenState();
}

class CreateRecordingScreenState extends State<CreateRecordingScreen> {
final FocusNode _titleFocusNode = FocusNode();

final recorder = Record();
late AudioPlayer _audioPlayer;

var buttenTapped = false;
String? recordedFilePath;
Timer? _timer;
int _elapsedSeconds = 0;

@override
void initState(){
  super.initState();
  _audioPlayer = AudioPlayer();
}
@override
void dispose(){
  _audioPlayer.dispose();
  super.dispose();
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEFE4),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topBackButtonTitle(),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 10),
                  child: commontitleTextWidget("Title",true),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: commonTextFieldWidget("Title"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10),
                  child: commontitleTextWidget("Topic",true),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: commonTextFieldWidget("Topic"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10),
                  child: commontitleTextWidget("Recording",true),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: recorderField(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: Center(child: startRecording()),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 15,
            right: 15,
            child: saveButton(),
          ),
        ],
      ),
    );
  }

Widget topBackButtonTitle() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Bounceable(onTap: () {
        Navigator.of(context).pop();
      }, child:
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF5D5FEF),
            size: 20,
          ),
        ),

      ),),
      Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Container(
          height: 46,
          width: 190,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
          ),
          child: const Center(
            child: Text(
              'Create a recording',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF5D5FEF),

              ),

            ),
          ),
        ),
      )
    ],
  );
}
Widget commontitleTextWidget(String titleText, bool isRequired) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        titleText,
        style: const TextStyle(
          decoration: TextDecoration.none,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
      if (isRequired) // Only show red star if required
        const Text(
          ' *',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
    ],
  );
}

Widget commonTextFieldWidget(String placeholderText) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xFFECE3D9),
    ),
    child: TextFormField(
      onTapOutside: (event) {
        _titleFocusNode.unfocus();
      },
      // controller: _searchController,
      focusNode: _titleFocusNode,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (value) {
        // _onSearchChanged();
      },
      textCapitalization:
      TextCapitalization.sentences,
      // inputFormatters: <TextInputFormatter>[
      //   CustomInputFormatter()
      // ],
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9&@#+-. ]*")),],
      cursorColor: Colors.white,
      enableInteractiveSelection: true,
      // enabled: ref
      //     .watch(globalSearchUINotifier)
      //     .isSearch,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        decoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholderText,
        hintStyle:const TextStyle(
          color:  Colors.black,
            fontSize: 15,
            height: 1,
          fontWeight: FontWeight.normal,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    ),
  );
}
Widget recorderField() {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xFFECE3D9),
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 10.0,right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("File Audio"),
      Row(
        children: [
          Bounceable(
            onTap: () async {
              if (recordedFilePath != null) {
                final player = AudioPlayer();
                await player.setFilePath(recordedFilePath!);
                player.play();
                // await _audioPlayer.setFilePath(recordedFilePath!);
                // _audioPlayer.play();
                print("Playing recording");
              }
            },
            child: Visibility(
              visible: recordedFilePath != null,
              child: Icon(Icons.play_circle, color: Color(0xFF5D5FEF), size: 20),
            ),
          ),
          Bounceable(
            onTap: () {
              print("tapped delete");
            },
            child: Visibility(
              visible: recordedFilePath != null,
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(Icons.delete,
                  color: Color(0xFF5D5FEF),
                  size: 20,),
              ),
            ),
          )
        ],
      )
        ],
      ),
    )
  );
}
Widget startRecording() {
  return Column(
    children: [
      const Text("Start recording",style: TextStyle(
        color:  Colors.black,
        fontSize: 16,
        height: 1,
        fontWeight: FontWeight.w700,
      ),),
      Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Bounceable(
          onTap: () {
            if (buttenTapped) {
              _stopRecording();
            } else {
              _requestMicrophonePermission();
            }
            setState(() {
              buttenTapped = !buttenTapped;
            });
          },
          child: Image.asset(
            'assets/images/record-button.png',
            width: 122,
            height: 122,
          ),
        ),
      ),
 Padding(padding: const EdgeInsets.only(top: 10.0),
child: Text(
  "00:${_elapsedSeconds.toString().padLeft(2, '0')}" ,
  style: const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  ),
  ),
 )
    ],
  );
}
Future<void> _requestMicrophonePermission() async {
  final PermissionStatus status = await Permission.microphone.request();
  if (status == PermissionStatus.granted) {
    _startRecording();
    // Permission granted, proceed with recording
  } else {
    // Permission denied, handle accordingly (e.g., show a message to the user)
  }
}
Future<void> _startRecording() async {
  try {
    if (await recorder.hasPermission()) {
      // Get the directory to save file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/myFile_${DateTime.now().millisecondsSinceEpoch}.m4a';
      print("Recording started. File path: $filePath");

      await recorder.start(
        path: filePath,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
        });
      });
    } else {
      // Handle permission denied
      print("Recording permission denied.");
    }
  } catch (e) {
    print("Start recording error: $e");
  }
}

Future<void> _stopRecording() async {
  try {
      final path = await recorder.stop();
      if (path != null) {
        print("Recording saved at: $path");
        _timer?.cancel();
        setState(() {
          recordedFilePath = path;
          _elapsedSeconds = 0;
        });

    } else {
      print("Recording failed to save.");
    }
  } catch (e) {
    print("Stop recording error: $e");
  }
}



Widget saveButton(){
    return Bounceable(
      onTap: () {
        if (recordedFilePath != null) {
          print("Recording saved at: $recordedFilePath");
          // You can navigate or store file
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please record audio before saving")),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF5D5FEF),
          borderRadius: BorderRadius.circular(35),
        ),
        height: 51,
        child: const Center(
          child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );

}
}