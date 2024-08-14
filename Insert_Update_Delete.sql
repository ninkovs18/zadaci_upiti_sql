--1. Napraviti novu tabelu (Firm_{ImePrezime}) po uzoru na postojecu u koju cemo presuti samo Firme koje su sponzorisane (IsSponsored)
select *
into Firm_StrahijaNinkov
from Firm
where IsSponsored = 1


--2. Napraviti novu tabelu (FirmArticle_{ImePrezime}) koja ce imate kolone Id, Type, Title u koju cemo presuti sve firme i article. Type kolonu u slucaju ako je firma popuniti sa 'Firm', ako je u pitanju Article popuniti sa 'Article'
select *
into FirmArticle_StrahinjaNinkov
from FirmArticle

--4. Napraviti novu tabelu, kopiju tabele Firm u tabelu koja ce da nam sluzi za vezbanje update statementa. Nova tabela treba da se zove (FirmForPractice_{ImePrezime}). Isto uraditi i za tabelu Article. Nova tabela treba da se zove (ArticleForPractice_{ImePrezime}).
--Sve dalje INSERT, UPDATE i DELETE statement-e raditi nad novim tabelama
select *
into FirmForPractice_StrahinjaNinkov
from Firm

select *
into ArticleForPractice_StrahinjaNinkov
from Article

--5. Napraviti update statement koji ce da ispravi prazna polja (prazne stringove) u kolona Email i Web tako sto ce da postavi NULL na njih. Polja koja imaju vrednosti ne diramo.
update FirmForPractice_StrahinjaNinkov
set Email = null
where Email = ''

update FirmForPractice_StrahinjaNinkov
set Web = null
where Web = ''

--6. Napraviti update statement koji ce da proveri da li su Phone i Fax kolona ista (imaju istu vrednost) ukoliko imaju istu vrednost, kolona Fax treba da se podesi na NULL. Kolonu Phone ne diramo.
update FirmForPractice_StrahinjaNinkov
set Fax = null
where Fax = Phone

--7. Napraviti update statement koji ce da ispegla kolonu [Web] na nacin tako sto ce da svaku vrednost koja se zavrsava sa / (http://www.google.com/) da ukloni krajnji / i ostane vrednost npr http://www.google.com
update FirmForPractice_StrahinjaNinkov
set Web = LEFT(Web, LEN(Web) - 1)
where Web like '%/'

--8. Ubaciti novi red u tabelu [ArticleForPractice_{ImePrezime}]. Novi red treba da bude kopija vec postojeceg reda koji ima ID 41. Sve numericke vrednosti ostaju iste, sve tekstualne vrednosti treba da imaju dodatu vrednost 'Copy' na kraju svojih vrednosti. 
--Sve datumske vrednosti treba da budu vece za 3 dana u odnosu na inicijalni red. Isprisati u konzoli ID reda koji smo dodali. Skripta treba da bude idempotentna.

GO
declare @lastId int
insert into					ArticleForPractice_StrahinjaNinkov
select						EntityStatus, IsFeatured, 
							CONCAT(Title, 'Copy'), 
							CONCAT(ShortDescription, 'Copy'),
							CONCAT(Body, 'Copy'),
							Period_Id, Sponsor_Id, Type_Id,
							DATEADD(DAY, 3, CreateDate),
							CONCAT(Author, 'Copy'),
							CONCAT(Location, 'Copy'),
							NumberOfVisits,Image_Id,
							DATEADD(DAY, 3, ExpireDate),
							ExternalId, IsSponsored,
							IsTopFeatured,
							DATEADD(DAY, 3, CreateDate),
							DATEADD(DAY, 3, LastUpdatedOn),
							CreatedBy_Id, Editor_Id, LastUpdatedBy_Id
from						ArticleForPractice_StrahinjaNinkov
where						Id = 41


set @lastId = scope_identity()
select @lastId
GO

--9. Update-ovati Article sa ID-jem 59. Title treba da bude 'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж'
update ArticleForPractice_StrahinjaNinkov
set Title = N'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж'
where Id = 59

--10. Iskopirati redove iz tabele Firm i dodati ih kao nove. Redove koje zelimo da iskopiramo imaju sledece ID-jeve (3, 4, 5, 6, 7, 8, 9, 10). Sva tekstualna polja treba da imaju sufix Copy
insert into FirmForPractice_StrahinjaNinkov
select					CONCAT(Name, ''), Country_Id, GlobalFirm_Id,
						IsSponsored, CONCAT(Description, 'Copy'), 
						EntityStatus, Address_Id, CONCAT(Phone, 'Copy'), 
						CONCAT(Fax, 'Copy'), CONCAT(Email, 'Copy'), 
						CONCAT(Web, 'Copy'), FirmType, Editor_Id, Logo_Id, 
						IconRecognition_Id, Advert_Id, IconRecognition2_Id, 
						CreatedOn, LastUpdatedOn,
						CreatedBy_Id, LastUpdatedBy_Id, UpdatedForNextYear,
						EMLUpgrade, CONCAT(InsightUrl, 'Copy'), InsightImage_Id, 
						ProfileType, SubmissionToolId
from					Firm
where					Id IN (3, 4, 5, 6, 7, 8, 9, 10)

--11. Napraviti privremenu praznu (temp) tabelu na osnovu Tabele Firm,
select *
into #Temp_StrahinjaNinkov
from Firm


--12. Napraviti privremenu temp tabelu sa sledecim kolonama (Identifikator, NazivFirme) u tu tabelu insertovati sve redove iz tabele [Firm]. Firm.Id -> Identifikator, Firm.Name -> NazivFirme. 
--Insertovani redovi treba da budu sortirani po nazivu firme.
select Id as Identifikator, Name as NazivFirme
into ##Temp_StrahinjaNinkov
from Firm
order by Name


select *
from FirmForPractice_StrahinjaNinkov


select *
from ArticleForPractice_StrahinjaNinkov
order by Id desc


begin tran

rollback
commit