<% SERVER.SCRIPTTIMEOUT = 4800 %>
<%
'Stores only files with size less than MaxFileSize

'Using Huge-ASP file upload
'Dim Form: Set Form = Server.CreateObject("ScriptUtils.ASPForm")
'Using Pure-ASP file upload
Dim Form: Set Form = New ASPForm %>
<!--#INCLUDE FILE="../Scripts/upload.motobit.asp"-->
<!--#INCLUDE FILE="../Scripts/vbscript.asp"-->
<% 
Server.ScriptTimeout = 2000
Form.SizeLimit = &HF000000

'{b}Set the upload ID for this form.
'Progress bar window will receive the same ID.
if len(Request.QueryString("UploadID"))>0 then
	Form.UploadID = Request.QueryString("UploadID")'{/b}
end if
'was the Form successfully received?
Const fsCompleted  = 0
If Form.State = fsCompleted Then 'Completed
  'was the Form successfully received?
  If Form.State = 0 then %><% 
	Dim parentFolder
	Dim fileName, saveAs
	Dim relativeTargetPath, DestinationPath
	parentFolder=Request.QueryString("parentFolder")'TRIM(Form("parentFolder").Value)
	saveAs=Request.QueryString("saveAs")'TRIM(Form("saveAs").Value)
	
	Form.Files.Item("file").FileName = "tmp_"&Form.UploadID
	IF TRIM(saveAs)<>"" THEN
		Form.Files.Item("file").FileName = saveAs
	END IF
	'fileName = Form.Files.Items.Item(0).FileName
	relativeTargetPath=parentFolder & "/" & fileName
	' Ruta donde se va a guardar el file
	DestinationPath = Server.mapPath("../../../../"&parentFolder)
	Dim fso:	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	
	'response.write "DestinationPath: "&DestinationPath: response.end
	'response.end
'ON ERROR RESUME NEXT
%>
<% Form.Files.Save DestinationPath %>
<% IF Err.Number<>0 THEN %>
	{
	success: false,
	statusMessage: "Error: <%= REPLACE(Err.Description,"""","\""") %>"
	}
<% ELSE %>
	<% DIM File  %>
		{
		success:true, 
		files: [
	<% FOR EACH File IN Form.Files.Items %>, {
				sourceId: "<%= File.Name %>",
				file: "<%= parentFolder %>/<%= File.FileName %>",
				fileExtension: "<%= REPLACE(File.FileName, fso.GetBaseName(File.FilePath)&".", "") %>",
				originalFile: "<%= REPLACE(File.FilePath, "\", "\\") %>",
				fileName:"<%= File.FileName %>",
				parentFolder:"<%= parentFolder %>",
				status:"success"
			}
	<% NEXT %>
		],
		statusMessage:"<%= Form.Files.Count %> file(s) uploaded to <%= Request.ServerVariables("HTTP_HOST") %> (<%= relativeTargetPath %>)"
		}
	<%  End If
	ElseIf Form.State > 10 then
	  Const fsSizeLimit = &HD %>
			<script language="JavaScript">
				var resultObject = new Object();
				resultObject.status="error";
				resultObject.statusMessage="<% Select case Form.State
			case fsSizeLimit: %>Source form size (<%= Form.TotalBytes %>B) exceeds form limit (<%= Form.SizeLimit %>B)<% case else %>Some form error.<% end Select %>";
			    alert(resultObject.statusMessage)
			    window.close();
			</script>	
	<%	response.end
	End If'Form.State = 0 then %>
<% END IF %>
