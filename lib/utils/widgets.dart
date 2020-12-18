import 'package:flutter/material.dart';
import 'package:nbaplayers/models/team.dart';
import 'package:nbaplayers/utils/styles.dart';

buildCard(BuildContext context, Team team) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Column(children: <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Row(children: [
          Text(team.fullName, style: teamStyle),
          Text(' ' + team.countPlayers().toString() + ' players',
              style: countStyle)
        ]),
      ),
      Container(
          child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: team.players == null ? 0 : team.players.length,
        itemBuilder: (context, index) {
          return ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child:
                      Text(team.players[index].position, style: playerStyle)),
              title: Text(
                team.players[index].id.toString(),
                style: idStyle,
              ),
              subtitle: Text(
                  team.players[index].firstName +
                      ' ' +
                      team.players[index].lastName,
                  style: playerStyle));
        },
      )),
    ]),
  );
}
