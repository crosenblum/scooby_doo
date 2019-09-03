/* *******	CHECK BOX FUNCTIONS *******
	these functions require:
		1) the new Array functions: <a href="array.js">array.js</a>
		2) the getFormGroup() function from <a href="getRadio.js">getRadio.js</a>
*/

/* return whether or not <em>any</em> value is checked */
function isChecked(name) {
	elements = getFormGroup(name);
	if (elements)
		/* loop over all the checkboxes */
		for (i = 0; i < elements.length; i++)
			if (elements[i].checked)
				return true;
	/* either not found or none are checked */
	return false;
}

/* return an array of checked elements */
function getCheck(name) {
	elements = getFormGroup(name);
	checked = new Array();
	if (elements)
		for (i = 0; i < elements.length; i++)
			if (elements[i].checked)
				/* use our new array function */
				checked.append(elements[i]);
	/* return the array, it may be empty */
	return checked;
}

/* return an array of the checked elements' values */
function getCheckValue(name) {
	elements = getCheck(name);
	values = new Array();
	/* are there any selected elements? */
	if (elements)
		for (i = 0; i < elements.length; i++)
			values.append(elements[i].value);
	/* may return an empty array */
	return values;
}