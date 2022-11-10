--Allen Yu
--CPE365

-- BAKERY-1
-- Using a single SQL statement, reduce the prices of Lemon Cake and Napoleon Cake by $2.

UPDATE goods
set Price = Price - 2
where (Flavor = "Lemon" and Food = "cake") or (Flavor = "Napoleon" AND Food = 'Cake'); 

-- BAKERY-2
-- Using a single SQL statement, increase by 15% the price of all Apricot or Chocolate favored items with a current price below $5.95.

UPDATE goods
set Price = Price * 1.15
where (Flavor = 'Apricot' and Price <= 5.95) or (Flavor = 'Chocolate' and Price <= 5.95);

-- BAKERY-3
-- Add the capability for the database to record payment information for each receipt in a new table named payments. A receipt may have multiple payments (split checks). 
-- Each payment row should hold an Amount, PaymentSettled (date and time), and a PaymentType.

CREATE TABLE payments(
    Receipt INTEGER,
    Amount DECIMAL(10,2),
    PaymentSettled DATETIME,
    PaymentType VARCHAR(20),
    
    primary key (Receipt, Amount, PaymentSettled, PaymentType),
    foreign key (Receipt) references receipts(RNumber)
);

-- BAKERY-4
-- Create a database trigger to prevent the sale of Meringues (any flavor) and all Almond flavored items on either Saturday or Sunday.

CREATE TRIGGER weekendCheck BEFORE INSERT ON items
FOR EACH ROW
    BEGIN
    DECLARE newFood varchar(50);
    DECLARE newFlavor varchar(50);
    DECLARE newReceiptDate date;
    
    select Food into newFood from goods where GId = NEW.Item;
    select Flavor into newFlavor from goods where GId = new.Item;
    select SaleDate into newReceiptDate from receipts where RNumber = new.Receipt;
    
    if((DAYNAME(newReceiptDate) = "Saturday") or (DAYNAME(newReceiptDate) = "Sunday")) and
        (newFood = "Meringue" or newFlavor = 'Almond') then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sorry, no meringues until Monday';
    end if;
    END;

-- AIRLINES-1
-- create a database trigger to prevent insertion of flights with the same source and destination.

CREATE TRIGGER sameAirport before insert on flights
for each row
begin
    DECLARE newSource varchar(10);
    DECLARE newDest varchar(10);
    
    set newSource = NEW.SourceAirport;
    set newDest = NEW.DestAirport;
    
    if newSource = newDest then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid destination';
    end if;
end

-- AIRLINES-2
-- Add a Partner column to the airlines table to indicate optional corporate partnerships between airline companies.

ALTER TABLE airlines ADD COLUMN Partner VARCHAR(50);


CREATE TRIGGER existingCheck BEFORE insert on airlines
for each row
begin
    DECLARE airlineExist INTEGER;
    
    if NEW.Partner is not null then
        select * from airlines where Abbreviation = NEW.Partner into airlineExist;
        if airline_exist = 0 then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non-existent Partner';
        end if;
    end if;
end;

CREATE TRIGGER airlineSelf BEFORE INSERT on airlines
for each row
begin
    DECLARE airlineAbbr VARCHAR(50);
    DECLARE airlinePartner VARCHAR(50);
    
    set airlineAbbr = NEW.Abbreviation;
    set airlinePartner = NEW.Partner;
    
    if airlineAbbr = airlinePartner then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Airline can't partner with self";
    end if;
end
        
CREATE TRIGGER currentPartner BEFORE INSERT on airlines
for each row
begin
    DECLARE currentPartner varchar(50);
    
    If NEW.Partner is not null then
        SELECT Partner into currentPartner from airlines where Abbreviation = NEW.Partner;
        if currentPartner is not null then 
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "Partner can't be added";
        end if;
    end if;
end;

CREATE TRIGGER checkUpdate BEFORE UPDATE on airlines
for each row
begin
    DECLARE currentPartner VARCHAR(50);
    
    if NEW.Partner is not null then
        SELECT Partner into currentPartner from airlines where Abbreviation = NEW.Partner;
        if (currentPartner is not null and currentPartner != NEW.Abbreviation) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "Can't with update partner";
        end if;
    end if;
end;

UPDATE airlines
set Partner = "Southwest" where Abbreviation = "JetBlue";
UPDATE airlines
set Partner = "JetBlue" where Abbreviation = "Southwest";

-- KATZENJAMMER-1
-- Change the name of two instruments: `bass balalaika' to `awesome bass balalaika', and `guitar' to `acoustic guitar'.

UPDATE Instruments
SET Instrument = 'awesome bass balalaika' where Instrument = 'bass balalaika';
UPDATE Instruments
SET Instrument = 'acoustic guitar' where Instrument = 'guitar';

-- KATZENJAMMER-2
-- Keep in the Vocals table only those rows where Solveig (id 1 { you may use this numeric value directly) did not sing lead.

DELETE FROM Vocals
where (Bandmate != 1 or Type != 'chorus');