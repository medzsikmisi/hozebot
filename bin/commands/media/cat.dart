import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman.dart';
import '../command.dart';

class CatCommand extends DiscordCommand{
  CatCommand():super('cat','Get an image of a cat.',[]){
    registerHandler(handle);
  }
  @override
  handle(ISlashCommandInteractionEvent e){
    e.respond(Postman.getImageEmbed('https://cataas.com/cat/gif'));
  }
}