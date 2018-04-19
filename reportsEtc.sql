\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

/* Shows the total of each part used by each technician as required */
SELECT TechnicianID, ComponentPart
FROM Assembles NATURAL JOIN BOM
WHERE CompositePart IN (SELECT PartID FROM Assembles)
GROUP BY TechnicianID, ComponentPart;

/* Creating a bill for the customer with CustomerID 00001 as required */
SELECT PartID, UnitCost, OrderTotal
FROM COrder_t NATURAL JOIN COrder NATURAL Join ForPart_t NATURAL JOIN Part
WHERE CustomerID=00001;

/* Check which customers have placed the most orders.  They are preferred customers */
SELECT CustomerID, COUNT(OrderID)
FROM Places
GROUP BY CustomerID
ORDER BY COUNT(OrderID);


