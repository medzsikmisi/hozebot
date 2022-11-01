import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class PingCommand extends SlashCommandBuilder {
  PingCommand() : super('hping', 'Check if the bot is running.', []) {
    registerHandler((_) => _.respond(MessageBuilder.content('pong')));
  }
}
