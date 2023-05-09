import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/postman/postman.dart';
import '../command.dart';

class ResponseTimeCommand extends DiscordCommand {
  ResponseTimeCommand() : super('responsetime', 'You can get the response time', []);

  @override
  handle(ISlashCommandInteractionEvent e) {
    final DateTime createdAt = e.interaction.createdAt;
    final diff = createdAt.difference(DateTime.now()).inMilliseconds.abs().toString();
    Postman(e)
      ..setDefaultColor()
      ..setDescription('Ping: $diff ms')
      ..send();
  }
}
