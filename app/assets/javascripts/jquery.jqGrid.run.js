 $(document).ready(function(){
  	
  	var ddlAccessionSrch_Var = $("#DdlAccessionIdSrch").multiselect({
        							noneSelectedText: "Select Accession"
     							});
  	var ddlStatusSrch_Var = $("#DdlStatusSrch").multiselect({
        						noneSelectedText: "Select Status"
     						});
    //===Initializing Grid first time===
    createOrUpdateRadExamGrid();
    //===End of Initializing Grid first time===
            
  	//========Search functionality=================
  	$("#BtnFilter").click(function(){
		createOrUpdateRadExamGrid ();  		
  	});
  	//=====End Search functionality==============

  	
  	function makeIdAsLinkFormatter( cellvalue, option, rowobj ){
  		return '<a class="" id="lnk$#'+ cellvalue +'" onclick="showExamDetail(this.id)">' + cellvalue + '</a>';
  	}
  	
  	function parseStatusOfExamFormatter(cellvalue, option, rowobj) {         
            var cellvalue_array = cellvalue.split(',');
            //(cellvalue_array[0].split('->')[1] != "") ? cellvalue_array[0].split('->')[1] : cellvalue_array[1].split('->')[1];
            var firstStageTitle = cellvalue_array[0].split('->')[1]; //Order Stage
            var secondStageTitle = cellvalue_array[1].split('->')[1]; //Scheduled stage
            var thirdStageTitle = (cellvalue_array[3].split('->')[1] != "") ? cellvalue_array[3].split('->')[1] : cellvalue_array[4].split('->')[1]; //arrived stage
            var fourthStageTitle = cellvalue_array[5].split('->')[1]; //begin stage
            var fifthStageTitle = cellvalue_array[6].split('->')[1]; //complete or prelim stage
            var sixthStageTitle = cellvalue_array[7].split('->')[1]; //final stage
            
                firstStageTitle = Datetime_tag_change(firstStageTitle);
                secondStageTitle = Datetime_tag_change(secondStageTitle);
                thirdStageTitle = Datetime_tag_change(thirdStageTitle);
                fourthStageTitle = Datetime_tag_change(fourthStageTitle);
                fifthStageTitle = Datetime_tag_change(fifthStageTitle);
                sixthStageTitle = Datetime_tag_change(sixthStageTitle);
                
		if(cellvalue_array[cellvalue_array.length -1] == "order"){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="grey" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="grey" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="grey" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a title="'+ sixthStageTitle +'"><span class="badge"></span></a></div>';
		}
		else if(cellvalue_array[cellvalue_array.length -1]=="scheduled"){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="grey" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="grey" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a title="'+ sixthStageTitle +'"><span class="badge"></span></a></div>';
		}
		else if(cellvalue_array[cellvalue_array.length -1] == "arrived"){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="grey" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a title="'+ sixthStageTitle +'"><span class="badge"></span></a></div>';
		}
		else if(cellvalue_array[cellvalue_array.length -1] == "begin"){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="violet" title="'+ fourthStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a title="'+ sixthStageTitle +'"><span class="badge"></span></a></div>';
		}
		else if(cellvalue_array[cellvalue_array.length-1] == "complete"){

			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="violet" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="darkorange" title="'+ fifthStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge badge-inverse"></span></a><a title="'+ sixthStageTitle +'"><span class="badge"></span></a></div>';
		}
                else if ( (cellvalue_array[cellvalue_array.length-1]=="dictated") || (cellvalue_array[cellvalue_array.length-1]=="prelim") || (cellvalue_array[cellvalue_array.length-1]=="corrections") ){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="violet" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="darkorange" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a class="gold" title="'+ sixthStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i></a></div>';
		}
		else if ( (cellvalue_array[cellvalue_array.length-1]=="final") || (cellvalue_array[cellvalue_array.length-1]=="addendum") ){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="violet" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="darkorange" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a class="green" title="'+ sixthStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i></a></div>';
		}
		else if(cellvalue_array[cellvalue_array.length-1]=="cancelled"){
			
			var cancelledAtStageClass = "sixthStageClass";
                        if(sixthStageTitle == ""){
                          cancelledAtStageClass = "fifthStageClass";
                          if(fifthStageTitle == ""){
                             cancelledAtStageClass = "fourthStageClass";
                             if(fourthStageTitle == ""){
                                cancelledAtStageClass = "thirdStageClass";
                                if(thirdStageTitle == ""){
                                  cancelledAtStageClass = "secondStageClass";
                                  if(secondStageTitle == ""){                                    
                                    cancelledAtStageClass = "firstStageClass";
                                  }
                                }
                             }
                          }
                        }
                        /*
			if(sixthStageTitle == ""){
				if(fifthStageTitle == ""){
					if(fourthStageTitle == ""){
						if(thirdStageTitle == ""){
							if(secondStageTitle == ""){
								cancelledAtStageClass = "firstStageClass";
							}
							else{
								cancelledAtStageClass = "secondStageClass";
							}
						}
						else{
							cancelledAtStageClass = "thirdStageClass";
						}
					}
					else{
						cancelledAtStageClass = "fourthStageClass";
					}
				}
				else{                                      
					cancelledAtStageClass = "fifthStageClass";                                       
				}
			}
			else{
				cancelledAtStageClass = "sixthStageClass";
			}
                        */
			//GraphUI to be displayed when cancelled status comes.
			var graphStatusUI = $('<div class="wizard"><a class="firstStageClass current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="secondStageClass softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="thirdStageClass vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="fourthStageClass violet" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="fifthStageClass darkorange" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a class="sixthStageClass green" title="'+ sixthStageTitle +'"></a></div>');
			var cancelledStageIndex = $(graphStatusUI).find('a.'+ cancelledAtStageClass +'').index();
			//$(graphStatusUI).find('a:lt('+cancelledStageIndex+')').addClass("current");
			$(graphStatusUI).find('a:eq('+cancelledStageIndex+')').removeClass();
                        $(graphStatusUI).find('a:eq('+cancelledStageIndex+')').addClass("red").append('<i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i>');
                        $(graphStatusUI).find('a:gt('+cancelledStageIndex+')').removeClass();		
                        $(graphStatusUI).find('a:gt('+cancelledStageIndex+')').addClass("grey");			
			 return $(graphStatusUI).prop('outerHTML');
		}
		else{
			return 'Can not parse "' + cellvalue + '" status';
		}
	  }
  	
  	function createOrUpdateRadExamGrid () {
  	$('#radExamGridContainer').html('').append('<table id="tblRadExam" class="scroll"></table> <div id="tblRadExamPager" class="scroll text-center"></div>');
        $("#tblRadExam").jqGrid({
            datatype: "json",
            url: '/home/get_jqgrid/',
            mtype: 'POST',
			postData: {
                accession: $("#DdlAccessionIdSrch").val(),
                status: $("#DdlStatusSrch").val(),
                role: window._role,
                authenticity_token: window._token
            },
            colNames: ['A#','Progress Status','Current Status','Status Last Changed','Patient Name','Patient MRN','Patient DOB','Appt Time','Begin Exam','End Exam','SignIn','CheckIn','Site','Patient Class','Patient Type','Patient Location at exam','Radiology Department','Exam Resource','Modality','Proc Code','Proc Description','Ordering Provider','Scheduler','Technologist','PACS Image Count'],
            colModel: [
                { name: 'accession', index: 'accession', align: 'center', width:40, fixed:true, formatter: makeIdAsLinkFormatter }
				,{ name: 'graph_status', index: 'graph_status', align: 'center', width:325, fixed:true, formatter: parseStatusOfExamFormatter }
				,{ name: 'current_status', index: 'current_status', align: 'center', width:100, fixed:true }
				,{ name: 'updated_at', index: 'updated_at', align: 'center', width:150, fixed:true , formatter:format_date_time }
				,{ name: 'patient_name', index: 'patient_name', align: 'center', width:140, fixed:true }
                                ,{ name: 'mrn', index: 'mrn', align: 'center', width:120, fixed:true }
				,{ name: 'birthdate', index: 'birthdate', align: 'center', width:140, fixed:true }
                                ,{ name: 'appt_time', index: 'appt_time', align: 'center', width:150, fixed:true, formatter:format_date_time }
				,{ name: 'begin_exam', index: 'begin_exam', align: 'center', width:150, fixed:true, formatter: TimeFromDateTime }
				,{ name: 'end_exam', index: 'end_exam', align: 'center', width:150, fixed:true , formatter: TimeFromDateTime}
				,{ name: 'sign_in', index: 'sign_in', align: 'center', width:150, fixed:true , formatter: TimeFromDateTime}
                                ,{ name: 'check_in', index: 'check_in', align: 'center', width:140, fixed:true , formatter: TimeFromDateTime}
				,{ name: 'site_name', index: 'site_name', align: 'center', width:80, fixed:true }
				,{ name: 'patient_class', index: 'patient_class', align: 'center', width:80, fixed:true }
				,{ name: 'patient_type', index: 'patient_type', align: 'center', width:80, fixed:true }
				,{ name: 'patient_location_at_exam', index: 'patient_location_at_exam', align: 'center', width:150, fixed:true }
				,{ name: 'radiology_department', index: 'radiology_department', align: 'center', width:150, fixed:true }
				,{ name: 'resource_name', index: 'resource_name', align: 'center', width:130, fixed:true }
				,{ name: 'modality', index: 'modality', align: 'center', width:80, fixed:true }			
                ,{ name: 'code', index: 'code', align: 'center', width:80, fixed:true }
                ,{ name: 'description', index: 'description', align: 'center', width:150, fixed:true }	
				,{ name: 'ordering_provider', index: 'ordering_provider', align: 'center', width:150, fixed:true }
				,{ name: 'scheduler', index: 'scheduler', align: 'center', width:80, fixed:true }
				,{ name: 'technologist', index: 'technologist', align: 'center', width:80, fixed:true }
                ,{ name: 'pacs_image_count', index: 'pacs_image_count', align: 'center', width:140, fixed:true }
                    
                
            ],
            //jsonReader: { repeatitems:false, root:"rows" },
            //jsonReader: { repeatitems: false, id: "id", root: "rows", page: "page", total: "total",
    //records: "records"
			//},
            jsonReader: { repeatitems: false, id: "id", root: function (obj) { return obj.rows; }, page: function (obj) { return obj.page; }, total: function (obj) { return obj.total; },
    records: function (obj) { return (obj.records ); }
			},
			beforeSelectRow: function() { return false; },
            multiselect: false,
            autowidth: true,
            //width:'90%',
            scrollOffset: 0,
            rowNum: 5,
            rowList: [5, 10, 15, 20],
            height: '250',
            sortname: 'Id',
            sortorder: "asc",
            viewrecords: true,
            ignoreCase: true,
            pager: '#tblRadExamPager',
            caption: "Exam Details",
            rownumbers: true,
            loadonce:true,
			recordtext:"View {0}-{1} of {2}",
			onPaging:function(which_button){
				$("#tblRadExam").setGridParam({datatype:'json'});
			},
            loadComplete: function (data) {
								
				$("#tblRadExam").setGridParam({datatype:'local'});
				
                var datacount = $("#tblRadExam").getGridParam("reccount");
                if (datacount == 0) {
                    $('.ui-jqgrid-bdiv').removeClass('JqgridAutoHeight'); 
                    $('#tblRadExam').jqGrid('setGridHeight','250'); 
                }
                if (datacount > 0) {   /*grid heigth */
					$('#tblRadExam').jqGrid('setGridHeight','auto');
                    //$('.ui-jqgrid-bdiv').addClass('JqgridAutoHeight');
                }
                
                //****Binding data to AccessionId dropdown****//
                $("#DdlAccessionIdSrch").empty();
                 var uniqueACC = []; 
                $.each(data.rows,function(index, value){
                  if (uniqueACC.indexOf(value.accession) === -1){
                    $("#DdlAccessionIdSrch").append($('<option>', { value: value.accession, text: value.accession }));
                    uniqueACC.push(value.accession);
                  }
                	
                });
                ddlAccessionSrch_Var.multiselect('refresh');
                //****End Binding data to AccessionId dropdown****//
				
				//****Binding data to Status dropdown****//
                $("#DdlStatusSrch").empty();               
                var uniqueStatuses = []; 
                $.each(data.rows,function(index, value){
                      
                        if(uniqueStatuses.indexOf(value.current_status) === -1){
                          $("#DdlStatusSrch").append($('<option>', { value: value.current_status, text: value.current_status }));
                          uniqueStatuses.push(value.current_status);
                        }               	
                });
                ddlStatusSrch_Var.multiselect('refresh');
                //****End Binding data to Status dropdown****//
            },
        }).hideCol([ ]).navGrid('#tblRadExamPager', {
            edit: false, add: false, del: false, search: true, refresh: true, beforeRefresh: function () {
                //$("#tblUsersGrid").setGridParam({ postData: { pageXL: '_pageXL' } });
                //$('#pg_UsersGridPager table:eq(1) tr td.nRCls').remove();
            }, afterRefresh: function () {
                //$('#SearchGridPager table:eq(1) tr td.nRCls').remove();
            }
        },
       {}, {}, {}, {
           width: 500, onSearch: function () {
               //$('#pg_UsersGridPager table:eq(1) tr td.nRCls').remove();
               //if ($('#pg_UsersGridPager table:eq(1) tr td.nRCls').length == 0 && $('#fbox_tblUsersGrid').find(':input').eq(2).val() != "") {
                   //$('#pg_UsersGridPager table:eq(1) tr').append('<td class="nRCls"><span class="fntSiz11">Filtered Results Shown. Click on Refresh Data to clear filter.</span></td>');
               //}
               //if ($('#fbox_tblUsersGrid').find(':input').eq(2).val() != "") {
                   //$('.ui-jqdialog-titlebar-close:eq(0)').click();
               //}
           },
           onReset: function () {
               //$('#pg_UsersGridPager table:eq(1) tr td.nRCls').remove();
           }, sopt: ['cn', 'nc']
       });
	   
	   $('.ui-icon-refresh').click(function () {
			$("#tblRadExam").setGridParam({ datatype: 'json', page: 1,postData:{accession:"",status:"",authenticity_token: window._token}}).trigger('reloadGrid');
	   });
	}     

	$('#tblRadExamPager .ui-icon-refresh').click(function () {
		$("#tblRadExam").setGridParam({ datatype: 'json', page: 1,postData:{accession:"",status:"",authenticity_token: window._token} }).trigger('reloadGrid');
    });
            
            
  }); 