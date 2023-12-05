import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:xrandom/xrandom.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';
/*
THIS CLASS IS CURRENTLY UNDER DEVELOPMENT
 */

class RandomNumberCommand extends DiscordCommand {
  RandomNumberCommand()
      : super('szám', 'Véletlenszerű szám generálása', [ CommandOptionBuilder(
      CommandOptionType.number, 'maximium', 'Állítsd be a maximum értéket.',
      required: true, min: -10000000, max: 10000000),
          CommandOptionBuilder(CommandOptionType.number, 'min',
              'Állítsd be a minimum értéket (alapból 0)',
              min: -10000000, max: 10000000),

        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    final min = e.getArg('minimum').value ?? 0;
    final max = e.getArg('maximum').value;
    if (max <= min) {
      Postman(e).sendError('Rosszul használtad. max<=min');

      return;
    }
    final rnd = Xrandom();
    double number = rnd.nextDouble();
    Postman(e)
      ..setDefaultColor()
      ..setDescription('A számod ennyi lett: $number')
      ..send();
  }
}
