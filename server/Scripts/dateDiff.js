//http://www.htmlgoodies.com/html5/javascript/calculating-the-difference-between-two-dates-in-javascript.html#fbid=L_jFzkw0IGI
 // datepart: 'y', 'm', 'w', 'd', 'h', 'n', 's'
Date.dateDiff = function(datepart, fromdate, todate) {	
  datepart = datepart.toLowerCase();	
  var diff = todate - fromdate;	
  var divideBy = { w:604800000, 
                   d:86400000, 
                   h:3600000, 
                   n:60000, 
                   s:1000 };	
  
  return Math.floor( diff/divideBy[datepart]);
}

/*var start = new Date('2012-05-30 00:00:00');
var end=  new Date(); // new Date('2012-05-31 00:00:00'); //
alert( Date.dateDiff('h', start, end)+' Horas');*/