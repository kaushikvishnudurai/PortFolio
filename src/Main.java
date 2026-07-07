import com.sun.net.httpserver.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(Db.env("PORT", "8080"));
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/", Main::route);
        server.start();
        System.out.println("KaushikOS serving on http://localhost:" + port);
    }

    static void route(HttpExchange ex) throws IOException {
        String path = ex.getRequestURI().getPath();
        String method = ex.getRequestMethod();
        try {
            switch (path) {
                case "/" -> {
                    try { Db.update("INSERT INTO visits (path) VALUES (?)", "/"); }
                    catch (Exception ignored) {} // ponytail: page still loads if DB is down
                    byte[] html = Files.readAllBytes(Path.of("public/index.html"));
                    send(ex, 200, "text/html; charset=utf-8", html);
                }
                case "/api/profile"  -> json(ex, 200, first(Db.query("SELECT * FROM profile WHERE id = 1")));
                case "/api/skills"   -> json(ex, 200, Db.query("SELECT name, category FROM skills ORDER BY category, id"));
                case "/api/projects" -> json(ex, 200, Db.query("SELECT name, period, description, stack, lesson FROM projects ORDER BY id"));
                case "/api/journey"  -> json(ex, 200, Db.query("SELECT label, title, detail FROM journey ORDER BY sort_order"));
                case "/api/stats"    -> json(ex, 200, first(Db.query(
                        "SELECT (SELECT COUNT(*) FROM visits) AS visits, (SELECT COUNT(*) FROM guestbook) AS signatures")));
                case "/api/guestbook" -> {
                    if (method.equals("POST")) signGuestbook(ex);
                    else json(ex, 200, Db.query("SELECT name, message, DATE_FORMAT(created_at, '%d %b %Y') AS date FROM guestbook ORDER BY id DESC LIMIT 20"));
                }
                default -> json(ex, 404, Map.of("error", "no such endpoint: " + path));
            }
        } catch (Exception e) {
            e.printStackTrace();
            // TEMP diagnostics for Render deploy debugging — revert to plain message once fixed
            String driver;
            try { driver = Class.forName("com.mysql.cj.jdbc.Driver").getProtectionDomain().getCodeSource().getLocation().toString(); }
            catch (Throwable t) { driver = "LOAD FAILED: " + t; }
            String lib;
            try { lib = java.util.Arrays.toString(new java.io.File("lib").listFiles()); }
            catch (Throwable t) { lib = "ls failed: " + t; }
            json(ex, 500, Map.of(
                "error", String.valueOf(e),
                "classpath", System.getProperty("java.class.path"),
                "driver", driver,
                "lib", lib,
                "cwd", System.getProperty("user.dir")));
        }
    }

    static void signGuestbook(HttpExchange ex) throws Exception {
        Map<String, String> form = parseForm(new String(ex.getRequestBody().readAllBytes(), StandardCharsets.UTF_8));
        String name = form.getOrDefault("name", "").trim();
        String message = form.getOrDefault("message", "").trim();
        if (name.isEmpty() || message.isEmpty() || name.length() > 60 || message.length() > 280) {
            json(ex, 400, Map.of("error", "name (1-60 chars) and message (1-280 chars) required"));
            return;
        }
        Db.update("INSERT INTO guestbook (name, message) VALUES (?, ?)", name, message);
        json(ex, 201, Map.of("ok", true));
    }

    static Map<String, String> parseForm(String body) {
        Map<String, String> m = new HashMap<>();
        for (String pair : body.split("&")) {
            int eq = pair.indexOf('=');
            if (eq > 0) m.put(URLDecoder.decode(pair.substring(0, eq), StandardCharsets.UTF_8),
                              URLDecoder.decode(pair.substring(eq + 1), StandardCharsets.UTF_8));
        }
        return m;
    }

    // ---- JSON (stdlib has none; this is the whole serializer) ----

    static String toJson(Object o) {
        if (o == null) return "null";
        if (o instanceof Number || o instanceof Boolean) return o.toString();
        if (o instanceof Map<?, ?> m) {
            StringJoiner sj = new StringJoiner(",", "{", "}");
            m.forEach((k, v) -> sj.add("\"" + esc(String.valueOf(k)) + "\":" + toJson(v)));
            return sj.toString();
        }
        if (o instanceof List<?> l) {
            StringJoiner sj = new StringJoiner(",", "[", "]");
            l.forEach(v -> sj.add(toJson(v)));
            return sj.toString();
        }
        return "\"" + esc(o.toString()) + "\"";
    }

    static String esc(String s) {
        StringBuilder b = new StringBuilder();
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"'  -> b.append("\\\"");
                case '\\' -> b.append("\\\\");
                case '\n' -> b.append("\\n");
                case '\r' -> b.append("\\r");
                case '\t' -> b.append("\\t");
                default   -> { if (c < 0x20) b.append(String.format("\\u%04x", (int) c)); else b.append(c); }
            }
        }
        return b.toString();
    }

    static Object first(List<Map<String, Object>> rows) {
        return rows.isEmpty() ? Map.of("error", "no data — did you load db/schema.sql?") : rows.get(0);
    }

    static void json(HttpExchange ex, int status, Object body) throws IOException {
        send(ex, status, "application/json; charset=utf-8", toJson(body).getBytes(StandardCharsets.UTF_8));
    }

    static void send(HttpExchange ex, int status, String contentType, byte[] body) throws IOException {
        ex.getResponseHeaders().set("Content-Type", contentType);
        ex.sendResponseHeaders(status, body.length);
        try (OutputStream os = ex.getResponseBody()) { os.write(body); }
    }
}
