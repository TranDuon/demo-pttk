<%--
  [add] Trang khởi động, không có trong thiết kế (chỉ phục vụ triển khai).
  Mở http://localhost:8080/CineMan7/ -> chuyển hướng sang trang chủ homeView7.jsp.
  Dùng sendRedirect (không dùng welcome-file trỏ thẳng homeView7.jsp) để URL trên trình duyệt
  là .../view/member/homeView7.jsp, nhờ đó các link tương đối ../customer/... trỏ đúng.
--%>
<% response.sendRedirect("view/member/homeView7.jsp"); %>
