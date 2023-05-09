import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nyxx/nyxx.dart';

import '../models/todo.dart';
import 'data_manager.dart';
import 'hoze.dart';
import 'postman/postman.dart';

class MessageScheduler {
  Future<void> checkMessages() async {
    print('Checking messages');
    final box = await DataManager().getScheduledMessages();
    final toDos = box.keys.cast<String>().where((_) =>
        DateTime.fromMillisecondsSinceEpoch(int.parse(_))
            .isBefore(DateTime.now().add(Duration(hours: 1))));
    return Future.delayed(Duration.zero, () {
      for (final todo in toDos) {
        final message = ToDoMessage.parse(box.get(todo, defaultValue: {}));
        if (message.isInvalid) {
          continue;
        } else {
          sendMessage(message);
          box.delete(todo);
        }
      }
    });
  }

  Future<void> sendMessage(ToDoMessage message) async {
    final bot = Hoze.instance;
    final IChannel channel = await bot.fetchChannel(message.channel);
    if (channel.channelType != ChannelType.text) {
      Logger('Scheduler').log(Level.SHOUT,
          'sendMessage error, channeltype = ${channel.channelType}');
      return;
    }
    final dstChannel = channel as ITextChannel;
    final IGuild guild = await bot.fetchGuild(message.guild);
    final authorMember = await guild.fetchMember(message.user);
    String? name = authorMember.nickname;
    String? avatarUrl = authorMember.avatarUrl();
    if (name == null || avatarUrl == null) {
      final authorUser = await bot.fetchUser(message.user);
      name ??= authorUser.username;
      avatarUrl ??= authorUser.avatarUrl();
    }
    Postman.sendToChannel(
        embeddedMessage: message.message,
        embeddedAuthorName: name,
        embeddedAuthorPicture: avatarUrl,
        channel: dstChannel);
  }

  Future<void> saveMessage(ToDoMessage message, DateTime when) {
    return DataManager().getScheduledMessages().then(
        (_) => _.put(when.millisecondsSinceEpoch.toString(), message.toMap()));
  }
}
