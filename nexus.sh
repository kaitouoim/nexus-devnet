#!/bin/bash

# Warna untuk tampilan
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
BLUE='\033[1;34m'
LIGHT_BLUE='\033[0;36m'
GREEN='\033[1;32m'
LIGHT_GREEN='\033[0;92m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Menampilkan
show_logo() {
    echo -e "${LIGHT_GREEN}"
    echo " Buy me a coffee : 0x3d7b9825b152d24cc9bcc7cbb4dd20018db97ea5 "
    echo -e "${NC}"
    echo -e "${YELLOW}=========================================${NC}"
    echo -e "${LIGHT_GREEN} Kaitou Oim Custom Installer${NC}"
    echo -e "${WHITE} Repo: https://github.com/kaitouoim ${NC}"
    echo -e "${YELLOW}=========================================${NC}"
}

show_logo

# Fungsi untuk mencetak status
print_status() {
    echo -e "${BLUE}>>> $1...${NC}"
}

# Mengecek status perintah
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${LIGHT_GREEN}✔ $1 berhasil!${NC}"
    else
        echo -e "${RED}✘ $1 gagal!${NC}"
        exit 1
    fi
}

# Fungsi instalasi
install_custom() {
    print_status "Memperbarui sistem"
    sudo apt update && sudo apt upgrade -y
    check_status "Update sistem"

    print_status "Menginstal dependensi utama"
    sudo apt install -y screen build-essential pkg-config libssl-dev git unzip
    check_status "Instalasi dependensi"

    print_status "Menginstal Rust untuk pengembangan"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    check_status "Instalasi Rust"

    print_status "Mengatur environment Rust"
    source $HOME/.cargo/env
    check_status "Konfigurasi Rust"

    print_status "Menyiapkan swap 16GB untuk kinerja lebih optimal"
    sudo swapoff -a
    sudo fallocate -l 16G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    check_status "Swap berhasil dibuat"

    print_status "Instalasi selesai!"
    echo -e "${LIGHT_GREEN}Untuk mulai menggunakan Rust, jalankan perintah:${NC}"
    echo "source ~/.cargo/env"
}

# Fungsi uninstalasi
uninstall_custom() {
    print_status "Menghapus Rust dan dependensi"
    rustup self uninstall -y
    sudo apt remove --purge -y screen build-essential pkg-config libssl-dev git unzip
    sudo apt autoremove -y
    check_status "Rust dan dependensi dihapus"

    print_status "Menghapus swapfile"
    sudo swapoff /swapfile
    sudo rm -f /swapfile
    check_status "Swapfile dihapus"

    print_status "Uninstall selesai!"
}

# Menu interaktif
while true; do
    echo -e "\n${YELLOW}Pilih tindakan:${NC}"
    echo -e "${LIGHT_BLUE}1) Mulai instalasi Kaitou Oim Installer${NC}"
    echo -e "${RED}2) Uninstall Kaitou Oim Installer${NC}"
    echo -e "${RED}3) Keluar${NC}"
    read -p "Masukkan pilihan (1-3): " choice

    case $choice in
        1)
            install_custom
            break
            ;;
        2)
            uninstall_custom
            break
            ;;
        3)
            echo -e "${LIGHT_GREEN}Terima kasih, keluar...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid! Coba lagi.${NC}"
            ;;
    esac
done
