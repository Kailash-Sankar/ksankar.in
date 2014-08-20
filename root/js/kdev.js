/* =====================
    Kailash Sankar

/* ==== js for lamp design ==== */
function loginhint()
{
	$('p#hintbox').html("Clicking on submit button in the login form will post data to the login controller."
	+ "If the username and password fields are empty the page will throw an alert, if not the controller will authenticate the user by checking with the db. "
	+ "If the data is valid the function  will create the login session.");
}

function refreshhint()
{
	$('p#hintbox').html("Mouse over elements to know how they work");
}

function reghint()
{
	$('p#hintbox').html("Registration will only take a minute. After registering you will be able to add comments, report bugs and save theme choices ;)");
}

function lighthint()
{
	$('p#hintbox').html("The light theme is simple, responsive and pure bootstrap.");
}

function nighthint()
{
	$('p#hintbox').html("The night theme is elegent and calm but not as responsive");
}

/*
$("#navdown").click(function() {
  //alert("hey..get some rest mate");
  var x = $("#navhint2").offset().top + 250;
  
   $('html, body').animate({
       scrollTop: x
   },1000);
   
   //$('html,body').animate({scrollTop: 647});
   
  //$('').scrollTo('#slide-2');
});
*/


/* =============using enquire.js to make the parallax site responsive ================= */
( function( $ ) {
	// Setup variables
	$window = $(window);
	$slide = $('.parallax-slide');
	$loader = $('#preloader');
	$body = $('body');
	
    //show gif loader till the page is fully loaded   
	$body.imagesLoaded( function() {
		setTimeout(function() {
		      
		      // Resize sections
		      //adjustWindow();
		      
		      // remove gif loader
			  $loader.removeClass('loading').addClass('loaded');
			  
		}, 800);
	});


function adjustWindow(){

	    // Get window size
	    winH = $window.height();
	    winW = $window.width();

	    // Keep minimum height 550
	    if(winH <= 550) {
	        winH = 550;
	    }

	    // Init Skrollr for 768 and up
	    if( winW >= 768) {

	        // Init Skrollr
	        var s = skrollr.init(); 
    
	        // Resize
	        //$slide.height(winH);
	        //s.refresh($('.parallax-slide'));

	    } else {

	        // Init Skrollr
	        var s = skrollr.init();
	        s.destroy();
	    }
	
		// Check for touch
	   	if(Modernizr.touch) {

			// Init Skrollr
			var s = skrollr.init();
			s.destroy();
	   	}

	}

	function initAdjustWindow() {
	    return {
	        match : function() {
	            adjustWindow();
	        },
	        unmatch : function() {
	            adjustWindow();
	        }
	    };
	}

	enquire.register("screen and (min-width : 768px)", initAdjustWindow(), false)
	        .listen(100);
		
} )( jQuery );



