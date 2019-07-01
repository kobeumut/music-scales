import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'main.dart';
import 'dart:async';

List<Scale> scales = [    //A A# B C C# D D# E F F# G G#
  Scale("Major", 0, [2, 2, 1, 2, 2, 2]),
  Scale("Minor", 1, [2, 1, 2, 2, 1, 2]),
  Scale("Major Pentatonic", 12, [2, 2, 3, 2]),
  Scale("Minor Pentatonic", 13, [3, 2, 2, 3]),
  Scale("Blues", 2, [3, 2, 1, 1, 3]),
  Scale("Harmonic Minor", 3, [2, 1, 2, 2, 1, 3]),
  Scale("Melodic Minor", 4, [2, 1, 2, 2, 2, 2]),
  Scale("Ionian", 5, [2, 2, 1, 2, 2, 2]),
  Scale("Dorian", 6, [2, 1, 2, 2, 2, 1]),
  Scale("Mixolydian", 7, [2, 2, 1, 2, 2, 1]),
  Scale("Lydian", 8, [2, 2, 2, 1, 2, 2]),
  Scale("Phrygian", 9, [1, 2, 2, 2, 1, 2]), 
  Scale("Aeolian", 10, [2, 1, 2, 2, 1, 2]),
  Scale("Locrian", 11, [1, 2, 2, 1, 2, 2]),
  Scale("Augmented", 14, [3, 1, 3, 1, 3]),
  Scale("Double Harmonic", 15, [1, 3, 1, 2, 1, 3]),
  Scale("Altered", 16, [1, 2, 1, 2, 2, 2]),
  Scale("Altered bb7", 39, [1, 2, 1, 2, 2, 1]),
  Scale("Dorian b2", 17, [1, 2, 2, 2, 2, 1]),
  Scale("Augmented Lydian", 18, [2, 2, 2, 2, 1, 2]),
  Scale("Lydian b7", 19, [2, 2, 2, 1, 2, 1]),
  Scale("Mixolydian b6", 20, [2, 2, 1, 2, 1, 2]),
  Scale("Locrian 6", 21, [1, 2, 2, 1, 3, 1]),
  Scale("Locrian 2", 40, [2, 1, 2, 1, 2, 2]),
  Scale("Augmented Ionian", 22, [2, 2, 1, 3, 1, 2]),
  Scale("Dorian #4", 23, [2, 1, 3, 1, 2, 1]),
  Scale("Major Phrygian", 24, [1, 3, 1, 2, 1, 2]), 
  Scale("Lydian #9", 25, [3, 1, 2, 1, 2, 2]), 
  Scale("Diminished Lydian", 26, [2, 1, 3, 1, 2, 2]),
  Scale("Minor Lydian", 27, [2, 2, 2, 1, 1, 2]),
  Scale("Arabian", 28, [2, 2, 1, 1, 2, 2]),
  Scale("Balinese", 29, [1, 2, 3, 2]),
  Scale("Byzantine", 30, [1, 3, 1, 2, 1, 3]),
  Scale("Chinese", 31, [4, 2, 1, 4]),
  Scale("Egyptian", 32, [2, 3, 2, 3]),
  Scale("Mongolian", 33, [2, 2, 3, 2]),
  Scale("Hindu", 34, [2, 2, 1, 2, 1, 2]),
  Scale("Neopolitan", 35, [1, 2, 2, 2, 1, 3]),
  Scale("Neopolitan Major", 36, [1, 2, 2, 2, 2, 2]),
  Scale("Neopolitan Minor", 37, [1, 2, 2, 2, 1, 2]),
  Scale("Persian", 38, [1, 3, 1, 1, 2, 3])  //Continue from 41
];

class ScalePrintScreen extends StatefulWidget{
  @override
  _ScalePrintScreen createState() => _ScalePrintScreen();
}

class SNote{
  String note;
  String bemolle;
  String alternative;
  int index;
  int audioindex;
  bool isBemolle = false;
  SNote(this.note, this.index, this.audioindex, this.bemolle);
}

List<SNote> notes = [
  SNote("A", 0, 0, "Bbb"),
  SNote("A#", 1, 0, "Bb"),
  SNote("B", 2, 0, "Cb"),
  SNote("C", 3, 0, "B#"),
  SNote("C#", 4, 0, "Db"),
  SNote("D", 5, 0, "Ebb"),
  SNote("D#", 6, 0, "Eb"),
  SNote("E", 7, 0, "Fb"),
  SNote("F", 8, 0, "E#"),
  SNote("F#", 9, 0, "Gb"),
  SNote("G", 10, 0, "Abb"),
  SNote("G#", 11, 0, "Ab"),
];


