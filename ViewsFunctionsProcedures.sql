--1.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 1 sa nazivom [vFirmPracticeAreasStats_VaseImePrezime]. 
--Napraviti select iz tako napravljenog view-a. Rezultate view-a prepuniti u #temp tabelu. 
--Napraviti select iz tako napravljene #temp tabele. Obrisati temp tabelu.
create view [dbo].[vFirmPracticeAreasStats_StrahinjaNinkov]
as
select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas
from Firm f 
inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
group by f.Id, f.Name

select *
into #tempStrahinja
from vFirmPracticeAreasStats_StrahinjaNinkov

select *
from #tempStrahinja

DROP TABLE IF EXISTS #tempStrahinja

--2.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 10 sa nazivom [vCountryRelatedFirms_VaseImePrezime]. 
--Napraviti select iz tako napravljenog view-a. Napraviti select is napravljenog view-a, 
--za sve zemlje koje imaju vise od 1000 povezanih firmi. Takav select prepuniti u #temp tabelu. Obrisati temp tabelu.
create view [dbo].[vCountryRelatedFirms_StrahinjaNinkov]
as
select f.Id, f.Name, COUNT(*) as NumberOfArticles, STRING_AGG(CONVERT(NVARCHAR(max),a.Id), ', ') as ArticleIds
from Article a 
inner join Firm f on a.Sponsor_Id = f.Id
group by f.Id, f.Name

select * 
from vCountryRelatedFirms_StrahinjaNinkov

select * 
into #tempStrahinja
from vCountryRelatedFirms_StrahinjaNinkov countryRelatedFirms
where countryRelatedFirms.NumberOfArticles > 1000

select * from #tempStrahinja

DROP TABLE IF EXISTS #tempStrahinja

--3.	Napraviti kopiju postojeceg view-a [vFirmPracticeAreasStats] sa sledecim nazivom: [vFirmPracticeAreasStats_VaseImePrezime]
create view [dbo].[vFirmPracticeAreasStats_StrahinjaNinkovCopy]
as
select *
from vFirmPracticeAreasStats_StrahinjaNinkov

--4.	Update-ovati view: [vFirmPracticeAreasStats_VaseImePrezime] - dodati bilo kakvu kolonu, moze I fiksni string, svejedno.
alter view [dbo].[vFirmPracticeAreasStats_StrahinjaNinkov]
as
select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas, 'Update' as [Update]
from Firm f 
inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
group by f.Id, f.Name

select *
from vFirmPracticeAreasStats_StrahinjaNinkov

--5.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 14 sa nazivom [vDealWithValueGreaterThanAverage_VaseImePrezime]. 
--Tako napravljeni view iskoristiti za novi upit I povezati sa DealLawyer-ima, na nacin da izvestaj ima isti broj redova kao I sam view, 
--a lawyer-e zelim da prikazem grupisane po Deal-u {FirstName} {LastName} kao comma separated vrednosti.
create view [dbo].[vDealWithValueGreaterThanAverage_StrahinjaNinkov]
as
select d.Id, d.Title
from Deal d
where d.Value > (select AVG(d1.Value)
				 from Deal d1
				 where d1.Value > 0)
group by d.Id, d.Title

select dealGreaterThanAverage.*, STRING_AGG(CONCAT(CONVERT(NVARCHAR(max),l.FirstName), CONVERT(NVARCHAR(max),l.LastName)), ', ') as Lawyers
from vDealWithValueGreaterThanAverage_StrahinjaNinkov dealGreaterThanAverage
left join DealLawyer dl on dealGreaterThanAverage.Id = dl.Deal_Id
left join Lawyer l on dl.Lawyer_Id = l.Id
group by dealGreaterThanAverage.Id, dealGreaterThanAverage.Title

--6.	Napraviti skalarnu funkciju koja spaja dva stringa.
create function [dbo].[fnConcatTwoStringsStrahinjaNinkov]
(@string1 NVARCHAR(200), @string2 NVARCHAR(200))
returns NVARCHAR(400)
as
begin 
	return @string1 + @string2
end

select [dbo].[fnConcatTwoStringsStrahinjaNinkov]('Hello', 'World') as [Message]

--7.	Napraviti skalarnu funkciju ce na dati datetime da dodaje odredjen broj dana I vraca rezultat kao novi datetime.
create function [dbo].[fnAddDaysOnDateTime_StrahinjaNinkov]
(@dateTime DATETIME, @numDays int)
returns DATETIME
as 
begin
	return @dateTime + @numDays
end

