import 'package:dio/dio.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class JokeCommand extends DiscordCommand {
  JokeCommand()
      : super('vicc', 'Angol nyelvű viccet tudsz kérni.', [
          CommandOptionBuilder(CommandOptionType.string, 'típus',
              'Tudod specifikálni, hogy milyen típusú viccet kapj. Alapértelmezetten bármilyen. A jokeapi.dev végpontot használja a program.',
              choices: [
                ArgChoiceBuilder('Programozás', 'Programming'),
                ArgChoiceBuilder('Egyéb', 'Miscellaneous'),
                ArgChoiceBuilder('Sötét humor', 'Dark'),
                ArgChoiceBuilder('Szóvicc', 'Pun'),
                ArgChoiceBuilder('Ijesztő', 'Spooky'),
                ArgChoiceBuilder('Karácsony', 'Christmas'),
              ])
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    String type = 'Any';
    print('checking args');
    if (e.args.isNotEmpty) {
      type = e.getArg('típus').value;
      print('type is $type');
    }
    print('type check: $type');
    final response = await Dio().get('https://v2.jokeapi.dev/joke/$type');
    if (response.statusCode != 200) {
      print('request success');
      print(response.data);
      Postman(e).sendError('', static: true);
      return;
    }

    if (response.data['type'] == 'single') {
      print('single');
      final joke = response.data['joke'];
      Postman(e)
        ..setDefaultColor()
        ..setDescription(joke)
        ..send();
    } else if (response.data['type'] == 'twopart') {
      print('twopart');
      final part1 = response.data['setup'];
      final part2 = response.data['delivery'];
      Postman(e)
        ..setDefaultColor()
        ..setDescription('$part1\n||$part2||')
        ..send();
    } else {
      print('neither');
      Postman(e).sendError('', static: true);
      return;
    }
  }
}
