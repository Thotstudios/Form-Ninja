<?PHP
//insure HTTPS, otherwise 404

//Check for post data
if($_POST['username'])
{
	//login to database
	$link = mysql_connect('localhost', 'rilbur5_ninja', 'ninja');
	
	if(!$link){
		$response['registered'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		exit;
	}
		
	if(mysql_select_db('rilbur5_school'))
	{
		//echo "\ndatabase selected";
		
		//VALIDATE inputs!
		
		//SELECT to see if username / email combo exists
		$queryResult=mysql_query('select * from USER where USERNAME="'.$_POST['username'].'" OR EMAIL="'.$_POST['email'].'"');
		
		if(!$queryResult){
			$response['registered'] = 'False';
			$response['error'] = 'Database select error';
			print json_encode($response);
			exit;
		}

		if(mysql_numrows($queryResult)==0)
		{
		//if so, create session
			session_start();
			$query="INSERT INTO `USER` (`USERID`, `USERNAME`, `PASSWORD`, `FNAME`, 'LNAME' , `EMAIL`, `COMPANY`, `PHONENUMBER`, `SECURITYQUESTION`, `SECURITYANSWER`, `ZIPCODE`, `ZIPCODEEXT`) values (NULL, '";
			$query=$query.$_POST['username']."', '";
			$query=$query.$_POST['password']."', '";
			$query=$query.$_POST['name']."', '";
			$query=$query.$_POST['email']."', '";
			$query=$query.$_POST['company']."', '";
			$query=$query.$_POST['phonenumber']."', '";
			$query=$query.$_POST['securityquestion']."', '";
			$query=$query.$_POST['securityanswer']."', '";
			$query=$query.$_POST['zipcode']."', '";
			$query=$query.$_POST['zipcodeExt']."')";
			
			$queryReslut=mysql_query($query);
			
			if(!$queryResult){
				$response['registered'] = 'False';
				$response['error'] = mysql_error();
				print json_encode($response);
				exit;
			}
		
			else{
				$response['registered'] = 'True';
				print json_encode($response);
				exit;
			}
		}
		
		else{
			//should check to see if username or email is already used, then report that
			$response['registered'] = 'False';
			$response['error'] = 'Could not register account. Please try again or contact our tech support.';
			print json_encode($response);
			exit;
		}
	}
	
	else{
		$response['registered'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		exit;
		//die ('error, no connection'.mysql_error());	
	}
	
	//close out connection
	mysql_close($link);
}

else{
	$response['registered'] = 'False';
	$response['error'] = 'Please make sure all form information is filled out properly';
	print json_encode($response);
}
?>