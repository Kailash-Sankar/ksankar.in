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
	console.log('arrow called');
	$('#left_panel').toggleClass('hide-left-panel');
	$('#content_panel').toggleClass('center-content');
	$('#vs_arrow').toggleClass('flip-arrow');
});