# ICTU — Hệ thống quản lý sinh viên (Đề 2)

## Chức năng
- Màn hình đăng nhập, đăng xuất và bảo vệ các trang nghiệp vụ bằng session.
- CRUD sinh viên, lớp học, điểm số; tìm kiếm danh sách sinh viên.
- MySQL lưu dữ liệu; phpMyAdmin để quản trị CSDL.
- Nginx reverse proxy + security headers.
- Docker Compose; Prometheus/cAdvisor + Nginx exporter + MySQL exporter; Grafana; Loki/Promtail và truy vấn LogQL.
- Một số hardening: app chạy non-root, read-only root filesystem, tách mạng, không public cổng MySQL, công cụ quản trị bind loopback.

## Khởi chạy (Windows PowerShell)
1. Cài Docker Desktop và mở Docker Desktop, chờ trạng thái Running.
2. Giải nén ZIP, mở PowerShell trong thư mục chứa `docker-compose.yml`.
3. Tạo `.env`, sửa mọi mật khẩu placeholder trước khi chạy. Đặt `MYSQL_EXPORTER_PASSWORD` trong `.env` giống hệt mật khẩu trong `mysql/init/02-monitoring-user.sql`:
   ```powershell
   Copy-Item .env.example .env
   notepad .env
   ```
4. Kiểm tra cấu hình và chạy:
   ```powershell
   docker compose config
   docker compose --profile tools up -d --build
   docker compose ps
   ```
5. Truy cập:
   - Website: http://localhost:8080
   - phpMyAdmin: http://localhost:8081
   - Prometheus: http://localhost:9090
   - Grafana: http://localhost:3000
   - Loki readiness: http://localhost:3100/ready

## Đăng nhập demo
Email và mật khẩu được lấy từ `DEMO_ADMIN_EMAIL` và `DEMO_ADMIN_PASSWORD` trong `.env`. Giá trị mẫu là `admin@ICTU.local` / `ChangeMe@12345`; hãy đổi trước khi chạy. Tài khoản demo đầu tiên được tạo tự động trong bảng `users` bằng `password_hash()`. Đổi biến môi trường sau lần khởi chạy đầu không tự động đổi mật khẩu đã lưu trong DB.

## LogQL mẫu (Grafana → Explore → Loki)
```logql
{container=~".*nginx.*"}
```
```logql
{container=~".*app.*"} |= "Database"
```
```logql
{service="nginx"} |~ " 4[0-9][0-9] "
```
Trước lần chạy đầu, thay placeholder của exporter trong `mysql/init/02-monitoring-user.sql` bằng đúng giá trị `MYSQL_EXPORTER_PASSWORD` trong `.env`. Cú pháp nhãn/kết quả cần được xác minh sau khi stack chạy thực tế. Promtail cần đọc Docker socket; đây là quyền nhạy cảm, chỉ dùng trong lab.

## Lưu ý an toàn và minh chứng
- Không commit `.env` lên GitHub. Dùng mật khẩu mạnh, khác nhau cho MySQL, tài khoản demo và Grafana.
- MySQL không publish cổng ra máy host. phpMyAdmin, Prometheus, Grafana, Loki chỉ bind vào loopback.
- Docker socket được mount read-only nhưng vẫn nhạy cảm; không dùng cấu hình lab này nguyên trạng cho production.
- Các file cấu hình chưa phải bằng chứng hệ thống đã chạy thành công. Hãy tự kiểm tra `docker compose ps`, thao tác CRUD, Targets, datasource Grafana, truy vấn LogQL và headers Nginx rồi chụp ảnh thật cho báo cáo.
- `docker compose down` dừng dịch vụ nhưng giữ volume. Tránh `docker compose down -v` nếu muốn giữ dữ liệu.
