class Profile {
  Profile({required this.id, required this.fullName, required this.email
      //required this.created,
      //required this.modified
      });

  final String id;
  final String email;
  final String fullName;
  //final DateTime? created;
  //final DateTime? modified;

  Profile.fromMap(
      {required Map<String, dynamic> map, required String emailFromAuth})
      : id = map['id'],
        fullName = map['full_name'],
        email = emailFromAuth;
  //created = DateTime.parse(map['created']),
  //modified = DateTime.parse(map['modified']);
}
