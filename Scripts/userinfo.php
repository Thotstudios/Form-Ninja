<?PHP
//insure HTTPS, otherwise 404

//Start json array
$response = array();

//Check for post data
if($_POST['username'])
{
	$response['username'] = $_POST['username'];
	print json_encode($response);
	 
	//login to database
	$link = mysql_connect('localhost', 'rilbur5_ninja', 'ninja');
	if(!$link){
		$response['accepted'] = 'False';
		$response['error'] = 'Database connection error';
		//print json_encode($response);
	}
	
	if(mysql_select_db('rilbur5_school'))
	{
	}
}

else{
	//error
}

?>