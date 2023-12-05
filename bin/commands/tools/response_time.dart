import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class ResponseTimeCommand extends DiscordCommand {
  ResponseTimeCommand() : super('válaszidő', 'Le tudod kérdezni a chatbot válaszidejét', []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    final DateTime createdAt = e.interaction.createdAt;
    final diff = createdAt.difference(DateTime.now()).inMilliseconds.abs().toString();
    Postman(e)
      ..setDefaultColor()
      ..setDescription('Válaszidő: $diff ms')
      ..send();
  }
}
