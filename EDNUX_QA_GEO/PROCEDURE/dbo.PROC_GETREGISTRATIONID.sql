/****** Object:  StoredProcedure [dbo].[PROC_GETREGISTRATIONID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETREGISTRATIONID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETREGISTRATIONID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETREGISTRATIONID]
(
@PARAM varchar(100)
)
AS
BEGIN
	IF(@PARAM='REGID')
	BEGIN
		select distinct GrantRegistrationId from GrantRegistration
	END
	
	IF(@PARAM='ENTITY')
	BEGIN
		select distinct FIELD_VALUE from MASTER_LIST_FLD_VALUE
	END
END
GO
