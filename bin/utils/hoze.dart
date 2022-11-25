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
import '../commands/tools/schedule.dart';
import '../commands/zumi/zumijoin.dart';
import 'data_manager.dart';
import 'scheduler.dart';

class Hoze {
  static const test = false;

  static INyxxWebsocket? _bot;

  static INyxxWebsocket get instance => _bot!;

  static Cron cron = Cron();

  Future<void> rise() async {
    await DataManager.init();
    Hoze.cron.schedule(Schedule.parse('* * * * *'), _checkMessages);
    final token = Platform.environment['DC_TOKEN'].toString();
    _bot = NyxxFactory.createNyxxWebsocket(token, GatewayIntents.allUnprivileged)
      ..registerPlugin(Logging()) // Default logging plugin
      ..registerPlugin(
          CliIntegration()) // Cli integration for nyxx allows stopping application via SIGTERM and SIGKILl
      ..registerPlugin(
          IgnoreExceptions()) // Plugin that handles uncaught exceptions that may occur
      ..connect();
    initCommands();
  }

  static void die() {
    _bot?.dispose();
    exit(0);
  }

  static void initCommands() {
    IInteractions.create(WebsocketInteractionBackend(_bot!))
      ..registerSlashCommand(RankCommand())
      ..registerSlashCommand(RanklistCommand())
      ..registerSlashCommand(AvatarCommand())
      ..registerSlashCommand(HeadCommand())
      ..registerSlashCommand(TailCommand())
      ..registerSlashCommand(MaxRankRommand())
      ..registerSlashCommand(JoinCommand())
      ..registerSlashCommand(ScheduleCommand())
      ..registerSlashCommand(PingCommand())
      ..syncOnReady();
  }

  _checkMessages() => MessageScheduler().checkMessages();

  void addJob(Schedule schedule, Task job) {
    cron.schedule(schedule, job);
  }
}
