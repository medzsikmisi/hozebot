import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/hot_manager.dart';
import '../../utils/postman.dart';
import '../../utils/rankmanager.dart';
import '../command.dart';

class HeadCommand extends DiscordCommand{
  HeadCommand():super('head','Heads or tails. You choose head.',[]){
    registerHandler(handle);

  }
@override
  handle(ISlashCommandInteractionEvent e) {
  final result = HeadsOrTailsManager().play(HeadsOrTails.head);
  Future.delayed(Duration(seconds: 1),(){
    e.respond(Postman.getEmbed('You ${result?"won.🫡":"lost. 🙄"}',title: "It's ${result?'head':'tail'}.")).timeout(Duration(minutes: 1));
    if (result) {
      final userId = e.interaction.memberAuthor!.id.toString();
      final guildId = e.interaction.guild!.id.id;
      RankManager().reduceRankTime(userId, guildId);
    }
  });
  }
}