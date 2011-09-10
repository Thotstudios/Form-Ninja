<?php
//This file contains functions for validating inputs and preparing them for entry into the database.

function checkExistingUsername($username)
{
	$selector=get_user_MYSQL();
	$query="select * from ".$GLOBALS['db_prefix']."user where ".$GLOBALS['db_prefix']."user.username='".prepStringForSQL($username)."'";
	$result=$selector->query($query);
	return $result->num_rows!=0;
}

function validateUsername($username)
{
	return preg_match("/^[a-zA-Z0-9]{5,255}$/",$username)>0;
}

function checkExistingEmail($email)
{
	$selector=get_user_MYSQL();
	$query="select * from ".$GLOBALS['db_prefix']."user where ".$GLOBALS['db_prefix']."user.email='".prepStringForSQL($email)."'";
	$result=$selector->query($query);
	return $result->num_rows!=0;
}

function validateEmail($email)
{
	return ((strlen($email)>255) OR (preg_match("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/",$email)==0));
}

function validateZip($zip)
{
	return (preg_match("/^[0-9]{5}$/",$zip)==0);
}

function validateZipExt($zip)
{
	return (preg_match("/^[0-9]{4}$/",$zip)==0);
}

function validatePhoneNumber($phoneNumber)
{
	return (preg_match("/^[0-9]{3}\-[0-9]{3}\-[0-9]{4}$/", $phoneNumber)==1);
}

function validatePassword($password)
{
	return (strlen($password)>=5);
}

function hashPasswordWithSalt($password, $salt)
{
	$password=MD5($password);
	$passwordsalt='';
	for($i=0; $i<32; $i++)
	{
		$passwordsalt.=$password{$i}.$salt{$i};
	}
	$passwordsalt=MD5($passwordsalt);
	return $passwordsalt;
}

?>