import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ban_name/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Band> bands = [
    Band(id: '1',name: 'soda stereo',votes: 2),
    Band(id: '2',name: 'rhcp' ,votes: 4),
    Band(id: '3',name: 'los angeles azules',votes: 9),
    Band(id: '4',name: 'ff',votes: 3),
    Band(id: '5',name: 'Aterciopelados',votes: 6)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Band Names", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile( band: bands[i] )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  addNewBand(){
    
    final textController = new TextEditingController();

    if( Platform.isAndroid ){
        showDialog(
        context: context,
        builder: (context) {
        return AlertDialog(
          title: Text("New band name:"),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: Text("Add"),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text)
            )
          ],
        ); 
        }
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_){
        return CupertinoAlertDialog(
          title: Text("New band name:"),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Add"),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      }
    );
    
  }

  void addBandToList( String name){
    if ( name.length > 1 ){
      this.bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}

class _bandTile extends StatelessWidget {
  const _bandTile({
    Key? key,
    required this.band,
  }) : super(key: key);

  final Band band;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ){
        print(direction);
        print("${band.id}");
        // lammar borrado backend
      },
      background: Container(
        padding: EdgeInsets.only( left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Delete band", style: TextStyle(color: Colors.white),)
          ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text( band.name ),
        trailing: Text( '${band.votes}', style: TextStyle(fontSize: 20),),
        onTap: () {
           print(band.name); 
        },
      ),
    );
  }
}