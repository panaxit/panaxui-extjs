<%
'Option Explicit

'Dim objFSO, strFileIn, strFileOut

'strFileIn = WScript.ScriptName

'Set objFSO = CreateObject( "Scripting.FileSystemObject" )
'strFileOut = objFSO.GetBaseName( strFileIn ) & "_utf8.txt"
'Set objFSO = Nothing

'UTF8 strFileIn, strFileOut
Function UTF8( myFileIn, myFileOut )
' UTF8()  Version 1.00
' Open a "plain" text file and save it again in UTF-8 encoding
' (overwriting an existing file without asking for confirmation).
'
' Based on a sample script from JTMar:
' http://bytes.com/groups/asp/52959-save-file-utf-8-format-asp-vbscript
'
' Written by Rob van der Woude
' http://www.robvanderwoude.com

    Dim objStream

    ' Valid Charset values for ADODB.Stream
    Const CdoBIG5        = "big5"
    Const CdoEUC_JP      = "euc-jp"
    Const CdoEUC_KR      = "euc-kr"
    Const CdoGB2312      = "gb2312"
    Const CdoISO_2022_JP = "iso-2022-jp"
    Const CdoISO_2022_KR = "iso-2022-kr"
    Const CdoISO_8859_1  = "iso-8859-1"
    Const CdoISO_8859_2  = "iso-8859-2"
    Const CdoISO_8859_3  = "iso-8859-3"
    Const CdoISO_8859_4  = "iso-8859-4"
    Const CdoISO_8859_5  = "iso-8859-5"
    Const CdoISO_8859_6  = "iso-8859-6"
    Const CdoISO_8859_7  = "iso-8859-7"
    Const CdoISO_8859_8  = "iso-8859-8"
    Const CdoISO_8859_9  = "iso-8859-9"
    Const cdoKOI8_R      = "koi8-r"
    Const cdoShift_JIS   = "shift-jis"
    Const CdoUS_ASCII    = "us-ascii"
    Const CdoUTF_7       = "utf-7"
    Const CdoUTF_8       = "utf-8"

    ' ADODB.Stream file I/O constants
    Const adTypeBinary          = 1
    Const adTypeText            = 2
    Const adSaveCreateNotExist  = 1
    Const adSaveCreateOverWrite = 2

    On Error Resume Next
    
    Set objStream = CreateObject( "ADODB.Stream" )
    objStream.Open
    objStream.Type = adTypeText
    objStream.Position = 0
    objStream.Charset = CdoUTF_8
    'objStream.LoadFromFile myFileIn
	objStream.WriteText myFileIn
    objStream.SaveToFile myFileOut, adSaveCreateOverWrite
    objStream.Close
    Set objStream = Nothing
    
    If Err Then
        UTF8 = False
    Else
        UTF8 = True
    End If
    
    On Error Goto 0
End Function

Function SaveBinaryData(FileName, ByteArray)
  Const adTypeBinary = 1
  Const adSaveCreateOverWrite = 2
  
  'Create Stream object
  Dim BinaryStream
  Set BinaryStream = CreateObject("ADODB.Stream")
  
  'Specify stream type - we want To save binary data.
  BinaryStream.Type = adTypeBinary
  
  'Open the stream And write binary data To the object
  BinaryStream.Open
  BinaryStream.Write ByteArray
  
  'Save binary data To disk
  BinaryStream.SaveToFile FileName, adSaveCreateOverWrite
End Function

Function SaveTextData(FileName, Text, CharSet)
  Const adTypeText = 2
  Const adSaveCreateOverWrite = 2
  
  'Create Stream object
  Dim BinaryStream
  Set BinaryStream = CreateObject("ADODB.Stream")
  
  'Specify stream type - we want To save text/string data.
  BinaryStream.Type = adTypeText
  
  'Specify charset For the source text (unicode) data.
  If Len(CharSet) > 0 Then
    BinaryStream.CharSet = CharSet
  End If
  
  'Open the stream And write binary data To the object
  BinaryStream.Open
  BinaryStream.WriteText Text
  
  'Save binary data To disk
  BinaryStream.SaveToFile FileName, adSaveCreateOverWrite
End Function


%>