class RankError extends Error {}
class CannotRankError extends Error{
  CannotRankError(this.nextRank);
  final DateTime nextRank;
}