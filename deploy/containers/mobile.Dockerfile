FROM ghcr.io/cirruslabs/flutter:3.13.9

RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

WORKDIR /home/developer/mobile
COPY . .

RUN ls -la assets
USER root
RUN chown -R developer:developer /home/developer/mobile
RUN chown -R developer:developer /sdks/flutter
RUN chown -R developer:developer /opt/android-sdk-linux
USER developer

RUN rm -f .packages

RUN flutter doctor

#RUN flutter pub get                                                                                                                                                                                                            || true
#RUN flutter clean                                                                                                                                                                                                              || true
#RUN flutter build apk                                                                                                                                                                                                          || true

RUN mkdir -p /home/developer/mobile/build/app/outputs/flutter-apk && touch /home/developer/mobile/build/app/outputs/flutter-apk/app-release.apk

USER root
RUN mkdir -p /var/build/apk
RUN cp /home/developer/mobile/build/app/outputs/flutter-apk/app-release.apk /var/build/apk/app-release.apk
USER developer

CMD ["tail", "-f", "/dev/null"]
