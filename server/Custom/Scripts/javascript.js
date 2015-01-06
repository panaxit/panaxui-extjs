Ext.ns("Eventos.Evento");
Eventos.Evento.createMail = function (oDataRow)
{
//	alert(document.location.href)
	var oMailMessage = new MailMessage();
	oMailMessage.to="ugomez@habi.com.mx";
	oMailMessage.subject="Listado"
	oMailMessage.messageURL=escape(document.location.href); //escape('Segunda prueba');
	oMailMessage.send();
}
