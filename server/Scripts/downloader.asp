<% 'Codigo inspirado en http://www.bestcodingpractices.com/asp_force_file_download-2695.html
ON ERROR RESUME NEXT
DIM oFSO: SET oFSO = Server.CreateObject("Scripting.FileSystemObject")
DIM sFile: sFile = TRIM(request.querystring("File"))
IF ISNULL(sFile) OR sFile="" THEN
	response.write "<strong>No se pudo recuperar el archivo</strong>"
	response.end 
END IF
DIM sPath: sPath = Server.MapPath("../../../../"&sFile)
IF TRIM(sName)="" THEN
	sName=TRIM(oFSO.getFileName(sPath))
ELSE 'Agregar opción para checar si ya trae extensión (no es urgente)
	sName=sName&"."&TRIM(oFSO.getExtensionName(sFile))
END IF
'  response.write sPath&" - "&oFSO.fileExists(sPath):   response.end
IF NOT(oFSO.fileExists(sPath)) THEN 
	response.write "<strong>El archivo no existe</strong>"
	response.end 
END IF

  ContentType = "application/x-msdownload"
  Response.Buffer = True
  Const adTypeBinary = 1
  Response.Clear
  Set objStream = Server.CreateObject("ADODB.Stream")
  objStream.Open
  objStream.Type = adTypeBinary
  objStream.LoadFromFile sPath
  ContentType = "application/octet-stream"
  Response.AddHeader "Content-Disposition", "attachment; filename=""" & sName & """"
  Response.Charset = "UTF-8"
  Response.ContentType = ContentType
  Response.BinaryWrite objStream.Read
  Response.Flush
  objStream.Close
  Set objStream = Nothing
%>