<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/requireManager7.jspf" %>
<%-- Gói view.manager. ELEMENT: hai trường ngày, nút xem thống kê. Bước 4–6. --%>
<%
    String pageTitle = "Chọn khoảng thời gian";
    String message = Web7.text((String) request.getAttribute("message"));
    Object savedStart = session.getAttribute("startDate");
    Object savedEnd = session.getAttribute("endDate");
    String startValue = request.getParameter("startDate");
    String endValue = request.getParameter("endDate");
    if (startValue == null && savedStart != null) {
        startValue = savedStart.toString();
    }
    if (endValue == null && savedEnd != null) {
        endValue = savedEnd.toString();
    }
%>
<%@ include file="/WEB-INF/jspf/managerHeader7.jspf" %>
<main class="page">
  <section class="card">
    <h1>Thống kê phim theo doanh thu</h1>
    <p class="sub">Chọn khoảng thời gian theo ngày chiếu.</p>
    <form action="movieRevenueStatView7.jsp" method="get" novalidate>
      <div class="date-grid">
        <div class="field"><label for="startDate">Từ ngày</label>
          <input id="startDate" name="startDate" type="date" value="<%= Web7.html(startValue) %>"></div>
        <div class="field"><label for="endDate">Đến ngày</label>
          <input id="endDate" name="endDate" type="date" value="<%= Web7.html(endValue) %>"></div>
      </div>
      <% if (!message.isEmpty()) { %><div class="message show" role="alert"><%= Web7.html(message) %></div><% } %>
      <div class="actions">
        <button type="submit" class="btn btn-primary">Xem thống kê</button>
        <a class="btn btn-secondary" href="selectStatTypeView7.jsp">Quay lại</a>
      </div>
    </form>
  </section>
</main>
</body>
</html>
