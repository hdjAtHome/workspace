CREATE TABLE [ods].[key_Dim_Reversibilitet] (
    [pk_key]                   INT          IDENTITY (-1, 1) NOT NULL,
    [Reversibilitet_Reference] VARCHAR (50) NOT NULL,
    [oprettetTidspunkt]        DATETIME     DEFAULT (getdate()) NULL,
    [oprettetAf]               [sysname]    DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt]       DATETIME     NULL,
    [opdateretAf]              [sysname]    NULL
);


GO
create trigger [ods].[key_Dim_Reversibilitet_updated] on [ods].[key_Dim_Reversibilitet]
 AFTER  UPDATE
AS  UPDATE [ods].[key_Dim_Reversibilitet]  SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [ods].[key_Dim_Reversibilitet].pk_key