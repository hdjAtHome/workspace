CREATE TABLE [edw].[Dim_Art_Hierarki_ny_dirk] (
    [Pk_key]             INT           NULL,
    [Art]                VARCHAR (255) NULL,
    [Artsnavn]           VARCHAR (255) NULL,
    [Parent_Key]         INT           NULL,
    [Parent]             VARCHAR (255) NULL,
    [oprettetTidspunkt]  DATETIME      DEFAULT (getdate()) NULL,
    [oprettetAf]         [sysname]     DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt] DATETIME      NULL,
    [opdateretAf]        [sysname]     NULL
);


GO

create trigger [edw].[Dim_Art_Hierarki_ny_dirk_updated] on [edw].[Dim_Art_Hierarki_ny_dirk]
 AFTER  UPDATE
AS  UPDATE [edw].[Dim_Art_Hierarki_ny_dirk]  SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [edw].[Dim_Art_Hierarki_ny_dirk].pk_key