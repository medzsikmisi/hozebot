import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman/postman.dart';
import '../command.dart';

class RanklistCommand extends DiscordCommand {
  RanklistCommand() : super('ranglista', 'A jelenlegi 10 legnagyobb rangot tudod lekérdezni', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final guildId = e.interaction.guild!.id.id;
    final ranklist = await DataManager().getRankList(guildId: guildId);
    final postman = Postman(e)..setDefaultColor();

    if (ranklist.isEmpty) {
      postman
        ..setDescription('Nincs még egy rang sem.')
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
      ..setTitle('**Ranglista 🏆**')
      ..setDescription(displayedRanklist.join('\n'))
      ..setTimeOut(Duration(minutes: 1))
      ..send();
  }
}
