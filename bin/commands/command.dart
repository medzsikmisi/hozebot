import 'package:nyxx_interactions/nyxx_interactions.dart';

abstract class DiscordCommand extends SlashCommandBuilder {
  DiscordCommand(super.name, super.description, super.options,{super.guild,super.canBeUsedInDm=false}) {
    registerHandler(handle);
  }

  handle(ISlashCommandInteractionEvent e);
}
