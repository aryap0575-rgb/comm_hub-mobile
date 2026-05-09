class Urls {
  // Local

  // final String mainUrl = 'http://192.168.102.101:8000';
  final String mainUrl = 'http://192.168.1.33:8000';
  // final String mainUrl = 'https://sipintar.silatama.co.id';

  late String media = '$mainUrl/static/media/';

  Uri signup() => Uri.parse('$mainUrl/mobile/signup/');
  Uri signin() => Uri.parse('$mainUrl/mobile/login/');
  Uri forgotPass() => Uri.parse('$mainUrl/mobile/forgot/pass/');
  Uri changePass() => Uri.parse('$mainUrl/mobile/change/pass/');
  Uri getClasses() => Uri.parse('$mainUrl/mobile/get_classes/');
  Uri course() => Uri.parse('$mainUrl/mobile/course/');
  Uri userlog() => Uri.parse('$mainUrl/mobile/userlog/');
  Uri userlogout() => Uri.parse('$mainUrl/mobile/user_logout/');
  Uri usercreateLock() => Uri.parse('$mainUrl/mobile/user_create_lock/');
  Uri getProfile() => Uri.parse('$mainUrl/mobile/get/profile/');
  Uri updateProfile() => Uri.parse('$mainUrl/mobile/update/profile/');
  Uri updatePhoto() => Uri.parse('$mainUrl/mobile/update/photo/');
  Uri checkLock() => Uri.parse('$mainUrl/mobile/user_check_lock/');

  Uri synchJadwalSholat() => Uri.parse('$mainUrl/ajax/synch_jadwal_sholat/');
  Uri wallpaper() => Uri.parse('$mainUrl/wallpaper/');
  Uri standbyWallpaper() => Uri.parse('$mainUrl/standbywallpaper/');
  Uri sliderJumat() => Uri.parse('$mainUrl/sliderjumat/');
}
