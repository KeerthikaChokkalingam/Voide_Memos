import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class CreateRecordingScreen extends StatefulWidget {
  final int tappedIndex;
 const CreateRecordingScreen({super.key,this.tappedIndex = -1});

@override
State<CreateRecordingScreen> createState() => CreateRecordingScreenState();
}

class CreateRecordingScreenState extends State<CreateRecordingScreen> {
final FocusNode _titleFocusNode = FocusNode();
final FocusNode _topicFocusNode = FocusNode();

final recorder = Record();
late AudioPlayer _audioPlayer;

var buttenTapped = false;
String? recordedFilePath;
Timer? _timer;
int _elapsedSeconds = 0;
int deniedCount = 0;
final TextEditingController _firstController = TextEditingController();
final TextEditingController _secondController = TextEditingController();
bool isPlaying = false;
bool isPaused = false;
final box = Hive.box('recordingsListData');
bool isEditing = false;
List userList = Hive.box('recordingsListData').get('recordingsList', defaultValue: []);

@override
void initState(){
  super.initState();
  if(widget.tappedIndex != -1){
    var selectedValue = userList[widget.tappedIndex];
    _secondController.text = selectedValue["topicName"].toString();
    recordedFilePath = selectedValue["recordedStringFilePath"].toString();
    _firstController.text = selectedValue["titleName"].toString();
    isEditing = true;
  } else {
    _firstController.text = "";
    _secondController.text = "";
  }
  _audioPlayer = AudioPlayer();
  _audioPlayer.playerStateStream.listen((state) {
    if (state.processingState == ProcessingState.completed) {
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    }
  });
}
@override
void dispose(){
  _audioPlayer.dispose();
  _firstController.dispose();
  _secondController.dispose();
  _titleFocusNode.unfocus();
  _topicFocusNode.unfocus();
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
                  child: commonTextFieldWidget("Enter Title",_firstController,_titleFocusNode),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10),
                  child: commontitleTextWidget("Topic",true),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: commonTextFieldWidget("Enter Topic",_secondController,_topicFocusNode),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 40,left: 15,right: 15,top: 30),
                  child: saveButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget topBackButtonTitle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Bounceable(onTap: () {
        Navigator.of(context).pop(true);
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
      ),
      Visibility(
        visible: isEditing,
        child: Bounceable(onTap: () {
          deleteUser(widget.tappedIndex);
        }, child:
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: const Center(
            child: Icon(
              Icons.delete,
              color: Color(0xFF5D5FEF),
              size: 20,
            ),
          ),

        ),),
      ),
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

