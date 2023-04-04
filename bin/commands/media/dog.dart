import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/postman.dart';
import '../command.dart';

class DogCommand extends DiscordCommand {
  DogCommand() : super('dog', 'You can get pictures of dogs.', []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    Future.delayed(Duration.zero, () async {
      await e.respond(Postman.getEmbed('Loading...'));
      final url = await getUrl();
      e.getOriginalResponse().then((_) => _.edit(MessageBuilder.embed(Postman.getImageEmbed(url))));
    });
  }

  Future<String> getUrl() async {
    final respond = await Dio().get('https://random.dog/woof.json');
    final data = respond.data;
    if (data['url'].toString().toLowerCase().endsWith('.mp4')) return getUrl();
    return data['url'];
  }
}
