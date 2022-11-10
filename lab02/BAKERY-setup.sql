DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS customers;


CREATE TABLE customers(
    CId INTEGER,
    LastName VARCHAR (50),
    FirstName VARCHAR (50),

    PRIMARY KEY (CId)
);

CREATE TABLE goods(
    GId VARCHAR (50),
    Flavor VARCHAR(50),
    Food VARCHAR (50),
    Price DECIMAL (10,2),

    PRIMARY KEY (GId),
    UNIQUE(Flavor, Food)
);

CREATE TABLE receipts(
    RNumber INTEGER,
    Customer INTEGER,
    SaleDate DATE,
    

    PRIMARY KEY (RNumber),
    foreign key (Customer) references customers (CId)
);

CREATE TABLE items(
    Receipt INTEGER,
    Ordinal INTEGER,
    Item VARCHAR(50) NOT NULL,

    PRIMARY KEY (Receipt, Ordinal),
    foreign key (Receipt) references receipts(RNumber),
    foreign key (Item) references goods(GId)
);