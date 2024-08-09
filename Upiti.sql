--1. Poslednjih (CreatedDate) 10 artikala koji su IsSponsored
select top 10 *
from Article a
where a.IsSponsored = 1
order by a.CreateDate desc

--2. Poslednjih 20 (CreatedDate) artikala koji u svom nazivu (Title) imaju 'Legal'
select top 20 *
from Article a
where a.Title like '%Legal%'
order by a.CreateDate desc

--3. Poslednjih 10 (CreatedDate) artikala koji u svom nazivu (Title) pocinju sa 'Legal'
select top 10 *
from Article a
where a.Title like 'Legal%'
order by a.CreateDate desc

--4. Poslednjih 20 (CreatedDate) artikala koji u svom nazivu (Title) zavrsavaju sa 'Legal'
select top 20 *
from Article a
where a.Title like '%Legal'
order by a.CreateDate desc

--5. Prvih 10 (CreatedDate) artikala kojima se zavrsavaju (ExpireDate) u 2019 godinu
select top 10 *
from Article a
where YEAR(a.ExpireDate) = 2019
order by a.CreateDate asc

--5. Sve artikle kojima je rok zavrsetka u (ExpireDate) u sledecem periodu: 01.09.2018 - 31.12.2018
select *
from Article a
where a.ExpireDate BETWEEN '2018-09-01' 
	AND '2018-12-31'

--6. Sve artikle kojima je rok zavrsetka u (ExpireDate) u sledecem periodu: 01.01.2019 - 31.12.2020, prikazati samo odredjene kolone: 
-- Id, Title, Author, IsSponsored. IsSponsored ne zelimo da prikazemo kao nule i jedinice vec zelimo da ih prikazemo kao Yes/No
select					a.Id, a.Title, a.Author, 
					case a.IsSponsored
						when 1 then 'Yes' 
						when 0 then 'No'
						else ''
					end as isSponsored
from					Article a 
where					a.ExpireDate BETWEEN '2019-01-01' 
					AND '2020-12-31'

--7. Najvise 10 artikala koji imaju najvecu posecenost (NumberOfVisits) koji su napravljeni 2018 i 2019 godine
select top 10 * 
from Article a
where YEAR(a.CreateDate) = 2018 OR YEAR(a.CreateDate) = 2019
order by a.NumberOfVisits desc

--8. Poslednjih (CreatedDate) 100 artikala cija duzina Title ne prelazi 30 karaktera
select top 100 *
from Article a
where LEN(a.Title) <= 30

--9. Poslednjih (CreatedDate) 200 artikala (zelim sve kolone iz tabele) i ne zelim da vidim nijednu NULL vrednost. 
--Umesto NULL vrednosti prikazati N/A
select top 200				a.Id, a.EntityStatus, a.IsFeatured, 
					a.Title, a.ShortDescription, a.Body, 
					a.Period_Id, 
					ISNULL(CONVERT(VARCHAR(10), a.Sponsor_Id), 'N/A') as Sponsor_Id, 
					a.Type_Id, a.CreateDate, 
					ISNULL(a.Author, 'N/A') as Author, 
					ISNULL(a.Location, 'N/A') as Location, 
					a.NumberOfVisits, 
					ISNULL(CONVERT(VARCHAR(10), a.Image_Id), 'N/A') as Image_Id, 
					a.ExpireDate, 
					ISNULL(CONVERT(VARCHAR(10), a.ExternalId), 'N/A') as ExternalId, 
					a.IsSponsored, a.IsTopFeatured, a.CreatedOn, 
					ISNULL(CONVERT(VARCHAR(10), a.CreatedBy_Id), 'N/A') as CreatedBy_Id, 
					ISNULL(CONVERT(VARCHAR(10), a.LastUpdatedBy_Id), 'N/A') as LastUpdateBy_Id, 
					ISNULL(CONVERT(VARCHAR(10), a.Editor_Id), 'N/A') as Editor_Id, a.LastUpdatedOn
from					Article a

--10. Smatramo da su artikli poverljivi ako u svom Title imaju kljucnu rec: Panama. Zelim da prikazem prvih (ExpiryDate) 
--500 artikala (zelim sve kolone iz tabele, osim Body) koji su poverljivi, da prikazem dodatnu kolonu SecretYear: koja treba da izgleda ovako: 
-- Secret {ExpiryDate.Year} number of visits {NumberOfVisits} da budu sortirani po NumberOfVisits u opadajucem redosledu
select top 500				a.Id, a.EntityStatus, a.IsFeatured, 
					a.Title, a.ShortDescription, a.Period_Id, 
					a.Sponsor_Id, a.Type_Id, 
					a.Type_Id, a.CreateDate, a.Author, a.Location, 
					a.NumberOfVisits, a.Image_Id, a.ExpireDate, a.ExternalId, 
					a.IsSponsored, a.IsTopFeatured, a.CreatedOn, a.LastUpdatedBy_Id,
					a.Editor_Id, a.LastUpdatedOn, 
					CONCAT('Secret: ', YEAR(a.ExpireDate), ' number of visits ', a.NumberOfVisits) as SecretYear
from					Article a
where					a.Title like '%Panama%'
order by				a.ExpireDate,  a.NumberOfVisits desc

