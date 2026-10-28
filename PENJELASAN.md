# PANDUAN LENGKAP & MATERI PRESENTASI UTS
## Proyek: 02 - Absensi Kelas (Dart Console Application)

Dokumen ini disusun sebagai panduan menyeluruh untuk menghadapi presentasi dan sesi tanya jawab dengan dosen penguji pada **Pertemuan #8**.

---

## DAFTAR ISI
1. [Arsitektur & Struktur File](#1-arsitektur--struktur-file)
2. [Bedah Tipe Data Seluruh Program](#2-bedah-tipe-data-seluruh-program)
3. [Bedah Fitur yang Dikerjakan (Menu 4, 5, 6)](#3-bedah-fitur-yang-dikerjakan-menu-4-5-6)
4. [Bedah Fitur Bawaan & Fungsi Bantu (Menu 1, 2, 3)](#4-bedah-fitur-bawaan--fungsi-bantu-menu-1-2-3)
5. [Konsep Pemrograman Dart Penting](#5-konsep-pemrograman-dart-penting)
6. [Simulasi Tanya Jawab (Q&A) dengan Dosen](#6-simulasi-tanya-jawab-qa-dengan-dosen)
7. [Skenario Demo saat Presentasi](#7-skenario-demo-saat-presentasi)

---

## 1. Arsitektur & Struktur File

Aplikasi ini dibangun menggunakan bahasa pemrograman Dart dengan membagi tanggung jawab ke dalam 4 file modular:

| Nama File | Peran & Tanggung Jawab |
|---|---|
| `main.dart` | Titik masuk utama program (*entry point*), mengatur perulangan antarmuka menu CLI dan menangani pemilihan opsi pengguna (0–6). |
| `data.dart` | Menyimpan struktur data model, enum status kehadiran, data inisial mahasiswa, serta data riwayat absensi. |
| `input.dart` | Menyediakan fungsi pembacaan dan validasi input dari keyboard (`bacaTeks`, `bacaInt`, `bacaDouble`) agar kebal dari crash akibat input yang salah. |
| `fitur.dart` | Berisi seluruh logika fungsional sistem, baik fungsi bantu, fitur bawaan (Menu 1–3), maupun fitur baru yang dikembangkan (Menu 4–6). |

---

## 2. Bedah Tipe Data Seluruh Program

Berikut adalah rincian tipe data variabel dan koleksi yang digunakan dalam sistem:

### A. Tabel Tipe Data
| Nama Variabel / Objek | Tipe Data | Penjelasan Mendalam |
|---|---|---|
| `StatusHadir` | `enum` | **Enumerasi**. Mewakili 4 status absensi tetap: `hadir`, `izin`, `sakit`, `alpa`. Memberikan *type safety* agar tidak ada status di luar 4 nilai ini. |
| `daftarMahasiswa` | `List<Map<String, dynamic>>` | **List of Map**. Daftar kumpulan data mahasiswa. Setiap mahasiswa direpresentasikan sebagai sebuah `Map` dengan key berupa `String` (`'nim'` dan `'nama'`). |
| `'nim'` | `String` | Nomor Induk Mahasiswa disimpan dalam bentuk teks karena tidak diproses dalam perhitungan aritmatika dan menjaga angka `0` di awal jika ada. |
| `'nama'` | `String` | Nama mahasiswa berupa teks. |
| `absensi` | `Map<int, Map<String, StatusHadir>>` | **Nested Map (Map 2 Dimensi)**:<br>• **Key Luar (`int`)**: Nomor pertemuan (1, 2, 3, dst).<br>• **Key Dalam (`String`)**: NIM mahasiswa.<br>• **Value (`StatusHadir`)**: Status kehadiran pada pertemuan tersebut. |
| `berjalan` | `bool` | Flag boolean (`true`/`false`) untuk mengontrol jalannya perulangan `while` pada menu utama. |
| `pilihan` | `int` | Pilihan angka menu yang diinputkan pengguna (0 sampai 6). |
| `nomor` | `int` | Nomor urut pertemuan absensi. |
| `kataKunci` | `String` | Teks input untuk pencarian nama mahasiswa. |

### B. Mengapa Memakai Struktur `Map<int, Map<String, StatusHadir>>`?
Struktur ini memungkinkan pencarian status absensi seorang mahasiswa pada pertemuan tertentu berjalan instan dengan kompleksitas waktu $O(1)$:
```dart
final statusCitraPertemuan4 = absensi[4]!['2401003'];
```
Jika menggunakan `List` di dalam `List`, sistem harus melakukan pencarian linear ($O(n \times m)$) yang jauh lebih lambat dan rumit.

---

## 3. Bedah Fitur yang Dikerjakan (Menu 4, 5, 6)

Fitur-fitur inilah yang kamu kembangkan untuk memenuhi tugas UTS:

### A. Menu 4: Tambah Mahasiswa (`tambahMahasiswa`)
```dart
void tambahMahasiswa() {
  print('\n=== Tambah Mahasiswa ===');
  final nim = bacaTeks('NIM');

  // Validasi: tolak jika NIM sudah terdaftar
  if (cariByNim(nim) != null) {
    print('Mahasiswa dengan NIM $nim sudah terdaftar.');
    return;
  }

  final nama = bacaTeks('Nama');
  daftarMahasiswa.add({'nim': nim, 'nama': nama});
  print('Mahasiswa $nama berhasil ditambahkan.');
}
```
* **Logika Kerja:**
  1. Membaca NIM dari pengguna melalui `bacaTeks('NIM')`.
  2. Mengecek apakah NIM sudah ada dengan fungsi `cariByNim(nim)`.
  3. **Integritas Data:** Jika NIM sudah terdaftar, tampilkan pesan peringatan dan langsung `return` (membatalkan penambahan).
  4. Jika NIM baru, membaca Nama pengguna dan menyimpannya ke `daftarMahasiswa` via `.add()`.
  5. Menampilkan pesan konfirmasi keberhasilan.

---

### B. Menu 5: Cari Mahasiswa Berdasarkan Nama (`cariMahasiswa`)
```dart
void cariMahasiswa() {
  print('\n=== Cari Mahasiswa ===');
  if (daftarMahasiswa.isEmpty) {
    print('Belum ada data mahasiswa.');
    return;
  }

  final kataKunci = bacaTeks('Nama').toLowerCase();
  final hasil = daftarMahasiswa.where((mhs) {
    final nama = (mhs['nama'] as String).toLowerCase();
    return nama.contains(kataKunci);
  }).toList();

  if (hasil.isEmpty) {
    print('Mahasiswa dengan nama "$kataKunci" tidak ditemukan.');
    return;
  }

  for (final mhs in hasil) {
    cetakMahasiswa(mhs);
  }
}
```
* **Logika Kerja:**
  1. Validasi awal: mengecek apakah ada mahasiswa yang terdaftar (`daftarMahasiswa.isEmpty`).
  2. Membaca kata kunci dan mengubahnya menjadi huruf kecil (`.toLowerCase()`).
  3. Menggunakan fungsi tingkat tinggi `.where()` untuk menyaring daftar mahasiswa.
  4. Pencarian bersifat *partial match* menggunakan method `.contains()` dan tidak membedakan huruf besar/kecil (*case-insensitive*).
  5. Jika hasil penyaringan kosong, tampilkan pesan informatif. Jika ada, cetak setiap mahasiswa dengan `cetakMahasiswa()`.

---

### C. Menu 6: Ubah Status Absensi (`ubahStatus`)
```dart
void ubahStatus() {
  print('\n=== Ubah Status Absensi ===');
  if (absensi.isEmpty) {
    print('Belum ada absensi.');
    return;
  }

  final nomor = bacaInt('Nomor pertemuan', min: 1, max: absensi.length);
  final nim = bacaTeks('NIM');

  // Validasi: periksa apakah mahasiswa terdaftar
  final mhs = cariByNim(nim);
  if (mhs == null) {
    print('Mahasiswa dengan NIM $nim tidak ditemukan.');
    return;
  }

  final statusBaru = bacaStatus('Status baru');
  absensi[nomor]![nim] = statusBaru;
  print(
    'Status ${mhs['nama']} pada pertemuan $nomor diubah menjadi ${statusBaru.name}.',
  );
}
```
* **Logika Kerja:**
  1. Validasi apakah ada riwayat absensi (`absensi.isEmpty`).
  2. Meminta nomor pertemuan dengan batasan valid `1` hingga `absensi.length`.
  3. Meminta NIM dan memverifikasi apakah mahasiswa ada di database kelas menggunakan `cariByNim(nim)`.
  4. Jika mahasiswa ditemukan, meminta status baru via `bacaStatus('Status baru')` (1=hadir, 2=izin, 3=sakit, 4=alpa).
  5. Memperbarui status pada nested map: `absensi[nomor]![nim] = statusBaru;`.
  6. Menampilkan pesan sukses pembaruan status.

---

## 4. Bedah Fitur Bawaan & Fungsi Bantu (Menu 1, 2, 3)

### A. Fungsi Bantu
- **`cariByNim(String nim)`**: Menerima NIM dan mengembalikan objek `Map<String, dynamic>?` (bisa bernilai `null` jika tidak ditemukan). Menggunakan *sequential search* / perulangan `for-in`.
- **`cetakMahasiswa(Map<String, dynamic> mhs)`**: Mencetak format string `'NIM | Nama'`.
- **`bacaStatus(String label)`**: Membaca angka 1–4 dan mengonversinya menjadi nilai enum `StatusHadir` menggunakan *Switch Expression*.

### B. Fitur 1: `tampilkanDaftar()`
Melakukan perulangan `for-in` pada koleksi `daftarMahasiswa` dan memanggil `cetakMahasiswa(mhs)`.

### C. Fitur 2: `catatAbsensi()`
Membuat nomor pertemuan baru (`absensi.length + 1`), lalu meminta input status kehadiran untuk setiap mahasiswa terdaftar satu per satu.

### D. Fitur 3: `tampilkanAbsensiPertemuan()`
Mengambil data absensi pada pertemuan tertentu (`absensi[nomor]!`) dan mencetak status setiap mahasiswa. Jika seorang mahasiswa baru ditambahkan dan belum memiliki status pada pertemuan lama, kode `status?.name ?? '-'` akan mencetak tanda strip (`-`).

---

## 5. Konsep Pemrograman Dart Penting

Dosen penguji kerap menanyakan konsep-konsep inti Dart:

### A. Null Safety (`?`, `!`, dan `??`)
1. **Nullable Type (`?`)**:
   - Menandakan suatu variabel/fungsi boleh bernilai `null`.
   - Contoh: `Map<String, dynamic>? cariByNim(...)` -> jika tidak ketemu, return `null`.
2. **Null Assertion Operator (`!`)**:
   - Menegaskan kepada compiler bahwa objek tersebut dijamin **tidak null** pada saat runtime.
   - Contoh: `absensi[nomor]!` -> karena `nomor` sudah divalidasi antara 1 s/d `absensi.length`, maka pertemuan tersebut pasti ada.
3. **If-Null Operator (`??`)**:
   - Memberikan nilai cadangan jika ekspresi di sebelah kirinya bernilai `null`.
   - Contoh: `status?.name ?? '-'` -> jika status `null`, tampilkan `'-'`.

### B. Enum vs Tipe Data Primitif (String / int)
- Mengapa memakai `enum StatusHadir` daripada `String 'hadir'`?
  - **Type Safety**: Menghindari bug akibat salah ketik (*typo*). Compiler akan langsung memberi error jika ada status di luar yang didefinisikan.
  - **Efisiensi**: Enum dievaluasi sebagai referensi konstan yang cepat dibanding perbandingan string.

### C. `final` vs `const`
- `const batasKehadiran = 75;`: Nilai konstanta kompilasi (*compile-time constant*), nilainya mutlak tidak bisa berubah.
- `final daftarMahasiswa = [...]`: Variabel tidak dapat di-*reassign* ke list lain (`daftarMahasiswa = []` akan error), tetapi konten di dalam list tersebut masih dapat dimodifikasi (bisa `.add()`).

### D. Switch Expression (Fitur Modern Dart 3)
```dart
return switch (pilihan) {
  1 => StatusHadir.hadir,
  2 => StatusHadir.izin,
  3 => StatusHadir.sakit,
  _ => StatusHadir.alpa,
};
```
- Tanda panah `=>` adalah pemetaan langsung nilai ekspresi.
- Tanda *underscore* `_` adalah **wildcard pattern** (berperan sama seperti `default:` pada switch-case biasa).

---

## 6. Simulasi Tanya Jawab (Q&A) dengan Dosen

Berikut adalah pertanyaan yang paling sering diajukan saat demo kode:

### Q1: "Coba jelaskan alur logika saat fungsi `tambahMahasiswa` dijalankan!"
> **Jawaban:**
> *"Ketika menu 4 dipilih, sistem pertama-tama meminta input NIM dari pengguna. Selanjutnya, sistem memanggil fungsi bantu `cariByNim(nim)`. Jika fungsi mengembalikan nilai bukan `null`, artinya NIM tersebut sudah dipakai oleh mahasiswa lain, sehingga program mencetak pesan penolakan dan langsung `return`. Jika NIM belum terdaftar, sistem akan meminta input Nama mahasiswa, kemudian menambahkan Map `{'nim': nim, 'nama': nama}` ke dalam `daftarMahasiswa` menggunakan method `.add()`."*

---

### Q2: "Mengapa pencarian nama di `cariMahasiswa` bisa menemukan nama meskipun pengguna mengetik huruf kecil semua?"
> **Jawaban:**
> *"Karena kami melakukan standardisasi teks menjadi huruf kecil terlebih dahulu. Input pencarian dari pengguna diubah dengan `.toLowerCase()`, dan saat memfilter dengan method `.where()`, properti nama mahasiswa juga diubah sementara menjadi huruf kecil dengan `(mhs['nama'] as String).toLowerCase()`. Setelah keduanya sama-sama berformat huruf kecil, kami gunakan method `.contains()` untuk mencocokkan kemunculan teks."*

---

### Q3: "Bagaimana cara kerja pengubahan status pada fungsi `ubahStatus`?"
> **Jawaban:**
> *"Data absensi kami bertipe nested map `Map<int, Map<String, StatusHadir>>`. Pada fungsi `ubahStatus`, pertama kami meminta nomor pertemuan dan NIM mahasiswa. Setelah mahasiswa dipastikan terdaftar melalui `cariByNim(nim)`, kami membaca status baru dari input keyboard (1–4) yang menghasilkan objek enum `StatusHadir`. Terakhir, status lama ditimpa dengan sintaks: `absensi[nomor]![nim] = statusBaru;`."*

---

### Q4: "Apa yang terjadi jika mahasiswa yang baru saja ditambahkan di Menu 4 dicek absensinya pada Pertemuan 1 di Menu 3?"
> **Jawaban:**
> *"Mahasiswa tersebut akan tetap muncul dalam daftar pertemuan 1, tetapi statusnya akan menampilkan tanda strip (`-`). Hal ini terjadi karena NIM mahasiswa baru tersebut belum ada di dalam Map absensi pertemuan 1 (nilainya `null`). Di fungsi `tampilkanAbsensiPertemuan()`, kami menggunakan operator null-aware `status?.name ?? '-'`, sehingga nilai `null` secara elegan digantikan dengan tanda strip."*

---

### Q5: "Mengapa data yang baru ditambahkan hilang setelah program dimatikan?"
> **Jawaban:**
> *"Karena aplikasi ini beroperasi secara in-memory (di memori RAM) sesuai spesifikasi soal UTS. Variabel disimpan di dalam memori kerja aplikasi selama proses eksekusi berlangsung dan tidak disimpan ke media penyimpanan permanen (seperti basis data SQL atau file JSON)."*

---

## 7. Skenario Demo saat Presentasi

Untuk menunjukkan bahwa seluruh fitur berfungsi optimal dan bebas bug, ikuti urutan demonstrasi berikut:

1. **Jalankan Aplikasi**:
   ```bash
   dart run main.dart
   ```
2. **Demo Menu 1 (Lihat Daftar)**:
   - Pilih menu `1`. Tunjukkan 4 data awal (Andi, Budi, Citra, Dewi).
3. **Demo Menu 4 (Tambah Mahasiswa - Sukses & Validasi)**:
   - Pilih menu `4`.
   - Masukkan NIM: `2401005`, Nama: `Fajar`. Tunjukkan pesan sukses.
   - Pilih menu `1` lagi untuk membuktikan "Fajar" sudah masuk ke daftar.
   - Pilih menu `4` lagi, masukkan NIM: `2401001` (NIM Andi yang sudah ada). Tunjukkan bahwa sistem **menolak** duplikasi NIM.
4. **Demo Menu 5 (Cari Mahasiswa)**:
   - Pilih menu `5`.
   - Masukkan kata kunci: `di` (huruf kecil).
   - Tunjukkan bahwa sistem berhasil menampilkan `Andi` dan `Budi`.
5. **Demo Menu 6 (Ubah Status Absensi)**:
   - Pilih menu `3`, lihat pertemuan `4` (Citra awalnya berstatus `izin`).
   - Pilih menu `6`.
   - Nomor pertemuan: `4`, NIM: `2401003`, Status baru: `1` (hadir).
   - Buka kembali menu `3` pertemuan `4` untuk membuktikan status Citra telah berubah menjadi `hadir`.
6. **Demo Menu 0 (Keluar)**:
   - Pilih menu `0`. Program selesai dengan pesan *"Terima kasih"*.
