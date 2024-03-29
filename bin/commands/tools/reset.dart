import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman/postman.dart';
import '../command.dart';

class ResetRanklistCommand extends DiscordCommand {
  ResetRanklistCommand()
      : super('datareset',
            'With the right permission, resets the leaderboard data.', []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    final author = e.interaction.userAuthor?.id.toString();
    if (author != '737043082704584855') {
      Postman(e).sendError('You do not have the correct permission.');
      return;
    }
    final postman = Postman(e)
      ..setDefaultColor()
      ..setDescription('Deleting...');
    postman.send().then((_) {
      DataManager.reset();
      postman
        ..setDescription('Ranklist deleted successfully.')
        ..editOriginal();
    });
  }
}
