import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class Postman {
  static MessageBuilder getMessage(final String message) {
    return MessageBuilder.content(message);
  }

  static MessageBuilder getEmbed(final String message,
      {final String? color,
      final bool error = false,
      final String? title,
      final String? authorName,
      final String? authorIconUrl}) {
    final embed = EmbedBuilder();

    if (color == null && !error) {
      embed.color = DiscordColor.fromHexString('#e7c97b');
    } else if (error) {
      embed.title = 'ERROR';
      embed.description = message.isNotEmpty
          ? message
          : 'An error occurred. Try again later or contact with developer.';
      embed.color = DiscordColor.fromHexString('#7b0112');
      return MessageBuilder.embed(embed);
    } else {
      embed.color = DiscordColor.fromHexString(color.toString());
    }
    embed.description = message;
    if (title != null) embed.title = title;

    if (authorName != null && authorIconUrl != null) {
      embed.addAuthor((author) {
        author.name = authorName;
        author.iconUrl = authorIconUrl;
      });
    }
    return MessageBuilder.embed(embed);
  }

  static void sendError(ISlashCommandInteractionEvent e) {
    e.respond(getError()).then((_) =>
        Future.delayed(Duration(minutes: 2), () => e.deleteOriginalResponse()));
  }

  static MessageBuilder getError() {
    return getEmbed('An error occurred. Try again later. 😒', error: true);
  }

  static getImageEmbed(String url) {
    final embed = EmbedBuilder();
    embed.url = url;
    embed.color = DiscordColor.fromHexString('#e7c97b');
    return embed;
  }

  static Future<void> sendPictureFromUrl(
      ISlashCommandInteractionEvent e, String? url,
      {String? title, Duration? timeout}) async {
    final embed = EmbedBuilder();
    embed.color = DiscordColor.fromHexString('#e7c97b');
    embed.title = title;
    embed.imageUrl = url;
    await e
        .getOriginalResponse()
        .then((value) => value.edit(MessageBuilder.embed(embed)));
    if (timeout != null) {
      Future.delayed(timeout, () => e.deleteOriginalResponse());
    }
  }
}
