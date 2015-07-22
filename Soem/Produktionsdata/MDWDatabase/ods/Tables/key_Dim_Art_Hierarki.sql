CREATE TABLE [ods].[key_Dim_Art_Hierarki] (
    [pk_key]             INT          IDENTITY (-1, 1) NOT NULL,
    [Art]                VARCHAR (50) NOT NULL,
    [oprettetTidspunkt]  DATETIME     DEFAULT (getdate()) NULL,
    [oprettetAf]         [sysname]    DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt] DATETIME     NULL,
    [opdateretAf]        [sysname]    NULL
);


GO
create trigger [ods].[key_Dim_Art_Hierarki_updated] on [ods].[key_Dim_Art_Hierarki]
 AFTER  UPDATE
AS  UPDATE [ods].[key_Dim_Art_Hierarki] SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [ods].[key_Dim_Art_Hierarki].pk_key