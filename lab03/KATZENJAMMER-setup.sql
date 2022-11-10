DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Tracklists;
DROP TABLE IF EXISTS Vocals;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Songs;


CREATE TABLE Albums (
    AId INTEGER,
    Title VARCHAR (50),
    Year INTEGER,
    Label VARCHAR (50),
    type VARCHAR (50),
    
    PRIMARY KEY (AId)
);

CREATE TABLE Band (
    Id INTEGER,
    Firstname VARCHAR (50),
    Lastname VARCHAR (50),
    
    PRIMARY KEY (Id)
);

CREATE TABLE Songs (
    SongId INTEGER,
    Title VARCHAR (100),
    
    PRIMARY KEY (SongId)
);

CREATE TABLE Instruments (
    SongId INTEGER,
    BandmateId INTEGER,
    Instrument VARCHAR (50),
    
    PRIMARY KEY (SongId, BandmateId, Instrument),
    foreign key (SongId) references Songs (SongId),
    foreign key (BandmateId) references Band (Id)
);

CREATE TABLE Performance (
    SongId INTEGER,
    Bandmate INTEGER,
    StagePosition VARCHAR (10),
    
    PRIMARY KEY (SongId, Bandmate),
    foreign key (SongId) references Songs (SongId),
    foreign key (Bandmate) references Band (Id)
);


CREATE TABLE Tracklists (
    AlbumId INTEGER,
    Position INTEGER,
    SongId INTEGER,
    
    foreign key (AlbumId) references Albums (AId),
    foreign key (SongId) references Songs (SongId)
);

CREATE TABLE Vocals (
    SongID INTEGER,
    Bandmate INTEGER,
    type VARCHAR (25),
    
    PRIMARY KEY (SongId, Bandmate),
    foreign key (SongId) references Songs (SongId),
    foreign key (Bandmate) references Band (Id)
);