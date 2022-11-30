import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman.dart';
import '../command.dart';

class PingCommand extends DiscordCommand {
  PingCommand()
      : super('ping', "You can ping someone if he doesn't answer", [
    CommandOptionBuilder(
        CommandOptionType.user, 'user', 'The user you want to ping.',
        required: true),
    CommandOptionBuilder(CommandOptionType.integer, 'times',
        'How many message do you want?',
        min: 1, max: 10, required: true)
  ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e)  {
    final userId = e
        .getArg('user')
        .value;
    final times = e
        .getArg('times')
        .value as int;
    e
        .respond(Postman.getEmbed('Pinging <@$userId> for $times times... '))
        .whenComplete(() async{
      final channel = await e.interaction.channel.getOrDownload();
      for (var i = 0; i < times; i++) {

            channel.sendMessage(Postman.getMessage('<@$userId>')).then(
                    (_) =>
                    Future.delayed(Duration(seconds: 30), () => _.delete()));
            await Future.delayed(Duration(seconds: 1));
      }
    });
  }
}
