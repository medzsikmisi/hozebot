FROM dart
# uncomment next line to ensure latest Dart and root CA bundle
#RUN apt -y update && apt -y upgrade
WORKDIR .
COPY pubspec.* .
RUN dart pub get
COPY . .
RUN dart pub get --offline
ENTRYPOINT  dart  ./bin/hozebot.dart