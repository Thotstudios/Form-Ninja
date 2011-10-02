<?php
//This file contains functions for logging a user in and retrieving user data once logged in.
require_once('_Validate.php');
require_once('_Database.php');

function logUserIn($username, $password)
{
	if(!validateUsername($username))
	{
		$returnValue['logged']=false;
		$returnValue['error']['username']="Error W01-0001: Invalid username";
		return $returnValue;
	}
	$selector=get_user_MYSQL();
	if(!$selector)
	{
		$returnValue['logged']=false;
		$returnValue['error']['database']="Error W01-0002: Error connecting to database";
		return $returnValue;
	}
	$username=prepStringForSQL(trim($username));
	$query="select * from ".$GLOBALS['db_prefix']."user where ".$GLOBALS['db_prefix']."user.username='$username'";
	$search=$selector->query($query);
	if(!$search)
	{
		$returnValue['logged']=false;
		$returnValue['error']['database']="Error W01-0003: Error with database connection";
		return $returnValue;
	}
	if($search->num_rows!=1)
	{
		$returnValue['logged']=false;
		$returnValue['error']['userpass']="Error W01-0004: Username/password combination not detected";
		return $returnValue;
	}
	
	$result=$search->fetch_object();
	$salt=$result->salt;
	$passwordsalt=hashPasswordWithSalt($password, $salt);
	$query="select * from ".$GLOBALS['db_prefix']."user where ".$GLOBALS['db_prefix']."user.username='".$username."' and ".$GLOBALS['db_prefix']."user.password='".$passwordsalt."'";
	$search2=$selector->query($query);
	if(!$search2)
	{
		$returnValue['logged']=false;
		$returnValue['error']['database']="Error W01-0005: Error with database connection";
		return $returnValue;
	}
	if($search2->num_rows==1)
	{
		$row=$search2->fetch_object();
		$_SESSION['uid']=$row->userid;
		session_regenerate_id();
		$returnValue['logged']=true;
		return $returnValue;
	}
	else
	{
		$returnValue['logged']=false;
		$returnValue['error']['userpass']="Error W01-0006: Username/password combination not detected";
		return $returnValue;
	}
}

function iPadLogin($username, $password, $days="14")
{
	$logged=logUserIn($username, $password);
	//echo $username; echo $password;
	if($logged['logged'])
	{	
		$saltChars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
		$salt='';
		for($i=0; $i<32; $i++)
		{
			$salt.=$saltChars{rand(0,61)};
		}
		$userSalt=MD5($salt);
		
		$salt='';
		for($i=0; $i<32; $i++)
		{
			$salt.=$saltChars{rand(0,61)};
		}
		$passSalt=MD5($salt);
		
		
		$userKey=hashPasswordWithSalt($username, $userSalt);
		$passKey=hashPasswordWithSalt($password, $passSalt);
		
		//echo $userKey;
		//echo $passKey;
		
		$updater=get_updater_MYSQL();
		if(!$updater)
		{
			$logged['logged']=false;
			$logged['error']['database']="Error W01-0007: Error with second stage database connection";
		}
		else
		{
			$query="select userid from ".$GLOBALS['db_prefix']."user where ".$GLOBALS['db_prefix']."user.username='{$username}'";
			$result=$updater->query($query);
			$userID=$result->fetch_object();
			$userID=$userID->userid;
			$query="INSERT INTO ".$GLOBALS['db_prefix']."ipad_login (userid, userKey, passKey, expirationDate) VALUES ('{$userid}', '{$userKey}', '{$passKey}', adddate(now(), interval {$days} day)) on duplicate key update userKey='{$userKey}', passKey='{$passKey}', expirationDate=adddate(now(), interval {$days} day)";
			$success=$updater->query($query);
			if($success)
			{
				$logged['userKey']=$userKey;
				$logged['passKey']=$passKey;
				$logged['days']=$days;
			}
			else
			{
				$logged['logged']=false;
			}
		}
	}
	return $logged;
}

?>