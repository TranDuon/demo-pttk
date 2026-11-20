package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import model.MovieStat7;

/** Gói dao. Cấp 1: tổng số suất chiếu, số vé và doanh thu theo phim. */
public class MovieStatDAO7 extends DAO7 {
    public ArrayList<MovieStat7> getMovieRevenueStat(Date startDate, Date endDate) throws SQLException {
        String sql = """
                SELECT m.id, m.title, m.genre, m.duration, m.director, m.description,
                       COUNT(DISTINCT s.id) AS showtimeCount, COUNT(t.id) AS ticketCount,
                       COALESCE(SUM(t.price), 0) AS totalRevenue
                FROM tblMovie7 m
                JOIN tblShowtime7 s ON s.movieId = m.id
                LEFT JOIN tblTicket7 t ON t.showtimeId = s.id
                WHERE s.showDate BETWEEN ? AND ?
                GROUP BY m.id, m.title, m.genre, m.duration, m.director, m.description
                ORDER BY totalRevenue DESC, m.title ASC
                """;
        ArrayList<MovieStat7> movies = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setDate(1, new java.sql.Date(startDate.getTime()));
            statement.setDate(2, new java.sql.Date(endDate.getTime()));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    MovieStat7 movie = new MovieStat7();
                    movie.setId(rows.getInt("id"));
                    movie.setTitle(rows.getString("title"));
                    movie.setGenre(rows.getString("genre"));
                    movie.setDuration(rows.getInt("duration"));
                    movie.setDirector(rows.getString("director"));
                    movie.setDescription(rows.getString("description"));
                    movie.setShowtimeCount(rows.getInt("showtimeCount"));
                    movie.setTicketCount(rows.getInt("ticketCount"));
                    movie.setTotalRevenue(rows.getDouble("totalRevenue"));
                    movies.add(movie);
                }
            }
        }
        return movies;
    }
}
