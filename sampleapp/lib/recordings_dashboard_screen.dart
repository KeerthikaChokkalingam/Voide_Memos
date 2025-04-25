import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'create_recording_screen.dart';
import 'package:cross_file/cross_file.dart';

class NewRecordingScreen extends StatefulWidget {
  const NewRecordingScreen({super.key});

  @override
  State<NewRecordingScreen> createState() => _NewRecordingScreenState();
}

class _NewRecordingScreenState extends State<NewRecordingScreen> {
  List userList = Hive.box('recordingsListData').get('recordingsList', defaultValue: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          headerWidget(),
          Expanded(child: recorderWidget(userList.length)),
        ],
      ),
    );
  }

  Widget headerWidget() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double firstImageWidth = screenWidth * 0.38;
    final double firstImageHeight = firstImageWidth * (202 / 197);

    return Container(
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFAD5B2),
            Color(0xFFFAD5B2),
            Color(0xFFEADEC6),
            Color(0xFFC3F2F9),
            Color(0xFFC5F0F6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 20.0),
                child: Bounceable(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CreateRecordingScreen()),
                    ).then((value) {
                      if (value == true) {
                        setState(() {
                          userList = Hive.box('recordingsListData').get('recordingsList', defaultValue: []);
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 91,
                    height: 41,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      color: const Color(0xFF5D5FEF),
                    ),
                    child: const Center(
                      child: Text(
                        "  +  New  ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Stack(
              children: [
                const Positioned(
                  left: 16, // adjust based on your design
                  top: 40,
                  child: Text(
                    'Record your \nAssignment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 41,
                      fontWeight:FontWeight.w900,
                    ),
                  ),
                ),
                Positioned(
                  right: 16, // adjust based on your design
                  top: 20,
                  child: Image.asset(
                    'assets/images/Books-And-Headset.png',
                    width: firstImageWidth,  // adjust width
                    height: firstImageHeight, // adjust height
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget recorderWidget(int recordingsCount) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFECE3D9),
          child: Column(
            crossAxisAlignment: recordingsCount != 0 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              recordingsCount != 0 ? newRecordingTitleWidget() : noRecordsWidget(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 40,bottom: 30),
          child: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = userList[index];
              return Column(
                  children: <Widget>[
                    Bounceable(
    onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  CreateRecordingScreen(tappedIndex: index)),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      userList = Hive.box('recordingsListData').get('recordingsList', defaultValue: []);
                    });
                  }
                });
              },
                      child: Padding(
                        padding: EdgeInsets.only(top:index == 0 ? 0 : 10.0,bottom:  index == 30 ? 50.0 : 10.0,left: 15.0,right: 15.0),
                        child:
                        recordCard(item['titleName'],item['topicName'],item["recordedStringFilePath"]),
                      ),
                    ),
                    ]);
          },
          ),
        ),
        // Center(child: noRecordsWidget()),
        Positioned(
          left: 0,
          right: 0,
          bottom: 30, // 10px from the bottom
          child: Center(child: newRecordingButton()),
        ),
      ],
    );
  }

  Widget newRecordingTitleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 59,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          'My Recordings',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xFF000000).withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget newRecordingButton() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF5D5FEF),
          borderRadius: BorderRadius.circular(30.0)),
      width: 232,
      height: 55,
      child: Center(
        child: Bounceable(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  const CreateRecordingScreen()),
            ).then((value) {
              if (value == true) {
                setState(() {
                  userList = Hive.box('recordingsListData').get('recordingsList', defaultValue: []);
                });
              }
            });
          },
          child: const Text(
            '   +  New Recording   ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget noRecordsWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Text(
            'No recordings yet.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black.withOpacity(0.30),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Image.asset(
            'assets/images/Play_empty.png',
            width: 38,
            height: 38,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            'Start recording \nyour assignments',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black.withOpacity(0.30),
            ),
          ),
        ),
      ],
    );
  }

  Widget recordCard(String recorderName,String recorderTopic,String recorderPath) {
    return Container(
          height: 100,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    ),
    child:  Row(
    children: [
    Expanded(
    flex: 6,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
      recorderName,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black,
    ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        recorderTopic,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
      fontSize: 13,
      color: Color(0xFF7B88E0),
      ),
      ),
    ),
    ],
    ),
    ),
    Bounceable(
      onTap: () async {
        final result = await Share.shareXFiles(
          [XFile(recorderPath)],
          text: recorderName,
          subject: recorderTopic,
        );
        print(result);
      },
      child: const CircleAvatar(
      backgroundColor: Color(0xFF5D5FEF),
      radius: 20,
      child: Icon(
      Icons.share,
      color: Colors.white,
      ),
      ),
    ),
    ],
    ),
    // )
    );
  }
}
