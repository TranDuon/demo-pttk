<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/requireManager7.jspf" %>
<%-- Gói view.manager. ELEMENT: xem báo cáo. Bước 1 của kịch bản thống kê. --%>
<% String pageTitle = "Trang quản lí"; %>
<%@ include file="/WEB-INF/jspf/managerHeader7.jspf" %>
<main class="page">
  <section class="hero">
    <h1>Trang quản lí CineMan</h1>
    <p>Xin chào, <%= Web7.html(manager.getFullName()) %>.</p>
    <a class="btn btn-primary" href="selectStatTypeView7.jsp">Xem báo cáo</a>
  </section>
</main>
</body>
</html>
