import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman.dart';
import '../command.dart';

class JoinCommand extends DiscordCommand {
  JoinCommand()
      : super(
            'join',
            'Ezzel szólsz az adminoknak, hogy akarsz méhecske rangot.',
            [
              CommandOptionBuilder(
                  CommandOptionType.string, 'name', 'Írd be a neved.',
                  required: true),
              CommandOptionBuilder(
                  CommandOptionType.string, 'neptun', 'Írd be a neptun kódod.',
                  required: true),
            ],
            guild: Snowflake('753505407904776214')) {
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) async {
    e.respond(Postman.getEmbed(
        'Ha nem kapsz rangot 2 napon belül, akkor pingeld ezt a rangot: <@&811701870636171274>'));
    final guild = await e.interaction.guild!.getOrDownload();
    final bool channelExists =
        guild.channels.any((channel) => channel.name == 'join');
    ITextChannel channel;
    if (channelExists) {
      channel = guild.channels
          .where((_) => _.name == 'join' && _.channelType == ChannelType.text)
          .first as ITextChannel;
    } else {
      channel = await guild.createChannel(TextChannelBuilder.create('join'))
          as ITextChannel;
    }
    final name = e.getArg('name').value;
    final neptun = e.getArg('neptun').value;
    channel.sendMessage(Postman.getEmbed('Név: *$name*\nNeptun-kód: *$neptun*',
        title: '**Új csatlakozási kérelem**'));
  }
}
