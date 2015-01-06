Ext.onReady(function() {
	var workarea=Ext.getCmp('app-workarea');
	workarea.remove(0);
	workarea.add(Ext.apply(diagram));
	
	var diagram = Ext.getCmp('app-workarea').add([{
		xtype: 'panel',
		layout: {
			type: 'border',
			padding: 5
		},
		defaults: {
			split: true
		}, 
		items: [
		{
		region: 'north',
		xtype: 'box',
		html: 'north',
		},{
		region: 'south',
		xtype: 'box',
		html: 'south',
		},{
			region: 'west',
			collapsible: true,
			title: 'Elementos',
			split: true,
			width: 80,
			minWidth: 100,
			minHeight: 140,
			html: '<div id="obj1"><center><br><img src="../../../../resources/images/Proyectos/empty.png" id="empty" style="cursor:move" height="100"/><br><img src="../../../../resources/images/Proyectos/working.png"   id="working" style="cursor:move" height="100"/><br><img src="../../../../resources/images/Proyectos/finished.png"   id="finished" style="cursor:move" height="100"/></center></div>'
		},{
			region: 'center',
			html: 'center center',
			title: 'Diagrama',
			id: 'diagram_workarea',
			minHeight: 80,
			html: '<div id="center1" class="x-layout-active-content"><div id="paintarea" style="position:relative;width:3000px;height:3000px;" ></div></div>',
			bbar: [ 'Opciones:', ' ', {
				text: 'Guardar',
				listeners: {
					click: function () {
						alert(new draw2d.CanvasXmlSerializer().toXML(workflow.getDocument()));
						
						Ext.Ajax.request({
							url: '../Templates/diagrama.js',
							method: 'GET',
							params: {
								catalogName: 'Diagram',
								pageSize: 20,
								output: 'extjs'
							},
							// process the response object to add it to the TabPanel:
							success: function(xhr) {
								//eval("var newComponent={xtype: 'grid',title: 'Invoice Report'}"); // see discussion below
								var result;
								eval(xhr.responseText); // see discussion below
								if (result) updateWorkarea(Ext.apply(result), 'Diagrama');
								/*myTabPanel.add(newComponent); // add the component to the TabPanel
								myTabPanel.setActiveTab(newComponent);*/
							},
							failure: function() {
								Ext.Msg.alert("Grid create failed", "Server communication failure");
							}
						});
					}
				}
			}]
		},{
			region: 'east',
			collapsible: true,
			collapsed: true,
			split: true,
			width: 400,
			minWidth: 400,
			title: 'Proyecto: ',
			layout: {
				type: 'border',
				padding: 5
			},
			items: [{
				title: 'Historial',
				region: 'west',
				width:80,
				minWidth: 80,
				html: '<div id="obj1"><center><br><img src="../../../../resources/images/Proyectos/empty.png" height="50"/><br><img src="../../../../resources/images/Proyectos/working.png" height="50"/><br><img src="../../../../resources/images/Proyectos/finished.png" height="50"/></center></div>',
				split: true,
				collapsible: true,
				collapsed: true
			}, {
				title: 'Archivo Actual',
				region: 'center',
				collapsible: true,
				split: true,
				minWidth: 80,
				items: [{
					xtype: 'image',
					width: 70,
					style: { display: 'block', margin: 'auto' },                
					src: '../../../../resources/images/Proyectos/working.png',               
				}, {
					xtype     : 'textareafield',
					grow      : true,
					name      : 'message',
					fieldLabel: 'Descripcion',
					anchor    : '100%',
					labelAlign: 'top',
				}]
			}, {
				title: 'Archivos',
				region: 'south',
				minHeight: 120,
					layout: {
						type: 'hbox',
						align: 'top'
					},
				items: [{
					xtype: 'image',
					height: 70,
					style: { display: 'block', margin: 'auto' },                
					src: '../../../../resources/images/Proyectos/finished.png',               
				},{
					xtype: 'image',
					height: 70,
					style: { display: 'block', margin: 'auto' },                
					src: '../../../../resources/images/Proyectos/finished.png',               
				},{
					xtype: 'image',
					height: 70,
					style: { display: 'block', margin: 'auto' },                
					src: '../../../../resources/images/Proyectos/empty.png',               
				},{
					xtype: 'image',
					height: 70,
					style: { display: 'block', margin: 'auto' },                
					src: '../../../../resources/images/Proyectos/empty.png',               
				},{
					xtype: 'image',
					height: 70,
					style: { display: 'block', margin: 'auto' },                
					src: '../../../../resources/images/Proyectos/empty.png',               
				}],
			}, {
				title: 'Estatus actual',
				region: 'east',
				flex: 1,
				minWidth: 80,
				items: {
					xtype: 'form',
					defaults: {
						labelWidth: 40,
					},
					defaultType: 'textfield',
					labelWidth: 30,
					items: [{
						fieldLabel: 'Vo.Bo',
						xtype: 'checkboxgroup',
						columns: 1,
						vertical: true,
						items: [
							{ boxLabel: 'Proyecto', name: 'rb', inputValue: '1' },
							{ boxLabel: 'Plaza', name: 'rb', inputValue: '2', checked: true },
							{ boxLabel: 'Obra', name: 'rb', inputValue: '3' }
						]
					},{
						fieldLabel: 'Status',
						xtype: 'radiogroup',
						columns: 1,
						vertical: true,
						items: [
							{ boxLabel: 'Trabajo', name: 'rb', inputValue: '1' },
							{ boxLabel: 'Info', name: 'rb', inputValue: '2', checked: true },
							{ boxLabel: 'Autorizar', name: 'rb', inputValue: '3' }
						]
					}],
				},
				split: true,
				collapsible: true
			}]
		}]
	}]);
   /**********************************************************************************
   * 
   * Do the Draw2D Stuff
   *
   **********************************************************************************/
  var workflow  = new draw2d.Workflow("paintarea");
	workflow.html.style.backgroundImage="url(../../../../resources/images/Proyectos/grid_10.png)"
//  workflow.setEnableSmoothFigureHandling(true);


  // Add the image node to the canvas
  //
  var startObj1 = new draw2d.diagramImage("../../../../resources/images/Proyectos/finished.png");
  startObj1.id='1'
  workflow.addFigure(startObj1, 100,25);

  var startObj2 = new draw2d.diagramImage("../../../../resources/images/Proyectos/finished.png");
  startObj2.id='2'
  workflow.addFigure(startObj2, 100,175);

  var startObj3 = new draw2d.diagramImage("../../../../resources/images/Proyectos/finished.png");
  workflow.addFigure(startObj3, 100,325);

  var startObj4 = new draw2d.diagramImage("../../../../resources/images/Proyectos/working.png");
  startObj4.id='4'
  workflow.addFigure(startObj4, 375,69);

  var c = new draw2d.Connection();
  c.setSource(startObj1.getPort("output4"));
  c.setTarget(startObj4.getPort("input3"));
  c.setTargetDecorator(new draw2d.ArrowConnectionDecorator());
  workflow.addFigure(c);

  var c = new draw2d.Connection();
  c.setSource(startObj2.getPort("output4"));
  c.setTarget(startObj4.getPort("input2"));
  c.setTargetDecorator(new draw2d.ArrowConnectionDecorator());
  workflow.addFigure(c);

  var c = new draw2d.Connection();
  c.setSource(startObj3.getPort("output4"));
  c.setTarget(startObj4.getPort("input2"));
  c.setTargetDecorator(new draw2d.ArrowConnectionDecorator());
  workflow.addFigure(c);

  var startObj5 = new draw2d.diagramImage("../../../../resources/images/Proyectos/empty.png");
  workflow.addFigure(startObj5, 319,222);

  
  
	workflow.scrollArea = document.getElementById("center1").parentNode;
	//               var dragsource=new Ext.dd.DragSource("dragMe", {ddGroup:'TreeDD',dragData:{name: "Start"}}); 
	//               var dragsource=new Ext.dd.DragSource("dragMe2", {ddGroup:'TreeDD',dragData:{name: "End"}}); 
    var dragsource=new Ext.dd.DragSource("empty", {ddGroup:'TreeDD',dragData:{src:'../../../../resources/images/Proyectos/empty.png'}}); 
    var dragsource=new Ext.dd.DragSource("working", {ddGroup:'TreeDD',dragData:{src:'../../../../resources/images/Proyectos/working.png'}}); 
    var dragsource=new Ext.dd.DragSource("finished", {ddGroup:'TreeDD',dragData:{src:'../../../../resources/images/Proyectos/finished.png'}}); 
    var droptarget=new Ext.dd.DropTarget("center1",{ddGroup:'TreeDD'});
    droptarget.notifyDrop=function(dd, e, data)
    {
		if(data.src)
		{
		   var xOffset    = workflow.getAbsoluteX();
		   var yOffset    = workflow.getAbsoluteY();
		   var scrollLeft = workflow.getScrollLeft();
		   var scrollTop  = workflow.getScrollTop();

		   workflow.addFigure(new draw2d.diagramImage(data.src),e.xy[0]-xOffset+scrollLeft,e.xy[1]-yOffset+scrollTop);
		   return true;
		}
    }
});