class _ScalePrintScreen extends State<ScalePrintScreen> {
  AudioCache audio = new AudioCache();
  var instrimg;
  @override
  void initState() {
    instrimg = AssetImage('lib/assets/imgs/${instrument.toLowerCase()}.png');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<SNote> sharpToBemolle(List<SNote> thenotes){
      List<SNote> tempscale = [];
      tempscale.add(thenotes[0]); 
      for(int i=1; i<thenotes.length; i++){
        SNote tempnote = new SNote(thenotes[i].note, thenotes[i].index, thenotes[i].audioindex, thenotes[i].bemolle);
        for(int j=0; j<i; j++){
          print(tempscale[j].note + " ?= " + tempnote.note);
          if(tempscale[j].isBemolle == false){
            if(tempscale[j].note.contains(tempnote.note[0])){
              print("Since ${thenotes[j].note}, ${tempnote.note} is bemolle ${tempnote.bemolle}");
              tempnote.isBemolle = true;
              break;
            }
          }
          else{
            if(tempscale[j].bemolle.contains(tempnote.note[0])){
              print("Since ${thenotes[j].note}, ${tempnote.note} is bemolle ${tempnote.bemolle}");
              tempnote.isBemolle = true;
              break;
            }
          }
        }
        /*if(tempnote.note.contains(thenotes[i].note)){
          for(int j=0; j<thenotes.length; j++){
            if(j != i){
              if(thenotes[j].note.contains(tempnote.note[0])){
                print("Since ${thenotes[j].note}, ${tempnote.note} is bemolle ${tempnote.bemolle}");
                tempnote.isBemolle = true;
                break;
              }
            }
          }
        }*/
        tempscale.add(tempnote);
      }
      return tempscale;
    }
    List<SNote> calculateScale(int mode, int key){
    	List<SNote> theScale = [];
      int audioindx = 4;
      int index = key;
      Scale scaleObj;
      for(int i=0; i<scales.length; i++){
        if(mode == scales[i].index)
          scaleObj = scales[i];
      }
      for(int j=0; j<scaleObj.formula.length+1; j++){
        if(j != 0)
          index += scaleObj.formula[j-1];
        if(index > 11){
          index %= 12;
          audioindx = 5;
        }
        notes[index].audioindex = audioindx;
        theScale.add(notes[index]); 
      }
      return sharpToBemolle(theScale);
    }
    List<SNote> myScale;
    myScale = calculateScale(clickedindexscale, clickedindex);
    //print(myScale.length);
    String urlScale(String mode, List<SNote> notes, String instr){
      String url;
      String n_or_sharp;
      if(!notes[0].note.contains("#"))
        n_or_sharp = "n";
      else 
        n_or_sharp = "sharp";
     if(mode == "Minor")
        url = "$instr-natural_minor-${notes[0].note[0]}-$n_or_sharp";
      else if(mode.contains(" ")){
        url = "$instr-${mode.toLowerCase().replaceFirst(" ", "_").replaceFirst("#", "s")}-${notes[0].note[0]}-$n_or_sharp";
      }
      else
        url = "$instr-${mode.toLowerCase()}-${notes[0].note[0]}-$n_or_sharp"; 
      print(url);
      return url;
    }
    List<String> nums = ["1", "2", "3", "4", "5", "6", "7"];
    
    void tableNums(String mode){
      if(mode == "Minor"){
        nums[2] = "b3";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Blues"){
        nums[1] = "b3";
        nums[2] = "4";
        nums[3] = "#4";
        nums[4] = "5";
        nums[5] = "b7";
      }
      else if(mode == "Melodic Minor")
        nums[2] = "b3";
      else if(mode == "Harmonic Minor"){
        nums[2] = "b3";
        nums[5] = "b6";
      }
      else if(mode == "Dorian"){
        nums[2] = "b3";
        nums[6] = "b7";
      }
      else if(mode == "Mixolydian")
        nums[6] = "b7";
      else if(mode == "Lydian")
        nums[3] = "#4";
      else if(mode == "Phrygian"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Aeolian"){
        nums[2] = "b3";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Locrian"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[4] = "b5";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Locrian 2"){
        nums[2] = "b3";
        nums[4] = "b5";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Major Pentatonic"){
        nums[3] = "5";
        nums[4] = "6";  
      }
      else if(mode == "Minor Pentatonic"){
        nums[1] = "b3";
        nums[2] = "4";
        nums[3] = "5";
        nums[4] = "b7";
      }
      else if(mode == "Augmented"){
        nums[1] = "b3";
        nums[3] = "5";
        nums[4] = "#5";
        nums[5] = "7";
      }
      else if(mode == "Double Harmonic"){
        nums[1] = "b2";
        nums[5] = "b6";
      }
      else if(mode == "Altered"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[3] = "b4";
        nums[4] = "b5";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Altered bb7"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[3] = "b4";
        nums[4] = "b5";
        nums[5] = "b6";
        nums[6] = "bb7";
      }
      else if(mode == "Dorian b2"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[6] = "b7";
      }
      else if(mode == "Augmented Lydian"){
        nums[3] = "#4";
        nums[4] = "#5";
      }
      else if(mode == "Lydian b7"){
        nums[3] = "#4";
        nums[6] = "b7";
      }
      else if(mode == "Mixolydian b6"){
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Locrian 6"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[4] = "b5";
        nums[6] = "b7";
      }
      else if(mode == "Augmented Ionian")
        nums[4] = "#5";
      else if(mode == "Dorian #4"){
        nums[2] = "b3";
        nums[3] = "#4";
        nums[6] = "b7";
      }
      else if(mode == "Major Phrygian"){
        nums[1] = "b2";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Lydian #9"){
        nums[1] = "#2";
        nums[3] = "#4";
      }
      else if(mode == "Diminished Lydian"){
        nums[2] = "b3";
        nums[3] = "#4";
      }
      else if(mode == "Minor Lydian"){
        nums[3] = "#4";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Arabian"){
        nums[4] = "#4";
        nums[5] = "#5";
        nums[6] = "b7";
      }
      else if(mode == "Balinese"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[3] = "5";
        nums[4] = "b6";
      }
      else if(mode == "Byzantine"){
        nums[1] = "b2";
        nums[5] = "b6";
      }
      else if(mode == "Chinese"){
        nums[1] = "3";
        nums[2] = "#4";
        nums[3] = "5";
        nums[4] = "7";
      }
      else if(mode == "Egyptian"){
        nums[2] = "4";
        nums[3] = "5";
        nums[4] = "b7";
      }
      else if(mode == "Mongolian"){
        nums[3] = "5";
        nums[4] = "6";
      }
      else if(mode == "Hindu"){
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Neopolitan"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[5] = "b6";
      }
      else if(mode == "Neopolitan Major"){
        nums[1] = "b2";
        nums[2] = "b3";
      }
      else if(mode == "Neopolitan Minor"){
        nums[1] = "b2";
        nums[2] = "b3";
        nums[5] = "b6";
        nums[6] = "b7";
      }
      else if(mode == "Persian"){
        nums[1] = "b2";
        nums[4] = "b5";
        nums[5] = "b6";
      }
    }

    tableNums(clickednotescale);


    Future<void> play(String note, int index) async{
      await audio.play("notes/${instrument.toLowerCase()}/${note.replaceAll("#", "s").toLowerCase()}$index.mp3");
      }

    TableCell noteCell(String note, int index){
      return TableCell(
        child: FlatButton(
          color: Color.fromRGBO(230, 80, 80, 0.12),
          onPressed: (){
            if(note.length > 1){
              if(note[1] == "b"){
                int tempint;
                tempint = note.codeUnitAt(0);
                tempint--;
                if(tempint < 65)
                  tempint += 7;
                if(note.length == 3)
                  note = String.fromCharCode(tempint);
                else
                  note = String.fromCharCode(tempint) + "#";
              }
            }
            print("note is $note");
            play("$note", index);
          },
          child: Container(
            child:  Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.7, 0, textSize * 0.75), child: AutoSizeText("$note", maxLines: 1, style: TextStyle(fontSize: textSize, color: Colors.red, fontWeight: FontWeight.w400),)),
            ),
        ),
      );
    }

