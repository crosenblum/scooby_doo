/* *******	NEW ARRAY FUNCTIONS ******* */
/* this is a simple shortcut function:
	all it does is add a value to the end of an array */
Array.prototype.append = function (val) {
	this[this.length] = val;
}