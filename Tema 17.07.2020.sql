/* Implementati sub forma unui script separat fiecare din urmatoarele query-uri:

Un query care sa returneze toate persoanele a caror FirstName incepe cu litera "Z" */
   
   SELECT * FROM dbo.Person AS tPers WHERE tPers.FirstName LIKE 'Z%'

/* Un query care afiseaza numele unui judet / stat (tabela County, coloana CountyName) impreuna cu numarul de orase (tabela City) aflate in acel judet / stat */
   
   SELECT dbo.County.CountyName, Count(1) As 'Orase in judet' FROM dbo.County JOIN dbo.City ON dbo.County.CountyId = dbo.City.CountyId GROUP BY dbo.County.CountyName

/* Un query care sa afiseze toate companiile impreuna cu informatiile de adresa */
   
   SELECT dbo.Company.CompanyName, CONCAT(dbo.Address.AddressLine, ', ', dbo.Address.CityId, ', ', dbo.Address.PostalCode) AS 'Full Address' FROM dbo.Company JOIN dbo.Address ON dbo.Company.MainAddressId = dbo.Address.AddressId

/* Un query care sa afiseze toate persoanele care au statutul de angajat */
   SELECT Person.* FROM PERSON JOIN Employee ON Person.PersonId = Employee.EmployeeId

/* Inserati in tabela de nume de departamente (DepartmentNames) un departament nou, sa zicem "R&D". Nu asignati acesti departament la nici o firma. Scrieti apoi un query care sa afiseze toate numele de departamente care inca nu sunt folosite de nici o firma. Query-ul dvs ar trebui sa returneze cel putin departamentul "R&D" (daca mai sunt si altele ca sa fie ne-assignate, atunci si pe acelea). */

	SELECT dpnames.DepartmentName FROM dbo.DepartmentNames AS dpnames LEFT JOIN dbo.CompanyDepartment AS cmpdep ON  dpnames.DepartmentId = cmpdep.DepartmentId  WHERE cmpdep.DepartmentId is Null
	
/* Afisati toate persoanele cu informatiile lor de baza (nume, prenume, data nasterii) si pe langa acestea afisati o coloana numerica denumita "IsEmployee" care sa contina valoarea 1 daca acea persoana are si statutul de angajat, respectiv "0" daca acea persoana nu are statutul de angajat */

   SELECT pers.FirstName, pers.LastName, pers.DateOfBirth, IIF(emps.EmployeeID Is Null, '0', '1') As IsEmployee FROM dbo.Person as pers Left Join dbo.Employee as emps On pers.PersonId = emps.EmployeeId 

/* Afisati toate persoanele care nu sunt angajati folosind RIGHT OUTER JOIN  */

   Select dbo.Person.* FROM dbo.Employee RIGHT JOIN dbo.Person On Person.PersonId = Employee.EmployeeId Where Employee.EmployeeId is Null


/* Afisati primele 100 de orase in care nu sunt sedii de firma, folosind RIGHT OUTER JOIN  */

	Select TOP(100) City.* from dbo.Company RIGHT OUTER JOIN dbo.Address On dbo.Company.MainAddressId = dbo.Address.AddressId JOIN dbo.City On dbo.Address.CityId = dbo.City.CityId Where dbo.Company.CompanyName is Null


/* Definiti o noua companie si adaugati-o in baza de date, fara sa faceti setup-ul de departamente. Scrieti apoi un query care returneaza toate companiile cu toate departamentele lor, iar acolo unde nu exista corelatii (companie, sau departament) faceti asa incat query-ul sa returneze “N/A”  */

	INSERT INTO dbo.Company VALUES('Cibernetica SA', '444')
    
	SELECT ISNULL(dbo.Company.CompanyName , 'N/A') As 'Company Name', ISNULL(dbo.Department.DepartmentName , 'N/A') As 'Department Name'  From dbo.Company 
	FULL OUTER JOIN dbo.CompanyDepartment on dbo.Company.CompanyId = dbo.CompanyDepartment.CompanyId
	FULL OUTER JOIN dbo.Department on dbo.Department.DepartmentId = dbo.CompanyDepartment.DepartmentId

/* Creeati un view care sa returneze pentru toti angajatii: numele, prenumele, data nasterii, compania la care lucreaza (id + nume), departamentul la care lucreaza (id + nume) si badge code-ul  */

	CREATE VIEW View_Employees As
    Select Pers.FirstName, Pers.LastName, Pers.DateOfBirth, comp.CompanyId, comp.CompanyName, dep.DepartmentId, dept.DepartmentName, emp.BadgeCode 
    FROM dbo.Person as Pers Inner Join dbo.Employee As Emp On Pers.PersonId = Emp.EmployeeId 
	Inner Join dbo.EmployeeDepartment as dep On dep.EmployeeId = Emp.EmployeeId
	Inner Join dbo.Department as dept On dep.DepartmentId = dept.DepartmentId
	Inner Join dbo.Company As comp On comp.CompanyId = emp.CompanyId 

	SELECT * FROM View_Employees

/* Scrieti o procedura stocata care sa returneze pentru o companie (data ca parametru), tot angajatii impreuna cu: numele, prenumele, departamentul la care lucreaza si badge code-ul  */

	CREATE PROCEDURE ProceduraFirma @Comp Varchar(30) As
    Select Pers.FirstName, Pers.LastName, dept.DepartmentName, emp.BadgeCode FROM dbo.Person as Pers 
    Inner Join dbo.Employee As Emp On Pers.PersonId = Emp.EmployeeId 
	Inner Join dbo.EmployeeDepartment as dep On dep.EmployeeId = Emp.EmployeeId
	Inner Join dbo.Department as dept On dep.DepartmentId = dept.DepartmentId
	Inner Join dbo.Company As comp On comp.CompanyId = emp.CompanyId 
	Where comp.CompanyName = @Comp
   
	EXEC ProceduraFirma @Comp = 'Amazon'