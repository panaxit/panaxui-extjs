<% 
Function [$DataSource]()
	DIM oDataSource:	Set oDataSource = new DataSource
'	oDataSource.DataField = oDataField
	Set [$DataSource] = oDataSource
End Function
Class DataSource
	Private sFieldNull, bShowRowNumber, bDataBound
	Private oConnection, sCommandText, sPagedCommandText, sConnectionString, rsRecordSet, aRecords, oFields
	Private bEnablePaging, iPageSize, iPageIndex, sRankORDERBY, rsAllOriginalRecords, sAllOriginalRecords, iTotalRecords, iRecordCount, sDBLanguage, sQueryFilter, dFilterMembers
	Private oPageSelector, dParameters, oProgressBar
	Private sOutput, sErrorDescription

	Private oTable
	Private iIndex

	'Timers
    Private oTimerOpenConection, oTimerQuery, oTimeFetching, oTimeMetadata
	
	Private Sub Class_Initialize()
		iIndex = 0
		IF NOT IsEmpty(request.querystring("output")) THEN
			sOutput = request.querystring("output")
		ELSE
			sOutput = "HTML"
		END IF
		Set oConnection = nothing
		Set oTimerOpenConection = new StopWatch
		Set oTimerQuery = new StopWatch
		Set oTimeFetching = new StopWatch
		Set oTimeMetadata = new StopWatch
		Set oConnection = nothing
		set rsRecordSet=nothing
		Set dFilterMembers = server.CreateObject("Scripting.Dictionary")
		Set dParameters = server.CreateObject("Scripting.Dictionary")
		IF SESSION("StrCnn")<>"" THEN
			sConnectionString=SESSION("StrCnn")
		ELSE
			sConnectionString=application("StrCnn")
		END IF
		IF request.querystring("PageIndex")<>"" THEN
			iPageIndex = CINT(request.querystring("PageIndex"))
		ELSE
			iPageIndex=1
		END IF
		sFieldNull="&nbsp;"
		bShowRowNumber=TRUE
		Set oPageSelector = nothing
		Set oProgressBar = nothing
	End Sub
	
	Private Sub Class_Terminate()
		IF NOT oConnection IS NOTHING THEN oConnection.Close
		Set oConnection = nothing
		set rsAllOriginalRecords=nothing
		set rsRecordSet=nothing
		Set dFilterMembers = NOTHING
		Set oTimerOpenConection = nothing
		Set oTimerQuery = nothing
		Set oTimeFetching = nothing
		Set oTimeMetadata = nothing
		Set oPageSelector = nothing
		Set oProgressBar = nothing
	End Sub

	Public Property Get ProgressBar()
		IF oProgressBar IS NOTHING THEN Set oProgressBar = new Progress
		Set ProgressBar = oProgressBar
	End Property

	Public Property Get Output()
		Output = sOutput
	End Property
	Public Property Let Output(input)
		sOutput = input
	End Property

	Public Property Get Table()
		Set Table = oTable
	End Property
	Public Property Let Table(input)
		Set oTable = input
	End Property

	Public Property Get QueryFilter()
		QueryFilter = sQueryFilter
	End Property
	Public Property Let QueryFilter(input)
		sQueryFilter = input
	End Property

	Public Property Get Parameters()
		Set Parameters = dParameters
	End Property

	Public Sub ShowProperties()
		response.write "Properties for recordset: <br>"
		DIM oColumn
		FOR EACH oColumn IN rsRecordSet.Properties
			response.write "<b>"&oColumn.Name&"</b>: "&oColumn.Value&"<br>"
		NEXT
	End Sub
	
	Public Function DataBind()
		IF oConnection IS NOTHING THEN
			OpenConnection()
		END IF
		
		IF sCommandText="" THEN 
			Err.Raise 1, "ASP 101", "SQL Query is not defined"
			response.end
		END IF
		oTimerQuery.StartTimer()
		IF bEnablePaging THEN
			set rsRecordSet=oConnection.execute(sPagedCommandText)
		ELSE
