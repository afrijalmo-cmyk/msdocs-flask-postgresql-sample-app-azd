-- 1. TABEL RESTAURANT
CREATE TABLE restaurant (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  street_address VARCHAR(255),
  description TEXT
);

-- 2. TABEL REVIEW + FOREIGN KEY
CREATE TABLE review (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES restaurant(id) ON DELETE CASCADE,
  user_name VARCHAR(100),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT,
  review_date DATE
);

-- B. INSERT 3 RESTAURANT
INSERT INTO restaurant (name, street_address, description) VALUES
('Coto Makassar Daeng', 'Jl. Sulawesi No. 10, Makassar', 'Coto legendaris terenak'),
('Pallubasa Serigala', 'Jl. Serigala No. 54, Makassar', 'Pallubasa dengan telur setengah matang'),
('Konro Bakar Karebosi', 'Jl. Boulevard No. 8, Makassar', 'Konro bakar primadona Karebosi');

-- B. INSERT 5 REVIEW
INSERT INTO review (restaurant_id, user_name, rating, review_text, review_date) VALUES
(1, 'Aprijal', 5, 'Coto nya mantap poll!', '2026-05-01'),
(1, 'Najmi', 4, 'Kuah kental enak', '2026-05-02'),
(2, 'Syauqi', 5, 'Pallubasa terbaik di Sulsel', '2026-05-03'),
(2, 'Andryan', 3, 'Lumayan tapi antri lama', '2026-05-04'),
(3, 'Elvans', 4, 'Konro bakarnya juicy', '2026-05-05');

-- C1. Create - tambah restoran baru
INSERT INTO restaurant (name, street_address, description) 
VALUES ('Sop Saudara Karebosi', 'Jl. Veteran No.1', 'Sop saudara khas Makassar');

-- C2. Read - review by restaurant_id = 1
SELECT * FROM review WHERE restaurant_id = 1;

-- C3. Read - rating >=4
SELECT * FROM review WHERE rating >= 4;

-- C4. Read - JOIN restaurant + review
SELECT r.name, rv.user_name, rv.rating, rv.review_text 
FROM restaurant r
JOIN review rv ON r.id = rv.restaurant_id;

-- C5. Update deskripsi
UPDATE restaurant SET description = 'Coto legendaris paling enak se-Makassar Raya' WHERE id = 1;

-- C6. Delete 1 review id 5
DELETE FROM review WHERE id = 5;

---Cari restoran dengan rating tertinggi (AVG)
SELECT r.name, AVG(rv.rating) AS avg_rating
FROM restaurant r
JOIN review rv ON r.id = rv.restaurant_id
GROUP BY r.name
ORDER BY avg_rating DESC
LIMIT 1;

--Hitung jumlah review per restoran (COUNT)
SELECT r.name, COUNT(rv.id) AS jumlah_review
FROM restaurant r
LEFT JOIN review rv ON r.id = rv.restaurant_id
GROUP BY r.name;

--Tampilin review terbaru per restoran (ini yang ke-3, belum kamu kerjain)
SELECT r.name, rv.user_name, rv.review_text, rv.review_date
FROM restaurant r
JOIN review rv ON r.id = rv.restaurant_id
WHERE rv.review_date = (
  SELECT MAX(review_date) FROM review WHERE restaurant_id = r.id
)
ORDER BY rv.review_date DESC; 