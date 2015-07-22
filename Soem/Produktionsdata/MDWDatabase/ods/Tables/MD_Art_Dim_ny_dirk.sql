CREATE TABLE [ods].[MD_Art_Dim_ny_dirk] (
    [ArtID]             VARCHAR (255) NULL,
    [MemberName]        VARCHAR (255) NULL,
    [Parent]            VARCHAR (255) NULL,
    [oprettetTidspunkt] DATETIME      DEFAULT (getdate()) NULL,
    [oprettetAf]        [sysname]     DEFAULT (suser_sname()) NOT NULL
);

