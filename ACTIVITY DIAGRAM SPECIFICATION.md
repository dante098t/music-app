# ACTIVITY DIAGRAM SPECIFICATION – MUSIC STREAMING APPLICATION

## Tổng Quan

Tài liệu này mô tả Activity Diagram Specification của hệ thống ứng dụng nghe nhạc được phát triển bằng SwiftUI và Supabase. Hệ thống hỗ trợ xác thực người dùng, phát nhạc, quản lý album, bài hát yêu thích, recently played và phân quyền nhiều role khác nhau.

---

# 1. Register Activity

## Mục Đích
Cho phép người dùng tạo tài khoản mới trong hệ thống.

## Actor
- Guest User

## Main Flow
1. User mở màn hình Register
2. Nhập:
   - Username
   - Email
   - Password
   - Role
3. System validate dữ liệu
4. Gửi request đến Supabase Authentication
5. Supabase tạo tài khoản
6. Hệ thống tạo Profile mặc định:
   - premium = false
   - is_banned = false
7. Insert profile vào database
8. Đăng ký thành công
9. Điều hướng đến Home Screen

## Alternative Flow
- Email đã tồn tại
- Không có internet
- Dữ liệu không hợp lệ

---

# 2. Login Activity

## Mục Đích
Cho phép người dùng đăng nhập hệ thống.

## Actor
- User
- Artist
- Premium User
- Admin

## Main Flow
1. User nhập email/password
2. System validate dữ liệu
3. Supabase xác thực tài khoản
4. Tạo session
5. Fetch role từ bảng profiles
6. Điều hướng giao diện theo role:
   - Admin Dashboard
   - Artist Dashboard
   - Premium Home
   - User Home
7. Đăng nhập thành công

## Alternative Flow
- Sai mật khẩu
- Account bị khóa
- Không có internet

---

# 3. Logout Activity

## Mục Đích
Đăng xuất khỏi hệ thống.

## Actor
- User

## Main Flow
1. User nhấn Logout
2. System gọi signOut()
3. Session bị xóa
4. currentUser = nil
5. Điều hướng về Login Screen

---

# 4. Forgot Password Activity

## Mục Đích
Khôi phục mật khẩu tài khoản.

## Actor
- Guest User
- User

## Main Flow
1. User chọn Forgot Password
2. Nhập email
3. System gửi request reset password
4. Supabase gửi email reset
5. User reset password
6. Password được cập nhật

## Alternative Flow
- Email không tồn tại
- Không có internet

---

# 5. Fetch Songs Activity

## Mục Đích
Hiển thị danh sách bài hát trên Home Screen.

## Actor
- User

## Main Flow
1. HomeView xuất hiện
2. System gọi fetchSongs()
3. Query bảng songs
4. Join:
   - artists
   - albums
5. Filter status = approved
6. Decode dữ liệu
7. Update songs array
8. Hiển thị SongCard

---

# 6. Fetch Albums Activity

## Mục Đích
Hiển thị danh sách album nổi bật.

## Actor
- User

## Main Flow
1. HomeView load
2. System gọi fetchAlbums()
3. Query albums
4. Join artists
5. Update albums array
6. Hiển thị AlbumCard

---

# 7. Home Navigation Activity

## Mục Đích
Điều hướng trong Home Screen.

## Actor
- User

## Main Flow
1. User mở HomeView
2. System hiển thị:
   - Header Section
   - Premium Banner
   - Trending Albums
   - Recently Played
3. User chọn SongCard hoặc AlbumCard
4. Điều hướng sang màn hình tương ứng

---

# 8. Album Detail Activity

## Mục Đích
Hiển thị chi tiết album.

## Actor
- User

## Main Flow
1. User chọn AlbumCard
2. Mở AlbumDetailView
3. Load:
   - Album Cover
   - Album Title
   - Artist
   - Song List
4. Hiển thị Album Detail

---

# 9. Favorite Album Activity

## Mục Đích
Lưu album yêu thích.

## Actor
- User

## Main Flow
1. User nhấn Favorite Button
2. System gọi toggle(albumId:)
3. Nếu chưa favorite:
   - Insert favorite_albums
4. Nếu đã favorite:
   - Remove favorite_albums
5. Update UI

---

# 10. Play Song Activity

## Mục Đích
Phát nhạc từ SongCard hoặc Album Detail.

## Actor
- User
- Premium User

## Main Flow
1. User chọn SongCard
2. Mở PlayerRouterView
3. Load audio URL
4. Khởi tạo audio player
5. Phát bài hát
6. Lưu Recently Played
7. Update mini player

## Alternative Flow
- Audio URL lỗi
- Playback thất bại

---

# 11. Favorite Song Activity

## Mục Đích
Lưu bài hát yêu thích.

## Actor
- User

## Main Flow
1. User nhấn Like Button
2. Insert vào favorites
3. Fetch lại favorite songs
4. Update Side Menu

---

# 12. Saved Albums Activity

## Mục Đích
Lưu album yêu thích.

## Actor
- User

## Main Flow
1. User chọn Save Album
2. Insert favorite_albums
3. Fetch saved albums
4. Update Side Menu

---

# 13. Side Menu Activity

## Mục Đích
Điều hướng nhanh trong ứng dụng.

## Actor
- User

## Main Flow
1. User nhấn Menu Button
2. Side Menu xuất hiện
3. User chọn:
   - Home
   - Favorite Songs
   - Saved Albums
   - Profile
   - Logout
4. Điều hướng màn hình

---

# 14. Recently Played Activity

## Mục Đích
Lưu lịch sử phát nhạc gần đây.

## Actor
- User

## Main Flow
1. User phát bài hát
2. System kiểm tra bài hát đã tồn tại chưa
3. Update recently played array
4. Hiển thị Recently Played section

---

# 15. Admin Activity

## Mục Đích
Quản lý hệ thống.

## Actor
- Admin

## Main Flow
1. Admin mở Dashboard
2. Quản lý:
   - Songs
   - Albums
   - Users
   - Reports
3. Approve hoặc reject bài hát
4. Update database

---

# 16. Artist Activity

## Mục Đích
Upload và quản lý bài hát.

## Actor
- Artist

## Main Flow
1. Artist upload song
2. Upload audio/image
3. Nhập metadata:
   - title
   - genre
   - explicit content
4. Submit bài hát
5. Chờ Admin duyệt

---

# 17. Premium Features Activity

## Mục Đích
Kích hoạt tính năng premium.

## Actor
- Premium User

## Main Flow
1. System kiểm tra premium status
2. Kích hoạt:
   - No Ads
   - Unlimited Skip
   - High Quality Audio
   - Premium Content

---

# Kết Luận

Activity Diagram Specification mô tả toàn bộ luồng hoạt động chính của hệ thống Music Streaming Application bao gồm:
- Authentication
- Music Playback
- Album Management
- Favorite System
- Side Menu Navigation
- Role Management
- Premium Features
