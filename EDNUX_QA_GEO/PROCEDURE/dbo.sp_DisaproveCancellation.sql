/****** Object:  StoredProcedure [dbo].[sp_DisaproveCancellation]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_DisaproveCancellation]
GO
/****** Object:  StoredProcedure [dbo].[sp_DisaproveCancellation]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_DisaproveCancellation]
As
Begin
delete  from Cancelled where CancelledTransID in (select CancelledTransID from CancelledTrans where ApprovalStatus ='N');
delete from CancelledTrans where ApprovalStatus ='N'
END
GO
