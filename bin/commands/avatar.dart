import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../utils/postman.dart';
import 'command.dart';

class AvatarCommand extends DiscordCommand {
  AvatarCommand()
      : super('avatar', 'Get a user\'s profile picture.', [
          CommandOptionBuilder(CommandOptionType.user, 'user',
              'The user who\'s picture you want.')
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    e.respond(Postman.getEmbed('One sec...'));
    IMember user;
    if (e.args.isEmpty) {
      user = e.interaction.memberAuthor!;
      return;
    } else {
      final userId = e.getArg('user').value;
      if (userId == null) {
        Postman.sendError(e);
        return;
      }
      user = await (await e.interaction.guild!.getOrDownload())
          .fetchMember(userId);
    }
    String username =
        user.nickname ?? (await user.user.getOrDownload()).username;
    Postman.sendPictureFromUrl(e, user.avatarURL(),
        title: '$username\'s avatar:');
  }
}
