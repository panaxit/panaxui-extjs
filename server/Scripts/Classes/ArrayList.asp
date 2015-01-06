<% 
Function [$Queue](ByRef aObjects)
	DIM oQueue:	Set oQueue = CreateObject("System.Collections.Queue")
	DIM oElement
	IF NOT IsEmpty(aObjects) THEN
		FOR EACH oElement IN aObjects
			oQueue.Enqueue oElement
		NEXT
	END IF
	Set [$Queue] = oQueue
End Function 
Function [$ArrayList](ByRef aObjects)
'	DIM oQueue:	Set oQueue=[$Queue](aObjects)
'	Debugger Me, TypeName(aObjects)
	DIM oArrayList:	Set oArrayList = New ArrayList
	SELECT CASE TypeName(aObjects)
	CASE "Variant()", "IMatchCollection2"
		oArrayList.AddRange aObjects
	CASE "Empty" 
	CASE ELSE
		oArrayList.Add aObjects
	END SELECT
	Set [$ArrayList]=oArrayList
	SET oArrayList = NOTHING
End Function
Class ArrayList
	Private oArray, sMode, iCurrentIndex, sJoin
	
	Private Sub Class_Initialize()
		Set oArray = CreateObject("System.Collections.ArrayList")
	End Sub
	Private Sub Class_Terminate()
		Set oArray = nothing
	End Sub
	
	Public Property Get [ArrayList]()
		Set [ArrayList]=oArray
	End Property
	
	Public Property Get Count()
		Count=oArray.Count
	End Property

	Public Property Get LastItem()
		IF Me.Count>0 THEN
			Assign LastItem, oArray(Me.Count-1)
		ELSE
			Assign LastItem, Empty
		END IF
	End Property

	Public Property Get FirstItem()
		Assign FirstItem, oArray(0)
	End Property

	Public Default Property Get Item(sPosition)
		ON ERROR	RESUME NEXT
		IF ISNUMERIC(sPosition) THEN
			Assign Item, oArray(sPosition)
		ELSE
			DIM oItem
			SELECT CASE UCASE(sPosition)
			CASE UCASE("First")
				Assign Item, oArray(0)
			CASE UCASE("Last")
				IF Me.Length>0 THEN
					Assign Item, oArray(Me.Length-1)
				ELSE
					Assign Item, Empty
				END IF
			CASE ELSE
				Assign Item, nothing
			END SELECT
		END IF
		[&Catch] TRUE, TypeName(Me)&".Item", "Error para "&TypeName(oElement) &""
		ON ERROR	GOTO 0
	End Property

	Public Function ToArray()
		ToArray = oArray.ToArray
	End Function

	Public Function Join(sSeparator)
		IF IsEmpty(sJoin) THEN
			DIM sJoin, oElement
			FOR EACH oElement IN oArray.ToArray()
				IF IsObject(oElement) THEN 
					sJoin=sJoin&"["&TypeName(oElement)&" Object]"
				ELSE
					sJoin=sJoin&oElement
				END IF
				sJoin=sJoin&sSeparator
			NEXT
		END IF
		sJoin=ReplaceMatch(sJoin, sSeparator&"$", "")
		Join = sJoin
	End Function

	Public Sub AddAt(ByRef oElement, ByVal iPosition)
		oArray.Insert iPosition, oElement
	End Sub
	
	Public Sub AddItem(ByRef oElement)
		Me.Add oElement
	End Sub
	
	Public Sub AddRange(oArrayList)
		DIM aElement
		SELECT CASE TypeName(oArrayList)
		CASE "Variant()"
			FOR EACH aElement IN oArrayList
				oArray.Add	aElement
			NEXT
		CASE "IMatchCollection2"
			FOR EACH aElement IN oArrayList
				oArray.Add	aElement.Value
			NEXT
		CASE ELSE
		END SELECT
	End Sub
	
	Public Sub Remove(sItem)
		oArray.Remove(sItem)
	End Sub
	
	Public Sub RemoveAt(iItem)
		oArray.RemoveAt(iItem)
	End Sub
	
	Public Sub Add(ByRef oElement)
		oArray.Add	oElement
	End Sub

	Public Sub AppendList(ByRef aAppendList, ByVal iStartIndex)
		IF IsEmpty(aAppendList) THEN Exit Sub
		DIM iOriginalLength:	iOriginalLength=Me.Length
		'response.write "Length: "&Me.Length&" --> "
		Allocate(Me.Length+UBOUND(aAppendList)-iStartIndex)
		'response.write "Length: "&Me.Length&"<br>"
		
		DIM iAppendIndex
		FOR iAppendIndex=iStartIndex TO UBOUND(aAppendList)
'			Debugger Me, aAppendList(iAppendIndex)&vbcrlf&vbcrlf
			Assign oArray(iOriginalLength+iAppendIndex-iStartIndex), aAppendList(iAppendIndex)
			IF IsObject(aAppendList(iAppendIndex)) THEN 
'				IF TypeName(aAppendList(iAppendIndex))="Cell" THEN oArray(iOriginalLength+iAppendIndex-iStartIndex).Relatives.Index=iAppendIndex
'				TryPropertySet oArray(iOriginalLength+iAppendIndex-iStartIndex), "Relatives.Index", iAppendIndex, TRUE
			END IF
		NEXT
		sJoin=Empty
		'response.write "<strong>"&Me.Length&"</strong><br>"
	End Sub
	
	Public Sub Clear()
		oArray.Clear()
	End sub

	Public Sub ForEach(sOperations)
		IF sOperations<>"" THEN
			DIM oElement
			FOR EACH oElement in oArray
				SELECT CASE sOperations
				CASE "[&echo]"
					[&echo] oElement
					[&echo] "<br>"
				CASE ELSE
					WITH oElement
						EXECUTE("."&sOperations)
					END WITH
				END SELECT
			NEXT
		END IF
	End Sub
End Class
 %>