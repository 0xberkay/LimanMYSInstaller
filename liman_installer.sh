#!/bin/bash

# Bu betik, Liman MYS 2.0'nin kurulumu, kaldırılması ve yönetimi için kullanılır.
# Liman MYS 2.0'nin kurulumunu, kaldırılmasını, yönetici parolasını sıfırlamayı,
# servis durumlarını kontrol etmeyi, veritabanını yedeklemeyi ve geri yüklemeyi,
# uygulama anahtarını almayı sağlayan işlevleri sağlar.
# Betik ayrıca günlük tutma ve sudo yetkilerini kontrol etme yardımcı işlevlerini içerir.
# Betiği kullanmak için, çalıştırırken bir komutu argüman olarak geçirin.
# Örneğin: ./liman_installer.sh kur (Liman MYS 2.0'ı kurmak için)
# Kullanılabilir komutların listesi için 'yardım' komutunu kullanın.
# Not: Bu betiğin çalıştırılması için sudo yetkilerine ihtiyaç vardır.

log_file="liman_installation.log"
liman_deb="liman-2.0-RC2-863.deb"

# ANSI renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Bir mesajı bir dosyaya ve standart çıktıya kaydetmek için işlev
function log() {
    local message="$1"
    local is_error="$2"
    local timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
    
    # Log dosyasına yaz
    echo "$timestamp $message" >> "$log_file"
    
    # Standart çıktıya yaz
    if [ "$is_error" = true ]; then
        echo -e "${RED}$message${NC}"
    else
        echo -e "${GREEN}$message${NC}"
    fi
}

# Betiğin sudo yetkileriyle çalıştırılıp çalıştırılmadığını kontrol etmek için işlev
function check_sudo() {
    if [ "$(id -u)" -ne 0 ]; then
        log "HATA: Bu betiğin çalıştırılması için sudo yetkisi gereklidir. Lütfen sudo ile tekrar deneyin." true
        exit 1
    fi
}

# Liman MYS 2.0'ı kurmak için işlev
function install_liman() {
    log "Liman MYS 2.0 kurulumu başlatılıyor..."
    NODE_MAJOR=18
    
    # NodeJS deposunu ekle
    log "NodeJS deposu ekleniyor..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    if sudo apt-get update; then
        log "NodeJS deposu başarıyla eklendi."
    else
        log "HATA: NodeJS deposu eklenemedi." true
        exit 1
    fi
    
    # PHP deposunu ekle
    log "PHP deposu ekleniyor..."
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    if sudo apt-get update; then
        log "PHP deposu başarıyla eklendi."
    else
        log "HATA: PHP deposu eklenemedi." true
        exit 1
    fi
    
    # PostgreSQL deposunu ekle
    log "PostgreSQL deposu ekleniyor..."
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > pgsql.gpg
    sudo mv pgsql.gpg /etc/apt/trusted.gpg.d/pgsql.gpg
    
    # Liman MYS 2.0'ı indir ve kur
    log "Liman MYS 2.0 indiriliyor ve kuruluyor..."
    sudo apt update
    wget https://github.com/limanmys/core/releases/download/release.feature-new-ui.863/"$liman_deb"
    
    # .deb dosyası için izinleri ayarla
    sudo chmod +x ./"$liman_deb"
    
    sudo apt install ./"$liman_deb"
    
    # .deb dosyasını kaldır
    if [ -f "$liman_deb" ]; then
        log ".deb dosyası temizleniyor..."
        rm -f "$liman_deb"
    else
        log "HATA: .deb dosyası bulunamadı."
    fi
    
    log "Liman MYS 2.0 kurulumu tamamlandı."
}

# Liman MYS 2.0'ı kaldırmak için işlev
function uninstall_liman() {
    log "Liman MYS 2.0 kaldırılıyor..."
    sudo apt-get remove --purge liman
    sudo apt-get autoremove
    log "Liman MYS 2.0 kaldırma işlemi tamamlandı."
}

# Yönetici parolasını sıfırlamak için işlev
function reset_admin_password() {
    log "Admin kullanıcısı için yeni parola oluşturuluyor..."
    sudo limanctl reset administrator@liman.dev
    log "Yeni parola oluşturuldu."
}

function logo() {
    echo -e "${BLUE}"
    cat << "EOF"
    $$\       $$\
    $$ |      \__|
    $$ |      $$\ $$$$$$\$$$$\   $$$$$$\  $$$$$$$\
    $$ |      $$ |$$  _$$  _$$\  \____$$\ $$  __$$\
    $$ |      $$ |$$ / $$ / $$ | $$$$$$$ |$$ |  $$ |
    $$ |      $$ |$$ | $$ | $$ |$$  __$$ |$$ |  $$ |
    $$$$$$$$\ $$ |$$ | $$ | $$ |\$$$$$$$ |$$ |  $$ |
    \________|\__|\__| \__| \__| \_______|\__|  \__|
EOF
echo -e "Liman MYS 2.0 Otomasyon Scripti\n${NC}"
}

