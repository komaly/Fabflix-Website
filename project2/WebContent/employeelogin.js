
function handleLoginResult(resultDataString) {
	resultDataJson = JSON.parse(resultDataString);
	console.log("handle login response");
	console.log(resultDataJson);
	console.log(resultDataJson["status"]);

	// if login success, redirect to index.html page
	if (resultDataJson["status"] == "success") {
		window.location.replace("/project2/employeeMain.html");
	} else {
		console.log("show error message");
		console.log(resultDataJson["message"]);
		jQuery("#employee_login_error_message").text(resultDataJson["message"]);
		window.alert(resultDataJson["message"]);
		window.location.replace("/project2/_dashboard.html");
	}
}


function submitLoginForm(formSubmitEvent) {
	console.log("submit login form");
	
	// important: disable the default action of submitting the form
	//   which will cause the page to refresh
	//   see jQuery reference for details: https://api.jquery.com/submit/
	formSubmitEvent.preventDefault();
		
	jQuery.post(
		"/project2/EmployeeLogin", 
		// serialize the login form to the data sent by POST request
		jQuery("#employee_login_form").serialize(),
		(resultDataString) => handleLoginResult(resultDataString));

}

// bind the submit action of the form to a handler function
jQuery("#employee_login_form").submit((event) => submitLoginForm(event));

