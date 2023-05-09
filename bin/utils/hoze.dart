import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../commands/fun/joke.dart';
import '../commands/gif/interaction/congratulation.dart';
import '../commands/gif/interaction/highfive.dart';
import '../commands/gif/interaction/hug.dart';
import '../commands/gif/interaction/kiss.dart';
import '../commands/gif/interaction/punch.dart';
import '../commands/gif/interaction/slap.dart';
import '../commands/headOrTail/head.dart';
import '../commands/headOrTail/tail.dart';
import '../commands/media/cat.dart';
import '../commands/media/dog.dart';
import '../commands/rank/maxrank.dart';
import '../commands/rank/rank.dart';
import '../commands/rank/ranklist.dart';
import '../commands/tools/avatar.dart';
import '../commands/tools/ping.dart';
import '../commands/tools/reset.dart';
import '../commands/tools/response_time.dart';
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
      ..registerSlashCommand(JokeCommand())
      ..registerSlashCommand(ResetRanklistCommand())
      ..registerSlashCommand(DogCommand())
      ..registerSlashCommand(CatCommand())
      ..registerSlashCommand(SlapCommand())
      ..registerSlashCommand(HugCommand())
      ..registerSlashCommand(KissCommand())
      ..registerSlashCommand(CongratulationCommand())
      ..registerSlashCommand(HighFiveCommand())
      ..registerSlashCommand(PunchCommand())
      ..registerSlashCommand(ResponseTimeCommand())
      //..registerSlashCommand(RandomNumberCommand())
      ..syncOnReady();
  }

  _checkMessages() => MessageScheduler().checkMessages();

  void addJob(Schedule schedule, Task job) {
    cron.schedule(schedule, job);
  }
}
