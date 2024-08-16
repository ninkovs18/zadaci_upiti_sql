--1.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na Jurisdiction (koristiti LEFT JOIN)
select *
from Lookup l left join Jurisdiction j
on l.Id = j.Id
where j.Id is null

--2.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na Jurisdiction (koristiti RIGHT JOIN)
select *
from Jurisdiction j right join Lookup l
on l.Id = j.Id
where j.Id is null

--3.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti LEFT JOIN)
select *
from Lookup l left join PracticeArea p
on l.Id = p.Id
where p.Id is null

--4.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti RIGHT JOIN)
select *
from PracticeArea p right join Lookup l
on l.Id = p.Id
where p.Id is null

--5.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na IndustrySector (koristiti LEFT JOIN)
select *
from Lookup l left join IndustrySector i
on l.Id = i.Id
where i.Id is null

--6.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na IndustrySector (koristiti RIGHT JOIN)
select *
from IndustrySector i right join Lookup l
on l.Id = i.Id
where i.Id is null

--7.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti LEFT JOIN)
--8.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti RIGHT JOIN)

--9.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na LayerTier (koristiti LEFT JOIN)
select *
from Lookup l left join LawyerTier lt
on l.Id = lt.Id
where lt.Id is null

--10.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na LayerTier (koristiti RIGHT JOIN)
select *
from LawyerTier lt right join Lookup l
on l.Id = lt.Id
where lt.Id is null

--11.	Prikazati sledece kolone iz tabele Firm (Id, Name, [Country/GlobalFirm]). 
--Kolona [Country/GlobalFirm] treba da prikaze vezan Country name (Country_Id) za firmu ukoliko firma ima Country. 
--Ukoliko nema, treba da prikaze vezanu globalnu firmu - naziv globalne firme (GlobalFirm_Id). 
--Ukoliko nema Globalnu firmu treba da prikaze 'N/A'.
select f.Id, f.Name, COALESCE(c.Name, gf.Name, 'N/A') as [Country/GlobalFirm]
from Firm f 
left join  Country c on f.Country_Id = c.Id
left join Firm gf on gf.Id = f.GlobalFirm_Id

--12.	Prikazati sledece kolone iz tabele Firm (Id, Name, Address). Kolonu Address pravimo na osnovu spoljnog kljuca Address_Id. 
--Ideja je da prikazemo samo one kolone iz tabele Address koje imaju vrednost u sledecem redosledu: Line1 Line2 Line3 POBox, Country. 
--Ona polja iz tabele Address koja nemaju vrednost ne prikazujemo. 
-- Country prikazujemo na osnovu spoljnog kljuca Country_Id (napraviti vezu sa Country) I prikazati naziv zemlje. 
--Naziv zemlje takodje prikazujemo samo ako postoji.
select f.Id, f.Name, 
LTRIM(CONCAT(ISNULL(a.Line1, ''), ' ', ISNULL(a.Line2, ''), ' ', ISNULL(a.Line3, ''), ' ', ISNULL(a.POBox, ''), ' ',  c.Name))
from Firm f
inner join Address a on f.Address_Id = a.Id
inner join Country c on a.Country_Id = c.Id

--13.	Prikazati sledece kolone iz tabele Firm (Id, Name, Logo, IconRecognition, Advert, IconRecognition2).
--Logo, IconRecognition, Advert, IconRecognition2 izvuci na osnovu njihovih spoljnih kljuceva iz relevantne tabele kao FileName. 
--Ukoliko nemaju vrednosti u spoljnom kljucu, prikazati prazan string.
select			fr.Id, fr.Name, 
				ISNULL(l.OriginalFileName, '') as Logo, 
				ISNULL(ir1.OriginalFileName, '') as IconRecognition, 
				ISNULL(ad.ImageName, '') as Advert, 
				ISNULL(ir2.OriginalFileName, '') as  IconRecognition2
from			Firm fr
left join [File] l on fr.Logo_Id = l.Id
left join [File] ir1 on fr.IconRecognition_Id = ir1.Id
left join [Advert] ad on fr.Advert_Id = ad.Id
left join [File] ir2 on fr.IconRecognition2_Id = ir2.Id