'			set rsRecordSet=oConnection.execute(sCommandText)
			Set rsRecordSet = Server.CreateObject("ADODB.RecordSet")
			rsRecordSet.CursorLocation 	= 3
			rsRecordSet.CursorType 		= 3
			IF request.querystring("debug")="true" THEN response.write "<br/><br/>"&sCommandText: response.end
			'rsRecordSet.open sCommandText, oConnection
			ON ERROR  RESUME NEXT
			set rsRecordSet=oConnection.execute(sCommandText)'"RAISERROR('HELLO THERE', 16, 1)")
			SELECT CASE Err.Number
			CASE -2147467259
				ShowError 284501, sOutput, "Ocurrió un problema de conexión, intenténlo nuevamente.</strong><br/> "&replaceMatch(Err.Description, "\[[^\[]+\]", "")
				response.end
				Err.Clear
			CASE -2147217900
				DIM sErrorDescription:	sErrorDescription=replaceMatch(Err.Description, "\[[^\[]+\]", "")
				IF UCASE(session("username"))="WEBMASTER" THEN 	
					sErrorDescription=sErrorDescription'&"\n\n"&replace(sCommandText, """", "\""")
				END IF
				ShowError 284502, sOutput, sErrorDescription
				response.end
				IF request.querystring("app_retry")<>1 THEN 
					DIM sCurrentLocation:	sCurrentLocation=Request.serverVariables("PATH_INFO")&"?"&Request.ServerVariables("QUERY_STRING")
					'IF Request.ServerVariables("QUERY_STRING")<>"" THEN sCurrentLocation=sCurrentLocation&"&"
					'response.write "<strong>REINTENTANDO... ("&sCurrentLocation&"&app_retry=1)</strong>"
					response.redirect sCurrentLocation&"&app_retry=1"
				END IF
				ShowError 284503, sOutput, replaceMatch(Err.Description, "\[[^\[]+\]", "")
				response.end
			CASE 0
				IF rsRecordSet.EOF AND rsRecordSet.BOF THEN 
				ShowError Err.Number, sOutput, "No se encontraron registros"
					response.end
				END IF
			CASE ELSE
				sErrorDescription = "No se pudo recuperar la información: "&Err.Description
				ShowError Err.Number, sOutput, sErrorDescription
				response.end
				Err.Clear
			END SELECT
			ON ERROR  GOTO 0
		END IF
		oTimerQuery.StopTimer()
		'Me.CreateHTMLPager()

		bDataBound=TRUE
		Set DataBind = rsRecordSet
	End Function
	
	Public Sub OpenConnection()
		oTimerOpenConection.StartTimer()
		ON ERROR RESUME NEXT
		IF TRIM(sConnectionString)="" THEN
			Err.Raise 1, "Connection String", "Connection string is missing"
		ELSE
			Set oConnection = server.createobject("ADODB.Connection")
			oConnection.open sConnectionString
		END IF
			SELECT CASE Err.Number
			CASE 0
				'continue
			CASE ELSE
				ShowError 284501, "Ocurrió un problema de conexión, inténtelo nuevamente.</strong><br/> "&replaceMatch(Err.Description, "\[[^\[]+\]", "")
				response.end
				Err.Clear
			END SELECT
		ON ERROR  GOTO 0
		oConnection.CommandTimeout = 600
		oTimerOpenConection.StopTimer()
	End Sub
	
	Public Property Get Fields()
		Set Fields = oFields
	End Property

	Public Property Get Metadata()
		Set Metadata = oMetadata
	End Property

	Public Property Get PageSelector()
		Set PageSelector = oPageSelector
	End Property

	Public Property Get DBLanguage()
		DBLanguage = sDBLanguage
	End Property
	Public Property Let DBLanguage(input)
		sDBLanguage = input
		Me.SetDBLanguage(sDBLanguage)
	End Property
	
	Public Property Get FieldNull()
		FieldNull = sFieldNull
	End Property
	Public Property Let FieldNull(input)
		sFieldNull = input
	End Property

   Public Property Get RecordSet()
		Set RecordSet = rsRecordSet
    End Property

	Public Property Get ShowRowNumber()
		ShowRowNumber = bShowRowNumber
	End Property
	Public Property Let ShowRowNumber(input)
		bShowRowNumber = input
	End Property

	Public Property Get DataBound()
		DataBound = bDataBound
	End Property

	Public Property Get FilterMembers()
		Set FilterMembers = dFilterMembers
	End Property

    Public Property Get TotalRecords()
		TotalRecords = iTotalRecords
    End Property

	Public Property Get RecordCount()
		RecordCount = iRecordCount
	End Property

    Public Property Get EnablePaging()
		EnablePaging = bEnablePaging
    End Property
    Public Property Let EnablePaging(input)
		bEnablePaging = input
    End Property

	Public Property Get InitialRecord()
		InitialRecord = iPageSize*(iPageIndex-1)
	End Property

    Public Property Get PageSize()
		PageSize = iPageSize
    End Property
    Public Property Let PageSize(input)
		iPageSize = input
    End Property

    Public Property Get PageIndex()
		PageIndex = iPageIndex
    End Property
    Public Property Let PageIndex(input)
		iPageIndex = input
    End Property

    Public Default Property Get CommandText()
		CommandText = sCommandText
    End Property
    Public Property Let CommandText(input)
		sCommandText = input
    End Property
	
    Public Property Get PagedCommandText()
		PagedCommandText = sPagedCommandText
    End Property

    Public Property Get ConnectionString()
		CommandText = sConnectionString
    End Property
    Public Property Let ConnectionString(input)
		sConnectionString = input
    End Property
	
    Public Property Get TimeOpenConn()
		TimeOpenConn = 	oTimerOpenConection.TotalTime()
    End Property
	
	Public Property Get TimeQuery()
		TimeQuery = oTimerQuery.TotalTime
    End Property
       
	Public Property Get TimeFetching()
		TimeFetching = oTimeFetching.TotalTime
	End Property

	Public Property Get TimeMetadata()
		TimeMetadata = oTimeMetadata.TotalTime
	End Property

	Public Property Get Index()
		Index = iIndex
	End Property
	Public Property Let Index(input)
		iIndex = input
	End Property

	Public Sub MoveNext()
		iIndex=iIndex+1
