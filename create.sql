\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

CREATE TABLE Part (
PartID INTEGER NOT NULL PRIMARY KEY CHECK (PartID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
UnitCost FLOAT NOT NULL CHECK (UnitCost>0));

CREATE TABLE Customer (
CustomerID INTEGER NOT NULL PRIMARY KEY CHECK (CustomerID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
Street VARCHAR(30) NOT NULL CHECK (Street <> ' '),
City VARCHAR(20) NOT NULL CHECK (City <> ' '),
State CHAR(2) NOT NULL CHECK (State <> ' '),
Zip VARCHAR(10) NOT NULL CHECK (Zip <> ' '));

CREATE TABLE Technician (
TechnicianID INTEGER NOT NULL PRIMARY KEY CHECK (TechnicianID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
Street VARCHAR(30) CHECK (Street <> ' '),
City VARCHAR(20) CHECK (City <> ' '),
State CHAR(2) CHECK (State <> ' '),
Zip VARCHAR(10) CHECK (Zip <> ' '));

CREATE TABLE Supplier (
SupplierID INTEGER NOT NULL PRIMARY KEY CHECK (SupplierID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
Street VARCHAR(30) NOT NULL CHECK (Street <> ' '),
City VARCHAR(20) NOT NULL CHECK (City <> ' '),
State CHAR(2) NOT NULL CHECK (State <> ' '),
Zip VARCHAR(10) NOT NULL CHECK (Zip <> ' '));

CREATE TABLE COrder_t (
OrderID INTEGER NOT NULL PRIMARY KEY CHECK (OrderID > 0),
DateToFill DATE CHECK (DateToFill >= CURRENT_DATE),
CustomerID INTEGER NOT NULL REFERENCES Customer CHECK (CustomerID > 0),
PartID INTEGER NOT NULL REFERENCES Part CHECK (PartID > 0));

CREATE TABLE AssemblyCard (
CardNumber INTEGER NOT NULL PRIMARY KEY CHECK (CardNumber > 0),
OrderID INTEGER NOT NULL REFERENCES COrder_t CHECK (OrderID > 0));

CREATE TABLE SupplyShipment (
SupplyID INTEGER NOT NULL PRIMARY KEY CHECK (SupplyID > 0),
Quantity INTEGER NOT NULL CHECK (Quantity > 0),
SupplierID INTEGER NOT NULL REFERENCES Supplier CHECK (SupplierID > 0),
PartID INTEGER NOT NULL REFERENCES Part CHECK (PartID > 0));

CREATE TABLE Assembles (
TechnicianID INTEGER NOT NULL REFERENCES Technician CHECK (TechnicianID > 0),
PartID INTEGER NOT NULL REFERENCES Part CHECK (PartID > 0),
CONSTRAINT assembles_pk PRIMARY KEY (TechnicianID, PartID));

CREATE TABLE Ships (
SupplierID INTEGER NOT NULL REFERENCES Supplier CHECK (SupplierID > 0),
SupplyID INTEGER NOT NULL REFERENCES SupplyShipment CHECK (SupplyID > 0),
CONSTRAINT ships_pk PRIMARY KEY (SupplierID, SupplyID));

CREATE TABLE Contains (
PartID INTEGER NOT NULL REFERENCES Part CHECK (PartID > 0),
SupplyID INTEGER NOT NULL REFERENCES SupplyShipment CHECK (SupplyID > 0),
CONSTRAINT contains_pk PRIMARY KEY (PartID, SupplyID));

CREATE TABLE BOM (
CompositePart INTEGER REFERENCES Part CHECK (CompositePart > 0),
ComponentPart INTEGER REFERENCES Part CHECK (ComponentPart > 0),
CONSTRAINT bom_pk PRIMARY KEY (CompositePart, ComponentPart));

CREATE TABLE Uses (
TechnicianID INTEGER NOT NULL REFERENCES Technician CHECK (TechnicianID > 0),
CardNumber INTEGER NOT NULL REFERENCES AssemblyCard CHECK (CardNumber > 0),
CONSTRAINT use_pk PRIMARY KEY (TechnicianID, CardNumber));

CREATE TABLE ForPart_t (
PartID INTEGER NOT NULL REFERENCES Part CHECK (PartID > 0),
OrderID INTEGER NOT NULL REFERENCES COrder_t CHECK (OrderID > 0),
Quantity INTEGER NOT NULL CHECK (Quantity >= 0),
CONSTRAINT for_pk PRIMARY KEY (PartID, OrderID));

CREATE VIEW ForPart AS
SELECT PartID, OrderID, Quantity, (UnitCost * Quantity) AS LineTotal
FROM ForPart_t NATURAL JOIN Part;

CREATE VIEW COrder AS
SELECT OrderID, (SELECT SUM(LineTotal) FROM ForPart) AS OrderTotal
FROM COrder_t;

CREATE TABLE Places (
CustomerID INTEGER NOT NULL REFERENCES Customer CHECK (CustomerID > 0),
OrderID INTEGER NOT NULL REFERENCES COrder_t CHECK (OrderID > 0),
CONSTRAINT places_pk PRIMARY KEY (CustomerID, OrderID));

CREATE TABLE Creates (
OrderID INTEGER NOT NULL REFERENCES COrder_t CHECK (OrderID > 0),
CardNumber INTEGER NOT NULL REFERENCES AssemblyCard CHECK (CardNumber > 0),
CONsTRAINT creates_pk PRIMARY KEY (OrderID, CardNumber));
