var currentURL = window.location.pathname;
var split_currentURL = currentURL.split('/');
var school = split_currentURL[split_currentURL.length - 1];

var competency_types = null;
var competency_levels = null;
var content_competencies = "";
var session_competencies = "";
var course_competencies = "";
var content_info = null;
var session_info = null;
var course_info = null;
var search_clear_flag = 0;


$(function() {
	$("#domain_dropdown").val(0);
	$("#competency_dropdown").val(0);

	$("#tabs").tabs();

	$.ajax({
			async: false,
			global: false,
			type: "POST",
			url: "/tusk/competency/search/ajaxCompetencyTypes/school/" + school,
			dataType: "json"
	}).success(function(data) {
			competency_types = data;
	});

	$.ajax({
			async: false,
			global: false,
			type: "POST",
			url: "/tusk/competency/search/ajaxCompetencyLevels/school/" + school,
			dataType: "json"
	}).success(function(data) {
			competency_levels = data;
	});

});


function loadTopLevelCompetencies(domain) {
	$.ajax({
			type: "POST",
			url: "/tusk/competency/search/ajaxTopLevelCompetencies",
			data: {competency_id: domain.value},

		}).success(function(data) {
			$("#competency_dropdown").empty();
			var blankCompetency = $('<option value="">' + "-- Select a Competency --" + '</option>');
			$("#competency_dropdown").append(blankCompetency);
			data = $.parseJSON(data);
			$.each(data, function(index, competency_object) {
				var newCompetency = $('<option value="' + competency_object.competency_id + '">' + competency_object.title + '</option>');
				$("#competency_dropdown").append(newCompetency);
			});
			if ($("#competency_dropdown option").length  <= 1) {
				var newCompetency = $('<option value="" disabled>' + "(None Available for current Selection)" + '</option>');
				$("#competency_dropdown").append(newCompetency);
			}
		});
}

function loadLinkedAndChildren(competency_id) {
	search_clear_flag = 0;
	$("#competency_search_results").find("tr:gt(0)").remove();
	$("#school_competency_search_results").find("tr:gt(0)").remove();
	$("#course_competency_search_results").find("tr:gt(0)").remove();
	$("#content_competency_search_results").find("tr:gt(0)").remove();
	$("#session_competency_search_results").find("tr:gt(0)").remove();
	$("#search_loading").show();

	$.ajax({
			type: "POST",
			url: "/tusk/competency/search/ajaxLinkedAndChildren",
			data: {competency_id: competency_id},
			dataType: "json"
		}).success(function(data) {
			$.each(data, function (index, value) {
				var table_row = '<tr>';

				if (competency_types[value.type] == 'category') {
					table_row += '<td><img src="/graphics/competency/folder_16x16.png" /></td>'
				} else if (competency_types[value.type] == 'info') {
					table_row += '<td><img src="/graphics/competency/info_16x16.png" /></td>'
				} else {
					table_row += '<td><img src="/graphics/competency/checkmark_16x16.png" /></td>'
				}
				if (value.level == 'national') {
					table_row += '<td>' + value.title + '</td></tr>';
					$("#competency_search_results tr:last").after(table_row);
				} else if (value.level == 'school') {
					table_row += '<td style="color:#4E8700;">' + value.title + '</td></tr>';
					$("#school_competency_search_results tr:last").after(table_row);
				} else if (value.level == 'course') {
					//needs work (course objectives);
				} else if (value.level == 'content') {
					//needs work (content objectives)
				}	else {
					//needs work (session objectives)
				}
			});
			$("#search_loading").hide();
		});
}

