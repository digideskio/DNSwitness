DROP TABLE Hosts;
DROP TABLE Tests;
DROP TABLE Zones;

CREATE TABLE Zones (id SERIAL UNIQUE NOT NULL,
       uuid UUID NOT NULL,
       date TIMESTAMP NOT NULL DEFAULT now(),
       name TEXT NOT NULL, -- Not UNIQUE because several runs can be stored in the base
       PRIMARY KEY (uuid, name));

CREATE TABLE Tests (id SERIAL UNIQUE NOT NULL,
       uuid UUID NOT NULL,
       date TIMESTAMP NOT NULL DEFAULT now(),
       domain TEXT NOT NULL,
       zone INTEGER NOT NULL REFERENCES Zones(id),
       broken BOOLEAN,
       a_zone INET[] DEFAULT NULL, -- Array because a name can have 
       		 		      -- several A records
       a_www_zone INET[] DEFAULT NULL
       );

CREATE TABLE Hosts (id SERIAL UNIQUE NOT NULL,
       PRIMARY KEY (address, tls, name, uuid),
       uuid UUID NOT NULL,
       tls BOOLEAN DEFAULT False,
       date TIMESTAMP NOT NULL DEFAULT now(),
       zone INTEGER NOT NULL REFERENCES Zones(id),
       domain TEXT NOT NULL,
       name TEXT NOT NULL,
       address INET NOT NULL,
       result BOOLEAN,
       details TEXT);

CREATE INDEX index_tests_uuid ON Tests(uuid);
CREATE INDEX index_tests_domain ON Tests(domain);
CREATE INDEX index_tests_date ON Tests(date);
CREATE INDEX index_zones_name ON Zones(name);
CREATE INDEX index_zones_uuid ON Zones(uuid);

