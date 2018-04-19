\qecho -n 'Script run on '
\qecho -n `date /t`
\qecho -n 'at '
\qecho `time /t`
\qecho -n 'Script run by ' :USER ' on server ' :HOST ' with db ' :DBNAME
\qecho ' '

\d Part
\d Technician
\d COrder_t
\d AssemblyCard
\d Customer
\d Supplier
\d SupplyShipment
\d Assembles
\d Ships
\d Contains
\d BOM
\d Uses
\d ForPart_t
\d Places
\d Creates
