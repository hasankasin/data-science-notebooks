CREATE DATABASE database_name -- Database oluşturma

CREATE SCHEMA schema_name -- Schema oluşturma

-- Tablo oluşturma
CREATE TABLE schema_name.name_freq(
  state TEXT,
  gender TEXT,
  year INT,
  name TEXT,
  freq INT
)

CREATE TABLE schema_name.region(
  state TEXT,
  region TEXT
)

CREATE TABLE schema_name.election(
  state TEXT,
  democrat INT,
  republican INT,
  other INT,
  year INT
)

CREATE TABLE schema_name.candidate(
  year INT, 
  party TEXT,
  name TEXT
)

-- Veri yazma
copy schema_name.name_freq FROM 'data/all_state_1950.csv' DELIMITER ',' CSV -- Veriyi sütun başlıklarını da dahil ederek yaz
copy schema_name.election FROM 'data/election.csv' DELIMITER ',' CSV HEADER -- Veriyi sütun başlıklarını dahil etmeden yaz
copy schema_name.candidate FROM 'data/candidates.csv' DELIMITER ',' CSV HEADER
copy schema_name.region FROM 'data/regions.csv' DELIMITER ',' CSV