import 'package:logging/logging.dart';

import 'utils/hoze.dart';

void main(List<String> arguments) async {
  Logger.root.level = Level.INFO;
  Hoze().rise();
}
