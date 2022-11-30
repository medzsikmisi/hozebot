import 'package:logging/logging.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman.dart';
import '../command.dart';

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
    Future.delayed(Duration.zero, () async {
      await e.respond(Postman.getEmbed('One sec...'));
    });
    IMember user;
    if (e.args.isEmpty) {
      user = e.interaction.memberAuthor!;
    } else {
      final String? userId = e.getArg('user').value;
      if (userId == null) {
        Postman.sendError(e);
        return;
      }
      final guild = await e.interaction.guild!.getOrDownload();
      user = await guild.fetchMember(Snowflake(userId));
    }
    String username =
        user.nickname ?? (await user.user.getOrDownload()).username;
    String? avatarUrl = user.avatarURL();
    if (avatarUrl == null) {
      final globalUser = await user.user.getOrDownload();
      avatarUrl = globalUser.avatarURL(size: 1024);
    }
    Logger('AvatarCommand').log(Level.INFO, 'avatarUrl:$avatarUrl');
    await Postman.sendPictureFromUrl(e, avatarUrl,
        title: '$username\'s avatar:',timeout:Duration(minutes: 5));
  }
}
