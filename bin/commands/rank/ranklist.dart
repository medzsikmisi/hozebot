import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman.dart';
import '../command.dart';

class RanklistCommand extends DiscordCommand {
  RanklistCommand() : super('ranklist', 'Get the top 10 ranks.', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final guildId = e.interaction.guild!.id.id;
    final ranklist = await DataManager().getRankList(guildId: guildId);
    if (ranklist.isEmpty) {
      e.respond(Postman.getEmbed('No rank found.'));
      return;
    }
    List<String> displayedRanklist = [];
    int i = 1;
    for (var ranklistEntry in ranklist) {
      displayedRanklist.add(
          '**$i.** <@${ranklistEntry.item1}> (*${ranklistEntry.item2}*)${i == 1 ? " 👑" : ""}');
      i++;
    }
    e.respond(Postman.getEmbed(displayedRanklist.join('\n'),
        title: '**Ranklist 🏆**'));
  }
}
