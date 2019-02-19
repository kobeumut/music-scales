import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'scales.dart';
import 'my_flutter_app_icons.dart' as CustomIcons;
import 'package:firebase_admob/firebase_admob.dart';
import 'appid.dart';
import 'main.dart';
import 'dart:math';


class QuizScreen extends StatefulWidget{
  @override
  _QuizScreen createState() => _QuizScreen();
}


List<QNote> myScale = [];
List<String> nums;
String ansstr;
Scale selectedScale;
List<QNote> choices;
bool clickable;
int score;
int deaths = 0;
bool reload;
int gamesplayed = 0;

class QNote{
  String note;
  int index;
  int audioindex;
  QNote(this.note, this.index, this.audioindex);
}

List<QNote> mynotes = [
  QNote("A", 0, 0),
  QNote("A#", 1, 0),
  QNote("B", 2, 0),
  QNote("C", 3, 0),
  QNote("C#", 4, 0),
  QNote("D", 5, 0),
  QNote("D#", 6, 0),
  QNote("E", 7, 0),
  QNote("F", 8, 0),
  QNote("F#", 9, 0),
  QNote("G", 10, 0),
  QNote("G#", 11, 0)
];

List<QNote> calculateScale(Scale scale, int index){     //Change Note to Qnote
  List<QNote> theScale = [];
  int audioindx = 4;
  for(int j=0; j<scale.formula.length+1; j++){
    if(j != 0)
      index += scale.formula[j-1];
    if(index > 11){
      index %= 12;
      audioindx = 5;
    }
    mynotes[index].audioindex = audioindx;
    theScale.add(mynotes[index]); 
  }
  return theScale;
}

