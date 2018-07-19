FROM jenkinsxio/builder-base:0.0.419

ARG JAVA_RELEASE=10
ARG JAVA_VERSION=10.0.2
ARG JAVA_BUILD=13
ARG JAVA_PATH=19aef61b38124481863b1413dce1855f
ARG JAVA_HOME=/opt/java

ENV JAVA_HOME=$JAVA_HOME \
    PATH=$JAVA_HOME/bin:${PATH}

RUN cd "/opt" && \
    wget -O jdk.tar.gz \
        "https://download.java.net/java/GA/jdk${JAVA_RELEASE}/${JAVA_VERSION}/${JAVA_PATH}/${JAVA_BUILD}/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" && \
    tar -xzf jdk.tar.gz && \
    ln -s "jdk-${JAVA_VERSION}" "$JAVA_HOME" && \
    rm -f "$JAVA_HOME"/bin/jjs \
          "$JAVA_HOME"/bin/orbd \
          "$JAVA_HOME"/bin/pack200 \
          "$JAVA_HOME"/bin/policytool \
          "$JAVA_HOME"/bin/rmid \
          "$JAVA_HOME"/bin/rmiregistry \
          "$JAVA_HOME"/bin/servertool \
          "$JAVA_HOME"/bin/tnameserv \
          "$JAVA_HOME"/bin/unpack200 && \
    rm -rf jdk.tar.gz



CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.9

ARG GRADLE_DOWNLOAD_SHA256=e66e69dce8173dd2004b39ba93586a184628bc6c28461bc771d6835f7f9b0d28
RUN set -o errexit -o nounset \
	&& echo "Downloading Gradle" \
	&& wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mkdir -p /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

# ENV ANDROID_VERSION 4333796
# ENV ANDROID_HOME /opt/android-sdk-linux
# RUN wget https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_VERSION}.zip && \
#   unzip sdk-tools-linux-${ANDROID_VERSION}.zip -d android-sdk-linux && mv android-sdk-linux /opt/
# ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
# RUN yes | sdkmanager --licenses
# RUN sdkmanager "platform-tools"
# RUN yes | sdkmanager \
#     "platforms;android-28" \
#     "build-tools;28.0.0"
	
#	&& echo "Adding gradle user and group" \
#	&& addgroup -S -g 1000 gradle \
#	&& adduser -D -S -G gradle -u 1000 -s /bin/ash gradle \
#	&& mkdir /home/gradle/.gradle \
#	&& chown -R gradle:gradle /home/gradle \
#	\
#	&& echo "Symlinking root Gradle cache to gradle Gradle cache" \
#	&& ln -s /home/gradle/.gradle /root/.gradle

# Create Gradle volume
#USER gradle
#VOLUME "/home/gradle/.gradle"
#WORKDIR /home/gradle

#RUN set -o errexit -o nounset \
#	&& echo "Testing Gradle installation" \
#	&& gradle --version
