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
	}
}

else{
	//error
}

?>