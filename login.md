# Báo Cáo Hệ Thống Authentication Và Authorization

# 1. Tổng Quan Hệ Thống

Hệ thống Authentication được xây dựng nhằm quản lý:
- Đăng ký tài khoản
- Đăng nhập
- Đăng xuất
- Quên mật khẩu
- Kiểm tra trạng thái đăng nhập
- Phân quyền người dùng

Hệ thống sử dụng:
- SwiftUI
- Supabase Authentication
- Supabase Database
- Combine Framework

Authentication được chia thành 2 thành phần chính:
- AuthService
- AuthManager

---

# 2. AuthService

## Mục Đích

AuthService chịu trách nhiệm xử lý toàn bộ logic giao tiếp với Supabase Authentication và Database.

Các chức năng chính:
- Register
- Login
- Logout
- Reset Password
- Fetch Role

Hệ thống sử dụng Singleton Pattern:

swift id="i0qkxz" static let shared = AuthService() 

Điều này giúp:
- Dùng chung một instance
- Quản lý authentication tập trung
- Dễ mở rộng hệ thống

---

# 3. ProfileInsert Model

## Mô Tả

Struct ProfileInsert được sử dụng để insert dữ liệu vào bảng profiles.

swift id="fh2b7m" struct ProfileInsert: Encodable 

## Thuộc Tính

| Thuộc tính | Chức năng |
|---|---|
| id | ID người dùng |
| username | Tên người dùng |
| role | Vai trò tài khoản |
| premium | Trạng thái Premium |
| is_banned | Trạng thái khóa tài khoản |
| avatar_url | Ảnh đại diện |

---

# 4. Register Function

## Mô Tả

Chức năng Register cho phép người dùng tạo tài khoản mới.

## Quy Trình Hoạt Động

### Bước 1 — Tạo Authentication Account

swift id="8cl4ka" client.auth.signUp(     email: email,     password: password ) 

Supabase tạo:
- Email
- Password
- Session
- User ID

---

### Bước 2 — Lấy User ID

swift id="2wb3kp" let userId = response.user.id 

ID này sẽ liên kết với bảng profiles.

---

### Bước 3 — Tạo Profile Data

swift id="1r8a5t" let data = ProfileInsert(...) 

Hệ thống tạo dữ liệu profile mặc định:
- premium = false
- is_banned = false
- avatar_url = nil

---

### Bước 4 — Insert Database

swift id="g1d4hv" .from("profiles") .insert(data) .execute() 

Dữ liệu được lưu vào bảng profiles.

---

# 5. Login Function

## Mô Tả

Chức năng Login xác thực email và password.

swift id="k2m0ax" client.auth.signIn(     email: email,     password: password ) 

## Chức Năng

- Kiểm tra thông tin tài khoản
- Tạo session đăng nhập
- Lưu trạng thái người dùng

## Kết Quả

Nếu thành công:
- User được xác thực
- Session được tạo
- Truy cập vào hệ thống

---

# 6. Logout Function

## Mô Tả

Logout xóa session hiện tại khỏi ứng dụng.

swift id="t4j9rn" client.auth.signOut() 

## Kết Quả

- Người dùng bị đăng xuất
- Session bị hủy
- Chuyển về màn hình login

---

# 7. Forgot Password Function

## Mô Tả

Cho phép người dùng khôi phục mật khẩu thông qua email.

swift id="p5v2dz" client.auth.resetPasswordForEmail(email) 

## Quy Trình

1. Người dùng nhập email
2. Supabase gửi email reset password
3. Người dùng mở email
4. Đặt mật khẩu mới

## Ý Nghĩa

Giúp:
- Tăng bảo mật
- Hỗ trợ recovery account
- Tránh mất tài khoản

---

# 8. Fetch Role Function

## Mô Tả

Sau khi login, hệ thống lấy role từ bảng profiles.

swift id="x7c9ql" .eq("id", value: userId) 

## Chức Năng

