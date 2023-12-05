import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/data_manager.dart';
import '../../utils/postman/postman.dart';
import '../command.dart';

class ResetRanklistCommand extends DiscordCommand {
  ResetRanklistCommand()
      : super(
            'adattörlés',
            'A megfelelő engedéllyel törölheted az adatbázist. (veszélyes!)',
            []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    final author = e.interaction.userAuthor?.id.toString();
    if (author != '737043082704584855') {
      Postman(e).sendError('Ehhez a parancshoz nincs engedélyed!');
      return;
    }
    final postman = Postman(e)
      ..setDefaultColor()
      ..setDescription('Deleting...');
    postman.send().then((_) {
      DataManager.reset();
      postman
        ..setDescription('Sikeres törlés.')
        ..editOriginal();
    });
  }
}
