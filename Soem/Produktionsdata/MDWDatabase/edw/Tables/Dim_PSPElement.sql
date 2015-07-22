CREATE TABLE [edw].[Dim_PSPElement] (
    [Pk_key]             INT           NULL,
    [PSPElement]         VARCHAR (255) NULL,
    [PSPElementnavn]     VARCHAR (255) NULL,
    [oprettetTidspunkt]  DATETIME      DEFAULT (getdate()) NULL,
    [oprettetAf]         [sysname]     DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt] DATETIME      NULL,
    [opdateretAf]        [sysname]     NULL
);


GO
create trigger[edw].[Dim_PSPElement_updated] on [edw].[Dim_PSPElement]
 AFTER  UPDATE
AS  UPDATE[edw].[Dim_PSPElement]  SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [edw].[Dim_PSPElement].pk_key