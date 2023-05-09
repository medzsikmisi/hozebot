import 'package:logging/logging.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../errors.dart';
import '../../utils/hoze.dart';
import '../../utils/postman/postman.dart';
import '../../utils/rankmanager.dart';
import '../command.dart';

class RankCommand extends DiscordCommand {
  RankCommand()
      : super('rank', 'Get a rank bro.', [
          CommandOptionBuilder(CommandOptionType.user, 'user',
              'If you want to get a rank for somebody else.')
        ]) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    final guildId = e.interaction.guild!.id.toString();
    String? userId;
    bool? hasNitro;
    String? name;
    String? tag;
    if (e.args.isEmpty) {
      userId = e.interaction.userAuthor!.id.id.toString();
      hasNitro = ((e.interaction.userAuthor!.nitroType?.value as NitroType?) ??
              NitroType.none) !=
          NitroType.none;
      name = e.interaction.memberAuthor!.nickname;
      name ??= e.interaction.userAuthor!.username;
      tag = e.interaction.userAuthor!.tag;
    } else if (e.args.length == 1) {
      userId = e.args.first.value;
      final member = await fetchMember(userId!, e.interaction.guild!.id);
      hasNitro =
          ((await member?.user.getOrDownload())?.nitroType ?? NitroType.none) !=
              NitroType.none;
      tag = (await member!.user.getOrDownload()).tag;
      name = member.nickname;
      name ??= (await member.user.getOrDownload()).username;
    } else {
      Postman(e).sendError('', static: true);

      Logger('RankCommand').log(Level.SHOUT,
          'ERROR => RANKCOMMAND :: handle() :: e.interaction.memberAuthor?.id.id = null');
      return;
    }
    if (userId == null) {
      Postman(e).sendError('', static: true);
      return;
    }
    final isBot = await checkIfBot(userId, e);
    if (isBot) {
      Logger('RankCommand').log(Level.INFO, 'Rank command called on bot.');
      return;
    }
    final postman = Postman(e)
      ..setDefaultColor()
      ..setDescription('Getting rank for $name...');
    await postman.send();

    try {
      final rank =
          await RankManager().getRank(userId, guildId, tag, hasNitro: hasNitro);
      postman
        ..setDescription("$name's rank is $rank.")
        ..editOriginal();
    } catch (err) {
      if (err is CannotRankError) {
        final nextRank = err.nextRank;

        final nextRankString =
            nextRank.toString().substring(0, nextRank.toString().length - 4);
        postman
          ..setDescription('Try again after $nextRankString.')
          ..setTimeOut(Duration(seconds: 10))
          ..editOriginal();
        return;
      }
      postman.sendError('', static: true);
    }
  }

  Future<IMember?> fetchMember(String id, Snowflake guildId) async {
    final instance = Hoze.instance;
    final guild = await instance.fetchGuild(guildId);
    final member = await guild.fetchMember(Snowflake(id));
    return member;
  }

  Future<bool> checkIfBot(String id, ISlashCommandInteractionEvent e) async {
    final botInstance = Hoze.instance;
    final user = await botInstance.fetchUser(Snowflake(id));
    if (user.bot == true) {
      Postman(e)
        ..setDefaultColor()
        ..setDescription(
            "Nice try but bots are always better than humans.")
        ..send();
      return true;
    }
    return false;
  }
}
