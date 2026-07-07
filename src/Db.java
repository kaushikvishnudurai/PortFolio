import java.sql.*;
import java.util.*;

class Db {
    // ponytail: connection per request, no pool — fine for portfolio traffic, add HikariCP if it ever isn't
    static final String URL  = env("DB_URL",  "jdbc:mysql://localhost:3306/kaushik_portfolio");
    static final String USER = env("DB_USER", "root");
    static final String PASS = env("DB_PASS", "");

    static String env(String key, String def) {
        String v = System.getenv(key);
        if (v != null) v = v.split("\\R", 2)[0].trim(); // pasted junk after line 1 = "No suitable driver found"
        return (v == null || v.isEmpty()) ? def : v;
    }

    static {
        // register the driver explicitly; if the jar is missing/corrupt this prints the real reason
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (Throwable t) {
            System.err.println("JDBC driver load failed: " + t);
            System.err.println("java.class.path=" + System.getProperty("java.class.path"));
            try (var s = java.nio.file.Files.list(java.nio.file.Path.of("lib"))) {
                s.forEach(p -> System.err.println("lib contains: " + p));
            } catch (Exception e) { System.err.println("cannot list lib/: " + e); }
        }
    }

    static Connection open() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    static List<Map<String, Object>> query(String sql, Object... params) throws SQLException {
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                List<Map<String, Object>> rows = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= md.getColumnCount(); i++)
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    rows.add(row);
                }
                return rows;
            }
        }
    }

    static int update(String sql, Object... params) throws SQLException {
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            return ps.executeUpdate();
        }
    }
}
