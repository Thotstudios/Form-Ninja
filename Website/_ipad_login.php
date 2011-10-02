<?php
require_once('_Login.php');
require_once('_Validate.php');

if(isset($_POST['username']) and isset($_POST['password']))
{
	$logged=iPadLogin($_POST['username'], $_POST['password']);
	if($logged['logged'])
	{
		$response['accepted'] = 'true';
		$response['userKey']=$logged['userKey'];
		$response['passKey']=$logged['passKey'];
		$response['days']=$logged['days'];
		print json_encode($response);
	}
	else
	{
		$response['accepted'] = 'false';
		$response['error'] = $logged['error'];
		print json_encode($response);
	}
}
else
{
	$response['accepted'] = 'False';
	$response['error'] = 'No username or password entered';
	print json_encode($response);
}

?>