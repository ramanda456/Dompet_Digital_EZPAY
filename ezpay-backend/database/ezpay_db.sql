-- ================================================================
-- DATABASE EZ PAY - SKEMA LENGKAP
-- Dibuat untuk mendukung: Laravel Backend + Flutter Mobile App
-- Kompatibel: MySQL 5.7+ / MariaDB 10.4+
-- ================================================================

CREATE DATABASE IF NOT EXISTS ezpay_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ezpay_db;

-- ================================================================
-- 1. TABEL USERS (Pengguna)
-- ================================================================
CREATE TABLE users (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    firebase_uid    VARCHAR(128)    UNIQUE NOT NULL  COMMENT 'UID dari Firebase Auth',
    name            VARCHAR(100)    NOT NULL         COMMENT 'Nama lengkap pengguna',
    email           VARCHAR(100)    UNIQUE NOT NULL  COMMENT 'Email terdaftar',
    phone           VARCHAR(20)     UNIQUE NOT NULL  COMMENT 'Nomor handphone (format: 08xxx)',
    nik             VARCHAR(20)     UNIQUE NOT NULL  COMMENT 'Nomor Induk Kependudukan (16 digit)',
    gender          ENUM('Laki-laki', 'Perempuan') NOT NULL,
    profile_picture VARCHAR(255)    DEFAULT NULL     COMMENT 'URL/path foto profil',
    pin             VARCHAR(255)    DEFAULT NULL     COMMENT 'PIN transaksi (6 digit, hashed BCrypt)',
    balance         DECIMAL(15,2)   NOT NULL DEFAULT 0.00 COMMENT 'Saldo aktif pengguna (Rupiah)',
    status          ENUM('active', 'suspended', 'unverified') DEFAULT 'active',
    email_verified_at TIMESTAMP     NULL DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_firebase_uid (firebase_uid),
    INDEX idx_phone (phone),
    INDEX idx_email (email),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 2. TABEL USER_FCM_TOKENS
-- ================================================================
CREATE TABLE user_fcm_tokens (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    fcm_token   VARCHAR(512)    NOT NULL    COMMENT 'Token FCM dari Firebase Messaging',
    device_info VARCHAR(255)    DEFAULT NULL COMMENT 'Info device (model, OS version)',
    is_active   TINYINT(1)      DEFAULT 1,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_token (user_id, fcm_token),
    INDEX idx_user_fcm (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 3. TABEL USER_BANK_ACCOUNTS
-- ================================================================
CREATE TABLE user_bank_accounts (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    bank_code           VARCHAR(10)     NOT NULL    COMMENT 'Kode bank: BSI, BNI, BRI, BCA, dll',
    bank_name           VARCHAR(50)     NOT NULL    COMMENT 'Nama bank lengkap',
    account_number      VARCHAR(30)     NOT NULL    COMMENT 'Nomor rekening',
    account_holder_name VARCHAR(100)    NOT NULL    COMMENT 'Nama pemilik rekening',
    is_verified         TINYINT(1)      DEFAULT 0,
    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_bank (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 4. TABEL PIN_HISTORIES
-- ================================================================
CREATE TABLE pin_histories (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    old_pin     VARCHAR(255)    DEFAULT NULL COMMENT 'PIN lama (hashed)',
    new_pin     VARCHAR(255)    NOT NULL     COMMENT 'PIN baru (hashed)',
    changed_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_pin (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 5. TABEL PRODUCT_CATEGORIES
-- ================================================================
CREATE TABLE product_categories (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL    COMMENT 'Nama kategori: Pulsa, Paket Data, dll',
    slug        VARCHAR(50)     UNIQUE NOT NULL COMMENT 'Slug URL: pulsa, paket-data, dll',
    icon        VARCHAR(255)    DEFAULT NULL COMMENT 'Path/URL ikon kategori',
    description TEXT            DEFAULT NULL,
    is_active   TINYINT(1)      DEFAULT 1,
    sort_order  INT             DEFAULT 0   COMMENT 'Urutan tampil di menu',
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 6. TABEL PRODUCTS
-- ================================================================
CREATE TABLE products (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id     BIGINT UNSIGNED NOT NULL,
    product_code    VARCHAR(50)     UNIQUE NOT NULL COMMENT 'Kode produk dari provider PPOB',
    product_name    VARCHAR(150)    NOT NULL        COMMENT 'Nama produk: Telkomsel 10.000, dll',
    provider        VARCHAR(50)     NOT NULL        COMMENT 'Operator/provider: Telkomsel, PLN, dll',
    base_price      DECIMAL(15,2)   NOT NULL        COMMENT 'Harga beli dari provider (modal)',
    sell_price      DECIMAL(15,2)   NOT NULL        COMMENT 'Harga jual ke user',
    admin_fee       DECIMAL(10,2)   DEFAULT 0.00    COMMENT 'Biaya admin terpisah (jika ada)',
    is_active       TINYINT(1)      DEFAULT 1,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE RESTRICT,
    INDEX idx_category (category_id),
    INDEX idx_provider (provider),
    INDEX idx_product_code (product_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 7. TABEL MERCHANTS
-- ================================================================
CREATE TABLE merchants (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    merchant_code   VARCHAR(30)     UNIQUE NOT NULL  COMMENT 'Kode unik merchant',
    merchant_name   VARCHAR(100)    NOT NULL         COMMENT 'Nama gerai',
    merchant_type   VARCHAR(50)     NOT NULL         COMMENT 'Tipe: alfamart, indomaret, alfamidi',
    address         TEXT            DEFAULT NULL,
    phone           VARCHAR(20)     DEFAULT NULL,
    is_active       TINYINT(1)      DEFAULT 1,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_type (merchant_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 8. TABEL TRANSACTIONS (Buku Besar / Ledger)
-- ================================================================
CREATE TABLE transactions (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_code    VARCHAR(50)     UNIQUE NOT NULL  COMMENT 'Kode unik: TRX-YYYYMMDD-XXXXXX',
    reference_id        VARCHAR(100)    DEFAULT NULL     COMMENT 'ID referensi dari provider eksternal',

    -- Pihak yang terlibat
    sender_id           BIGINT UNSIGNED NULL             COMMENT 'User pengirim (saldo berkurang)',
    receiver_id         BIGINT UNSIGNED NULL             COMMENT 'User penerima (saldo bertambah)',
    merchant_id         BIGINT UNSIGNED NULL             COMMENT 'Merchant (untuk tarik tunai)',

    -- Jenis transaksi
    type                ENUM(
                            'top_up_saldo',
                            'transfer_bank',
                            'transfer_ewallet',
                            'transfer_ezpay',
                            'tarik_tunai',
                            'beli_pulsa',
                            'beli_paket_data',
                            'bayar_listrik',
                            'bayar_pdam',
                            'bayar_bpjs',
                            'top_up_game'
                        ) NOT NULL,

    -- Keuangan
    amount              DECIMAL(15,2)   NOT NULL         COMMENT 'Nominal transaksi',
    admin_fee           DECIMAL(10,2)   DEFAULT 0.00     COMMENT 'Biaya admin',
    total               DECIMAL(15,2)   NOT NULL         COMMENT 'Total = amount + admin_fee',

    -- Status & Info
    status              ENUM('pending', 'processing', 'success', 'failed', 'cancelled', 'refunded') DEFAULT 'pending',
    payment_method      VARCHAR(50)     DEFAULT NULL     COMMENT 'Metode bayar',
    note                VARCHAR(255)    DEFAULT NULL     COMMENT 'Catatan transaksi',
    failed_reason       VARCHAR(255)    DEFAULT NULL     COMMENT 'Alasan gagal',

    -- Saldo snapshot (untuk audit)
    sender_balance_before   DECIMAL(15,2) DEFAULT NULL,
    sender_balance_after    DECIMAL(15,2) DEFAULT NULL,
    receiver_balance_before DECIMAL(15,2) DEFAULT NULL,
    receiver_balance_after  DECIMAL(15,2) DEFAULT NULL,

    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE SET NULL,

    INDEX idx_sender (sender_id),
    INDEX idx_receiver (receiver_id),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_created (created_at),
    INDEX idx_trx_code (transaction_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 9. TABEL TRANSACTION_DETAILS
-- ================================================================
CREATE TABLE transaction_details (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_id      BIGINT UNSIGNED NOT NULL,

    -- Untuk PPOB
    product_id          BIGINT UNSIGNED NULL,
    target_number       VARCHAR(100)    DEFAULT NULL     COMMENT 'No HP / ID Pelanggan / ID Game',
    target_name         VARCHAR(100)    DEFAULT NULL     COMMENT 'Nama pemilik',
    serial_number       VARCHAR(255)    DEFAULT NULL     COMMENT 'SN pulsa / Token listrik',
    provider_ref        VARCHAR(100)    DEFAULT NULL     COMMENT 'Ref ID dari provider',

    -- Untuk Transfer Bank / E-Wallet
    bank_code           VARCHAR(10)     DEFAULT NULL,
    bank_name           VARCHAR(50)     DEFAULT NULL,
    account_number      VARCHAR(50)     DEFAULT NULL,
    account_holder_name VARCHAR(100)    DEFAULT NULL,

    -- Untuk Tarik Tunai
    merchant_code       VARCHAR(30)     DEFAULT NULL,
    withdrawal_code     VARCHAR(20)     DEFAULT NULL     COMMENT 'Kode tarik tunai',

    -- Untuk Top Up Saldo
    va_number           VARCHAR(50)     DEFAULT NULL     COMMENT 'Nomor Virtual Account',
    payment_url         VARCHAR(512)    DEFAULT NULL     COMMENT 'URL pembayaran Midtrans',

    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL,
    INDEX idx_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 10. TABEL PAYMENT_GATEWAY_LOGS
-- ================================================================
CREATE TABLE payment_gateway_logs (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_id  BIGINT UNSIGNED NOT NULL,
    gateway         VARCHAR(30)     DEFAULT 'midtrans' COMMENT 'Nama payment gateway',
    event_type      VARCHAR(50)     NOT NULL    COMMENT 'create, notification, callback',
    request_body    JSON            DEFAULT NULL,
    response_body   JSON            DEFAULT NULL,
    http_status     INT             DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
    INDEX idx_trx_log (transaction_id),
    INDEX idx_event (event_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 11. TABEL NOTIFICATIONS
-- ================================================================
CREATE TABLE notifications (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    title       VARCHAR(150)    NOT NULL,
    message     TEXT            NOT NULL,
    type        ENUM('transaction', 'promo', 'system', 'security') DEFAULT 'system',
    data_json   JSON            DEFAULT NULL COMMENT 'Payload data tambahan',
    is_read     TINYINT(1)      DEFAULT 0,
    is_pushed   TINYINT(1)      DEFAULT 0   COMMENT 'Sudah dikirim via FCM',
    read_at     TIMESTAMP       NULL DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_notif (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 12. TABEL PROMOS
-- ================================================================
CREATE TABLE promos (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(150)    NOT NULL,
    description     TEXT            NOT NULL,
    image_url       VARCHAR(255)    NOT NULL     COMMENT 'URL gambar banner',
    promo_code      VARCHAR(50)     UNIQUE NULL,
    discount_type   ENUM('percentage', 'fixed') DEFAULT 'fixed',
    discount_value  DECIMAL(15,2)   DEFAULT 0.00,
    min_transaction DECIMAL(15,2)   DEFAULT 0.00,
    max_discount    DECIMAL(15,2)   DEFAULT 0.00,
    quota           INT             DEFAULT NULL COMMENT 'NULL = unlimited',
    used_count      INT             DEFAULT 0,
    start_date      DATETIME        NOT NULL,
    end_date        DATETIME        NOT NULL,
    status          ENUM('active', 'inactive', 'expired') DEFAULT 'active',
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_status (status),
    INDEX idx_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 13. TABEL PROMO_USAGES
-- ================================================================
CREATE TABLE promo_usages (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    promo_id        BIGINT UNSIGNED NOT NULL,
    user_id         BIGINT UNSIGNED NOT NULL,
    transaction_id  BIGINT UNSIGNED NULL,
    discount_applied DECIMAL(15,2)  NOT NULL,
    used_at         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (promo_id) REFERENCES promos(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
    UNIQUE KEY uk_user_promo (user_id, promo_id),
    INDEX idx_promo_usage (promo_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 14. TABEL ADMIN_USERS
-- ================================================================
CREATE TABLE admin_users (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,
    email           VARCHAR(100)    UNIQUE NOT NULL,
    password        VARCHAR(255)    NOT NULL     COMMENT 'Hashed password (BCrypt)',
    role            ENUM('super_admin', 'admin', 'operator', 'viewer') DEFAULT 'admin',
    is_active       TINYINT(1)      DEFAULT 1,
    last_login_at   TIMESTAMP       NULL DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 15. TABEL ADMIN_ACTIVITY_LOGS
-- ================================================================
CREATE TABLE admin_activity_logs (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    admin_id    BIGINT UNSIGNED NOT NULL,
    action      VARCHAR(100)    NOT NULL,
    target_type VARCHAR(50)     DEFAULT NULL,
    target_id   BIGINT UNSIGNED DEFAULT NULL,
    details     JSON            DEFAULT NULL,
    ip_address  VARCHAR(45)     DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (admin_id) REFERENCES admin_users(id) ON DELETE CASCADE,
    INDEX idx_admin_log (admin_id),
    INDEX idx_action (action),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 16. TABEL APP_SETTINGS
-- ================================================================
CREATE TABLE app_settings (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100)    UNIQUE NOT NULL COMMENT 'Contoh: default_admin_fee, min_topup',
    value       TEXT            NOT NULL,
    description VARCHAR(255)    DEFAULT NULL,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- DATA AWAL (SEEDER)
-- ================================================================

-- Kategori produk PPOB
INSERT INTO product_categories (name, slug, description, sort_order) VALUES
('Pulsa', 'pulsa', 'Pembelian pulsa semua operator', 1),
('Paket Data', 'paket-data', 'Pembelian paket internet', 2),
('Token Listrik', 'listrik', 'Pembelian token listrik PLN Prabayar', 3),
('PDAM', 'pdam', 'Pembayaran tagihan air PDAM', 4),
('BPJS Kesehatan', 'bpjs', 'Pembayaran iuran BPJS Kesehatan', 5),
('Voucher Game', 'game', 'Top up game online', 6);

-- Contoh produk Pulsa
INSERT INTO products (category_id, product_code, product_name, provider, base_price, sell_price, admin_fee) VALUES
(1, 'tsel5', 'Telkomsel 5.000', 'Telkomsel', 5500.00, 6000.00, 0.00),
(1, 'tsel10', 'Telkomsel 10.000', 'Telkomsel', 10500.00, 11000.00, 0.00),
(1, 'tsel20', 'Telkomsel 20.000', 'Telkomsel', 20200.00, 21000.00, 0.00),
(1, 'tsel25', 'Telkomsel 25.000', 'Telkomsel', 25100.00, 26000.00, 0.00),
(1, 'tsel50', 'Telkomsel 50.000', 'Telkomsel', 49500.00, 51000.00, 0.00),
(1, 'tsel100', 'Telkomsel 100.000', 'Telkomsel', 98500.00, 100000.00, 0.00),
(1, 'isat5', 'Indosat 5.000', 'Indosat', 5600.00, 6000.00, 0.00),
(1, 'isat10', 'Indosat 10.000', 'Indosat', 10600.00, 11000.00, 0.00),
(1, 'isat25', 'Indosat 25.000', 'Indosat', 25100.00, 26000.00, 0.00),
(1, 'isat50', 'Indosat 50.000', 'Indosat', 49400.00, 51000.00, 0.00),
(1, 'xl5', 'XL 5.000', 'XL Axiata', 5700.00, 6000.00, 0.00),
(1, 'xl10', 'XL 10.000', 'XL Axiata', 10700.00, 11000.00, 0.00),
(1, 'xl25', 'XL 25.000', 'XL Axiata', 25200.00, 26000.00, 0.00),
(1, 'xl50', 'XL 50.000', 'XL Axiata', 49700.00, 51000.00, 0.00),
(1, 'three5', 'Three 5.000', 'Three', 5400.00, 6000.00, 0.00),
(1, 'three10', 'Three 10.000', 'Three', 10400.00, 11000.00, 0.00),
(1, 'three25', 'Three 25.000', 'Three', 25000.00, 26000.00, 0.00),
(1, 'three50', 'Three 50.000', 'Three', 49300.00, 51000.00, 0.00);

-- Contoh produk Paket Data
INSERT INTO products (category_id, product_code, product_name, provider, base_price, sell_price, admin_fee) VALUES
(2, 'tsel_data_1gb', 'Telkomsel 1GB 30 Hari', 'Telkomsel', 18000.00, 20000.00, 0.00),
(2, 'tsel_data_2gb', 'Telkomsel 2GB 30 Hari', 'Telkomsel', 28000.00, 30000.00, 0.00),
(2, 'tsel_data_5gb', 'Telkomsel 5GB 30 Hari', 'Telkomsel', 48000.00, 50000.00, 0.00),
(2, 'tsel_data_10gb', 'Telkomsel 10GB 30 Hari', 'Telkomsel', 78000.00, 80000.00, 0.00),
(2, 'isat_data_1gb', 'Indosat 1GB 30 Hari', 'Indosat', 16000.00, 18000.00, 0.00),
(2, 'isat_data_3gb', 'Indosat 3GB 30 Hari', 'Indosat', 30000.00, 33000.00, 0.00),
(2, 'xl_data_1gb', 'XL 1GB 30 Hari', 'XL Axiata', 17000.00, 19000.00, 0.00),
(2, 'xl_data_3gb', 'XL 3GB 30 Hari', 'XL Axiata', 32000.00, 35000.00, 0.00);

-- Contoh produk Token Listrik
INSERT INTO products (category_id, product_code, product_name, provider, base_price, sell_price, admin_fee) VALUES
(3, 'pln20', 'Token Listrik 20.000', 'PLN', 20500.00, 20000.00, 1000.00),
(3, 'pln50', 'Token Listrik 50.000', 'PLN', 50500.00, 50000.00, 1000.00),
(3, 'pln100', 'Token Listrik 100.000', 'PLN', 100500.00, 100000.00, 1000.00),
(3, 'pln200', 'Token Listrik 200.000', 'PLN', 200500.00, 200000.00, 1000.00),
(3, 'pln500', 'Token Listrik 500.000', 'PLN', 500500.00, 500000.00, 1000.00),
(3, 'pln1000', 'Token Listrik 1.000.000', 'PLN', 1000500.00, 1000000.00, 1000.00);

-- Contoh produk Voucher Game
INSERT INTO products (category_id, product_code, product_name, provider, base_price, sell_price, admin_fee) VALUES
(6, 'ml86', 'Mobile Legends 86 Diamonds', 'Moonton', 18000.00, 20000.00, 0.00),
(6, 'ml172', 'Mobile Legends 172 Diamonds', 'Moonton', 35000.00, 38000.00, 0.00),
(6, 'ml257', 'Mobile Legends 257 Diamonds', 'Moonton', 52000.00, 55000.00, 0.00),
(6, 'ml344', 'Mobile Legends 344 Diamonds', 'Moonton', 68000.00, 72000.00, 0.00),
(6, 'ml514', 'Mobile Legends 514 Diamonds', 'Moonton', 100000.00, 105000.00, 0.00),
(6, 'ff100', 'Free Fire 100 Diamonds', 'Garena', 14000.00, 16000.00, 0.00),
(6, 'ff210', 'Free Fire 210 Diamonds', 'Garena', 28000.00, 30000.00, 0.00),
(6, 'ff530', 'Free Fire 530 Diamonds', 'Garena', 68000.00, 72000.00, 0.00),
(6, 'gi60', 'Genshin Impact 60 Genesis Crystals', 'HoYoverse', 15000.00, 17000.00, 0.00),
(6, 'gi330', 'Genshin Impact 330 Genesis Crystals', 'HoYoverse', 73000.00, 77000.00, 0.00),
(6, 'hsr60', 'Honkai Star Rail 60 Oneiric Shards', 'HoYoverse', 15000.00, 17000.00, 0.00),
(6, 'hsr330', 'Honkai Star Rail 330 Oneiric Shards', 'HoYoverse', 73000.00, 77000.00, 0.00),
(6, 'vp125', 'Valorant 125 Points', 'Riot Games', 15000.00, 17000.00, 0.00),
(6, 'vp420', 'Valorant 420 Points', 'Riot Games', 48000.00, 50000.00, 0.00);

-- Merchant tarik tunai
INSERT INTO merchants (merchant_code, merchant_name, merchant_type) VALUES
('ALF001', 'Alfamart', 'alfamart'),
('IND001', 'Indomaret', 'indomaret'),
('ALM001', 'Alfamidi', 'alfamidi');

-- Konfigurasi default aplikasi
INSERT INTO app_settings (setting_key, value, description) VALUES
('min_topup_saldo', '10000', 'Minimal nominal top up saldo (Rp)'),
('max_topup_saldo', '10000000', 'Maksimal nominal top up saldo (Rp)'),
('min_transfer', '10000', 'Minimal nominal transfer (Rp)'),
('max_transfer', '25000000', 'Maksimal nominal transfer per transaksi (Rp)'),
('default_admin_fee_ewallet', '1000', 'Biaya admin default top up e-wallet (Rp)'),
('default_admin_fee_bank', '2500', 'Biaya admin transfer bank (Rp)'),
('default_admin_fee_transfer_ezpay', '0', 'Biaya admin transfer sesama EZPay (Rp)'),
('min_withdrawal', '50000', 'Minimal tarik tunai (Rp)'),
('max_withdrawal', '5000000', 'Maksimal tarik tunai per hari (Rp)'),
('withdrawal_fee', '5000', 'Biaya tarik tunai di merchant (Rp)'),
('midtrans_is_production', '0', '0 = sandbox, 1 = production'),
('midtrans_server_key', '', 'Server key Midtrans (isi di .env)'),
('midtrans_client_key', '', 'Client key Midtrans (isi di .env)'),
('digiflazz_username', '', 'Username Digiflazz (isi di .env)'),
('digiflazz_api_key', '', 'API key Digiflazz (isi di .env)'),
('digiflazz_is_production', '0', '0 = development, 1 = production');

-- Admin default (password: admin123 - GANTI SEGERA di production!)
-- BCrypt hash untuk 'admin123'
INSERT INTO admin_users (name, email, password, role) VALUES
('Super Admin', 'admin@ezpay.id', '$2y$12$LK.oG2HB7YLmBNJqJe5FxOVcX6VQzCpP/rT8ByVrMSWxZLcNPVK4K', 'super_admin');
