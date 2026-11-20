package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import model.Room7;
import model.ShowtimeStat7;

/** Gói dao. Cấp 2: các suất chiếu của phim, kể cả suất chưa bán vé. */
public class ShowtimeStatDAO7 extends DAO7 {
    public ArrayList<ShowtimeStat7> getShowtimeRevenueStat(int idMovie, Date startDate, Date endDate)
            throws SQLException {
        String sql = """
                SELECT s.id, s.showDate, s.startTime, s.ticketPrice,
                       r.id AS roomId, r.name AS roomName,
                       COUNT(t.id) AS ticketCount, COALESCE(SUM(t.price), 0) AS revenue
                FROM tblShowtime7 s
                JOIN tblRoom7 r ON r.id = s.roomId
                LEFT JOIN tblTicket7 t ON t.showtimeId = s.id
                WHERE s.movieId = ? AND s.showDate BETWEEN ? AND ?
                GROUP BY s.id, s.showDate, s.startTime, s.ticketPrice, r.id, r.name
                ORDER BY revenue DESC, s.showDate ASC, s.startTime ASC, s.id ASC
                """;
        ArrayList<ShowtimeStat7> showtimes = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idMovie);
            statement.setDate(2, new java.sql.Date(startDate.getTime()));
            statement.setDate(3, new java.sql.Date(endDate.getTime()));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    Room7 room = new Room7();
                    room.setId(rows.getInt("roomId"));
                    room.setName(rows.getString("roomName"));
                    ShowtimeStat7 showtime = new ShowtimeStat7();
                    showtime.setId(rows.getInt("id"));
                    showtime.setShowDate(rows.getDate("showDate"));
                    showtime.setStartTime(rows.getTime("startTime"));
                    showtime.setTicketPrice(rows.getDouble("ticketPrice"));
                    showtime.setRoom(room);
                    showtime.setTicketCount(rows.getInt("ticketCount"));
                    showtime.setRevenue(rows.getDouble("revenue"));
                    showtimes.add(showtime);
                }
            }
        }
        return showtimes;
    }
}
