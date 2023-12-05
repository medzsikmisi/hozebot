import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../../utils/gif_manager.dart';
import '../../../utils/hoze.dart';
import '../../../utils/postman/postman.dart';
import '../../command.dart';

abstract class InteractionCommand extends DiscordCommand {
  final String action;

  InteractionCommand(String name, String dsc, this.action)
      : super(name, dsc, [
          CommandOptionBuilder(CommandOptionType.user, 'barát',
              'A barátod, akivel ezt akarod csinálni: $name',
              required: true)
        ]);

  @override
  handle(ISlashCommandInteractionEvent e) async {
    if (e.args.isEmpty) {
      Postman(e).sendError('Jelölj meg valakit!');
      return;
    }
    final userId = e.args.first.value;
    final member = await fetchMember(userId!, e.interaction.guild!.id);
    final targetUserMention = member?.mention;
    final author = e.interaction.memberAuthor;
    final authorMention = author?.mention;
    final gifUrl = await GifManager.search(name).getGif();
    final actionString = action.replaceAll('@author', authorMention.toString()).replaceAll('@target', targetUserMention.toString());
    Postman(e)
      ..setDefaultColor()
      ..setDescription(actionString)
      ..setImageUrl(gifUrl)
      ..send();
  }

  Future<IMember?> fetchMember(String id, Snowflake guildId) async {
    final instance = Hoze.instance;
    final guild = await instance.fetchGuild(guildId);
    final member = await guild.fetchMember(Snowflake(id));
    return member;
  }
}
