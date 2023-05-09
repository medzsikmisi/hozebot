import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman/postman.dart';
import '../command.dart';

class MaxRankRommand extends DiscordCommand {
  MaxRankRommand()
      : super('rmax', 'Get the current value of maximum rank value.', []) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final guildId = e.interaction.guild!.id.toString();
    final rankCounter = await DataManager().getRankCounter(guildId: guildId);
    final maxRank = (100 + 0.03 * rankCounter).floor();
    Postman(e)
      ..setDefaultColor()
      ..setDescription(
          'The current max rank is $maxRank. Number of ranks: $rankCounter')
      ..setTimeOut(Duration(seconds: 15))
      ..send();
  }
}
