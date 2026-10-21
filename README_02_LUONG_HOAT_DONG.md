# CNJ02 – Luồng hoạt động và logic nghiệp vụ

## 1. Nhìn tổng thể

Hệ thống đi theo luồng:

**Đăng nhập → Xác định vai trò → Thực hiện nghiệp vụ → Ghi MySQL → Đọc lại MySQL → Cập nhật giao diện/thống kê**

Dữ liệu không được nhập riêng ở giao diện rồi giữ độc lập. Các trang cùng đọc dữ liệu từ MySQL để tránh lệch số liệu.

## 2. Luồng của sinh viên

### Bước 1 – Đăng nhập
Sinh viên đăng nhập bằng tài khoản của mình. Hệ thống xác định `role_id` là sinh viên và chỉ cho truy cập nhóm chức năng USER.

### Bước 2 – Hồ sơ xét tuyển
Sinh viên khai báo/cập nhật thông tin cá nhân và hồ sơ. Khi nộp hồ sơ, hệ thống tạo bản ghi trong `HoSo` và liên kết với `SinhVien`.

### Bước 3 – Nguyện vọng
Sinh viên chọn ngành theo thứ tự NV1, NV2, NV3. Mỗi nguyện vọng liên kết hồ sơ với ngành trong bảng `NguyenVong`.

### Bước 4 – Minh chứng và điểm
Minh chứng được lưu trong `MinhChung`; điểm xét tuyển được lưu trong `DiemXetTuyen`.

### Bước 5 – Xét tuyển
Sau khi hồ sơ được cán bộ xử lý, hệ thống có `KetQua`. Nếu trạng thái là `TRUNG_TUYEN`, sinh viên có thể xem kết quả và phiếu trúng tuyển.

### Bước 6 – Nhập học
Sinh viên trúng tuyển mở **Nhập học**, điền đầy đủ thông tin được yêu cầu và bấm **Xác nhận nhập học**.

Hệ thống cập nhật `NhapHoc.trang_thai = CHO_CAN_BO_XU_LY` và lưu thời điểm `ngay_xac_nhan`.

## 3. Luồng của cán bộ

### Bước 1 – Xem hồ sơ
Cán bộ xem danh sách hồ sơ và xử lý nghiệp vụ xét tuyển.

### Bước 2 – Xử lý kết quả
Cán bộ kiểm tra hồ sơ, điểm, nguyện vọng và trạng thái. Kết quả cuối cùng được ghi vào `KetQua`.

### Bước 3 – Tiếp nhận nhập học
Cán bộ mở menu **Nhập học**. Hệ thống hiển thị các sinh viên đã trúng tuyển và trạng thái hiện tại.

### Bước 4 – Kiểm tra xác nhận
Nếu sinh viên chưa gửi xác nhận, cán bộ không được ghi nhận `DA_NHAP_HOC`.

Nếu sinh viên đã gửi, trạng thái là `CHO_CAN_BO_XU_LY` và cán bộ có thể tiếp tục kiểm tra.

### Bước 5 – Bố trí nhập học
Cán bộ nhập/cập nhật:

- Cơ sở.
- Địa điểm/phòng.
- Địa chỉ.
- Ngày nhập học.
- Khung giờ.
- Ghi chú nếu cần.

### Bước 6 – Ghi nhận kết quả

- Đủ điều kiện: chuyển `DA_NHAP_HOC`.
- Không đủ điều kiện: chuyển `TU_CHOI` và ghi lý do.

Khi xử lý, hệ thống ghi `ngay_xu_ly`, `nguoi_xu_ly` và ghi nhật ký vào `HoSoLog`.

### Bước 7 – Danh sách đã nhập học
Ngay trên trang cán bộ có mục **Danh sách sinh viên đã nhập học**. Danh sách này chỉ lấy những bản ghi `NhapHoc.trang_thai = DA_NHAP_HOC`.

Thông tin hiển thị gồm hồ sơ, sinh viên, ngành/khoa, địa điểm, ngày nhập học và ngày cán bộ xử lý.

## 4. Luồng của Admin

Admin có quyền quản trị hệ thống và xem số liệu tổng hợp.

Admin **không có nghiệp vụ xử lý nhập học**.

