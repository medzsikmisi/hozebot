import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman.dart';
import '../command.dart';

class ResetRanklistCommand extends DiscordCommand {
  ResetRanklistCommand()
      : super('datareset',
            'With the right permission, resets the leaderboard data.', []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    final author = e.interaction.userAuthor?.id.toString();
    if (author != '737043082704584855') {
      e.respond(Postman.getEmbed('You do not have the correct permission.',
          error: true));
    } else {
      e
          .respond(Postman.getEmbed('Deleting...'))
          .then((value) => Future.delayed(Duration.zero, () async{
                await DataManager.reset();
                e.editOriginalResponse(Postman.getEmbed(
                  'Deleted successfully',
                ));
              }));
    }
  }
}
