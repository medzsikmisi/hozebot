import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../commands/avatar.dart';
import '../commands/headOrTail/head.dart';
import '../commands/headOrTail/tail.dart';
import '../commands/ping.dart';
import '../commands/rank.dart';
import '../commands/ranklist.dart';
import 'data_manager.dart';

class Hoze {
  static INyxxWebsocket? _bot;

  static INyxxWebsocket getInstance() => _bot!;

  static Future<void> rise() async {
    await DataManager.init();
    final token = Platform.environment['DC_TOKEN'].toString();
    _bot =
        NyxxFactory.createNyxxWebsocket(token, GatewayIntents.allUnprivileged)
          ..registerPlugin(Logging()) // Default logging plugin
          ..registerPlugin(
              CliIntegration()) // Cli integration for nyxx allows stopping application via SIGTERM and SIGKILl
          ..registerPlugin(
              IgnoreExceptions()) // Plugin that handles uncaught exceptions that may occur
          ..connect();
    initCommands();
  }

  static void initCommands() {
    IInteractions.create(WebsocketInteractionBackend(_bot!))
      ..registerSlashCommand(PingCommand())
      ..registerSlashCommand(RankCommand())
      ..registerSlashCommand(RanklistCommand())
      ..registerSlashCommand(AvatarCommand())
      ..registerSlashCommand(HeadCommand())
      ..registerSlashCommand(TailCommand())
      ..syncOnReady();
  }
}
