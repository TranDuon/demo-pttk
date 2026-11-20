<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="view.Web7"%>
<%-- Gói view.member. ELEMENT: ô tên đăng nhập, mật khẩu và nút đăng nhập. --%>
<%
    String username = request.getAttribute("username") == null
            ? Web7.text(request.getParameter("username")) : (String) request.getAttribute("username");
    String message = Web7.text((String) request.getAttribute("message"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CineMan - Đăng nhập</title>
<link rel="stylesheet" href="../../css/cineman7.css">
</head>
<body>
<div class="header"><div class="header-inner">
  <a class="brand" href="homeView7.jsp"><span class="brand-logo">&#127916;</span><span>Cine<span class="accent">Man</span></span></a>
  <span class="header-note">Hệ thống quản lí rạp chiếu phim</span>
</div></div>
<main class="page">
  <div class="card compact">
    <h1>Đăng nhập</h1>
    <p class="sub">Thành viên dùng số điện thoại đã đăng kí.</p>
    <form action="doLogin7.jsp" method="post">
      <div class="field"><label for="username">Tên đăng nhập</label>
        <input id="username" name="username" value="<%= Web7.html(username) %>" autocomplete="username" required></div>
      <div class="field"><label for="password">Mật khẩu</label>
        <input id="password" name="password" type="password" autocomplete="current-password" required></div>
      <% if (!message.isEmpty()) { %><div class="message show" role="alert"><%= Web7.html(message) %></div><% } %>
      <button type="submit" class="btn btn-primary btn-block">Đăng nhập</button>
    </form>
    <div class="form-foot"><a href="../customer/registerMembershipView7.jsp">Đăng kí thành viên</a></div>
  </div>
</main>
</body>
</html>
