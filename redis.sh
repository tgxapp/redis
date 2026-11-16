#!/bin/bash

# Memastikan skrip dijalankan dengan hak akses root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan skrip ini sebagai root atau dengan sudo"
  exit
fi

# Fungsi untuk mencetak pesan sebelum menjalankan perintah
run_command() {
  echo "Menjalankan: $1"
  eval "$1"
  echo "Selesai: $1"
  echo
}

# 1. Memasang redis-server
run_command "sudo apt update"
run_command "sudo apt upgrade -y"
run_command "sudo apt install redis-server -y"

# 2. Copy file konfigurasi dari folder kerja ke sistem
run_command "sudo cp redis.conf /etc/redis/redis.conf"
run_command "sudo cp redis-server.service /lib/systemd/system/redis-server.service"

# 3. OTOMATISASI: Modifikasi file yang SUDAH ADA di dalam /etc/redis/
echo "Mengonfigurasi batas memori Redis (1GB)..."
sudo sed -i '/^maxmemory/d' /etc/redis/redis.conf
echo "maxmemory 1gb" | sudo tee -a /etc/redis/redis.conf
echo "maxmemory-policy allkeys-lru" | sudo tee -a /etc/redis/redis.conf

# 4. Reload dan restart service
run_command "sudo systemctl daemon-reload"
run_command "sudo systemctl restart redis-server"
run_command "sudo systemctl restart redis.service"

# 5. Mengatur zona waktu ke Asia/Jakarta
run_command "sudo timedatectl set-timezone Asia/Jakarta"

# 6. Menampilkan waktu sistem
run_command "timedatectl"

# 7. VERIFIKASI KONFIGURASI REDIS
echo "=================================================="
echo "Memverifikasi konfigurasi memori Redis..."
echo "=================================================="
# Cek maxmemory (harusnya 1073741824 bytes atau 1gb)
redis-cli config get maxmemory
# Cek kebijakan eviction (harusnya allkeys-lru)
redis-cli config get maxmemory-policy
echo "=================================================="

echo "Semua langkah telah selesai."
