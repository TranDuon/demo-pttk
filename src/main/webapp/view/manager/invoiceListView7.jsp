<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/requireManager7.jspf" %>
<%@ page import="java.sql.SQLException,java.util.List,model.Invoice7,model.MovieStat7,model.ShowtimeStat7,dao.InvoiceDAO7" %>
<%-- Gói view.manager. ELEMENT: bảng cấp hóa đơn. Lấy ngữ cảnh từ film và suất chiếu trong session. --%>
<%
    Integer showtimeId = Web7.id(request.getParameter("idShowtime"));
    MovieStat7 movie = (MovieStat7) session.getAttribute("movie");
    List<?> listShowtimeStat = (List<?>) session.getAttribute("listShowtimeStat");
    ShowtimeStat7 showtime = null;
    if (showtimeId != null && listShowtimeStat != null) {
        for (Object item : listShowtimeStat) {
            ShowtimeStat7 candidate = (ShowtimeStat7) item;
            if (candidate.getId() == showtimeId) {
                showtime = candidate;
                break;
            }
        }
    }
    if (showtime == null || movie == null) {
        response.sendRedirect("showtimeRevenueStatView7.jsp");
        return;
    }
    String message = "";
    List<Invoice7> invoices = List.of();
    try {
        invoices = new InvoiceDAO7().getInvoicesOfShowtime(showtime.getId());
    } catch (SQLException error) {
        application.log("Không đọc được danh sách hóa đơn", error);
        message = "Không đọc được danh sách hóa đơn. Vui lòng thử lại.";
    }
    int ticketTotal = invoices.stream().mapToInt(invoice -> invoice.getTickets().size()).sum();
    double invoiceTotal = invoices.stream().mapToDouble(Invoice7::getTotalAmount).sum();
    String pageTitle = "Danh sách hóa đơn";
%>
<%@ include file="/WEB-INF/jspf/managerHeader7.jspf" %>
<main class="page">
  <section class="card report">
    <h1><%= pageTitle %></h1>
    <p class="sub"><b><%= Web7.html(movie.getTitle()) %></b> · <%= Web7.format(showtime.getShowDate(), "dd/MM/yyyy") %> <%= Web7.format(showtime.getStartTime(), "HH:mm") %> · Phòng <%= Web7.html(showtime.getRoom().getName()) %> · Giá vé <%= Web7.number(showtime.getTicketPrice()) %></p>
    <% if (!message.isEmpty()) { %><div class="message show" role="alert"><%= Web7.html(message) %></div><% } else { %>
    <div class="table-wrap"><table>
      <thead><tr><th scope="col">TT</th><th scope="col">Mã hóa đơn</th><th scope="col">Khách hàng</th><th scope="col" class="numeric">Số vé</th><th scope="col" class="numeric">Tổng tiền</th><th scope="col">Thời điểm lập</th></tr></thead>
      <tbody>
      <% if (invoices.isEmpty()) { %><tr><td colspan="6" class="empty">Chưa có hóa đơn</td></tr><% } %>
      <% int index = 0; for (Invoice7 invoice : invoices) { %>
        <tr><td><%= ++index %></td><td><%= invoice.getId() %></td>
          <td><%= invoice.getCustomer() == null ? "Khách vãng lai" : Web7.html(invoice.getCustomer().getFullName()) %></td>
          <td class="numeric"><%= Web7.number(invoice.getTickets().size()) %></td>
          <td class="numeric"><%= Web7.number(invoice.getTotalAmount()) %></td>
          <td><%= Web7.format(invoice.getCreatedTime(), "HH:mm dd/MM/yyyy") %></td></tr>
      <% } %>
      </tbody>
      <tfoot><tr><th scope="row" colspan="3">Tổng</th><td class="numeric"><%= Web7.number(ticketTotal) %></td><td class="numeric"><%= Web7.number(invoiceTotal) %></td><td></td></tr></tfoot>
    </table></div><% } %>
    <a class="btn btn-secondary" href="showtimeRevenueStatView7.jsp?idMovie=<%= movie.getId() %>">Quay lại</a>
  </section>
</main>
</body>
</html>
