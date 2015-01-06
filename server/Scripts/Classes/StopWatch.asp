<% 
Function [$StopWatch]()
	DIM oStopWatch:	Set oStopWatch=[&New]("StopWatch", "")
	Set [$StopWatch]=oStopWatch
End Function
Class StopWatch
	Private tStartTime, tStopTime, bIsRunning, aLaps, tTotalTime, iDecimalPositions

	Private Sub Class_Initialize()
		iDecimalPositions=3
		tStartTime = null
		tStopTime = null
		bIsRunning = false
		Set aLaps= new ArrayList
	End Sub
	Private Sub Class_Terminate()
		Set aLaps = nothing
	End Sub

	'Properties
	Public Property Get StartTime()
		StartTime = tStartTime
	End Property

	Public Property Get StopTime()
		StopTime = tStopTime
	End Property

	Public Property Get IsRunning()
		IsRunning = bIsRunning
	End Property

	Public Property Get ElapsedTime()
		ElapsedTime = (timer - tStartTime)
	End Property

	Public Property Get TotalTime()
	    IF (ISNULL(tStartTime) OR ISNULL(tStopTime)) THEN
	        TotalTime=-1
	    ELSE
	        TotalTime=(tStopTime - tStartTime)
		END IF
	End Property
	
	'Methods
	Public Function Lap()
		DIM tLast: tLast=aLaps.LastItem
		aLaps.Add timer
		Lap=ROUND(aLaps.LastItem-Try(IsEmpty(tLast), tStartTime, tLast), iDecimalPositions)
	End Function
	
	Public Sub StartTimer()
	    IF (bIsRunning) THEN
			response.write "Warning: Stop watch was already running... try Lap() Method to set lap times"
	        Exit Sub
	    ELSEIF (NOT ISNULL(tStartTime)) THEN
	        tStopTime = null
		END IF
	    bIsRunning = true
	    tStartTime = timer
	End Sub

	Public Sub StopTimer()
	    if (bIsRunning = false) THEN Exit Sub
	    tStopTime = timer
	    bIsRunning = false
	End Sub
End Class
 %>