import '../models/artist.dart';
import '../models/song.dart';

class MusicData {
  static final List<Artist> artists = [
    // ================= NOO PHƯỚC THỊNH =================
    Artist(
      name: "Noo Phước Thịnh",
      image: "",
      songs: [
        Song(
          title: "Thương Em Là Điều Anh Không Thể Ngờ",
          artist: "Noo Phước Thịnh",
          filePath: "songs/Thương Em Là Điều Anh Không Thể Ngờ.mp3",
          duration: "5:09",
        ),
        Song(
          title: "Khổ Quá Thì Về Mẹ Nuôi",
          artist: "Noo Phước Thịnh",
          filePath: "songs/kho_qua_thi_ve_me_nuoi.mp3",
          duration: "3:27",
        ),
        Song(
          title: "Cause I Love You",
          artist: "Noo Phước Thịnh",
          filePath: "songs/Cause I Love You (Xuân Phát Tài 8).mp3",
          duration: "4:45",
        ),
        Song(
          title: "Lặng Thầm",
          artist: "Noo Phước Thịnh",
          filePath: "songs/Lặng Thầm.mp3",
          duration: "3:20",
        ),
        Song(
          title: "Những Kẻ Mộng Mơ",
          artist: "Noo Phước Thịnh",
          filePath: "songs/Những Kẻ Mộng Mơ.mp3",
          duration: "4:14",
        ),
      ],
    ),

    // ================= HÀ ANH TUẤN =================
    Artist(
      name: "Hà Anh Tuấn",
      image: "",
      songs: [
        Song(
          title: "Tháng Tư Là Lời Nói Dối Của Em",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Tháng Tư Là Lời Nói Dối Của Em.mp3",
          duration: "4:45",
        ),
        Song(
          title: "Tháng Mấy Em Nhớ Anh",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Tháng Mấy Em Nhớ Anh_.mp3",
          duration: "4:28",
        ),
        Song(
          title: "Chưa Bao Giờ",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Chưa Bao Giờ (SEE SING SHARE 2).mp3",
          duration: "4:12",
        ),
        Song(
          title: "Nhà Tôi Có Treo Một Lá Cờ",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Nhà Tôi Có Treo Một Lá Cờ.mp3",
          duration: "4:35",
        ),
        Song(
          title: "Cơn Mưa Tình Yêu",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Cơn Mưa Tình Yêu.mp3",
          duration: "4:18",
        ),
      ],
    ),

    // ================= QUỐC THIÊN =================
    Artist(
      name: "Quốc Thiên",
      image: "",
      songs: [
        Song(
          title: "Hoa và Váy",
          artist: "Quốc Thiên",
          filePath: "songs/Hoa và Váy (RnB ver).mp3",
          duration: "3:30",
        ),
        Song(
          title: "Kiếp Sau Vẫn Là Người Việt Nam",
          artist: "Quốc Thiên",
          filePath: "songs/Kiếp Sau Vẫn Là Người Việt Nam.mp3",
          duration: "4:12",
        ),
        Song(
          title: "Rất Lâu Rồi Mới Khóc",
          artist: "Quốc Thiên",
          filePath: "songs/Rất Lâu Rồi Mới Khóc (New Version).mp3",
          duration: "4:05",
        ),
      ],
    ),

    // ================= JACK - J97 =================
    Artist(
      name: "J97",
      image: "",
      songs: [
        Song(
          title: "Hồng Nhan",
          artist: "Jack - J97",
          filePath: "songs/Hồng Nhan (K-ICM Mix).mp3",
          duration: "4:22",
        ),
        Song(
          title: "Sóng Gió",
          artist: "Jack - J97",
          filePath: "songs/Sóng Gió.mp3",
          duration: "4:05",
        ),
        Song(
          title: "Về Bên Anh",
          artist: "Jack - J97",
          filePath: "songs/Về Bên Anh.mp3",
          duration: "3:58",
        ),
        Song(
          title: "Trạm Dừng Chân",
          artist: "Jack - J97",
          filePath: "songs/Trạm Dừng Chân.mp3",
          duration: "4:15",
        ),
        Song(
          title: "Hoa Hải Đường",
          artist: "Jack - J97",
          filePath: "songs/Hoa Hải Đường (HITStory Live Version).mp3",
          duration: "3:45",
        ),
      ],
    ),
  ];

  // ================= HELPER METHODS =================

  /// Lấy artist theo tên (so khớp tuyệt đối)
  static Artist? getArtistByName(String name) {
    try {
      return artists.firstWhere((artist) => artist.name == name);
    } catch (_) {
      return null;
    }
  }

  /// Lấy danh sách bài hát của một artist
  static List<Song> getSongsByArtist(String artistName) {
    final artist = getArtistByName(artistName);
    return artist?.songs ?? [];
  }
}
