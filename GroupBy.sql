--1.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, 
--Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za svaku firmu
select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas
from Firm f 
inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
group by f.Id, f.Name

--2.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, 
--Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za sve firme koje imaju vise od 5 povezanih practice area-a
select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas
from Firm f 
inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
group by f.Id, f.Name
having COUNT(*) > 5

--3.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, 
--Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za sve firme koje imaju manje od 5 povezanih practice area-a
select f.Id, f.Name, COUNT(*) as NumberOfPracticeAreas
from Firm f 
inner join PracticeAreaFirm paf on f.Id = paf.Firm_Id
group by f.Id, f.Name
having COUNT(*) < 5

--4.	Prikazati sledece podatke iz tabele Lawyer L: L.Id, L.FirstName, L.LastName, 
--Ukupan broj povezanih practice area-a (tabela [PracticeAreaLawyer]) za svakog lawyer-a
select l.id, l.FirstName, l.LastName, COUNT(*) as NumberOfPracticeAreas
from Lawyer l 
inner join PracticeAreaLawyer pal on l.Id = pal.Lawyer_Id
group by l.id, l.FirstName, l.LastName

--5.	Prikazati 10 najzastupljenijih Practice Area koje su vezane za ceo set firmi.
select top 10 l.Name, COUNT(*) as Representation
from PracticeArea pa
inner join PracticeAreaFirm paf on pa.Id = paf.Firm_Id
inner join [Lookup] l on pa.Id = l.Id
group by l.Name
order by COUNT(*) desc

--6.	Prikazati 20 najzastupljenijih Practice Area koje su vezane za ceo set lawyer-a.
select top 20 l.Name, COUNT(*) as Representation
from PracticeArea pa
inner join PracticeAreaLawyer pal on pa.Id = pal.Lawyer_Id
inner join [Lookup] l on pa.Id = l.Id
group by l.Name
order by COUNT(*) desc

--7.	Prikazati 15 najmanje zastupljenih (ali ne I nezastupljenih) Practice Area koje su vezane za ceo set firmi.
select top 15 l.Name, COUNT(*) as Representation
from PracticeArea pa
inner join PracticeAreaLawyer pal on pa.Id = pal.Lawyer_Id
inner join [Lookup] l on pa.Id = l.Id
group by l.Name
having COUNT(*) > 0
order by COUNT(*) 

--8.	Prikazati spisak zemalja sa ukupnim brojem povezanih firmi
select c.name, COUNT(*) as NumberOfFirms
from Firm f
inner join Country c on f.Country_Id = c.Id
group by c.Name

--9.	Prikazati spisak zemalja sa sledecim kolona: Country.Name, 
--Broj povezanih firmi, Lista povezanih firmi odvojenih zarezom (u jednoj celiji)
select c.name, COUNT(*) as NumberOfFirms, STRING_AGG(CONVERT(NVARCHAR(max),f.Name), ', ') as Firms
from Firm f
inner join Country c on f.Country_Id = c.Id
group by c.Name

--10.	Prikazati koliko svaki sponsor (Sponsor_Id) ima vezanih artikala ukupno. 
--Izvestaj treba da ima sledece kolone: Sponsor_Id, Naziv Sponsora, Broj vezanih artikala, 
--Lista coma separated Article id-jeva (u jednoj celiji)
select f.Id, f.Name, COUNT(*) as NumberOfArticles, STRING_AGG(CONVERT(NVARCHAR(max),a.Id), ', ') as ArticleIds
from Article a 
inner join Firm f on a.Sponsor_Id = f.Id
group by f.Id, f.Name

--11.	Napraviti izvestaj koji ce da ima sledece kolone: Deal.Year, Deal.Month, ukupan broj deal-ova, 
--ukupan iznos deal-ova (DollarValue), prosecnu vrednost deal-ova (DollarValue), 
--minimalnu vrednost deal-ova (DollarValue), maximalnu vrednost deal-ova (DollarValue) za sve Deal-ove koji imaju EntityStatus = 3
select				d.Year, d.Month, COUNT(*) as 'Count', 
					SUM(d.DollarValue) as TotalValue, 
					AVG(d.DollarValue) as AverageValue,
					MIN(d.DollarValue) as MinValue,
					MAX(d.DollarValue) as MaxValue
from				Deal d
where				d.EntityStatus = 3
group by			d.Year, d.Month

