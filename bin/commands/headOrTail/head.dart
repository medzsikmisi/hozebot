import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/hot_manager.dart';
import '../../utils/postman/postman.dart';
import '../../utils/rankmanager.dart';
import '../command.dart';

class HeadCommand extends DiscordCommand {
  HeadCommand() : super('head', 'Heads or tails. You choose head.', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    final result = HeadsOrTailsManager().play(HeadsOrTails.head);
    Future.delayed(Duration(seconds: 1), () {
      Postman(e)
        ..setDefaultColor()
        ..setTitle("It's ${result ? 'head' : 'tail'}.")
        ..setDescription('You ${result ? "won.🫡" : "lost. 🙄"}')
        ..setTimeOut(Duration(seconds: 15))
        ..send();

      if (result) {
        final userId = e.interaction.memberAuthor!.id.toString();
        final guildId = e.interaction.guild!.id.id;
        RankManager().reduceRankTime(userId, guildId);
      }
    });
  }
}
