import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbaplayers/models/player.dart';
import 'package:nbaplayers/models/team.dart';
import 'package:nbaplayers/utils/constants.dart';

class NbaAPI {
  static Future<Teams> getAllPlayers(Teams paramTeams) async {
    Teams teams = paramTeams;
    var url = Constants.API_ENDPOINT + 'players?per_page=5';
    if (teams.nextPage > 1) {
      url = url + "&page=" + teams.nextPage.toString();
    }

    var response = await http.get(url);  
    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      Iterable listaResponse = mapResponse['data'];

      for (Map map in listaResponse) {
        Team newTeam = new Team.fromJson(map['team']);

        teams.updateTeam(newTeam, Player.fromJson(map));
      }
      teams.nextPage = mapResponse['meta']['next_page'];
    }
    return teams;
  }
}
