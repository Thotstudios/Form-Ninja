<?PHP
//insure HTTPS, otherwise 404

//Check for post data
if($_POST['username'])
{
	//login to database
	$link = mysql_connect('localhost', 'rilbur5_ninja', 'ninja');
	if(!$link){
		$response['accepted'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		//die('Could not connect: ' . mysql_error());
	}
	
	if(mysql_select_db('rilbur5_school'))
	{
		//echo "\ndatabase selected";
		
		//VALIDATE inputs!
		
		//SELECT to see if username / password combo exists
		$queryResult=mysql_query('select * from USER where USERNAME="'.$_POST['username'].'" and PASSWORD="'.$_POST['password'].'"');
		
		if(!$queryResult){
			$response['accepted'] = 'False';
			$response['error'] = 'Database select error';
			print json_encode($response);
			exit;
		}

		//Start json array
		$response = array();
		
		if(mysql_numrows($queryResult)==1){
			//if so, create session
			session_start();
			
			
			$response['accepted'] = 'True';
			

			$row = mysql_fetch_array($queryResult);
  			$response['firstName'] = $row['FNAME'];
  			$response['lastName'] = $row['LNAME'];
  			$response['email'] = $row['EMAIL'];
  			$response['company'] = $row['COMPANY'];
  			$response['phoneNumber'] = $row['PHONENUMBER'];
  			$response['zipCode'] = $row['ZIPCODE'];
  			$response['zipeCodeExt'] = $row['ZIPCODEEXT'];
  						
			print json_encode($response);
		}
		
		else{
			$response['accepted'] = 'False';
			$response['error'] = 'Invalid username or password';
			print json_encode($response);
		}
	}
	
	else{
		$response['accepted'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		//die ('error, no connection'.mysql_error());
	}
	
	
	
	//close out connection
	mysql_close($link);

}

else
{
		$response['accepted'] = 'False';
		$response['error'] = 'No username or password entered';
		print json_encode($response);
}
?>