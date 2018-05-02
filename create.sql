\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

CREATE TABLE Part (
PartID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
UnitCost FLOAT NOT NULL CHECK(UnitCost>0),
CONSTRAINT part_pk PRIMARY KEY (PartID));

CREATE TABLE Customer (
CustomerID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
Street VARCHAR(30) NOT NULL,
City VARCHAR(20) NOT NULL,
State CHAR(2) NOT NULL,
Zip VARCHAR(10) NOT NULL,
CONSTRAINT customers_pk PRIMARY KEY (CustomerID));

CREATE TABLE Technician (
TechnicianID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
Street VARCHAR(30),
City VARCHAR(20),
State CHAR(2),
Zip VARCHAR(10),
CONSTRAINT technician_pk PRIMARY KEY (TechnicianID));

CREATE TABLE Supplier (
SupplierID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
Street VARCHAR(30) NOT NULL,
City VARCHAR(20) NOT NULL,
State CHAR(2) NOT NULL,
Zip VARCHAR(10) NOT NULL,
CONSTRAINT supplier_pk PRIMARY KEY (SupplierID));

CREATE TABLE COrder_t (
OrderID INTEGER NOT NULL,
DateToFill DATE,
CustomerID INTEGER NOT NULL,
PartID INTEGER NOT NULL,
CONSTRAINT corder_pk PRIMARY KEY (OrderID),
CONSTRAINT corder_customer_fk FOREIGN KEY (CustomerID) REFERENCES Customer,
CONSTRAINT corder_part_fk FOREIGN KEY (PartID) REFERENCES Part);

CREATE TABLE AssemblyCard (
CardNumber INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
CONSTRAINT assemblycard_pk PRIMARY KEY (CardNumber),
CONSTRAINT assemblycard_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE TABLE SupplyShipment (
SupplyID INTEGER NOT NULL,
Quantity INTEGER NOT NULL,
SupplierID INTEGER NOT NULL,
PartID INTEGER NOT NULL,
CONSTRAINT supply_shipment_pk PRIMARY KEY (SupplyID),
CONSTRAINT supply_shipment_supplier_fk FOREIGN KEY (SupplierID) REFERENCES Supplier,
CONSTRAINT supply_shipment_part_fk FOREIGN KEY (PartID) REFERENCES Part);

CREATE TABLE Assembles (
TechnicianID INTEGER NOT NULL,
PartID INTEGER NOT NULL,
CONSTRAINT assembles_pk PRIMARY KEY (TechnicianID, PartID),
CONSTRAINT assembles_technician_fk FOREIGN KEY (TechnicianID) REFERENCES Technician,
CONSTRAINT assembles_part_fk FOREIGN KEY (PartID) REFERENCES Part);

CREATE TABLE Ships (
SupplierID INTEGER NOT NULL,
SupplyID INTEGER NOT NULL,
CONSTRAINT ships_pk PRIMARY KEY (SupplierID, SupplyID),
CONSTRAINT ships_supplier_fk FOREIGN KEY (SupplierID) REFERENCES Supplier,
CONSTRAINT ships_supply_fk FOREIGN KEY (SupplyID) REFERENCES SupplyShipment);

CREATE TABLE Contains (
PartID INTEGER NOT NULL,
SupplyID INTEGER NOT NULL,
CONSTRAINT contains_pk PRIMARY KEY (PartID, SupplyID),
CONSTRAINT contains_part_fk FOREIGN KEY (PartID) REFERENCES Part,
CONSTRAINT contains_supply_fk FOREIGN KEY (SupplyID) REFERENCES SupplyShipment);

CREATE TABLE BOM (
CompositePart INTEGER,
ComponentPart INTEGER,
CONSTRAINT bom_pk PRIMARY KEY (CompositePart, ComponentPart),
CONSTRAINT bom_composite_fk FOREIGN KEY (CompositePart) REFERENCES Part,
CONSTRAINT bom_component_fk FOREIGN KEY (ComponentPart) REFERENCES Part);

CREATE TABLE Uses (
TechnicianID INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
CONSTRAINT use_pk PRIMARY KEY (TechnicianID, OrderID),
CONSTRAINT uses_technician_fk FOREIGN KEY (TechnicianID) REFERENCES Technician,
CONSTRAINT uses_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE TABLE ForPart_t (
PartID INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
Quantity INTEGER NOT NULL,
CHECK (Quantity >= 0),
CONSTRAINT for_pk PRIMARY KEY (PartID, OrderID),
CONSTRAINT for_part_fk FOREIGN KEY (PartID) REFERENCES Part,
CONSTRAINT for_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE VIEW ForPart AS
SELECT PartID, OrderID, Quantity, (UnitCost * Quantity) AS LineTotal
FROM ForPart_t NATURAL JOIN Part;

CREATE VIEW COrder AS
SELECT OrderID, (SELECT SUM(LineTotal) FROM ForPart) AS OrderTotal
FROM COrder_t;

CREATE TABLE Places (
CustomerID INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
CONSTRAINT places_pk PRIMARY KEY (CustomerID, OrderID),
CONSTRAINT places_customer_fk FOREIGN KEY (CustomerID) REFERENCES Customer,
CONSTRAINT places_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t);

CREATE TABLE Creates (
OrderID INTEGER NOT NULL,
CardNumber INTEGER NOT NULL,
CONsTRAINT creates_pk PRIMARY KEY (OrderID, CardNumber),
CONSTRAINT creates_order_fk FOREIGN KEY (OrderID) REFERENCES COrder_t,
CONSTRAINT creates_assemblycard_fk FOREIGN KEY (CardNumber) REFERENCES AssemblyCard);
