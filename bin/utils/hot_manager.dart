import 'package:xrandom/xrandom.dart';

class HeadsOrTailsManager {
  HeadsOrTails _generateResult() {
    final resultPack = <HeadsOrTails>[];
    for (int i = 0; i < 15; i++) {
      final trueResult =
          Xrandom().nextBool() ? HeadsOrTails.tail : HeadsOrTails.head;
      final current = Xrandom().nextBool();
      if (current) {
        resultPack.add(trueResult);
      } else {
        resultPack.add(trueResult == HeadsOrTails.head
            ? HeadsOrTails.tail
            : HeadsOrTails.head);
      }
    }
    final heads =
        resultPack.where((element) => element == HeadsOrTails.head).length;
    if (heads > 7) return HeadsOrTails.head;
    return HeadsOrTails.tail;
  }

  bool play(HeadsOrTails usersChoice) {
    final hoze = _generateResult();
    return hoze == usersChoice;
  }
}

enum HeadsOrTails { head, tail }
