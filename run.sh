#!/bin/sh
set -e
cd "$(dirname "$0")"

JAR=lib/mysql-connector-j-9.3.0.jar
if [ ! -f "$JAR" ]; then
  mkdir -p lib
  echo "Downloading MySQL JDBC driver (one time)..."
  curl -fL -o "$JAR" https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.3.0/mysql-connector-j-9.3.0.jar
fi

mkdir -p out
javac -cp "lib/*" -d out src/*.java
exec java -cp "out:lib/*" Main
