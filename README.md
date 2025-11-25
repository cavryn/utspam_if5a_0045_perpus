# 📚 Aplikasi Peminjaman Buku – Flutter

Aplikasi ini merupakan proyek UTS yang dibuat menggunakan **Flutter** dengan konsep **Local Storage (shared_preferences)** sebagai penyimpanan data. Aplikasi ini mensimulasikan sistem peminjaman buku dengan fitur login, register, peminjaman buku, riwayat, detail transaksi, dan profil pengguna.

---

## 🚀 Fitur Utama

### 🔐 **1. Register & Login**
- Pengguna dapat membuat akun baru
- Validasi input (NIM, email, nomor telepon, password)
- Data akun disimpan menggunakan `shared_preferences`
- Sistem sesi login (auto login setelah berhasil)

---

### 🏠 **2. Home Page**
Menampilkan menu utama:
- Daftar Buku
- Form Peminjaman
- Riwayat Peminjaman
- Profil Pengguna
- Logout

---

### 📚 **3. Daftar Buku**
Berisi beberapa buku dummy dengan data:
- Judul
- Genre
- Harga pinjam per hari
- Cover buku
- Sinopsis

---

### 📝 **4. Form Peminjaman**
- Pilih buku yang ingin dipinjam
- Pilih tanggal pinjam dan kembali
- Total biaya dihitung otomatis
- Data transaksi disimpan ke `shared_preferences`

---

### 📜 **5. Riwayat Peminjaman**
Menampilkan seluruh transaksi yang sudah dibuat:
- Judul buku
- Lama pinjam
- Total biaya
- Aksi menuju halaman detail

---

### 🔍 **6. Halaman Detail Peminjaman**
Menampilkan informasi lengkap:
- Cover buku
- Data peminjam
- Data tanggal
- Total biaya  
Terdapat fitur:
- Edit transaksi
- Cancel transaksi

---

### 👤 **7. Profil Pengguna**
Menampilkan data user:
- Nama
- Email
- NIM
- Username
- Alamat
- Nomor HP

---

## 🏗 **Screenshoot**

<img width="459" height="895" alt="image" src="https://github.com/user-attachments/assets/abfba112-d8a4-49c5-9174-4051128db0e5" />


