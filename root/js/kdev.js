/* =====================
    Kailash Sankar

   ======================
   * /
/*
$("#navdown").click(function() {
  //alert("hey..get some rest mate");
  var x = $("#navhint2").offset().top + 250;
  
   $('html, body').animate({
       scrollTop: x
   },1000);
   
   //$('html,body').animate({scrollTop: 647});
   
  //$('').scrollTo('#slide-2');
  
  $('html,body').animate({
	          scrollTop: target.offset().top
	        }, 500);
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
		      $loader.one('transitionend', function(e) {    
						$loader.addClass('hidden');  
  
				});  
			  
			 			  
		}, 800);
		
	var imgLoad = imagesLoaded('#parallax-base');
	imgLoad.on( 'progress', function( instance, image ) {
    var result = image.isLoaded ? 'loaded' : 'broken';
    console.log( 'image is ' + result + ' for ' + image.img.src );
     });
     
    //Init tooltip
    $("body").tooltip({ selector: '[data-toggle=tooltip]' });
    
    
    
    //Site navigation marker using waypoint.js
    $('#one').waypoint(function(direction) {
	   console.log('marking site nav home');
	   clearSiteNav();
       $('#navhome').addClass('active');
    }, { offset: '25%' });

    $('#two').waypoint(function(direction) {
	   console.log('marking site nav designs');
	   clearSiteNav();
	   if(direction=='up') {
		   $('#navhome').addClass('active');
	   }
	   else {
		   $('#navdesigns').addClass('active'); 
	   }
	}, { offset: '25%' });

    $('#three').waypoint(function(direction) {
	   console.log('marking site nav demo');
	   clearSiteNav();
	   if(direction=='up') {
            $('#navdesigns').addClass('active');
       }
       else {
		   $('#navdemo').addClass('active');
	   }
	}, { offset: '25%' });


    $('#four').waypoint(function(direction) {
	   console.log('marking site nav tuts');
	   clearSiteNav();
	   if(direction=='up') {
		    $('#navdemo').addClass('active'); 
		} 
		else {
			$('#navtuts').addClass('active'); 
		}
	}, { offset: '25%' });
	
	 $('#five').waypoint(function(direction) {
	   console.log('marking site nav tuts');
	   clearSiteNav();
	   if(direction=='up') {
		    $('#navtuts').addClass('active'); 
		} 
		else {
			$('#navend').addClass('active'); 
		}
	}, { offset: '25%' });


});

function clearSiteNav() {
	$('#sitenav ul li a').removeClass('active');  
}

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
            skrollr.menu.init(s, {
				animate: true,
				easing: 'sqrt',
				duration: function(currentTop, targetTop) {
				//By default, the duration is hardcoded at 500ms.
				//return 500;
				
				//But you could calculate a value based on the current scroll position (`currentTop`) and the target scroll position (`targetTop`).
				console.log(' output ' + (Math.abs(currentTop - targetTop)) );
				return Math.abs(currentTop - targetTop);
				},
			});
	        
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
			//scrolling doesn't happen the way we want on touch 
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

function showmenu() {
	$( "#sociallinks" ).toggle(800, function () { 
		if($("#socialmenu").hasClass("active")) {
			$("#socialmenu").removeClass("active");
		}
		else {
			$("#socialmenu").addClass("active");
		}
		
	});
}

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



