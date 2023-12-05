import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman/postman.dart';
import '../command.dart';

class MaxRankRommand extends DiscordCommand {
  MaxRankRommand()
      : super('maxrang', 'A jelenlegi maximum rang számot tudod lekérdezni', []) {
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
          'A mostani legnagyobb elérhető rang $maxRank. Eddig ennyiszer használták a parancsot: $rankCounter')
      ..setTimeOut(Duration(seconds: 15))
      ..send();
  }
}
