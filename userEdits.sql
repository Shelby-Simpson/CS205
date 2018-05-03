\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

/* Creating Parts that can be ordered */
INSERT INTO Part
VALUES (0001, 'Turbine', 50000),
(0002, 'Wing', 25000),
(0003, 'Fuselage', 80000),
(0004, 'Flaps', 5000),
(0005, 'Aileron', 20000);

/*Creating BOM relationships*/
INSERT INTO BOM
VALUES (0002, 0004),
(0002, 0005);

/* Hiring a technician */
INSERT INTO Technician
VALUES (0001, 'Elon Musk', NULL);

/*Creating an Assembles relationship*/
INSERT INTO Assembles
VALUES (0001, 0002);

/* Inserting customers */
INSERT INTO Customer
VALUES (00001, 'Lockheed Martin', '6801 Rockledge Drive', 'Bethesda', 'MD', 20817),
(00002, 'Dylan Keane', '1 Infinite Loop', 'Cupertino', 'CA', 95014),
(00003, 'Boeing', '100 North Riverside Plaza', 'Chicago', 'IL', 60606);

/* A customer changed their address */
UPDATE Customer
SET Street = '5 David Way'
WHERE Name = 'Dylan Keane';

/* Deleting a part the company no longer makes */
DELETE FROM Part
WHERE Name='Turbine';

/* Creating orders */
INSERT INTO COrder_t
VALUES (0000001, '2020-06-09', 00001, 0002),
(0000002, '2019-09-02', 00002, 0003);

/* Creating Assembly Cards for the orders */
INSERT INTO AssemblyCard
VALUES (0000001, 0000001),
(0000002, 0000002);

/* Creating creates relationships */
INSERT INTO Creates
VALUES (0000001, 0000001),
(0000002, 0000002);

/* Creating places relationships */
INSERT INTO Places
VALUES (00001, 0000001),
(00002, 0000002);

/* Creating ForPart_t relationships */
INSERT INTO ForPart_t
VALUES (0002, 0000001, 3),
(0003, 0000002, 1);

/* Editing a date to fill */
UPDATE COrder_t
SET DateToFill='2018-12-12'
WHERE OrderID=0000001;

/* Creating a Uses relationship */
INSERT INTO Uses
VALUES (0001, 0000001);

/* Adding suppliers */
INSERT INTO Supplier
VALUES (00001, 'Plane Parts Inc', '12 Breeze Way', 'Miami', 'FL', 33101),
(00002, 'Wings R Us', '4 Grey Road', 'Pheonix', 'AZ', 85001);

/* Editing a supplier zip code because it was incorrect */
UPDATE Supplier
SET Zip=85010
WHERE SupplierID=00002;

/* Requesting a supply shipment */
INSERT INTO SupplyShipment
VALUES (0000001, 5, 00001, 0004),
(0000002, 5, 00001, 0005);

/* Creating Ships relationships */
INSERT INTO Ships
VALUES (00001, 0000001),
(00001, 0000002);

/* Creating Contains relationships */
INSERT INTO Contains
VALUES (0004, 0000001),
(0005, 0000002);

/* Getting rid of a supplier */
DELETE FROM Supplier
WHERE SupplierID=00002;

/* Rehiring the supplier */
INSERT INTO Supplier
VALUES (00002, 'Wings R Us', '4 Grey Road', 'Pheonix', 'AZ', 85010);












