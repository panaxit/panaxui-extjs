<%
DIM oFSO: SET oFSO=Server.CreateObject("Scripting.FileSystemObject")
DIM sTmpFileName:	sTmpFileName=Server.MapPath(Request.ServerVariables("URL"))
DIM sTestFileName:	sTestFileName=replaceMatch(sTmpFileName, "(.*([/\\]))(\bVersion[/\\].*?[/\\])(.+?\.asp)", "$1Version$2"&APPLICATION("#testPath")&"$2$4")
DIM bExistsNewFile:	bExistsNewFile=(TRIM(oFSO.buildPath(oFSO.GetParentFolderName(sTmpFileName), oFSO.GetFileName(sTmpFileName)))<>TRIM(oFSO.buildPath(oFSO.GetParentFolderName(sTestFileName), oFSO.GetFileName(sTestFileName))))
IF (UCASE(session("username"))="WEBMASTER" OR Request.ServerVariables("REMOTE_ADDR")="10.1.1.251") AND bExistsNewFile THEN 
	'response.write replaceMatch(sTmpFileName, "(.*([/\\]))(\bVersion[/\\].*?[/\\])(.+?\.asp)", "$1Version$2"&APPLICATION("#testPath")&"$2$4"): response.end
	DIM sLocation:	sLocation=Request.serverVariables("PATH_INFO")&"?"&Request.ServerVariables("QUERY_STRING")
	IF bExistsNewFile THEN
		response.redirect (replaceMatch(sLocation, "(.*([/\\]))(\bVersion[/\\].*?[/\\])(.+?\.asp)", "$1Version$2"&APPLICATION("#testPath")&"$2$4"))'replaceMatch(sLocation, "(.*[/\\])(.+?\.asp)", "$1Modulos/$2"))
	END IF
	response.end 
END IF 
%>
