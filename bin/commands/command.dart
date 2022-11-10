import 'package:nyxx_interactions/nyxx_interactions.dart';

abstract class DiscordCommand extends SlashCommandBuilder {
  DiscordCommand(super.name, super.description, super.options) {
    registerHandler(handle);
  }

  handle(ISlashCommandInteractionEvent e);
}
