
function getRem(pwidth,prem){
	var html = document.getElementsByTagName("html")[0];
	var oWidth = window.innerWidth;	
	html.style.fontSize = oWidth/pwidth*prem + "px";		
	if(!/iphone|ipad|ipod|android.*mobile|windows.*phone|blackberry.*mobile/i.test(window.navigator.userAgent.toLowerCase())){	//pc端居中显示
		
		html.style.width="750px";
		html.style["margin"] = "0 auto";	
		html.style.fontSize="100px";
	}
}

getRem(750,100);
/*750代表设计师给的设计稿的宽度，你的设计稿是多少，就写多少;100代表换算比例，这里写100是
为了以后好算,比如，你测量的一个宽度是100px,就可以写为1rem,以及1px=0.01rem等等*/
window.onresize = function(){
getRem(750,100);
};