Admin có thể theo dõi:

- Tổng số trúng tuyển.
- Số đã nhập học.
- Số chờ xử lý.
- Số từ chối.
- Tỷ lệ nhập học.
- Thống kê theo khoa/ngành/năm.

Các số liệu này được tính lại từ MySQL, không phải số cố định trong HTML.

## 5. Cách tính tỷ lệ nhập học

**Tỷ lệ nhập học = Số sinh viên đã được cán bộ ghi nhận `DA_NHAP_HOC` / Tổng số sinh viên trúng tuyển × 100%**

Vì tử số và mẫu số đều lấy từ MySQL nên khi cán bộ xử lý thêm một hồ sơ, tỷ lệ ở trang cán bộ và trang Admin được cập nhật theo dữ liệu mới.

## 6. Luồng dữ liệu hai chiều

```text
Sinh viên / Cán bộ
        ↓
Giao diện Thymeleaf
        ↓
Controller
        ↓
Service / Repository / JdbcTemplate
        ↓
MySQL
        ↓
Truy vấn lại dữ liệu
        ↓
Dashboard / Danh sách / Thống kê
```

Ví dụ nhập học:

```text
Sinh viên gửi xác nhận
        ↓
NhapHoc = CHO_CAN_BO_XU_LY
        ↓
Cán bộ kiểm tra
        ↓
Cán bộ xác nhận ĐÃ NHẬP HỌC
        ↓
NhapHoc = DA_NHAP_HOC
        ↓
Ghi HoSoLog
        ↓
Tính lại tỷ lệ nhập học
        ↓
Cán bộ + Admin thấy số liệu mới
```

## 7. Quy tắc quan trọng

1. Chỉ hồ sơ `TRUNG_TUYEN` mới có luồng nhập học.
2. Sinh viên phải gửi xác nhận trước khi cán bộ ghi nhận `DA_NHAP_HOC`.
3. Chỉ cán bộ được xử lý trạng thái nhập học.
4. Admin chỉ quản trị/xem tổng hợp, không xử lý nhập học.
5. Trạng thái và thống kê được lấy từ MySQL.
6. Hồ sơ 2026 trong bộ dữ liệu chuẩn có ID `1–200`, không dùng ID hiển thị kiểu `1024` để thay thế thứ tự hồ sơ.
7. Nhật ký xử lý được lưu để có thể kiểm tra lịch sử thao tác.


## Luồng nhập học sau khi cán bộ xác nhận

1. Sinh viên trúng tuyển mở chức năng **Nhập học** và điền đầy đủ thông tin.
2. Sinh viên bấm **Xác nhận nhập học**. Dữ liệu được ghi vào bảng `NhapHoc` với trạng thái `CHO_CAN_BO_XU_LY`.
3. Cán bộ mở **Nhập học**, kiểm tra hồ sơ và bổ sung cơ sở, địa điểm, ngày, khung giờ nếu cần.
4. Cán bộ chọn **Đã nhập học** và bấm **Lưu xử lý**. Hệ thống ghi `DA_NHAP_HOC`, thời gian xử lý và người xử lý.
5. Sau khi lưu thành công, hệ thống chuyển cán bộ tới **Danh sách sinh viên đã nhập học**. Trang này đọc trực tiếp từ MySQL và hiển thị họ tên, CCCD, liên hệ, ngành, khoa, cơ sở, địa điểm, ngày nhập học và ngày xử lý.
6. Tỷ lệ nhập học được tính lại từ số sinh viên `DA_NHAP_HOC` chia cho tổng số sinh viên `TRUNG_TUYEN`.
7. Admin chỉ xem số liệu tổng hợp; Admin không có quyền xử lý hồ sơ nhập học.

### Vì sao danh sách đã nhập học là một trang riêng?

Trang xử lý chỉ tập trung vào hồ sơ đang cần cán bộ thao tác. Danh sách đã nhập học được tách riêng để cán bộ có thể mở lại nhanh, xem toàn bộ thông tin mà không phải cuộn qua bảng xử lý dài. Cách này cũng giảm số lượng phần tử phải render trên trang xử lý và giúp giao diện nhẹ hơn.

###
