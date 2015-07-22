CREATE TABLE [edw].[Dim_Kilde] (
    [pk_key]             INT          NULL,
    [Kilde]              VARCHAR (50) NULL,
    [KildeArk]           VARCHAR (50) NULL,
    [KildeBeskrivelse]   VARCHAR (50) NULL,
    [oprettetTidspunkt]  DATETIME     DEFAULT (getdate()) NULL,
    [oprettetAf]         [sysname]    DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt] DATETIME     NULL,
    [opdateretAf]        [sysname]    NULL
);


GO
create trigger [edw].[Dim_Kilde_updated] on [edw].[Dim_Kilde]
 AFTER  UPDATE
AS  UPDATE [edw].[Dim_Kilde] SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [edw].[Dim_Kilde].pk_key