--11. Zelim da napravim izvestaj i da tekstualno opisem kakva je posecenost artikala bila (NumberOfVisits).
--Smatram da je artikal slabo posecen ako je imao manje od 1000 pregleda.
--Smatram da je artikal srednje posecen ako je imao izmedju 1000 i 2000 pregleda. Smatram da je artikal visoko posecen ako je imao vise od 3000 pregleda. 
--Dodatna kolona u kojoj je opisana posecenost treba da se zove 'NumberOfVisitsDescriptive'. 
--Kolone koje zelim da prikazem su: Id, Title, NumberOfVisitsDescriptive. Izvestaj treba da bude sortiran po Article.Title u rastucem redosledu.
select top 100				a.Id, a.Title, 
					case 
						when a.NumberOfVisits < 1000 then 'Slabo prosecan'
						when a.NumberOfVisits BETWEEN 1000 AND 2000 then 'Srednje prosecan'
						when a.NumberOfVisits > 3000 then 'Visoko prosecan'
						else 'Bez pregleda'
					end as NumberOfVisitsDescriptive
from					Article a
order by				a.Title

--12. Prikazati sve firme (tabela Firm) koje imaju email adresu (Email). Smatra se da firma ima email adresu AKKO polje nije null i ako polje ima vrednost
select top 100 *
from Firm f
where f.Email is not null 
	and LEN(f.Email) > 0

-- 13. Prikazati sve firme koje imaju u isto vreme email adresu i web adresu (Web).
select top 100 *
from Firm f
where f.Email is not null 
	and LEN(f.Email) > 0 
	and f.Web is not null 
	and LEN(f.Web) > 0

--14. Prikazati sve firme koje nemaju email adresu (Email).
select top 100 *
from Firm f
where f.Email is  null 
	or LEN(f.Email) = 0

--15. Prikazati sve firme koje nemaju email adresu i nemaju web adresu (Web).
select top 100 *
from Firm f
where f.Email is  null or LEN(f.Email) = 0
	and f.Web is null or LEN(f.Web) = 0

--16. Prikazati sve firme koje imaju web adresu ali nemaju email adresu.
select top 100 *
from Firm f
where (f.Email is  null or LEN(f.Email) = 0)
	and f.Web is not null and LEN(f.Web) > 0

--17. Prikazati sve firme koje imaju Logo (Logo_Id)
select top 100 *
from Firm f
where f.Logo_Id is not null

--18. Prikazati sve firme koje nemaju Logo (Logo_Id)
select top 100 *
from Firm f
where f.Logo_Id is null 

--19. Prikazati sve firme koje imaju Logo i koje su update-ovane u poslednje 3 godine
select top 100 *
from Firm f
where f.Logo_Id is not null
	and YEAR(DATEADD(YEAR, -3, GETDATE())) <= YEAR(f.LastUpdatedOn)

--20. Prikazati sve Artikle koji imaju ExpireDate u poslednja 3 meseca od trenutka izvrsenja querija
select top 100 *
from Article a
where DATEADD(MONTH, -3, GETDATE()) <= a.ExpireDate 
	and GETDATE() >= a.ExpireDate

--21. Prikazati sve Artikle koji imaju ExpireDate u poslednjih 30 dana od trenutka izvrsenja querija
select top 100 * 
from Article a
where DATEADD(DAY, -30, GETDATE()) <= a.ExpireDate 
	and GETDATE() >= a.ExpireDate

--22. Prikazati sve Artikle koji imaju ExpireDate u buducnosti od trenutka izvrsenja querija
select top 100 * 
from Article a
where GETDATE() < a.ExpireDate


--23. Prikazati sve artikle koji se odnose na Mexico (Location) i koji imaju NumberOfVisits veci od 100
select top 100 *
from Article a
where a.Location = 'Mexico' 
	and a.NumberOfVisits > 100

--24. Napraviti izvestaj koji ima sledece kolone:
--Id, TitleAuthorNumberOfVisits
--Kolona TitleAuthorNumberOfVisits treba da bude u sledecem formatu: {Title} - Author: {Author}, number of visits: 
--{NumberOfVisits} za sve artikle koji nisu istekli (ExpireDate)
select				a.Id, 
				CONCAT(a.Title, ' - ', 'Author:', a.Author, ', number of visits: ', a.NumberOfVisits) as TitleAuthorNumberOfVisits
from				Article a
where				GETDATE() > a.ExpireDate

--25. Prikazati koji sve razliciti domeni postoje medju advokatima (Layer) na osnovu njihove email adrese (gde email adresa postoji)
select distinct			SUBSTRING(l.Email, CHARINDEX('@', l.Email) + 1, LEN(l.Email))
from				Lawyer l
where				LEN(l.Email) > 0

--26. Prikazati sve razlicite domene email adresa medju advokatima (Layer) od advokata koji su poslednji put update-ovani u poslednjem kvartalu 2023 godine
select distinct			SUBSTRING(l.Email, CHARINDEX('@', l.Email) + 1, LEN(l.Email))
from				Lawyer l
where				LEN(l.Email) > 0
				and MONTH(l.LastUpdatedOn) BETWEEN 10 AND 12
				and YEAR(l.LastUpdatedOn) = 2023
