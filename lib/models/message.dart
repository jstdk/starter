import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MessageModel {
  MessageModel({
    this.id,
    this.profileId,
    this.content,
    //this.created,
    this.isMine,
  });

  final String? id;
  final String? profileId;
  final String? content;
  //final DateTime? created;
  final bool? isMine;

  MessageModel.fromMap({
    required Map<String, dynamic> map,
    required String uid,
  })  : id = map['id'],
        profileId = map['profile_id'],
        content = map['content'],
        //createdAt = DateTime.parse(map['created']),
        isMine = uid == map['profile_id'];
}