Widget commonTextFieldWidget(String placeholderText,TextEditingController controller,FocusNode focusNode) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xFFECE3D9),
    ),
    child:TextFormField(
      controller: controller, // First TextField
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9&@#+-. ]*")),
      ],
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        decoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholderText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
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
      padding: const EdgeInsets.only(left: 10.0,right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text((recordedFilePath != null && _firstController.text.isNotEmpty) ? "${_firstController.text} Audio File" :"Start Recording Your File",style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),),
      Row(
        children: [
          Bounceable(
            scaleFactor: 0.6,
            onTap: () async {
              if (recordedFilePath == null) return;
              if (!isPlaying && !isPaused) {
                await _audioPlayer.setFilePath(recordedFilePath!);
                setState(() {
                  isPlaying = true;
                  isPaused = false;
                });
                await _audioPlayer.play();
              }

              else if (isPlaying) {
                await _audioPlayer.pause();
                setState(() {
                  isPlaying = false;
                  isPaused = true;
                });
              }

              else if (isPaused) {
                setState(() {
                  isPlaying = true;
                  isPaused = false;
                });
                await _audioPlayer.play();
              }

            },
            child: Visibility(
              visible: recordedFilePath != null,
              child: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: const Color(0xFF5D5FEF),
                size: 24,
              ),
            ),
          ),
          Bounceable(
            onTap: () {
              setState(() {
                recordedFilePath = null;
              });
            },
            child: Visibility(
              visible: recordedFilePath != null ,
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
            if (deniedCount == 0){
              if (buttenTapped) {
                _stopRecording();
              } else {
                _requestMicrophonePermission();
              }
              setState(() {
                buttenTapped = !buttenTapped;
              });
            } else {
              _requestMicrophonePermission();
            }
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
    deniedCount = 0;
    _startRecording();
    // Permission granted, proceed with recording
  } else {
    deniedCount++;
    if (deniedCount > 2) {
      deniedCount = 2;
    }
    if (deniedCount == 2) {
      showSettingsDialog(context);
    }
  }
}
void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Permission Required"),
      content: const Text("Please enable microphone permission from settings."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            openAppSettings(); // Open device settings
            Navigator.of(context).pop(true);
          },
          child: const Text("Open Settings"),
        ),
      ],
    ),
  );
}
Future<void> _startRecording() async {
  try {
    if (await recorder.hasPermission()) {
      // Get the directory to save file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/myFile_${DateTime.now().millisecondsSinceEpoch}.m4a';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recording permission denied.",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
          backgroundColor: Color(0xFFECE3A3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 100,left: 10,right: 10),

        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Start recording error",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
        backgroundColor: Color(0xFFECE3A3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100,left: 10,right: 10),

      ),
    );
  }
}

Future<void> _stopRecording() async {
  try {
      final path = await recorder.stop();
      if (path != null) {
        _timer?.cancel();
        setState(() {
          recordedFilePath = path;
          _elapsedSeconds = 0;
        });

    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Recording failed to save. ",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
            backgroundColor: Color(0xFFECE3A3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 100,left: 10,right: 10),

          ),
        );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Stop recording error ",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
        backgroundColor: Color(0xFFECE3A3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100,left: 10,right: 10),

      ),
    );
  }
}


void addUserValue(String titleName,String topicName,String recordedStringFilePath) {
  final existingList = box.get('recordingsList', defaultValue: []) as List;
    existingList.add({'titleName': titleName,'topicName': topicName,'recordedStringFilePath':recordedStringFilePath});
    box.put('recordingsList', existingList);
}
void deleteUser(int index) {
  final box = Hive.box('recordingsListData');
  final userList = box.get('recordingsList', defaultValue: []) as List;
  userList.removeAt(index);
  box.put('recordingsList', userList);
  Navigator.of(context).pop(true);
}
void editUser(int index, String titleName,String topicName,String recordedStringFilePath) {
  final box = Hive.box('recordingsListData');
  final userList = box.get('recordingsList', defaultValue: []) as List;
  userList[index]['titleName'] = titleName;
  userList[index]['topicName'] = topicName;
  userList[index]['recordedStringFilePath'] = recordedStringFilePath;
  box.put('recordingsList', userList);
}
Widget saveButton(){
    return Bounceable(
      onTap: () {
        if (recordedFilePath != null && _firstController.text != "" && _secondController.text != "") {
          if (isEditing) {
            if (userList[widget.tappedIndex]["titleName"].toString() != (_firstController.text) || userList[widget.tappedIndex]["topicName"].toString() != (_secondController.text) || userList[widget.tappedIndex]["recordedStringFilePath"].toString() != (recordedFilePath.toString())){
              editUser(widget.tappedIndex,_firstController.text, _secondController.text,
                  recordedFilePath!);
              Navigator.of(context).pop(true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("The same Recording already exists",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
                  backgroundColor: Color(0xFFECE3A3),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(bottom: 80,left: 10,right: 10),
                ),
              );
            }
          } else {
            addUserValue(_firstController.text, _secondController.text,
                recordedFilePath!);
            Navigator.of(context).pop(true);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all the Required field",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
              backgroundColor: Color(0xFFECE3A3),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 100,left: 10,right: 10),

            ),
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