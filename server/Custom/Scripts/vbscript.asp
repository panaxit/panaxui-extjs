<% 
Class Mail
	DIM oMessage
	Private Sub Class_Initialize()
		Set oMessage = new MailMessage
		oMessage.SMTPServer="mail.registrateunidos.net"
		oMessage.From="noreply@registrateunidos.net"
		oMessage.Password="Unidos12!"
	End Sub
	Private Sub Class_Terminate()
		SET oMessage = NOTHING
	End Sub
	
	Public Property Get Message()
		Set Message = oMessage
	End Property
End Class
%>