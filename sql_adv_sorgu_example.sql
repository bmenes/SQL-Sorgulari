------Northwind Veritabanýnda Örnek Yapmak için Ýleri Seviye SQL Sorgu Sorularý

------ 1. Farklý kategorilerdeki ürünlerin ortalama fiyatlarýný ve toplam satýþlarýný gösteren bir sorgu yazýn

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

------2. En çok satan 5 ürünün adýný, satýþ miktarýný ve satýþ tutarýný gösteren bir sorgu yazýn

------select top 5 Products.ProductName ,
------SUM([Order Details].Quantity) as 'Satýþ_miktarý',
------SUM([Order Details].Quantity * [Order Details].UnitPrice) as 'satýþ_tutarý'
------from  Products 
------inner join [Order Details]
------on Products.ProductID=[Order Details].ProductID
------group by  Products.ProductName
------ORDER BY Satýþ_miktarý DESC

------3. 2023 yýlýndan önce sipariþ verilen ve 100$ 'dan fazla tutan sipariþlerin listesini gösteren bir sorgu yazýn:

------select Products.ProductName,Orders.OrderDate
------from [Order Details]
------inner join Products
------on Products.ProductID=[Order Details].ProductID
------inner join Orders
------on Orders.OrderID=[Order Details].OrderID
------where   Orders.OrderDate < '2023-01-01' and Orders.Freight>100
------order by Products.ProductName asc


------4. Her bir çalýþanýn sipariþ ettiði ürünlerin listesini ve toplam sipariþ tutarýný gösteren bir sorgu yazýn

------select Employees.FirstName,Employees.LastName, Products.ProductName,SUM( [Order Details].Quantity) AS 'Toplam Siparis Miktar' , SUM([Order Details].Quantity * [Order Details].UnitPrice) as 'Toplam Siparis Tutar'
------from Employees
------inner join Orders
------on Orders.EmployeeID=Employees.EmployeeID
------inner join [Order Details]
------on [Order Details].OrderID=Orders.OrderID
------inner join Products
------on Products.ProductID=[Order Details].ProductID
------group by Employees.FirstName,Employees.LastName, Products.ProductName


------5. Tedarikçilerin bilgilerini  ve tedarikçilerden sipariþ verilen ürünlerin listesini gösteren bir sorgu yazýn

------select Suppliers.CompanyName,Suppliers.ContactName,Suppliers.ContactTitle,Products.ProductName
------from Suppliers
------inner join Products
------on Products.SupplierID=Suppliers.SupplierID




------ CTE and Window Func Example

----1. Her Ürün Kategorisi için En Yüksek Fiyatlý Ürünü Bulma

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


------2. Her Sipariþ için Toplam Tutarý ve Kargo Ücretini Hesaplama

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

------select OrderID,SUM(KargoUcreti) as 'Toplam Kargo Ücreti', SUM(Tutar) as 'Toplam Sipariþ Tutarý'
------from siparis_hesap
------group by OrderID;

 



---- --3.  1996-08-01 tarihi ve bu tarihten 3 ay onceki tarih aralýðýnda  En Çok Satan Ürünleri Bulma

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
---- ProductName , Toplam_Satis as 'Toplam Satýþ Miktarý'
---- from encok_hesap
---- ORDER BY Toplam_Satis DESC


 