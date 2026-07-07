FROM eclipse-temurin:21-jdk
WORKDIR /app

# ADD from a URL saves as 600/root — unreadable if the host runs the container non-root
ADD --chmod=644 https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.3.0/mysql-connector-j-9.3.0.jar lib/mysql-connector-j.jar
COPY src src
COPY public public
RUN javac -cp "lib/*" -d out src/*.java

EXPOSE 8080
CMD ["java", "-cp", "out:lib/*", "Main"]