Hệ thống kiểm tra:
- admin
- artist
- premium
- user

để điều hướng giao diện phù hợp.

---

# 9. AuthManager

## Mục Đích

AuthManager quản lý:
- Trạng thái đăng nhập
- Session hiện tại
- User hiện tại
- Role hiện tại

Class sử dụng:

swift id="m8u3wa" ObservableObject 

để cập nhật giao diện theo thời gian thực.

---

# 10. Published Variables

## isAuthenticated

swift id="e4x1ov" @Published var isAuthenticated = false 

Kiểm tra user đã đăng nhập hay chưa.

---

## currentUser

swift id="v3f9ki" @Published var currentUser: Supabase.User? 

Lưu thông tin user hiện tại từ Supabase.

---

## role

swift id="j2q5nd" @Published var role: UserRole = .user 

Lưu role hiện tại của người dùng.

---

# 11. Computed Properties

## isAdmin

swift id="a6k8tp" role == .admin 

Kiểm tra user có phải admin.

---

## isArtist

swift id="u7n4xe" role == .artist 

Kiểm tra artist.

---

## isPremium

swift id="d1m0yr" role == .premium 

Kiểm tra premium user.

---

## isUser

swift id="z9b6lw" role == .user 

Kiểm tra user thường.

---

# 12. checkAuthStatus Function

## Mô Tả

Kiểm tra session hiện tại khi app khởi động.

swift id="h5p2ck" let session = try await client.auth.session 

## Chức Năng

Nếu có session:
- isAuthenticated = true
- currentUser được cập nhật

Nếu không có:
- Trở về login screen

---

# 13. signOut Function Trong AuthManager

## Mô Tả

Hàm signOut quản lý trạng thái giao diện sau khi logout.

## Chức Năng

Sau khi logout:
- Xóa session
- currentUser = nil
- isAuthenticated = false

## Ý Nghĩa

Giúp giao diện cập nhật realtime sau khi đăng xuất.

---

# 14. Phân Quyền Hệ Thống

Hệ thống hỗ trợ 4 role:

| Role | Chức năng |
|---|---|
| Admin | Quản trị hệ thống |
| Artist | Upload và quản lý bài hát |
| User | Người dùng thường |
| Premium | Người dùng trả phí |

---

# 15. Use Case Authentication

## Guest
- Register
- Login
- Forgot Password

## User
- Logout
- View Profile
- Play Music

## Admin
- Manage Users
- Ban User
- Manage Songs

## Artist
- Upload Song
- Edit Song
- Delete Song

## Premium
- Download Music
- No Ads
- High Quality Audio

---

# 16. Activity Diagram Flow

# Register Flow

Start
→ Nhập thông tin
→ Validate dữ liệu
→ Sign Up Supabase
→ Tạo Profile
→ Insert Database
→ Thành công
→ End

---

# Login Flow

Start
→ Nhập email/password
→ Authentication
→ Fetch Role
→ Điều hướng theo role
→ End

---

# Forgot Password Flow

Start
→ Nhập email
→ Gửi email reset
→ User mở email
→ Đặt mật khẩu mới
→ Thành công
→ End

---

# 17. Kiến Trúc Hệ Thống

## Authentication Layer
- Supabase Auth
- Session
- JWT

## Business Layer
- AuthService
- AuthManager

## Database Layer
- profiles table

---

# 18. Ưu Điểm Hệ Thống

- Authentication bảo mật
- Phân quyền rõ ràng
- Hỗ trợ nhiều role
- Quản lý realtime state
- Dễ mở rộng
- Tích hợp Supabase dễ dàng

---

# 19. Kết Luận

Hệ thống Authentication và Authorization đã được xây dựng đầy đủ với:
- Register
- Login
- Logout
- Forgot Password
- Session Management
- Role Management

Hệ thống đảm bảo:
- Tính bảo mật
- Quản lý người dùng hiệu quả
- Hỗ trợ Premium và Artist
- Dễ bảo trì và mở rộng trong tương lai.
