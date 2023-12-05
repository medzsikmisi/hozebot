import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../models/todo.dart';
import '../../utils/postman/postman.dart';
import '../../utils/scheduler.dart';
import '../command.dart';

class ScheduleCommand extends DiscordCommand {
  ScheduleCommand()
      : super('időzítés', 'Üzenetet tudsz időzíteni.', [
          CommandOptionBuilder(CommandOptionType.string, 'üzenet',
              'Az üzenet, amit szeretnél időzíteni.',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'óra',
              'Hány órára szeretnéd időzíteni?',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'perc',
              'Hány percre szeretnéd időzíteni? Minimum két perc mostantól, különben holnap küldi el.',
              required: true),
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final messageTest = e.getArg('üzenet').value;
    final user = e.interaction.memberAuthor!.id;
    final channel = (await e.interaction.channel.getOrDownload()).id;
    final guild = (await e.interaction.guild!.getOrDownload()).id;
    final message = ToDoMessage(
        message: messageTest.toString(),
        guildId: guild,
        channelId: channel,
        userId: user);
    final hour = e.getArg('óra').value as int;
    final minute = e.getArg('perc').value as int;
    final DateTime now = DateTime.now();
    DateTime scheduleTime =
        DateTime(now.year, now.month, now.day, hour, minute);
    if (now.hour > hour || (now.hour == hour && now.minute + 1 > minute)) {
      scheduleTime = scheduleTime.add(Duration(days: 1));
    }
    Future.delayed(Duration.zero, () async {
      await MessageScheduler().saveMessage(message, scheduleTime);
    });
    Postman(e)
      ..setDefaultColor()
      ..setToPrivate()
      ..setDescription(
          'Your message is saved. It will be delivered at ${scheduleTime.toString().substring(0, scheduleTime.toString().length - 7)}')
      ..send();
  }
}