class _QuizScreen extends State<QuizScreen> {
  Random myrand = new Random();
  List<Color> buttoncolors;
  @override
  void initState() {
    score = 0;
    deaths = 0;
    print(gamesplayed);
    reload = true;
    buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
    clickable = true;
    mynotes = [
      QNote("A", 0, 0),
      QNote("A#", 1, 0),
      QNote("B", 2, 0),
      QNote("C", 3, 0),
      QNote("C#", 4, 0),
      QNote("D", 5, 0),
      QNote("D#", 6, 0),
      QNote("E", 7, 0),
      QNote("F", 8, 0),
      QNote("F#", 9, 0),
      QNote("G", 10, 0),
      QNote("G#", 11, 0)
    ];
    super.initState();
  }
  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: ["Music", "Scales", "Guitar", "Piano", "Instrument", "Songs", "Chords"],
  );

  var myInterstitial = InterstitialAd(
    adUnitId: interstitialid, //InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
  var myInterstitial2 = InterstitialAd(
    adUnitId: interstitialid, //InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  @override
  void dispose(){
    myInterstitial?.dispose();
    myInterstitial2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AudioCache audio = new AudioCache();
    
    //choices.shuffle();

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
    }

    tableNums(selectedScale.name);

    Future<void> play(String note, int index) async{
      if(note != "?"){
        await audio.play("notes/${instrument.toLowerCase()}/${note.replaceAll("#", "s").toLowerCase()}$index.mp3");
      }
      else
        return;
    }

    TableCell noteCell(String note, int index){
      return TableCell(
        child: FlatButton(
          color: Color.fromRGBO(230, 80, 80, 0.12),
          onPressed: (){
            play("$note", index);
          },
          child: Container(
            child:  Padding(padding: EdgeInsets.fromLTRB(0, textSize * 0.6, 0, textSize * 0.65), child: Center(child: Text("$note", style: TextStyle(fontSize: textSize * 1.1, color: Colors.red, fontWeight: FontWeight.w400),))),
            ),
        ),
      );
    }

    Column scaletable(String mode){
      if(mode == "Blues" || mode == "Augmented"){
        return Column(children: <Widget>[            
            Padding(padding: EdgeInsets.fromLTRB(56 - textSize * 0.35, 12, 56 - textSize * 0.35, 12), child: Table(
              border: TableBorder.all(width: 1.5, color: Color.fromRGBO(20, 0, 160, 0.2)),
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
                   noteCell(myScale[0].note, myScale[0].audioindex),
                   noteCell(myScale[1].note, myScale[1].audioindex),
                   noteCell(myScale[2].note, myScale[2].audioindex),
                  ],
                ),
                ],
            ),),
            Padding(padding: EdgeInsets.fromLTRB(56 - textSize * 0.35, 0, 56 - textSize * 0.35, 10), child: Table(
              border: TableBorder.all(width: 1.5, color: Color.fromRGBO(20, 0, 160, 0.2)),
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
                   noteCell(myScale[3].note, myScale[3].audioindex),
                   noteCell(myScale[4].note, myScale[4].audioindex),
                   noteCell(myScale[5].note, myScale[5].audioindex),
                  ],
                ),
                ],
            ),
            ),
        ]);
      }
      else if(mode == "Major Pentatonic" || mode == "Minor Pentatonic" || mode == "Balinese" || mode == "Chinese" || mode == "Egyptian" || mode == "Mongolian"){
        return Column(children: <Widget>[            
            Padding(padding: EdgeInsets.fromLTRB(56 - textSize * 0.35, 12, 56 - textSize * 0.35, 12), child: Table(
              border: TableBorder.all(width: 1.5, color: Color.fromRGBO(20, 0, 160, 0.2)),
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
                   noteCell(myScale[0].note, myScale[0].audioindex),
                   noteCell(myScale[1].note, myScale[1].audioindex),
                   noteCell(myScale[2].note, myScale[2].audioindex),
                  ],
                ),
                ],
            ),),
            Padding(padding: EdgeInsets.fromLTRB(92 - textSize * 0.35, 0, 92 - textSize * 0.35, 10), child: Table(
              border: TableBorder.all(width: 1.5, color: Color.fromRGBO(20, 0, 160, 0.2)),
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
                   noteCell(myScale[3].note, myScale[3].audioindex),
                   noteCell(myScale[4].note, myScale[4].audioindex),
                  ],
                ),
                ],
            ),
            ),
        ]);
      }
      else{
        return Column(children: <Widget>[            
            Padding(padding: EdgeInsets.fromLTRB(56 - textSize, 12, 56-textSize, 12), child: Table(
              border: TableBorder.all(width: 1.5, color: Color.fromRGBO(20, 0, 160, 0.2)),
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
                    noteCell(myScale[0].note, myScale[0].audioindex),
                    noteCell(myScale[1].note, myScale[1].audioindex),
                    noteCell(myScale[2].note, myScale[2].audioindex),
                    noteCell(myScale[3].note, myScale[3].audioindex),
                    ],
                ),
                ],
            ),),
            Padding(padding: EdgeInsets.fromLTRB(72 - textSize * 0.35, 0, 72 - textSize * 0.35, 10), child: Table(
              border: TableBorder.all(width: 1.5, color: Color.fromRGBO(20, 0, 160, 0.2)),
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
                    noteCell(myScale[4].note, myScale[4].audioindex),
                    noteCell(myScale[5].note, myScale[5].audioindex),
                    noteCell(myScale[6].note, myScale[6].audioindex),
                  ],
                ),
                ],
            ),
            ),
        ],
        );
      }
    }
    FirebaseAdMob.instance.initialize(appId: appid);//FirebaseAdMob.testAppId); 
    myInterstitial..load();
    myInterstitial2..load();
    if(gamesplayed == 4)
      myInterstitial..show();
    if(gamesplayed == 9)
      myInterstitial2..show();

    var lifeicons;
    Row _lifeicons(){
      List<Color> iconcolors = [Colors.grey, Colors.grey, Colors.grey];
      if(deaths == 1)
        iconcolors[0] = Colors.red[400];
      else if(deaths == 2){
        iconcolors[0] = Colors.red[400];
        iconcolors[1] = Colors.red[400];
      }
      else if(deaths == 3){
        iconcolors[0] = Colors.red[400];
        iconcolors[1] = Colors.red[400];
        iconcolors[2] = Colors.red[400];
        gamesplayed++;
        clickable = false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Press to restart: ", style: TextStyle(fontSize: 22, color:  Colors.black54),),
            GestureDetector(
              onTap: (){
                setState(() {
                  mynotes = [
                    QNote("A", 0, 0),
                    QNote("A#", 1, 0),
                    QNote("B", 2, 0),
                    QNote("C", 3, 0),
                    QNote("C#", 4, 0),
                    QNote("D", 5, 0),
                    QNote("D#", 6, 0),
                    QNote("E", 7, 0),
                    QNote("F", 8, 0),
                    QNote("F#", 9, 0),
                    QNote("G", 10, 0),
                    QNote("G#", 11, 0)
                  ];
                  score = 0;
                  deaths = 0;
                  reload = true;
                  Random myrand = new Random();
                  int rand = myrand.nextInt(34);
                  int randkey = myrand.nextInt(12);
                  selectedScale = scales[rand];
                  myScale = calculateScale(selectedScale, randkey);
                  Set choicesset;
                  int answerindex = myrand.nextInt(myScale.length);
                  ansstr = myScale[answerindex].note;
                  myScale[answerindex].note = "?";
                  nums = ["1", "2", "3", "4", "5", "6", "7"];
                  int randset;
                  choicesset = myScale.toSet();
                  QNote answer = new QNote(ansstr, -1, 0);
                  choices = [answer];
                  while(choicesset.length != 4 + myScale.length){
                    randset = myrand.nextInt(12);
                    if(choicesset.add(mynotes[randset]) == true){
                      choices.add(mynotes[randset]);
                    }
                  }
                  choices.shuffle();
                  clickable = true;
                  buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
                });
              },
              child: Icon(Icons.refresh, color: Colors.red, size: 28,),
            )
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(CustomIcons.MyFlutterApp.x, color: iconcolors[0], size: 28,),
          Padding(padding: EdgeInsets.only(right: 4)),
          Icon(CustomIcons.MyFlutterApp.x, color: iconcolors[1], size: 28,),
          Padding(padding: EdgeInsets.only(right: 4)),
          Icon(CustomIcons.MyFlutterApp.x, color: iconcolors[2], size: 28,),
        ],
      );
    }

    lifeicons = _lifeicons();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedScale.name} Scale", style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1))),
        elevation: 1,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
                  child: Icon(Icons.help, size: 30,),
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (ctxt) => AlertDialog(
                      title: Text("Help", textAlign: TextAlign.center,),
                      content: Text("Find the missing note!\nWait for 2.5 seconds and the next screen question will apppear. Click the notes in the table to hear them in the."),
                    )
                    );
                  },
                ),
          ),
        ],
      ),
      //bottomNavigationBar: Container(height: adpadding,),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 6, bottom: 4), child: Text("Score: $score", style: TextStyle(fontSize: 32, color: Colors.grey[600]), textAlign: TextAlign.center,),),
            lifeicons,
            Padding(padding: EdgeInsets.only(bottom: 12),),
            Divider(height: 0, color: Colors.black45,),
            scaletable(selectedScale.name),
            Padding(padding: EdgeInsets.only(bottom: 6),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              FlatButton(
                onPressed: (){
                  if(clickable){
                    if(choices[0].note == ansstr){
                      setState(() {
                        score++;
                        buttoncolors[0] = Colors.green[300]; 
                        clickable = false;
                      });
                    }
                    else{
                      setState(() {
                        buttoncolors[0] = Colors.red[300];
                        int ansindex;
                        for(int i=0; i<5; i++){
                          if(choices[i].note == ansstr)
                            ansindex = i;
                        } 
                        buttoncolors[ansindex] = Colors.green[300];
                        deaths++;
                        clickable = false;
                      });  
                    }
                    if(deaths == 3)
                      reload = false;
                    if(reload){
                      Timer(Duration(milliseconds: 2500), (){
                        setState(() {
                        mynotes = [
                          QNote("A", 0, 0),
                          QNote("A#", 1, 0),
                          QNote("B", 2, 0),
                          QNote("C", 3, 0),
                          QNote("C#", 4, 0),
                          QNote("D", 5, 0),
                          QNote("D#", 6, 0),
                          QNote("E", 7, 0),
                          QNote("F", 8, 0),
                          QNote("F#", 9, 0),
                          QNote("G", 10, 0),
                          QNote("G#", 11, 0)
                        ];
                        Random myrand = new Random();
                        int rand = myrand.nextInt(34);
                        int randkey = myrand.nextInt(12);
                        selectedScale = scales[rand];
                        myScale = calculateScale(selectedScale, randkey);
                        Set choicesset;
                        int answerindex = myrand.nextInt(myScale.length);
                        ansstr = myScale[answerindex].note;
                        myScale[answerindex].note = "?";
                        nums = ["1", "2", "3", "4", "5", "6", "7"];
                        int randset;
                        choicesset = myScale.toSet();
                        QNote answer = new QNote(ansstr, -1, 0);
                        choices = [answer];
                        while(choicesset.length != 4 + myScale.length){
                          randset = myrand.nextInt(12);
                          if(choicesset.add(mynotes[randset]) == true){
                            choices.add(mynotes[randset]);
                          }
                        }
                        choices.shuffle();
                        clickable = true;
                        buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
                      });
                      }); 
                    }
                  }
                },
                shape: CircleBorder(),
                padding: EdgeInsets.all(26),
                color: buttoncolors[0],
                child: Text("${choices[0].note}", style: TextStyle(fontSize: 28),),
              ),
              Padding(padding: EdgeInsets.only(right: 8),),
              FlatButton(
                onPressed: (){
                  if(clickable){
                    if(choices[1].note == ansstr){
                      setState(() {
                        score++;
                        buttoncolors[1] = Colors.green[300]; 
                        clickable = false;
                      });
                    }
                    else{
                      setState(() {
                        buttoncolors[1] = Colors.red[300];
                        int ansindex;
                        for(int i=0; i<5; i++){
                          if(choices[i].note == ansstr)
                            ansindex = i;
                        } 
                        buttoncolors[ansindex] = Colors.green[300];
                        deaths++;
                        clickable = false;
                      });  
                    }
                    if(deaths == 3)
                      reload = false;
                    if(reload){
                      Timer(Duration(milliseconds: 2500), (){
                        setState(() {
                        mynotes = [
                          QNote("A", 0, 0),
                          QNote("A#", 1, 0),
                          QNote("B", 2, 0),
                          QNote("C", 3, 0),
                          QNote("C#", 4, 0),
                          QNote("D", 5, 0),
                          QNote("D#", 6, 0),
                          QNote("E", 7, 0),
                          QNote("F", 8, 0),
                          QNote("F#", 9, 0),
                          QNote("G", 10, 0),
                          QNote("G#", 11, 0)
                        ];
                        Random myrand = new Random();
                        int rand = myrand.nextInt(34);
                        int randkey = myrand.nextInt(12);
                        selectedScale = scales[rand];
                        myScale = calculateScale(selectedScale, randkey);
                        Set choicesset;
                        int answerindex = myrand.nextInt(myScale.length);
                        ansstr = myScale[answerindex].note;
                        myScale[answerindex].note = "?";
                        nums = ["1", "2", "3", "4", "5", "6", "7"];
                        int randset;
                        choicesset = myScale.toSet();
                        QNote answer = new QNote(ansstr, -1, 0);
                        choices = [answer];
                        while(choicesset.length != 4 + myScale.length){
                          randset = myrand.nextInt(12);
                          if(choicesset.add(mynotes[randset]) == true){
                            choices.add(mynotes[randset]);
                          }
                        }
                        choices.shuffle();
                        clickable = true;
                        buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
                      });
                      }); 
                    }
                  }
                },
                shape: CircleBorder(),
                padding: EdgeInsets.all(26),
                color: buttoncolors[1],
                child: Text("${choices[1].note}", style: TextStyle(fontSize: 28),),
              ),
              Padding(padding: EdgeInsets.only(right: 8),),
              FlatButton(
                onPressed: (){
                  if(clickable){
                    if(choices[2].note == ansstr){
                      setState(() {
                        score++;
                        buttoncolors[2] = Colors.green[300]; 
                        clickable = false;
                      });
                    }
                    else{
                      setState(() {
                        buttoncolors[2] = Colors.red[300];
                        int ansindex;
                        for(int i=0; i<5; i++){
                          if(choices[i].note == ansstr)
                            ansindex = i;
                        } 
                        buttoncolors[ansindex] = Colors.green[300];
                        deaths++;
                        clickable = false;
                      });  
                    }
                    if(deaths == 3)
                      reload = false;
                    if(reload){
                      Timer(Duration(milliseconds: 2500), (){
                        setState(() {
                        mynotes = [
                          QNote("A", 0, 0),
                          QNote("A#", 1, 0),
                          QNote("B", 2, 0),
                          QNote("C", 3, 0),
                          QNote("C#", 4, 0),
                          QNote("D", 5, 0),
                          QNote("D#", 6, 0),
                          QNote("E", 7, 0),
                          QNote("F", 8, 0),
                          QNote("F#", 9, 0),
                          QNote("G", 10, 0),
                          QNote("G#", 11, 0)
                        ];
                        Random myrand = new Random();
                        int rand = myrand.nextInt(34);
                        int randkey = myrand.nextInt(12);
                        selectedScale = scales[rand];
                        myScale = calculateScale(selectedScale, randkey);
                        Set choicesset;
                        int answerindex = myrand.nextInt(myScale.length);
                        ansstr = myScale[answerindex].note;
                        myScale[answerindex].note = "?";
                        nums = ["1", "2", "3", "4", "5", "6", "7"];
                        int randset;
                        choicesset = myScale.toSet();
                        QNote answer = new QNote(ansstr, -1, 0);
                        choices = [answer];
                        while(choicesset.length != 4 + myScale.length){
                          randset = myrand.nextInt(12);
                          if(choicesset.add(mynotes[randset]) == true){
                            choices.add(mynotes[randset]);
                          }
                        }
                        choices.shuffle();
                        clickable = true;
                        buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
                      });
                      }); 
                    }
                  }
                },
                shape: CircleBorder(),
                padding: EdgeInsets.all(26),
                color: buttoncolors[2],
                child: Text("${choices[2].note}", style: TextStyle(fontSize: 28),),
              ),
            ],),
            Padding(padding: EdgeInsets.only(top: 4),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              FlatButton(
                onPressed: (){
                  if(clickable){
                    if(choices[3].note == ansstr){
                      setState(() {
                        score++;
                        buttoncolors[3] = Colors.green[300]; 
                        clickable = false;
                      });
                    }
                    else{
                      setState(() {
                        buttoncolors[3] = Colors.red[300];
                        int ansindex;
                        for(int i=0; i<5; i++){
                          if(choices[i].note == ansstr)
                            ansindex = i;
                        } 
                        buttoncolors[ansindex] = Colors.green[300];
                        deaths++;
                        clickable = false;
                      });  
                    }
                    if(deaths == 3)
                      reload = false;
                    if(reload){
                      Timer(Duration(milliseconds: 2500), (){
                        setState(() {
                        mynotes = [
                          QNote("A", 0, 0),
                          QNote("A#", 1, 0),
                          QNote("B", 2, 0),
                          QNote("C", 3, 0),
                          QNote("C#", 4, 0),
                          QNote("D", 5, 0),
                          QNote("D#", 6, 0),
                          QNote("E", 7, 0),
                          QNote("F", 8, 0),
                          QNote("F#", 9, 0),
                          QNote("G", 10, 0),
                          QNote("G#", 11, 0)
                        ];
                        Random myrand = new Random();
                        int rand = myrand.nextInt(34);
                        int randkey = myrand.nextInt(12);
                        selectedScale = scales[rand];
                        myScale = calculateScale(selectedScale, randkey);
                        Set choicesset;
                        int answerindex = myrand.nextInt(myScale.length);
                        ansstr = myScale[answerindex].note;
                        myScale[answerindex].note = "?";
                        nums = ["1", "2", "3", "4", "5", "6", "7"];
                        int randset;
                        choicesset = myScale.toSet();
                        QNote answer = new QNote(ansstr, -1, 0);
                        choices = [answer];
                        while(choicesset.length != 4 + myScale.length){
                          randset = myrand.nextInt(12);
                          if(choicesset.add(mynotes[randset]) == true){
                            choices.add(mynotes[randset]);
                          }
                        }
                        choices.shuffle();
                        clickable = true;
                        buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
                      });
                      }); 
                    }
                  }
                },
                shape: CircleBorder(),
                padding: EdgeInsets.all(26),
                color: buttoncolors[3],
                child: Text("${choices[3].note}", style: TextStyle(fontSize: 28),),
              ),
              Padding(padding: EdgeInsets.only(right: 8),),
              FlatButton(
                onPressed: (){
                  if(clickable){
                    if(choices[4].note == ansstr){
                      setState(() {
                        score++;
                        buttoncolors[4] = Colors.green[300]; 
                        clickable = false;
                      });
                    }
                    else{
                      setState(() {
                        buttoncolors[4] = Colors.red[300];
                        int ansindex;
                        for(int i=0; i<5; i++){
                          if(choices[i].note == ansstr)
                            ansindex = i;
                        } 
                        buttoncolors[ansindex] = Colors.green[300];
                        deaths++;
                        clickable = false;
                      });  
                    }
                    if(deaths == 3)
                      reload = false;
                    if(reload){
                      Timer(Duration(milliseconds: 2500), (){
                        setState(() {
                        mynotes = [
                          QNote("A", 0, 0),
                          QNote("A#", 1, 0),
                          QNote("B", 2, 0),
                          QNote("C", 3, 0),
                          QNote("C#", 4, 0),
                          QNote("D", 5, 0),
                          QNote("D#", 6, 0),
                          QNote("E", 7, 0),
                          QNote("F", 8, 0),
                          QNote("F#", 9, 0),
                          QNote("G", 10, 0),
                          QNote("G#", 11, 0)
                        ];
                        Random myrand = new Random();
                        int rand = myrand.nextInt(34);
                        int randkey = myrand.nextInt(12);
                        selectedScale = scales[rand];
                        myScale = calculateScale(selectedScale, randkey);
                        Set choicesset;
                        int answerindex = myrand.nextInt(myScale.length);
                        ansstr = myScale[answerindex].note;
                        myScale[answerindex].note = "?";
                        nums = ["1", "2", "3", "4", "5", "6", "7"];
                        int randset;
                        choicesset = myScale.toSet();
                        QNote answer = new QNote(ansstr, -1, 0);
                        choices = [answer];
                        while(choicesset.length != 4 + myScale.length){
                          randset = myrand.nextInt(12);
                          if(choicesset.add(mynotes[randset]) == true){
                            choices.add(mynotes[randset]);
                          }
                        }
                        choices.shuffle();
                        clickable = true;
                        buttoncolors = [Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1), Color.fromRGBO(200, 250, 250, 1)];
                      });
                      }); 
                    }
                  }
                },
                shape: CircleBorder(),
                padding: EdgeInsets.all(26),
                color: buttoncolors[4],
                child: Text("${choices[4].note}", style: TextStyle(fontSize: 28),),
              ),
            ],),
            Padding(padding: EdgeInsets.only(bottom: 12),),
          ],
        ),
      ),
    );
  }
}