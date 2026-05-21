ACTIVITY DIAGRAM SPECIFICATION

1. Activity Diagram – Register

Mục Đích

Mô tả quy trình người dùng đăng ký tài khoản mới trong hệ thống.

Actor

* Guest User

Preconditions

* Người dùng chưa đăng nhập
* Người dùng có email hợp lệ

Main Flow

1. Người dùng mở màn hình Register
2. Người dùng nhập:
    * Username
    * Email
    * Password
    * Role
3. Hệ thống kiểm tra dữ liệu đầu vào
4. Hệ thống gửi request đăng ký đến Supabase Authentication
5. Supabase tạo tài khoản Authentication
6. Hệ thống nhận User ID từ Supabase
7. Hệ thống tạo Profile mặc định:
    * premium = false
    * is_banned = false
8. Hệ thống insert dữ liệu vào bảng profiles
9. Đăng ký thành công
10. Chuyển đến Home Screen

Alternative Flow

Trường hợp email đã tồn tại

* Supabase trả lỗi
* Hệ thống hiển thị thông báo lỗi
* Quay lại màn hình Register

Trường hợp mất kết nối internet

* Request thất bại
* Hiển thị lỗi kết nối

Postconditions

* Tài khoản mới được tạo
* Profile được lưu trong database

⸻

2. Activity Diagram – Login

Mục Đích

Mô tả quy trình đăng nhập hệ thống.

Actor

* User
* Artist
* Premium User
* Admin

Preconditions

* Người dùng đã có tài khoản

Main Flow

1. Người dùng mở Login Screen
2. Nhập email và password
3. Hệ thống validate dữ liệu
4. Gửi request authentication tới Supabase
5. Supabase kiểm tra thông tin tài khoản
6. Nếu hợp lệ:
    * Tạo session
    * Lưu currentUser
7. Hệ thống fetch role từ bảng profiles
8. Điều hướng giao diện:
    * Admin → Admin Dashboard
    * Artist → Artist Dashboard
    * Premium → Premium Home
    * User → HomeView
9. Đăng nhập thành công

Alternative Flow

Sai mật khẩu

* Hiển thị “Invalid credentials”

Tài khoản bị khóa

* Hiển thị thông báo account banned

Không có internet

* Login thất bại
* Hiển thị lỗi kết nối

Postconditions

* User được xác thực
* Session được lưu

⸻

3. Activity Diagram – Logout

Mục Đích

Mô tả quy trình đăng xuất khỏi hệ thống.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. User nhấn Logout
2. Hệ thống gọi signOut()
3. Supabase xóa session
4. currentUser = nil
5. isAuthenticated = false
6. Chuyển về Login Screen

Postconditions

* Session bị hủy
* User đăng xuất thành công

⸻

4. Activity Diagram – Forgot Password

Mục Đích

Cho phép người dùng khôi phục mật khẩu.

Actor

* Guest User
* User

Preconditions

* Email đã tồn tại trong hệ thống

Main Flow

1. User chọn “Forgot Password”
2. Nhập email
3. Hệ thống gửi request reset password
4. Supabase gửi email reset password
5. User mở email
6. User nhấn reset link
7. User nhập mật khẩu mới
8. Hệ thống cập nhật password
9. Reset password thành công

Alternative Flow

Email không tồn tại

* Hiển thị lỗi email invalid

Không có internet

* Gửi email thất bại

Postconditions

* Password mới được cập nhật

⸻

5. Activity Diagram – Fetch Songs

Mục Đích

Hiển thị danh sách bài hát trên Home Screen.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. User mở HomeView
2. Hệ thống gọi fetchSongs()
3. Query bảng songs
4. Join bảng:
    * artists
    * albums
5. Filter:
    * status = approved
6. Sắp xếp theo created_at
7. Hệ thống decode dữ liệu
8. Update songs
9. Hiển thị SongCard

Alternative Flow

Fetch thất bại

* Hiển thị errorMessage

Postconditions

* Danh sách bài hát hiển thị trên UI

⸻

6. Activity Diagram – Fetch Albums

Mục Đích

