# Liman MYS 2.0 Otomasyon Betiği

## Zübeyir Berkay Küçük - 210707088

```bash
    $$\       $$\
    $$ |      \__|
    $$ |      $$\ $$$$$$\$$$$\   $$$$$$\  $$$$$$$\
    $$ |      $$ |$$  _$$  _$$\  \____$$\ $$  __$$\
    $$ |      $$ |$$ / $$ / $$ | $$$$$$$ |$$ |  $$ |
    $$ |      $$ |$$ | $$ | $$ |$$  __$$ |$$ |  $$ |
    $$$$$$$$\ $$ |$$ | $$ | $$ |\$$$$$$$ |$$ |  $$ |
    \________|\__|\__| \__| \__| \_______|\__|  \__|
    Liman MYS 2.0 Otomasyon Scripti

```

## Açıklama

Bu Bash betiği, Liman MYS 2.0'nin kurulumu, kaldırılması ve yönetimi için tasarlanmıştır. Kurulum, kaldırma, şifre sıfırlama, servis durumu kontrolü, veritabanı yedekleme ve geri yükleme, uygulama anahtarı alımı gibi özellikleri içermektedir.

## Önkoşullar

- Bu betiğin çalıştırılması için `sudo` yetkileri gereklidir.
- Sisteminizde gerekli bağımlılıkların karşılandığından emin olun.

## Kurulum

Betiği kullanmak için aşağıdaki adımları takip edin:

1. Depoyu klonlayın:

    ```bash
    git clone https://github.com/0xberkay/AtaUni-Proje-Liman
    cd AtaUni-Proje-Liman
    ```

2. Betiğe çalıştırma izni verin:

    ```bash
    chmod +x liman_installer.sh
    ```

3. Betiği istediğiniz komut ile çalıştırın:

    ```bash
    sudo ./liman_installer.sh [komut] [seçenekler]
    ```

    `[komut]` yerine aşağıdaki komutlardan birini kullanın:
    - `kur`: Liman MYS 2.0'ı kurun.
    - `kaldir`: Liman MYS 2.0'ı kaldırın.
    - `administrator`: Yönetici şifresini sıfırlayın.
    - `reset`: Liman MYS 2.0'ı kaldırın ve yeniden kurun.
    - `help`: Yardım mesajını görüntüleyin.
    - `print_all_logs`: Tüm logları ekrana yazdırın.
    - `check_services`: Liman MYS 2.0 servislerinin durumunu kontrol edin.
    - `reset_services`: Liman MYS 2.0 servislerini yeniden başlatın.
    - `backup_database`: Veritabanını yedekleyin. Parametre olarak yedek dosyasının kaydedileceği dizini alır.
    - `restore_database`: Veritabanını yedekten geri yükleyin. Parametre olarak yedek dosyasının adını alır.
    - `get_app_key`: App key'i alın ve dosyaya kaydedin. Parametre olarak dosya adını alır.

    `[seçenekler]` belli komutlarda gerekli olabilir. Detaylar için Kullanım bölümüne bakın.

## Kullanım

1. Liman MYS 2.0'ı kurun:

    ```bash
    sudo ./liman_installer.sh kur
    ```

2. Liman MYS 2.0'ı kaldırın:

    ```bash
    sudo ./liman_installer.sh kaldir
    ```

3. Yönetici şifresini sıfırlayın:

    ```bash
    sudo ./liman_installer.sh administrator
    ```

4. Yardım mesajını görüntüleyin:

    ```bash
    sudo ./liman_installer.sh yardim
    ```
5. Tüm logları ekrana yazdırın:

    ```bash
    sudo ./liman_installer.sh print_all_logs
    ```
6. Liman MYS 2.0 servislerinin durumunu kontrol edin:

    ```bash
    sudo ./liman_installer.sh check_services
    ```
7. Liman MYS 2.0 servislerini yeniden başlatın:

    ```bash
    sudo ./liman_installer.sh reset_services
    ```
8. Veritabanını yedekleyin:

    ```bash
    sudo ./liman_installer.sh backup_database /home/liman/backup.sql
    ```
9. Veritabanını yedekten geri yükleyin:

    ```bash
    sudo ./liman_installer.sh restore_database /home/liman/backup.sql
    ```
10. App key'i alın ve dosyaya kaydedin:

    ```bash
    sudo ./liman_installer.sh get_app_key /home/liman/app_key.txt
    ```


---
