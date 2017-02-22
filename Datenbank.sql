-- Tabelle mit Daten erstellen
CREATE TABLE monatswerte (
id INTEGER NOT NULL,
datum_anfang DATE,
datum_ende DATE,
qualitaet REAL,
art REAL,
luft_max REAL,
luft REAL,
luft_min REAL,
windstaerke REAL,
bedeckungsgrad REAL,
bedeckung_art REAL,
sonnenschein REAL,
sonnen_art REAL,
niederschlag REAL,
niederschlag_art REAL,
max_max_luft REAL,
min_min_luft REAL,
max_windspitze REAL,
arte REAL,
max_niederschlag REAL,
eor TEXT
);

-- Tabelle mit Stationen erstellen
CREATE TABLE stationen (
id INTEGER NOT NULL PRIMARY KEY,
datum_anfang DATE,
datum_ende DATE,
hoehe REAL,
breite REAL,
laenge REAL,
station_name TEXT,
station_bld TEXT
);

-- Daten laden
-- Messwerte
COPY monatswerte FROM '/Users/Bob/ownCloud/Studienprojekt/Daten/Gesamt_Recent_Hist.txt' WITH DELIMITER ';' CSV HEADER;
-- stationen
COPY stationen FROM '/Users/Bob/ownCloud/Studienprojekt/Daten/test.csv' WITH DELIMITER ';' CSV HEADER;
