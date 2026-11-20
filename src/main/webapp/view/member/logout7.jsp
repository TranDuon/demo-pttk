<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Gói view.member. Xóa phiên đăng nhập khi người dùng nhấn Đăng xuất. --%>
<%
    if ("POST".equals(request.getMethod())) {
        session.invalidate();
    }
    response.sendRedirect("loginView7.jsp");
%>
