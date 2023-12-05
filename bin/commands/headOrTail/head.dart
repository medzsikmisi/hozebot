import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/hot_manager.dart';
import '../../utils/postman/postman.dart';
import '../../utils/rankmanager.dart';
import '../command.dart';

class HeadCommand extends DiscordCommand {
  HeadCommand() : super('fej', 'Fej vagy írásnál a fejet választod.', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    final result = HeadsOrTailsManager().play(HeadsOrTails.head);
    Future.delayed(Duration(seconds: 1), () {
      Postman(e)
        ..setDefaultColor()
        ..setTitle(result ? 'Fej.' : 'Írás.')
        ..setDescription(result ? "Nyertél.🫡" : "Vesztettél. 🙄")
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
