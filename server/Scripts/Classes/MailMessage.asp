<% 
'DIM oMessage: Set oMessage = new Mail
'oMessage.Message.To="uriel_online@hotmail.com"
'oMessage.Message.Subject="Probando html mail 3"
'oMessage.Message.HTMLBody "<strong>Este es un mensaje simple</strong>"
''oMessage.Message.CreateHTMLBody "http://www.w3schools.com/asp/"
''oMessage.Message.AddAttachment "D:\DropBox\My Dropbox\Websites\Px\archivos_proyectos\Resultados Semanales 2010.xls"
'oMessage.Message.Send()
'response.end


'http://www.w3schools.com/asp/asp_send_email.asp
'http://www.paulsadowski.com/wsh/cdo.htm
Const cdoSendUsingPickup = 1 'Send message using the local SMTP service pickup directory. 
Const cdoSendUsingPort = 2 'Send the message using the network (SMTP over the network). 

Const cdoAnonymous = 0 'Do not authenticate
Const cdoBasic = 1 'basic (clear-text) authentication
Const cdoNTLM = 2 'NTLM

Class MailMessage
	Private cdoConfig, cdoMessage
	Private sFrom, sTo, sCC, sSubject, sSMTPServer, sPassword

	Private Sub Class_Initialize()
	    Set cdoConfig = CreateObject("CDO.Configuration")  
	    Set cdoMessage = CreateObject("CDO.Message")  
	 	'sSMTPServer="smtp.habi.com.mx"
	End Sub
	Private Sub Class_Terminate()
	    Set cdoMessage = Nothing  
	    Set cdoConfig = Nothing  
	End Sub

	'Properties
	Public Property Let from(input)
		sFrom=input
	End Property
	Public Property Get from()
		from=sFrom
	End Property
	
	Public Property Let [to](input)
		sTo=input
	End Property
	Public Property Get [to]()
		[to]=sTo
	End Property
	
	Public Property Let cc(input)
		sCC=input
	End Property
	Public Property Get cc()
		cc = sCC
	End Property
	
	Public Property Let subject(input)
		sSubject=input
	End Property
	Public Property Get subject()
		subject = sSubject
	End Property
	
	Public Property Let SMTPServer(input)
		sSMTPServer=input
	End Property
	
	Public Property Let Password(input)
		sPassword=input
	End Property
	
	Public Property Get Message()
		Set Message = cdoMessage
	End Property 
	
	Public Sub CreateHTMLBody(input)
		cdoMessage.CreateMHTMLBody input
	End Sub

	Public Property Let HTMLBody(input)
		cdoMessage.HTMLBody = input
	End Property
	Public Property Get HTMLBody()
		HTMLBody = cdoMessage.HTMLBody
	End Property

	Public Sub AddAttachment(sAttachmentPath)
		cdoMessage.AddAttachment sAttachmentPath
	End Sub
	
	Public Sub configure()
		'==This section provides the configuration information for the remote SMTP server.
		
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
		
		'Name or IP of Remote SMTP Server
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/smtpserver") = sSMTPServer
		
		'Type of authentication, NONE, Basic (Base64 encoded), NTLM
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = cdoBasic
		
		'Your UserID on the SMTP server
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/sendusername") = sFrom
		
		'Your password on the SMTP server
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/sendpassword") = sPassword
		
		'Server port (typically 25)
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
		
		'Use SSL for the connection (False or True)
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False
		
		'Connection Timeout in seconds (the maximum time CDO will try to establish a connection to the SMTP server)
		cdoMessage.Configuration.Fields.Item _
		("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
		
		cdoMessage.Configuration.Fields.Update
		
		'==End remote SMTP server configuration section==
	End Sub
	'Methods
	Public Function Send()
		ON ERROR RESUME NEXT
	    Me.configure()

	    With cdoMessage 
	        .From = sFrom
	        .To = sTo
			.Cc = sCC
	        .Subject = sSubject
	        .Send 
	    End With 
		
		IF Err.Number<>0 THEN
			IF session("idioma")="eng" THEN %>
			<b>REQUEST COULDN'T BE SENT, PLEASE TRY E-MAILING WITH THE OTHER AVAILABLE BUTTONS ON THE SUBMENU</b>
	<% 		ELSE %>
			<b>LA SOLICITUD NO PUDO SER ENVIADA</b>
	<% 		END IF %><br><br>
			<code><%= Err.Description %></code>
	<%	ELSE
			IF session("idioma")="eng" THEN %>
			<b>REQUEST SENT</b>
	<% 		ELSE %>
			<b>CORREO ENVIADO</b>
	<% 		END IF 
		END IF
	End Function
End Class
%>