Hiển thị danh sách album nổi bật.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. HomeView xuất hiện
2. Hệ thống gọi fetchAlbums()
3. Query bảng albums
4. Join bảng artists
5. Decode dữ liệu
6. Update albums array
7. Hiển thị AlbumCard

Postconditions

* Album hiển thị trên Home Screen

⸻

7. Activity Diagram – Home Screen Navigation

Mục Đích

Mô tả điều hướng trong HomeView.

Actor

* User

Main Flow

1. User mở HomeView
2. Hệ thống load:
    * Header Section
    * Premium Banner
    * Trending Albums
    * Recently Played
3. User tương tác với SongCard hoặc AlbumCard
4. Điều hướng đến màn hình tương ứng
5. User tiếp tục sử dụng ứng dụng

Postconditions

* Home Screen hiển thị đầy đủ dữ liệu

⸻

8. Activity Diagram – Open Album Detail

Mục Đích

Mô tả quy trình người dùng mở chi tiết album.

Actor

* User

Preconditions

* Album tồn tại

Main Flow

1. User chọn AlbumCard
2. NavigationLink mở AlbumDetailView
3. Hệ thống truyền:
    * album
    * songs
4. Load Album Header
5. Load danh sách bài hát
6. Hiển thị Album Detail

Alternative Flow

Album không có bài hát

* Hiển thị “No Songs Available”

Cover URL lỗi

* Hiển thị placeholder image

Postconditions

* User xem được thông tin album

⸻

9. Activity Diagram – Load Album Header

Mục Đích

Hiển thị thông tin chính của album.

Actor

* User

Main Flow

1. AlbumDetailView được mở
2. Hệ thống load:
    * cover_url
    * title
    * artist
3. AsyncImage fetch ảnh từ URL
4. Render:
    * Album Cover
    * Album Title
    * Artist Name
    * Song Count
5. Hiển thị action buttons

Alternative Flow

Không tải được ảnh

* Hiển thị placeholder
* Hiển thị ProgressView

Postconditions

* Album Header hiển thị thành công

⸻

10. Activity Diagram – Favorite Album

Mục Đích

Cho phép người dùng lưu album yêu thích.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. User nhấn Favorite Button
2. Hệ thống lấy album.id
3. Gọi toggle(albumId:)
4. Kiểm tra trạng thái favorite mới
5. Nếu album chưa favorite:
    * Insert vào favorite_albums
6. Nếu đã favorite:
    * Remove khỏi favorite_albums
7. Update isFavorite
8. Update UI

Alternative Flow

Database Error

* Favorite thất bại
* Hiển thị lỗi console

Postconditions

* Album được thêm hoặc xóa khỏi Saved Albums

⸻

11. Activity Diagram – Check Favorite Album State

Mục Đích

Kiểm tra album đã được favorite hay chưa.

Actor

* User

Main Flow

1. AlbumDetailView xuất hiện
2. .task được gọi
3. Hệ thống lấy album.id
4. Query bảng favorite_albums
5. Nếu tồn tại:
    * isFavorite = true
6. Nếu không tồn tại:
    * isFavorite = false
7. Update Favorite Button UI

Postconditions

* Favorite state được đồng bộ với database

⸻

12. Activity Diagram – View Album Songs

Mục Đích

Hiển thị danh sách bài hát trong album.

Actor

* User

Preconditions

* Album có bài hát

Main Flow

1. AlbumDetailView load songs array
2. Hiển thị section “Tracks”
3. ForEach render SongCard
4. Hiển thị:
    * Song image
    * Song title
    * Artist
5. User scroll danh sách bài hát

Postconditions

* User xem được toàn bộ bài hát trong album

⸻

13. Activity Diagram – Play Song

Mục Đích

Cho phép người dùng phát nhạc.

Actor

* User
* Premium User

Preconditions

* Có bài hát hợp lệ

Main Flow

1. User chọn SongCard
2. Mở PlayerRouterView
3. Load audio URL
4. Khởi tạo audio player
5. Phát bài hát
6. Lưu recently played
7. Update mini player

Alternative Flow

Audio URL lỗi

* Không phát được nhạc
* Hiển thị lỗi playback

Postconditions

* Bài hát được phát thành công

⸻

14. Activity Diagram – Favorite Song

Mục Đích

