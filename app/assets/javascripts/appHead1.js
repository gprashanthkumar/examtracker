//kumar 

 function showExamDetail(id) {

          $("#divstatus").html('<div class=wizard"><a class="grey"><span class="badge"></span></a><a class="grey"><span class="badge"></span></a><a class="grey"><span class="badge"></span></a><a class="grey"><span class="badge"></span></a><a class="grey"><span class="badge badge-inverse"></span></a><a class="grey"><span class="badge"></span></a></div>')
          $("#ExamDetailPopupDiv").modal('show');
          $("#resultLoadingview").modal('show');

          //debugger;
          id = id.replace("lnk$#", "");
          var myobj;
          $.ajax({
              url: '/home/get_accession',
              type: 'POST',
              dataType: 'json',
              //contentType: "application/json; charset=utf-8",
              data: {
                  accession_id: id,
                  authenticity_token: window._token
              },
              success: function (resultExamDetail) {
                  $("#resultLoadingview").modal('hide');

                  try {
                      mydata = JSON.stringify(resultExamDetail);
                      // alert(mydata);
                      myobj = JSON.parse(mydata);

                      // start processing data from here into a function if possible
                      $.ajax({
                          url: '/home/get_accession_report',
                          type: 'POST',
                          dataType: 'json',
                          //contentType: "application/json; charset=utf-8",
                          data: {
                              accession_id: id,
                              authenticity_token: window._token
                          },
                          success: function (resultReportHistories) {

                              $("#reportHistoryContainerDiv").empty();
                              $(resultReportHistories).each(function (index, resultReportHistory) {
                                  if ((resultReportHistory.status != null) && (resultReportHistory.status != '')) {
                                      $("#reportHistoryContainerDiv").append('<div> <h3>' + resultReportHistory.report_impression + '</h3> <b>status:</b>' + resultReportHistory.status + '<br> <b>Time:</b>' + format_date_time(resultReportHistory.report_time) + '<br> <b>Radiologist:</b>' + resultReportHistory.rad1_name + '<br> <b>Radiologist:</b>' + resultReportHistory.rad2_name + '<br> </br></br></br> <p>' + resultReportHistory.report_body + '</p> </div>');
                                  }
                              });
                              if ($("#reportHistoryContainerDiv").text() == "") {
                                  $("#reportHistoryContainerDiv").append('<div> <h4 style="color:red" >No Report found.</h4></div>');
                              }

                              $("#currentStatusH3").text(myobj.current_status);
                          },
                          error: function (resultReportHistories) {
                              debugger;
                          }
                      });

                      //exam information

                      $("#lblProcedure").text(myobj.description + "(" + myobj.code + ")");
                      $("#lblpatient_class").text(NullEmpty(myobj.patient_type) + "-" + NullEmpty(myobj.patient_class));
                      $("#lbltrauma").text(NullEmpty(myobj.trauma));
                      $("#lblmodality").text(NullEmpty(myobj.modality));
                      $("#lblresource").text(NullEmpty(myobj.resource_name));

                      //staff parts
                      $("#lbltechnologist").text(NullEmpty(myobj.technologist));

                      if ((myobj.rad1_name != null) && (myobj.rad1_name != '')) {
                          $("#lblRadiologist").text("Signed by: " + myobj.rad1_name);
                          $("#lblfinalRadiologist").text(myobj.rad1_name);
                      }

                      $("#lblfinalRadiologist").text(NullEmpty(myobj.rad2_name));

                      //time parts
                      $("#lblorder").text(format_date_time(myobj.order_arrival));
                      $("#lblappt_time").text(format_date_time(myobj.appt_time));
                      $("#lblsign_in").text(TimeFromDateTime(myobj.sign_in));
                      $("#lblbegin_exam").text(TimeFromDateTime(myobj.begin_exam));
                      $("#lblend_exam").text(TimeFromDateTime(myobj.end_exam));
                      $("#lblfirst_final").text(TimeFromDateTime(myobj.first_final));
                      $("#lbllast_final").text(TimeFromDateTime(myobj.last_final));
                      var btime = null;
                      var etime = null;
                      var aptime = null;
                      var scheventime = null;  
                      $("#lbleduration").text("");
                      $("#lblwaitduration").text("");
                      $("#lblscheEventToappt").text("");
                      $("#lbltotalpatientwait").text("");
                      $("#lblfinalTurnaroundTime").text("");
                      
                       if ((myobj.order_arrival != null) && (myobj.order_arrival != ""))
                       {
                         scheventime = new Date(myobj.order_arrival);                         
                       }
                       if ((myobj.appt_time != null) && (myobj.appt_time != ""))
                       {
                            aptime = new Date(myobj.appt_time);                         
                       }
                       
                       if ((myobj.begin_exam != null) && (myobj.begin_exam != ""))
                       {
                               btime = new Date(myobj.begin_exam);                         
                       }
                       
                      if ((myobj.end_exam != null) && (myobj.end_exam != ""))
                      {
                        etime = new Date(myobj.end_exam);
                      }


                      if ((etime != null) && (btime != null)) {
                         var eduration = new Date(etime - btime);
                          if (eduration != null) {
                              $("#lbleduration").text(eduration.toISOString().substr(11, 8));
                          }
                      }
                      
                        if ((aptime != null) && (btime != null)) {
                           var waitduarion = new Date(btime - aptime);
                           if (waitduarion != null) {
                               $("#lblwaitduration").text(waitduarion.toISOString().substr(11, 8));
                          }
                        }

                      if ((aptime != null) && (scheventime != null)) {
                           var sched_to_aptime = new Date(aptime - scheventime);
                           if (sched_to_aptime != null) {
                               $("#lblscheEventToappt").text(DaysTimeWait(sched_to_aptime.toISOString()));
                          }
                        }
                        
                         if ((etime != null) && (scheventime != null)) {
                           var finalTurnaroundTime = new Date(etime - scheventime);
                           if (finalTurnaroundTime != null) {
                               $("#lblfinalTurnaroundTime").text(DaysTimeWait(finalTurnaroundTime.toISOString()));
                          }
                        }
                      if ((btime != null) && (scheventime != null)) {
                              var totalpatientwait = new Date(btime - scheventime);
                           if (totalpatientwait != null) {
                                  $("#lbltotalpatientwait").text(DaysTimeWait(totalpatientwait.toISOString()));
                          }
                        }   

                      //indentifiers
                      $("#lblaccession").text(myobj.accession);
                      $("#lblmrn").text(NullEmpty(myobj.mrn));

                      var statusdiv = parseExamStatusGraph(myobj.graph_status);
                      $("#divstatus").html(statusdiv);

                      //$("#ExamDetailPopupDiv").modal('show');

                  }
                  catch (err) {
                      alert(err.message);
                  }

              },
              error: function (data) {
                  debugger;
              }
          });

      }
	  
	  
 function parseExamStatusGraph(cellvalue) {
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

          if (cellvalue_array[cellvalue_array.length - 1] == "order") {
              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="grey" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="grey" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="grey" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a title="' + sixthStageTitle + '"><span class="badge"></span></a></div>';
          }
          else if (cellvalue_array[cellvalue_array.length - 1] == "scheduled") {
              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="softcyanlimegreen" title="' + secondStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="grey" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="grey" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a title="' + sixthStageTitle + '"><span class="badge"></span></a></div>';
          }
          else if (cellvalue_array[cellvalue_array.length - 1] == "arrived") {
              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="softcyanlimegreen" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="vanilla" title="' + thirdStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="grey" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a title="' + sixthStageTitle + '"><span class="badge"></span></a></div>';
          }
          else if (cellvalue_array[cellvalue_array.length - 1] == "begin") {
              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="softcyanlimegreen" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="vanilla" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="violet" title="' + fourthStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge"></span></a><a class="grey" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a title="' + sixthStageTitle + '"><span class="badge"></span></a></div>';
          }
          else if (cellvalue_array[cellvalue_array.length - 1] == "complete") {

              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="softcyanlimegreen" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="vanilla" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="violet" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="darkorange" title="' + fifthStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i><span class="badge badge-inverse"></span></a><a title="' + sixthStageTitle + '"><span class="badge"></span></a></div>';
          }
          else if ((cellvalue_array[cellvalue_array.length - 1] == "dictated") || (cellvalue_array[cellvalue_array.length - 1] == "prelim") || (cellvalue_array[cellvalue_array.length - 1] == "corrections")) {
              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="softcyanlimegreen" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="vanilla" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="violet" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="darkorange" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a class="gold" title="' + sixthStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i></a></div>';
          }
          else if ((cellvalue_array[cellvalue_array.length - 1] == "final") || (cellvalue_array[cellvalue_array.length - 1] == "addendum")) {
              return '<div class="wizard"><a class="current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="softcyanlimegreen" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="vanilla" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="violet" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="darkorange" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a class="green" title="' + sixthStageTitle + '"><i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i></a></div>';
          }
          else if (cellvalue_array[cellvalue_array.length - 1] == "cancelled") {

              var cancelledAtStageClass = "sixthStageClass";
              if (sixthStageTitle == "") {
                  cancelledAtStageClass = "fifthStageClass";
                  if (fifthStageTitle == "") {
                      cancelledAtStageClass = "fourthStageClass";
                      if (fourthStageTitle == "") {
                          cancelledAtStageClass = "thirdStageClass";
                          if (thirdStageTitle == "") {
                              cancelledAtStageClass = "secondStageClass";
                              if (secondStageTitle == "") {
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
              var graphStatusUI = $('<div class="wizard"><a class="firstStageClass current" title="' + firstStageTitle + '"><span class="badge"></span></a><a class="secondStageClass softcyanlimegreen" title="' + secondStageTitle + '"><span class="badge"></span></a><a class="thirdStageClass vanilla" title="' + thirdStageTitle + '"><span class="badge"></span></a><a class="fourthStageClass violet" title="' + fourthStageTitle + '"><span class="badge"></span></a><a class="fifthStageClass darkorange" title="' + fifthStageTitle + '"><span class="badge badge-inverse"></span></a><a class="sixthStageClass green" title="' + sixthStageTitle + '"></a></div>');
              var cancelledStageIndex = $(graphStatusUI).find('a.' + cancelledAtStageClass + '').index();
              //$(graphStatusUI).find('a:lt('+cancelledStageIndex+')').addClass("current");
              $(graphStatusUI).find('a:eq(' + cancelledStageIndex + ')').removeClass();
              $(graphStatusUI).find('a:eq(' + cancelledStageIndex + ')').addClass("red").append('<i class="fa fa-check" style="display: table-cell; float: right; margin: 8px;"></i>');
              $(graphStatusUI).find('a:gt(' + cancelledStageIndex + ')').removeClass();
              $(graphStatusUI).find('a:gt(' + cancelledStageIndex + ')').addClass("grey");
              return $(graphStatusUI).prop('outerHTML');
          }
          else {
              return 'Can not parse "' + cellvalue + '" status';
          }
      }

      function TimeFromDateTime(mydate)
      {
          var datetext = '';
          if ((mydate == null) || (mydate == '')) {
              return datetext;
          }
          d = new Date(mydate);
          if (d != null) {
              datetext = d.toTimeString();
              datetext = datetext.split(' ')[0];
          }
          return datetext;
      }
      function DaysTimeWait(mydate) {
          var datetext = '';
          if ((mydate == null) || (mydate == '')) {
              return datetext;
          }
          try {


              d = new Date(mydate);
              if (d != null) {
                  datetext = pad2(d.getDate()) + "d "
                  datetext += pad2(d.getHours()) + ":"
                  datetext += pad2(d.getMinutes()) + ":"
                  datetext += pad2(d.getSeconds());
              }

          }
          catch (err) {
              console.log(err.message + "[" + mydate + "]");
          }
          return datetext;
      }
      function pad2(n) {
          return n < 10 ? '0' + n : n;
      }

      function format_date_time(mydate) {

          var datetext = '';
          if ((mydate == null) || (mydate == '')) {
              return datetext;
          }
          try {


              d = new Date(mydate);

              //console.info( '[' + mydate + '] + [' + d + ']')
              if (d != null) {
                  datetext = d.getFullYear() + "-"
                  datetext += pad2(d.getMonth() + 1) + "-"
                  datetext += pad2(d.getDate()) + " "
                  datetext += pad2(d.getHours()) + ":"
                  datetext += pad2(d.getMinutes()) + ":"
                  datetext += pad2(d.getSeconds());
              }
          } catch (err) {
              console.log(err.message + "[" + mydate + "]");
          }

          return datetext;
      }

      function NullEmpty(data)
      {
          if (data != null) {
              return data
          } else {
              return '';
          }

      }


      String.prototype.replaceAll = function (search, replacement)
      {
          var target = this;
          return target.replace(new RegExp(search, 'g'), replacement);
      };

      function Datetime_tag_change(mystring) {

          if ((mystring == null) || (mystring.trim() == ""))
          {
              return "";
          } else {
              //return format_date_time(mystring.replaceAll("-","/"));
              return format_date_time(mystring);
          }

      }