--12.	Napraviti izvestaj koji ce da prikaze sledece vrednosti: Deal.Id, Deal.Title, sve povezane PracticeArea-a, 
--sve povezane Lawyer-e s, sve povezane jurisdikcije, sve povezane DealGoverningLaw
select					deal.Id, deal.Title, STRING_AGG(CONVERT(NVARCHAR(max), lookupPracticeArea.Name), ', ') as PracticeAreas, 
						STRING_AGG(CONVERT(NVARCHAR(max), lawyer.FirstName), ', ') as Lawyers,
						STRING_AGG(CONVERT(NVARCHAR(max), lookupJurisdiction.Name), ', ') as Jurisdisctions,
						STRING_AGG(CONVERT(NVARCHAR(max), governingLaw.Title), ', ') as GoverningLaws
from					Deal deal
						inner join DealPracticeArea dealPracticeArea 
							on deal.Id = dealPracticeArea.Deal_Id
						inner join PracticeArea pa 
							on dealPracticeArea.PracticeArea_Id = pa.Id
						inner join [Lookup] lookupPracticeArea 
							on pa.Id = lookupPracticeArea.Id
						inner join DealLawyer dealLawyer 
							on deal.Id = dealLawyer.Deal_Id
						inner join Lawyer lawyer 
							on dealLawyer.Lawyer_Id = lawyer.Id
						inner join DealJurisdiction dealJurisdiction 
							on deal.Id = dealJurisdiction.Deal_Id
						inner join Jurisdiction j 
							on dealJurisdiction.Jurisdiction_Id = j.Id
						inner join [Lookup] lookupJurisdiction 
							on j.Id = lookupJurisdiction.Id
						inner join DealGoverningLaw dgl
							on deal.Id = dgl.Deal_Id
						inner join GoverningLaw governingLaw 
							on dgl.GoverningLaw_Id = governingLaw.id 
group by				deal.Id, deal.Title

--13.	Napraviti izvestaj koji ce da pokaze sve Deal-ove (Deal.Id, Deal.Title) koji imaju Value veci od ukupne prosecne vrednosti 
--svih Deal-ova iz tabele koji imaju Deal veci od 0.

select d.Id, d.Title
from Deal d
where d.Value > (select AVG(d1.Value)
				 from Deal d1
				 where d1.Value > 0)
group by d.Id, d.Title

--14.	Napraviti izvestaj koji ce da prikaze broj Deal-ova napravljenih na odredjeni dan (koristiti polje [CreatedOn]). 
--Izvestaj treba da ima sledece kolone: CreatedOn, CountDeals. 
--Izvestaj treba da bude sortiran tako da pokaze prvo dane sa najvise napravljenih deal-ova
select d.CreatedOn, COUNT(*) as CountDeals
from Deal d
group by d.CreatedOn
order by COUNT(*) desc

--15.	Napraviti izvestaj koji ce da prikaze ko je od editora uneo u sistem najvise deal-ova, 
--kako bi 3 editora sa najvise deal-ova dobila bonus.
select top 3 u.Forename, u.Surname, COUNT(*) as CountDeals
from Deal d
inner join [User] u on d.CreatedBy_Id = u.Id
group by u.Forename, u.Surname
order by COUNT(*) desc

--16.	Napraviti izvestaj koji ce da prikaze u svakoj godini ko je od editora napravio najvise izvestaja.


select d.Year, (select top 1 u1.Id
							from Deal d1
							inner join [User] u1 on d1.CreatedBy_Id = u1.Id
							where d1.Year = d.Year
							group by u1.id
							order by COUNT(*) desc
							) as Editor_Id
from Deal d
inner join [User] u on d.CreatedBy_Id = u.Id
group by d.Year

--17.	Napraviti izvestaj koji ce da izvuce po Currency-ju koliko svaki Currency ima vezanih Deal-ova. 
--Izvestaj treba da ima sledece kolone: CurrencyId, CurrencyName, 
--Broj vezanih deal-ova, Deals (comma separated list of deal ids). 
--Izvestaj treba da bude sortiran u opadajucem redosledu po broju povezanih Currency-ja.
select l.Id, l.Name, COUNT(*) as Count,  STRING_AGG(CONVERT(NVARCHAR(max), d.Id), ', ')
from Currency c
inner join Deal d on c.Id = d.Currency_Id
inner join [Lookup] l on c.Id = l.Id
group by l.Id, l.Name
order by COUNT(*) desc
