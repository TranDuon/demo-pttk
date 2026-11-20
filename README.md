# CineMan7

Bản demo Java/JSP gồm đăng ký thành viên và báo cáo doanh thu theo phim, suất chiếu, hóa đơn.

## Chạy demo trên Windows

Cần JDK 17 trở lên trong `PATH`, Tomcat 10.1 và MySQL Server. Bản này đã chạy với JDK 24.0.2, Tomcat 10.1.55 và MySQL 9.4.

1. Giải nén ZIP và mở PowerShell trong thư mục `CineMan7`.
2. Chạy:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Run-Demo.ps1
   ```

   Nếu công cụ cài ở đường dẫn khác, truyền thư mục gốc của hai bộ cài.

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Run-Demo.ps1 -TomcatHome "D:\tools\apache-tomcat-10.1.55" -MysqlHome "C:\MySQL\MySQL Server 9.4"
   ```

3. Mở <http://127.0.0.1:18087/CineMan7/>.

Script dùng WAR trong `target/CineMan7.war` nếu đã đóng gói kèm. Cơ sở dữ liệu demo lưu riêng trong `.demo`, chạy trên cổng `33367` và được nạp dữ liệu ở lần đầu. Web và MySQL của bản demo đều lắng nghe trên loopback. Dữ liệu đăng ký được giữ khi khởi động lại.

## Thử hai luồng

- **Đăng ký.** Từ trang chủ, chọn **Đăng kí thành viên**. Nhập Nguyễn Văn A, số `0912345678`, email `nguyenvana@gmail.com`, ngày sinh `15/03/2000`, mật khẩu và xác nhận `123456`. Trên dữ liệu mới, kết quả là thẻ `TV000125`. Nút **Xác nhận** mở đăng nhập và điền sẵn số điện thoại. Thử số `0987654321` để thấy thông báo trùng.
- **Doanh thu.** Đăng nhập bằng tài khoản mẫu `quanli01` / `123456`. Chọn **Xem báo cáo** → **Thống kê phim theo doanh thu** → ngày `01/09/2026` đến `30/09/2026`. Dòng tổng là 39 suất, 1.450 vé và 130.500.000. Chọn **Phim A**, sau đó chọn suất ngày **05/09/2026, 19:00, P1** để xem 12 hóa đơn, tổng 45 vé và 4.050.000.

## Dừng hoặc dựng lại WAR

```powershell
powershell -ExecutionPolicy Bypass -File .\Run-Demo.ps1 -Stop
powershell -ExecutionPolicy Bypass -File .\Build-Demo.ps1
```

Khởi động lại bằng `Run-Demo.ps1` sau khi dựng WAR. Để thử lại từ dữ liệu đầu, dừng phiên cũ và giải nén ZIP vào một thư mục mới.

Mã Java nằm dưới `src/main/java`, JSP và CSS nằm dưới `src/main/webapp`. Bộ dữ liệu của báo cáo là `database/seed_cineman7.sql`.
