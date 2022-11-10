DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports;


CREATE TABLE airlines(
    Id INTEGER,
    Airline VARCHAR (50),
    Abbreviation VARCHAR (30),
    Country VARCHAR (30),
    
    PRIMARY KEY (Id),
    UNIQUE (Airline),
    UNIQUE (Abbreviation)
);

CREATE TABLE airports(
    City VARCHAR (50),
    AirportCode VARCHAR (3),
    AirportName VARCHAR (50),
    Country VARCHAR (50),
    CountryAbbrev VARCHAR (50),
    
    PRIMARY KEY (AirportCode)
);

CREATE TABLE flights(
    Airline INTEGER NOT NULL,
    FlightNo INTEGER,
    SourceAirport VARCHAR (3) NOT NULL,
    DestAirport VARCHAR (3) NOT NULL,
    
    PRIMARY KEY (Airline, FlightNo),
    foreign key Source (SourceAirport) references airports (AirportCode),
    foreign key Dest (DestAirport) references airports (AirportCode),
    foreign key (Airline) references airlines (Id)
);