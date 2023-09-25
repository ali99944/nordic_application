import 'package:car_app/models/issue_data.dart';
import 'package:car_app/services/issue_service.dart';
import 'package:flutter/material.dart';

import '../models/issue_notification_data.dart';
import '../screens/machine_issue_control_screen.dart';

class CompletedIssuesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IssueService.getAllCompletedIssues(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString(),style: TextStyle(
                fontSize: 20
            ),),
          );
        }

        if(snapshot.data != null){
          if(snapshot.data!.isEmpty){
            return Center(
              child: Text(
                  'No Completed Issues',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            );
          }

          List<IssueData> machineIssues = snapshot.data!.map((issue){
            return IssueData(
                title: issue['title'].toString() ?? '',
                description: issue['description'] ?? '',
                date: issue['date'] ?? '',
                status: 'complete',
                notes: issue['notes'],
                zone: issue['zone'],
                zoneLocation: issue['zoneLocation'],
                serial: issue['serial'],
                id: issue['_id']
            );
          }).toList();

          return ListView.builder(
            itemCount: machineIssues.length,
            itemBuilder: (context, index) {
              final issue = machineIssues[index];
              return GestureDetector(
                onTap:  (){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Den Automaten er fikset ferdig '))
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  elevation: 2,
                  color: Colors.green,
                  child: ListTile(
                    title: Text(issue.title,style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                    subtitle: Text(issue.description,style: TextStyle(color: Colors.white)),
                    trailing: Text(issue.date,style: TextStyle(color: Colors.white)),
                    leading: Icon(Icons.verified ,color: Colors.white,),
                  ),
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}

