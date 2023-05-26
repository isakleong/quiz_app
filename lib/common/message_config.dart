abstract class Message {
  static const retry = "coba lagi";

  static const errorConnection = "Gagal terhubung ke server, pastikan sudah terhubung ke jaringan internet.";
  static const errorQuizConfig = "Mohon maaf, konfigurasi kuis tidak ditemukan, silahkan menghubungi tim SFA.";
  static const errorActiveQuiz = "Mohon maaf, tidak ada kuis yang aktif untuk saat ini.";
  static const submittingQuiz = "Mohon tunggu, sedang proses mengumpulkan kuis.";
  static const confirmSubmitQuiz = "Apakah Anda yakin ingin mengumpulkan kuis?";
  static const retrySubmitQuiz = "Data kuis belum dapat terkirim ke server untuk saat ini.\nJangan matikan gadget agar data dapat langsung terkirim ke server secara otomatis.";
}