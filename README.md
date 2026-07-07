# KaushikOS — a backend-first portfolio

A portfolio that **is** an API. Visitors land in a terminal; every command they type
(`whoami`, `projects`, `sign`, ...) fires a real HTTP request to a Java + MySQL backend.
The frontend is deliberately just one thin client.

No Spring, no Tomcat, no build tool. Java's built-in `HttpServer` + JDBC.

## Run it

```sh
# 1. load the schema + seed data (once)
mysql -u root -p < db/schema.sql

# 2. start the server (downloads the JDBC driver on first run)
./run.sh
```

Open http://localhost:8080 — or skip the browser entirely:

```sh
curl localhost:8080/api/profile
curl localhost:8080/api/projects
curl -d 'name=You&message=hi from curl' localhost:8080/api/guestbook
```

DB credentials default to `root` / empty password; override with env vars:

```sh
DB_USER=root DB_PASS=secret ./run.sh
```

## Update your portfolio (no redeploy)

Content lives in MySQL, not in code:

```sql
INSERT INTO projects (name, description, stack, lesson)
VALUES ('My new thing', 'What it does', 'Java, MySQL', 'What I learned');
```

## Layout

```
src/Main.java        HTTP server, routing, JSON  (~150 lines)
src/Db.java          JDBC helpers                (~45 lines)
db/schema.sql        tables + seed data — EDIT the seeds, esp. the github URL
public/index.html    the terminal client
run.sh               compile + run
```
