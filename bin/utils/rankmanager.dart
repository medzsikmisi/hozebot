import 'dart:math';

import 'package:logging/logging.dart';
import 'package:xrandom/xrandom.dart';

import '../errors.dart';
import 'data_manager.dart';

class RankManager {
  Future<int> getRank(String userId, String guildId, String tag,
      {bool hasNitro = false}) async {
    final dm = DataManager();
    final canRank = await dm.canRank(guildId: guildId, userId: userId);
    if (canRank is DateTime) {
      throw CannotRankError(canRank);
    }

    final rank = await _requestRank(userId, guildId);
    if (rank == null) throw RankError();
    await Future.delayed(Duration.zero, () async {
      try {
        await dm.registerRank(
            userId: userId,
            guildId: guildId,
            rank: rank,
            tag: tag,
            hasNitro: hasNitro);
        await dm.incrementRankCounter(guildId: guildId);
      } catch (e) {
        Logger('RankManager')
          ..log(
              Level.SHOUT, 'Error during registerRank and incrementRankCounter')
          ..log(Level.SHOUT, e.toString());
      }
    });
    return rank;
  }

  Future<int?> _requestRank(String id, String guildId) async {
    try {
      final rankCounter = await DataManager().getRankCounter(guildId: guildId);
      return calculateRank(rankCounter: rankCounter);
    } catch (e) {
      Logger('RankManager').log(Level.SHOUT, e.toString());
      return null;
    }
  }

  Future<void> reduceRankTime(String userId, int guildId, {int? s}) {
    final seconds = s ?? Xrandom().nextInt(15);
    return DataManager()
        .reduceRankTime(userId, guildId, Duration(seconds: seconds));
  }

  ///  This method calculates a rank. The higher number has less chance.
  int calculateRank({required int rankCounter}) {
    final maxRank = 100 + rankCounter * 0.03.floor();
    final random = Random();
    int num = random
        .nextInt(maxRank + 1); // generate a random number between 0 and max
    double probability = 1 - (num / (maxRank * 2));
    //print("probability $probability");
    // calculate the probability of returning this number

    // adjust the probability of returning zero and 35
    if (num == 0) {
      probability /= 2; // reduce the probability of returning zero by half
    } else if (num > 35) {
      probability -= 0.6; // increase the probability of returning 35 by 5%
    }

    // apply the probability and return the number
    return (random.nextDouble() < probability)
        ? num
        : calculateRank(rankCounter: rankCounter);
  }


}
