<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.time.LocalDate,java.sql.Date,java.sql.SQLException,java.util.LinkedHashMap,model.Customer7,model.MembershipCard7,dao.CustomerDAO7,dao.MembershipCardDAO7,dao.UserDAO7,view.Web7"%>
<%-- Gói view.customer. XỬ LÝ SỰ KIỆN: kiểm tra, tạo thẻ và lưu tài khoản theo mục 4.3. --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (!"POST".equals(request.getMethod())) {
        response.sendRedirect("registerMembershipView7.jsp");
        return;
    }

    Customer7 customer = new Customer7();
    customer.setFullName(Web7.text(request.getParameter("fullName")));
    customer.setPhoneNumber(Web7.text(request.getParameter("phoneNumber")));
    customer.setUsername(customer.getPhoneNumber());
    customer.setEmail(Web7.text(request.getParameter("email")));
    String birthInput = Web7.text(request.getParameter("dateOfBirth"));
    Date birth = Web7.date(birthInput);
    customer.setDateOfBirth(birth);
    String password = request.getParameter("password");
    String confirmation = request.getParameter("confirmPassword");

    LinkedHashMap<String, String> errors = new LinkedHashMap<>();
    if (customer.getFullName().isEmpty()) {
        errors.put("fullName", "Vui lòng nhập họ và tên.");
    } else if (customer.getFullName().length() > 100) {
        errors.put("fullName", "Họ và tên tối đa 100 kí tự.");
    }
    if (!customer.getPhoneNumber().matches("0[0-9]{9}")) {
        errors.put("phoneNumber", "Số điện thoại gồm 10 chữ số, bắt đầu bằng 0.");
    }
    if (customer.getEmail().length() > 100
            || !customer.getEmail().matches("[^\\s@]+@[^\\s@]+\\.[^\\s@]+")) {
        errors.put("email", "Email không đúng định dạng.");
    }
    if (birth == null) {
        errors.put("dateOfBirth", "Vui lòng nhập ngày sinh hợp lệ.");
    } else if (!birth.toLocalDate().isBefore(LocalDate.now())) {
        errors.put("dateOfBirth", "Ngày sinh phải trước ngày hiện tại.");
    }
    if (password == null || password.length() < 6) {
        errors.put("password", "Mật khẩu tối thiểu 6 kí tự.");
    }
    if (confirmation == null || !confirmation.equals(password)) {
        errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
    }

    String failure = String.join(" ", errors.values());
    if (errors.isEmpty()) {
        CustomerDAO7 dao = new CustomerDAO7();
        try {
            if (dao.checkExisted(customer.getPhoneNumber(), customer.getEmail())) {
                failure = "Số điện thoại/Email đã được đăng kí.";
            } else {
                customer.setPassword(UserDAO7.hashPassword(password));
                customer.setMembershipCard(new MembershipCardDAO7().createCard(customer));
                if (!dao.saveCustomer(customer)) {
                    failure = "Đăng kí không thành công, vui lòng thử lại.";
                }
            }
        } catch (SQLException error) {
            application.log("Không lưu được đăng kí thành viên", error);
            failure = error.getErrorCode() == 1062
                    ? "Số điện thoại/Email đã được đăng kí."
                    : "Đăng kí không thành công, vui lòng thử lại.";
        } finally {
            customer.setPassword(null);
        }
    }
    if (!failure.isEmpty()) {
        request.setAttribute("customer", customer);
        request.setAttribute("dateOfBirth", birthInput);
        request.setAttribute("message", errors.isEmpty() ? failure : "");
        request.setAttribute("fieldErrors", errors);
        request.getRequestDispatcher("registerMembershipView7.jsp").forward(request, response);
        return;
    }
    MembershipCard7 card = customer.getMembershipCard();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CineMan - Đăng kí thành công</title>
<link rel="stylesheet" href="../../css/cineman7.css">
</head>
<body>
<div class="header"><div class="header-inner">
  <a class="brand" href="../member/homeView7.jsp"><span class="brand-logo">&#127916;</span><span>Cine<span class="accent">Man</span></span></a>
  <span class="header-note">Hệ thống quản lí rạp chiếu phim</span>
</div></div>
<div class="page">
  <%-- ELEMENT: hộp thoại xác nhận và mã thẻ vừa cấp. --%>
  <section class="dialog confirmation" aria-labelledby="dlgTitle">
    <div class="dialog-title">Thông báo</div>
    <div class="dialog-body">
      <div class="dialog-icon ok">&#10003;</div>
      <h1 id="dlgTitle">Đăng kí thành công</h1>
      <p>Chào mừng <b><%= Web7.html(customer.getFullName()) %></b> trở thành thành viên CineMan.</p>
      <p>Mã thẻ thành viên</p>
      <div class="card-code"><%= Web7.html(card.getCardCode()) %></div>
    </div>
    <div class="dialog-foot">
      <a id="btnConfirm" class="btn btn-primary btn-block" href="../member/loginView7.jsp?username=<%= Web7.html(customer.getUsername()) %>">Xác nhận</a>
    </div>
  </section>
</div>
</body>
</html>
