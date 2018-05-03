\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

CREATE TABLE Part (
PartID INTEGER NOT NULL PRIMARY KEY CHECK (PartID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
UnitCost FLOAT NOT NULL CHECK(UnitCost>0);

CREATE TABLE Customer (
CustomerID INTEGER NOT NULL PRIMARY KEY CHECK (CustomerID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
Street VARCHAR(30) NOT NULL CHECK (Street <> ' '),
City VARCHAR(20) NOT NULL CHECK (City <> ' '),
State CHAR(2) NOT NULL CHECK (State <> ' '),
Zip VARCHAR(10) NOT NULL CHECK (Zip <> ' ');

CREATE TABLE Technician (
TechnicianID INTEGER NOT NULL PRIMARY KEY CHECK (TechnicianID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
Street VARCHAR(30) CHECK (Street <> ' '),
City VARCHAR(20) CHECK (City <> ' '),
State CHAR(2) CHECK (State <> ' '),
Zip VARCHAR(10) CHECK (Zip <> ' ');

CREATE TABLE Supplier (
SupplierID INTEGER NOT NULL PRIMARY KEY CHECK (SupplierID > 0),
Name VARCHAR(30) NOT NULL CHECK (Name <> ' '),
Street VARCHAR(30) NOT NULL CHECK (Street <> ' '),
City VARCHAR(20) NOT NULL CHECK (City <> ' '),
State CHAR(2) NOT NULL CHECK (State <> ' '),
Zip VARCHAR(10) NOT NULL CHECK (Zip <> ' ');

CREATE TABLE COrder_t (
OrderID INTEGER NOT NULL PRIMARY KEY CHECK (OrderID > 0),
DateToFill DATE,
CustomerID INTEGER NOT NULL FOREIGN KEY REFERENCES Customer CHECK (CustomerID > 0),
PartID INTEGER NOT NULL FOREIGN KEY REFERENCES Part CHECK (PartID > 0);

CREATE TABLE AssemblyCard (
CardNumber INTEGER NOT NULL PRIMARY KEY CHECK (CardNumber > 0),
OrderID INTEGER NOT NULL FOREIGN KEY REFERENCES COrder_t CHECK (OrderID > 0);

CREATE TABLE SupplyShipment (
SupplyID INTEGER NOT NULL CHECK (SupplyID > 0),
Quantity INTEGER NOT NULL CHECK (Quantity > 0),
SupplierID INTEGER NOT NULL CHECK (SupplierID > 0),
PartID INTEGER NOT NULL CHECK PartID > 0),
CONSTRAINT supply_shipment_pk PRIMARY KEY (SupplyID),
CONSTRAINT supply_shipment_supplier_fk FOREIGN KEY (SupplierID) REFERENCES Supplier,
CONSTRAINT supply_shipment_part_fk FOREIGN KEY (PartID) REFERENCES Part);

CREATE TABLE Assembles (
TechnicianID INTEGER NOT NULL CHECK (TechnicianID > 0),
PartID INTEGER NOT NULL CHECK (PartID > 0),
CONSTRAINT assembles_pk PRIMARY KEY (TechnicianID, PartID),
CONSTRAINT assembles_technician_fk FOREIGN KEY (TechnicianID) REFERENCES Technician,
CONSTRAINT assembles_part_fk FOREIGN KEY (PartID) REFERENCES Part);

CREATE TABLE Ships (
SupplierID INTEGER NOT NULL CHECK (SupplierID > 0),
SupplyID INTEGER NOT NULL CHECK (SupplyID > 0),
CONSTRAINT ships_pk PRIMARY KEY (SupplierID, SupplyID),
CONSTRAINT ships_supplier_fk FOREIGN KEY (SupplierID) REFERENCES Supplier,
CONSTRAINT ships_supply_fk FOREIGN KEY (SupplyID) REFERENCES SupplyShipment);

CREATE TABLE Contains (
PartID INTEGER NOT NULL CHECK (PartID > 0),
SupplyID INTEGER NOT NULL CHECK (SupplyID > 0),
CONSTRAINT contains_pk PRIMARY KEY (PartID, SupplyID),
CONSTRAINT contains_part_fk FOREIGN KEY (PartID) REFERENCES Part,
CONSTRAINT contains_supply_fk FOREIGN KEY (SupplyID) REFERENCES SupplyShipment);

CREATE TABLE BOM (
CompositePart INTEGER CHECK (CompositePart > 0),
ComponentPart INTEGER CHECK (ComponentPart > 0),
CONSTRAINT bom_pk PRIMARY KEY (CompositePart, ComponentPart),
CONSTRAINT bom_composite_fk FOREIGN KEY (CompositePart) REFERENCES Part,
CONSTRAINT bom_component_fk FOREIGN KEY (ComponentPart) REFERENCES Part);

CREATE TABLE Uses (
TechnicianID INTEGER NOT NULL CHECK (TechnicianID > 0),
OrderID INTEGER NOT NULL CHECK (OrderID > 0),
CONSTRAINT use_pk PRIMARY KEY (TechnicianID, OrderID),
CONSTRAINT uses_technician_fk FOREIGN KEY (TechnicianID) REFERENCES Technician,
CONSTRAINT uses_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE TABLE ForPart_t (
PartID INTEGER NOT NULL CHECK (PartID > 0),
OrderID INTEGER NOT NULL CHECK (OrderID > 0),
Quantity INTEGER NOT NULL,
CHECK (Quantity >= 0),
CONSTRAINT for_pk PRIMARY KEY (PartID, OrderID),
CONSTRAINT for_part_fk FOREIGN KEY (PartID) REFERENCES Part,
CONSTRAINT for_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE VIEW ForPart AS
SELECT PartID, OrderID, Quantity, (UnitCost * Quantity) AS LineTotal CHECK (LineTotal >= 0)
FROM ForPart_t NATURAL JOIN Part;

CREATE VIEW COrder AS
SELECT OrderID, (SELECT SUM(LineTotal) FROM ForPart) AS OrderTotal CHECK (OrderTotal >= 0)
FROM COrder_t;

CREATE TABLE Places (
CustomerID INTEGER NOT NULL CHECK (CustomerID > 0),
OrderID INTEGER NOT NULL CHECK OrderID > 0),
CONSTRAINT places_pk PRIMARY KEY (CustomerID, OrderID),
CONSTRAINT places_customer_fk FOREIGN KEY (CustomerID) REFERENCES Customer,
CONSTRAINT places_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE TABLE Creates (
OrderID INTEGER NOT NULL CHECK (OrderID > 0),
CardNumber INTEGER NOT NULL CHECK (CardNumber > 0),
CONsTRAINT creates_pk PRIMARY KEY (OrderID, CardNumber),
CONSTRAINT creates_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t,
CONSTRAINT creates_assemblycard_fk FOREIGN KEY (CardNumber) REFERENCES AssemblyCard);
