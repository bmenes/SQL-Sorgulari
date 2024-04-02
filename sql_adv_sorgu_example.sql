------Northwind Veritaban�nda �rnek Yapmak i�in �leri Seviye SQL Sorgu Sorular�

------ 1. Farkl� kategorilerdeki �r�nlerin ortalama fiyatlar�n� ve toplam sat��lar�n� g�steren bir sorgu yaz�n

---- --select
---- --Categories.CategoryName ,
---- --AVG([Products].UnitPrice) as 'avg price',
---- --SUM([Order Details].Quantity * [Order Details].UnitPrice) as 'sum order'
---- --from  Products
---- --inner join [Order Details]
---- --on [Order Details].ProductID=Products.ProductID
---- --inner join Categories
---- --on Categories.CategoryID=Products.CategoryID
---- --group by Categories.CategoryName

------2. En �ok satan 5 �r�n�n ad�n�, sat�� miktar�n� ve sat�� tutar�n� g�steren bir sorgu yaz�n

------select top 5 Products.ProductName ,
------SUM([Order Details].Quantity) as 'Sat��_miktar�',
------SUM([Order Details].Quantity * [Order Details].UnitPrice) as 'sat��_tutar�'
------from  Products 
------inner join [Order Details]
------on Products.ProductID=[Order Details].ProductID
------group by  Products.ProductName
------ORDER BY Sat��_miktar� DESC

------3. 2023 y�l�ndan �nce sipari� verilen ve 100$ 'dan fazla tutan sipari�lerin listesini g�steren bir sorgu yaz�n:

------select Products.ProductName,Orders.OrderDate
------from [Order Details]
------inner join Products
------on Products.ProductID=[Order Details].ProductID
------inner join Orders
------on Orders.OrderID=[Order Details].OrderID
------where   Orders.OrderDate < '2023-01-01' and Orders.Freight>100
------order by Products.ProductName asc


------4. Her bir �al��an�n sipari� etti�i �r�nlerin listesini ve toplam sipari� tutar�n� g�steren bir sorgu yaz�n

------select Employees.FirstName,Employees.LastName, Products.ProductName,SUM( [Order Details].Quantity) AS 'Toplam Siparis Miktar' , SUM([Order Details].Quantity * [Order Details].UnitPrice) as 'Toplam Siparis Tutar'
------from Employees
------inner join Orders
------on Orders.EmployeeID=Employees.EmployeeID
------inner join [Order Details]
------on [Order Details].OrderID=Orders.OrderID
------inner join Products
------on Products.ProductID=[Order Details].ProductID
------group by Employees.FirstName,Employees.LastName, Products.ProductName


------5. Tedarik�ilerin bilgilerini  ve tedarik�ilerden sipari� verilen �r�nlerin listesini g�steren bir sorgu yaz�n

------select Suppliers.CompanyName,Suppliers.ContactName,Suppliers.ContactTitle,Products.ProductName
------from Suppliers
------inner join Products
------on Products.SupplierID=Suppliers.SupplierID




------ CTE and Window Func Example

----1. Her �r�n Kategorisi i�in En Y�ksek Fiyatl� �r�n� Bulma

--WITH EnYuksekFiyatliUrunler AS (
--SELECT
-- Products.ProductName,
-- Categories.CategoryName,
-- Products.UnitPrice,
-- ROW_NUMBER() OVER (PARTITION BY Categories.CategoryName ORDER BY Products.UnitPrice DESC) AS SiraNo
--from Products
--inner join Categories
--on Categories.CategoryID=Products.CategoryID
--)


--SELECT 
--    CategoryName, 
--   ProductName, 
--    UnitPrice
--FROM EnYuksekFiyatliUrunler
--WHERE SiraNo = 1;


------2. Her Sipari� i�in Toplam Tutar� ve Kargo �cretini Hesaplama

------with siparis_hesap as (

------select 
------Orders.OrderID,
------Products.ProductName,
------[Order Details]. UnitPrice, 
------[Order Details].Quantity, 
------Orders.OrderDate,
------Orders.Freight as 'KargoUcreti',
------[Order Details].Quantity * [Order Details].UnitPrice as 'Tutar'
------from [Order Details]
------inner join Products
------on Products.ProductID=[Order Details].ProductID
------inner join Orders
------on Orders.OrderID=[Order Details].OrderID

------)

------select OrderID,SUM(KargoUcreti) as 'Toplam Kargo �creti', SUM(Tutar) as 'Toplam Sipari� Tutar�'
------from siparis_hesap
------group by OrderID;

 



---- --3.  1996-08-01 tarihi ve bu tarihten 3 ay onceki tarih aral���nda  En �ok Satan �r�nleri Bulma

---- with encok_hesap as (

---- select 
----  Products.ProductName,
---- SUM([Order Details].Quantity) as 'Toplam_Satis'
---- from [Order Details]
---- inner join Products
---- on Products.ProductID=[Order Details].ProductID
---- inner join Orders
---- on [Order Details].OrderID=Orders.OrderID
---- WHERE Orders.OrderDate BETWEEN DATEADD(MONTH, -3,'1996-08-01 ') AND '1996-08-01'
---- GROUP BY   Products.ProductName
---- )



---- select top 10
---- ProductName , Toplam_Satis as 'Toplam Sat�� Miktar�'
---- from encok_hesap
---- ORDER BY Toplam_Satis DESC


 