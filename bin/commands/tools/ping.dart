import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman/postman.dart';
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
  handle(ISlashCommandInteractionEvent e) {
    final userId = e.getArg('user').value;
    final times = e.getArg('times').value as int;
    Postman(e)
      ..setDefaultColor()
      ..setDescription('Pinging <@$userId> for $times times... ')
      ..setTimeOut(Duration(minutes: 1))
      ..send()
      ..switchToPlain()
      ..setTimeOut(Duration(seconds: 2))
      ..setMessage('<@$userId>')
      ..sendFollowUp(times: times);
  }
}
