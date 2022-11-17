import 'package:nyxx/nyxx.dart';

class ToDoMessage {
  String? _message;
  Snowflake? _guild;
  Snowflake? _channel;
  Snowflake? _user;

  String get message => _message!;

  Snowflake get guild => _guild!;

  Snowflake get channel => _channel!;

  Snowflake get user => _user!;

  bool get isValid {
    return _message != null &&
        _guild != null &&
        _channel != null &&
        _user != null;
  }

  bool get isInvalid {
    return _message == null ||
        _guild == null ||
        _channel == null ||
        _user == null;
  }

  ToDoMessage(
      {required String message,
      required Snowflake guildId,
      required Snowflake channelId,
      required Snowflake userId}) {
    _message = message;
    _guild = guildId;
    _channel = channelId;
    _user = userId;
  }

  ToDoMessage.parse(Map data) {
    if (data.isEmpty) return;
    _message = data['message'];
    _guild = Snowflake(data['guild']);
    _channel = Snowflake(data['channel']);
    _user = Snowflake(data['user']);
  }

  ToDoMessage.invalid();

  Map toMap() {
    return {
      'message': _message.toString(),
      'guild': _guild.toString(),
      'channel': _channel.toString(),
      'user': _user.toString()
    };
  }
}
