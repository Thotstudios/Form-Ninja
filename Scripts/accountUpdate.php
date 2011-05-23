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
		$query = 'UPDATE USER set FNAME = "'.$_POST['firstName'].'", LNAME="'.$_POST['lastName'].'", EMAIL="'.$_POST['email'].'"';
		$query .= ', ZIPCODE="'.$_POST['zipCode'].'"';
		
		if(!empty($_POST['companyName']))
			$query .= ', COMPANY="'.$_POST['companyName'].'"';
			
		if(!empty($_POST['phoneNumber']))
			$query .= ', PHONENUMBER="'.$_POST['phoneNumber'].'"';
			
		if(!empty($_POST['zipExt']))
			$query .= ', ZIPCODEEXT="'.$_POST['zipExt'].'"';
			
		if(!empty($_POST['password'])){
			$query = 'UPDATE USER set PASSWORD = "'.$_POST['password'].'"';
			$response['passwordChanged'] = 'True';
		}
		
		$query.= ' where USERNAME="'.$_POST['username'].'"';
		
		$queryResult=mysql_query($query);
			
		if(!$queryResult){
			$response['updated'] = 'False';
			$response['error'] = 'Database select error';
			print json_encode($response);
			exit;
		}
		
		else{
			$response['updated'] = 'True';
			print json_encode($response);
			exit;
		}
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