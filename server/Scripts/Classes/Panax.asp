<% 
Function [$Panax]()
	DIM oPanax:	Set oPanax = new Panax
'	oPanax.DataField = oDataField
	Set [$Panax] = oPanax
End Function
Class Panax
	Private sParameter, sParameters, sSessionVariable, sType, sTypeLength, sOutput
	Private oDataSource, oXMLFile
	Private sParamValue, bParameterString
	Private sFilter, sControlType, sFilters, aFilters
	Private sField, sFilterField, sFilterType, sFilterValue, sFilterComparison
	Private sCatalogName, sEncryptedId, sVersion, bCached
	Private sMode, sLang, sSorters, oJson, aSorters, key, iPageIndex, iPageSize, id, identityKey, sFullPath, iMaxRecords, bRebuild, bRebuildJS, bBuild
	'Timers
    Private oTimerQuery, oTimerRender

	Private testData
	
	Private Sub Class_Initialize()
		Set oDataSource = New DataSource
		Me.Output = (request.querystring("output"))
		bCached = TRUE
		testData=request.querystring("testData")
		'testData="pacientesData.js"
		For Each sSessionVariable in Session.Contents
			sTypeLength=""
			IF NOT IsObject(Session(sSessionVariable)) THEN 
				SELECT CASE UCASE(TypeName(Session(sSessionVariable)))
					CASE "DATE"
						sType="datetime"
					CASE "INTEGER"
						sType="int"
					CASE ELSE
						IF testMatch(TRIM(SESSION(sSessionVariable)), "^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$") THEN 
							sType="datetime"
						ELSEIF testMatch(RTRIM(SESSION(sSessionVariable)), "^\d+$") THEN 
							sType="int"
						ELSE 
							sType="nvarchar"
							sTypeLength="(MAX)"
						END IF
				END SELECT
			
				IF testMatch(sSessionVariable, "^\@") THEN
					  'Response.Write(sSessionVariable & "("&sType&")="&session(sSessionVariable)&"<br />")
					sParameters=sParameters&"&"&sSessionVariable&"["&sType&"]"&sTypeLength&"="
					IF ISNULL(session(sSessionVariable)) OR IsEmpty(session(sSessionVariable)) THEN
						sParameters=sParameters&"NULL"
					ELSE
						SELECT CASE UCASE(sType)
						CASE "INT"
							sParameters=sParameters&session(sSessionVariable)
						CASE ELSE
							'RESPONSE.WRITE sSessionVariable&": "&session(sSessionVariable)
							IF testMatch(sSessionVariable, "^'.*'$") or session(sSessionVariable)="NULL" THEN
								sParameters=sParameters&session(sSessionVariable)
							ELSE
								sParameters=sParameters&"'"&REPLACE(session(sSessionVariable), "'", "''")&"'"
							END IF
						END SELECT
					END IF
				END IF
			END IF
		Next
		'response.write request.querystring': response.end
		FOR EACH sParameter IN request.querystring
			IF testMatch(sParameter, "^\@") THEN
		'	response.write sParameter&"<br/>"
				sParamValue=request.querystring(sParameter)
				bParameterString=NOT(sParamValue="" OR sParamValue="NULL" OR ISNUMERIC(sParamValue) OR testMatch(sParamValue, "^['@]"))
				IF bParameterString THEN sParamValue="'"&sParamValue&"'" END IF
				IF RTRIM(sParamValue)="" THEN sParamValue="NULL" END IF
				sParameters=sParameters&"&"&sParameter&"="&sParamValue
			END IF
		NEXT
		sParameters=replaceMatch(sParameters, "^&\s", "")
		sParameters=replaceMatch(sParameters, "(@.+?)\{(\w+?)\}", "$1($2)")
		'response.write "request.querystring: "&request.querystring&"<br/>"': response.end
		'response.write "request.querystring: "&request.querystring("Parameters")&"<br/>"': response.end
		IF RTRIM(request.querystring("Parameters"))<>"" THEN 
			sParameters=sParameters&"&"&request.querystring("Parameters")
		END IF
		IF sParameters<>"" AND NOT(sParameters="DEFAULT") THEN sParameters="'"&REPLACE(sParameters, "'", "''")&"'" ELSE sParameters="DEFAULT" END IF

		'response.write sParameters: response.end
		sCatalogName = request.querystring("CatalogName")
		sEncryptedId = request.querystring("eid")
		sMode = request.querystring("Mode")
		sControlType=TRIM(request.querystring("controlType"))
		IF sEncryptedId<>"" THEN
			sControlType="formView"
			sMode="insert"
			oDataSource.CommandText = "SET NOCOUNT ON; EXEC [$Security].DecryptCatalogReference '"&sEncryptedId&"', @mode='"&sMode&"', @controlType='"&sControlType&"'"
			oDataSource.DataBind()
			DIM rsRecordSet
			rsRecordSet=oDataSource.RecordSet
			sCatalogName=rsRecordSet(0)+"."+rsRecordSet(1)
			'response.write sCatalogName
		END IF
		IF sMode<>"" AND NOT(sMode="DEFAULT") THEN sMode="'"&sMode&"'" ELSE sMode="DEFAULT" END IF
		IF sControlType<>"" THEN sControlType=sControlType ELSE sControlType="DEFAULT" END IF
		sLang = request.querystring("Lang")
		IF sLang<>"" AND NOT(sLang="DEFAULT") THEN sLang="'"&sLang&"'" ELSE IF RTRIM(SESSION("lang"))<>"" THEN sLang=SESSION("lang") ELSE sLang="DEFAULT" END IF
		
		SET aFilters = New ArrayList
		FOR EACH sFilter IN request.querystring
			sFilter=[$ArrayList](getMatch(sFilter, "^(filter\[\d+?\])(?=\[field\])")).item(0)
			IF sFilter<>"" THEN'testMatch(sFilter, "^filter\[\d+?\]\[field\]") THEN
		''        // assign filter data (location depends if encoded or not)
		'        if ($encoded) {
		'            sFilterField = $filter->field;
		'            sFilterValue = $filter->value;
		'            sFilterComparison = isset($filter->comparison) ? $filter->comparison : null;
		'            sFilterType = $filter->type;
		'        } else {
					sFilterField=request.querystring(sFilter&"[field]")
					sFilterValue=URLDecode(request.querystring(sFilter&"[data][value]"))
					sFilterType=request.querystring(sFilter&"[data][type]")
					sFilterComparison=request.querystring(sFilter&"[data][comparison]")
					'response.write "//"&sFilter& vbCrLf
					'response.write "//field="&sFilterField& vbCrLf
					'response.write "//type="&sFilterValue& vbCrLf
					'response.write "//value="&sFilterType& vbCrLf
					IF NOT IsEmpty(sFilterComparison) THEN
						'response.write "//comparison="&sFilterComparison& vbCrLf
					END IF
					'response.write vbCrLf
		'        }
		
		        SELECT CASE (sFilterType)
		            case "string" : aFilters.add("["&sFilterField&"] COLLATE Latin1_General_CI_AI LIKE '%"&REPLACE(REPLACE(sFilterValue, " ", "%"), "'", "''")&"%'")
		            case "list" :
						DIM aValues: SET aValues = New ArrayList
						DIM bNull: bNull=FALSE
						FOR EACH sFilterValue IN request.querystring(sFilter&"[data][value]")
							IF sFilterValue="NULL" THEN
								bNull=TRUE
							ELSE
								aValues.Add("'"&REPLACE(sFilterValue, "'", "''")&"'")
							END IF
						NEXT
						DIM aListFilter: SET aListFilter = New ArrayList
						IF bNull THEN 
							aListFilter.add("["&sFilterField&"] IS NULL")
						END IF
						IF aValues.count>0 THEN
							aListFilter.add("["&sFilterField&"] IN ("&aValues.join(",")&")")
						END IF
		                aFilters.add("("&aListFilter.join(" OR ")&")")
		            case "boolean" : aFilters.add("["&sFilterField&"] = "& ABS(CINT(CBOOL(sFilterValue))))
		            case "numeric" :
		                SELECT CASE (sFilterComparison) 
		                    case "eq" : aFilters.add("["&sFilterField&"] = "&sFilterValue)
		                    case "lt" : aFilters.add("["&sFilterField&"] <= "&sFilterValue)
		                    case "gt" : aFilters.add("["&sFilterField&"] >= "&sFilterValue)
		                END SELECT
		            case "date" :
		                SELECT CASE (sFilterComparison) 
		                    case "eq" : aFilters.add("[$Date].ShortDate(["&sFilterField&"]) = '"&REPLACE(sFilterValue, "'", "''")&"'")
		                    case "lt" : aFilters.add("["&sFilterField&"] <= CONVERT(datetime, RTRIM(CONVERT(nchar(25), ISNULL('"&REPLACE(sFilterValue, "'", "''")&"', GETDATE()), 103))+' 23:59.99')")
		                    case "gt" : aFilters.add("["&sFilterField&"] >= '"&REPLACE(sFilterValue, "'", "''")&"'")
		                END SELECT
		        END SELECT
			END IF
		NEXT
		id = TRIM(request.querystring("id"))
		identityKey = TRIM(request.querystring("identityKey"))
		IF identityKey<>"" AND NOT(id="" OR UCASE(id)="NULL") THEN aFilters.add("["&identityKey&"]='"&id&"'") END IF

		'response.write "//"&sFilters
		sFilters=TRIM(request.querystring("filters"))
		sFilters=replaceMatch(sFilters, "^\s*AND\s+", "")
		IF sFilters<>"" THEN aFilters.add("("&sFilters&")") END IF
		IF aFilters.count>0 THEN sFilters="'"&REPLACE(aFilters.join(" AND "), "'", "''")&"'" ELSE sFilters="DEFAULT" END IF
		
		sSorters = request.querystring("sorters") 'expects json format "[{""property"":""company"",""direction"":""ASC""}, {""property"":""product"",""direction"":""DESC""}]"'
		   set oJson = new Json
		   oJson.loadJson(sSorters)
		SET aSorters = New ArrayList
		
		FOR EACH key IN oJson.getChildNodes("")
			aSorters.add(oJson.getElement(key&".property")&" "&oJson.getElement(key&".direction"))
		    'Response.write(key & " : " & oJson.getElement(key) & "<br />" & vbCrLf)
		NEXT
		IF aSorters.count>0 THEN sSorters="'"&REPLACE(aSorters.join(", "), "'", "''")&"'" ELSE sSorters="DEFAULT" END IF
		
		iPageIndex = request.querystring("PageIndex")
		IF iPageIndex="" THEN iPageIndex="DEFAULT" END IF
		iPageSize = request.querystring("PageSize")
		IF iPageSize="" THEN iPageSize="DEFAULT" END IF
		IF iPageSize="" THEN iPageSize="DEFAULT" END IF
		sFullPath = request.querystring("FullPath")
		iMaxRecords = request.querystring("MaxRecords")
		IF iMaxRecords="" THEN iMaxRecords="DEFAULT" END IF
		bRebuild = request.querystring("rebuild")
		IF bRebuild="" THEN bRebuild="DEFAULT" END IF
		bRebuildJS = request.querystring("rebuildJS")
		IF bRebuildJS="" THEN bRebuildJS="DEFAULT" END IF
		bBuild = request.querystring("build")
		IF bBuild="" THEN bBuild="DEFAULT" END IF
		IF bBuild="1" THEN bRebuild="1" END IF
		
		Dim fso:	Set fso = Server.CreateObject("Scripting.FileSystemObject")
		DIM sFolderName: sFolderName=fso.GetFolder(server.MapPath("..")).name
		sVersion=replaceMatch(sFolderName, "\..+$", "")
	End Sub

	Private Sub DataBind()
		DIM rsRecordSet
		set oXMLFile = Server.CreateObject("Microsoft.XMLDOM")
		    oXMLFile.Async = false
			DIM sTestFile
			'sTestFile = "XMLtest.xml"'request.querystring("testFile")'
			IF sTestFile<>"" THEN
				response.write "//file: "&Server.MapPath(".")&"\"&sTestFile': response.end
		    	oXMLFile.Load(Server.MapPath(".")&"/"&sTestFile)
			END IF
		Set oTimerQuery = [$StopWatch]
		oTimerQuery.StartTimer()
		Dim fso:	Set fso = Server.CreateObject("Scripting.FileSystemObject")
		DIM sApplicacionOutput: sApplicacionOutput=fso.GetFolder(server.MapPath(".")).name
		DIM xmlDoc, xmlString
		Set xmlDoc=Server.CreateObject("Microsoft.XMLDOM")
		xmlDoc.async="false"
		xmlDoc.load(Request)
		IF NOT xmlDoc.documentElement IS NOTHING THEN
			xmlString=REPLACE(REPLACE(REPLACE(URLDecode(xmlDoc.xml), "&", "&amp;"), "'", "\'"),vbcrlf,"")
			xmlString="'"&xmlString&"'"
			bRebuild="1"
		ELSE
			xmlString="DEFAULT"
		END IF
		IF oXMLFile.documentElement IS NOTHING THEN
		ON ERROR RESUME NEXT
			DIM bGetData, bGetStructure
			bGetData=request.querystring("getData")
			bGetStructure=request.querystring("getStructure")
			SELECT CASE UCASE(sOutput)
			CASE "HTML", "EXTJS":
				IF bGetData="" THEN bGetData = 0 END IF
				IF bGetStructure="" THEN bGetStructure=0 END IF
			CASE "JSON":
				IF bGetData="" THEN bGetData = 1 END IF
				IF bGetStructure="" THEN bGetStructure=0 END IF
			CASE ELSE 
				response.write "Output "&sOutput&" not supported"
			END SELECT

			oDataSource.CommandText = "EXEC [$Ver:"&sVersion&"].getXmlData @@IdUser="&SESSION("IdUsuario")&", @FullPath='"&sFullPath&"', @TableName='"&sCatalogName&"', @Mode="&sMode&", @PageIndex="&iPageIndex&", @PageSize="&iPageSize&", @MaxRecords="&iMaxRecords&", @ControlType="&sControlType&", @Filters="&sFilters&", @Sorters="&sSorters&", @Parameters="&sParameters&", @lang="&sLang&", @getData="&bGetData&", @getStructure="&bGetStructure&", @rebuild="&bRebuild&", @columnList="&xmlString&", @output="&sApplicacionOutput
			response.write "// "&oDataSource.CommandText&vbcrlf&"//<br/>"&vbcrlf
			oDataSource.DataBind()
			IF Err.Number<>0 THEN
				ShowError 284516, sOutput, "Error: "&replaceMatch(Err.Description, "\[[^\[]+\]", "")
				response.end
			END IF
		
			rsRecordSet=oDataSource.RecordSet
			oXMLFile.LoadXML(rsRecordSet(0))
		ON ERROR  GOTO 0
		END IF
		oTimerQuery.StopTimer()
		DIM sFileLocation: sFileLocation="cache\app\"&oXMLFile.documentElement.getAttribute("dbId")&"\"&oXMLFile.documentElement.getAttribute("xml:lang")&"\"&oXMLFile.documentElement.getAttribute("Table_Schema")&"\"&oXMLFile.documentElement.getAttribute("Table_Name")&"\"&oXMLFile.documentElement.getAttribute("mode")&"\"&oXMLFile.documentElement.getAttribute("controlType")&".js"
		DIM sFileName: sFileName=server.MapPath(sFileLocation)
		IF NOT fso.FolderExists(fso.GetParentFolderName(sFileName)) THEN
			response.write "//NO existía folder "&fso.GetParentFolderName(sFileName)&"!<br/>"&vbcrlf
			RecurseMKDir fso.GetParentFolderName(sFileName)
			'fso.CreateFolder(fso.GetParentFolderName(sFileName))
		END IF
		IF fso.FileExists(sFileName) AND (bRebuild="1" OR bRebuildJS="1") THEN
			fso.DeleteFile(sFileName)
			response.write "//Archivo "&sFileName&" eliminado!<br/>"&vbcrlf
		END IF
		IF NOT fso.FileExists(sFileName) THEN
			DIM tfile
			IF sTestFile="" THEN
				oDataSource.CommandText = "EXEC [$Ver:"&sVersion&"].getXmlData @@IdUser="&SESSION("IdUsuario")&", @FullPath='"&sFullPath&"', @TableName='"&sCatalogName&"', @Mode="&sMode&", @PageIndex="&iPageIndex&", @PageSize="&iPageSize&", @MaxRecords="&iMaxRecords&", @ControlType="&sControlType&", @Filters="&sFilters&", @Sorters="&sSorters&", @Parameters="&sParameters&", @lang="&sLang&", @getData=0, @getStructure=1, @rebuild="&bRebuild&", @columnList="&xmlString&", @output="&sApplicacionOutput
				response.write "// "&oDataSource.CommandText&vbcrlf&"//<br/>"&vbcrlf
				oDataSource.DataBind()
				rsRecordSet=oDataSource.RecordSet
				oXMLFile.LoadXML(rsRecordSet(0))
			END IF
			UTF8 Transform(oXMLFile, server.MapPath("Templates\extjs.xsl")), sFileName
			
			'set tfile=fso.CreateTextFile(sFileName,true,true)
			'tfile.write(Transform(oXMLFile, server.MapPath("Templates\extjs.xsl")))
			'tfile.close
			'set tfile=nothing
			response.write "//NO existía archivo "&sFileName&"!<br/>"&vbcrlf
		END IF
		IF NOT fso.FileExists(sFileName) THEN
			response.write "//NO se pudo crear el archivo "&sFileName&"!<br/>"&vbcrlf
		END IF
		IF fso.FileExists(sFileName) AND (bRebuild="1" OR bRebuildJS="1") AND UCASE(sOutput)="JSON" THEN %>{
success: true,
action: undefined,
catalog: {
	dbId: '<%= oXMLFile.documentElement.getAttribute("dbId") %>'
	,catalogName: '<%= oXMLFile.documentElement.getAttribute("Table_Schema") %>.<%= oXMLFile.documentElement.getAttribute("Table_Name") %>'
	,mode: '<%= oXMLFile.documentElement.getAttribute("mode") %>'
	,controlType: '<%= oXMLFile.documentElement.getAttribute("controlType") %>'
	,lang: '<%= oXMLFile.documentElement.getAttribute("xml:lang") %>'
} 
}<%			response.end
		END IF
		Set fso = nothing
	End Sub
	
	Private Sub Class_Terminate()
		SET oDataSource = NOTHING
		SET rsRecordSet = NOTHING
		SET oTimerRender = NOTHING
		SET aFilters = NOTHING
		SET aSorters = NOTHING
		SET oJson = NOTHING
		SET oXMLFile = NOTHING
	End Sub

	Public Property Get output()
		output = sOutput
	End Property
	Public Property Let output(input)
		IF IsEmpty(input) THEN
			sOutput = "HTML"
		ELSE
			sOutput = input
		END IF
	End Property


	Public Sub Statistics()
		response.write "Query Time: <strong>"&oTimerQuery.ElapsedTime&"</strong>; ": 
		response.write "Transformation Time: <strong>"&oTimerRender.ElapsedTime&"</strong><br/>"': response.end
	End Sub
	
	Public Sub WriteCode()
		DataBind
		IF bBuild<>"1" THEN
			SELECT CASE UCASE(sOutput)
			CASE "HTML":
				Me.HTMLFormat
			CASE "JSON", "EXTJS"
				Me.JSONFormat
			CASE ELSE 
				response.write "Output "&sOutput&" not supported"
			END SELECT
		END IF
	End Sub
	
	Public Sub JSONFormat()
		IF (testData<>"") THEN 
			testData=server.MapPath("custom/testfiles/"&testData)
			response.write "// Archivo de prueba: "&testData&""&vbcrlf
			response.write leeArchivo(testData)
		ELSE
			response.write "// "&oDataSource.CommandText&"<br/>"&vbcrlf
			DIM xslFile:	xslFile=server.MapPath("Templates\"&sOutput&".xsl")	'&request.querystring("xslFile"))
			'response.write vbcrlf&"//xml: "&oXMLFile.xml
			DIM extjs: extjs=Transform(oXMLFile, xslFile)
		END IF
		response.ContentType =  "application/json"
		response.write extjs
	End Sub
	
	Public Sub HTMLFormat() 
		SET oTimerRender = New StopWatch
		oTimerRender.StartTimer()
		
		IF oXMLFile.documentElement IS NOTHING THEN
			IF UCASE(session("username"))="WEBMASTER" THEN 	response.write "<br/><br/>"&oDataSource.CommandText&"<br/><br/>"
			response.write "Error: No se pudo recuperar la información XML<br><br>": RESPONSE.END
		END IF
		IF (oXMLFile.documentElement.getAttribute("controlType")="fileTemplate") THEN 
			DIM Document:	Set Document=new FileTranslator
'			ON ERROR RESUME NEXT
			DIM FileTemplate:	FileTemplate=oXMLFile.documentElement.selectSingleNode("//*[@fileTemplate]").getAttribute("fileTemplate")
				SELECT CASE Err.Number
				CASE 0
					'continue
				CASE ELSE
					response.write "Error "&Err.Number&"!, no está definido o se pudo recuperar el archivo plantilla.<br><br>"
					IF UCASE(session("username"))="WEBMASTER" THEN 	response.write Err.Description&" <br><br>"&sSQL
					response.end
					Err.Clear
				END SELECT
'			ON ERROR  GOTO 0
			'response.write FileTemplate
			IF ISNULL(FileTemplate) THEN 
				response.write "<strong>EL NOMBRE DEL ARCHIVO NO ESTÁ DEFINIDO</strong>": response.end
			END IF
			Document.FileName=server.MapPath("..\..\Documentos\"&FileTemplate)
			Document.DataSource=oXMLFile
			Document.WriteCode()
		ELSE
			DIM xslFile:	xslFile=server.MapPath("Templates\"&sOutput&".xsl")	'&request.querystring("xslFile"))
			TransformData oXMLFile, xslFile 
		END IF
		oTimerRender.StopTimer()
		IF UCASE(session("username"))="WEBMASTER" THEN 
			Statistics()
		END IF
%>
<%	End Sub
End Class
 %>