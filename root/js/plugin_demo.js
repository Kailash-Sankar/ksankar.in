
$('.prog-btn').progbtn({ enable_zblock : 1 });
$('.inp-btn').progbtn({ enable_zblock : 1 });
$(".example-5").progbtn({ enable_zblock:1, minimal_mode:1 });

$('.prog-btn, .inp-btn, #checkbox-1').click( function(e) {
  var ele = $(this);
  
  console.log('Clicked...');
  
  //get the handler
  var ele_handle = ele.data('progbtn');
  
   //get the id
  var id = ele.attr('id');
  
  switch( id ) {
	case 'prog_btn1':
		//star progress
		ele_handle.setProgress();	
	    setTimeout( function () {  ele_handle.setSuccess(); }, 2000 ); 
	    break;
	case 'prog_btn2':
		ele_handle.setProgress();
		setTimeout( function()  {  ele_handle.setError(); }, 3000 ); 
		break;
	case 'prog_btn3':
		ele_handle.showAlert({ ontrue: 'setProgress', event : e });
		setTimeout( function()  {  ele_handle.setSuccess(); }, 3000 ); 
		break;
	case 'prog_btn4':
		ele_handle.showAlert({ ontrue: 'setProgress', msg: 'Because you can.', event: e });
		setTimeout( function()  {  ele_handle.setError(); }, 2000 ); 
		break;		
	case 'prog_btn5':
		ele_handle.showAlert({ ontrue: 'zBlock', event: e });
		setTimeout( function()  {  ele_handle.zUnblock(); }, 2000 ); 
		break;	
	case 'prog_btn6':
		ele_handle.zBlock('Blocked without an alert.');
		setTimeout( function()  {  ele_handle.zUnblock(100); }, 2000 ); 
		break;
	case 'inp_btn1':
		ele_handle.showAlert({ ontrue: 'zBlock', msg: 'Make a sandwich?', zmsg: 'Your sandwitch is being made...', event: e });
		setTimeout( function()  {  ele_handle.zUnblock(400); }, 2000 );
		break;
	case 'inp_btn2':
		//ele_handle.setProgress();
		ele_handle.showAlert({ ontrue: 'setProgress', msg: 'Make amends?', event: e });
		setTimeout( function()  {  ele_handle.setError(); }, 3000 ); 
		break;
	case 'rain_btn1':
		ele_handle.cryMeARiver(800);
		//setTimeout( function()  {  ele_handle.setError(); }, 3000 ); 
		break;	
	case 'rain_btn2':
		ele_handle.breakTheSpell();
		break;
		
	};

});


$( ".example-5" ).change(function(e) {
   var ele = $(this);
  
  console.log('Clicked...');
  
  //get the handler
  var ele_handle = ele.data('progbtn');
  
   //get the id
  var id = ele.attr('id');
  
  switch( id ) {
  	case 'select-1':
		 ele_handle.showAlert({ ontrue: 'zBlock', zmsg: 'It works even without a button...', event: e });
		 setTimeout( function()  {  ele_handle.zUnblock(400); }, 2000 );
		 break;
	case 'checkbox-1':
		ele_handle.zBlock('Your action is being saved. Please remain calm and stop clicking all over the page.');
		setTimeout( function()  {  ele_handle.zUnblock(600); }, 2000 );
		break;	
  };
});


/*
   var con = ele_handle.showAlert({ 
									msg: 'Show custom Alert?',
									ontrue: 'setProgress',
									event: e
									});
									
*/


/* ----------------- basic page block for post back ----------------- */
$('.inp-btn-case1').click( function() {
	var ele = $(this);
	ele.progbtn({ enable_zblock:1, minimal_mode:1 });
	var ele_handle = ele.data('progbtn');
	ele_handle.showAlert({ ontrue: 'zBlock' });							
});


$('.inp-btn-case2').click( function() {
	var ele = $(this);
	ele.progbtn({ enable_zblock:0, minimal_mode:0 });
	var ele_handle = ele.data('progbtn');
	ele_handle.showAlert({ ontrue: 'setProgress' });							
});

/* -------------------- END ------------------------------------------- */


//for testing.
$('#reset00').click( function() {
  var ele = $(this);
  ele.progbtn();
  var ele_handle = ele.data('progbtn');
  ele_handle.setProgress();
});