# Yardım mesajını yazdırmak için işlev
function print_help() {
    echo "Kullanım: ./liman_installer.sh [command] [options]"
    echo "  kur: Liman MYS 2.0'ı kurar."
    echo "  kaldir: Liman MYS 2.0'ı kaldırır."
    echo "  administrator: Admin kullanıcısı için yeni parola oluşturur."
    echo "  reset: Liman MYS 2.0'ı kaldırır ve tekrar kurar."
    echo "  help: Bu yardım mesajını gösterir."
    echo "  print_all_logs: Tüm logları ekrana yazdırır."
    echo "  check_services: Liman MYS 2.0 servislerinin durumunu kontrol eder."
    echo "  reset_services: Liman MYS 2.0 servislerini yeniden başlatır."
    echo "  backup_database: Veritabanını yedekler. Parametre olarak yedek dosyasının kaydedileceği dizini alır."
    echo "  restore_database: Veritabanını yedekten geri yükler. Parametre olarak yedek dosyasının adını alır."
    echo "  get_app_key: App key'i alır ve dosyaya kaydeder. Parametre olarak dosya adını alır."
    echo -e "${NC}"
}

# Tüm logları yazdırmak için işlev
function print_all_logs() {
    echo "Tüm loglar ekrana yazdırılıyor..."
    cat "$log_file"
}

# Kontrol edilecek servislerin dizisi
services=("liman-render" "liman-socket" "liman-system" "liman-ui")

# Servis durumlarını kontrol etmek için işlev
function check_services() {
    local status_codes=()
    
    for service in "${services[@]}"; do
        # Servis durumunu kontrol et
        if systemctl is-active --quiet "$service.service"; then
            status_codes+=("$service: aktif")
        else
            status_codes+=("$service: pasif")
        fi
    done
    
    # Durum kodlarını yazdır
    echo -e "${RED}Servis Durumları:${NC}"
    for status_code in "${status_codes[@]}"; do
        echo -e "${GREEN}$status_code${NC}"
    done
}

# Servisleri sıfırlamak için işlev
function reset_services() {
    for service in "${services[@]}"; do
        # Servisi yeniden başlat
        systemctl restart "$service.service"
    done
    
    log "Liman MYS 2.0 servisleri yeniden başlatıldı."
}

# Veritabanını yedeklemek için işlev
function backup_database() {
    local db_password=$(cat /liman/server/.env | grep DB_PASSWORD | cut -d"=" -f2)
    local backup_path="$1"
    
    [ -z "$db_password" ] && log "HATA: Veritabanı parolası bulunamadı." true && exit 1
    [ -z "$backup_path" ] && log "Yedek dosyası adı belirtilmedi. Varsayılan ad kullanılacak." && backup_path="/opt/liman-yedek.sql"
    
    log "Veritabanı yedekleme işlemi başlatılıyor..."
    
    pg_dump --dbname=postgresql://liman:"$db_password"@127.0.0.1:5432/liman > "$backup_path"
    
    log "Veritabanı yedekleme işlemi tamamlandı. Yedek dosyası: $backup_path"
}

# Veritabanını geri yüklemek için işlev
function restore_database() {
    local liman_db_backup="$1"
    [ -z "$1" ] && log "HATA: Yedek dosyası adı belirtilmedi. Varsayılan ad kullanılacak." && liman_db_backup="/opt/liman-yedek.sql"
    [ ! -f "$liman_db_backup" ] && log "HATA: Yedek dosyası bulunamadı." true && exit 1
    
    log "Veritabanı geri yükleme işlemi başlatılıyor..."
    local password=$(cat /liman/server/.env | grep DB_PASSWORDs | cut -d"=" -f2)
    
    # Servisleri durdur
    for service in "${services[@]}"; do
        systemctl stop "$service.service"
    done
    
    # Veritabanını sıfırla
    sudo psql -U postgres -c "drop database liman" --dbname=postgresql://liman:"$password"@localhost:5432/liman
    
    log "Veritabanı sıfırlandı."
    
    # Veritabanını geri yükle
    psql -f "$liman_db_backup" --dbname=postgresql://liman:"$password"@localhost:5432/liman
}

# App key'ini almak için işlev
function get_app_key() {
    local liman_app_key_file="$1"
    [ -z "$1" ] && log "HATA: App Key dosyası adı belirtilmedi. Varsayılan ad kullanılacak." && liman_app_key_file="/opt/liman-app-key.txt"
    local app_key=$(cat /liman/server/.env | grep APP_KEY | cut -d"=" -f2)
    echo "$app_key" > "$liman_app_key_file"
    log "App Key başarıyla alındı ve '$liman_app_key_file' dosyasına kaydedildi."
}

# Sudo yetkilerini kontrol et
check_sudo

# Bir komutun sağlanıp sağlanmadığını kontrol et
if [ "$#" -eq 0 ]; then
    log "HATA: Lütfen bir komut girin. Yardım için './liman_installer.sh help' komutunu kullanın." true
    exit 1
fi

# Argümana göre komutu çalıştır
case "$1" in
    "kur")
        install_liman
    ;;
    "kaldir")
        uninstall_liman
    ;;
    "administrator")
        reset_admin_password
    ;;
    "reset")
        uninstall_liman
        install_liman
    ;;
    "help")
        logo
        print_help
    ;;
    "print_all_logs")
        print_all_logs
    ;;
    "check_services")
        check_services
    ;;
    "reset_services")
        reset_services
    ;;
    "backup_database")
        backup_database "$2"
    ;;
    "restore_database")
        restore_database "$2"
        reset_services
    ;;
    "get_app_key")
        get_app_key "$2"
    ;;
    *)
        log "Geçersiz komut! Lütfen './liman_installer.sh help' komutunu kullanarak yardım alın." true
        exit 1
    ;;
esac

exit 0
