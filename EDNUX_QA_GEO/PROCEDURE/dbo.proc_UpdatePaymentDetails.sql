/****** Object:  StoredProcedure [dbo].[proc_UpdatePaymentDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[proc_UpdatePaymentDetails]
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdatePaymentDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[proc_UpdatePaymentDetails] @ExerciseNo integer ,@Paymentmode char,@Action char
As
	BEGIN
		if (@Paymentmode='Q' OR  @Paymentmode='D' OR @Paymentmode='W' OR @Paymentmode='R' )
			update ShTransactionDetails set	[STATUS]=@Action where ExerciseNo =@ExerciseNo
		if(@Paymentmode='N')	
			update transaction_details set	[STATUS]=@Action,ExerciseNo=@ExerciseNo where Sh_ExerciseNo=@ExerciseNo
		if(@Paymentmode ='A' OR @Paymentmode='P')
			update TransactionDetails_cashless set	[STATUS]=@Action where ExerciseNo =@ExerciseNo
		if(@Paymentmode ='F')
			update TransactionDetails_funding set	[STATUS]=@Action where ExerciseNo =@ExerciseNo
	END
GO
