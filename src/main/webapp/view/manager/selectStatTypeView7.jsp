<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/requireManager7.jspf" %>
<%-- Gói view.manager. ELEMENT: chọn loại thống kê và nút quay lại. Bước 2–4. --%>
<% String pageTitle = "Chọn loại thống kê"; %>
<%@ include file="/WEB-INF/jspf/managerHeader7.jspf" %>
<main class="page">
  <section class="card compact">
    <h1>Chọn loại thống kê</h1>
    <div class="option-list">
      <a class="btn btn-primary btn-block" href="selectPeriodView7.jsp">Thống kê phim theo doanh thu</a>
      <button class="btn btn-secondary btn-block" type="button" disabled>Thống kê khách hàng</button>
      <button class="btn btn-secondary btn-block" type="button" disabled>Thống kê doanh thu</button>
    </div>
    <a class="btn btn-secondary" href="managerHomeView7.jsp">Quay lại</a>
  </section>
</main>
</body>
</html>
