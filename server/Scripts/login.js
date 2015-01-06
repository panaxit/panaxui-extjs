var login = new Login();
login.onCancel = function() { window.close() }
login.onError = function()
	{
	alert('Error!!');
	}