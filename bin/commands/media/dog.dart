import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_interactions/src/events/interaction_event.dart';

import '../../utils/postman.dart';
import '../command.dart';

class DogCommand extends DiscordCommand {

  DogCommand()
      : super('dog', 'You can get pictures of dogs.',[]) {
    options=[CommandOptionBuilder(CommandOptionType.string, 'type',
        'You can specify the exact type of dog that you want the picture of. Default is any.',choices: List.generate(dogTypes.length, (_) => ArgChoiceBuilder(dogTypes[_],dogTypes[_])))];
    registerHandler(handle);
  }

  @override
  handle(ISlashCommandInteractionEvent e) {
    if(e.args.isEmpty){
      e.respond(Postman.getEmbed('Args is empty.'));
    }else {
      e.respond(Postman.getEmbed('Args is NOT empty.'));
    }
  }

  final dogTypes = ['affenpinscher',
    'african',
    'airedale',
    'akita',
    'appenzeller',
    'shepherd australian',
    'basenji',
    'beagle',
    'bluetick',
    'borzoi',
    'bouvier',
    'boxer',
    'brabancon',
    'briard',
    'norwegian buhund',
    'boston bulldog',
    'english bulldog',
    'french bulldog',
    'staffordshire bullterrier',
    'australian cattledog',
    'chihuahua',
    'chow',
    'clumber',
    'cockapoo',
    'border collie',
    'coonhound',
    'cardigan corgi',
    'cotondetulear',
    'dachshund',
    'dalmatian',
    'great dane',
    'scottish deerhound',
    'dhole',
    'dingo',
    'doberman',
    'norwegian elkhound',
    'entlebucher',
    'eskimo',
    'lapphund finnish',
    'bichon frise',
    'germanshepherd',
    'italian greyhound',
    'groenendael',
    'havanese',
    'afghan hound',
    'basset hound',
    'blood hound',
    'english hound',
    'ibizan hound',
    'plott hound',
    'walker hound',
    'husky',
    'keeshond',
    'kelpie',
    'komondor',
    'kuvasz',
    'labradoodle',
    'labrador',
    'leonberg',
    'lhasa',
    'malamute',
    'malinois',
    'maltese',
    'bull mastiff',
    'english mastiff',
    'tibetan mastiff',
    'mexicanhairless',
    'mix',
    'bernese mountain',
    'swiss mountain',
    'newfoundland',
    'otterhound',
    'caucasian ovcharka',
    'papillon',
    'pekinese',
    'pembroke',
    'miniature pinscher',
    'pitbull',
    'german pointer',
    'germanlonghair pointer',
    'pomeranian',
    'medium poodle',
    'miniature poodle',
    'standard poodle',
    'toy poodle',
    'pug',
    'puggle',
    'pyrenees',
    'redbone',
    'chesapeake retriever',
    'curly retriever',
    'flatcoated retriever',
    'golden retriever',
    'rhodesian ridgeback',
    'rottweiler',
    'saluki',
    'samoyed',
    'schipperke',
    'giant schnauzer',
    'miniature schnauzer',
    'italian segugio',
    'english setter',
    'gordon setter',
    'irish setter',
    'sharpei',
    'english sheepdog',
    'shetland sheepdog',
    'shiba',
    'shihtzu',
    'blenheim spaniel',
    'brittany spaniel',
    'cocker spaniel',
    'irish spaniel',
    'japanese spaniel',
    'sussex spaniel',
    'welsh spaniel',
    'japanese spitz',
    'english springer',
    'stbernard',
    'american terrier',
    'australian terrier',
    'bedlington terrier',
    'border terrier',
    'cairn terrier',
    'dandie terrier',
    'fox terrier',
    'irish terrier',
    'kerryblue terrier',
    'lakeland terrier',
    'norfolk terrier',
    'norwich terrier',
    'patterdale terrier',
    'russell terrier',
    'scottish terrier',
    'sealyham terrier',
    'silky terrier',
    'tibetan terrier',
    'toy terrier',
    'welsh terrier',
    'westhighland terrier',
    'wheaten terrier',
    'yorkshire terrier',
    'tervuren',
    'vizsla',
    'spanish waterdog',
    'weimaraner',
    'whippet',
    'irish wolfhound'];
}
