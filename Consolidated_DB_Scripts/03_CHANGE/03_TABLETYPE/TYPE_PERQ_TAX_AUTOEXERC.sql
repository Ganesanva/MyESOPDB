IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_TENTATIVETAX_FORAUTOEXERCISE')
BEGIN
DROP PROCEDURE PROC_TENTATIVETAX_FORAUTOEXERCISE
END
GO

IF EXISTS(SELECT NAME FROM SYS.TYPES WHERE NAME = 'TYPE_PERQ_TAX_AUTOEXERC')
BEGIN
DROP TYPE TYPE_PERQ_TAX_AUTOEXERC
END
GO

CREATE TYPE [dbo].[TYPE_PERQ_TAX_AUTOEXERC] AS TABLE (
    [INSTRUMENT_ID]    BIGINT          NULL,
    [EMPLOYEE_ID]      VARCHAR (50)    NULL,
    [COUNTRY_ID]       INT             NULL,
    [GRANTOPTIONID]    VARCHAR (100)   NULL,
    [TOT_DAYS]         FLOAT (53)      NULL,
    [VESTING_DATE]     DATETIME        NULL,
    [GRANTLEGSERIALNO] BIGINT          NULL,
    [FROM_DATE]        DATETIME        NULL,
    [TO_DATE]          DATETIME        NULL,
    [TEMP_EXERCISEID]  BIGINT          NULL,
    [STOCK_VALUE]      NUMERIC (18, 9) NULL);
GO



