class ProfileModel {
  ProfileModel(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.avatar
      //required this.created,
      //required this.modified
      });

  final String id;
  final String email;
  final String fullName;
  final String avatar;
  //final DateTime? created;
  //final DateTime? modified;

  ProfileModel.fromMap(
      {required Map<String, dynamic> map, required String emailFromAuth})
      : id = map['id'],
        fullName = map['full_name'],
        email = emailFromAuth,
        avatar = map['avatar'];
  //created = DateTime.parse(map['created']),
  //modified = DateTime.parse(map['modified']);
}
