# CNJ02 – Công cụ và môi trường sử dụng

## 1. Mục đích
Tài liệu này giải thích ngắn gọn các công cụ cần có để mở, sửa, chạy và kiểm tra hệ thống CNJ02.

## 2. Công nghệ chính

| Công cụ / công nghệ | Vai trò |
|---|---|
| Java 21 | Ngôn ngữ và môi trường chạy ứng dụng |
| Spring Boot 3.2.5 | Xây dựng backend, Controller, Service và kết nối web |
| Thymeleaf | Hiển thị giao diện HTML theo từng vai trò |
| HTML/CSS/JavaScript | Giao diện và tương tác |
| JavaFX 21 + WebView | Đóng gói giao diện web thành cửa sổ Desktop |
| SwingWorker | Khởi động backend ở luồng nền, tránh treo cửa sổ lúc mở |
| MySQL | Lưu trữ dữ liệu nghiệp vụ |
| JDBC / JdbcTemplate | Truy vấn dữ liệu trực tiếp từ MySQL ở các nghiệp vụ thống kê/xử lý đặc thù |
| Spring Data JPA | Tầng truy cập dữ liệu cho các entity/repository phù hợp |
| Maven | Quản lý thư viện và build project |
| MySQL Workbench | Tạo CSDL, chạy file `DATABASE/CNJ02_CSDL.sql`, kiểm tra dữ liệu |
| VS Code | IDE có thể dùng để mở và chỉnh sửa toàn bộ source |

## 3. Cấu trúc chính

- `src/main/java`: Java theo các tầng Presentation / Business / Data Access.
- `src/main/resources/templates`: giao diện Thymeleaf theo `ADMIN`, `STAFF`, `USER`.
- `src/main/resources/static`: CSS và tài nguyên tĩnh.
- `DATABASE/CNJ02_CSDL.sql`: **file SQL duy nhất** để tạo CSDL và dữ liệu chuẩn.
- `RUN_CNJ02.bat`: **file chạy duy nhất**.
- `pom.xml`: cấu hình Maven.

## 4. Dữ liệu chuẩn

File SQL tạo database `CNJ02_QuanLyHoSoXetTuyen` và bộ dữ liệu demo gồm:

- 1.000 sinh viên mẫu.
- 200 hồ sơ tuyển sinh 2026 với mã hồ sơ `HS1` đến `HS200`.
- 5 khoa và 12 ngành.
- Dữ liệu nguyện vọng, điểm xét tuyển, minh chứng, kết quả.
- Chức năng nhập học và thống kê tỷ lệ nhập học.

## 5. Cài CSDL

1. Mở MySQL Workbench.
2. Mở duy nhất file `DATABASE/CNJ02_CSDL.sql`.
3. Execute toàn bộ file.
4. Kiểm tra cuối script: số hồ sơ 2026 phải là 200 và ID nhỏ nhất/lớn nhất phải là 1/200.

> Nếu đang có database cũ bị lẫn `HS1024`, hãy sao lưu dữ liệu cần giữ trước khi chạy file SQL này vì script tạo lại database từ đầu.

## 6. Tài khoản demo

- `admin / 123456` – quản trị hệ thống.
- `canbo / 123456` – cán bộ xét tuyển và xử lý nhập học.
- `Maihoa / 123456` – sinh viên.

## 7. Chạy ứng dụng

Đặt MySQL đang hoạt động và cấu hình đúng tài khoản trong `src/main/resources/application.properties`.

Sau đó chạy **duy nhất**:

```bat
RUN_CNJ02.bat
```

File này tự build nếu chưa có JAR rồi khởi động Desktop CNJ02.

## 8. Phân quyền

- **Sinh viên:** khai báo hồ sơ, nguyện vọng, minh chứng, xem kết quả và gửi xác nhận nhập học.
- **Cán bộ:** tiếp nhận/xử lý hồ sơ, xử lý nhập học, xem danh sách sinh viên đã nhập học và theo dõi tỷ lệ nhập học.
- **Admin:** chỉ quản trị và xem số liệu tổng hợp; **không xử lý nghiệp vụ nhập học**.
