\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

SELECT *
FROM Part;
SELECT *
FROM Technician;
SELECT *
FROM COrder_t;
SELECT *
FROM COrder;
SELECT *
FROM AssemblyCard;
SELECT *
FROM Customer;
SELECT *
FROM Supplier;
SELECT *
FROM SupplyShipment;
SELECT *
FROM Assembles;
SELECT *
FROM Ships;
SELECT *
FROM Contains;
SELECT *
FROM BOM;
SELECT *
FROM Uses;
SELECT *
FROM ForPart_t;
SELECT *
FROM ForPart;
SELECT *
FROM Places;
SELECT *
FROM Creates;