/*
 * SimpleModal Confirm Modal Dialog
 * http://www.ericmmartin.com/projects/simplemodal/
 * http://code.google.com/p/simplemodal/
 *
 * Copyright (c) 2010 Eric Martin - http://ericmmartin.com
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Revision: $Id: confirm.js 254 2010-07-23 05:14:44Z emartin24 $
 */

function confirm(message, callback) {
	var oModal=document.createElement("<div></div>")
	oModal.innerHTML="<div class='header'><span>Confirm</span></div><div class='message'></div><div class='buttons'><div class='no simplemodal-close'>No</div><div class='yes'>Yes</div></div>"
	$(oModal).modal({
		closeHTML: "<a href='#' title='Cerrar' class='modal-close'>x</a>",
		position: ["20%",],
		overlayId: 'confirm-overlay',
		containerId: 'confirm-container', 
		onShow: function (dialog) {
			var modal = this;

			$('.message', dialog.data[0]).append(message);

			// if the user clicks "yes"
			$('.yes', dialog.data[0]).click(function () {
				// call the callback
				if ($.isFunction(callback)) {
					callback.apply();
				}
				else {
					return true;
				}
				// close the dialog
				modal.close(); // or $.modal.close();
			});
		}
	});
}