-- 01_create_schema.sql
-- Schéma relationnel (exemple PostgreSQL) pour la plateforme Vite & Gourmand
-- Note : les mots de passe sont stockés en clair UNIQUEMENT pour la démo.
-- En production, utiliser un hash (bcrypt/argon2) + salage.

BEGIN;

CREATE TABLE IF NOT EXISTS users (
  id            BIGSERIAL PRIMARY KEY,
  role          VARCHAR(20) NOT NULL DEFAULT 'client' CHECK (role IN ('client','employee','admin')),
  prenom        VARCHAR(80) NOT NULL,
  nom           VARCHAR(80) NOT NULL,
  email         VARCHAR(255) NOT NULL UNIQUE,
  password      VARCHAR(255) NOT NULL,
  tel           VARCHAR(30),
  birth_date    DATE,
  diet          VARCHAR(40),
  allergies     TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS addresses (
  id          BIGSERIAL PRIMARY KEY,
  user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  label       VARCHAR(60) NOT NULL DEFAULT 'Adresse',
  street      VARCHAR(255) NOT NULL,
  zip         VARCHAR(12) NOT NULL,
  city        VARCHAR(120) NOT NULL,
  extra       VARCHAR(255),
  created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS menus (
  id            BIGSERIAL PRIMARY KEY,
  name          VARCHAR(120) NOT NULL,
  type          VARCHAR(20) NOT NULL CHECK (type IN ('classique','vegetarien','vegan')),
  theme         VARCHAR(60),
  short_desc    VARCHAR(255),
  full_desc     TEXT,
  price_per_p   NUMERIC(10,2) NOT NULL CHECK (price_per_p >= 0),
  min_persons   INT NOT NULL CHECK (min_persons >= 1),
  img_url       TEXT,
  composition   TEXT,      -- texte libre (ou JSON si besoin)
  allergens     TEXT
);

CREATE TABLE IF NOT EXISTS orders (
  id              BIGSERIAL PRIMARY KEY,
  order_ref       VARCHAR(40) NOT NULL UNIQUE,
  user_id         BIGINT NOT NULL REFERENCES users(id),
  menu_id         BIGINT REFERENCES menus(id),
  persons         INT NOT NULL CHECK (persons >= 1),
  event_date      DATE NOT NULL,
  event_time      TIME,
  delivery_addr   VARCHAR(255),
  notes           TEXT,
  status          VARCHAR(30) NOT NULL DEFAULT 'pending' CHECK (
                    status IN ('pending','accepted','in_preparation','delivering','delivered','awaiting_return','completed','cancelled')
                  ),
  subtotal        NUMERIC(10,2) NOT NULL DEFAULT 0,
  discount        NUMERIC(10,2) NOT NULL DEFAULT 0,
  delivery_fee    NUMERIC(10,2) NOT NULL DEFAULT 0,
  total           NUMERIC(10,2) NOT NULL DEFAULT 0,
  created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_status_history (
  id          BIGSERIAL PRIMARY KEY,
  order_id    BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  status      VARCHAR(30) NOT NULL,
  label       VARCHAR(255) NOT NULL,
  changed_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reviews (
  id          BIGSERIAL PRIMARY KEY,
  order_id    BIGINT NOT NULL UNIQUE REFERENCES orders(id) ON DELETE CASCADE,
  user_id     BIGINT NOT NULL REFERENCES users(id),
  stars       INT NOT NULL CHECK (stars BETWEEN 1 AND 5),
  comment     TEXT NOT NULL,
  review_date TIMESTAMP NOT NULL DEFAULT NOW(),
  moderated   BOOLEAN NOT NULL DEFAULT FALSE,
  decision    VARCHAR(20) CHECK (decision IN ('approved','rejected'))
);

CREATE TABLE IF NOT EXISTS opening_hours (
  id        BIGSERIAL PRIMARY KEY,
  day_name  VARCHAR(12) NOT NULL,
  is_closed BOOLEAN NOT NULL DEFAULT FALSE,
  open_time TIME,
  close_time TIME
);

COMMIT;
