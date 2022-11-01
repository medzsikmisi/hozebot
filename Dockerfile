FROM dart
# uncomment next line to ensure latest Dart and root CA bundle
#RUN apt -y update && apt -y upgrade
WORKDIR .
COPY pubspec.* .
RUN dart pub get
COPY . .
RUN dart pub get --offline
ENTRYPOINT sleep 2 && dart  ./bin/hozebot.dart