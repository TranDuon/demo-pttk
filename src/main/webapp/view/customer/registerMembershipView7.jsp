<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.Map,model.Customer7,view.Web7"%>
<%!
    private String fieldError(Map<?, ?> errors, String key) {
        Object message = errors.get(key);
        return message == null ? "" : "<div class='field-error' role='alert'>"
                + Web7.html(message.toString()) + "</div>";
    }
%>
<%-- Gói view.customer. ELEMENT: biểu mẫu đăng kí. THUỘC TÍNH ẨN: customer và message của request. --%>
<%
    Customer7 customer = (Customer7) request.getAttribute("customer");
    String message = Web7.text((String) request.getAttribute("message"));
    String fullName = customer == null ? "" : customer.getFullName();
    String phone = customer == null ? "" : customer.getPhoneNumber();
    String email = customer == null ? "" : customer.getEmail();
    String dob = customer == null ? "" : Web7.text((String) request.getAttribute("dateOfBirth"));
    Object fieldErrors = request.getAttribute("fieldErrors");
    Map<?, ?> errors = fieldErrors instanceof Map<?, ?> ? (Map<?, ?>) fieldErrors : Map.of();
    String dupClass = message.startsWith("Số điện thoại/Email") ? " invalid" : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CineMan - Đăng kí thành viên</title>
<link rel="stylesheet" href="../../css/cineman7.css">
</head>
<body>
  <div class="header">
    <div class="header-inner">
      <a class="brand" href="../member/homeView7.jsp"><span class="brand-logo">&#127916;</span><span>Cine<span class="accent">Man</span></span></a>
      <span class="header-note">Hệ thống quản lí rạp chiếu phim</span>
    </div>
  </div>
  <div class="menu">
    <div class="menu-inner"><a class="active" href="registerMembershipView7.jsp">Đăng kí thành viên</a></div>
  </div>

  <div class="page">
    <div class="card">
      <h1>Đăng kí thành viên</h1>
      <p class="sub">Điền thông tin bên dưới để nhận thẻ thành viên CineMan. Các ô có dấu <span style="color:var(--accent)">*</span> là bắt buộc.</p>

      <%-- XỬ LÝ SỰ KIỆN: gửi form POST đến doRegisterMembership7.jsp để kiểm tra và lưu. --%>

      <form name="frmRegister" action="doRegisterMembership7.jsp" method="post" novalidate>
        <div class="field" id="fFullName">
          <label for="txtFullName">Họ và tên <span class="req">*</span></label>
          <%-- ELEMENT: txtFullName : text --%>
          <input type="text" name="fullName" id="txtFullName" value="<%= Web7.html(fullName) %>" placeholder="VD: Nguyễn Văn A" maxlength="100">
          <%= fieldError(errors, "fullName") %>
        </div>
        <div class="field<%= dupClass %>" id="fPhone">
          <label for="txtPhone">Số điện thoại <span class="req">*</span></label>
          <%-- ELEMENT: txtPhone : text (số điện thoại được dùng làm tên đăng nhập) --%>
          <input type="text" name="phoneNumber" id="txtPhone" value="<%= Web7.html(phone) %>" placeholder="VD: 0912345678" maxlength="10" inputmode="numeric">
          <%= fieldError(errors, "phoneNumber") %>
          <div class="hint">Dùng làm tên đăng nhập.</div>
        </div>
        <div class="field<%= dupClass %>" id="fEmail">
          <label for="txtEmail">Email <span class="req">*</span></label>
          <%-- ELEMENT: txtEmail : text --%>
          <input type="text" name="email" id="txtEmail" value="<%= Web7.html(email) %>" placeholder="VD: nguyenvana@gmail.com" maxlength="100">
          <%= fieldError(errors, "email") %>
        </div>
        <div class="field" id="fDateOfBirth">
          <label for="txtDateOfBirth">Ngày sinh <span class="req">*</span></label>
          <%-- ELEMENT: txtDateOfBirth : date --%>
          <input type="date" name="dateOfBirth" id="txtDateOfBirth" value="<%= Web7.html(dob) %>">
          <%= fieldError(errors, "dateOfBirth") %>
        </div>
        <div class="field" id="fPassword">
          <label for="txtPassword">Mật khẩu <span class="req">*</span></label>
          <%-- ELEMENT: txtPassword : password --%>
          <input type="password" name="password" id="txtPassword">
          <%= fieldError(errors, "password") %>
        </div>
        <div class="field" id="fConfirmPassword">
          <label for="txtConfirmPassword">Xác nhận mật khẩu <span class="req">*</span></label>
          <%-- ELEMENT: txtConfirmPassword : password --%>
          <input type="password" name="confirmPassword" id="txtConfirmPassword">
          <%= fieldError(errors, "confirmPassword") %>
        </div>

        <%-- ELEMENT: message : String - dòng thông báo lỗi màu đỏ phía trên nút Đăng kí (chỉ hiện khi có lỗi) --%>
        <div id="message" class="message<%= message.isEmpty() ? "" : " show" %>" role="alert"><%= Web7.html(message) %></div>

        <%-- ELEMENT: btnRegister : submit --%>
        <input type="submit" name="btnRegister" id="btnRegister" class="btn btn-primary btn-block" value="Đăng kí">
      </form>
      <div class="form-foot">Đã là thành viên? <a href="../member/loginView7.jsp">Đăng nhập</a></div>
    </div>
  </div>

</body>
</html>
