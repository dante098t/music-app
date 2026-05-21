# Phân Tích Hệ Thống Authentication Và Phân Quyền Người Dùng
doan_nhom6/doan_nhom6/Views/Auth 
# 1. Tổng Quan Hệ Thống

Hệ thống được xây dựng cho ứng dụng nghe nhạc trực tuyến với mục tiêu:

- Quản lý tài khoản người dùng
- Xác thực đăng nhập
- Phân quyền theo vai trò
- Kiểm soát quyền truy cập chức năng
- Hỗ trợ Premium và Artist

Hệ thống sử dụng:
- SwiftUI (Frontend)
- Supabase Authentication
- Supabase Database

---

# 2. Các Vai Trò Trong Hệ Thống

Hệ thống gồm 4 role chính:

| Role | Mô Tả |
|---|---|
| Admin | Quản trị toàn bộ hệ thống |
| Artist | Nghệ sĩ đăng tải bài hát |
| User | Người dùng bình thường |
| Premium | Người dùng trả phí |

---

# 3. Chức Năng Theo Từng Role

# 3.1 Admin

## Quyền hạn
- Quản lý người dùng
- Khóa tài khoản
- Xóa tài khoản
- Duyệt bài hát
- Xóa bài hát vi phạm
- Quản lý nghệ sĩ
- Xem báo cáo hệ thống
- Quản lý nội dung explicit
- Quản lý premium

## Use Case của Admin
- Login
- Logout
- Quản lý user
- Quản lý artist
- Quản lý bài hát
- Quản lý album
- Xem report
- Ban user
- Duyệt bài hát

---

# 3.2 Artist

## Quyền hạn
- Upload bài hát
- Upload ảnh bài hát
- Tạo album
- Chỉnh sửa bài hát
- Xóa bài hát
- Theo dõi lượt nghe
- Quản lý profile nghệ sĩ

## Use Case của Artist
- Login
- Upload song
- Edit song
- Delete song
- Create album
- View analytics

---

# 3.3 User Thường

## Quyền hạn
- Đăng ký
- Đăng nhập
- Nghe nhạc
- Tìm kiếm bài hát
- Like bài hát
- Tạo playlist
- Follow artist

## Giới Hạn
- Có quảng cáo
- Không nghe chất lượng cao
- Không tải nhạc offline

## Use Case của User
- Register
- Login
- Search music
- Play music
- Add favorite
- Create playlist

---

# 3.4 Premium User

## Quyền hạn
Bao gồm toàn bộ quyền của User thường và thêm:

- Không quảng cáo
- Chất lượng âm thanh cao
- Download offline
- Unlimited skip
- Background play

## Use Case của Premium
- Upgrade premium
- Download song
- High quality streaming
- Background listening

---

# 4. Phân Tích Authentication System

# 4.1 Register Flow

## Mô Tả
Người dùng tạo tài khoản mới bằng email và password.

## Quy Trình
1. User nhập email/password
2. App gửi request tới Supabase Auth
3. Supabase tạo tài khoản
4. Hệ thống tạo profile trong database
5. Gán role mặc định là User
6. Trả kết quả thành công

## Activity Diagram Flow
Start
→ Nhập thông tin
→ Validate dữ liệu
→ Gửi request register
→ Tạo account
→ Insert profile
→ Thành công
→ End

---

# 4.2 Login Flow

## Mô Tả
Người dùng đăng nhập để sử dụng hệ thống.

## Quy Trình
1. Nhập email/password
2. Gửi request login
3. Supabase xác thực
4. Lấy role từ database
5. Điều hướng giao diện theo role

## Điều Hướng Sau Login
- Admin → Admin Dashboard
- Artist → Artist Dashboard
- Premium → Premium Home
- User → User Home

## Activity Diagram Flow
Start
→ Nhập thông tin
→ Validate
→ Authentication
→ Lấy role
→ Điều hướng màn hình
→ End

---

# 4.3 Forgot Password Flow

## Mô Tả
Người dùng yêu cầu khôi phục mật khẩu.

## Quy Trình
1. User nhập email
2. App gửi yêu cầu reset
3. Supabase gửi email reset
4. User nhấn link email
5. User nhập mật khẩu mới
6. Cập nhật password

## Activity Diagram Flow
Start
→ Nhập email
→ Gửi request reset
→ Gửi email
→ User mở email
→ Đổi mật khẩu
→ Thành công
→ End

---

# 5. Use Case Diagram Phân Tích

# 5.1 Actor

## Primary Actors
- Admin
- Artist
- User
- Premium User

---

# 5.2 Các Use Case Chính

| Use Case | Admin | Artist | User | Premium |
|---|---|---|---|---|
| Register | ✓ | ✓ | ✓ | ✓ |
| Login | ✓ | ✓ | ✓ | ✓ |
| Logout | ✓ | ✓ | ✓ | ✓ |
| Search Music | ✓ | ✓ | ✓ | ✓ |
| Play Music | ✓ | ✓ | ✓ | ✓ |
| Upload Song | ✗ | ✓ | ✗ | ✗ |
| Manage Users | ✓ | ✗ | ✗ | ✗ |
| Create Playlist | ✗ | ✓ | ✓ | ✓ |
| Download Offline | ✗ | ✗ | ✗ | ✓ |
| Remove Ads | ✗ | ✗ | ✗ | ✓ |
| View Reports | ✓ | ✗ | ✗ | ✗ |

---

# 6. Database Thiết Kế

# 6.1 Bảng profiles

| Field | Type | Mô Tả |
|---|---|---|
| id | UUID | ID người dùng |
| username | TEXT | Tên người dùng |
| role | TEXT | Vai trò |
| premium | BOOL | Trạng thái premium |
| is_banned | BOOL | Trạng thái khóa |
| avatar_url | TEXT | Ảnh đại diện |

---

# 6.2 Giá Trị Role

swift enum UserRole: String, Codable {     case admin     case artist     case user     case premium } 

---

# 7. Điều Hướng Theo Role

## Sau Khi Login

swift switch role { case .admin:     AdminDashboardView()  case .artist:     ArtistDashboardView()  case .premium:     PremiumHomeView()  case .user:     UserHomeView() } 

---

# 8. Bảo Mật Hệ Thống

## Authentication
- Supabase Auth
- JWT Session
- Email Verification

## Database Security
- Row Level Security (RLS)
- Role-based access control

## User Protection
- Ban account
- Password reset
- Session management

---

# 9. Kết Luận

Hệ thống Authentication và phân quyền đã được xây dựng đầy đủ cho ứng dụng nghe nhạc với:

- Xác thực tài khoản
- Phân quyền nhiều role
- Điều hướng theo vai trò
- Hỗ trợ Premium
- Quản lý nghệ sĩ
- Quản trị hệ thống

Kiến trúc này giúp hệ thống:
- Dễ mở rộng
- Bảo mật cao
- Dễ quản lý
- Hỗ trợ phát triển các tính năng nâng cao trong tương lai.
