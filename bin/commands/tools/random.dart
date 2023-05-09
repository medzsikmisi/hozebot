import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:xrandom/xrandom.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';
/*
THIS CLASS IS CURRENTLY UNDER DEVELOPMENT
 */

class RandomNumberCommand extends DiscordCommand {
  RandomNumberCommand()
      : super('rnd', 'Generates a random number', [ CommandOptionBuilder(
      CommandOptionType.number, 'max', 'Set the maximum value.',
      required: true, min: -10000000, max: 10000000),
          CommandOptionBuilder(CommandOptionType.number, 'min',
              'Set the minimum value. (default is 0)',
              min: -10000000, max: 10000000),

        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    final min = e.getArg('min').value ?? 0;
    final max = e.getArg('max').value;
    if (max <= min) {
      Postman(e).sendError('Wrong usage. max<=min');

      return;
    }
    final rnd = Xrandom();
    double number = rnd.nextDouble();
    Postman(e)
      ..setDefaultColor()
      ..setDescription('Your random number is $number')
      ..send();
  }
}
