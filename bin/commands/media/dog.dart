import 'package:dio/dio.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class DogCommand extends DiscordCommand {
  DogCommand() : super('dog', 'You can get pictures of dogs.', []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    Future.delayed(Duration.zero, () async {
      final postman = Postman(e);
      postman
        ..setDefaultColor()
        ..setDescription('Loading...');
      await postman.send();

      final url = await getUrl();
      postman
        ..deleteDescription()
        ..setImageUrl('https://cataas.com$url')
        ..editOriginal();
    });
  }

  Future<String> getUrl() async {
    final respond = await Dio().get('https://random.dog/woof.json');
    final data = respond.data;
    if (data['url'].toString().toLowerCase().endsWith('.mp4')) return getUrl();
    return data['url'];
  }
}
