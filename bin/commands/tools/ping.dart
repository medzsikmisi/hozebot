import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class PingCommand extends DiscordCommand {
  PingCommand()
      : super('megjelölés', "Jelöld meg egy barátodat, ha nem válaszol.", [
          CommandOptionBuilder(CommandOptionType.user, 'barát',
              'A barátod, akinek szólni szeretnél',
              required: true),
          CommandOptionBuilder(CommandOptionType.integer, 'hányszor',
              'Hányszor szeretnéd, hogy megjelöljem?',
              min: 1, max: 10, required: true)
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    final userId = e.getArg('barát').value;
    final times = e.getArg('hányszor').value as int;
    Postman(e)
      ..setDefaultColor()
      ..setDescription('<@$userId> megjelölése ennyiszer: $times... ')
      ..setTimeOut(Duration(minutes: 1))
      ..send()
      ..switchToPlain()
      ..setTimeOut(Duration(seconds: 2))
      ..setMessage('<@$userId>')
      ..sendFollowUp(times: times);
  }
}
