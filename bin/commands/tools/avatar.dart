import 'package:logging/logging.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman/postman.dart';
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
    final postman = Postman(e);
    postman
      ..setDefaultColor()
      ..setDescription('One sec...');
    await postman.send();
    IMember user;
    if (e.args.isEmpty) {
      user = e.interaction.memberAuthor!;
    } else {
      final String? userId = e.getArg('user').value;
      if (userId == null) {
        postman.sendError('', static: true);
        return;
      }
      final guild = await e.interaction.guild!.getOrDownload();
      user = await guild.fetchMember(Snowflake(userId));
    }
    String username =
        user.nickname ?? (await user.user.getOrDownload()).username;
    String? avatarUrl = user.avatarUrl();
    if (avatarUrl == null) {
      final globalUser = await user.user.getOrDownload();
      avatarUrl = globalUser.avatarUrl(size: 1024);
    }
    Logger('AvatarCommand').log(Level.INFO, 'avatarUrl:$avatarUrl');
    postman
      ..deleteDescription()
      ..setTitle('$username\'s avatar:')
      ..setImageUrl(avatarUrl)
      ..setTimeOut(Duration(minutes: 2))
      ..editOriginal();
  }
}
