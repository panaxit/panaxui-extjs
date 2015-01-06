<% 
'Función de motobit
Function RecurseMKDir(ByVal Path)
  Dim FS: Set FS = CreateObject("Scripting.FileSystemObject")
	
  Path = Replace(Path, "/", "\")
  If Right(Path, 1) <> "\" Then Path = Path & "\"   '"
  Dim Pos, n
  Pos = 0: n = 0
  Pos = InStr(Pos + 1, Path, "\")   '"
  Do While Pos > 0
    On Error Resume Next
    FS.CreateFolder Left(Path, Pos - 1)
    If Err = 0 Then n = n + 1
    Pos = InStr(Pos + 1, Path, "\")   '"
  Loop
  RecurseMKDir = n
End Function



Function UserSiteMap()
	'IF SESSION("IdUsuario")="" THEN response.write "<strong>ES NECESARIO INICIAR SESIÓN</strong>": response.end
	IF NOT IsObject(SESSION("UserSiteMap")) THEN
		DIM oCn:	set oCn=server.createobject("adodb.connection")
		oCn.open SESSION("StrCnn")
		oCn.CommandTimeout = 120 
		
		DIM rsRecordSet:	Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
		rsRecordSet.CursorLocation 	= 3
		rsRecordSet.CursorType 		= 3
		
		ON ERROR RESUME NEXT
			DIM sSQL:	sSQL="[$Security].UserMapSite @@IdUser="&SESSION("IdUsuario")&", @lang='"&SESSION("lang")&"'"
			set rsRecordSet=oCn.execute(sSQL)
			SELECT CASE Err.Number
			CASE -2147217900
				response.write "<strong class=""error"">Error: "&REPLACE(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")&"</strong>"
				IF session("IdUsuario")=-1 THEN 	response.write "<br/><br/>"&sSQL
				response.end
			CASE 0
				'continue
			CASE ELSE
				response.write "Error "&Err.Number&"!, no se pudo recuperar la información.<br><br>"
				IF session("IdUsuario")=-1 THEN 	response.write Err.Description&" <br><br>"&sSQL
				response.end
				Err.Clear
			END SELECT
		ON ERROR  GOTO 0
	
		DIM oSiteMap:	set oSiteMap = Server.CreateObject("Microsoft.XMLDOM"): oSiteMap.Async = false: oSiteMap.LoadXML(rsRecordSet(0))
		SET SESSION("UserSiteMap")=oSiteMap 
	END IF
	SET UserSiteMap = SESSION("UserSiteMap")
End Function

Function XMLReader(xml)
	DIM oXMLFile
	IF IsObject(xml) THEN
		Set oXMLFile = xml
	ELSE
		set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
	    oXMLFile.Async = false
		IF testMatch(TRIM(xml), "^<.*>$") THEN
		    oXMLFile.LoadXML(xml)
		ELSE
		    oXMLFile.Load(xml)
		END IF
		ReportParseError oXMLFile
	END IF
Set XMLReader = oXMLFile
End Function

Function transformXML(xmlfile, xslfile)
	Dim xmlDoc, xslDoc
	IF IsObject(xmlFile) THEN
		Set xmlDoc=xmlFile
	ELSE
		Set xmlDoc=XMLReader(xmlfile)
	END IF
	IF IsObject(xslfile) THEN
		Set xslDoc=xslfile
	ELSE
		Set xslDoc=XMLReader(xslfile)
	END IF
	IF xmlDoc IS NOTHING THEN
		transformXML="<strong style=""color:red"">Error!</strong>"
	ELSE
		transformXML=CString(xmlDoc.transformNode(xslDoc)).replace("<\?xml.*?\?>", "")
	END IF
End Function

Function Transform(xmlfile, xslfile)
	Dim xmlDoc, xslDoc
	
	IF IsObject(xmlfile) THEN
		Set xmlDoc = xmlfile
	ELSE
		'Load XML file
		set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
		xmlDoc.async = false
		xmlDoc.load(xmlfile)
		ReportParseError xmlDoc
	END IF
	'Load XSL file
	set xslDoc = Server.CreateObject("Microsoft.XMLDOM")
	xslDoc.async = false
	xslDoc.load(xslfile)
	ReportParseError xslDoc
	'Transform file
	ON ERROR  RESUME NEXT
		Transform=xmlDoc.transformNode(xslDoc)
	SELECT CASE Err.Number
	CASE 0
		'Response.write result
	CASE ELSE
		Response.write "<b>Error: "&Err.Number&":</b> "&Err.Description&"<br/><br/>"
		Err.Clear
		response.end
	END SELECT
	ON ERROR  GOTO 0
End Function

Function TransformData(xmlfile, xslfile)
	ON ERROR  RESUME NEXT
	Dim result: result=Transform(xmlfile, xslfile)
	SELECT CASE Err.Number
	CASE 0
		Response.write result
	CASE ELSE
		Response.write "<b>Error: "&Err.Number&":</b> "&Err.Description&"<br/><br/>"
		Err.Clear
	END SELECT
	ON ERROR  GOTO 0
End Function

Sub ReportParseError(oXMLFile)
	if oXMLFile.parseError.errorcode<>0 then%>
	<span class="error">
  	<label>El <% IF NOT TRIM(oXMLFile.parseError.url)="" THEN %>archivo <%= oXMLFile.parseError.url %><% END IF %> xml contiene el siguiente error:</label><br/>
  	<strong id="reason"><%= oXMLFile.parseError.reason %></strong>
  	</span>
  <%response.end
	end if
End Sub

Function RandomNumber(intHighestNumber)
	Randomize
	RandomNumber = Int(Rnd * intHighestNumber) + 1
End Function

Function testMatch(sOriginal, sPatrn)
	Dim regEx, Match, Matches, strReturn
	Set regEx = New RegExp
	regEx.Pattern = sPatrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
	testMatch = regEx.Test(sOriginal)
End Function

Function getMatch(sOriginal, sPatrn)
	Dim regEx, Match, Matches, strReturn
	Set regEx = New RegExp
	regEx.Pattern = sPatrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
	Set Matches = regEx.Execute(sOriginal) 
	Set getMatch = Matches
End Function

Function replaceMatch(sOriginal, sPatrn, sReplacementText)
	Dim regEx, Match, Matches, strReturn
	Set regEx = New RegExp
	regEx.Pattern = sPatrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
	IF IsNullOrEmpty(sOriginal) THEN
		replaceMatch = ""
	ELSE
		replaceMatch = regEx.Replace(sOriginal, sReplacementText) 
	END IF
End Function

Function replaceEvaluatingMatch(sOriginal, sPatrn, sReplacementText)
	Dim regEx, Match, Matches, strReturn
	Set regEx = New RegExp
	regEx.Pattern = sPatrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
	IF IsNullOrEmpty(sOriginal) THEN
		replaceEvaluatingMatch = ""
	ELSE
		replaceEvaluatingMatch = regEx.Replace(sOriginal, sReplacementText) 'Evaluate(regEx.Replace(sOriginal, sReplacementText))
	END IF
End Function

Function applyTemplate(sOriginal, sPatrn, sTemplate)
	Dim regEx, Match, Matches, strReturn
	Set regEx = New RegExp
	regEx.Pattern = sPatrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
	strReturn=regEx.Replace(sOriginal, sTemplate)
	strReturn=REPLACE(strReturn, "ñ", "ni")
	strReturn=REPLACE(strReturn, "Ñ", "NI")
	applyTemplate=EVAL(strReturn)
End Function

Function getDisplayName(strTemp)
	Dim patrn
	patrn="\{(.*)\}*"
	Dim regEx, Match, Matches
	Set regEx = New RegExp
	regEx.Pattern = patrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
	strTemp=regEx.Replace(strTemp, "")
	getDisplayName=strTemp
End Function

Function getParameters(ByVal sParameters)
	Set getParameters = getMatch(sParameters, "(?:@)([\w\.\(\)""]*)=([^@]*)(?!(\s*@))")
'	Set getParameters = getMatch(sParameters, "(?:@)([\w\.\(\)""]*)=([\w\d\s,=\(\)\[\]""'\.\*\+\/\-\\&\?\!<>]*)(?!(\s*@))")
End Function

Function getMetadataString(sOriginal, sColumnName)
	Dim patrn, regEx, Match, Submatch, sMetadataString
	patrn=","&sColumnName&"@{(.*?)}@"
'	strMatchPattern="«\w*(\([^«]|[\w\(\)\,\s\-]*\))*»"
'	Debugger Me, "<strong>"&sColumnName&"("&getMatch(","&sOriginal, patrn).Count&"): </strong> ("&sOriginal&"): "
'	response.write sOriginal &"<br>"
	For Each Match in getMatch(","&sOriginal, patrn)
		FOR EACH Submatch IN Match.Submatches
			getMetadataString=TRIM(Submatch)
		NEXT
	Next 
End Function

Function getMetadata(sOriginal, sColumnName, sPropertyName)
'	sOriginal=getMetadataString(sOriginal, sColumnName)
	Dim strMatchPattern, i, Match, sValue
'	response.write sOriginal & "<br>"
	'IF sPropertyName="ControlParameters" THEN Debugger Me, sOriginal
	strMatchPattern=";@"&sPropertyName&"\:(.*?);@"
	'IF sPropertyName="ControlParameters" THEN Debugger Me, strMatchPattern
'	strMatchPattern="«\w*(\([^«]|[\w\(\)\,\s\-]*\))*»"
	DIM SubMatch
	i=0
	For Each Match in getMatch(";"&sOriginal&"@", strMatchPattern)
		'For Each SubMatch IN Match.SubMatches
			sValue=TRIM(Match.SubMatches(0))
		'NEXT
'		i=i+1
'		sValue=LEFT(Match.value, LEN(Match.value)-1)
'		sValue=RTRIM(replace(sValue, ";"&sPropertyName&":", ""))
	Next 
'	Debugger Me, sPropertyName&"> "&sValue
'	response.write "<br><br>"
	IF sValue="NULL" THEN sValue=NULL
	getMetadata=sValue
End Function

Function Evaluate(ByVal sInput)
	Evaluate=fncEvaluate(sInput)
End Function
Function fncEvaluate(ByVal sInput)
	DIM vReturnValue
'	IF IsObject(vInput) THEN
'		EXECUTE("Set Evaluate=sInput")
'	ELSE
	ON ERROR  RESUME NEXT
	EXECUTE("vReturnValue="&CString(sInput).RemoveEntities())
	IF Err.Number<>0 THEN
		response.write "Ocurrió el siguiente error en funcion <strong>fncEvaluate</strong>:"&Err.Description&vbcrlf&"<br> Al evaluar "&sInput&".<br>"
		Debugger Me, ("vReturnValue="&CString(sInput).RemoveEntities().Replace("(["&chr(13)&""&chr(9)&""&chr(10)&""&vbcr&""&vbcrlf&""&vbtab&"])", "<strong>-especial-</strong>"))
		response.end
		Err.Clear
	END IF
	ON ERROR  GOTO 0
'	END IF
	fncEvaluate=vReturnValue
End Function


function evalTemplate(byVal fldformat, ByRef oDictionary, ByVal aDataRow)
	Dim patrn, fldvalue
	patrn="\{(\w*)\}*"
	Dim regEx, Match, Matches
	Set regEx = New RegExp
	regEx.Pattern = patrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
''				response.write fldformat &"-->"
'	fldvalue=regEx.Replace(fldformat, "getDataRowValue(RowNumber, oDictionary(""fieldsDictionary"")(""$1""))")
	fldvalue=regEx.Replace(fldformat, "getDataRowValue(aDataRow, oDictionary.item(""$1"").ParentCell.ColumnNumber)")
''                fldvalue=replace(fldformat, "{0}", fldvalue) '"datarow(oDictionary(""fieldsDictionary"")(""PrecioViv""))-123")
	evalTemplate=EVAL(fldvalue)
End Function

function EvaluateTemplate(byVal fldformat, ByRef oDictionary, ByVal iRecord)
	Dim patrn, fldvalue
	patrn="\{(\w*)\}*"
	Dim regEx, Match, Matches
	Set regEx = New RegExp
	regEx.Pattern = patrn
	regEx.IgnoreCase = True				' Distinguir mayúsculas de minúsculas.
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
	regEx.Global = True
'	Dim a, i
'	a=oDictionary.Keys
'	for i=0 to oDictionary.Count-1
'	  Response.Write("a: "&a(i))
'	  Response.Write("<br />")
'	next
'	set a=nothing
	fldvalue=regEx.Replace(fldformat, "oDictionary.item(""$1"")")'oDictionary.item(""$1"").Value")
'	response.write fldvalue&"<br>"
	EvaluateTemplate=EVAL(fldvalue)
End Function

Function TranslateTemplate(ByVal sTemplate)
	TranslateTemplate=CString(sTemplate).Remove(vbcrlf).Replace("\\""", """""").Replace("\$_GET\[""(.*?)""\]", "request.querystring(""$1"")").Replace("([^\\])\[(?!\$)(\w*)\](?!=\!)", "$1oFields(""$2"")").RemoveEntities().Replace("((?=.?)(?!\\)\[(?!\$)(?:\w*)(?!\\)\])(\!)", "$1") '\[(?!\$)(\w*)\]
End Function

function EvaluateFieldsTemplate(ByVal sTemplate, ByRef oFields)
	ON ERROR  RESUME NEXT: 
	IF sTemplate<>"" THEN
		Assign EvaluateFieldsTemplate, EVAL(sTemplate)
		'EXECUTE("SET EvaluateFieldsTemplate."&sPropertyName&"=Evaluate(sTemplate)")
		'IF Err.Number<>0 THEN
		'	Err.Clear
		'	EXECUTE("EvaluateFieldsTemplate."&sPropertyName&"=sTemplate")
		'END IF
	ELSE
		EvaluateFieldsTemplate=sTemplate
	END IF
	[&Catch] TRUE, Me, "EvaluateFieldsTemplate", ""&sTemplate&" <strong>=></strong><br> ": ON ERROR  GOTO 0
End Function 

function ContextualEvaluation(ByVal sTemplate, ByRef oContext)
	ON ERROR  RESUME NEXT: 
	IF sTemplate<>"" THEN
		Assign EvaluateFieldsTemplate, Evaluate(sTemplate)
		EXECUTE("SET EvaluateFieldsTemplate."&sPropertyName&"=Evaluate(sTemplate)")
		IF Err.Number<>0 THEN
			Err.Clear
			EXECUTE("oElement."&sPropertyName&"=vInput")
		END IF

	ELSE
		EvaluateFieldsTemplate=sTemplate
	END IF
	[&Catch] TRUE, Me, "EvaluateFieldsTemplate", ""&sTemplate&" <strong>=></strong><br> ": ON ERROR  GOTO 0
End Function 

function EvaluateRowTemplate(byVal sTemplate, ByRef oFields)
	Dim fldvalue
	fldvalue=TranslateTemplate(sTemplate)
'	fldvalue=regEx.Replace(sTemplate, "oFields(""$1"")")'oDictionary.item(""$1"").Value")

'	response.write fldvalue&"<br>"
	ON ERROR  RESUME NEXT: 
	DIM oResult
	Assign oResult, EVAL(fldvalue)
	[&Catch] TRUE, Me, "EvaluateRowTemplate", ""&sTemplate&" <strong>=></strong><br> "&fldvalue: ON ERROR  GOTO 0

	IF IsObject(oResult) THEN
		Set EvaluateRowTemplate=oResult
	ELSE
		EvaluateRowTemplate=oResult
	END IF
End Function

Function TextDataBind(byRef sText, ByRef oFields)

'"& (""&RTRIM( Candidato )&"") &" 
'RESPONSE.WRITE  eval("""Texto: ""&Evaluate(""RTRIM( ""& """""""&Candidato&""""""" &"" )"")&"" Fin Texto""")
'"&RTRIM(""«Candidato»""))&"



'RESPONSE.WRITE  EVAL("""Texto: ""&RTRIM(Candidato)&"" Fin Texto""")
'RESPONSE.WRITE  EVAL("""Texto: ""&Evaluate("""&REPLACE("""&RTRIM(""""&Candidato&"""")&""", """", """""""")&""")&"" Fin Texto""")
'RESPONSE.WRITE Evaluate("""Nombre: ""& (""&( Candidato )&"") &""""" )
'RESPONSE.END

'	Set TextDataBind = CString(sText).Replace("""", """""").Append("""").Prepend("""").Replace("(?:&lt;|<)%(.*?)%(?:&gt;|>)", """&Evaluate(""($1)"") &""" ).Replace("(?:&laquo;|«)(.*?)(?:&raquo;|»)", """&(""$1"")&""").Evaluate()
'"""& (""Evaluate( $1 ) "") &"""
	IF NOT oFields IS NOTHING THEN
		Set TextDataBind = CString(sText).DoubleQuote() _
			.Replace("""(?:&laquo;|«)(.*?)(?=[\s]*(?:&raquo;|»))", """") _
			.Replace("\[(.*?)\](?=[\)\s]*(?=&raquo;|»))", "oFields(""$1"").GetCode()") _
			.Replace("\{(.*?)\}(?=[\)\s]*(&raquo;|»))", "oFields(""$1"")") _
			.Replace("#(.*?)#(?=&raquo;|»)", "session(""$1"")") _
			.Replace("(?:&laquo;|«)(.*?)(?:&raquo;|»)", """&( $1 )&""") _
			.Evaluate()
	ELSE
		Set TextDataBind = CString(sText).DoubleQuote() _
			.Replace("(?:&laquo;|«)(.*?)(?:&raquo;|»)", """&( $1 )&""") _
			.Evaluate()
	END IF
End Function

Function TextEvaluate(byRef sText)
	Set TextEvaluate = CString(sText).Replace("""", """""").Append("""").Prepend("""").Replace("(?:&laquo;|«)(.*?)(?:&raquo;|»)", """&($1)&""").Evaluate()
End Function

'Function GetDataField(sDataField, byVal oXML, oXSL)
'	'response.write sDataField&": "&oXML.nodeName&"<br/>"
'	DIM oDataField: SET oDataField=oXML'.selectSingleNode("//data/dataRow")
'	'oXML.setAttribute "use", sDataField
'	'response.write sDataField&": "
'	'response.write oXML.selectSingleNode(sDataField).getAttribute("value")
'	GetDataField=transformXML(oXML.selectSingleNode(sDataField), oXSL)'.getAttribute("value")'transformXML(oXML, oXSL)
'End Function

Function createRootElement(oXML, oXSL)
	createRootElement=transformXML(oXML.selectSingleNode("/"), oXSL)
End Function

Function XMLDataBind(byRef sText, ByRef oXMLDataSource, ByVal oXSLFile)
'RESPONSE.WRITE transformXML(oXMLDataSource.getElementsByTagName("NumeroOC")(0), oXSLFile)
	'response.write oXMLDataSource.getAttribute("rowNumber")
	XMLDataBind=REPLACE(createRootElement(oXMLDataSource, oXSLFile),"@@CONTENT", EVAL(CString(sText).DoubleQuote() _
	.Replace("""(?:&laquo;|«)(.*?)(?=[\s]*(?:&raquo;|»))", """") _
	.Replace("\[(.*?)\](?=[\)\s]*(?=&raquo;|»))", "transformXML(oXMLDataSource.selectSingleNode(""$1""), oXSLFile)") _
	.Replace("\{(.*?)\}(?=[\)\s]*(&raquo;|»))", "transformXML(oXMLDataSource.selectSingleNode(""$1""), oXSLFile)") _
	.Replace("#(.*?)#(?=&raquo;|»)", "session(""$1"")") _
	.Replace("(?:&laquo;|«)(.*?)(?:&raquo;|»)", """&( $1 )&""") _
	.RemoveEntities() _
))
End Function

Function getDataRowValue(ByVal aDataRow, ByVal FieldColumnNumber)
	Dim thisrow, returnValue
	IF FieldColumnNumber="" THEN
		returnValue=""
	ELSE
'        thisrow=arrayData(RowNumber)
'		response.write "RowNumber: "&RowNumber&", FieldColumnNumber: "&FieldColumnNumber&" ("&thisrow&")<br>"
'		aDataRow=split(thisrow, "#c#") 
		returnValue=aDataRow(FieldColumnNumber)
	END IF
	IF Err.Number<>0 THEN
		response.write "Error en getDataRowValue("&RowNumber&", "&FieldColumnNumber&") <br>"
		'Err.Clear
	END IF

	getDataRowValue=returnValue
End Function

Function calculateRowSpan(ByVal RowNumber, ByVal spanRowsBy)
'	response.write "Buscando a partir de n: "&RowNumber&"<br>"
	returnValue=0
	IF spanRowsBy="" THEN
		calculateRowSpan=1
			EXIT FUNCTION
	ELSE
	    FOR therow=RowNumber TO ubound(arrayData)-1
			thisrow=arrayData(therow)
	        datarow=split(thisrow, "#c#")
			IF NOT(therow=RowNumber) THEN
				thisRowValReference=evalTemplate(spanRowsBy, therow)
'				response.write "r: "&therow&", n: "&RowNumber&", "&UBOUND(arrayData)&"("&thisRowValReference&" vs "&lastRowValReference&"): "&returnValue&"<br>"
				IF NOT(lastRowValReference=thisRowValReference) THEN
'					response.write "Valor encontrado: "&returnValue
					calculateRowSpan=returnValue
					EXIT FUNCTION
				END IF
			END IF
			lastRowValReference=evalTemplate(spanRowsBy, therow)
			returnValue=returnValue+1
		NEXT
		calculateRowSpan=returnValue
	END IF
End Function


FUNCTION ErrorDisplay(parmSource, parmConn, objDictionary)
'    If objDictionary.item("debug")=true THEN    
'        response.write "<hr>ErrorDisplay called<br>"
'        response.flush
'    END IF
    ErrorDisplay=0
    DIM errvbs, errdesc
    errvbs=err.number
    errdesc=err.description
    objDictionary.item("errorsource")=parmSource
'     IF objDictionary.item("debug")=true THEN    
'        response.write "errvbs=" & errvbs & "<br>"
'        response.write "errdesc=" & errdesc & "<br>"
'        response.write "parmsource=" & parmSource & "<br>"
'        response.flush
'    END IF    
    DIM errordetails, customerror
    customerror=false
    If errvbs<>0 THEN
        SELECT CASE errvbs
            CASE -2147467259
                objDictionary.item("errordesc")="Bad DSN" 
                objDictionary.item("errornum")=2
                errordetails=objDictionary.item("conn")
                ErrorDisplay=2
                objDictionary.item("errorname")="error_dsn_bad"
            CASE -2147217843
                objDictionary.item("errordesc")="Bad DSN Login Info"  
                objDictionary.item("errornum")=3
                errordetails=objDictionary.item("conn")
                ErrorDisplay=3
                objDictionary.item("errorname")="error_dsn_bad_login"
            CASE -2147217865
                objDictionary.item("errordesc")="Invalid Object Name"
                objDictionary.item("errornum")=4
                errordetails="probably query has wrong table name - SQL= " & objDictionary.item("sql")
                ErrorDisplay=4
                objDictionary.item("errorname")="error_query_badname"
            CASE -2147217900
              objDictionary.item("errordesc")="Bad Query Syntax"
                objDictionary.item("errornum")=5
                errordetails=errdesc & " - SQL= " & objDictionary.item("sql")
                ErrorDisplay=5
                objDictionary.item("errorname")="error_query_badsyntax"
            CASE ELSE
                objDictionary.item("errordesc")="VBscript Error #=<b>" & errvbs & "</b>, desc=<b>" & errdesc & "</b>"
                errordetails="n/a"
                ErrorDisplay=1
                objDictionary.item("errorname")="error_unexpected"
        END SELECT
    END IF
'     IF objDictionary.item("debug")=true THEN    
'           response.write "objDictionary.item(""errordesc"")=" & objDictionary.item("errordesc") & "<br>"
'            response.write "objDictionary.item(""errornum"")=" & objDictionary.item("errornum") & "<br>"
'            response.write "errordetails=" & errordetails & "<br>"
'            response.write "errorDisplay=" & errordisplay & "<br>"
'            response.write "objDictionary.item(""errordesc"")=" & objDictionary.item("errordesc") & "<br>"
'    END IF    
    
    Dim errorname
    errorname=objDictionary.item("errorname")
    IF objDictionary.item(errorname)="" THEN
        ' nothing to do
    ELSE
        customerror=true
        objDictionary.item("errordesc")=objDictionary.item(errorname)
    END IF

    IF customerror=TRUE THEN
            objDictionary.item("errordesc")=    replace(objDictionary.item("errordesc"), "{details}", errordetails)
    ELSE
        IF objDictionary.item("errorsdetailed")=TRUE THEN    
            objDictionary.item("errordesc")=objDictionary.item("errordesc") & " details=<b>" & errordetails & "</b>"
        END IF    
    END IF

    DIM howmanyerrors, dberrnum, dberrdesc, dberrdetails, counter
    howmanyerrors=parmConn.errors.count
'     IF objDictionary.item("debug")=true THEN    
'        response.write "howmanyerrors =" & howmanyerrors & "<br>"
'        response.flush
'    END IF    
    dberrdetails="<b>(details: "

    IF howmanyerrors>0 THEN
        FOR counter= 0 TO 0'howmanyerrors
            dberrnum=parmconn.errors(counter).number
            dberrdesc=parmconn.errors(counter).description
            dberrdetails=dberrdetails & " #=" & dberrnum & ", desc=" & dberrdesc & "; " 
       NEXT
       objDictionary.item("adoerrornum")=1
       objDictionary.item("adoerrordesc")="DB Error " & dberrdetails
    END IF
    'objDictionary.item("errornum")=ErrorDisplay    
'     If objDictionary.item("debug")=true THEN    
'        response.write "objDictionary(""adoerrornum"")=" & objDictionary("adoerrornum") & "<br>"
'        response.write "objDictionary(""adoerrordesc"")=" & objDictionary("adoerrordisc") & "<br>"
'        response.write "Leaving ErrorDisplay Function<br>"
'        response.write "objDictionary(""errornum"")=" & objDictionary("errornum") & "<br>"
'        response.flush
'    END IF
END FUNCTION

Function ToTitleFromPascal(ByVal s)
    Dim s0, s1, s2, s3, s4, sf, Regex
	Set Regex = New RegExp
	Regex.Global = True 
	Regex.IgnoreCase = False 
	regEx.Multiline = True				' Distinguir mayúsculas de minúsculas.
    ' remove name space
	Regex.Pattern = "(.*\.)(.*)"
	s0 = Regex.Replace(s, "$2")

    ' add space before Capital letter
	Regex.Pattern = "[A-Z]"
    s1 = Regex.Replace(s0, " $&")
    
    ' replace '_' with space
	Regex.Pattern = "[_]"
    s2 = Regex.Replace(s1, " ")
    
    ' replace double space with single space
	Regex.Pattern = " "
    s3 = Regex.Replace(s2, " ")
    
    ' remove and double capitals with inserted space
	Regex.Pattern = "([A-Z])\s([A-Z])"
'    response.write s&": "&Regex.Test(s3) &"<br>"
	DO WHILE Regex.Test(s3)
	    s3 = Regex.Replace(s3, "$1$2")
	LOOP
	S4=s3
'    response.write s&": "&Regex.Test(s3) &"<br>" &"<br>"

	Regex.Pattern = "^\s"
    sf = Regex.Replace(s4, "")
    
    ' force first character to upper case
    ToTitleFromPascal=ToTitleCase(sf)
End Function

Function ToTitleCase(ByVal text)
'	RegEx.Replace(RegEx.Replace(@str, "[a-z](?=[A-Z])", "$& ", 0), "(?<=[A-Z])[A-Z](?=[a-z])", " $&", 0)
    Dim sb, i
    
    For i = 0 To LEN(text) - 1
        If i > 0 Then
            If MID(text, i, 1) = " " OR MID(text, i, 1) = vbTab OR MID(text, i, 1) = "/" Then
                sb=sb&(UCASE(MID(text, i+1, 1)))
            Else
                sb=sb&(LCASE(MID(text, i+1, 1)))
            End If
        Else
			sb=sb&UCASE(MID(text, i+1, 1))
        End If
    Next
    
    ToTitleCase=sb
End Function

Function FormatearNombre(strTemp)
	strTemp=replace(UCASE(strTemp), "Á", "A")
	strTemp=replace(UCASE(strTemp), "A", "[AÁ]")
	strTemp=replace(UCASE(strTemp), "É", "E")
	strTemp=replace(UCASE(strTemp), "E", "[EÉ]")
	strTemp=replace(UCASE(strTemp), "Í", "I")
	strTemp=replace(UCASE(strTemp), "I", "[IÍ]")
	strTemp=replace(UCASE(strTemp), "Ó", "O")
	strTemp=replace(UCASE(strTemp), "O", "[OÓ]")
	strTemp=replace(UCASE(strTemp), "Ú", "U")
	strTemp=replace(UCASE(strTemp), "U", "[UÚ]")
	FormatearNombre=strTemp
End Function

Function FormatValue(ByVal vValue, ByVal sFormat, ByVal iDecimalPositions)
	IF IsNullOrEmpty(vValue) THEN FormatValue="": Exit Function END IF
	IF IsNullOrEmpty(sFormat) THEN FormatValue=vValue: Exit Function END IF
	SELECT CASE UCASE(sFormat)
	CASE "MONEY"
		IF IsNullOrEmpty(iDecimalPositions) THEN iDecimalPositions=2
		FormatValue=FormatCurrency(vValue, iDecimalPositions)
	CASE "PERCENT"
		IF IsNullOrEmpty(iDecimalPositions) THEN iDecimalPositions=2
		FormatValue=FormatPercent(vValue/100, iDecimalPositions)
	CASE "DATE"
		FormatValue=FormatDateTime(vValue, 2)
	CASE "DATETIME"
		FormatValue=FormatDateTime(vValue, 2)&" "&FormatDateTime(vValue, 3)
	CASE "NUMERIC"
		IF IsNullOrEmpty(iDecimalPositions) THEN iDecimalPositions=0
		FormatValue=FormatNumber(vValue, iDecimalPositions)
	CASE ELSE
'		IF IsNumeric(vValue) THEN
'			IF IsNullOrEmpty(iDecimalPositions) THEN iDecimalPositions=0
'			FormatValue=FormatNumber(vValue, iDecimalPositions)
'		ELSE
		FormatValue=vValue
'		END IF
	END SELECT
End Function

Function URLDecode(sConvert)
    Dim aSplit
    Dim sOutput
    Dim I
	IF sConvert="" THEN 
       URLDecode = ""
       Exit Function
    End If
    If IsNull(sConvert) Then
       URLDecode = ""
       Exit Function
    End If
	
    ' convert all pluses to spaces
    sOutput = REPLACE(sConvert, "+", " ")
    sOutput = REPLACE(sOutput, "%A0", " ")
	
    ' next convert %hexdigits to the character
    aSplit = Split(sOutput, "%")
	
    If IsArray(aSplit) Then
      sOutput = aSplit(0)
      For I = 0 to UBound(aSplit) - 1
        sOutput = sOutput & _
          Chr("&H" & Left(aSplit(i + 1), 2)) &_
          Right(aSplit(i + 1), Len(aSplit(i + 1)) - 2)
      Next
    End If
    URLDecode = sOutput
End Function

Function encodeURL(sConvert)
	Dim strTemp
	strTemp=server.urlEncode(sConvert)
	strTemp=replace(strTemp, "%2C", ",")
	strTemp=replace(strTemp, "%28", "(")
	strTemp=replace(strTemp, "%29", ")")
	strTemp=replace(strTemp, "%2A", "*")
	strTemp=replace(strTemp, "%3D", "=")
	strTemp=replace(strTemp, "%2E", ".")
	strTemp=replace(strTemp, "%2F", "/")
	strTemp=replace(strTemp, "%3C", "<")
	strTemp=replace(strTemp, "%3E", ">")
	strTemp=replace(strTemp, "%5F", "_")
	encodeURL=strTemp
End Function

Function HTMLEncode(sText)
	HTMLEncode=Server.HTMLEncode(sText)
End Function

Function HTMLDecode(sText)
    Dim i
    sText = Replace(sText, "&quot;", Chr(34))
    sText = Replace(sText, "&lt;"  , Chr(60))
    sText = Replace(sText, "&gt;"  , Chr(62))
    sText = Replace(sText, "&amp;" , Chr(38))
'    sText = Replace(sText, "&nbsp;", Chr(32))
	sText = Replace(sText, "&#x0D;", Chr(13))
    For i = 1 to 255
        sText = Replace(sText, "&#" & i & ";", Chr(i))
    Next
    HTMLDecode = sText
End Function

'ESTAS FUNCIONES DEBEN ESTAR IGUALES QUE EN EL SQL SERVER
Function anioReal(byVal Fecha)
semana=semanaReal(Fecha)
	IF YEAR(Fecha-DATEPART("w", Fecha, 2, 1)+1)<>YEAR(Fecha+7-DATEPART("w", Fecha, 2, 1)) THEN 
		IF semana=1 THEN
			anioReal=YEAR(Fecha+7-DATEPART("w", Fecha, 2, 1))
		ELSE
			anioReal=YEAR(Fecha-DATEPART("w", Fecha, 2, 1)+1)
		END IF
	ELSE
		anioReal=YEAR(Fecha)
	END IF
End Function

Function semanaReal(byVal Fecha)
	Dim iSemanaCalculada
	Fecha=CDATE(Fecha)
	IF DatePart("ww", Fecha, 2, 1)=54 OR DATEPART("w", CDATE("1/1/"&YEAR(Fecha)), 2, 1)<4 THEN 
		iSemanaCalculada=DATEPART("ww", Fecha+7-DATEPART("w", Fecha, 2, 1), 2, 1)
	ELSEIF DATEPART("w", CDATE("1/1/"&YEAR(Fecha)), 2, 1)>4 THEN 
		IF DATEPART("ww", Fecha, 2, 1)=1 AND DATEPART("w", Fecha, 2, 1)>4 THEN 
			iSemanaCalculada=semanaReal(Fecha-DATEPART("w", Fecha, 2, 1)+1)
		ELSE 
			iSemanaCalculada=DATEPART("ww", Fecha-DATEPART("w", Fecha, 2, 1), 2, 1) 
		END IF
	ELSEIF DATEPART("w", CDATE("1/1/"&YEAR(Fecha)), 2, 1)=4 OR DATEPART("w", CDATE("31/12/"&YEAR(Fecha)), 2, 1)=4 THEN 
		iSemanaCalculada=DatePart("ww", Fecha, 2, 1)
	ELSE 
		iSemanaCalculada=-1 
	END IF
	semanaReal=iSemanaCalculada
End Function

Function Numero_Letras(byVal cant)
IF TRIM(cant)="" THEN
	Numero_Letras=""
ELSE
	Numero_Letras=Pesos(CDBL(cant))
END IF
End Function

Function leeArchivo(byVal fileName)
	Const ParaLeer = 1
	Dim fso, f
	Set fso = CreateObject("Scripting.FileSystemObject")
	'ON ERROR  RESUME NEXT
	Set f = fso.OpenTextFile(fileName, ParaLeer)
	IF Err.Number<>0 THEN
		response.write "Error al abrir archivo "&fileName&". Error:"&REPLACE(Err.Description,"'","\'")
		response.end
		''Err.Clear
	END IF
	leeArchivo =  f.ReadAll
	'ON ERROR  GOTO 0
End Function

Sub BindFile (byRef strFile, byVal oRecordSet)
	Dim strMatchPattern, i
	strMatchPattern="«\w*(\([^«]|[\w\(\)\,\s\-]*\))*»"
End Sub

Function interpretaContratos (byRef sContrato) 
	Dim strMatchPattern, i
	Dim Matches, Match
'	sContrato=HTMLDecode(sContrato)
	strMatchPattern="(?:&laquo;|«)(.*?)(?:&raquo;|»)"
	Set Matches = getMatch(sContrato, strMatchPattern)

	i=0
	For Each Match in Matches 
		i=i+1
	'	strReturnStr = i&".- Match found at position " 
	'	strReturnStr = strReturnStr & Match.FirstIndex & ". Match Value is '" 
	'	strReturnStr = strReturnStr & replace(replace(Match.value, "«", ""), "»", "") & "'="&EVAL(replace(replace(Match.value, "«", ""), "»", ""))&"." 
if session("IdUsuario")=-1 THEN
'ON ERROR  RESUME NEXT
END IF
		sContrato=replace(sContrato, Match.value, EVAL(Match.Submatches(0)))
	'	sContrato=replace(sContrato, Match.value, "<label style=""text-decoration:'underline';"">&nbsp;&nbsp;&nbsp;"&EVAL(replace(replace(Match.value, "«", ""), "»", ""))&"&nbsp;&nbsp;&nbsp;</label>")
	'	Response.Write(strReturnStr &"<BR>") 
	Next 
	interpretaContratos=sContrato
End Function

Const MinNum = 0
Const MaxNum = 4294967295.99

Function Pesos(Number)
	DIM strPesos
	DIM CompletarDecimales
	Number=CCUR(Number)
	If (Number >= MinNum) And (Number <= MaxNum) Then
		Pesos = conLetra(Fix(Number))
		If CSNG(Round((Number - Fix(Number)) * 100)) < 10 Then
			CompletarDecimales="0"
		Else
			CompletarDecimales=""
		End If
		IF Fix(Number)=1 THEN
			strPesos="PESO"
		ELSE 
			strPesos="PESOS"
		END IF
		Pesos = Pesos & " "& strPesos &" " & CompletarDecimales & CStr(Round((Number - Fix(Number)) * 100)) & "/100 M.N."
	Else
		Pesos = "Error, no se pudo procesar la cantidad "&Number&"."
	End If
End Function

Function conLetra(N)
Dim Numbers, Tenths, decimales, Hundrens
Dim Result, primeraParte_letra, separador, resto_letra
IF session("IdUsuario")=-1 THEN
	decimales=Round((N - Fix(N)) * 100)
	Numbers = Array("CERO", "UN", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE", "DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE", "QUINCE", "DIECISEIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE", "VEINTE", "VEINTIUN", "VEINTIDOS", "VEINTITRES", "VEINTICUATRO", "VEINTICINCO", "VEINTISEIS", "VEINTISIETE", "VEINTIOCHO", "VEINTINUEVE")
	Tenths = Array("CERO", "DIEZ", "VEINTE", "TREINTA", "CUARENTA", "CINCUENTA", "SESENTA", "SETENTA", "OCHENTA", "NOVENTA")
	Hundrens = Array("CERO", "CIENTO", "DOSCIENTOS", "TRESCIENTOS", "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS", "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS")
	IF decimales>0 THEN
		primeraParte_letra=conLetra(Fix(N))
		IF MID(primeraParte_letra, LEN(primeraParte_letra)+1-2, 2)="UN" THEN
			primeraParte_letra=primeraParte_letra&"O"
		END IF
		resto_letra=TRIM(conLetra(decimales))
		IF decimales<10 THEN 
			resto_letra=" CERO " & resto_letra
		END IF
		IF MID(resto_letra, LEN(resto_letra)+1-2, 2)="UN" THEN
			resto_letra=resto_letra&"O"
		END IF
		separador=" PUNTO "
	ELSEIF N=0 THEN
		primeraParte_letra=""
		separador=""
		resto_letra=""
	ELSEIF N>=1 AND N<30 THEN
		primeraParte_letra=Numbers(N)
		separador=""
		resto_letra=""
	ELSEIF N>=30 AND N<100 THEN
		primeraParte_letra=Tenths(N \ 10)
		If N Mod 10 <> 0 Then
			Separador=" Y "
		Else
			Separador=" "
		End If
		resto_letra=conLetra(N Mod 10)
	ELSEIF N>=100 AND N<1000 THEN
		primeraParte_letra=""
		separador=""
		resto_letra=""
		IF N = 100 THEN
			primeraParte_letra = "CIEN"
		ELSE
			primeraParte_letra = Hundrens(N \ 100)
		END IF
		separador=" "
		resto_letra=conLetra(N Mod 100)
	ELSEIF N>=1000 AND N<1000000 THEN
		primeraParte_letra=conLetra(N \ 1000)
		separador=" MIL "
		resto_letra=conLetra(N Mod 1000)
	ELSEIF N>=1000000 AND N<1000000000 THEN
		primeraParte_letra = conLetra(N \ 1000000)
		IF Fix(N \ 1000000)=1 THEN
			separador = " MILLON "
		ELSE
			separador = " MILLONES "
		END IF
		resto_letra = conLetra(N Mod 1000000)
	ELSEIF N>=1000000000 AND N<MaxNum+1 THEN
		primeraParte_letra = conLetra(N \ 1000000000)
		IF Fix(N \ 1000000000)=1 THEN
			separador = " BILLON "
		ELSE
			separador = " BILLONES "
		END IF
		resto_letra = conLetra(N Mod 1000000000)
	END IF
	Result = primeraParte_letra + separador + resto_letra
ELSE
	decimales=Round((N - Fix(N)) * 100)
	Numbers = Array("CERO", "UN", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE", "DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE", "QUINCE", "DIECISEIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE", "VEINTE", "VEINTIUN", "VEINTIDOS", "VEINTITRES", "VEINTICUATRO", "VEINTICINCO", "VEINTISEIS", "VEINTISIETE", "VEINTIOCHO", "VEINTINUEVE")
	Tenths = Array("CERO", "DIEZ", "VEINTE", "TREINTA", "CUARENTA", "CINCUENTA", "SESENTA", "SETENTA", "OCHENTA", "NOVENTA")
	Hundrens = Array("CERO", "CIENTO", "DOSCIENTOS", "TRESCIENTOS", "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS", "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS")
	IF decimales>0 THEN
		primeraParte_letra=conLetra(Fix(N))
		IF MID(primeraParte_letra, LEN(primeraParte_letra)+1-2, 2)="UN" THEN
			primeraParte_letra=primeraParte_letra&"O"
		END IF
		resto_letra=TRIM(conLetra(decimales))
		IF decimales<10 THEN 
			resto_letra=" CERO " & resto_letra
		END IF
		IF MID(resto_letra, LEN(resto_letra)+1-2, 2)="UN" THEN
			resto_letra=resto_letra&"O"
		END IF
		Result = primeraParte_letra + " PUNTO " + resto_letra
	ELSEIF N=0 THEN
		Result = ""
	ELSEIF N>=1 AND N<30 THEN
		Result = Numbers(N)
	ELSEIF N>=30 AND N<100 THEN
		If N Mod 10 <> 0 Then
			Result = Tenths(N \ 10) + " Y " + conLetra(N Mod 10)
		Else
			Result = Tenths(N \ 10) + " " + conLetra(N Mod 10)
		End If
	ELSEIF N>=100 AND N<1000 THEN
		If N \ 100 = 1 Then
			If N = 100 Then
				Result = "CIEN" + " " + conLetra(N Mod 100)
			Else
				Result = Hundrens(N \ 100) + " " + conLetra(N Mod 100)
			End If
		Else
			Result = Hundrens(N \ 100) + " " + conLetra(N Mod 100)
		End If
	ELSEIF N>=1000 AND N<1000000 THEN
		Result = conLetra(N \ 1000) + " MIL " + conLetra(N Mod 1000)
	ELSEIF N>=1000000 AND N<1000000000 THEN
		IF Fix(N \ 1000000)=1 THEN
			Result = conLetra(N \ 1000000) + " MILLON " + conLetra(N Mod 1000000)
		ELSE
			Result = conLetra(N \ 1000000) + " MILLONES " + conLetra(N Mod 1000000)
		END IF
	ELSEIF N>=1000000000 AND N<MaxNum+1 THEN
		Result = conLetra(N \ 1000000000) + " BILLONES " + conLetra(N Mod 1000000000)
	END IF
END IF
	conLetra = Result
End Function

 Function fncLetra(byVal cant)
if (cant=0) then
	strng="CERO "
else
	decimales=round((cant-fix(cant))*100)
	cant=fix(cant)
	strng=""
	temp=cant/1000000
	temp1=fix(temp)
	cant=cant-temp1*1000000
	if (temp1>0) then
		if (temp1>1) then
			strng=strng&fncLetra(temp1)& "MILLONES "
		else
			strng=strng&fncLetra(temp1)& "MILLÓN "
		end if
	end if

'	//con esto checamos los miles
	temp=cant/1000
	temp1=fix(temp)
	cant=cant-temp1*1000
	if (temp1>0) then
		strng=strng&fncLetra(temp1)& "MIL "
	end if
'	//con esto checamos las centenas
	
	temp=cant/100
	temp1=fix(temp)
	temp2=(cant-temp1*100)/10
	cant=cant-temp1*100
	if (temp1=1) then
		if (temp2<>0) then
			strng=strng&"CIENTO "
		else
			strng=strng&"CIEN "
		end if
	elseif (temp1=2) then
		strng=strng&"DOSCIENTOS "
	elseif (temp1=3) then
		strng=strng&"TRESCIENTOS "
	elseif (temp1=4) then
		strng=strng&"CUATROCIENTOS "
	elseif (temp1=5) then
		strng=strng&"QUINIENTOS "
	elseif (temp1=6) then
		strng=strng&"SEISCIENTOS "
	elseif (temp1=7) then
		strng=strng&"SETECIENTOS "
	elseif (temp1=8) then
		strng=strng&"OCHOCIENTOS "
	elseif (temp1=9) then
		strng=strng&"NOVECIENTOS "
	end if
	
'	//con esto checamos las decenas
	temp=cant/10
	temp1=fix(temp)
	temp2=cant-temp1*10
	if (temp1<3) then
		if (temp1=1) then
			if (temp2<6) then
				if (temp2=0) then
					strng=strng&"DIEZ "
				elseif (temp2=1) then
					strng=strng&"ONCE "
				elseif (temp2=2) then
					strng=strng&"DOCE "
				elseif (temp2=3) then
					strng=strng&"TRECE "
				elseif (temp2=4) then
					strng=strng&"CATORCE "
				elseif (temp2=5) then
					strng=strng&"QUINCE "
				end if
				temp2=0
			else
				strng=strng&"DIECI"
			end if
		elseif (temp1=2) then
			if (temp2=0) then
				strng=strng&"VEINTE "
			else
				strng=strng&"VEINTI"
			end if
		end if
	else
		if (temp1=3) then
			strng=strng&"TREINTA "
		elseif (temp1=4) then
			strng=strng&"CUARENTA "
		elseif (temp1=5) then
			strng=strng&"CINCUENTA "
		elseif (temp1=6) then
			strng=strng&"SESENTA "
		elseif (temp1=7) then
			strng=strng&"SETENTA "
		elseif (temp1=8) then
			strng=strng&"OCHENTA "
		elseif (temp1=9) then
			strng=strng&"NOVENTA "
		end if
	
		if (temp2<>0) then
			strng = strng & "Y "
		end if
	end if
		
'	//con esto checamos los demás
	if (temp2=1) then
		strng = strng & "UN "
	elseif (temp2=2) then
		strng = strng & "DOS "
	elseif (temp2=3) then
		strng = strng & "TRES "
	elseif (temp2=4) then
		strng = strng & "CUATRO "
	elseif (temp2=5) then
		strng = strng & "CINCO "
	elseif (temp2=6) then
		strng = strng & "SEIS "
	elseif (temp2=7) then
		strng = strng & "SIETE "
	elseif (temp2=8) then
		strng = strng & "OCHO "
	elseif (temp2=9) then
		strng = strng & "NUEVE "
	end if

	IF decimales>0 THEN
		strng = strng & "PUNTO "&fncLetra(decimales)
	END IF

end if
fncLetra=strng
End Function

FUNCTION updateURLString(ByVal strQueryString, ByVal variable, ByVal valor)
DIM new_string, variable_buscar, pos_variable, left_string, right_string, strPartial, pos_partial
strQueryString=TRIM(URLDecode(strQueryString))
'RESPONSE.WRITE strQueryString & "<br><br>"
'RESPONSE.END
new_string=replace(strQueryString, "?", "&")
variable_buscar="&"&variable&"="
pos_variable=INSTR(UCASE(new_string), UCASE(variable_buscar))
IF pos_variable>0 THEN
	left_string=MID(strQueryString, 1, pos_variable-1+LEN(variable_buscar)) & valor
	strPartial=RIGHT(strQueryString, LEN(strQueryString)-pos_variable-LEN(variable_buscar)+1)
	pos_partial=INSTR(strPartial, "&")
	IF pos_partial>0 THEN 
		right_string=RIGHT(strPartial, LEN(strPartial)-pos_partial+1)
	END IF
ELSE
	left_string=strQueryString & variable_buscar & valor
	right_string=""
END IF
new_string=REPLACE(left_string, ".asp&", ".asp?")&right_string
'new_string=REPLACE(UCASE(strQueryString), UCASE(variable), UCASE(variable)&"="&valor)

updateURLString=new_string
END FUNCTION 


function IsNaN(byval n) 'http://www.livio.net/main/asp_functions.asp?id=IsNaN%20Function
    dim d
    'ON ERROR  RESUME NEXT
    if not isnumeric(n) then
        IsNan = true
        Exit Function
    end if
    d = cdbl(n)
    if err.number <> 0 then isNan = true else isNan = false
	'Err.Clear
	'ON ERROR  GOTO 0
end function

Function Concatenate(byval sString1, byval sString2)
	Concatenate=sString1&sString2
End Function

Sub Assign(ByRef oTarget, ByRef vValue)
'	response.write "<br>"&[&TypeName](vValue)&"<br>"
	ON ERROR	RESUME NEXT
	IF IsObject(vValue) THEN
		Set oTarget = vValue
	ELSE
		oTarget = vValue
	END IF
	[&Catch] TRUE, Me, "Assign", "Error para "&vValue&""
	ON ERROR	GOTO 0
End Sub

Function IsNullOrEmpty(ByVal sInput)
	IF IsObject(sInput) THEN
		IsNullOrEmpty = FALSE
	ELSE
		ON ERROR  RESUME NEXT
		IF UCASE([&TypeName](sInput))="BYTE()" THEN
			IsNullOrEmpty =IsNull(sInput)
		ELSE
			IsNullOrEmpty = (IsNull(sInput) OR IsEmpty(sInput) OR sInput="")
		END IF
		IF Err.Number<>0 THEN
			RESPONSE.WRITE "Error con tipo de datos "&[&TypeName](sInput)
			Err.Clear
			RESPONSE.END
		END IF
		
		ON ERROR  GOTO 0
	END IF
End Function

Function IsBlankOrEmpty(ByVal sInput)
	IsBlankOrEmpty=( IsEmpty(sInput) OR TRIM(sInput)="" )
End Function

Function NullIfEmptyOrNullText(sInput)
	NullIfEmptyOrNullText=Try( ((sInput="NULL") OR IsNullOrEmpty(sInput)), NULL, sInput)
End Function

Function EmptyIfNull(sInput)
	IF IsNull(sInput) THEN
		EmptyIfNull=Empty
	ELSE
		EmptyIfNull=sInput
	END IF
End Function

Function ZeroIfInvalid(sInput)
	IF NOT ISNUMERIC(sInput) THEN
		ZeroIfInvalid=0
	ELSE
		ZeroIfInvalid=sInput
	END IF
End Function

Function AppendIfNotEmpty(ByVal sString, ByVal sAppendString, ByVal sPosition)
IF NOT(IsNullOrEmpty(sPosition)) THEN sPosition="after"
IF NOT(IsNullOrEmpty(sString)) THEN 
	IF UCASE(sPosition)="BEFORE" THEN
		sString=sAppendString&sString
	ELSE
		sString=sString&sAppendString
	END IF
END IF
AppendIfNotEmpty=sString
End Function 

Function IsObjectReady(oInput)
	IF NOT IsObject(oInput) THEN 
		Err.Raise 1, "ASP 101", "Input variable is not an object"
		response.end
	END IF
	IsObjectReady=NOT(oInput IS NOTHING)
End Function

Sub [&CheckValidObjectType](oInput, sValidDataTypes)
	IF NOT CString([&TypeName](oInput)).ExistsIn(TRIM(sValidDataTypes)) THEN
		RESPONSE.WRITE "<strong>"&[&TypeName](oInput)&"</strong> is not a valid type, object only admits "&sValidDataTypes&" Type Objects"
		RESPONSE.END
	END IF
End Sub

Function TryPropertyRemove(ByRef oElement, sPropertyName, ByVal WarnError)
	DIM bReturnValue
	ON ERROR  RESUME NEXT
'	IF Session("debugging") THEN _
'	response.write "<br><strong>TryPropertySet: </strong>Intentando propiedad <strong class=""info"">"&sPropertyName&"</strong> para <strong class=""info"">"&[&TypeName](oElement)&"</strong> "
	oElement.Properties.RemoveProperty sPropertyName

	IF Err.Number<>0 THEN
		IF WarnError OR Session("debugging") THEN 
			RESPONSE.WRITE "<strong class=""warning"">Warning: </strong>No se puede <strong class=""info"">establecer</strong>, para el tipo de objeto <strong class=""info"">"&[&TypeName](oElement)&"</strong>, la propiedad <strong class=""info"">"&sPropertyName&"</strong> ("&Try(IsObject(vInput), "Object: "&[&TypeName](vInput), vInput)&")"
			IF [&TypeName](oElement)="DataField" THEN 
				RESPONSE.WRITE " ("&[&TypeName](oElement.Control)&")"
			END IF
			RESPONSE.WRITE "("&Err.Description&")<br>"
		END IF
'		response.end
		Err.Clear
		bReturnValue=FALSE
	ELSE
		bReturnValue=TRUE
	END IF
	ON ERROR  GOTO 0
	TryPropertyRemove=bReturnValue
End Function

Function TryPropertySet(ByRef oElement, sProperties, ByRef vInput, ByVal WarnError)
	DIM bReturnValue, aPropertyNames
	ON ERROR  RESUME NEXT
'	IF sProperties="Control.IsReadonly" THEN _
	IF Session("debugging") THEN _
	Debugger Me, "<br><strong>TryPropertySet: </strong>Intentando propiedad <strong class=""info"">"&sProperties&"</strong> para <strong class=""info"">"&[&TypeName](oElement)&" Valor ("&TypeName(vInput)&"): "&vInput&"</strong> "
	IF INSTR(sProperties, "/")<>0 THEN 
		aPropertyNames = Split(sProperties, "/")
	ELSE
		aPropertyNames = Array(sProperties)
	END IF
	
	DIM sPropertyName
	DIM iPropertyName:	iPropertyName=0
	FOR EACH sPropertyName IN aPropertyNames
		iPropertyName=iPropertyName+1
		IF Err.Number<>0 OR iPropertyName=1 THEN
			Err.Clear
'			IF IsObject(vInput) THEN
'				EXECUTE("SET oElement."&sPropertyName&"=vInput")
'			ELSE
'				EXECUTE("oElement."&sPropertyName&"=vInput")
'			END IF
			EXECUTE("SET oElement."&sPropertyName&"=vInput")
			IF Err.Number<>0 THEN
				Err.Clear
				EXECUTE("oElement."&sPropertyName&"=vInput")
			END IF
		END IF
	NEXT
	
	IF Err.Number<>0 THEN
		IF WarnError OR Session("debugging") THEN 
			RESPONSE.WRITE "<strong class=""warning"">Warning: </strong>No se puede <strong class=""info"">establecer</strong>, para el tipo de objeto <strong class=""info"">"&[&TypeName](oElement)&"</strong>, la propiedad <strong class=""info"">"&sProperties&"</strong> ("&Try(IsObject(vInput), "Object: "&[&TypeName](vInput), vInput)&")"
			IF [&TypeName](oElement)="DataField" THEN 
				RESPONSE.WRITE " ("&[&TypeName](oElement.Control)&")"
			END IF
			RESPONSE.WRITE "("&Err.Description&")<br>"
		END IF
'		response.end
		Err.Clear
		bReturnValue=FALSE
	ELSE
		bReturnValue=TRUE
	END IF
	ON ERROR  GOTO 0
	TryPropertySet=bReturnValue
End Function
Sub [&Stop](oSource)
	response.write "<strong style=""color:'red'"">Detenido en "&[&TypeName](oSource)&"</strong>"
	response.end
End Sub

Function TryPropertyGet(ByRef oElement, sPropertyName, ByRef vTarget, ByVal WarnError)
	DIM bReturnValue
	ON ERROR  RESUME NEXT
	IF Session("debugging") THEN _
	response.write "<br><strong>TryPropertyGet: </strong>Intentando propiedad <strong class=""info"">"&sPropertyName&"</strong> para <strong class=""info"">"&[&TypeName](oElement)&"</strong> "
	
	EXECUTE("IF IsObject(oElement."&sPropertyName&") THEN Set vTarget=oElement."&sPropertyName&" ELSE vTarget=oElement."&sPropertyName&" END IF")
	IF Err.Number<>0 THEN
		IF WarnError OR Session("debugging") THEN RESPONSE.WRITE "<strong class=""warning"">Warning: </strong>La propiedad "&sPropertyName&" no se puede <strong class=""info"">recuperar</strong> para el tipo de objeto "&[&TypeName](oElement)&"<br>"
'		response.end
		Err.Clear
		bReturnValue=FALSE
	ELSE
		bReturnValue=TRUE
	END IF
	ON ERROR  GOTO 0
	TryPropertyGet=bReturnValue
End Function

Function fillWith(ByVal sValue, ByVal sFill, ByVal iLength, ByVal sPosition)
DIM sNewString
IF IsNullOrEmpty(sPosition) THEN sPosition="right"
DIM iCurrentLength: iCurrentLength=LEN(TRIM(sValue))
DIM sFilled: sFilled=replicate(sFill, iLength-iCurrentLength)
IF sPosition="left" THEN sNewString=sFilled&sNewString
sNewString=sNewString&sValue
IF sPosition="right" THEN sNewString=sNewString&sFilled
fillWith=sNewString
End Function

Function replicate(ByVal sString, ByVal iTimes)
DIM sNewString: sNewString=""
DO WHILE(iTimes>0) 
	sNewString=sNewString&sString
	iTimes=iTimes-1
LOOP
replicate=sNewString
End Function

Function QuoteName(sString)
	QuoteName = "'"&sString&"'"
End Function

Function DoubleQuoteName(sString)
	QuoteName = """"&sString&""""
End Function

Function ReferenciaHorizontes(sLote)
ReferenciaHorizontes=CONCATENATE(CSTR(2),fillWith(Lote,"0",3,"left"))
End Function

Function Try(bCondition, sTrue, sFalse)
	IF bCondition THEN
		Try=sTrue
	ELSE
		Try=sFalse
	END IF
End Function

Function [&Coalesce](vFirstOption, vSecondOption)
	IF NOT IsNullOrEmpty(vFirstOption) THEN
		[&Coalesce]=vFirstOption
	ELSE
		[&Coalesce]=vSecondOption
	END IF
End Function

Function ToArray(ByVal oObject)
	DIM oArray: Set oArray = new ArrayList
	DIM oElement
	FOR EACH oElement IN oObject
		oArray.Add oElement
	NEXT
	ToArray = oArray.ToArray()
End Function

Function TextToNull(ByVal vValue)
	TextToNull=Try(vValue="NULL", NULL, vValue)
End Function

Function NullToText(ByVal vValue)
	IF IsNull(vValue) THEN 
		NullToText="NULL"
	ELSE
		NullToText=vValue
	END IF
End Function

Function ClassTracker(oClass)
	ClassTracker="<strong class=""warning"">"& [&TypeName](oClass)&" ==></strong>"
End Function

Sub Debugger(oClass, sText)
	DIM sType:
	IF [&TypeName](sText)="Byte()" THEN
		response.write ClassTracker(oClass)&" Dato de tipo :"& [&TypeName](sText)&"<br>"
	ELSE
		response.write ClassTracker(oClass)&" "&sText&"<br>"
	END IF
End Sub

Function [&TypeName](oInput)
ON ERROR	RESUME NEXT
	DIM sTypeName
	sTypeName=TypeName(oInput)
	IF Err.Number<>0 THEN
		Err.Clear
		Debugger Me, "<strong>[&TypeName]</strong>"&oInput.Type
		sTypeName=oInput.Type
	END IF
[&TypeName]=sTypeName
ON ERROR	GOTO 0

End Function

Dim dBooleanDictionary
Set dBooleanDictionary = server.CreateObject("Scripting.Dictionary")
dBooleanDictionary("NO")="0"
dBooleanDictionary("YES")="1"
dBooleanDictionary(LCASE(CSTR(CBOOL(0))))="0" 'Traslates "False" OR "Falso" according to the language and assigns its value to 0
dBooleanDictionary(LCASE(CSTR(CBOOL(1))))="1"	'Traslates "True" OR "Verdadero" according to the language and assigns its value to 1
dBooleanDictionary("0")="0"
dBooleanDictionary("1")="1"
dBooleanDictionary("javascript_0")="false"
dBooleanDictionary("javascript_1")="true"

Function CBoolean(ByVal vValue)
	DIM oExtendedBoolean: Set oExtendedBoolean = new ExtendedBoolean
	oExtendedBoolean.Value=vValue
	Set CBoolean = oExtendedBoolean
End Function
Class ExtendedBoolean
	Private vValue
	Private dMainDictionary
	
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
	Public Default Property Get Value()
		Value = CBOOL(vValue)
	End Property
	Public Property Let Value(input)
		vValue = dBooleanDictionary(LCASE(CSTR(input)))
	End Property
	
	Public Function IsTrue()
		IsTrue=(Me.Value=TRUE)
	End Function
	
	Public Function IsFalse()
		IsFalse=(Me.Value=FALSE)
	End Function
	
	Public Function Text()
		Text=dBooleanDictionary("javascript_"&vValue)
	End Function
End Class

Public Function ChangeUnrecognizedFieldType(oField)
	DIM oResult
	SELECT CASE oField.Type
	CASE 20	'20: BigInt -- no soporta [&TypeName]
		oField.Type=3
	CASE ELSE
	END SELECT
	Set ChangeUnrecognizedFieldType=oField
End Function	

Function CString(ByVal input)
	DIM sText
	DIM oExtendedString: Set oExtendedString = new ExtendedString
	ON ERROR  RESUME NEXT
	IF UCASE([&TypeName](input))="FIELD" THEN 
		IF input.type=20 THEN '20: BigInt -- no soporta [&TypeName]
			input=CINT(input.value)
		ELSE
			input=input.value
		END IF
	END IF
	[&Catch] TRUE, Me, "CString", ""
	ON ERROR  GOTO 0

	SELECT CASE UCASE([&TypeName](input))
	CASE "NULL"
		sText=NULL
	CASE ELSE
		sText=CSTR(input) 'HTMLDecode(CSTR(input))
	END SELECT
	oExtendedString.Text=sText
	Set CString = oExtendedString
End Function

Class ExtendedString
	Private sText
	Public Default Property Get Text()
		Text = sText
	End Property
	Public Property Let Text(input)
		sText = input
	End Property

	Public Function RemoveEntities()
		Set RemoveEntities=Me.Replace("["&chr(13)&""&chr(9)&""&chr(10)&""&vbcr&""&vbcrlf&""&vbtab&"]", " ")
	End Function
	
	Public Function DoubleQuote()
		Me.Text=Me.Replace("""", """""").Append("""").Prepend("""")
		Set DoubleQuote = Me
	End Function 
	
	Public Function ExistsIn(sString)
		ExistsIn=(INSTR(" "&sString&",", " "&sText&",")>0)
	End Function

	Public Function IsLike(sPath)
		IsLike=testMatch(sText, sPath)
	End Function

	Public Function Remove(sPatrn)
		Set Remove=Me.Replace(sPatrn, "")
	End Function

	Public Function Replace(sPatrn, sReplacementText)
		Me.Text=replaceMatch(sText, sPatrn, sReplacementText)
		Set Replace = Me
	End Function

	Public Function ReplaceAndEvaluate(sPatrn, sReplacementText)
		Me.Text=replaceEvaluatingMatch(sText, sPatrn, sReplacementText)
		Set ReplaceAndEvaluate = Me
	End Function

	Public Function Escape()
		Me.Text=escapeString(sText)
		Set Escape = Me
	End Function

	Public Function EscapeChars(sChars)
		Me.Text=escapeCharacters(sText, sChars)
		Set EscapeChars = Me
	End Function

	Public Function Evaluate()
		Me.Text=fncEvaluate(sText)
		Set Evaluate = Me
	End Function

	Public Function Append(sAppend)
		Me.Text=sText&sAppend
		Set Append = Me
	End Function

	Public Function Prepend(sPrepend)
		Me.Text=sPrepend&sText
		Set Prepend = Me
	End Function

	Public Function IsNull()
		IsNull=CheckNull(sText)
	End Function
End Class

Public Function [&CString](ByVal input)
	DIM sText
	DIM oExtendedString: Set oExtendedString = new XString
	ON ERROR  RESUME NEXT
	IF UCASE([&TypeName](input))="FIELD" THEN 
		IF input.type=20 THEN '20: BigInt -- no soporta [&TypeName]
			input=CINT(input.value)
		ELSE
			input=input.value
		END IF
	END IF
	[&Catch] TRUE, Me, "[&CString]", ""
	ON ERROR  GOTO 0

	SELECT CASE UCASE([&TypeName](input))
	CASE "NULL"
		sText=NULL
	CASE ELSE
		sText=CSTR(input) 'HTMLDecode(CSTR(input))
	END SELECT
	oExtendedString.Text=sText
	Set [&CString] = oExtendedString
End Function	
Class XString
	Private oStringBuilder
	Private Sub Class_Initialize()
'		Set oStringBuilder = CreateObject("System.IO.StringWriter")		'Necesitaría .GetStringBuilder()
		Set oStringBuilder = CreateObject("System.Text.StringBuilder")	'Es más eficiente!!
	End Sub
	Private Sub Class_Terminate()
		Set oStringBuilder = nothing
	End Sub
	
	Public Default Property Get Text()
		Text = oStringBuilder.ToString()
	End Property
	Public Property Let Text(input)
		oStringBuilder.Length=0
		oStringBuilder.Append_3 CStr(input)
	End Property

	Public Function RemoveEntities()
		Set RemoveEntities=Me.Replace("["&chr(13)&""&chr(9)&""&chr(10)&""&vbcr&""&vbcrlf&""&vbtab&"]", " ")
	End Function
	
	Public Function DoubleQuote()
		Me.Text=Me.Replace("""", """""").Append("""").Prepend("""")
		Set DoubleQuote = Me
	End Function 
	
	Public Function ExistsIn(sString)
		ExistsIn=(INSTR(" "&sString&",", " "&Me.Text&",")>0)
	End Function

	Public Function IsLike(sPath)
		IsLike=testMatch(Me.Text, sPath)
	End Function

	Public Function Remove(sPatrn)
		Set Remove=Me.Replace(sPatrn, "")
	End Function

	Public Function RemoveString(sString)
		oStringBuilder.Replace sString, ""
		Set RemoveString = Me
	End Function

	Public Function Extract(sPatrn)
		Set Extract = [$ArrayList](getMatch(Me.Text, sPatrn))
	End Function
	
	Public Function Replace(sPatrn, sReplacementText)
		Me.Text=replaceMatch(Me.Text, sPatrn, sReplacementText)
		Set Replace = Me
	End Function

	Public Function Escape()
		Me.Text=escapeString(sText)
		Set Escape = Me
	End Function

	Public Function EscapeChars(sChars)
		Me.Text=escapeCharacters(sText, sChars)
		Set EscapeChars = Me
	End Function

	Public Function Evaluate()
		Me.Text=fncEvaluate(Me.Text)
		Set Evaluate = Me
	End Function

	Public Function Append(sAppend)
		oStringBuilder.Append_3 CStr(sAppend)
		Set Append = Me
	End Function

	Public Function Prepend(sPrepend)
'		oStringBuilder.AppendFormat_4 "Probando {0} en {1}", Array(1, "loneliest")
		oStringBuilder.Insert_2 0, CStr(sPrepend)
		Set Prepend = Me
	End Function

	Public Function IsNull()
		IsNull=CheckNull(sText)
	End Function
End Class

Function CheckNull(ByVal vValue)
	CheckNull=ISNULL(vValue)
End Function

Function escapeCharacters(sOriginal, sPatrn)
	DIM sReplacementText: sReplacementText="\$&"
	escapeCharacters=replaceMatch(sOriginal, sPatrn, sReplacementText)
End Function 

Function escapeString(sOriginal)
	Dim sPatrn: sPatrn="\[\\\^\$\.\|\?\*\+\(\)\{\}"
	escapeString=escapeCharacters(sOriginal, sPatrn)
End Function

Sub StoreSessionVariable(ByVal VariableName, ByVal vValue)
	IF IsObject(vValue) THEN
		Set Session(VariableName) = vValue
	ELSE
		Session(VariableName) = vValue
	END IF
End Sub 
 
Sub [&Catch](bStop, oSourceClass, sFunctionName, sMessage)
	IF Err.Number<>0 THEN
		response.write "<br>Ocurrió el siguiente error:<strong>"&Err.Description&"</strong>. En función:<strong>"&vbcrlf&TypeName(oSourceClass)&"."&sFunctionName&"</strong>.<br>"&sMessage&"<br><br>"
		IF bStop THEN response.end
		Err.Clear
	END IF
End Sub

Class Parameter
	Private sName, vValue
	Public Property Get Name()
		Name = sName
	End Property
	Public Property Let Name(input)
		sName = input
	End Property

	Public Property Get Value()
		Value = vValue
	End Property
	Public Property Let Value(input)
		vValue = input
	End Property
End Class

Class Parameters
	Private oDictionary
	Private Sub Class_Initialize()
		Set oDictionary = new Dictionary
	End Sub
	Private Sub Class_Terminate()
		Set oDictionary = nothing
	End Sub
	
	Public Property Get All()
		Set All = oDictionary
	End Property

	Public Default Property Get Parameters()
		Set Parameters = oDictionary
	End Property
	Public Property Let Parameters(input)
		DIM aControlParameters: Set aControlParameters=getParameters(input)
		DIM oParam
		FOR EACH oParam IN aControlParameters
			DIM oParameter: Set oParameter = new Parameter
			oParameter.Name=oParam.SubMatches(0)
			DIM oValue: Set oValue=[&CString](oParam.SubMatches(1))
			IF oValue.IsLike("^'.*'$") THEN
				oParameter.Value=oValue.Replace("\\'", """""").Replace("'", """").Text
			ELSE
				oParameter.Value=oValue.Text
			END IF
			oDictionary.Add oParameter.Name, oParameter
		NEXT
	End Property
End Class

Function [&New](ByVal vValue, ByVal sParameters)
DIM oCreated
Set oCreated=[&CreateObject](vValue)
IF NOT IsNullOrEmpty(sParameters) THEN
	DIM oParameters: Set oParameters = new Parameters
	oParameters.Parameters=sParameters
	DIM oParameter
	FOR EACH oParameter IN oParameters.All.Items
		'Set oParameter=oParameters.Parameters.Item(i)
	'	response.write [&TypeName](oParameter)
		EXECUTE("oCreated."&oParameter.Name&"="&oParameter.Value)
	'	RESPONSE.WRITE oParameter.Name&": "&oParameter.Value
	'	TryPropertySet oCreated, oParameter.Name, Evaluate(oParameter.Value), TRUE
	NEXT
	Set oParameters = NOTHING
END IF
Set [&New] = oCreated
End Function

Function [&CreateObject](ByVal sObject)
DIM oCreated
EXECUTE("Set oCreated = new "&sObject)
Set [&CreateObject]=oCreated
End Function 

Sub [&BR]()
	response.write "<br>"
End Sub

Sub [&echo](ByVal sText)
	response.write sText
End Sub

Class clsXML
  'strFile must be full path to document, ie C:\XML\XMLFile.XML
  'objDoc is the XML Object
  Private strFile, objDoc

  '*********************************************************************
  ' Initialization/Termination
  '*********************************************************************

  'Initialize Class Members
  Private Sub Class_Initialize()
    strFile = ""
  End Sub

  'Terminate and unload all created objects
  Private Sub Class_Terminate()
    Set objDoc = Nothing
  End Sub

  '*********************************************************************
  ' Properties
  '*********************************************************************

  'Set XML File and objDoc
  Public Property Let File(str)
    Set objDoc = Server.CreateObject("Microsoft.XMLDOM")
    objDoc.async = False
    strFile = str
    objDoc.Load strFile
  End Property

  'Get XML File
  Public Property Get File()
    File = strFile
  End Property

  '*********************************************************************
  ' Functions
  '*********************************************************************

  'Create Blank XML File, set current obj File to newly created file
  Public Function createFile(strPath, strRoot)
    Dim objFSO, objTextFile
    Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
    Set objTextFile = objFSO.CreateTextFile(strPath, True)
    objTextFile.WriteLine("<?xml version=""1.0""?>")
    objTextFile.WriteLine("<" & strRoot & "/>")
    objTextFile.Close
    Me.File = strPath
    Set objTextFile = Nothing
    Set objFSO = Nothing
  End Function

  'Get XML Field(s) based on XPath input from root node
  Public Function getField(strXPath)
    Dim objNodeList, arrResponse(), i
    Set objNodeList = objDoc.documentElement.selectNodes(strXPath)
    ReDim arrResponse(objNodeList.length)
    For i = 0 To objNodeList.length - 1
      arrResponse(i) = objNodeList.item(i).Text
    Next
    getField = arrResponse
  End Function

  'Update existing node(s) based on XPath specs
  Public Function updateField(strXPath, strData)
    Dim objField
    For Each objField In objDoc.documentElement.selectNodes(strXPath)
      objField.Text = strData
    Next
    objDoc.Save strFile
    Set objField = Nothing
    updateField = True
  End Function

  'Create node directly under root
  Public Function createRootChild(strNode)
    Dim objChild
    Set objChild = objDoc.createNode(1, strNode, "")
    objDoc.documentElement.appendChild(objChild)
    objDoc.Save strFile
    Set objChild = Nothing
  End Function

  'Create a child node under root node with attributes
  Public Function createRootNodeWAttr(strNode, attr, val)
    Dim objChild, objAttr
    Set objChild = objDoc.createNode(1, strNode, "")
    If IsArray(attr) And IsArray(val) Then
      If UBound(attr)-LBound(attr) <> UBound(val)-LBound(val) Then
        Exit Function
      Else
        Dim i
        For i = LBound(attr) To UBound(attr)
          Set objAttr = objDoc.createAttribute(attr(i))
          objChild.setAttribute attr(i), val(i)
        Next
      End If
    Else
      Set objAttr = objDoc.createAttribute(attr)
      objChild.setAttribute attr, val
    End If
    objDoc.documentElement.appendChild(objChild)
    objDoc.Save strFile
    Set objChild = Nothing
  End Function

  'Create a child node under the specified XPath Node
  Public Function createChildNode(strXPath, strNode)
    Dim objParent, objChild
    For Each objParent In objDoc.documentElement.selectNodes(strXPath)
      Set objChild = objDoc.createNode(1, strNode, "")
      objParent.appendChild(objChild)
    Next
    objDoc.Save strFile
    Set objParent = Nothing
    Set objChild = Nothing
  End Function

  'Create a child node(s) under the specified XPath Node with attributes
  Public Function createChildNodeWAttr(strXPath, strNode, attr, val)
    Dim objParent, objChild, objAttr
    For Each objParent In objDoc.documentElement.selectNodes(strXPath)
      Set objChild = objDoc.createNode(1, strNode, "")
      If IsArray(attr) And IsArray(val) Then
        If UBound(attr)-LBound(attr) <> UBound(val)-LBound(val) Then
          Exit Function
        Else
          Dim i
          For i = LBound(attr) To UBound(attr)
            Set objAttr = objDoc.createAttribute(attr(i))
            objChild.SetAttribute attr(i), val(i)
          Next
        End If
      Else
        Set objAttr = objDoc.createAttribute(attr)
        objChild.setAttribute attr, val
      End If
      objParent.appendChild(objChild)
    Next
    objDoc.Save strFile
    Set objParent = Nothing
    Set objChild = Nothing
  End Function

  'Delete the node specified by the XPath
  Public Function deleteNode(strXPath)
    Dim objOld
    For Each objOld In objDoc.documentElement.selectNodes(strXPath)
      objDoc.documentElement.removeChild objOld
    Next
    objDoc.Save strFile
    Set objOld = Nothing
  End Function
End Class

FUNCTION firstDayOfMonth(dDate)
	firstDayOfMonth=DATEADD("d", -DAY(dDate)+1, dDate)
END FUNCTION

FUNCTION lastDayOfMonth(dDate)
	lastDayOfMonth=DATEADD("d", -1, DATEADD("m", 1, firstDayOfMonth(dDate)))
END FUNCTION

FUNCTION getRelativeURLPath(sFileName)
	Dim fso:	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	getRelativeURLPath=CString(getPathFromRoot(server.MapPath(Request.ServerVariables("URL")))&"\").Replace("[^/\\]", "").Replace("[/\\]", "..$&") &getPathFromRoot(sFileName)'.Replace("[^/\\]", "").Replace("[/\\]", "..$&")
END FUNCTION 

FUNCTION getPathFromRoot(sFileName)
	Dim fso:	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	'response.write "string ("&fso.GetExtensionName(sFileName)&"): "&fso.GetParentFolderName(sFileName)&"<br>"
	Dim sFolderPath
	IF fso.GetExtensionName(sFileName)<>"" THEN
		sFolderPath=fso.GetParentFolderName(sFileName)
	ELSE
		sFolderPath=sFileName
	END IF
	getPathFromRoot=CString(sFolderPath).Replace("^"&REPLACE(Request.ServerVariables("APPL_PHYSICAL_PATH"), "\", "\\"), "")
END FUNCTION 

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
End Sub

%>