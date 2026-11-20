package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.Customer7;
import model.MembershipCard7;

/** Gói dao. Kiểm tra trùng và lưu tài khoản, khách hàng, thẻ trong một giao dịch. */
public class CustomerDAO7 extends DAO7 {
    public boolean checkExisted(String phoneNumber, String email) throws SQLException {
        String sql = """
                SELECT EXISTS(SELECT 1 FROM tblCustomer7 WHERE phoneNumber = ? OR email = ?)
                    OR EXISTS(SELECT 1 FROM tblUser7 WHERE username = ?)
                """;
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, phoneNumber);
            statement.setString(2, email);
            statement.setString(3, phoneNumber);
            try (ResultSet rows = statement.executeQuery()) {
                rows.next();
                return rows.getBoolean(1);
            }
        }
    }

    public boolean saveCustomer(Customer7 customer) throws SQLException {
        if (customer.getMembershipCard() == null) {
            return false;
        }
        try (Connection connection = openConnection()) {
            // [add] Giữ khóa đến lúc đóng kết nối để hai yêu cầu cùng lúc có mã thẻ khác nhau.
            try (PreparedStatement statement = connection.prepareStatement(
                    "SELECT GET_LOCK(CONCAT(DATABASE(), '.membership-card'), 5)");
                 ResultSet rows = statement.executeQuery()) {
                if (!rows.next() || rows.getInt(1) != 1) {
                    return false;
                }
            }
            connection.setAutoCommit(false);
            try {
                MembershipCard7 card = MembershipCardDAO7.nextCard(connection);
                int id = insertUser(connection, customer);
                String sql = """
                        INSERT INTO tblCustomer7
                          (userId, phoneNumber, email, dateOfBirth, cardCode, points, issueDate)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                        """;
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setInt(1, id);
                    statement.setString(2, customer.getPhoneNumber());
                    statement.setString(3, customer.getEmail());
                    statement.setDate(4, new Date(customer.getDateOfBirth().getTime()));
                    statement.setString(5, card.getCardCode());
                    statement.setInt(6, card.getPoints());
                    statement.setDate(7, new Date(card.getIssueDate().getTime()));
                    statement.executeUpdate();
                }
                connection.commit();
                customer.setId(id);
                card.setId(id);
                customer.setMembershipCard(card);
                return true;
            } catch (SQLException error) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    error.addSuppressed(rollbackError);
                }
                throw error;
            }
        }
    }

    private int insertUser(Connection connection, Customer7 customer) throws SQLException {
        String sql = "INSERT INTO tblUser7(username, password, fullName) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, customer.getUsername());
            statement.setString(2, customer.getPassword());
            statement.setString(3, customer.getFullName());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Không lấy được id tài khoản");
                }
                return keys.getInt(1);
            }
        }
    }
}
