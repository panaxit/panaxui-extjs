$(document).ready(function(){
	$(":select").each(function(){
		this.defaultValue=this.value;
	})
	$(":radio, :checkbox").click(function(){
		alert(this.value)
	})
	
	$(":input")
	.blur(function(){
   		$(this).removeClass("activeInput")
	})
	.focus(function(){
   		$(this).addClass("activeInput")
	})
	.bind('propertychange', function(oSrcElement) {
	if (document.activeElement!=this && event.propertyName=='value' && this.lastValue!=this.value || event.propertyName=='selectedIndex' || event.propertyName=='checked')
		{
		var property_changed=((/*this.defaultValue!=undefined && */!(getVal(this.defaultValue)===getVal(this.value)) ) || ((this.type=='checkbox' || this.type=='radio') && this.defaultChecked!=this.checked) )
		this.lastValue=this.value;
		if (property_changed)
	   		$(this).addClass("changedInput");
		else if ($(this).hasClass("changedInput"))
			$(this).removeClass("changedInput");
		}
   	});
 });

 $(document).ready(function(){
	$("*[required='true']")
		.addClass("required")
 });
