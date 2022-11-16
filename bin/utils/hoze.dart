import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../commands/headOrTail/head.dart';
import '../commands/headOrTail/tail.dart';
import '../commands/rank/maxrank.dart';
import '../commands/rank/rank.dart';
import '../commands/rank/ranklist.dart';
import '../commands/tools/avatar.dart';
import '../commands/tools/ping.dart';
import '../commands/zumi/zumijoin.dart';
import 'data_manager.dart';

class Hoze {
  static INyxxWebsocket? _bot;

  static INyxxWebsocket getInstance() => _bot!;

  //TODO implement cron
  static Cron cron = Cron();

  Future<void> rise() async {
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
      ..registerSlashCommand(MaxRankRommand())
      ..registerSlashCommand(JoinCommand())
      ..syncOnReady();
  }

  void addJob(Schedule schedule, Task job) {
    cron.schedule(schedule, job);
  }
}