--14.	Prikazati sve kolone iz tabele Firm I umesto spoljnih kljuceva prikazati vrednosti entiteta koji spoljni kljuc pokazuje 
--(prikazati Name, Title, Value, sto god od toga povezani entitet poseduje). 
--Ideja je da ne vidim nikakve spoljne kljuceve u svom izvestaju, vec njihove vrednosti. 
--Nazivi takvih kolona ne treba da imaju _Id kao sufix. Gde nema vrednosti u spoljnom kljucu, prikazati kao prazan string.
select				f.Id, f.Name, ISNULL(c.Name, '') as Country, f.IsSponsored, f.Description, f.EntityStatus, 
					ISNULL(a.Line1, '') as Line1, ISNULL(a.Line2, '') as Line2, ISNULL(a.Line3, '') as Line3, 
					ISNULL(a.POBox, '') as POBox,f.Phone, f.Fax, f.Email, f.Web, f.FirmType, 
					ISNULL(ed.Forename, '') as EditorName, ISNULL(ed.Surname, '') as EditorSurname, 
					ISNULL(ed.Role, '') as EditorRole, ISNULL(ed.Email, '') as EditorEmail, 
					ISNULL(fi.OriginalFileName, '') as LogoName, 
					ISNULL(CONVERT(VARCHAR(10), fi.Category), '') as LogoCategory, ISNULL(CONVERT(VARCHAR(1), fi.Active), '') as LogoIsActive, 
					ISNULL(ir1.OriginalFileName, '') as IconRecognitionName1, 
					ISNULL(CONVERT(VARCHAR(10), ir1.Category), '') as IconRecognitionCategory1, ISNULL(CONVERT(VARCHAR(1), ir1.Active), '') as IconRecognitionIsActive1, 
					ISNULL(ad.ImageName, '') as AdvertName, ISNULL(ad.Url, '') as AdvertUrl, ISNULL(CONVERT(VARCHAR(1), ad.Active), '') as AdvertIsActive, 
					ISNULL(ir2.OriginalFileName, '') as IconRecognitionName2,
					ISNULL(CONVERT(VARCHAR(10), ir2.Category), '') as IconRecognitionCategory2, ISNULL(CONVERT(VARCHAR(1), ir2.Active), '') as IconRecognitionIsActive2, 
					f.CreatedOn, f.LastUpdatedOn,  ISNULL(cr.Forename, '') as CreatorName, ISNULL(cr.Surname, '') as CreatorSurname, 
					ISNULL(cr.Role, '') as CreatorRole, ISNULL(cr.Email, '') as CreatorEmail, ISNULL(lu.Forename, '') as LastUpdatedName, ISNULL(lu.Surname, '') as LastUpdatedSurname, 
					ISNULL(lu.Role, '') as LastUpdatedRole, ISNULL(lu.Email, '') as LastUpdatedEmail,
					ISNULL(CONVERT(VARCHAR(4), f.UpdatedForNextYear), '') as UpdatedForNextYear, f.EMLUpgrade, ISNULL(f.InsightUrl, '') as InsightUrl, 
					ISNULL(ii.OriginalFileName, '') as InsightImageName,
					ISNULL(CONVERT(VARCHAR(10), ii.Category), '') InsightImageCategory, ISNULL(CONVERT(VARCHAR(1), ii.Active), '') as InsightImageIsActive, 
					f.ProfileType, ISNULL(CONVERT(VARCHAR(10), f.SubmissionToolId), '') as SubmissionToolId
from				Firm f
left join Country c on c.Id = f.Country_Id
left join [Address] a on f.Address_Id = a.Id
left join [User] ed on f.Editor_Id = ed.Id
left join [File] fi on f.Logo_Id = fi.Id
left join [File] ir1 on f.IconRecognition_Id = ir1.Id
left join [File] ir2 on f.IconRecognition2_Id = ir2.Id
left join [File] ii on f.InsightImage_Id = ii.Id
left join Advert ad on f.Advert_Id = ad.Id
left join [User] cr on f.CreatedBy_Id = cr.Id
left join [User] lu on f.LastUpdatedBy_Id =lu.Id

--15.	Prikazati sve kolone iz tabele LawyerReview. Umesto spoljnih kljuceva prikazati vrednosti entiteta koji spoljni kljuc pokazuje. 
--Gde nema vrednosti u spoljnom kljucu, prikazati kao prazan string.
--ISNULL(CONVERT(VARCHAR(10), l.EntityStatus), '')
--ISNULL(l.FirstName, '')