Lưu bài hát yêu thích.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. User nhấn Like button
2. Insert vào bảng favorites
3. Lưu:
    * user_id
    * song_id
4. Fetch lại favorite songs
5. Update Side Menu
6. Hiển thị bài hát yêu thích

Postconditions

* Favorite song được lưu

⸻

15. Activity Diagram – Save Album

Mục Đích

Lưu album yêu thích.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. User chọn Save Album
2. Insert vào bảng favorite_albums
3. Lưu:
    * user_id
    * album_id
4. Fetch saved albums
5. Update Side Menu

Postconditions

* Album được lưu thành công

⸻

16. Activity Diagram – Open Side Menu

Mục Đích

Điều hướng nhanh trong ứng dụng.

Actor

* User

Main Flow

1. User nhấn menu button
2. showMenu = true
3. Side Menu slide từ trái sang
4. Overlay background xuất hiện
5. User chọn chức năng:
    * Home
    * Favorite Songs
    * Saved Albums
    * Profile
    * Logout
6. Điều hướng màn hình tương ứng

Alternative Flow

User tap ngoài menu

* showMenu = false
* Menu đóng lại

Postconditions

* Side Menu hoạt động thành công

⸻

17. Activity Diagram – Fetch Favorite Songs

Mục Đích

Lấy danh sách bài hát yêu thích.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. Hệ thống lấy currentUser.id
2. Query bảng favorites
3. Lấy danh sách song_id
4. Query bảng songs
5. Filter status = approved
6. Update favoriteSongs
7. Hiển thị Favorite Songs trong Side Menu

Postconditions

* Favorite Songs được cập nhật

⸻

18. Activity Diagram – Fetch Saved Albums

Mục Đích

Lấy danh sách album đã lưu.

Actor

* User

Preconditions

* User đã đăng nhập

Main Flow

1. Hệ thống lấy currentUser.id
2. Query bảng favorite_albums
3. Lấy danh sách album_id
4. Query bảng albums
5. Join bảng artists
6. Update savedAlbums
7. Hiển thị Saved Albums trong Side Menu

Postconditions

* Saved Albums được cập nhật

⸻

19. Activity Diagram – Recently Played

Mục Đích

Lưu lịch sử phát nhạc gần đây.

Actor

* User

Preconditions

* User phát bài hát

Main Flow

1. User phát bài hát
2. Hệ thống kiểm tra bài hát đã tồn tại chưa
3. Nếu chưa tồn tại:
    * Insert recently played
4. Nếu đã tồn tại:
    * Move lên đầu danh sách
5. Update recently played array
6. Hiển thị trong Recently Played section

Postconditions

* Recently played được cập nhật

⸻

20. Activity Diagram – Album Menu Actions

Mục Đích

Hiển thị menu tùy chọn của album.

Actor

* User

Main Flow

1. User nhấn button “ellipsis”
2. Hệ thống mở Menu
3. Hiển thị:
    * Add to Queue
    * Report
4. User chọn chức năng

⸻

Flow – Add To Queue

1. User chọn “Add to Queue”
2. Hệ thống thêm bài hát album vào queue
3. Update player queue

Postconditions

* Queue được cập nhật

⸻

Flow – Report Album

1. User chọn “Report”
2. Hệ thống gửi report album
3. Admin nhận report

Postconditions

* Album được report thành công

⸻

21. Activity Diagram – Navigation Back

Mục Đích

Quay lại màn hình trước.

Actor

* User

Main Flow

1. User nhấn Back Button
2. NavigationStack pop view
3. Quay lại HomeView hoặc màn hình trước đó

Postconditions

* User trở về màn hình trước

⸻

22. Kết Luận

Hệ thống Activity Diagram của ứng dụng nghe nhạc mô tả đầy đủ các quy trình chính bao gồm:

* Authentication
* Home Navigation
* Album System
* Song System
* Favorite System
* Recently Played
* Side Menu Navigation
* Music Playback

Các Activity Diagram giúp:

* Phân tích luồng hoạt động hệ thống
* Hỗ trợ thiết kế UML
* Dễ dàng phát triển và bảo trì hệ thống
* Tăng khả năng mở rộng ứng dụng trong tương lai.
