import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../hoze.dart';

class Postman {
  final ISlashCommandInteractionEvent _event;
  String? _message;
  bool _isEmbed;
  EmbedBuilder? _embed;
  Duration? _timeout;
  bool sent;
  static const EMBEDCOLOR = '#e7c97b';

  Postman(this._event, {String? message, bool isEmbed = true})
      : _isEmbed = isEmbed,
        _message = message,
        sent = false {
    if (_isEmbed) {
      _embed = EmbedBuilder();
    }
  }

  void switchToEmbed() {
    _isEmbed = true;
    _embed = EmbedBuilder();
  }

  void switchToPlain() {
    _isEmbed = false;
    _embed = null;
  }

  get isEmbed => _isEmbed;

  void setMessage(String message) => _message = message;

  void setColor(DiscordColor color) => _embed?.color = color;

  void setDefaultColor() =>
      _embed?.color = DiscordColor.fromHexString(EMBEDCOLOR);

  void setUrl(String url) => _embed?.url = url;

  void setImageUrl(String url) => _embed?.imageUrl = url;

  void setTitle(String title) => _embed?.title = title;

  void setDescription(String? description) => _embed?.description = description;

  void deleteDescription() => _embed?.description = null;

  Future<void> sendError(String error, {bool static = false}) {
    if (!isEmbed) _embed = EmbedBuilder();
    this
      ..setColor(DiscordColor.darkRed)
      ..setDescription(
          static ? 'An error occurred. 😢 Try again later.' : error)
      ..setTitle('ERROR');
    if (sent) {
      return editOriginal();
    }
    sent = true;

    return send();
  }

  void setTimeOut(Duration duration) => _timeout = duration;

  Future<void> send() {
    final timeout = _timeout;
    if (!_isEmbed) {
      if (timeout == null) {
        return _event.respond(MessageBuilder.content(_message.toString()));
      }
      return _event
          .respond(MessageBuilder.content(_message.toString()))
          .then((_) {
        Future.delayed(timeout, () => _event.deleteOriginalResponse());
      });
    } else {
      if (!isDescriptionSet()) setDescription(_message);
      if (timeout == null) {
        sent = true;
        return _event.respond(MessageBuilder.embed(_embed!));
      }
      sent = true;
      return _event.respond(MessageBuilder.embed(_embed!)).then((_) {
        Future.delayed(timeout, () => _event.deleteOriginalResponse());
      });
    }
  }

  Future<void> sendFollowUp({int times = 1}) async {
    final timeout = _timeout;
    final channel = await _event.interaction.channel.getOrDownload();
    if (!_isEmbed) {
      if (timeout == null) {
        channel.sendMessage(MessageBuilder.content(_message.toString()));
      }
      channel
          .sendMessage(MessageBuilder.content(_message.toString()))
          .then((_) {
        Future.delayed(timeout!, () => _.delete(auditReason: 'Timeout'));
      });
    } else {
      if (!isDescriptionSet()) setDescription(_message);
      if (timeout == null) {
        sent = true;
        channel.sendMessage(MessageBuilder.embed(_embed!));
      }
      sent = true;
      channel.sendMessage(MessageBuilder.embed(_embed!)).then((_) {
        Future.delayed(timeout!, () => _.delete(auditReason: 'Timeout'));
      });
    }
    if (times > 1) return sendFollowUp(times: times - 1);
  }

  Future<void> editOriginal() {
    final timeout = _timeout;
    if (!sent) return Future<void>.error(Error());
    if (!_isEmbed) {
      if (timeout == null) {
        return _event
            .getOriginalResponse()
            .then((_) => _.edit(MessageBuilder.content(_message.toString())));
      }
      return _event
          .getOriginalResponse()
          .then((_) => _.edit(MessageBuilder.content(_message.toString())))
          .then((_) {
        Future.delayed(timeout, () => _event.deleteOriginalResponse());
      });
    } else {
      if (!isDescriptionSet()) setDescription(_message);
      if (timeout == null) {
        sent = true;
        return _event
            .getOriginalResponse()
            .then((_) => _.edit(MessageBuilder.embed(_embed!)));
      }
      sent = true;
      return _event
          .getOriginalResponse()
          .then((_) => _.edit(MessageBuilder.embed(_embed!)))
          .then((_) {
        Future.delayed(timeout, () => _event.deleteOriginalResponse());
      });
    }
  }

  static Future<void> sendToChannel(
      {String? embeddedMessage,
      String? embeddedTitle,
      String? embeddedAuthorPicture,
      String? embeddedAuthorName,
      String? message,
      Snowflake? channelId,
      ITextChannel? channel}) async {
    if ((embeddedMessage == null && message == null) ||
        (channelId == null && channel == null)) {
      throw ArgumentError();
    }
    assert((embeddedMessage == null && message != null) ||
        (embeddedMessage != null && message == null));
    assert((channelId == null && channel != null) ||
        (channelId != null && channel == null));
    ITextChannel dstChannel;
    if (channel != null) {
      dstChannel = channel;
    } else {
      dstChannel = await Hoze.instance.fetchChannel(channelId!);
    }
    MessageBuilder builder;
    if (message != null) {
      builder = MessageBuilder.content(message);
    } else {
      builder = MessageBuilder.embed(EmbedBuilder(
          color: DiscordColor.fromHexString(EMBEDCOLOR),
          title: embeddedTitle,
          author: EmbedAuthorBuilder(
              name: embeddedAuthorName, iconUrl: embeddedAuthorPicture),
          description: embeddedMessage));
    }
    _sendToChannel(builder, dstChannel);
  }

  static Future<void> _sendToChannel(
      MessageBuilder builder, ITextChannel channel) {
    return channel.sendMessage(builder);
  }

  bool isDescriptionSet() => _embed?.description != null;
}