select				lr.Id, lr.EntityStatus, lr.Overview, 
					ISNULL(CONVERT(VARCHAR(10), j.Id), '') as Jurisdiction, 
					ISNULL(l.FirstName, '') as LawyerName, ISNULL(l.LastName, '') LawyerLastName, ISNULL(l.Phone, '') as LawyerPhone, 
					ISNULL(l.Fax, '') as LawyerFax, 
					ISNULL(l.Email, '') as LawyerEmail, ISNULL(l.Web, '') as LawyerWeb, ISNULL(l.Language, '') as LawyerLanguage, 
					ISNULL(CONVERT(VARCHAR(10), l.EntityStatus), '') as LawyerEntityStatus,
					ISNULL(CONVERT(VARCHAR(10), l.Address_id), '') as LawyerAddress, 
					ISNULL(CONVERT(VARCHAR(10), l.Advert_Id), '') as LawyerAdvert, 
					ISNULL(CONVERT(VARCHAR(10), l.Country_Id), '') as LawyerCountry,
					ISNULL(CONVERT(VARCHAR(10), l.Editor_Id), '') as LawyerEditor ,
					ISNULL(CONVERT(VARCHAR(10), l.IconRecognition_Id), '') as LawyerIconRecognition, 
					ISNULL(CONVERT(VARCHAR(10), l.IconRecognition2_Id), '') as LawyerIconRecognition2, 
					ISNULL(CONVERT(VARCHAR(10), l.Logo_Id), '') as LawyerLogo,
					ISNULL(l.JobPosition, '') as LawyerPostion, ISNULL(CONVERT(VARCHAR(1), l.IsSponsored), '') as LawyerIsSponsored,
					ISNULL(l.LinkedInUrl, '') as LawyerUrl, ISNULL(l.CreatedOn, '') as LawyerCreatedon, 
					ISNULL(l.LastUpdatedOn, '') as LawyerLastUpdatedOn,
					ISNULL(CONVERT(VARCHAR(10), l.CreatedBy_Id), '') as LawyerCreatedBy, ISNULL(CONVERT(VARCHAR(10), l.LastUpdatedBy_Id), '') as LawyerUpdatedBy,
					ISNULL(l.AdminEmail, '') as LawyerAdminEmail, ISNULL(CONVERT(VARCHAR(10), l.Tier_Id), '') as LawyerTier,
					ISNULL(l.SourceOfInformation, '') as LawyerSource, ISNULL(CONVERT(VARCHAR(1), l.IsNotificationSent), '') as LawyerIsNotificationSent,
					ISNULL(l.InsightUrl, '') as LawyerInsightUrl, ISNULL(CONVERT(VARCHAR(10), l.InsightImage_Id), '') as LawyerInsightId,
					ISNULL(CONVERT(VARCHAR(10), p.Year), '') as Period, 
					lr.CreatedOn, lr.LastUpdatedOn, 
					ISNULL(cr.Forename, '') as CreatorName, ISNULL(cr.Surname, '') as CreatorSurname, ISNULL(cr.Role, '') as CreatorRole, ISNULL(cr.Email, '') as CreatorEmail,
					ISNULL(ed.Forename, '') as EditorName, ISNULL(ed.Surname, '') as EditorSurname, ISNULL(ed.Role, '') as EditorRole, ISNULL(ed.Email, '') as EditorEmail, 
					ISNULL(lu.Forename, '') as UpdateByName, ISNULL(lu.Surname, '') as UpdateBySurname, ISNULL(lu.Role, '') as UpdateByRole, ISNULL(lu.Email, '') as UpdateByEmail
from LawyerReview lr
left join Jurisdiction j on lr.Jurisdiction_Id = j.Id
left join Lawyer l on lr.Lawyer_Id = l.Id
left join Period p on lr.Period_Id = p.Id
left join [User] cr on lr.Editor_Id = cr.Id
left join [User] ed on lr.Editor_Id = ed.Id
left join [User] lu on lr.Editor_Id = lu.Id

--16.	Prikazati sve jurisdikcije [Jurisdiction] za koje ne postoji nijedan [LawyerReview].
select j.Id
from Jurisdiction j
left join LawyerReview lr on j.Id = lr.Jurisdiction_Id
where lr.Jurisdiction_Id is null

