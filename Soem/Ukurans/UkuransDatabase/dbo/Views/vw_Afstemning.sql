



CREATE view [dbo].[vw_Afstemning] 
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000...
as
Select Aendring 
      ,Dim_Fabrik 
      ,Materiale 
      ,Dim_Materiale 
      ,LNType 
      ,FLNType 
      ,FraTil_Tid 
      ,sum(Beholdning) as  Beholdning 
      ,sum(AnskVaerdi) as  AnskVaerdi 
      ,sum(NedForPrinc) as  NedForPrinc 
      ,sum(NedskrNetto) as  NedskrNetto 
      ,sum(Vaerdi_SP) as  Vaerdi_SP 
      ,sum(Forskel) as  Forskel 
From dbo.vw_Afstemn_fork
Group by  Aendring 
      ,Dim_Fabrik 
      ,Materiale 
      ,Dim_Materiale 
      ,LNType 
      ,FLNType 
      ,FraTil_Tid 
Having abs(sum(Beholdning)) > .009
  or   abs(sum(AnskVaerdi)) > .009
  or   abs(sum(NedForPrinc)) > .009
  or   abs(sum(NedskrNetto)) > .009
  or   abs(sum(Vaerdi_SP)) > .009
  or   abs(sum(Forskel)) > .009