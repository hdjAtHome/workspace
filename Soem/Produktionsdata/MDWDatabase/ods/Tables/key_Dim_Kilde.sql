CREATE TABLE [ods].[key_Dim_Kilde] (
    [pk_key]             INT          IDENTITY (-1, 1) NOT NULL,
    [KildeArk]           VARCHAR (50) NULL,
    [KildeBeskrivelse]   VARCHAR (50) NULL,
    [oprettetTidspunkt]  DATETIME     DEFAULT (getdate()) NULL,
    [oprettetAf]         [sysname]    DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt] DATETIME     NULL,
    [opdateretAf]        [sysname]    NULL
);


GO
create trigger [ods].[key_Dim_Kilde_updated] on [ods].[key_Dim_Kilde]
 AFTER  UPDATE
AS  UPDATE [ods].[key_Dim_Kilde] SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [ods].[key_Dim_Kilde].pk_key