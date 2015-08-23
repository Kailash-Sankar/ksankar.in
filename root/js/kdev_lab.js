/* Kailash Sankar
 * js for Lab
 * 14 Feb 2015
 */
 
 /*
 $(".flip-container").on('click', function() {
	 
	
	var exp = $(this).attr('data-exp');
	console.log('opening card' + exp);
	$('a#' + exp)[0].click();
 });
 */
 

	//On page load, redirect user to the #hash slide if any
	$(document).ready( function() {
		var hash = window.location.hash.split('#')[1];
		console.log('Page load hash changed : ', hash );
		if( hash ){
			hash = '#' + hash;
			handle_hash_change(hash);	
		}	
	});	
	
	//for cross browser testing.
	if ("onhashchange" in window) {
    console.log("The browser supports the hashchange event!");
	}
	
	//handle URL
	function locationHashChanged() {
		console.log('hash change event triggered');
		if (location.hash) {
			handle_hash_change(location.hash);
		}
		else {
			//default redirect user to #slide-demo
			handle_hash_change('#slide-demo');
		}
	}
	//attach event
	window.onhashchange = locationHashChanged;
	
		
	// Take user to #hash slide
	function handle_hash_change(ele) {
		
		console.log('Element id',ele);
	
		//show slected slide
		$(".plugin-slide").slideUp('slow');
		
	
		$(ele).slideDown(1000);
		
		set_active_tab(ele)
	
	}
	
	function set_active_tab(ele) {
		$(".plugin-nav a").removeClass('active');
		$(".plugin-nav a[href="+ ele +"]").addClass('active');
			
	}



			
