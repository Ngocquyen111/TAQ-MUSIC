## Giới Thiệu

**TAQ Music** là ứng dụng di động nghe nhạc giúp người dùng thưởng thức âm nhạc mọi lúc, mọi nơi với trải nghiệm mượt mà và thân thiện.

Ứng dụng tích hợp các tính năng:
- Nghe nhạc trực tuyến trong ứng dụng
- Quản lý bài hát yêu thích
- Đăng nhập và lưu trữ dữ liệu người dùng
- Giao diện trực quan, dễ sử dụng

TAQ Music hướng tới trải nghiệm người dùng **đơn giản – nhanh chóng – hiện đại**, phù hợp với sinh viên và người yêu âm nhạc.

---

## Luồng Chạy Ứng Dụng TAQ Music

### 1. LOGIN – Đăng nhập

**Thành phần liên quan:**  
User → Login Screen → Firebase Service → User Store → Main Store  

**Luồng xử lý:**  
- Người dùng nhập email và password  
- Ứng dụng gọi hàm:
- Firebase Authentication xử lý đăng nhập  
- Trả về đối tượng `UserCredential`  
- Lưu thông tin người dùng vào User Store / Main Store  
- Điều hướng sang Home Screen  

---

### 2. HOME – Trang chủ

**Thành phần liên quan:**  
Home Screen → Artist Service  

**Luồng xử lý:**  
- Hiển thị trang chủ  
- Tải danh sách:
- Nghệ sĩ  
- Bài hát nổi bật  
- Người dùng chọn nghệ sĩ  
- Điều hướng sang trang chi tiết nghệ sĩ:

---

### 3. ARTIST DETAIL – Chi tiết nghệ sĩ

**Thành phần liên quan:**  
Artist Detail → Music Service  

**Luồng xử lý:**  
- Hiển thị thông tin nghệ sĩ  
- Hiển thị danh sách bài hát của nghệ sĩ  
- Người dùng chọn bài hát để phát  

---

### 4. PLAY MUSIC – Phát nhạc

**Luồng xử lý:**  
- Phát bài hát đã chọn  
- Hiển thị màn hình phát nhạc  
- Người dùng có thể điều khiển phát / tạm dừng / chuyển bài  

---

### 5. FAVORITE – Yêu thích

**Luồng xử lý:**  
- Người dùng thêm bài hát vào danh sách yêu thích  
- Lưu dữ liệu bài hát yêu thích theo tài khoản người dùng  
- Cập nhật danh sách yêu thích  

---

### 6. SETTINGS & LOGOUT – Cài đặt và đăng xuất

**Luồng xử lý:**  
- Người dùng mở màn hình cài đặt  
- Thực hiện đăng xuất  
- Xoá dữ liệu người dùng khỏi bộ nhớ  
- Điều hướng về màn hình đăng nhập  

---

## Các Tính Năng Chính

<p align="center">
<img width="392" height="801" src="https://github.com/user-attachments/assets/54b16130-efcc-47ab-a906-57c2d3a241f9" />
<img width="395" height="787" src="https://github.com/user-attachments/assets/66b74e28-d754-4ec3-a72b-a9469df8fdd9" />
</p>

### Nghe nhạc
- Phát nhạc trực tiếp trong ứng dụng  
- Hỗ trợ Play / Pause / Next / Previous  
- Thanh tiến trình bài hát (seek bar)  

### Bài hát yêu thích
- Lưu và quản lý danh sách bài hát yêu thích  
- Đồng bộ dữ liệu theo tài khoản người dùng  

### Thư viện nhạc
- Hiển thị danh sách bài hát  
- Phân loại theo album / playlist (có thể mở rộng)  

### Tài khoản người dùng
- Đăng nhập bằng Email  
- Đăng nhập bằng Google (Firebase Authentication)  

---

## Tech Stack

- **Frontend:** Flutter (Dart)  
- **Backend:** Firebase  
- **Database:** Cloud Firestore / Firebase Realtime Database  
- **Authentication:** Email / Google Sign-In  

---

## Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

<p align="center">
<img width="800" src="https://github.com/user-attachments/assets/a72f023d-c905-45cc-8c3c-174f2327fb62" />
</p>
