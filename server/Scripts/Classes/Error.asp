<% 
Function [$ErrorManager]()
	DIM oErrorManager:	Set oErrorManager = new ErrorManager
'	oErrorManager.DataField = oDataField
	Set [$ErrorManager] = oErrorManager
End Function
Class ErrorManager
	Private sOutput, iErrorNumber, sErrorMessage, bStop

	Private Sub Class_Initialize()
		sOutput="HTML"
		bStop=TRUE
	End Sub
	
	Private Sub Class_Terminate()
	End Sub

	Public Property Get Output()
		Output = sOutput
	End Property
	Public Property Let Output(input)
		sOutput = input
	End Property

	Public Property Get ErrorMessage()
		ErrorMessage = sErrorMessage
	End Property
	Public Property Let ErrorMessage(input)
		sErrorMessage = input
	End Property

	Public Property Get ErrorNumber()
		ErrorNumber = iErrorNumber
	End Property
	Public Property Let ErrorNumber(input)
		iErrorNumber = input
	End Property

	Public Property Get Stop()
		Stop = bStop
	End Property
	Public Property Let Stop(input)
		bStop = input
	End Property

	Public Sub ShowError(Error, sOutput, Description)
		SELECT CASE UCASE(sOutput)
		CASE "HTML"
			response.write "<strong class=""error"">error '"&Error&"'</strong>: "&Description&"<br><br>"
		CASE "JSON"
			response.write "{""success"":false,""message"":"""&REPLACE(replace(Description, """", "&quot;"), VBCRLF, "\"&VBCRLF)&""",""data"":[]}"
		CASE "EXTJS"
	'		response.write " Ext.Error.raise({ msg: """&replace(Description, """", "\""")&""", 'error code': "&Error&" });"
			response.write " alert(""Error "&Error&": "&replace(Description, """", "\""")&""");"
	'		IF UCASE(session("username"))="WEBMASTER" THEN 	
	'			response.write "alert("""&replace(sCommandText, """", "\""")&""");"
	'		END IF
		CASE ELSE
			response.write Description
		END SELECT
		IF bStop THEN 
			response.end
		END IF
	End Sub
End Class
 %>