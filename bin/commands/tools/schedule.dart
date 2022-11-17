import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../models/todo.dart';
import '../../utils/postman.dart';
import '../../utils/scheduler.dart';
import '../command.dart';

class ScheduleCommand extends DiscordCommand {
  ScheduleCommand()
      : super('schedule', 'You can send a message at a different time.', [
          CommandOptionBuilder(CommandOptionType.string, 'message',
              'The message you want to schedule.',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'hour',
              'The hour you want to deliver the message.',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'minute',
              'The minute you want to deliver the message. (min 2 or it\'ll be delivered tomorrow)',
              required: true),
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final messageTest = e.getArg('message').value;
    final user = e.interaction.memberAuthor!.id;
    final channel = (await e.interaction.channel.getOrDownload()).id;
    final guild = (await e.interaction.guild!.getOrDownload()).id;
    final message = ToDoMessage(
        message: messageTest.toString(),
        guildId: guild,
        channelId: channel,
        userId: user);
    final hour = e.getArg('hour').value as int;
    final minute = e.getArg('minute').value as int;
    final DateTime now = DateTime.now().add(Duration(hours: 1));
    DateTime scheduleTime =
        DateTime(now.year, now.month, now.day, hour, minute);
    if (now.hour > hour || (now.hour == hour && now.minute + 1 > minute)) {
      scheduleTime = scheduleTime.add(Duration(days: 1));
    }
    Future.delayed(Duration.zero, () async {
      await MessageScheduler().saveMessage(message, scheduleTime);
    });
     e.respond(
        Postman.getEmbed(
            'Your message is saved. It will be delivered at ${scheduleTime.toString().substring(0, scheduleTime.toString().length - 7)}'),
        hidden: true);

  }
}
