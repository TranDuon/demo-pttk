package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Locale;
import model.Customer7;
import model.MembershipCard7;

/** Gói dao. Tạo thông tin thẻ trong bộ nhớ trước khi lưu khách hàng. */
public class MembershipCardDAO7 extends DAO7 {
    public MembershipCard7 createCard(Customer7 customer) throws SQLException {
        try (Connection connection = openConnection()) {
            return nextCard(connection);
        }
    }

    static MembershipCard7 nextCard(Connection connection) throws SQLException {
        String sql = """
                SELECT COALESCE(MAX(CAST(SUBSTRING(cardCode, 3) AS UNSIGNED)), 0)
                FROM tblCustomer7 WHERE cardCode REGEXP '^TV[0-9]{6}$'
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rows = statement.executeQuery()) {
            rows.next();
            int nextNumber = rows.getInt(1) + 1;
            if (nextNumber > 999999) {
                throw new SQLException("Đã sử dụng hết dải mã thẻ thành viên");
            }
            String code = String.format(Locale.ROOT, "TV%06d", nextNumber);
            return new MembershipCard7(0, code, 0, Date.valueOf(LocalDate.now()));
        }
    }
}
