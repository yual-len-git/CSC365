DROP TABLE IF EXISTS stats;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS players;

CREATE TABLE players(
    PId INTEGER,
    PName VARCHAR (50),
    nationality VARCHAR(50),

    PRIMARY KEY (PID), 
    UNIQUE (PName)
);

CREATE TABLE stats (
    PId INTEGER,
    age INTEGER,
    overall INTEGER,
    potential INTEGER,

    foreign key (PId) references players(PId)
);

CREATE TABLE teams(
    PName VARCHAR(50),
    team VARCHAR(50),
    position VARCHAR(50),
    goals INTEGER,

    foreign key (PName) references players(PName)
);