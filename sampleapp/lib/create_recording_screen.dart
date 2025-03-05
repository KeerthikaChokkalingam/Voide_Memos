import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CreateRecordingScreen extends StatefulWidget {
const CreateRecordingScreen({super.key});

@override
State<CreateRecordingScreen> createState() => _CreateRecordingScreenState();
}

class _CreateRecordingScreenState extends State<CreateRecordingScreen> {
final FocusNode _titleFocusNode = FocusNode();

  @override
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
                  child: commontitleTextWidget("Title"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: commonTextFieldWidget("Title"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10),
                  child: commontitleTextWidget("Topic"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: commonTextFieldWidget("Topic"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10),
                  child: commontitleTextWidget("Recording"),
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
Widget commontitleTextWidget(String titleText) {
  return Text(titleText,style: const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.black,

  ),);
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
    child: const Padding(
      padding: EdgeInsets.only(left: 10.0,right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("File Audio"),
          Visibility(
            visible: false,
            child: Icon(Icons.delete,
              color: Color(0xFF5D5FEF),
              size: 20,),
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
          onTap: () {  },
          child: Image.asset(
            'assets/images/record-button.png',
            width: 122,
            height: 122,
          ),
        ),
      ),

    ],
  );
}
Widget saveButton(){
    return Bounceable(onTap: (){}, child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF5D5FEF),
        borderRadius: BorderRadius.circular(35)
      ),
      height: 51,
      child: const Center(
        child: Text("Save",style: TextStyle(
          color:  Colors.white,
          fontSize: 18,
          height: 1,
          fontWeight: FontWeight.w600,
        ),),
      ),
    ));
}
}