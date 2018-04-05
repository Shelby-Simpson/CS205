CREATE TABLE Part (
PartID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
UnitCost FLOAT NOT NULL CHECK(UnitCost>0),
CONSTRAINT part_pk PRIMARY KEY (PartID)
);
CREATE TABLE Customer (
CustomerID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
Address VARCHAR(50) NOT NULL,
CONSTRAINT customers_pk PRIMARY KEY (CustomerID)
);
CREATE TABLE Technician (
TechnicianID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
Address VARCHAR(50),
CONSTRAINT technician_pk PRIMARY KEY (TechnicianID)
);
CREATE TABLE Supplier (
SupplierID INTEGER NOT NULL,
Name VARCHAR(30) NOT NULL,
Address VARCHAR(50) NOT NULL,
CONSTRAINT supplier_pk PRIMARY KEY (SupplierID)
);
CREATE TABLE COrder (
OrderID INTEGER NOT NULL,
CustomerID INTEGER NOT NULL,
PartID INTEGER NOT NULL,
ExactDate DATE,
CONSTRAINT corder_pk PRIMARY KEY (OrderID),
CONSTRAINT corder_customer_fk FOREIGN KEY (CustomerID) REFERENCES Customer,
CONSTRAINT corder_part_fk FOREIGN KEY (PartID) REFERENCES Part
);
CREATE TABLE SupplyShipment (
SupplyID INTEGER NOT NULL,
Quantity INTEGER NOT NULL,
SupplierID INTEGER NOT NULL,
PartID INTEGER NOT NULL,
CONSTRAINT supply_shipment_pk PRIMARY KEY (SupplyID),
CONSTRAINT supply_shipment_supplier_fk FOREIGN KEY (SupplierID) REFERENCES Supplier,
CONSTRAINT supply_shipment_part_fk FOREIGN KEY (PartID) REFERENCES Part
);
CREATE TABLE Assembles (
TechnicianID INTEGER NOT NULL,
PartID INTEGER NOT NULL,
CONSTRAINT assembles_pk PRIMARY KEY (TechnicianID, PartID),
CONSTRAINT assembles_technician_fk FOREIGN KEY (TechnicianID) REFERENCES Technician,
CONSTRAINT assembles_part_fk FOREIGN KEY (PartID) REFERENCES Part
);
CREATE TABLE Ships (
SupplierID INTEGER NOT NULL,
SupplyID INTEGER NOT NULL,
CONSTRAINT ships_pk PRIMARY KEY (SupplierID, SupplyID),
CONSTRAINT ships_supplier_fk FOREIGN KEY (SupplierID) REFERENCES Supplier,
CONSTRAINT ships_supply_fk FOREIGN KEY (SupplyID) REFERENCES Supply
);
CREATE TABLE Contains (
PartID INTEGER NOT NULL,
SupplyID INTEGER NOT NULL,
CONSTRAINT contains_pk PRIMARY KEY (PartID, SupplyID),
CONSTRAINT contains_part_fk FOREIGN KEY (PartID) REFERENCES Part,
CONSTRAINT contains_supply_fk FOREIGN KEY (SupplyID) REFERENCES Supply
);
CREATE TABLE BOM (
CompositePart VARCHAR(30),
ComponentPart VARCHAR(30),
CONSTRAINT bom_pk PRIMARY KEY (CompositePart, ComponentPart)
);
CREATE TABLE Uses (
TechnicianID INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
CONSTRAINT use_pk PRIMARY KEY (TechnicianID, OrderID),
CONSTRAINT uses_technician_fk FOREIGN KEY (TechnicianID) REFERENCES Technician,
CONSTRAINT uses_order_fk FOREIGN KEY (OrderID) REFERENCES COrder
);
CREATE TABLE For (
PartID INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
CONSTRAINT for_pk PRIMARY KEY (PartID, OrderID),
CONSTRAINT for_part_fk FOREIGN KEY (PartID) REFERENCES Part,
CONSTRAINT for_order_fk FOREIGN KEY (OrderID) REFERENCES Order
);
CREATE TABLE Places (
CustomerID INTEGER NOT NULL,
OrderID INTEGER NOT NULL,
CONSTRAINT places_pk PRIMARY KEY (CustomerID, OrderID),
CONSTRAINT places_customer_fk FOREIGN KEY (CustomerID) REFERENCES Customer,
CONSTRAINT places_order_fk FOREIGN KEY (OrderID) REFERENCES Order
);
