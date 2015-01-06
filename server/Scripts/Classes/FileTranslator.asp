<% 
Class FileTranslator
	'Properties
	Private sFileName, sSourceFilesFolder
	
	'Settings
	
	'Objects
	Private oDataSource
'	Private oInput, oLabel
	
	Public Property Get Object()
		Set Object = Me
	End Property

	Private Sub Class_Terminate()
		Set oDataSource = nothing
	End Sub
	
	Private Sub Class_Initialize()
		Set oDataSource = nothing
		Me.FileName=request.querystring("FileName")
'		sSourceFilesFolder="Formato SER-01-b PREFILTRO_archivos/" 'request.querystring("SourceFilesFolder")
	End Sub

	Public Property Get DataSource()
		Set DataSource = oDataSource
	End Property
	Public Property Let DataSource(input)
		Set oDataSource = input
	End Property

	'Properties
	Public Property Get FileName()
		FileName = sFileName
	End Property
	Public Property Let FileName(input)
		sFileName = input
	End Property

	Function readFile(byVal fileName)
		Const ParaLeer = 1
		Dim fso, f
		Set fso = CreateObject("Scripting.FileSystemObject")
		ON ERROR  RESUME NEXT
		Set f = fso.OpenTextFile(fileName, ParaLeer)
		IF Err.Number<>0 THEN
			response.write "Error al abrir archivo "&fileName&". Error:"&REPLACE(Err.Description,"'","\'")
			response.end
		END IF
		ON ERROR  GOTO 0
		readFile =  f.ReadAll
	End Function

	Public Function GetCode()
'		IF session("IdUsuario")<>1 THEN response.write "Página en mantenimiento... esto tomará algunos minutos."
		DIM strDocumento, sFullPathName
		IF TRIM(sFileName)="" THEN %>
		<center style="color:'red'; font-weight:bolder;">NO SE HA PROPORCIONADO EL NOMBRE DEL ARCHIVO.</center><br><br>
		<% RESPONSE.END
		END IF
		DIM oXMLSource
		IF NOT Me.DataSource IS NOTHING THEN 
			Set oXMLSource=Me.DataSource
		ELSE
			Set oXMLSource=nothing
		END IF
		Dim fso, f:	Set fso = Server.CreateObject("Scripting.FileSystemObject")
		IF fso.FolderExists(fso.buildPath(fso.GetParentFolderName(sFileName), fso.GetBaseName(sFileName)&"_archivos/")) THEN
			sSourceFilesFolder=fso.buildPath(fso.GetParentFolderName(sFileName), fso.GetBaseName(sFileName)&"_archivos/")
			IF fso.FileExists(fso.buildPath(sSourceFilesFolder, "sheet001.htm")) THEN
				sFileName=fso.buildPath(sSourceFilesFolder, "sheet001.htm")
			END IF
		ELSE
			sSourceFilesFolder=fso.buildPath(fso.GetParentFolderName(sFileName),"\")
		END IF
		'response.write getRelativeURLPath(sFileName)&"<br>"
		'response.write "<strong>"&sFileName&" <br> "&sSourceFilesFolder&"<br></strong>"
		'response.write "<strong>Source Files Folder:</strong>"&fso.buildPath(getRelativeURLPath(sSourceFilesFolder),"\")
		''response.end
		DIM sFolderPath:	sFolderPath=fso.GetParentFolderName(sFileName)
		strDocumento = readFile(sFileName) 
		strDocumento = CString(strDocumento).Replace("href=(stylesheet.css)", REPLACE("href="""&getRelativeURLPath(sSourceFilesFolder)&"$1""", "\", "/"))
'		strDocumento = CString(strDocumento).Replace("<!(\[[^>]+?\])>", "") 'Al mandar correos aparecen estas etiquetas, comentar esta linea cuando el archivo se mande como pdf
		DIM oXSLT:	SET oXSLT = XMLReader(server.MapPath("..\templates\controls\fileTemplate.xsl"))
		strDocumento = CString(strDocumento).Replace("src=""?([^\s""]+_\w+[\\/])?([^\s""]+)""?", REPLACE("src="""&getRelativeURLPath(sSourceFilesFolder)&"$2""", "\", "/"))
		DIM strDocumentoFinal
		DIM dataRows, dataRow
		'strDocumentoFinal=strDocumentoFinal&XMLDataBind(strDocumento, dataRows, oXSLT) 
		Set dataRows = oXMLSource.documentElement.selectNodes("//data/dataRow")
		DIM i: i=0
		For Each dataRow In dataRows
			i=i+1
			IF i>1 THEN strDocumentoFinal=strDocumentoFinal&"<BR style=""page-break-before: always"" clear=""all"">"
			strDocumentoFinal=strDocumentoFinal&XMLDataBind(strDocumento, dataRow, oXSLT) 
		Next

		'response.write "dataRows: "&dataRows.length
		'response.end
		IF INSTR(strDocumentoFinal, "«")>0 THEN %>
			<center style="color:'red'; font-weight:bolder;">EL DOCUMENTO NO ESTÁ INTERPRETADO CORRECTAMENTE.</center><br><br>
			<% IF session("IdGrupo")<>1 THEN %>
				<% '<center style="color:'red'; font-weight:bolder;">NO SE PUEDE CONTINUAR, FAVOR DE COMUNICARSE CON EL RESPONSABLE DEL SISTEMA</center><br><br> %>
				<% 'response.end %>
			<% ELSE %>
				<center style="color:'red'; font-weight:bolder;">ES POSIBLE QUE EL ARCHIVO FUENTE TENGA ERRORES ORTOGRAFICOS O GRAMATICALES Y SEA NECESARIO DESACTIVARLOS.</center><br><br>
			<% END IF 
		END IF 
		GetCode = strDocumentoFinal
	End Function

	Public Sub WriteCode()
		response.write Me.GetCode()
	End Sub

End Class %>