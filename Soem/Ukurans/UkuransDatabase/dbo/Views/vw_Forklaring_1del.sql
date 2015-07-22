




Create view [dbo].[vw_Forklaring_1del]
-- Ajourført 141114-1: Ændret FraTil_Tid med en Cast, da det fyldte 8000... 
-- Ajourført 150318-1: Delt i 2 da "minimum row size exceeds the maximum allowable of 8060 bytes"
-- Ajourført 150324-1: Indsat værdier for LNType og FLNType i select 'KASS_BEH' 

as
--insert into edw.FT_Forklaring
select 'PRIMO_BEH_NET' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType,  FLNType, FraTil_tid, AnskVaerdi, NedForPrinc
	,Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr
	, NedskrNetto NedskrNetto
	,Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.vw_Nedskriv_Primo_Netto
union all

--insert into edw.FT_Forklaring
select 'PRIMO_BEH_BRT' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType,  FLNType, FraTil_tid, AnskVaerdi, NedForPrinc
	,Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr
	, NedskrNetto NedskrNetto
	,Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.vw_Nedskriv_Primo_Brutto
union all

--insert into edw.FT_Forklaring
select 'KASS_BEH' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType,  FLNType, FraTil_tid, AnskVaerdi, NedForPrinc
	,Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr
	, NedskrNetto NedskrNetto
	,Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.vw_kassation
union all

--insert into edw.FT_Forklaring
select 'FALDE_BEH' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	Null
					End
	End DSystAendr
	, NedskrNetto
	, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.[vw_Faldende_Beh]

union all
--insert into edw.FT_Forklaring
select 'STIGEN_BEH' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	Null
					End
	End DSystAendr
	, NedskrNetto
	, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.[vw_Stigende_Beh] --check this error:Warning: Null value is eliminated by an aggregate or other SET operation
union all
--insert into edw.FT_Forklaring
select 'SAMME_BEH' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr
	, NedskrNetto
	, 0 Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.[vw_Samme_Beh]
union all
--insert into edw.FT_Forklaring
select 'NY_INDK_PER' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr
	, NedskrNetto
	, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.[vw_NyIndkPer_Beh]
/*union all
--insert into edw.FT_Forklaring
select 'AFSTEMNING1' Aendring,  Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr,
NedskrNetto, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from [dbo].[vw_Afstemning]
*/
union all
--insert into edw.FT_Forklaring
select 'LOG_NEDS_BRUT' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr
	, NedskrNetto
	, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from dbo.vw_LogNedsBrutto
/*
union all
--insert into edw.FT_Forklaring
select 'KORR_NYEMAT_3' Aendring, Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr,
NedskrNetto, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from [dbo].[vw_KorrNyeMat36m]
union all
--insert into edw.FT_Forklaring --check feil: Warning: Null value is eliminated by an aggregate or other SET operation.
select 'ULTBEH_INDK12' Aendring,  Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr,
NedskrNetto, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from [dbo].[vw_UltBeh_Indk12md]
union all
--insert into edw.FT_Forklaring
select 'NEDS_NETTO' Aendring,  Dim_Fabrik, Materiale, Dim_Materiale, LNType, FLNType, FraTil_tid, AnskVaerdi, NedForPrinc, 
	Case	When	NedskrNetto <> 0 
			Then	Case	When	NedForPrinc	<>	0 
							Then	NedskrNetto	-	NedForPrinc
							Else	NedskrNetto
					End
			Else	Case	When	NedForPrinc	<>	0
							Then	NedForPrinc * -1
							Else	0
					End
	End DSystAendr,
NedskrNetto, Beholdning, Vaerdi_SP, Isnull(AnskVaerdi, 0) - Isnull(Vaerdi_SP, 0) as Forskel
from [dbo].[vw_NedskrivNetto]


*/