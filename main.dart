import 'fitur.dart';
import 'input.dart';

void main() {
  print('=== Absensi Kelas ===');
  var berjalan = true;

  while (berjalan) {
    print('');
    print('1. Lihat daftar mahasiswa');
    print('2. Catat absensi pertemuan baru');
    print('3. Lihat absensi per pertemuan');
    print('4. Tambah mahasiswa                [Mudah]');
    print('5. Cari mahasiswa (nama)           [Mudah]');
    print('6. Ubah status absensi             [Sedang]');
    print('0. Keluar');

    final pilihan = bacaInt('Pilih menu', min: 0, max: 6);
    switch (pilihan) {
      case 1:
        tampilkanDaftar();
      case 2:
        catatAbsensi();
      case 3:
        tampilkanAbsensiPertemuan();
      case 4:
        tambahMahasiswa();
      case 5:
        cariMahasiswa();
      case 6:
        ubahStatus();
      case 0:
        berjalan = false;
    }
  }

  print('Terima kasih.');
}
