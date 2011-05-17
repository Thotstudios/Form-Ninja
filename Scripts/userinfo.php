<?PHP
//insure HTTPS, otherwise 404

//Start json array
$response = array();

//Check for post data
if($_POST['username'])
{
	 
	//login to database
	$link = mysql_connect('localhost', 'rilbur5_ninja', 'ninja');
	if(!$link){
		$response['userExists'] = 'False';
		$response['error'] = 'Database connection error';
		//print json_encode($response);
	}
	
	if(mysql_select_db('rilbur5_school'))
	{
	//SELECT to see if username / password combo exists
		$queryResult=mysql_query('select * from USER where USERNAME="'.$_POST['username'].'"');
		
		if(!$queryResult){
			$response['userExists'] = 'False';
			$response['error'] = 'Database select error';
			print json_encode($response);
			exit;
		}
		
		if(mysql_numrows($queryResult)==1){
			$response['userExists'] = 'True';
		}
		
		
		else{
			$response['userExists'] = 'False';
			$response['error'] = 'User information cannot be retrieved';
		}

		print json_encode($response);

	}
	
	else{
		$response['userExists'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
	}
	
	//close out connection
	mysql_close($link);
}

else{
	//error
}

?>