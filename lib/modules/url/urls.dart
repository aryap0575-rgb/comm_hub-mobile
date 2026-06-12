class Urls {
  // Local

  // final String mainUrl = 'http://192.168.102.101:8000';
  final String mainUrl = 'http://192.168.1.10:8000';
  // final String mainUrl = 'https://sipintar.silatama.co.id';

  late String media = '$mainUrl/static/media/';

  Uri signup() => Uri.parse('$mainUrl/mobile/register/');
  Uri signin() => Uri.parse('$mainUrl/mobile/login/');
  Uri forgotPass() => Uri.parse('$mainUrl/mobile/forgot/pass/');
  Uri changePass() => Uri.parse('$mainUrl/mobile/change/pass/');
  Uri getClasses() => Uri.parse('$mainUrl/mobile/get_classes/');
  Uri course() => Uri.parse('$mainUrl/mobile/course/');
  Uri userlog() => Uri.parse('$mainUrl/mobile/userlog/');
  Uri userlogout() => Uri.parse('$mainUrl/mobile/user_logout/');
  Uri usercreateLock() => Uri.parse('$mainUrl/mobile/user_create_lock/');
  Uri getProfile() => Uri.parse('$mainUrl/mobile/get/profile/');
  Uri profileUser(int userId) => Uri.parse('$mainUrl/mobile/profile/$userId/');
  Uri updateProfile() => Uri.parse('$mainUrl/mobile/update/profile/');
  Uri updatePhoto() => Uri.parse('$mainUrl/mobile/update/photo/');
  Uri checkLock() => Uri.parse('$mainUrl/mobile/user_check_lock/');

  Uri synchJadwalSholat() => Uri.parse('$mainUrl/ajax/synch_jadwal_sholat/');
  Uri wallpaper() => Uri.parse('$mainUrl/wallpaper/');
  Uri standbyWallpaper() => Uri.parse('$mainUrl/standbywallpaper/');
  Uri sliderJumat() => Uri.parse('$mainUrl/sliderjumat/');

  Uri register() => Uri.parse('$mainUrl/mobile/register/');
  Uri login() => Uri.parse('$mainUrl/mobile/login/');
  Uri logout() => Uri.parse('$mainUrl/mobile/logout/');
  Uri forgotPassword() => Uri.parse('$mainUrl/mobile/forgot/password/');
  Uri resetPassword() => Uri.parse('$mainUrl/mobile/reset/password/');

// Komunitas
  Uri listKomunitas() => Uri.parse('$mainUrl/mobile/komunitas/list/');
  Uri detailKomunitas(int id) =>
      Uri.parse('$mainUrl/mobile/komunitas/detail/$id/');
  Uri daftarKomunitas() => Uri.parse('$mainUrl/mobile/komunitas/daftar/');
  Uri simpanKomunitas() => Uri.parse('$mainUrl/mobile/komunitas/simpan/');
  Uri tersimpanKomunitas() => Uri.parse('$mainUrl/mobile/komunitas/tersimpan/');
  Uri favoritOrganisasi() => Uri.parse('$mainUrl/mobile/organisasi/favorit/');
  Uri favoritOrganisasiByUser(int userId) =>
      Uri.parse('$mainUrl/mobile/organisasi/favorit/user/$userId/');
}
