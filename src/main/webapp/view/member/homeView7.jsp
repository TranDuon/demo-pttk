<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  Gói: view.member
  Trang homeView7.jsp - Giao diện trang chủ (Hình 1 - thiết kế tĩnh modul đăng kí thành viên).
  Biểu đồ lớp thiết kế: homeView7.jsp { -registerMembership : link }
  Kịch bản v3: bước 1 (khách hàng click đăng kí thành viên), bước 2 (gọi registerMembershipView7.jsp).
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CineMan - Trang chủ</title>
<link rel="stylesheet" href="../../css/cineman7.css">
</head>
<body>
  <div class="header">
    <div class="header-inner">
      <a class="brand" href="homeView7.jsp"><span class="brand-logo">&#127916;</span><span>Cine<span class="accent">Man</span></span></a>
      <span class="header-note">Hệ thống quản lí rạp chiếu phim</span>
    </div>
  </div>

  <div class="menu">
    <div class="menu-inner">
      <%-- ELEMENT: registerMembership : link --%>
      <%-- XỬ LÝ SỰ KIỆN: click link -> gọi trang registerMembershipView7.jsp (bước 1-2) --%>
      <a id="registerMembership" href="../customer/registerMembershipView7.jsp">Đăng kí thành viên</a>
      <a href="loginView7.jsp">Đăng nhập</a>
    </div>
  </div>

  <div class="page">
    <div class="hero">
      <h1>Chào mừng đến với rạp chiếu phim CineMan</h1>
      <p>Đăng kí tài khoản thành viên để nhận mã thẻ và tích điểm khi mua vé.</p>
      <a class="btn btn-primary" href="../customer/registerMembershipView7.jsp">Đăng kí thành viên</a>
    </div>
  </div>
</body>
</html>
