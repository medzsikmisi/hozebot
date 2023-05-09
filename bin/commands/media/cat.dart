import 'package:dio/dio.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class CatCommand extends DiscordCommand {
  CatCommand() : super('cat', 'Get an image of a cat.', []) {
    registerHandler(handle);
  }

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
    final respond = await Dio().get('https://cataas.com/cat?json=true');
    final data = respond.data;
    if (data['url'].toString().toLowerCase().endsWith('.mp4')) return getUrl();
    return data['url'];
  }
}
