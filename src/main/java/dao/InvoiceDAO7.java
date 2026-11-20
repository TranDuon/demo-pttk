package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Customer7;
import model.Invoice7;
import model.Seat7;
import model.Ticket7;

/** Gói dao. Cấp 3: gộp các vé theo từng hóa đơn của suất chiếu đã chọn. */
public class InvoiceDAO7 extends DAO7 {
    public ArrayList<Invoice7> getInvoicesOfShowtime(int idShowtime) throws SQLException {
        String sql = """
                SELECT i.id AS invoiceId, i.createdTime, i.customerId, u.fullName,
                       t.id AS ticketId, t.price, t.seatId, se.seatRow, se.seatNumber
                FROM tblTicket7 t
                JOIN tblInvoice7 i ON i.id = t.invoiceId
                JOIN tblSeat7 se ON se.id = t.seatId
                LEFT JOIN tblUser7 u ON u.id = i.customerId
                WHERE t.showtimeId = ?
                ORDER BY i.createdTime ASC, i.id ASC, t.id ASC
                """;
        ArrayList<Invoice7> invoices = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idShowtime);
            try (ResultSet rows = statement.executeQuery()) {
                Invoice7 current = null;
                while (rows.next()) {
                    int invoiceId = rows.getInt("invoiceId");
                    if (current == null || current.getId() != invoiceId) {
                        current = new Invoice7();
                        current.setId(invoiceId);
                        current.setCreatedTime(rows.getTimestamp("createdTime"));
                        int customerId = rows.getInt("customerId");
                        if (customerId != 0) {
                            Customer7 customer = new Customer7();
                            customer.setId(customerId);
                            customer.setFullName(rows.getString("fullName"));
                            current.setCustomer(customer);
                        }
                        invoices.add(current);
                    }
                    Seat7 seat = new Seat7();
                    seat.setId(rows.getInt("seatId"));
                    seat.setSeatRow(rows.getString("seatRow"));
                    seat.setSeatNumber(rows.getInt("seatNumber"));
                    Ticket7 ticket = new Ticket7();
                    ticket.setId(rows.getInt("ticketId"));
                    ticket.setPrice(rows.getDouble("price"));
                    ticket.setSeat(seat);
                    current.getTickets().add(ticket);
                    current.setTotalAmount(current.getTotalAmount() + ticket.getPrice());
                }
            }
        }
        return invoices;
    }
}
