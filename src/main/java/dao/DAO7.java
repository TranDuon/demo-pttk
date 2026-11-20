package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Gói dao. Mở một kết nối JDBC riêng cho mỗi truy vấn hoặc giao dịch. */
public class DAO7 {
    protected Connection openConnection() throws SQLException {
        String url = System.getProperty("cineman7.db.url",
                "jdbc:mysql://127.0.0.1:33367/cineman7?characterEncoding=UTF-8"
                + "&serverTimezone=Asia/Ho_Chi_Minh&connectTimeout=3000");
        String user = System.getProperty("cineman7.db.user", "cineman7");
        String password = System.getProperty("cineman7.db.password", "cineman7-local-demo");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException error) {
            throw new SQLException("Thiếu MySQL Connector/J", error);
        }
        return DriverManager.getConnection(url, user, password);
    }
}