    Column scaletable(String mode){
      List<SNote> printScale = [];
      if(usebemolle == "Yes"){
        for(int i=0; i<myScale.length; i++){
          SNote temp = new SNote(myScale[i].note, myScale[i].index, myScale[i].audioindex, myScale[i].bemolle);
          temp.isBemolle = myScale[i].isBemolle;
          if(temp.isBemolle){
            print("Temp is bemolle; ${temp.bemolle}");
            temp.note = temp.bemolle;
          }
          printScale.add(temp);
        }
      }
      else
        printScale = myScale;
      if(mode == "Blues" || mode == "Augmented"){
        return Column(children: <Widget>[            
            Padding(padding: EdgeInsets.fromLTRB(18, 12, 18, 12), child: Table(
              border: TableBorder.all(width: 1, color: Color.fromRGBO(20, 0, 160, 0.2)),
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[0]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.75)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[1]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[2]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                   noteCell(printScale[0].note, myScale[0].audioindex),
                   noteCell(printScale[1].note, myScale[1].audioindex),
                   noteCell(printScale[2].note, myScale[2].audioindex),
                  ],
                ),
                ],
            ),),
            Padding(padding: EdgeInsets.fromLTRB(18, 0, 18, 10), child: Table(
              border: TableBorder.all(width: 1, color: Color.fromRGBO(20, 0, 160, 0.2)),
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[3]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[4]}", style: TextStyle(fontSize: textSize * 0.85,  color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[5]}", style: TextStyle(fontSize: textSize * 0.85,  color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                   noteCell(printScale[3].note, myScale[3].audioindex),
                   noteCell(printScale[4].note, myScale[4].audioindex),
                   noteCell(printScale[5].note, myScale[5].audioindex),
                  ],
                ),
                ],
            ),
            ),
        ]);
      }
      else if(mode == "Major Pentatonic" || mode == "Minor Pentatonic" || mode == "Balinese" || mode == "Chinese" || mode == "Egyptian" || mode == "Mongolian"){
        return Column(children: <Widget>[            
            Padding(padding: EdgeInsets.fromLTRB(18, 12, 18, 12), child: Table(
              border: TableBorder.all(width: 1, color: Color.fromRGBO(20, 0, 160, 0.2)),
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[0]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.75)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[1]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[2]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                   noteCell(printScale[0].note, myScale[0].audioindex),
                   noteCell(printScale[1].note, myScale[1].audioindex),
                   noteCell(printScale[2].note, myScale[2].audioindex),
                  ],
                ),
                ],
            ),),
            Padding(padding: EdgeInsets.fromLTRB(60, 0, 45, 60), child: Table(
              border: TableBorder.all(width: 1, color: Color.fromRGBO(20, 0, 160, 0.2)),
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[3]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[4]}", style: TextStyle(fontSize: textSize * 0.85,  color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                   noteCell(printScale[3].note, myScale[3].audioindex),
                   noteCell(printScale[4].note, myScale[4].audioindex),
                  ],
                ),
                ],
            ),
            ),
        ]);
      }
      else{
        return Column(children: <Widget>[            
            Padding(padding: EdgeInsets.fromLTRB(18, 12, 18, 12), child: Table(
              border: TableBorder.all(width: 1, color: Color.fromRGBO(20, 0, 160, 0.2)),
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center( child: Text("${nums[0]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.75)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[1]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[2]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[3]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    noteCell(printScale[0].note, myScale[0].audioindex),
                    noteCell(printScale[1].note, myScale[1].audioindex),
                    noteCell(printScale[2].note, myScale[2].audioindex),
                    noteCell(printScale[3].note, myScale[3].audioindex),
                    ],
                ),
                ],
            ),),
            Padding(padding: EdgeInsets.fromLTRB(40, 0, 40, 10), child: Table(
              border: TableBorder.all(width: 1, color: Color.fromRGBO(20, 0, 160, 0.2)),
              children: <TableRow>[
                TableRow(
                  children: <TableCell>[
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[4]}", style: TextStyle(fontSize: textSize * 0.85, color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[5]}", style: TextStyle(fontSize: textSize * 0.85,  color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                    TableCell(
                      child: Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.3, 0, textSize * 0.35), child: Center(child: Text("${nums[6]}", style: TextStyle(fontSize: textSize * 0.85,  color: Color.fromRGBO(20, 20, 20, 0.55)),))),
                    ),
                  ],
                ),
                TableRow(
                  children: <TableCell>[
                    noteCell(printScale[4].note, myScale[4].audioindex),
                    noteCell(printScale[5].note, myScale[5].audioindex),
                    noteCell(printScale[6].note, myScale[6].audioindex),
                  ],
                ),
                ],
            ),
            ),
        ],
        );
      }
    }

    Axis scrollaxis;
    if(instrument == "Guitar")
      scrollaxis = Axis.horizontal;
    else 
      scrollaxis = Axis.vertical;

    var scaleimg = (instrument == "Guitar") ? TransitionToImage(
        AdvancedNetworkImage("https://www.scales-chords.com/music-scales/${urlScale(clickednotescale, myScale, instrument.toLowerCase())}.jpg", useDiskCache: true),
        loadingWidget: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 3, backgroundColor: Colors.orangeAccent,)),
        placeholder: Column(children: <Widget>[
                    Padding( 
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
                      child:Text("No Internet Connection!", style: TextStyle(color: Color.fromRGBO(50, 50, 50, 0.6), fontSize: 20),),
                    ),
                    Icon(Icons.refresh, color: Colors.red, size: 52,),
                  ],
                ),
        enableRefresh: true,
        height: 100,
        alignment: Alignment(-1, -1),
        fit: BoxFit.fitHeight,
      ) : TransitionToImage(
        AdvancedNetworkImage("https://www.scales-chords.com/music-scales/${urlScale(clickednotescale, myScale, instrument.toLowerCase())}.jpg", useDiskCache: true),
        loadingWidget: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 3, backgroundColor: Colors.orangeAccent,)),
        placeholder: Column(children: <Widget>[
                    Padding( 
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
                      child:Text("No Internet Connection!", style: TextStyle(color: Color.fromRGBO(50, 50, 50, 0.6), fontSize: 20),),
                    ),
                    Icon(Icons.refresh, color: Colors.red, size: 52,),
                  ],
                ),
        enableRefresh: true,
      );

    return Scaffold(
      appBar: AppBar(
        title: Text("$clickednote $clickednotescale", style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1)), overflow: TextOverflow.fade,),
        elevation: 1,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              setState(() {
                  if(instrument == "Guitar")
                    instrument = "Piano";
                  else if(instrument == "Piano")
                    instrument = "Guitar";
                  instrimg = AssetImage('lib/assets/imgs/${instrument.toLowerCase()}.png');
                });
            },
            child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 6, 8),
              child: Image(
                color: Colors.black,
                image: instrimg,
                ),
              ),
            ),
            GestureDetector(
              child: Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.help, size: 30,)),
              onTap: (){
                showDialog(
                context: context,
                builder: (ctxt) => AlertDialog(
                  title: Text("Help", textAlign: TextAlign.center,),
                  content: Text("Click and select a scale from the menu. Press the button next to the question mark to change the instrument. Click on the red tiles to hear the individual notes with the selected instrument. While viewing the guitar scale, slide the scale to the right to see the remaining scale."),
                )
                );
              },
            )
          ],
      ),
      //bottomNavigationBar: Container(height: adpadding,),
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 2, left: 28, right: 28),
                    color: Color.fromRGBO(255, 225, 225, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Root", style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 50, 50, 1)),),
                        DropdownButton(
                          hint: Text(clickednote, style: TextStyle(fontSize: 20, color: Colors.blue),),
                          items: notes.map((SNote value){
                            return DropdownMenuItem<SNote>(
                              child: Text("${value.note}", style: TextStyle(fontSize: 18),),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (SNote newvalue){
                            setState(() {
                              clickedindex = newvalue.index;
                              clickednote = newvalue.note;
                            });
                          },
                        ),
                      ],
                      ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(225, 250, 250, 1),
                      padding: EdgeInsets.only(top: 10, bottom: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Scale", style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 50, 50, 1)),),
                          DropdownButton(
                            hint: Text(clickednotescale, style: TextStyle(fontSize: 20, color: Colors.deepPurple),),
                            items: scales.map((Scale value){
                              return DropdownMenuItem<Scale>(
                                child: Text("${value.name}", style: TextStyle(fontSize: 18),),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (Scale newvalue){
                              setState(() {
                              clickednotescale = newvalue.name;
                              clickedindexscale = newvalue.index; 
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ),
                ]
                ),
                Divider(height: 0, color: Colors.black26,),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(6, 8, 6, 0), 
                          child: SingleChildScrollView(
                            child: scaleimg,
                            scrollDirection: scrollaxis,
                            ),
                          ),
                        scaletable(clickednotescale),
                      ]
                    ),
                  ),
                ),
              //Text('$clickednotescale ${myScale[0].note}  ${urlScale(clickednotescale, myScale[0].note, instrument.toLowerCase())}'),
            ],
            ),  
          ),
        ),
    );
  }
}