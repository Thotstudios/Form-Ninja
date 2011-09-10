<?php 

require_once('_Constants.php');
require_once('_Register.php');

if(!empty($_POST))
{
	if(!isset($_POST['username']))
	{
		$_POST['username']='';
	}
	if(!isset($_POST['password']))
	{
		$_POST['password']='';
	}
	if(!isset($_POST['password2']))
	{
		$_POST['password2']='';
	}
	if(!isset($_POST['fname']))
	{
		$_POST['fname']='';
	}
	if(!isset($_POST['lname']))
	{
		$_POST['lname']='';
	}
	if(!isset($_POST['email']))
	{
		$_POST['email']='';
	}
	if(!isset($_POST['zip']))
	{
		$_POST['zip']='';
	}
	if(!isset($_POST['zipExt']))
	{
		$_POST['zipExt']='';
	}
	if(!isset($_POST['phoneNumber']))
	{
		$_POST['phoneNumber']='';
	}
	if(!isset($_POST['company']))
	{
		$_POST['company']='';
	}
	
	
	$register=registerUser($_POST['username'], $_POST['password'], $_POST['password2'], $_POST['fname'], $_POST['lname'], $_POST['email'], $_POST['zip'], $_POST['zipExt'], $_POST['phoneNumber'], $_POST['company']);
	
	if(isset($register['registered']))
	{
		$response['registered'] ="true";
		$response['userID'] = $register['uid'];
	}
	else
	{
		$response['registered']="false";
		$response['error']=$register['error'];
		
	}
	
	print json_encode($response);
}
?>