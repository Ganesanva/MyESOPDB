/****** Object:  StoredProcedure [dbo].[PROC_GET_TEMPLATE_FIELDS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TEMPLATE_FIELDS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TEMPLATE_FIELDS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PROC_GET_TEMPLATE_FIELDS]
AS

BEGIN

SELECT * FROM MST_ADDIN_PARAMETERS WHERE PARAMETERTYPE = 'TABLE'

SELECT * FROM MST_ADDIN_PARAMETERS WHERE PARAMETERTYPE != 'TABLE'

END 
GO
