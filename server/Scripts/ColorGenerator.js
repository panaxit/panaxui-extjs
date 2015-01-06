//Codigo obtenido de http://www.webtaller.com/construccion/lenguajes/javascript/lecciones/tabla-colores-javascript.php
//creamos los arrays 
var r = new Array("00","33","66","99","CC","FF"); 
var g = new Array("00","33","66","99","CC","FF"); 
var b = new Array("00","33","66","99","CC","FF"); 

//hacemos el bucle anidado 
for (i=0;i<r.length;i++) { 
    for (j=0;j<g.length;j++) { 
       for (k=0;k<b.length;k++) { 
          //creamos el color 
          var nuevoc = "#" + r[i] + g[j] + b[k]; 
          //imprimimos el color 
          document.write(nuevoc + "<br>"); 
       } 
    } 
} 
