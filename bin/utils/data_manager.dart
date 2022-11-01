import 'dart:math';

import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';

class DataManager {
  static void init({bool testMode = false}) {
    Hive.init('/root/hozedata');
    if (testMode) {
      Hive.deleteFromDisk();
    }
  }

  Future<void> _checkBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  Future<int> getRankCounter({required int guildId}) async {
    await _checkBox('rank_counters');
    final box = Hive.box('rank_counters');
    return box.get(guildId, defaultValue: 0);
  }

  Future<void> incrementRankCounter({required int guildId}) async {
    await _checkBox('rank_counters');
    final box = Hive.box('rank_counters');
    if (!box.containsKey(guildId)) {
      box.put(guildId, 1);
    } else {
      final currentRankCounter = await getRankCounter(guildId: guildId);
      box.put(guildId, currentRankCounter + 1);
    }
  }

  Future<dynamic> canRank({required int guildId, required int userId}) async {
    await _checkBox(guildId.toString());
    final box = Hive.box(guildId.toString());
    if (box.isEmpty) return true;
    final Map user = box.get(userId, defaultValue: {});
    if (user.isEmpty) return true;
    final DateTime nextRank = user['next_rank'];
    final now = DateTime.now();
    Logger('DataManager')
      ..log(Level.INFO, 'nextrank: $nextRank')
      ..log(Level.INFO, 'now: $now');
    if (now.isAfter(nextRank)) return true;
    return nextRank;
  }

  Future<void> registerRank(
      {required int userId, required int guildId, required int rank}) async {
    final guild = guildId.toString();
    await _checkBox(guild);
    final box = Hive.box(guild);
    final nextRank = DateTime.now().add(Duration(minutes: 30));
    if (!box.containsKey(userId)) {
      box.put(userId, {'next_rank': nextRank, 'max_rank': rank});
    } else {
      Map user = box.get(userId);
      final maxRank = user['max_rank'];
      if (maxRank >= rank) {
        Logger('DataManager').log(Level.INFO, 'No rank update needed');
        return;
      } else {
        user['max_rank'] = rank;
        user['next_rank'] = nextRank;
        box.put(userId, user);
        Logger('DataManager').log(Level.INFO, 'Rank updated ($userId,$rank)');
      }
    }
  }

  Future<List<Tuple2<int, int>>> getRankList({required int guildId}) async {
    final ranklist = <Tuple2<int, int>>[];
    await _checkBox(guildId.toString());
    final box = Hive.box(guildId.toString());
    if (box.isEmpty) return [];
    for (var key in box.keys) {
      ranklist.add(Tuple2(key, box.get(key)['max_rank']));
    }
    ranklist.sort((_, __) => __.item2.compareTo(_.item2));
    return ranklist.getRange(0, min(10,ranklist.length)).toList();
  }
}
