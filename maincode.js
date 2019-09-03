
/*
Shake image script (onMouseover)-
© Dynamic Drive (www.dynamicdrive.com)
For full source code, usage terms, and 100's more DHTML scripts, visit http://dynamicdrive.com
*/

//configure shake degree (where larger # equals greater shake)
var rector=3

///////DONE EDITTING///////////
var stopit=0
var a=1

function init(which){
stopit=0
shake=which
shake.style.left=0
shake.style.top=0
}

function rattleimage(){
if ((!document.all&&!document.getElementById)||stopit==1)
return
if (a==1){
shake.style.top=parseInt(shake.style.top)+rector
}
else if (a==2){
shake.style.left=parseInt(shake.style.left)+rector
}
else if (a==3){
shake.style.top=parseInt(shake.style.top)-rector
}
else{
shake.style.left=parseInt(shake.style.left)-rector
}
if (a<4)
a++
else
a=1
setTimeout("rattleimage()",50)
}

function stoprattle(which){
stopit=1
which.style.left=0
which.style.top=0
}
function windowpop(url) { 
	mywin2 = window.open(url, "winNew", 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,width=200,height=200,left=300,top=150'); 
}