function loadSearchResults() {
	if (search_clear_flag == 1) {
		$("#competency_search_results").find("tr:gt(0)").remove();
		$("#school_competency_search_results").find("tr:gt(0)").remove();
		$("#course_competency_search_results").find("tr:gt(0)").remove();
		$("#content_competency_search_results").find("tr:gt(0)").remove();
		$("#session_competency_search_results").find("tr:gt(0)").remove();
	}

	var search_text = ($("#search_box").val());
	search_text = search_text.replace(/(\r\n|\n|\r)/gm,"");

	$.ajax({
			type: "POST",
			url: "/tusk/competency/search/ajaxSearchResults/school/" + school,
			data: {search_text: search_text},
			dataType: "json"
	}).success(function(data) {
			$.each(data, function (index, value) {
				if (competency_levels[value[1]] == 'content') {
					if (value[0]) {
						content_competencies += ", " + value[0];					
					}
				} else if (competency_levels[value[1]] == 'class_meet') {
					if (value[0]) {
						session_competencies += ", " + value[0];
					}
				} else if (competency_levels[value[1]] == 'course') {
					if (value[0]) {
						course_competencies += ", " + value[0];
					}
				} else {}			
			});
			content_competencies = content_competencies.substr(2, content_competencies.length);
			session_competencies = session_competencies.substr(2, session_competencies.length);
			course_competencies = course_competencies.substr(2, course_competencies.length);

			$("#search_loading").show();
			if (content_competencies) {
				content_competencies = content_competencies.replace(/(^,)|(,$)/g, "");
				$.ajax({
					async: false,
					global: false,
					type: "POST",
					data: {competency_ids: content_competencies},
					url: "/tusk/competency/search/getContent/school/" + school,
					dataType: "json"
				}).success(function(data) {
					content_info = data;
				});
			}
			if (session_competencies) {
				session_competencies = session_competencies.replace(/(^,)|(,$)/g, "");
				$.ajax({
						async: false,
						global: false,
						type: "POST",
						data: {competency_ids: session_competencies},
						url: "/tusk/competency/search/getSession/school/" + school,
						dataType: "json"
					}).success(function(data) {
						session_info = data;
					});
			}
			if (course_competencies) {
				course_competencies = course_competencies.replace(/(^,)|(,$)/g, "");
				$.ajax({
						async: false,
						global: false,
						type: "POST",
						data: {competency_ids: course_competencies},
						url: "/tusk/competency/search/getCourse/school/" + school,
						dataType: "json"
					}).success(function(data) {
						course_info = data;
					});
			}

			$.each(data, function (index, value) {
				var table_row = '<tr>';
				if (competency_types[value[2]] == 'category') {
					table_row += '<td><img src="/graphics/competency/folder_16x16.png" /></td>'
				} else if (competency_types[value[2]] == 'info') {
					table_row += '<td><img src="/graphics/competency/info_16x16.png" /></td>'
				} else {
					table_row += '<td><img src="/graphics/competency/checkmark_16x16.png" /></td>'
				}

				if (competency_levels[value[1]] == 'national') {
					table_row += '<td>' + value[3] + '</td></tr>';
					$("#competency_search_results tr:last").after(table_row);
				} else if (competency_levels[value[1]] == 'school'){
					table_row += '<td style="color:#4E8700;">' + value[3] + '</td></tr>';
					$("#school_competency_search_results tr:last").after(table_row);
				} else if (competency_levels[value[1]] == 'course' && course_info[value[0]]) {
					var course_link;
					course_link = "</tr><tr><td colspan='2'><a class='content-link' href='/view/course/" + school + "/" + course_info[value[0]].id + "/obj' target='_blank'>" + course_info[value[0]].title + "</a>";
					table_row += '<td  style="color:#D67025;">' + value[3] + '</td>' +  course_link  + '</td></tr>';
					$("#course_competency_search_results tr:last").after(table_row);
				} else if (competency_levels[value[1]] == 'content' && content_info[value[0]]) {
					var content_link;
					content_link = "</tr><tr><td colspan='2'><a class='content-link' href='/view/content/" + content_info[value[0]].content_id  + "' target='_blank'>" + content_info[value[0]].title + "</a>";
					content_link += "<br> <b>ID:</b> " + content_info[value[0]].content_id;
					content_link += " &nbsp&nbsp<b>Created:</b> " + content_info[value[0]].created;
					content_link += " &nbsp&nbsp<b>Modified:</b> " + content_info[value[0]].modified;

					table_row += '<td style="color:#4D92CD;">' + value[3] + '</td>' +  content_link + '</td></tr>';
					$("#content_competency_search_results tr:last").after(table_row);
				} else {
					var session_link;
					if (session_info[value[0]] && session_info[value[0]]) {
						session_link = "</tr><tr><td colspan='2' style='color:#4D92CD;'><a class='session-link'>" + value[0] + " (" + session_info[value[0]].title + ") " + "</a>";
						session_link += "<br> <b>ID:</b> " + session_info[value[0]].session_id;
						session_link += " &nbsp&nbsp<b>Meeting Date:</b> " + session_info[value[0]].date;
						session_link += " &nbsp&nbsp<b>Time:</b> " + session_info[value[0]].starttime + " - " + session_info[value[0]].endtime;
						session_link += " &nbsp&nbsp<b>Location:</b> " + session_info[value[0]].location;
						table_row += '<td style="color:#4D92CD;">' + value[3] + '</td>' +  session_link + '</td></tr>';
						$("#session_competency_search_results tr:last").after(table_row);
				  }
				}
			});
	// notice display part
	$('.search_result_table').each(function() {
		if($(this).find('tr').length < 2) {
			$(this).find('tr').last().after("<tr><td><i>(No results of this competency type found for the current query. Please check other competency types and/or try again after modifying your search.) </i></td><td>x</td></tr>");		
		}
	});
	//
	
	$("#search_loading").hide();
	search_clear_flag = 1;
	});
}

function makeTabs(selector) {
    tab_lists_anchors = document.querySelectorAll(selector + " li a");
    divs = document.querySelector(selector).getElementsByTagName("div");
    for (var i = 0; i < tab_lists_anchors.length; i++) {
        if (tab_lists_anchors[i].classList.contains('active')) {
            divs[i].style.display = "block";
        }
    }

    for (i = 0; i < tab_lists_anchors.length; i++) {

        document.querySelectorAll(".tabs li a")[i].addEventListener('click', function(e) {

            for (i = 0; i < divs.length; i++) {
                divs[i].style.display = "none";
            }

            for (i = 0; i < tab_lists_anchors.length; i++) {
                tab_lists_anchors[i].classList.remove("active");
            }

            clicked_tab = e.target || e.srcElement;

            clicked_tab.classList.add('active');
            div_to_show = clicked_tab.getAttribute('href');

            document.querySelector(div_to_show).style.display = "block";
        });
    }
}
