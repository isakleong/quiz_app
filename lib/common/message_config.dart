abstract class Message {
  static const retry = "coba lagi";

  static const requestPermission = "Mohon berikan izin akses aplikasi dengan menekan tombol Allow.";

  static const updateVersionMessage = "Terdapat versi aplikasi yang lebih baru.\n\nIkuti langkah-langkah berikut :\n1. Tekan OK untuk kembali ke aplikasi SFA.\n2. Tekan menu Pengaturan.\n3. Tekan tombol Unduh Aplikasi SFA Tools.\n4. Tunggu hingga proses update selesai.";
  static const errorParameterData = "Mohon maaf, konfigurasi aplikasi tidak ditemukan, silahkan menghubungi tim SFA.";
  static const errorConnection = "Gagal terhubung ke server,\npastikan gadget sudah terhubung ke internet.\n(Bisa menggunakan simcard atau wifi SFA).";
  static const errorQuizConfig = "Mohon maaf, konfigurasi kuis tidak ditemukan, silahkan menghubungi tim SFA.";
  static const errorActiveQuiz = "Mohon maaf, tidak ada kuis yang aktif untuk saat ini.";
  static const submittingQuiz = "Mohon tunggu, sedang proses mengumpulkan kuis.";
  static const confirmSubmitQuiz = "Apakah Anda yakin ingin mengumpulkan kuis?";
  static const confirmExitApp = "Apakah Anda yakin ingin keluar dari aplikasi?";
  static const retrySubmitQuiz = "Data kuis belum dapat terkirim ke server untuk saat ini.\nJangan matikan gadget agar data dapat langsung terkirim ke server secara otomatis.";
  static const warningQuizNotSent = "Ada data kuis yang belum terkirim.\nPastikan gadget terhubung ke internet\ndan coba ulang setelah 5 menit.";
  static const emptyData = "Tidak ada data.";

}