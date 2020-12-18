class Player {
  int id;
  String firstName;
  String lastName;
  String position;

  Player({
    this.id,
    this.firstName,
    this.lastName,
    this.position,
  });

  Player.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json['first_name'];
    lastName = json['last_name'];
    position = json['position'];
  }
}
