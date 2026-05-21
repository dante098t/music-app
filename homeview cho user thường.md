# Báo Cáo Chức Năng User Home, Song Card, Album Card Và Side Menu

# 1. Tổng Quan

Module User Home được xây dựng nhằm cung cấp giao diện chính cho người dùng thường trong ứng dụng nghe nhạc. Chức năng này cho phép:

- Hiển thị danh sách bài hát
- Hiển thị album
- Xem thông tin nghệ sĩ
- Quản lý bài hát yêu thích
- Quản lý album đã lưu
- Điều hướng bằng Side Menu

Hệ thống sử dụng:
- SwiftUI
- MVVM Architecture
- Supabase Database
- Combine Framework

---

# 2. HomeViewModel

## Mục Đích

HomeViewModel chịu trách nhiệm:
- Lấy dữ liệu bài hát
- Lấy dữ liệu album
- Quản lý trạng thái loading
- Quản lý lỗi hệ thống

Class sử dụng:

swift id="v9k1xa" ObservableObject 

để cập nhật dữ liệu realtime cho giao diện.

---

# 3. Dữ Liệu Quản Lý

## Songs

swift id="j2n5qe" @Published var songs: [Song] = [] 

Lưu danh sách bài hát hiển thị trên Home Screen.

---

## Albums

swift id="k7t4rd" @Published var albums: [Album] = [] 

Lưu danh sách album.

---

## Favorite Songs

swift id="d3w8ph" @Published var favoriteSongs: [Song] = [] 

Lưu danh sách bài hát yêu thích của người dùng.

---

## Saved Albums

swift id="h5x1co" @Published var savedAlbums: [Album] = [] 

Lưu album đã lưu.

---

## Loading State

swift id="p8f6yv" @Published var isLoading = false 

Kiểm soát trạng thái tải dữ liệu.

---

## Error Message

swift id="r1m9zk" @Published var errorMessage: String? 

Hiển thị lỗi nếu fetch thất bại.

---

# 4. FetchSongs Function

## Mô Tả

Chức năng fetchSongs() lấy toàn bộ bài hát đã được duyệt từ Supabase Database.

---

# 5. Dữ Liệu Bài Hát

Hệ thống lấy:
- Thông tin bài hát
- Nghệ sĩ
- Album
- Premium status
- Explicit content
- Lyrics
- Play count

---

# 6. Điều Kiện Hiển Thị

swift id="n6q4bt" .eq("status", value: "approved") 

Chỉ hiển thị bài hát đã được Admin duyệt.

---

# 7. Song Card

## Mô Tả

Song Card được sử dụng để hiển thị:
- Ảnh bài hát
- Tên bài hát
- Nghệ sĩ
- Premium badge
- Explicit badge

Người dùng có thể:
- Nhấn để phát nhạc
- Xem chi tiết bài hát
- Like bài hát
- Thêm playlist

---

# 8. Thông Tin Song Card

| Thành phần | Chức năng |
|---|---|
| Cover Image | Ảnh bài hát |
| Song Title | Tên bài hát |
| Artist Name | Nghệ sĩ |
| Premium Icon | Nhạc Premium |
| Explicit Label | Nội dung giới hạn |
| Play Button | Phát nhạc |

---

# 9. FetchAlbums Function

## Mô Tả

fetchAlbums() lấy danh sách album từ database.

Dữ liệu bao gồm:
- Album
- Nghệ sĩ
- Ảnh album

---

# 10. Album Card

## Mô Tả

Album Card hiển thị:
- Cover album
- Tên album
- Nghệ sĩ

Người dùng có thể:
- Nhấn để mở album
- Xem danh sách bài hát
- Lưu album

---

# 11. Chức Năng Album Card

| Chức năng | Mô tả |
|---|---|
| Open Album | Mở chi tiết album |
| Save Album | Lưu album yêu thích |
| View Artist | Xem nghệ sĩ |

---

# 12. Side Menu System

## Mục Đích

Side Menu được xây dựng để:
- Điều hướng nhanh
- Hiển thị dữ liệu cá nhân
- Quản lý thư viện người dùng

Hệ thống sử dụng:
swift id="y7o3ma" SideMenuViewModel 

---

# 13. SideMenuViewModel

## Chức Năng

- Lấy album đã lưu
- Lấy bài hát yêu thích
- Đồng bộ dữ liệu người dùng

---

# 14. Favorite Songs System

## fetchFavoriteSongs()

### Mô Tả

Lấy danh sách bài hát yêu thích từ bảng:
text id="w4t8ce" favorites 

Quy trình:
1. Lấy user hiện tại
2. Query bảng favorites
3. Lấy song_id
4. Query bảng songs
5. Hiển thị danh sách favorite songs

---

# 15. Saved Albums System

## fetchSavedAlbums()

### Mô Tả

Lấy album đã lưu từ:
text id="u1r5xf" favorite_albums 

Quy trình:
1. Lấy user hiện tại
2. Query favorite_albums
3. Lấy album_id
4. Query bảng albums
5. Hiển thị saved albums

---

# 16. Side Menu Chức Năng

| Menu | Chức năng |
|---|---|
| Home | Trang chủ |
| Favorite Songs | Bài hát yêu thích |
| Saved Albums | Album đã lưu |
| Profile | Hồ sơ người dùng |
| Logout | Đăng xuất |

---

# 17. Kiến Trúc MVVM

Hệ thống sử dụng mô hình:
text id="q8d6nm" Model - View - ViewModel 

## Model
- Song
- Album
- Favorite
- FavoriteAlbum

## ViewModel
- HomeViewModel
- SideMenuViewModel

## View
- HomeView
- SongCard
- AlbumCard
- SideMenu

---

# 18. User Flow

# Home Screen Flow

Start
→ Fetch Songs
→ Fetch Albums
→ Hiển thị Song Card
→ Hiển thị Album Card
→ User tương tác
→ End

---

# Favorite Flow

Start
→ User like bài hát
→ Insert favorites
→ Fetch favorite songs
→ Hiển thị Side Menu
→ End

---

# Album Save Flow

Start
→ User save album
→ Insert favorite_albums
→ Fetch saved albums
→ Hiển thị trong Side Menu
→ End

---

# 19. Vai Trò Người Dùng Thường

## User thường có thể:
- Nghe nhạc
- Xem album
- Tìm kiếm bài hát
- Like bài hát
- Lưu album
- Xem artist

## User thường không thể:
- Upload nhạc
- Quản lý user
- Truy cập admin dashboard
- Download offline premium

---

# 20. Ưu Điểm Hệ Thống

- Dữ liệu realtime
- Giao diện động
- Quản lý favorite dễ dàng
- Tách biệt logic và UI
- Dễ mở rộng
- Tối ưu trải nghiệm người dùng

---

# 21. Kết Luận

Module User Home và Side Menu đã được xây dựng hoàn chỉnh cho người dùng thường với các chức năng:
- Hiển thị bài hát
- Hiển thị album
- Song Card
- Album Card
- Favorite Songs
- Saved Albums
- Side Menu Navigation

Hệ thống giúp:
- Tăng trải nghiệm người dùng
- Quản lý dữ liệu hiệu quả
- Dễ mở rộng tính năng trong tương lai
- Hỗ trợ mô hình ứng dụng nghe nhạc hiện đại.
