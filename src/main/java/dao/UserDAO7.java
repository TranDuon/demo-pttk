package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HexFormat;
import model.Customer7;
import model.Manager7;
import model.User7;

/** Gói dao. Đăng nhập hỗ trợ hai luồng trong báo cáo. */
public class UserDAO7 extends DAO7 {
    public User7 login(String username, String password) throws SQLException {
        String sql = """
                SELECT u.id, u.username, u.fullName, m.userId AS managerId, c.userId AS customerId
                FROM tblUser7 u
                LEFT JOIN tblManager7 m ON m.userId = u.id
                LEFT JOIN tblCustomer7 c ON c.userId = u.id
                WHERE u.username = ? AND u.password = ?
                """;
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, hashPassword(password));
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    return null;
                }
                User7 user;
                if (rows.getInt("managerId") != 0) {
                    user = new Manager7();
                } else if (rows.getInt("customerId") != 0) {
                    user = new Customer7();
                } else {
                    return null;
                }
                user.setId(rows.getInt("id"));
                user.setUsername(rows.getString("username"));
                user.setFullName(rows.getString("fullName"));
                return user;
            }
        }
    }

    public static String hashPassword(String password) {
        try {
            byte[] bytes = MessageDigest.getInstance("SHA-256")
                    .digest(password.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(bytes);
        } catch (NoSuchAlgorithmException error) {
            throw new IllegalStateException("SHA-256 không khả dụng", error);
        }
    }
}
