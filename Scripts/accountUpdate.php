<?PHP
//insure HTTPS, otherwise 404

//Start json array
$response = array();

//Check for post data
if($_POST['username']){

	//login to database
	$link = mysql_connect('localhost', 'rilbur5_ninja', 'ninja');
	if(!$link){
		$response['updated'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		exit;
	}
	
	if(mysql_select_db('rilbur5_school')){
		//Attempt to update user info
		$queryResult=mysql_query('UPDATE SET LNAME = "'.$_POST['lastName'].'" where USERNAME="'.$_POST['username'].'"');
	}
	
	
	else{
		$response['updated'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		exit;
	}
}


else{
	$response['updated'] = 'False';
	$response['error'] = 'No username or password entered';
	print json_encode($response);
}

?>