import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/message.dart';

final supabase = Supabase.instance.client;

class MessageService extends ChangeNotifier {
  loadMessages(id) {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created')
        .map((maps) => maps
            .map((map) => MessageModel.fromMap(
                map: map, uid: supabase.auth.currentUser!.id))
            .toList());
  }
}
