import 'dart:math';

import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:xrandom/xrandom.dart';

import '../utils/postman.dart';
import 'command.dart';
/*
THIS CLASS IS CURRENTLY UNDER DEVELOPMENT
 */


class RandomNumberCommand extends DiscordCommand {
  RandomNumberCommand() :super('rnd', 'Generates a random number', [
    CommandOptionBuilder(CommandOptionType.number, 'min',
        'Set the minimum value. (default is 0)', min: -10000000, max: 10000000),
    CommandOptionBuilder(CommandOptionType.number, 'max',
        'Set the maximum value.', required: true,
        min: -10000000,
        max: 10000000,
        defaultArg: true),
  ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    final min = e
        .getArg('min')
        .value ?? 0;
    final max = e
        .getArg('max')
        .value;
  if(max<=min){
    e.respond(Postman.getEmbed('Wrong usage. max<=min',error: true));
    return;
  }
    final rnd = Xrandom();
    double number = rnd.nextDouble();


    e.respond(Postman.getEmbed('Your random number is '));
  }
}