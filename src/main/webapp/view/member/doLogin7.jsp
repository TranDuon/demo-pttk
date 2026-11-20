<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.sql.SQLException,dao.UserDAO7,model.User7,model.Manager7,view.Web7"%>
<%-- Gói view.member. XỬ LÝ SỰ KIỆN: xác thực và đặt thuộc tính session manager. --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (!"POST".equals(request.getMethod())) {
        response.sendRedirect("loginView7.jsp");
        return;
    }
    String username = Web7.text(request.getParameter("username"));
    String password = request.getParameter("password");
    User7 matched = null;
    String failure = "Sai tên đăng nhập hoặc mật khẩu";
    try {
        if (!username.isEmpty() && password != null && !password.isEmpty()) {
            matched = new UserDAO7().login(username, password);
        }
    } catch (SQLException error) {
        application.log("Không xác thực được tài khoản", error);
        failure = "Không truy cập được cơ sở dữ liệu. Vui lòng thử lại.";
    }
    if (matched == null) {
        request.setAttribute("username", username);
        request.setAttribute("message", failure);
        request.getRequestDispatcher("loginView7.jsp").forward(request, response);
        return;
    }
    session.invalidate();
    jakarta.servlet.http.HttpSession newSession = request.getSession(true);
    if (matched instanceof Manager7) {
        newSession.setAttribute("manager", matched);
        response.sendRedirect("../manager/managerHomeView7.jsp");
    } else {
        newSession.setAttribute("member", matched);
        response.sendRedirect("homeView7.jsp");
    }
%>
