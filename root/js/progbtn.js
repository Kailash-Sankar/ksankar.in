/* Progress Button v2
	 Kailash Sankar
	   ksankar.in  

Inspired by Mary Lou's amazing tutorials.

Needs documentation
jquery plugs in the svg/path. 
cross browser tested

When life gives you lemons make lemonade.
*/

(function( $ ) {
  
  //the plugin
    $.fn.progbtn = function( options ) {
       return this.each(function()
       {
           var element = $(this);
           // Return early if this element already has a plugin instance
           if (element.data('progbtn')) return;
           // pass options to plugin constructor _init
           console.log('making an instance');
           var btnInstance = new progbtn(this, options);
           // Store plugin object in this element's data
           element.data('progbtn', btnInstance );
       });
    };
  
  
  var progbtn = function(ele, options ) {
  
   //vairables 
   var htmltext;
   var btn;	
   var path;
   var btn_co;
   var interval;
   var len; 
   var def_alert = 'Are you sure?';
   var def_msg = 'Please wait while page loads.';
   var is_active = 0;
   
  
	 var settings = $.extend({
            // These are the defaults.
            basetime: 0,
            rate: 0.1, 
            enable_zblock: 0,
			minimal_mode:0
    }, options );
	
	  console.log( $(ele).attr('id') );	
    
    //initialize the button
    _init(ele); 
    
    //zblock variables
    var ztrans_bg = $("div#pb_trans_bg");
    var ztrans_text = $("span#pb_status_text");
    
       
    //start the button progress
    this.setProgress = function() {
	   if( is_active) { return; }	 	
       btn_co.addClass('inprogress');
       htmltext = btn.html();
       btn.html('');
       console.log( htmltext );
       var progress = settings.basetime;
       var rate = settings.rate;
         
       interval = setInterval( function() {
              progress = Math.min( progress + Math.random() * rate, 1);
              _setOffset( progress );
              if( progress === 1 ) {
                    clearInterval( interval );
                console.log('cleared');
                }
         }, 120 );   
         
        is_active = 1;
 
   }   
     
   //enter success state
   //reset to default after 1s
    this.setSuccess = function () {
		if ( is_active ) {	
		   _resetProgress();
		   btn_co.addClass('success-btn');
		   btn.html('<span class="prog-symbol">&#10004;</span>');
		   setTimeout( function(){ _resetBtn();  },1000 );
		}   
    }

    //enter error state
    //reset to default after 1s
	this.setError = function () {
	   if ( is_active ) {	
		  _resetProgress();
		  btn_co.addClass('error-btn');
		  btn.html('<span class="prog-symbol">&#10060;</span>');
		  setTimeout( function(){ _resetBtn();  },1000 );
	  }    
	}
    
    //show an alert - custom or default
	// initiate progress or zblock
    //returns true or false if user wants the value
    this.showAlert = function(opt) {
      var msg;
      
      opt.event = opt.event || window.event;
      
	  console.log('event:',opt.event);
	  console.log('options:',opt);
	  
      if(opt.msg) { msg = opt.msg; } else { msg = def_alert; }
      var con  = confirm(msg);
      
      if (opt.return) { 
        return con;  
      }
      else {
         if( con ) { 
				
			switch(opt.ontrue ) {
				case 'zBlock':
					this.zBlock(opt.zmsg);
					break;
				case 'setProgress':
					this.setProgress();
					break;
				default:
					console.log('Default option');
			}
		  }
 		  else {
			opt.event.preventDefault();
			return false;
		}
      }        
     }
    
     
    //Full page block with message
    this.zBlock = function(cu_msg) {
      var msg;
       console.log('LL:',ztrans_bg);
      if(cu_msg) { msg = cu_msg; } else { msg = def_msg; }
      ztrans_bg.fadeIn();
      ztrans_text.html(msg);
      is_active = 1;
    }

    //Unblock
    this.zUnblock = function(cu_delay) {
	  if ( is_active  ) {	
		  console.log('UnBlock Screen'); 
		  if( !cu_delay ) { cu_delay = 1000; }  
		  setTimeout( function() { 
			  ztrans_bg.fadeOut();
			  //ztrans_text.html('');   
		  }, cu_delay );
		   is_active = 0;
	  }   
    }
    
    
	this.isActive = function() {
		return is_active;
	}
	
	//special
	this.cryMeARiver = function(nod) {
	
		for(i=0;i<nod;i++) {
			
			var leftpos = getRandomNumber(0,100) + '%';
			var toppos = getRandomNumber(-200,100) + '%';
			
			
			var rd_div = document.createElement('div');
			rd= $(rd_div);
			
			rd.addClass('rain-drop')
			  .css('left',leftpos)
			  .css('top',toppos)
			  .appendTo($('body'));
			
			console.log('left pos:',  leftpos);
			console.log('top pos:',  toppos );
			
			//$('body').append(rd);
		}	
				
	}
	
	this.breakTheSpell = function() {
		$('.rain-drop').fadeOut().remove();
	}	
    
    /* ---- private functions ---- */
     
     function _init(ele) {
       btn = $(ele);
       //console.log( btn );
       btn_co = btn.parent();
	   
	   if ( !settings.minimal_mode ) {	
		   btn_co.append( svg );
		   //console.log( btn_co );
		   path = btn_co[0].querySelector('.svg-co path');
		   len = path.getTotalLength();
		   console.log('_init:' + len );
		}  
       
       if ( settings.enable_zblock && !$('#pb_trans_bg').length ) {
         $('body').append( zblock );
       }
       
    }
    
    function _setOffset(progress) { 
		path.style.strokeDashoffset = len * ( 1 - progress );
   		console.log(progress);
  	}    
    
    function _resetProgress() {
       clearInterval( interval );
       btn_co.removeClass('inprogress');
       path.style.strokeDashoffset = len;
       console.log('reset:' + len);
    }
    
    function _resetBtn() {
       btn_co.removeClass('error-btn');
       btn_co.removeClass('success-btn');
       console.log('reset btn: ' +  htmltext );
       btn.html( htmltext );
       is_active = 0;
	}
	
	
	//special 
	
	// Returns a random integer between min (included) and max (included)
	// Using Math.round() will give you a non-uniform distribution!
	function getRandomNumber(min, max) {
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}
	    
 };	
  

var svg = '<div class="svg-co"> <svg xmlns="http://www.w3.org/2000/svg" height="46" width="46">   <path  transform="rotate(90 23,23.000000000000004)" id="svg_2" d="m2,23c0,-11.602203 9.397797,-21 21,-21c11.602203,0 21,9.397797 21,21c0,11.602203 -9.397797,21 -21,21c-11.602203,0 -21,-9.397797 -21,-21z" stroke-opacity="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="4" stroke="#3DB0FA" fill-opacity="null" fill="transparent" stroke-dasharray="131.9728240966797 131.9728240966797" stroke-dashoffset="131.9728240966797"/></svg> </div>';  
  
var zblock = '<div id="pb_trans_bg" class="pb_trans_bg"><div class="pb_status_box"><span id="pb_status_text"></span></div></div>'; 
  
}( jQuery ));