select [dbo].[fnAddDaysOnDateTime_StrahinjaNinkov]('2014-05-24 00:00:00.000', 30) as [DateTime]

--8.	Iskoristiti funkciju koja spaja dva stringa, I izlistati sve lawyer-e iz baze.
--Izvestaj treba da ima sledece kolone: Lawyer.Id, FirstNameLastName.
select l.Id, [dbo].[fnConcatTwoStringsStrahinjaNinkov](l.FirstName, l.LastName) as FirstNameLastName
from Lawyer l

--9.	Iskoristiti funkciju iz tacke 8, da se prikazu svi artikli kojima ExpireDate istekao pre nedelju dana.
select a.Id, a.Title, a.ShortDescription
from Article a 
where GETDATE() = [dbo].[fnAddDaysOnDateTime_StrahinjaNinkov](a.ExpireDate, 7)

--10.	Napraviti tabelarnu funkciju koja vraca sve Practice Area entitete u sledecem obliku: Id, Name
create function [dbo].[fnReturnPracticeAreas_StrahinjaNinkov]()
returns table
as
return
(
	select pa.Id, l.Name
	from PracticeArea pa
	inner join Lookup l on pa.Id = l.Id
)
select * from dbo.fnReturnPracticeAreas_StrahinjaNinkov()

--11.	Iskoristiti tabelarnu funkciju iz tacke 11 I napraviti izvestaj da se prikazu sve firme koje su vezane za navedenu practice area. 
--Izvestaj treba da ima isto redova kao I funkcija. Firme prikazati kao pipe separated.
select pa.Id, pa.Name, STRING_AGG(CONVERT(NVARCHAR(max),f.Name), ', ') as Firms
from dbo.fnReturnPracticeAreas_StrahinjaNinkov() pa
left join PracticeAreaFirm paf on pa.Id = paf.PracticeArea_Id
left join Firm f on paf.Firm_Id = f.Id
group by pa.Id, pa.Name

--12.	Napraviti sp za zadatak broj 1 iz group by unit-a; Procedura treba da se zove [spFirmPracticeAreas_VaseImePrezime]
 create procedure [dbo].[spFirmPracticeAreas_StrahinjaNinkov]
 as
 begin
	select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas
	from Firm f 
	inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
	group by f.Id, f.Name
 end

 exec [dbo].[spFirmPracticeAreas_StrahinjaNinkov]

--13.	Napraviti sp za zadatak broj 1 iz group by unit-a; Procedura rezultate iz query-ja treba 
--da napuni u tabelu [ReportFirmPracticeAreas_VaseImePrezime]. Procedura na pocetku izvrsenja treba da proveri da li tabela vec postoji. 
--Ukoliko tabela postoji, procedura treba da je obrise I ponovo kreira I napuni podacima
 create procedure [dbo].[spCreateReportFirmPracticeAreas_StrahinjaNinkov]
 as
 begin

	drop table if exists [dbo].[ReportFirmPracticeAreas_StrahinjaNinkov]

	select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas
	into [dbo].[ReportFirmPracticeAreas_StrahinjaNinkov]
	from Firm f 
	inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
	group by f.Id, f.Name

 end

 exec [dbo].[spCreateReportFirmPracticeAreas_StrahinjaNinkov]

--14.	Napraviti sp za zadatak broj 14 iz group by unit-a; Procedura treba da se zove [spDealsGreaterThanAverage_VaseImePrezime]. 
--Procedura treba da rezultate iz tabele napuni u novu tabelu [ReportDealsGreaterThanAverage_VaseImePrezime]. 
--Procedura na pocetku izvrsenja treba da proveri da li tabela vec postoji. Ukoliko tabela postoji, procedura treba da je obrise
--I ponovo kreira I napuni podacima
create procedure [dbo].[spDealsGreaterThanAverage_StrahinjaNinkov]
as
begin

	drop table if exists [dbo].[ReportDealsGreaterThanAverage_StrahinjaNinkov]

	select d.Id, d.Title
	into [dbo].[ReportDealsGreaterThanAverage_StrahinjaNinkov]
	from Deal d
	where d.Value > (select AVG(d1.Value)
				 from Deal d1
				 where d1.Value > 0)
	group by d.Id, d.Title
end

exec [dbo].[spDealsGreaterThanAverage_StrahinjaNinkov]

