import 'dart:io';
import 'package:ban_name/services/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ban_name/models/band.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  late List<Band> bands = [];


  @override
  void initState() {
    final socketService = Provider.of<Socket>(context,listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands( dynamic data ){

    this.bands = (data as List)
     .map( (band) => Band.fromMap(band))
     .toList();

     setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<Socket>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Band Names", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStauts == ServerStauts.Online
             ? Icon( Icons.check_circle, color: Colors.blue[300])
             : Icon( Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),
      body: 
      Column(
        children: [
          (bands.length > 0 ) ? _showGraph(bands) : Center()
          ,
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile( band: bands[i] )
            ),
          )
        ],
      ) 
      ,
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
        builder: (_) => AlertDialog(
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
        )
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
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
        )
    );
    
  }

  void addBandToList( String nameband){
    final socketService = Provider.of<Socket>(context, listen: false);

    if ( nameband.length > 1 ){
      socketService.socket.emit('add-band',{"name":nameband});
    }
    Navigator.pop(context);
  }
}

class _showGraph extends StatelessWidget {

  final List<Band> bands;

  const _showGraph(this.bands);


  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = new Map();
    bands.forEach((band)=>{
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble())
    });

    final List<Color> colorList = [
      Colors.blue[50] as Color,
      Colors.blue[200] as Color,
      Colors.pink[50] as Color,
      Colors.pink[200] as Color,
      Colors.yellow[50] as Color,
      Colors.yellow[200] as Color,
    ];

    return Container(
      width: double.infinity,
      height: 300,
      child: PieChart(
            dataMap: dataMap,
        animationDuration: Duration(milliseconds: 1800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        // centerText: "HYBRID",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      )
      ) ;
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

    final socketService = Provider.of<Socket>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band',{"id":band.id}),
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
        onTap: () => socketService.socket.emit('vote-bad',{'bandid':band.id})
      ),
    );
  }
}