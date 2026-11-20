<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/requireManager7.jspf" %>
<%@ page import="java.sql.Date,java.sql.SQLException,java.util.List,model.MovieStat7,dao.MovieStatDAO7" %>
<%-- Gói view.manager. ELEMENT: bảng cấp phim. THUỘC TÍNH ẨN: ngày và listMovieStat trong session. --%>
<%
    String startInput = request.getParameter("startDate");
    String endInput = request.getParameter("endDate");
    Date startDate;
    Date endDate;
    if (startInput == null && endInput == null) {
        startDate = (Date) session.getAttribute("startDate");
        endDate = (Date) session.getAttribute("endDate");
    } else {
        startDate = Web7.date(startInput);
        endDate = Web7.date(endInput);
    }
    String message = null;
    if (startDate == null || endDate == null) {
        message = "Vui lòng chọn đủ ngày bắt đầu, ngày kết thúc.";
    } else if (endDate.before(startDate)) {
        message = "Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu.";
    }
    if (message != null) {
        request.setAttribute("message", message);
        request.getRequestDispatcher("selectPeriodView7.jsp").forward(request, response);
        return;
    }

    List<MovieStat7> movies;
    try {
        movies = new MovieStatDAO7().getMovieRevenueStat(startDate, endDate);
    } catch (SQLException error) {
        application.log("Không đọc được thống kê phim", error);
        request.setAttribute("message", "Không đọc được thống kê. Vui lòng thử lại.");
        request.getRequestDispatcher("selectPeriodView7.jsp").forward(request, response);
        return;
    }
    if (!startDate.equals(session.getAttribute("startDate"))
            || !endDate.equals(session.getAttribute("endDate"))) {
        session.removeAttribute("movie");
        session.removeAttribute("listShowtimeStat");
    }
    session.setAttribute("startDate", startDate);
    session.setAttribute("endDate", endDate);
    session.setAttribute("listMovieStat", movies);

    int showtimeTotal = movies.stream().mapToInt(MovieStat7::getShowtimeCount).sum();
    int ticketTotal = movies.stream().mapToInt(MovieStat7::getTicketCount).sum();
    double revenueTotal = movies.stream().mapToDouble(MovieStat7::getTotalRevenue).sum();
    String pageTitle = "Thống kê phim theo doanh thu";
%>
<%@ include file="/WEB-INF/jspf/managerHeader7.jspf" %>
<main class="page">
  <section class="card report">
    <h1><%= pageTitle %></h1>
    <p class="sub">Từ <%= Web7.format(startDate, "dd/MM/yyyy") %> đến <%= Web7.format(endDate, "dd/MM/yyyy") %></p>
    <div class="table-wrap"><table>
      <thead><tr><th scope="col">TT</th><th scope="col">Tên phim</th><th scope="col" class="numeric">Số suất chiếu</th><th scope="col" class="numeric">Số vé</th><th scope="col" class="numeric">Doanh thu</th></tr></thead>
      <tbody>
      <% if (movies.isEmpty()) { %><tr><td colspan="5" class="empty">Không có dữ liệu</td></tr><% } %>
      <% int index = 0; for (MovieStat7 movie : movies) { %>
        <tr><td><%= ++index %></td>
          <td><a href="showtimeRevenueStatView7.jsp?idMovie=<%= movie.getId() %>"><%= Web7.html(movie.getTitle()) %></a></td>
          <td class="numeric"><%= Web7.number(movie.getShowtimeCount()) %></td>
          <td class="numeric"><%= Web7.number(movie.getTicketCount()) %></td>
          <td class="numeric"><%= Web7.number(movie.getTotalRevenue()) %></td></tr>
      <% } %>
      </tbody>
      <tfoot><tr><th scope="row" colspan="2">Tổng</th><td class="numeric"><%= Web7.number(showtimeTotal) %></td><td class="numeric"><%= Web7.number(ticketTotal) %></td><td class="numeric"><%= Web7.number(revenueTotal) %></td></tr></tfoot>
    </table></div>
    <a class="btn btn-secondary" href="selectPeriodView7.jsp">Quay lại</a>
  </section>
</main>
</body>
</html>
