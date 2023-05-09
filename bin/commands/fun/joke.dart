import 'package:dio/dio.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class JokeCommand extends DiscordCommand {
  JokeCommand()
      : super('joke', 'I send you joke if you use this command.', [
          CommandOptionBuilder(CommandOptionType.string, 'type',
              'You can get specific jokes if you select a category. Default is any. Uses the jokeapi.dev.',
              choices: [
                ArgChoiceBuilder('Programming', 'Programming'),
                ArgChoiceBuilder('Miscellaneous', 'Miscellaneous'),
                ArgChoiceBuilder('Dark', 'Dark'),
                ArgChoiceBuilder('Pun', 'Pun'),
                ArgChoiceBuilder('Spooky', 'Spooky'),
                ArgChoiceBuilder('Christmas', 'Christmas'),
              ])
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    String type = 'Any';
    print('checking args');
    if (e.args.isNotEmpty) {
      type = e.getArg('type').value;
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
