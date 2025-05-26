-- Active: 1747758165842@@localhost@5432@conservation_db

-- Create Tables
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT NOT NULL,
    ranger_id INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers (ranger_id),
    FOREIGN KEY (species_id) REFERENCES species (species_id)
);

-- Insert Data
INSERT INTO rangers (name, region) 
    VALUES
        ('Alice Green', 'Northern Hills'),
        ('Bob White', 'River Delta'),
        ('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) 
    VALUES
        ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
        ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
        ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
        ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) 
    VALUES
        (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
        (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
        (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
        (1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1
INSERT INTO rangers (name, region) 
    VALUES
        ('Derek Fox', 'Coastal Plains');

-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- Problem 3
SELECT * FROM sightings
    WHERE location LIKE '%Pass%';

-- Problem 4
SELECT name, count(*) as total_sightings FROM rangers
    JOIN sightings USING(ranger_id) 
    GROUP BY name 
    ORDER BY name ASC;

-- Problem 5
SELECT common_name FROM species 
    LEFT JOIN sightings USING(species_id) 
    WHERE sighting_id IS NULL;

-- Problem 6
SELECT common_name, sighting_time, name FROM species
    JOIN sightings USING (species_id)
    JOIN rangers USING (ranger_id)
    ORDER BY sighting_time DESC LIMIT 2;

-- Problem 7
UPDATE species
    SET conservation_status = 'Historic'
    WHERE extract(year from  discovery_date) < 1800;

-- Problem 8
CREATE OR REPLACE FUNCTION get_time_of_day(sighting_time TIMESTAMP) 
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    SELECT CASE
        WHEN extract(hour from sighting_time) < 12 THEN 'Morning'
        WHEN extract(hour from sighting_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END;
$$;

SELECT sighting_id, get_time_of_day(sighting_time) AS time_of_day FROM sightings;

-- Problem 9
DELETE FROM rangers 
    WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);
