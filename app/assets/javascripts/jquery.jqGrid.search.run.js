$(document).ready(function () {


        //========Search functionality=================
        $("#btnSearchExam").click(function (e) {
            e.preventDefault();
            
             if (!(
                           ($("#txtVisitId").val() != null && $("#txtVisitId").val() != "")
                        || ($("#txtOrderId").val() != null && $("#txtOrderId").val() != "")
                        || ($("#txtAccId").val() != null && $("#txtAccId").val() != "")
                        || ($("#txtAccId").val() != null && $("#txtAccId").val() != "")
                        || ($("#ddlPatientType").val() != null && $("#ddlPatientType").val() != "")
                        || ($("#txtPatientName").val() != null && $("#txtPatientName").val() != "")
                        || ($("#txtPatientMRN").val() != null && $("#txtPatientMRN").val() != "")
                        || ($("#txtRadExamDept").val() != null && $("#txtRadExamDept").val() != "")
                        || ($("#txtResource").val() != null && $("#txtResource").val() != "")
                        || ($("#txtModality").val() != null && $("#txtModality").val() != "")
                        || ($("#txtProcedure").val() != null && $("#txtProcedure").val() != "")
                        || ($("#txtCurrentPatientLocation").val() != null && $("#txtCurrentPatientLocation").val() != "")
                        || ($("#txtCurrentExamStatus").val() != null && $("#txtCurrentExamStatus").val() != "")
                        || ($("#txtSite").val() != null && $("#txtSite").val() != "")
                        || ($("#chkMyOrder").parent().hasClass('checked') == true)
                        || ($("#chkMyExams").parent().hasClass('checked') == true)
                        || ($("#chkMyReports").parent().hasClass('checked') == true)
                    ))
              {
                  alert("Please select or enter atleast one criteria to search.");
                  return false;
                }

            var searchCriteriaJSON = {
                "visit": $("#txtVisitId").val(),
                "order_id": $("#txtOrderId").val(),
                "accession": $("#txtAccId").val(),
                "patient_type": $("#ddlPatientType").val(),
                "patient_name": $("#txtPatientName").val(),
                "mrn": $("#txtPatientMRN").val(),
                "rad_exam_dept": $("#txtRadExamDept").val(),
                "resource_name": $("#txtResource").val(),
                "modality": $("#txtModality").val(),
                "code": $("#txtProcedure").val(),
                "patient_location_at_exam": $("#txtCurrentPatientLocation").val(),
                "current_status": $("#txtCurrentExamStatus").val(),
                "site_name": $("#txtSite").val(),
                "my_orders": ($("#chkMyOrder").parent().hasClass('checked') == true? "on":""),
                "my_exams": ($("#chkMyExams").parent().hasClass('checked') == true? "on":""),
                "my_reports":($("#chkMyReports").parent().hasClass('checked') == true? "on":""),
                "search_individual_buckets":$("#search_individual_buckets").val()
            };

            $("#SearchCriteriaContainerDiv").slideUp('slow');
            $("#RowForSearchCriteria").hide();
            $("#RowForGridDiv").show();
            $('#SearchExamGridContainerDiv').html('').append('<table id="tblSearchExam" class="scroll"></table> <div id="searchExamGridPagerDiv" class="scroll text-center"></div>');
            $("#tblSearchExam").jqGrid({
                datatype: "json",
                url: '/home/get_jqgridSearch_exam_data/',
                mtype: 'POST',
                postData: {
                    allSearchCriteriaInJson: searchCriteriaJSON,
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
                jsonReader: {repeatitems: false, id: "id", root: function (obj) {
              return obj.rows;
            }, page: function (obj) {
              return obj.page;
            }, total: function (obj) {
              return obj.total;
            },
                    records: function (obj) {
              return (obj.records);
            }
                },
                beforeSelectRow: function () {
            return false;
          },
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
                pager: '#searchExamGridPagerDiv',
                caption: "Exam Details",
                rownumbers: true,
                emptyrecords: 'No Records found matching this group or filter criteria.',
               // loadonce: false, // true,
               onPaging: function (which_button) {         
                $("#tblSearchExam").setGridParam({datatype: 'json'});
            },
            loadComplete: function (data) {
               
                //$("#tblRadExam").setGridParam({loadonce:true});
                var $this = $(this);
                if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
                    // because one use repeatitems: false option and uses no
                    // jsonmap in the colModel the setting of data parameter
                    // is very easy. We can set data parameter to data.rows:
                    $this.jqGrid('setGridParam', {
                        datatype: 'local',
                        data: data.rows,
                        pageServer: data.page,
                        recordsServer: data.records,
                        lastpageServer: data.total
                    });

                    // because we changed the value of the data parameter
                    // we need update internal _index parameter:
                    this.refreshIndex();

                    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
                        // we need reload grid only if we use sortname parameter,
                        // but the server return unsorted data
                        $this.triggerHandler('reloadGrid');
                    }
                } else {
                    $this.jqGrid('setGridParam', {
                        page: $this.jqGrid('getGridParam', 'pageServer'),
                        records: $this.jqGrid('getGridParam', 'recordsServer'),
                        lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
                    });
                    this.updatepager(false, true);
                }



                    var datacount = $("#tblSearchExam").getGridParam("reccount");
                    if (datacount == 0) {
                        $('.ui-jqgrid-bdiv').removeClass('JqgridAutoHeight');
                        $('#tblSearchExam').jqGrid('setGridHeight', '250');
                    }
                    if (datacount > 0) {   /*grid heigth */

                        $('#tblSearchExam').jqGrid('setGridHeight', 'auto');
                        //$('.ui-jqgrid-bdiv').addClass('JqgridAutoHeight');
                    }

                },
            }).hideCol([]).navGrid('#searchExamGridPagerDiv', {
                edit: false, add: false, del: false, search: true, refresh: true, beforeRefresh: function () {
                    //$("#tblUsersGrid").setGridParam({ postData: { pageXL: '_pageXL' } });
                    //$('#searchExamGridPagerDiv table:eq(1) tr td.nRCls').remove();
                }, afterRefresh: function () {
                    //$('#SearchGridPager table:eq(1) tr td.nRCls').remove();
                }
            },
            {}, {}, {}, {
                width: 500, onSearch: function () {
                    //$('#searchExamGridPagerDiv table:eq(1) tr td.nRCls').remove();
                    //if ($('#searchExamGridPagerDiv table:eq(1) tr td.nRCls').length == 0 && $('#fbox_tblUsersGrid').find(':input').eq(2).val() != "") {
                    //$('#searchExamGridPagerDiv table:eq(1) tr').append('<td class="nRCls"><span class="fntSiz11">Filtered Results Shown. Click on Refresh Data to clear filter.</span></td>');
                    //}
                    //if ($('#fbox_tblUsersGrid').find(':input').eq(2).val() != "") {
                    //$('.ui-jqdialog-titlebar-close:eq(0)').click();
                    //}
                },
                onReset: function () {
                    //$('#searchExamGridPagerDiv table:eq(1) tr td.nRCls').remove();
                }, sopt: ['cn', 'nc']
            });
       
		$('.ui-icon-refresh').click(function () {
			$("#tblTechExam").setGridParam({ datatype: 'json', page: 1,postData:{accession:"",status:"",authenticity_token: window._token}}).trigger('reloadGrid');
	   });
	   
        });
        //========== #btnSearchExam functionality==============

        $("#btnShowSearchCriteria").click(function () {
            $("#RowForSearchCriteria").show();
            $("#SearchCriteriaContainerDiv").slideDown('slow');
            $("#RowForGridDiv").hide();
        });
          //========== #btnSearchReset functionality==============
         $("#btnSearchReset").click(function () {
            $("#chkMyOrder").parent().removeClass('checked') ;
            $("#chkMyExams").parent().removeClass('checked') ;
            $("#chkMyReports").parent().removeClass('checked') ;
        });


        function makeIdAsLinkFormatter(cellvalue, option, rowobj) {

            if (cellvalue != undefined && cellvalue != null) {
                return '<a class="" id="lnk$#' + cellvalue + '" onclick="showExamDetail(this.id)">' + cellvalue + '</a>';
            }
            else {
                return '';
            }
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
            
                firstStageTitle = "Ordered: " + Datetime_tag_change(firstStageTitle);
                secondStageTitle = "Scheduled: " + Datetime_tag_change(secondStageTitle);
                thirdStageTitle = "Arrived: " + Datetime_tag_change(thirdStageTitle);
                fourthStageTitle = "Begin: " + Datetime_tag_change(fourthStageTitle);
                fifthStageTitle = "Complete: " + Datetime_tag_change(fifthStageTitle);
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
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="violet" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="darkorange" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a class="gold" title="' + cellvalue_array[cellvalue_array.length - 1] + ": " + sixthStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i></a></div>';
		}
		else if ( (cellvalue_array[cellvalue_array.length-1]=="final") || (cellvalue_array[cellvalue_array.length-1]=="addendum") ){
			return '<div class="wizard"><a class="current" title="'+ firstStageTitle +'"><span class="badge"></span></a><a class="softcyanlimegreen" title="'+ secondStageTitle +'"><span class="badge"></span></a><a class="vanilla" title="'+ thirdStageTitle +'"><span class="badge"></span></a><a class="violet" title="'+ fourthStageTitle +'"><span class="badge"></span></a><a class="darkorange" title="'+ fifthStageTitle +'"><span class="badge badge-inverse"></span></a><a class="green" title="' + cellvalue_array[cellvalue_array.length - 1] + ": " + sixthStageTitle +'"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i></a></div>';
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


    });
  // =======End of documnet.ready()
   $(document).ready(function () {

        $("#example1 tr td:first-child a").click(function (e) {

            e.preventDefault();
            $("#ExamDetailPopupDiv").modal('show');
        });

    });