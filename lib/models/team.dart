import 'package:nbaplayers/models/player.dart';

class Team {
  int id;
  String fullName;
  List<Player> players;

  Team(this.fullName, this.id, this.players);

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  addPlayer(Player player) {
    if (players == null) {
      players = new List<Player>();
    }
    players.add(player);
  }

  int countPlayers() {
    if (players == null) {
      return 0;
    }
    return players.length;
  }
}

class Teams {
  List<Team> listOfTeams = [];
  int nextPage = 1;
  bool isLoading = false;

  Team findTeam(int id) {
    int index = listOfTeams.indexWhere((team) => team.id == id);
    if (index > -1) {
      return listOfTeams[index];
    } else {
      return null;
    }
  }

  updateTeam(Team newTeam, Player player) {
    Team team = findTeam(newTeam.id);
    if (team == null) {
      listOfTeams.add(newTeam);
      team = newTeam;
    }
    team.addPlayer(player);
    listOfTeams[listOfTeams.indexWhere((team) => team.id == newTeam.id)] = team;
  }

  bool isEmpty() {
    return listOfTeams.isEmpty;
  }
}