'		IF NOT oDataSource.RecordSet.EOF THEN
'			oDataSource.RecordSet.MoveNext
'		END IF
	End Sub

	Public Sub MoveTo(input)
		iIndex=input
	End Sub

	Public Sub MoveFirst()
		IF NOT(oDataSource.RecordSet.BOF AND oDataSource.RecordSet.EOF) THEN
			iIndex=0
'			oDataSource.RecordSet.MoveFirst
		END IF
	End Sub

	Public Property Get BOF()
		BOF = (iIndex-1<0)
	End Property

	Public Property Get EOF()
		EOF = iIndex>iRecordCount-1
	End Property

	Public Sub MoveLast()
		iIndex=UBOUND(aValues)-1
'		oDataSource.RecordSet.MoveLast
	End Sub

	Public Sub MovePrevious()
		iIndex=iIndex-1
'		oDataSource.RecordSet.MovePrevious
	End Sub

	Public Sub SetDBLanguage(ByVal sLanguage)
'		IF sLanguage<>sDBLanguage THEN
		oConnection.open sConnectionString
		oConnection.Execute("sp_defaultlanguage @loginame = 'sa' ,@language = '"&sLanguage&"'")
		oConnection.Execute("SET LANGUAGE "&sLanguage)
'		response.write "Language set to "&sLanguage&"<br>"
		oConnection.close
'		END IF
	End Sub
	
	Public Sub CreateHTMLPager
		IF Me.PageSize>0 THEN
			Set oPageSelector = new Div
			oPageSelector.Id="freeze"
			DIM oImgLArrow: Set oImgLArrow=new ImageButton
			oImgLArrow.ImageURL="\"&application("btn_LArrow_path")
			oImgLArrow.Disabled=TRUE
			oImgLArrow.Width=20
			oImgLArrow.Height=20
			DIM oImgRArrow: Set oImgRArrow=new ImageButton
			oImgRArrow.ImageURL="\"&application("btn_RArrow_path")
			oImgRArrow.Disabled=TRUE
			oImgRArrow.Width=20
			oImgRArrow.Height=20
			
			DIM sCurrentURL: sCurrentURL=Request.serverVariables("PATH_INFO")
			IF Request.ServerVariables("QUERY_STRING")<>"" THEN
				sCurrentURL=sCurrentURL&"?"&REPLACE(Request.ServerVariables("QUERY_STRING"), "'", "\'")
			END IF
			DIM sGoBackURL: sGoBackURL=updateURLString(sCurrentURL, "PageIndex", Me.PageIndex-1)
			DIM sGoForwardURL: sGoForwardURL=updateURLString(sCurrentURL, "PageIndex", Me.PageIndex+1)
			IF Me.PageIndex-1>0 THEN
				oImgLArrow.CommandText="OpenLink(encodeURI('"&REPLACE(REPLACE(sGoBackURL, "'", "\'"), "\\'", "\'")&"'), false, true)"
				oImgLArrow.Disabled=FALSE
			END IF
			DIM iTotalPages: iTotalPages=ROUND((Me.TotalRecords/Me.PageSize)+.5, 0)
			IF Me.PageIndex+1<=iTotalPages THEN 
				oImgRArrow.CommandText="OpenLink(encodeURI('"&REPLACE(REPLACE(sGoForwardURL, "'", "\'"), "\\'", "\'")&"'), false, true)"
				oImgRArrow.Disabled=FALSE
			END IF
			DIM oDropDownSelector: Set oDropDownSelector = new NumberList
			oDropDownSelector.Control.NewOption CSTR(Me.PageIndex), CSTR(Me.PageIndex)
			oDropDownSelector.Control.OptionChoose=FALSE
			oDropDownSelector.Control.Properties.SetProperty "isSubmitable", "false"
			oDropDownSelector.MinValue=1
			oDropDownSelector.MaxValue=iTotalPages
			oDropDownSelector.Methods.OnChange="OpenLink(encodeURI('"&updateURLString(REPLACE(REPLACE(sCurrentURL, "'", "\'"), "\\'", "\'"), "PageIndex", "'+this.value+'")&"'), false, true)"
			oDropDownSelector.Value=CSTR(Me.PageIndex)&"@:@"&CSTR(Me.PageIndex)
			oPageSelector.AddContent(oImgLArrow)
			oPageSelector.AddContent("&nbsp;<b>Página: ")
			oPageSelector.AddContent(oDropDownSelector)
			oPageSelector.AddContent(" / "&iTotalPages&"</b>&nbsp;")
			oPageSelector.AddContent(oImgRArrow)
		END IF
	End Sub
End Class
 %>