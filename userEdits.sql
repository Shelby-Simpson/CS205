/* Creating Parts that can be ordered */
INSERT INTO Part
VALUES (0001, "Turbine", 50000)
VALUES (0002, "Wing", 25000)
VALUES (0003, "Fuselage", 80000);

/* Inserting customers */
INSERT INTO Customer
VALUES (00001, "Lockheed Martin", "6801 Rockledge Drive", "Bethesda", "MD", 20817)
VALUES (00002, "Dylan Keane", "1 Infinite Loop", "Cupertino", "CA", 95014)
VALUES (00003, "Boeing", "100 North Riverside Plaza", "Chicago", "IL", 60606);

/ *A customer changed their address */
UPDATE Customer
SET Street = "5 David Way"
WHERE Name = "Dylan Keane";

/* Deleting a part the company no longer makes */
DELETE FROM Part
WHERE Name="Turbine";

/* Creating orders */
INSERT INTO COrder_t
VALUES (0000001, 00001, 0002)
VALUES (0000002, 00002, 0003);

/* Creating Assembly Cards for the orders */
INSERT INTO AssemblyCard
VALUES (0000001, 0000001,)
VALUES (0000002, 0000002, '2018-09-23');

/* Editing an exact date */
UPDATE AssemblyCard
SET ExactDate='2018-12-12'
WHERE CardNumber=0000001;

/* Adding suppliers */
INSERT INTO Supplier
VALUES (00001, "Plane Parts Inc", "12 Breeze Way", "Miami", "FL", 33101)
VALUES (00002, "Wings R Us", "4 Grey Road", "Pheonix", "AZ", 85001)

/* Editing a supplier zip code because it was incorrect */
UPDATE Supplier
SET Zip=85010
WHERE SupplierID=00002;

/* Hiring a technician */
INSERT INTO Technician
VALUES (0001, "Elon Musk",);

/* Getting rid of a supplier */
DELETE FROM Supplier
WHERE SupplierID=00002;





