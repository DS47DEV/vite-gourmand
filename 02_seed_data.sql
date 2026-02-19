-- 02_seed_data.sql
-- Données de démonstration

BEGIN;

-- Comptes (reprennent les identifiants présents dans la démo front-end)
INSERT INTO users (role, prenom, nom, email, password)
VALUES
  ('admin',    'José',  'Lebon',  'admin@vitegourmand.fr',   'Admin@VG2026!'),
  ('employee', 'Julie', 'Lebon',  'employe@vitegourmand.fr', 'Employe@2026'),
  ('client',   'Sophie','Martin', 'client@demo.fr',          'Client@2026!')
ON CONFLICT (email) DO NOTHING;

-- Adresses du client seed
INSERT INTO addresses (user_id, label, street, zip, city, extra)
SELECT u.id, 'Domicile', '15 allée des Roses', '33000', 'Bordeaux', 'Bât. B, code 4521'
FROM users u WHERE u.email='client@demo.fr'
ON CONFLICT DO NOTHING;

INSERT INTO addresses (user_id, label, street, zip, city, extra)
SELECT u.id, 'Bureau', '47 cours de l''Intendance', '33000', 'Bordeaux', ''
FROM users u WHERE u.email='client@demo.fr'
ON CONFLICT DO NOTHING;

-- Menus (extraits simplifiés de la démo)
INSERT INTO menus (id, name, type, theme, short_desc, full_desc, price_per_p, min_persons, img_url, composition, allergens)
VALUES
  (1, 'Menu Buffet Festif',      'classique',   'Buffet',        'Assortiment généreux pour vos événements.', 'Buffet festif avec entrées, plats et desserts.', 38.00, 10, NULL, 'Entrées • Plats • Desserts', 'Gluten, Lait, Oeufs'),
  (2, 'Menu Réception Chic',     'classique',   'Réception',     'Un menu chic et équilibré.',               'Réception chic, produits de saison.',            50.00, 12, NULL, 'Amuse-bouches • Plat • Dessert', 'Gluten, Poisson'),
  (3, 'Menu Cocktail Prestige',  'classique',   'Cocktail',      'Pièces cocktail variées.',                 'Cocktail dinatoire premium.',                    42.00, 10, NULL, '12 pièces/personne', 'Gluten, Poisson, Crustacés'),
  (4, 'Menu Vegan Gourmand',     'vegan',       'Vegan',         'Cuisine vegan raffinée.',                  'Menu 100% végétalien gastronomique.',            34.00, 4,  NULL, 'Entrée • Plat • Dessert', 'Sésame, Gluten'),
  (5, 'Menu Mariage Prestige',   'classique',   'Mariage',       'Menu signature pour mariages.',            'Parcours gastronomique complet.',                85.00, 40, NULL, 'Mise en bouche • 3 services • Dessert', 'Gluten, Lait, Oeufs'),
  (6, 'Menu Gastronomique',      'classique',   'Gastronomique', 'Foie gras, magret et bûche.',              'Menu d''exception pour grandes occasions.',      45.00, 2,  NULL, 'Amuse-bouches • Foie gras • Magret • Fromages • Bûche', 'Gluten, Lait, Oeufs'),
  (14,'Menu Noël Prestige',      'classique',   'Noël',          'Foie gras, chapon, bûche.',                'Menu de réveillon par excellence.',              65.00, 6,  NULL, 'Foie gras • Homard • Chapon • Fromages • Bûche', 'Gluten, Crustacés, Lait, Oeufs, Sulfites')
ON CONFLICT (id) DO NOTHING;

-- Horaires (démo)
INSERT INTO opening_hours (day_name, is_closed, open_time, close_time) VALUES
  ('Lundi',    FALSE, '09:00', '18:00'),
  ('Mardi',    FALSE, '09:00', '18:00'),
  ('Mercredi', FALSE, '09:00', '18:00'),
  ('Jeudi',    FALSE, '09:00', '18:00'),
  ('Vendredi', FALSE, '09:00', '18:00'),
  ('Samedi',   FALSE, '10:00', '16:00'),
  ('Dimanche', TRUE,  NULL,    NULL)
ON CONFLICT DO NOTHING;

-- Commande d'exemple + avis
WITH u AS (SELECT id FROM users WHERE email='client@demo.fr'),
     m AS (SELECT id FROM menus WHERE id=14)
INSERT INTO orders (order_ref, user_id, menu_id, persons, event_date, event_time, delivery_addr, notes, status, subtotal, discount, delivery_fee, total)
SELECT
  'VG-2026-100', u.id, m.id, 12, DATE '2025-12-31', TIME '20:00',
  '47 cours de l''Intendance, 33000 Bordeaux', 'Entrée par la cour',
  'delivered', 780, 0, 0, 780
FROM u, m
ON CONFLICT (order_ref) DO NOTHING;

INSERT INTO order_status_history (order_id, status, label, changed_at)
SELECT o.id, 'pending', 'Commande reçue', NOW() - INTERVAL '2 days' FROM orders o WHERE o.order_ref='VG-2026-100'
UNION ALL
SELECT o.id, 'accepted', 'Commande acceptée', NOW() - INTERVAL '2 days' + INTERVAL '1 hour' FROM orders o WHERE o.order_ref='VG-2026-100'
UNION ALL
SELECT o.id, 'in_preparation', 'En préparation', NOW() - INTERVAL '1 day' FROM orders o WHERE o.order_ref='VG-2026-100'
UNION ALL
SELECT o.id, 'delivering', 'En cours de livraison', NOW() - INTERVAL '1 day' + INTERVAL '3 hours' FROM orders o WHERE o.order_ref='VG-2026-100'
UNION ALL
SELECT o.id, 'delivered', 'Livrée — Terminée', NOW() - INTERVAL '1 day' + INTERVAL '3 hours 30 minutes' FROM orders o WHERE o.order_ref='VG-2026-100';

INSERT INTO reviews (order_id, user_id, stars, comment, moderated, decision)
SELECT o.id, o.user_id, 5, 'Exceptionnel ! Toute la famille a adoré.', TRUE, 'approved'
FROM orders o
WHERE o.order_ref='VG-2026-100'
ON CONFLICT (order_id) DO NOTHING;

COMMIT;
