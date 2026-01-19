import '../models/artist.dart';
import '../models/song.dart';

class MusicData {
  static final List<Artist> artists = [
    // Noo Phước Thịnh
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
          filePath: "songs/cause_i_love_you.mp3",
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

    // Hà Anh Tuấn
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
          title: "Tháng mấy em nhớ anh",
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
          title: "Nhà tôi có treo một lá cờ",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Nhà Tôi Có Treo Một Lá Cờ.mp3",
          duration: "4:35",
        ),
        Song(
          title: "Cơn mưa tình yêu",
          artist: "Hà Anh Tuấn",
          filePath: "songs/Cơn Mưa Tình Yêu.mp3",
          duration: "4:18",
        ),
      ],
    ),

    // Hồng Nhan J97
    Artist(
      name: "Hồng Nhan J97",
      image: "",
      songs: [
        Song(
          title: "Hồng Nhan",
          artist: "Jack - J97",
          filePath: "songs/Hồng Nhan (K-ICM Mix).mp3",
          duration: "4:22",
        ),
        Song(
          title: "Sóng gió",
          artist: "Jack - J97",
          filePath: "songs/Sóng Gió.mp3",
          duration: "4:05",
        ),
        Song(
          title: "Về bên anh",
          artist: "Jack - J97",
          filePath: "songs/Về Bên Anh.mp3",
          duration: "3:58",
        ),
        Song(
          title: "Trạm dừng chân",
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

  // Lấy artist theo tên
  static Artist? getArtistByName(String name) {
    try {
      return artists.firstWhere((artist) => artist.name == name);
    } catch (e) {
      return null;
    }
  }

  // Lấy tất cả bài hát của một artist
  static List<Song> getSongsByArtist(String artistName) {
    final artist = getArtistByName(artistName);
    return artist?.songs ?? [];
  }
}