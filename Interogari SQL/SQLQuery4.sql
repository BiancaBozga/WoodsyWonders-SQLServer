use WoodsyWonders
go

/* 
	1.Afiseaza numele,pretul si cantitatea pentru produsele care se afla la magazinul/magazinele din Timisoara, au culoarea maro si sunt mai mult de 1000 de exemplare
	+ DISTINCT
	+ 3 tabele
    +  rel m-n 
	+ WHERE
*/

SELECT DISTINCT P.Name ,P.Price ,P.Quantity 
FROM Products P
INNER JOIN ShopsProducts SP 
ON SP.Pid=P.Pid
INNER JOIN Shops S
ON SP.Sid=S.Sid
WHERE P.Quantity>1000 AND S.City='Timisoara' AND P.Color='brown'
ORDER BY P.Price


/*
		2.Afisaza email-urile angajatilor care au permis de conducere si au salariul mai mic de 3000. Pt o Prima ;)
		+ 3 tabele
		+ WHERE
*/
SELECT E.Email
From Employee E
INNER JOIN DrivingLicense DL
ON DL.CNPDL=E.CNP
INNER JOIN Factories F
ON F.Fid=E.Fid
WHERE E.Salary<3000

/*
		3.Top 2 cei mai bine platiti angajati de la fabricile/fabrica din Cluj-Napoca cu permis de conducere
		+Where
		+3 tabele

*/
SELECT Top 2 E.Email,E.Salary
From Employee E
INNER JOIN DrivingLicense DL
ON DL.CNPDL=E.CNP
INNER JOIN Factories F
ON F.Fid=E.Fid
WHERE F.City='Cluj-Napoca'
ORDER BY E.Salary DESC

/*		4.Toate autoturismele care pleaca la Baia Mare si au capacitatea mai mare decat 1200
*/
SELECT T.Tip,T.AutoNumber,T.Capacity
FROM Transports T
INNER JOIN TransportsFactories TF
ON TF.AutoNumber=T.AutoNumber
INNER JOIN Factories F
ON F.Fid=TF.Fid
WHERE F.City='Baia Mare' and T.Capacity>1200
/*5.Autoturismele care merg la o fabrica, grupate dupa tip, avand capacitatea medie >2000
*/
SELECT T.Tip,AVG(T.Capacity) as 'Capacitate_medie'
FROM Transports T
INNER JOIN TransportsFactories TF
ON TF.AutoNumber=T.AutoNumber
INNER JOIN Taxes Tx
ON Tx.AutoNumber=T.AutoNumber
Group By T.Tip
Having AVG(T.Capacity)>2000
/*6.Produsele care exista in vreun magazin, grupate dupa culoare, vanad pretul mediu <2000 
*/
SELECT  P.color ,AVG(P.Price) as 'Pret_mediu_produse'
FROM Products P
INNER JOIN ShopsProducts SP 
ON SP.Pid=P.Pid
INNER JOIN Shops S
ON SP.Sid=S.Sid
Group by P.Color
Having AVG(P.Price)<2000
/*
7.Numele produselor care exista in magazine care primesc marfa de la vreo fabrica si se inchid dupa ora 7 
*/

SELECT P.Name ,P.Price ,P.Quantity
FROM Products P
INNER JOIN ShopsProducts SP 
ON SP.Pid=P.Pid
INNER JOIN Shops S
ON SP.Sid=S.Sid
INNER JOIN Factories F
ON F.Fid=S.Fid
WHERE  S.CloseTime>'07:00:00'

/*8.Tipul si suma totala a reclamelor existente pentru produse grupate dupa tipul reclamei
*/

SELECT A.Type, SUM(A.Cost) as 'cost_tip_reclame'
FROM Advertisements A
INNER JOIN Products P
ON A.Pid=P.Pid
INNER JOIN ShopsProducts SP 
ON SP.Pid=P.Pid
GROUP BY A.Type
/*9.Afiseaza numele si ora magazinelor ordonat edupa ora de inchidere
*/
Select S.Name as 'nume_magazin',S.CloseTime
from Shops S
Order by S.CloseTime 

/*10.Afiseaza numele si produsele care au reclama si se afla in vreun magazin
*/
Select DISTINCT P.Name,P.Price
From Products P,Advertisements A,ShopsProducts SP
Where P.Pid=A.Pid and P.Pid=SP.Pid




