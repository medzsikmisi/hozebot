import 'interaction_command.dart';

class SlapCommand extends InteractionCommand {
  SlapCommand()
      : super('slap', 'You can slap someone if you tag him', '@author slapped @target');
}
