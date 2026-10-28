# UTS: 02 Absensi Kelas

Aplikasi console untuk mencatat kehadiran mahasiswa di setiap pertemuan.

Sebagian fitur **sudah jadi**. Tugas kamu adalah **melanjutkan aplikasi ini** dengan membuat fitur yang belum tersedia.

## Ketentuan

- Dikerjakan **individu**.
- Pilih **minimal 3 fitur** dari daftar fitur pilihan di bawah. Tingkatnya bebas.
- Kerjakan di `fitur.dart`, pada fungsi yang bertanda `// TODO`. Hapus baris `print('Fitur belum tersedia.');` setelah fiturnya kamu buat.
- Kamu boleh menambah fungsi bantu sendiri.
- Hasilnya dipresentasikan di **pertemuan #8**: jalankan programnya, tunjukkan fitur yang kamu buat, dan jelaskan kodenya.

## Cara menjalankan

```bash
dart run main.dart
```

Data hanya disimpan di memori. Setelah program ditutup, data kembali seperti semula.

## Struktur file

| File | Isi |
| --- | --- |
| `main.dart` | Menu utama |
| `data.dart` | Enum `StatusHadir`, data mahasiswa, absensi 4 pertemuan, dan batas kehadiran |
| `input.dart` | Fungsi membaca input keyboard: `bacaTeks()`, `bacaInt()`, `bacaDouble()` |
| `fitur.dart` | Semua fitur. **Bagian yang kamu kerjakan ada di sini.** |

## Bentuk data absensi

```dart
// nomor pertemuan -> (NIM -> status)
final Map<int, Map<String, StatusHadir>> absensi = {
  1: {'2401001': StatusHadir.hadir, '2401002': StatusHadir.hadir, ...},
  2: {...},
};
```

Contoh: `absensi[2]!['2401002']` berisi status Budi di pertemuan 2. Mahasiswa yang ditambahkan belakangan tidak punya status di pertemuan sebelumnya (hasilnya `null`).

## Fitur yang sudah jadi

| Menu | Fitur | Fungsi |
| --- | --- | --- |
| 1 | Lihat daftar mahasiswa | `tampilkanDaftar()` |
| 2 | Catat absensi pertemuan baru | `catatAbsensi()` |
| 3 | Lihat absensi per pertemuan | `tampilkanAbsensiPertemuan()` |

Pelajari fitur ini dulu. Fungsi bantu `cariByNim()`, `cetakMahasiswa()`, dan `bacaStatus()` bisa kamu pakai lagi.

## Fitur pilihan

| Menu | Fitur | Tingkat | Fungsi |
| --- | --- | --- | --- |
| 4 | Tambah mahasiswa | Mudah | `tambahMahasiswa()` |
| 5 | Cari mahasiswa berdasarkan nama | Mudah | `cariMahasiswa()` |
| 6 | Ubah status absensi | Sedang | `ubahStatus()` |
| 7 | Rekap per mahasiswa | Sedang | `tampilkanRekap()` |
| 8 | Persentase kehadiran | Sulit | `tampilkanPersentase()` |
| 9 | Mahasiswa di bawah batas kehadiran | Sulit | `tampilkanDiBawahBatas()` |

Semua contoh output di bawah memakai data awal.

### Menu 4 — Tambah mahasiswa (Mudah)

Tolak jika NIM sudah terdaftar.

```
=== Tambah Mahasiswa ===
NIM: 2401005
Nama: Fajar
Mahasiswa Fajar berhasil ditambahkan.
```

### Menu 5 — Cari mahasiswa (Mudah)

Tampilkan semua mahasiswa yang namanya mengandung kata kunci. Huruf besar dan kecil tidak dibedakan.

```
=== Cari Mahasiswa ===
Nama: di
2401001 | Andi
2401002 | Budi
```

### Menu 6 — Ubah status absensi (Sedang)

```
=== Ubah Status Absensi ===
Nomor pertemuan: 4
NIM: 2401003
Status baru (1=hadir, 2=izin, 3=sakit, 4=alpa): 1
Status Citra pada pertemuan 4 diubah menjadi hadir.
```

### Menu 7 — Rekap per mahasiswa (Sedang)

Jumlah hadir, izin, sakit, dan alpa setiap mahasiswa dari semua pertemuan.

```
=== Rekap Absensi (4 pertemuan) ===
Andi | hadir 4 | izin 0 | sakit 0 | alpa 0
Budi | hadir 3 | izin 1 | sakit 0 | alpa 0
Citra | hadir 2 | izin 1 | sakit 1 | alpa 0
Dewi | hadir 1 | izin 0 | sakit 0 | alpa 3
```

### Menu 8 — Persentase kehadiran (Sulit)

Persentase = jumlah hadir / jumlah pertemuan × 100, dengan 1 angka di belakang koma.

```
=== Persentase Kehadiran ===
Andi | 4/4 pertemuan | 100.0%
Budi | 3/4 pertemuan | 75.0%
Citra | 2/4 pertemuan | 50.0%
Dewi | 1/4 pertemuan | 25.0%
```

### Menu 9 — Di bawah batas kehadiran (Sulit)

Tampilkan mahasiswa dengan persentase kehadiran **kurang dari** `batasKehadiran` (75%). Budi tepat 75%, jadi tidak termasuk.

```
=== Kehadiran di Bawah 75% ===
Citra | 50.0%
Dewi | 25.0%
```
