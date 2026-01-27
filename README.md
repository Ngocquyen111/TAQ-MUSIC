## Giới Thiệu

**TAQ Music** là ứng dụng di động nghe nhạc giúp người dùng thưởng thức âm nhạc mọi lúc, mọi nơi với trải nghiệm mượt mà và thân thiện.

Ứng dụng tích hợp các tính năng hỗ trợ:
- Nghe nhạc trực tuyến trong ứng dụng
- Quản lý bài hát yêu thích
- Đăng nhập và lưu dữ liệu người dùng
- Giao diện trực quan, dễ sử dụng

TAQ Music hướng tới trải nghiệm người dùng **đơn giản – nhanh chóng – hiện đại**, phù hợp với sinh viên và người yêu âm nhạc.

---
LUỒNG CHẠY ỨNG DỤNG TAQ MUSIC
1.LOGIN – Đăng nhập
-Thành phần liên quan:
User → Login Screen → Firebase Service → User Store → Main Store
-Luồng xử lý:
+Người dùng nhập email + password
+App gọi hàm: " signIn(email, password) "
-Firebase Authentication xử lý đăng nhập
-Trả về UserCredential
-Lưu thông tin người dùng vào User Store / Main Store
-Điều hướng sang Home Screen
2.HOME – Trang chủ
-Thành phần liên quan:
Home Screen → Artist Service
-Luồng xử lý:
+Hiển thị trang chủ 
+Tải danh sách:
~Nghệ sĩ
~Bài hát nổi bật
+Người dùng chọn Artist
+App điều hướng: " Navigator.push(ArtistDetail) "
3.ARTIST DETAIL – Chi tiết nghệ sĩ
-Thành phần liên quan: 
Artist Detail → Music Service
-Luồng xử lý:
+Hiển thị thông tin nghệ sĩ
+Hiển thị danh sách bài hát của nghệ sĩ
4.PLAY MUSIC – Phát nhạc
5.FAVORITE – Yêu thích
6.SETTINGS & LOGOUT – Cài đặt & Đăng xuất
---

## Các Tính Năng Chính


<img width="392" height="801" alt="image" src="https://github.com/user-attachments/assets/54b16130-efcc-47ab-a906-57c2d3a241f9" />

<img width="395" height="787" alt="image" src="https://github.com/user-attachments/assets/66b74e28-d754-4ec3-a72b-a9469df8fdd9" />


###  Nghe nhạc
 Phát nhạc trực tiếp trong ứng dụng  
 Hỗ trợ Play / Pause / Next / Previous  
 Thanh tiến trình bài hát (seek bar)

###  Bài hát yêu thích
 Lưu và quản lý danh sách bài hát yêu thích  
 Đồng bộ dữ liệu theo tài khoản người dùng

###  Thư viện nhạc
 Hiển thị danh sách bài hát  
 Phân loại theo album / playlist *(có thể mở rộng)*

###  Tài khoản người dùng
 Đăng nhập bằng Email  
 Đăng nhập bằng Google (Firebase Authentication)

---

##  Tech Stack

- **Frontend:** Flutter (Dart)  
- **Backend:** Firebase  
- **Database:** Cloud Firestore / Firebase Realtime Database  
- **Authentication:** Email / Google Sign-In  

---

##  Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

<img width="1000" height="1000" alt="image" src="https://github.com/user-attachments/assets/a72f023d-c905-45cc-8c3c-174f2327fb62" />
