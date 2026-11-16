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
# Update dan upgrade sistem
run_command "sudo apt update"
run_command "sudo apt upgrade -y"
run_command "sudo apt autoremove -y"

# Memasang software-properties-common dan menambahkan repository
run_command "sudo apt install software-properties-common -y"
run_command "sudo add-apt-repository ppa:deadsnakes/ppa -y"
run_command "sudo apt update"
run_command "sudo apt upgrade -y"

# Memasang virtual environment dan pip
run_command "sudo rm /etc/apt/apt.conf.d/50command-not-found"
run_command "sudo apt update"
run_command "sudo apt install -y python3-venv"
run_command "sudo apt install -y python3-pip"
run_command "python3 -m pip --version"

# Memasang build-essential dan paket lain
run_command "sudo apt-get update"
run_command "sudo apt-get install build-essential python3-dev -y"
run_command "sudo apt update"
run_command "sudo apt upgrade -y"
run_command "sudo apt install screen -y"
run_command "sudo apt install zip unzip -y"
run_command "sudo apt install rar unrar -y"

echo "Semua langkah telah selesai."
