import 'package:dio/dio.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman.dart';
import '../command.dart';

class CatCommand extends DiscordCommand {
  CatCommand() : super('cat', 'Get an image of a cat.', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    Future.delayed(Duration.zero, () async {
      await e.respond(Postman.getEmbed('Loading...'));
      final url = await getUrl();
      e.getOriginalResponse().then((_) => _.edit(MessageBuilder.embed(Postman.getImageEmbed('https://cataas.com$url'))));
    });
  }

  Future<String> getUrl() async {
    final respond = await Dio().get('https://cataas.com/cat?json=true');
    final data = respond.data;
    if (data['url'].toString().toLowerCase().endsWith('.mp4')) return getUrl();
    return data['url'];
  }
}
