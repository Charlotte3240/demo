(function(){

	//新tabs切换
	function tabs(handles,cons){
		$(handles).each(function(num){
	    	$(this).click(function(){    		
	    		$(handles).removeClass("hover");
	    		$(this).addClass("hover");
	    		$(cons).removeClass("show");
	    		$($(cons)[num]).addClass("show");
	    	});
	    });
	}

	window.tabs = tabs;

})();

$(function(){
	
	$(document.body).css("min-height",$(window).height());
	$(window).resize(function(){		
		$(document.body).css("min-height",$(window).height());
	});

});	