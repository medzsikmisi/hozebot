import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/hot_manager.dart';
import '../../utils/postman.dart';
import '../command.dart';

class TailCommand extends DiscordCommand{
  TailCommand():super('tail','Heads or tails. You choose tail.',[]){
    registerHandler(handle);

  }
  @override
  handle(ISlashCommandInteractionEvent e) {
    final result = HeadsOrTailsManager().play(HeadsOrTails.tail);
    Future.delayed(Duration(seconds: 1),(){
      e.respond(Postman.getEmbed('You ${result?"won.🫡":"lost. 🙄"}',title: "It's ${result?'tail':'head'}."));
    });
  }
}