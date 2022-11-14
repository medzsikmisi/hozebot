import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../utils/postman.dart';

class ColorTestCommand extends SlashCommandBuilder {
  ColorTestCommand()
      : super('colortest', 'Displays the color.', [
    CommandOptionBuilder(CommandOptionType.string, 'hex',
        'paste the hex color')
  ]) {
    registerHandler((_) {
      _
          .respond(Postman.getEmbed('Color test',color: _.getArg('hex').value))
          ;
    });
  }
}