--17.	Prikazati sve [Lawyer] entitete za koje ne postiji nijedan LawyerReview
select l.*
from Lawyer l
left join LawyerReview lr on l.id = lr.Lawyer_Id
where lr.Lawyer_Id is null

--18.	Prikazati sledece kolone iz tabele [LawyerReview]: Id, Lawyer.FirstName, Lawyer.LastName, JurisdictionName 
--koji se odnose na 2020 I 2018 godinu.
select lr.Id, l.FirstName, l.LastName, lo.Name JurisdictionName
from LawyerReview lr 
inner join Lawyer l on lr.Lawyer_Id = l.Id
inner join Jurisdiction j on lr.Jurisdiction_Id = j.Id
inner join [Lookup] lo on lr.Jurisdiction_Id = lo.id 
inner join [Period] p on lr.Period_Id = p.Id
where YEAR(lr.CreatedOn) = 2020
or YEAR(lr.CreatedOn) = 2018

--19.	Prikazati sledece kolone iz tabele [PracticeAreaLawyer]: Sledece podatke iz tabele lawyer: FirstName, LastName, Email, Address, JobPosition. 
--Sledeci podatak iz tabele PracticeArea: Name
select l.FirstName, l.LastName, l.Email,
LTRIM(CONCAT(ISNULL(a.Line1, ''), ' ', ISNULL(a.Line2, ''), ' ', ISNULL(a.Line3, ''), ' ', ISNULL(a.POBox, ''), ' ',  c.Name)) as [Address],
lo.Name
from PracticeAreaLawyer pal
inner join Lawyer l on pal.Lawyer_Id = l.Id
left join Address a on l.Address_Id = a.Id
left join Country c on a.Country_Id = c.Id
inner join PracticeArea pa on pal.PracticeArea_Id = pa.Id
inner join Lookup lo on pa.Id = lo.Id

--20.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji imaju Ranking Tier: Expert consultant
select l.*
from LawyerRanking lr
inner join LawyerTier lt on lr.Tier_Id = lt.Id
inner join Lookup lo on lt.Id = lo.Id
inner join Lawyer l on lr.Lawyer_Id = l.Id
where lo.Name = 'Expert consultant'

--21.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji imaju Ranking Tier: Rising star partner
select l.*
from LawyerRanking lr
inner join LawyerTier lt on lr.Tier_Id = lt.Id
inner join Lookup lo on lt.Id = lo.Id
inner join Lawyer l on lr.Lawyer_Id = l.Id
where lo.Name = 'Rising star partner'

--22.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji nemaju Ranking Tier: Women Leaders
select l.*
from LawyerRanking lr
inner join LawyerTier lt on lr.Tier_Id = lt.Id
inner join Lookup lo on lt.Id = lo.Id
inner join Lawyer l on lr.Lawyer_Id = l.Id
where lo.Name <> 'Women Leaders'

--23.	Prikazati sve laywer-r koji nemaju Ranking uopste
select l.*
from LawyerRanking lr
inner join LawyerTier lt on lr.Tier_Id = lt.Id
inner join Lookup lo on lt.Id = lo.Id
inner join Lawyer l on lr.Lawyer_Id = l.Id
where l.Tier_Id is null

--24.	Prikazati sledece kolone iz tabele [RankingTierFirm]: Firm.Id, Firm.Name, Jurisdiction.Name, Period, PracticeArea, Tier.Name
select f.Id, f.Name, lod.Name as Jurisdiction, p.Year, lop.Name as PracticeArea, lot.Name as Tier
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

--25.	Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Australia' 
--(glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
select f.*, lot.Name, lod.Name
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
where lot.Name = 'Tier 1' 
and lod.Name = 'Australia'

--26.	Prikazati iz samo firme koje imaju ranking 'Tier 3' u jurisdikciji 'China' 
--(glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
select f.*, lot.Name, lod.Name
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
where lot.Name = 'Tier 3' 
and lod.Name = 'China'

--27.	Prikazati iz samo firme koje imaju ranking 'Tier 3' u jurisdikciji 'China' 
--(glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
select f.*, lot.Name, lod.Name
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
where lot.Name = 'Tier 3' 
and lod.Name = 'China'

--28.	Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Barbados' u 2014. godini 
--(glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
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
where lot.Name = 'Tier 1' 
and lod.Name = 'Barbados'
and p.Year = 2014