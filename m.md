# ACTIVITY DIAGRAM SPECIFICATION

# 1. Activity Diagram – Register

## Mục Đích
Mô tả quy trình người dùng đăng ký tài khoản mới trong hệ thống.

## Actor
- Guest User

## Preconditions
- Người dùng chưa đăng nhập
- Người dùng có email hợp lệ

## Main Flow

1. Người dùng mở màn hình Register
2. Người dùng nhập:
   - Username
   - Email
   - Password
   - Role
3. Hệ thống kiểm tra dữ liệu đầu vào
4. Hệ thống gửi request đăng ký đến Supabase Authentication
5. Supabase tạo tài khoản Authentication
6. Hệ thống nhận User ID từ Supabase
7. Hệ thống tạo Profile mặc định:
   - premium = false
   - is_banned = false
8. Hệ thống insert dữ liệu vào bảng profiles
9. Đăng ký thành công
10. Chuyển đến Home Screen

## Alternative Flow

### Trường hợp email đã tồn tại
- Supabase trả lỗi
- Hệ thống hiển thị thông báo lỗi
- Quay lại màn hình Register

### Trường hợp mất kết nối internet
- Request thất bại
- Hiển thị lỗi kết nối

## Postconditions
- Tài khoản mới được tạo
- Profile được lưu trong database

---

# 2. Activity Diagram – Login

## Mục Đích
Mô tả quy trình đăng nhập hệ thống.

## Actor
- User
- Artist
- Premium User
- Admin

## Preconditions
- Người dùng đã có tài khoản

## Main Flow

1. Người dùng mở Login Screen
2. Nhập email và password
3. Hệ thống validate dữ liệu
4. Gửi request authentication tới Supabase
5. Supabase kiểm tra thông tin tài khoản
6. Nếu hợp lệ:
   - Tạo session
   - Lưu currentUser
7. Hệ thống fetch role từ bảng profiles
8. Điều hướng giao diện:
   - Admin → Admin Dashboard
   - Artist → Artist Dashboard
   - Premium → Premium Home
   - User → HomeView
9. Đăng nhập thành công

## Alternative Flow

### Sai mật khẩu
- Hiển thị “Invalid credentials”

### Tài khoản bị khóa
- Hiển thị thông báo account banned

### Không có internet
- Login thất bại
- Hiển thị lỗi kết nối

## Postconditions
- User được xác thực
- Session được lưu

---

# 3. Activity Diagram – Logout

## Mục Đích
Mô tả quy trình đăng xuất khỏi hệ thống.

## Actor
- User

## Preconditions
- User đã đăng nhập

## Main Flow

1. User nhấn Logout
2. Hệ thống gọi signOut()
3. Supabase xóa session
4. currentUser = nil
5. isAuthenticated = false
6. Chuyển về Login Screen

## Postconditions
- Session bị hủy
- User đăng xuất thành công

---

# 4. Activity Diagram – Forgot Password

## Mục Đích
Cho phép người dùng khôi phục mật khẩu.

## Actor
- Guest User
- User

## Preconditions
- Email đã tồn tại trong hệ thống

## Main Flow

1. User chọn “Forgot Password”
2. Nhập email
3. Hệ thống gửi request reset password
4. Supabase gửi email reset password
5. User mở email
6. User nhấn reset link
7. User nhập mật khẩu mới
8. Hệ thống cập nhật password
9. Reset password thành công

## Alternative Flow

### Email không tồn tại
- Hiển thị lỗi email invalid

### Không có internet
- Gửi email thất bại

## Postconditions
- Password mới được cập nhật

---

# 5. Activity Diagram – Fetch Songs

## Mục Đích
Hiển thị danh sách bài hát trên Home Screen.

## Actor
- User

## Preconditions
- User đã đăng nhập

## Main Flow

1. User mở HomeView
2. Hệ thống gọi fetchSongs()
3. Query bảng songs
4. Join bảng:
   - artists
   - albums
5. Filter:
   - status = approved
6. Sắp xếp theo created_at
7. Hệ thống decode dữ liệu
8. Update songs
9. Hiển thị SongCard

## Alternative Flow

### Fetch thất bại
- Hiển thị errorMessage

## Postconditions
- Danh sách bài hát hiển thị trên UI

---

# 6. Activity Diagram – Fetch Albums

## Mục Đích
Hiển thị danh sách album nổi bật.

## Actor
- User

## Preconditions
- User đã đăng nhập

## Main Flow

1. HomeView xuất hiện
2. Hệ thống gọi fetchAlbums()
3. Query bảng albums
4. Join bảng artists
5. Decode dữ liệu
6. Update albums array
7. Hiển thị AlbumCard

## Postconditions
- Album hiển thị trên Home Screen

---

# 7. Activity Diagram – Play Song

## Mục Đích
Cho phép người dùng phát nhạc.

## Actor
- User
- Premium User

## Preconditions
- Có bài hát hợp lệ

## Main Flow

1. User chọn SongCard
2. Mở PlayerRouterView
3. Load audio URL
4. Khởi tạo audio player
5. Phát bài hát
6. Lưu recently played
7. Update mini player

## Alternative Flow

### Audio URL lỗi
- Không phát được nhạc
- Hiển thị lỗi playback

## Postconditions
- Bài hát được phát thành công

---

# 8. Activity Diagram – Save Favorite Song

## Mục Đích
Lưu bài hát yêu thích.

## Actor
- User

## Preconditions
- User đã đăng nhập

## Main Flow

1. User nhấn Like button
2. Hệ thống insert vào bảng favorites
3. Lưu:
   - user_id
   - song_id
4. Fetch lại favorite songs
5. Update Side Menu
6. Hiển thị bài hát yêu thích

## Postconditions
- Favorite song được lưu

---

# 9. Activity Diagram – Save Album

## Mục Đích
Lưu album yêu thích.

## Actor
- User

## Preconditions
- User đã đăng nhập

## Main Flow

1. User chọn Save Album
2. Insert vào bảng favorite_albums
3. Lưu:
   - user_id
   - album_id
4. Fetch saved albums
5. Update Side Menu

## Postconditions
- Album được lưu thành công

---

# 10. Activity Diagram – Open Side Menu

## Mục Đích
Điều hướng nhanh trong ứng dụng.

## Actor
- User

## Main Flow

1. User nhấn menu button
2. showMenu = true
3. Side Menu slide từ trái sang
4. Overlay background xuất hiện
5. User chọn chức năng:
   - Home
   - Favorite Songs
   - Saved Albums
   - Profile
   - Logout
6. Điều hướng màn hình tương ứng

## Alternative Flow

### User tap ngoài menu
- showMenu = false
- Menu đóng lại

## Postconditions
- Side Menu hoạt động thành công

---

# 11. Activity Diagram – Recently Played

## Mục Đích
Lưu lịch sử phát nhạc gần đây.

## Actor
- User

## Preconditions
- User phát bài hát

## Main Flow

1. User phát bài hát
2. Hệ thống kiểm tra bài hát đã tồn tại chưa
3. Nếu chưa tồn tại:
   - Insert recently played
4. Nếu đã tồn tại:
   - Move lên đầu danh sách
5. Update recently played array
6. Hiển thị trong Recently Played section

## Postconditions
- Recently played được cập nhật
