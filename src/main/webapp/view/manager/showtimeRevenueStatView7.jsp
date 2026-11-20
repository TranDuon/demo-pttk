<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/requireManager7.jspf" %>
<%@ page import="java.sql.Date,java.sql.SQLException,java.util.List,model.MovieStat7,model.ShowtimeStat7,dao.ShowtimeStatDAO7" %>
<%-- Gói view.manager. ELEMENT: bảng cấp suất chiếu. THUỘC TÍNH ẨN: movie, listShowtimeStat và khoảng ngày. --%>
<%
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    List<?> listMovieStat = (List<?>) session.getAttribute("listMovieStat");
    String movieInput = request.getParameter("idMovie");
    MovieStat7 movie = null;
    if (listMovieStat != null) {
        if (movieInput == null) {
            movie = (MovieStat7) session.getAttribute("movie");
        } else {
            Integer movieId = Web7.id(movieInput);
            for (Object item : listMovieStat) {
                MovieStat7 candidate = (MovieStat7) item;
                if (movieId != null && candidate.getId() == movieId) {
                    movie = candidate;
                    break;
                }
            }
        }
    }
    if (movie == null || startDate == null || endDate == null) {
        response.sendRedirect("movieRevenueStatView7.jsp");
        return;
    }

    String message = "";
    List<ShowtimeStat7> showtimes = List.of();
    try {
        showtimes = new ShowtimeStatDAO7().getShowtimeRevenueStat(movie.getId(), startDate, endDate);
    } catch (SQLException error) {
        application.log("Không đọc được thống kê suất chiếu", error);
        message = "Không đọc được thống kê suất chiếu. Vui lòng thử lại.";
    }
    session.setAttribute("movie", movie);
    session.setAttribute("listShowtimeStat", showtimes);
    int ticketTotal = showtimes.stream().mapToInt(ShowtimeStat7::getTicketCount).sum();
    double revenueTotal = showtimes.stream().mapToDouble(ShowtimeStat7::getRevenue).sum();
    String pageTitle = "Thống kê suất chiếu theo doanh thu";
%>
<%@ include file="/WEB-INF/jspf/managerHeader7.jspf" %>
<main class="page">
  <section class="card report">
    <h1><%= pageTitle %></h1>
    <p class="sub"><b><%= Web7.html(movie.getTitle()) %></b> · Từ <%= Web7.format(startDate, "dd/MM/yyyy") %> đến <%= Web7.format(endDate, "dd/MM/yyyy") %></p>
    <% if (!message.isEmpty()) { %><div class="message show" role="alert"><%= Web7.html(message) %></div><% } else { %>
    <div class="table-wrap"><table>
      <thead><tr><th scope="col">TT</th><th scope="col">Ngày chiếu</th><th scope="col">Giờ</th><th scope="col">Phòng</th><th scope="col" class="numeric">Số vé</th><th scope="col" class="numeric">Doanh thu</th></tr></thead>
      <tbody>
      <% int index = 0; for (ShowtimeStat7 showtime : showtimes) { %>
        <tr><td><%= ++index %></td>
          <td><a href="invoiceListView7.jsp?idShowtime=<%= showtime.getId() %>"><%= Web7.format(showtime.getShowDate(), "dd/MM/yyyy") %></a></td>
          <td><%= Web7.format(showtime.getStartTime(), "HH:mm") %></td>
          <td><%= Web7.html(showtime.getRoom().getName()) %></td>
          <td class="numeric"><%= Web7.number(showtime.getTicketCount()) %></td>
          <td class="numeric"><%= Web7.number(showtime.getRevenue()) %></td></tr>
      <% } %>
      <% if (showtimes.isEmpty()) { %><tr><td colspan="6" class="empty">Không có dữ liệu</td></tr><% } %>
      </tbody>
      <tfoot><tr><th scope="row" colspan="4">Tổng</th><td class="numeric"><%= Web7.number(ticketTotal) %></td><td class="numeric"><%= Web7.number(revenueTotal) %></td></tr></tfoot>
    </table></div><% } %>
    <a class="btn btn-secondary" href="movieRevenueStatView7.jsp">Quay lại</a>
  </section>
</main>
</body>
</html>
