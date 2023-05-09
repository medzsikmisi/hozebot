import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman/postman.dart';
import '../command.dart';

class RanklistCommand extends DiscordCommand {
  RanklistCommand() : super('leaderboard', 'Get the top 10 ranks.', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final guildId = e.interaction.guild!.id.id;
    final ranklist = await DataManager().getRankList(guildId: guildId);
    final postman = Postman(e)..setDefaultColor();

    if (ranklist.isEmpty) {
      postman
        ..setDescription('No rank found.')
        ..setTimeOut(Duration(seconds: 10))
        ..send();
      return;
    }
    List<String> displayedRanklist = [];
    int i = 1;
    for (var ranklistEntry in ranklist) {
      displayedRanklist.add(
          '**$i.** <@${ranklistEntry.item1}> (*${ranklistEntry.item2}*)${i == 1 ? " 👑" : ""}');
      i++;
    }
    postman
      ..setTitle('**Ranklist 🏆**')
      ..setDescription(displayedRanklist.join('\n'))
      ..setTimeOut(Duration(minutes: 1))
      ..send();
  }
}
