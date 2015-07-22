
-- =============================================
-- Denne function levere an mail liste for en 
-- mail grupe
-- =============================================
CREATE FUNCTION [dbo].[Mail_grp_liste] (
	@mail_liste varchar(50))

RETURNS varchar(200)
AS

BEGIN

  DECLARE @Email varchar(50)	
  Declare @to_string varchar(200)	
  

  DECLARE mail_cursor CURSOR FOR
  select b.mail
  from [dbo].[MD_STYRING_Mail_Grupper] g
  join [dbo].[MD_STYRING_Mail_Lister] l on (l.gruppe_id = g.gruppe_id)
  join [dbo].[MD_STYRING_Mail_Brugere] b on (l.bruger_id = b.bruger_id)
  where (g.Gruppe_navn = @mail_liste
    or g.Gruppe_navn = 'Alle')
  group by b.mail

  OPEN mail_cursor 
  FETCH NEXT FROM mail_cursor INTO @Email
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
    set @to_string = ISNULL(@to_string, '') + ';' + @Email
    FETCH NEXT FROM mail_cursor INTO @Email
  END

  CLOSE mail_cursor
  DEALLOCATE mail_cursor

  RETURN SUBSTRING(@to_string,2,200)

END