import 'package:logging/logging.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../errors.dart';
import '../utils/hoze.dart';
import '../utils/postman.dart';
import '../utils/rankmanager.dart';

class RankCommand extends SlashCommandBuilder {
  RankCommand()
      : super('rank', 'Get a rank bro.', [
          CommandOptionBuilder(CommandOptionType.user, 'user',
              'If you want to get a rank for somebody else.')
        ]) {
    registerHandler(handle);
  }

  handle(ISlashCommandInteractionEvent e) async {
    final guildId = e.interaction.guild!.id.id;
    int? userId;
    String? name;
    if (e.args.isEmpty) {
      userId = e.interaction.memberAuthor?.id.id;
      name = e.interaction.memberAuthor?.nickname;
    } else if (e.args.length == 1) {
      userId = int.tryParse(e.args.first.value);
      name = await fetchUserName(userId!, e.interaction.guild!.id);
    } else {
      Postman.sendError(e);
      Logger('RankCommand').log(Level.SHOUT,
          'ERROR => RANKCOMMAND :: handle() :: e.interaction.memberAuthor?.id.id = null');
      return;
    }
    if (userId == null) {
      Postman.sendError(e);
      return;
    }
    final isBot = await checkIfBot(userId, e);
    if (isBot) {
      Logger('RankCommand').log(Level.INFO, 'Rank command called on bot.');
      return;
    }
    e.respond(Postman.getEmbed('Getting rank for $name'));
    try {
      final rank = await RankManager().getRank(userId, guildId);
      e.getOriginalResponse().then(
          (value) => value.edit(Postman.getEmbed("$name's rank is $rank.")));
    } catch (err) {
      if (err is CannotRankError) {
        final nextRank = err.nextRank;
        final nextRankString =
            "${nextRank.year}.${nextRank.month}.${nextRank.day} ${nextRank.hour}:${nextRank.minute}:${nextRank.second}";
        e.getOriginalResponse().then((value) =>
            value.edit(Postman.getEmbed('Try again after $nextRankString')));
      }
      Postman.sendError(e);
    }
  }

  Future<String?> fetchUserName(int id, Snowflake guildId) async {
    final instance = Hoze.getInstance();
    final guild = await instance.fetchGuild(guildId);
    final member = await guild.fetchMember(Snowflake(id));
    return member.nickname;
  }

  Future<bool> checkIfBot(int id, ISlashCommandInteractionEvent e) async {
    final botInstance = Hoze.getInstance();
    final user = await botInstance.fetchUser(Snowflake(id));
    if (user.bot == true) {
      e.respond(Postman.getEmbed(
          "Bots are always better than humans. That's why y'all lose. (Spoiler alert)"));
      return true;
    }
    return false;
  }
}