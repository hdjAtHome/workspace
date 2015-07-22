--EXEC [etl].[GD_R_Lokoførertid_FR_Fix]


CREATE PROCEDURE [etl].[GD_R_Lokoførertid_FR_Fix]
AS
BEGIN

/***********************************************************************************************
Denne procedure splitter IC timer ud på togsystemer
Dette er en midliertidig fix ind til IC togsystemerne spittet i MDW

***********************************************************************************************/
DECLARE @periode VARCHAR(50)
select @periode= PERIODE from dbo.MD_Kontrol_ModelLoadInfo

DELETE from dbo.GD_R_Lokoførertid_FR_Fix
WHERE periodeIndlæst = @periode

INSERT INTO dbo.GD_R_Lokoførertid_FR_Fix (PeriodeIndlæst,Turdepot,TurdepotNavn,OpgaveType,
    OpgaveGruppe,OpgaveGruppeNavn,ElementKode,ElementKodeNavn,Produkt,Togsystem,TogsystemNavn,
    Timer,Costobjekt,TidsintervalNavn)
SELECT g.PeriodeIndlæst,g.Turdepot,g.TurdepotNavn,g.OpgaveType,g.OpgaveGruppe,g.OpgaveGruppeNavn,g.ElementKode,
    g.ElementKodeNavn,g.Produkt,
    ISNULL(p.togsystem,g.Togsystem) as togsytem,
    ISNULL(p.TogsystemNavn,g.TogsystemNavn) as TogsystemNavn,
    g.Timer*ISNULL(p.Andel, 1) Timer,
    ISNULL(p.Costobjekt,g.Costobjekt) as Costobjekt,
    g.TidsintervalNavn
FROM dbo.GD_R_Lokoførertid_FR g
left outer join (
--Procent andel
select p.PeriodeIndlæst, p.sys100, p.togsystem, p.TogsystemNavn, p.CostObjekt, p.Værdi,
  p.Værdi/sum(p.Værdi) OVER (Partition by p.PeriodeIndlæst) as Andel
from (
select PeriodeIndlæst, 100 As sys100, togsystem, TogsystemNavn, CostObjekt, SUM(Værdi) as Værdi
from dbo.GD_R_Togproduktion_FR
where togsystem in (100, 102, 103, 107)
and Enhed = 'Togtimer'
and Materielkørsel = 'ja'
and PeriodeIndlæst = @periode
group by PeriodeIndlæst, togsystem, TogsystemNavn, CostObjekt) P) P
   on (p.PeriodeIndlæst=g.PeriodeIndlæst
   and p.sys100=g.Togsystem)
WHERE g.PeriodeIndlæst = @periode



END