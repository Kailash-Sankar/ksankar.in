/* js for blog 
-----Kailash Sankar --------
*/
( function($) {
	$("body").tooltip({ selector: '[data-toggle=tooltip]' });
})(jQuery);


$("#preview_box").hide();

function blog_preview()
{
	 
	if( $("#title").val() && $("#content").val() ) {
		$("#pre_error").hide();
		$("#preview_box").show();
		$("#pre_title").html( $("#title").val() );
		$("#pre_content").html( $("#content").val() );
	}
	else {
		$("#pr_error").show();
		$("#pre_error").html("<span class='alert alert-warning'>Title and Content are Required.</span>");
	}
}

function comment_preview()
{
	 
	if( $("#comment").val() ) {
		$("#pre_error").hide();
		$("#preview_box").show();
		$("#pre_comment").html( $("#comment").val() );
	}
	else {
		$("#pr_error").show();
		$("#pre_error").html("<span class='alert alert-warning'>The preview would look better with a few words....</span>");
	}
}


function gotopost(postloc) {
  console.log("scrolling to.."+postloc);
  var x = $(postloc).offset().top;
  var target = $(postloc);
 
  //prevent default action
  event.preventDefault();
  
  //scroll to the new element position
  $('html,body').animate({
	          scrollTop: x
	        }, "slow");
}

function enableedit() {
	$('#editprofile input').attr("disabled",false);
	$('.hideonedit').hide();
	$('.showonedit').show();
}

function canceledit() {
	$('#editprofile input').attr("disabled",true);
	$('.showonedit').hide();
	$('.hideonedit').show();
}

function charcount(comment_box) {
	
	var rem = 1500 - $(comment_box).val().length;
	console.log("counting"+ rem);
	$('#charcount').html(rem);
}


$('#vs_arrow').click( function(){
	update_viewspace();
	show_alert('Preference saved on localStorage.');
});


function update_viewspace() {
	$('#left_panel').toggleClass('hide-left-panel');
	$('#content_panel').toggleClass('center-content');
	$('#vs_arrow').toggleClass('flip-arrow');

	var arw_pref = '0';
	if ( $('#vs_arrow').hasClass('flip-arrow') ) {
		arw_pref = '1';
	}
	console.log('Update arw prefs',arw_pref);
	localStorage.setItem("ksankar_in_arw_pref_x836", arw_pref );
}	

$(document).ready( function(){
	var arw_pref = 	localStorage.getItem("ksankar_in_arw_pref_x836");
	console.log('Saved arrow prefs:', arw_pref);
	if ( arw_pref == '1' ) {
		setTimeout(function() {
		    update_viewspace();
		}, 200);
	}
});


function show_alert(msg) {
	var alt = '<div id="shw_alert_box" class="alert alert-info alert-dismissible fade in cu-alert"><button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span></button>' + msg  + '</div>';
	$('#content_panel').prepend(alt);
	setTimeout(function() {
		    $('#shw_alert_box').alert('close');
	}, 2000);
}