--15.	Napraviti sp koja ce da prima sledece parametre: DealIds, DealValueFrom, DealValueTo
--I koja ce da izvuce sve deal-ove (Id, Title, Value) za listu dostavljenih comma separated deal-ova (DealIds) gde je [Value] izmedju 
--dosavljenih parametara (DealValueFrom AND DealValueTo). Procedura treba da se zove [spDealByIdsAndValueRange_VaseImePrezime]. 
--Napraviti nekoliko poziva store procedure za razlicite vrednosti parametara
create procedure [dbo].[spDealByIdsAndValueRange_StrahinjaNinkov]
	@dealIds VARCHAR(MAX), @dealValueFrom decimal(18,2), @dealValueTo decimal(18,2)
as
begin
	select d.Id, d.Title, d.Value
	from Deal d
	where (d.Value BETWEEN @dealValueFrom AND @dealValueTo)
	and d.Id in (select * from [dbo].[fnSplitString_StrahinjaNinkov](@dealIds, ','))
end

exec [dbo].[spDealByIdsAndValueRange_StrahinjaNinkov] @dealIds = '2,3,4,5,6,7,8,9,10,11,12,13,14,15,18,19,20', @dealValueFrom = 450000.00, @dealValueTo= 3600000000.00
exec [dbo].[spDealByIdsAndValueRange_StrahinjaNinkov] @dealIds = '211,334,453,53,36,37,83,93,103,131,142,143,154,165,138,119,230', @dealValueFrom = 790000.00, @dealValueTo= 3400000000.00
exec [dbo].[spDealByIdsAndValueRange_StrahinjaNinkov] @dealIds = '24,35,46,56,63,73,84,94,103,113,123,131,141,135,138,149,230', @dealValueFrom = 630000.00, @dealValueTo= 3200000000.00

--16.	Napraviti proceduru koja ce da se zove [spPopulateNotExpiredArticles_VaseImePrezime].
--Procedura treba da proveri da li postoji tabela [reportNotExpiredArticles_VaseImePrezime]. Ukoliko postoji sp treba da je obrise. 
--Sp treba da napravi upit koji treba da ima sledece kolone: a.Id, a.Title, a.ExpiresIn iz tabele [Article]. 
--ExpiresIn predstavlja broj dana od trenutnog vremena do datuma isteka artikla. 
--Rezultat query-ja treba da napuni tabelu [reportNotExpiredArticles_VaseImePrezime]. 
create procedure [dbo].[spPopulateNotExpiredArticles_VaseImePrezime]
as
begin
	
	drop table if exists [dbo].[reportNotExpiredArticles_StrahinjaNinkov]

	select a.Id, a.Title, DATEDIFF(DAY, a.ExpireDate , GETDATE()) as ExpiresIn
	into [dbo].[reportNotExpiredArticles_StrahinjaNinkov]
	from Article a
	where DATEDIFF(DAY, a.ExpireDate , GETDATE()) > 0

end

exec [dbo].[spPopulateNotExpiredArticles_VaseImePrezime]
select * from reportNotExpiredArticles_StrahinjaNinkov


--Napraviti sp koja za izvestaj koji je radjen u jednoj od prethodnih vezbi:
--Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Barbados' u 2014. godini 
--(glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
--sp treba da prima sledece parametre (tierName, jurisdictionName, year) I  da uradi istu stvar kao 
--I upit samo koristeci dostavljene parametere. Napraviti nekoliko primera poziva ka takvoj sp.
create procedure [dbo].[spRankingTierFirm_StrahinjaNinkov]
	@tierName NVARCHAR(MAX), @jurisdictionName NVARCHAR(MAX), @year VARCHAR(4)
as
begin
	select f.*, lot.Name, lod.Name, p.Year
	from RankingTierFirm rtf
	inner join Firm f on rtf.Firm_Id = f.Id
	inner join FirmRanking fr on rtf.FirmRanking_Id = fr.Id
	inner join Jurisdiction j on fr.Jurisdiction_Id = j.Id
	inner join Lookup lod on j.Id = lod.Id
	inner join Period p on fr.Period_Id = p.Id
	inner join PracticeArea pa on fr.PracticeArea_Id = pa.Id
	inner join Lookup lop on pa.Id = lop.Id
	inner join FirmTier ft on rtf.Tier_Id = ft.Id
	inner join Lookup lot on ft.Id = lot.Id
	where lot.Name = @tierName 
	and lod.Name = @jurisdictionName
	and p.Year = @year
end

exec [dbo].[spRankingTierFirm_StrahinjaNinkov] 'Tier 4', 'Angola', '2012'
exec [dbo].[spRankingTierFirm_StrahinjaNinkov] 'Tier 1', 'Belgium', '2013'
exec [dbo].[spRankingTierFirm_StrahinjaNinkov] 'Tier 2', 'Argentina', '2010'