attachEvent("onload", showButtons);
function showButtons()
{
try { top.frames('buttons').btnBack.enabled=true } catch(e) {}
try { top.frames('buttons').btnRefresh.enabled=true } catch(e) {}
try { top.frames('buttons').btnExcel.enabled=true } catch(e) {}
if ($('.dataTable').length>0)
	{
	try { top.frames('buttons').btnPrint.enabled=true } catch(e) {}
	try { top.frames('buttons').btnSave.enabled=true } catch(e) {}
	}
}