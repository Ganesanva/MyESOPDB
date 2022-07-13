IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_GET_TAXFORAUTOEXERCISE')
BEGIN
DROP PROCEDURE PROC_GET_TAXFORAUTOEXERCISE
END
GO

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_TENTATIVETAX_FORAUTOEXERCISE')
BEGIN
DROP PROCEDURE PROC_TENTATIVETAX_FORAUTOEXERCISE
END
GO

IF EXISTS(SELECT NAME FROM SYS.TYPES WHERE NAME = 'TYPE_PERQ_FORAUTOEXERCISE')
BEGIN
DROP TYPE TYPE_PERQ_FORAUTOEXERCISE
END
GO


CREATE TYPE [dbo].[TYPE_PERQ_FORAUTOEXERCISE] AS TABLE (
    [MIT_ID]             INT             NULL,
    [EmployeeID]         VARCHAR (50)    NULL,
    [FMV]                NUMERIC (18, 9) NULL,
    [Total_Perk_Value]   NUMERIC (20, 9) NULL,
    [EVENT_OF_INCIDENCE] INT             NULL,
    [GRANT_DATE]         DATETIME        NULL,
    [VESTING_DATE]       DATETIME        NULL,
    [EXERCISE_DATE]      DATETIME        NULL,
    [GRANTOPTIONID]      VARCHAR (100)   NULL,
    [GRANTLEGSERIALNO]   BIGINT          NULL,
    [TEMP_EXERCISEID]    BIGINT          NULL,
    [STOCK_VALUE]        NUMERIC (20, 9) NULL);
GO

