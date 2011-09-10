<?php
//this file contains the functions to register and create a new account.
//It relies on the _Validate file to handle validation for it.
//It requires _Database to provide a database link
//_Account will handle accessing / modifying an existing account.
require_once('_Validate.php');
require_once('_Database.php');

function registerUser($username, $password, $password2, $fname, $lname, $email, $zip, $zipExt, $phoneNumber, $company)
{
	
	$username=trim(prepStringForSQL($username));
	$fname=trim(prepStringForSQL($fname));
	$lname=trim(prepStringForSQL($lname));
	$company=trim(prepStringForSQL($company));
	$email=trim($email);
	$zip=trim($zip);
	$zipExt=trim($zipExt);
	$phoneNumber=trim($phoneNumber);
	
	if(checkExistingUsername($username))
	{
		$error['usernameExists']=true;
	}
	if(!validateUsername($username))
	{
		$error['usernameInvalid']=true;
	}
	
	if($password!=$password2)
	{
		$error['passwordMismatch']=true;
	}
	else if(!validatePassword($password))
	{
		$error['passwordInvalid']=true;
	}
	
	if(checkExistingEmail($email))
	{
		$error['emailExists']=true;
	}
	if(validateEmail($email))
	{
		$error['emailInvalid']=true;
	}
	
	if(strlen($zip)>0)
	{
		if(validateZip($zip))
		{
			$error['zipInvalid']=$zip;
		}
		else if(strlen($zipExt)>0)
		{
			if(validateZipExt($zipExt))
			{
				$error['zipInvalid']=true;
			}
		}
	}
	else if(strlen($zipExt)>0)
	{
		$error['zipInvalid']=true;
	}
	
	if(strlen($phoneNumber)>0)
	{
		if(validatePhoneNumber($phoneNumber))
		{
			$error['phoneNumberInvalid'];
		}
	}
	if(!isset($error))
	{
		$saltChars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
		$salt='';
		for($i=0; $i<32; $i++)
		{
			$salt.=$saltChars{rand(0,61)};
		}
		$salt=MD5($salt);
		
		$passwordsalt=hashPasswordWithSalt($password, $salt);
		
		$updater=get_updater_MYSQL();
		$query="INSERT INTO ".$GLOBALS['db_prefix']."user (username, password, salt, fname, lname, email, zip, zipExt, phoneNumber, company) VALUES ("
		."'$username', '$passwordsalt', '$salt'," 
		.((!empty($fname))?"'".$fname."'":"NULL").", " 
		.((!empty($lname))?"'".$lname."'":"NULL")
		.", '$email', " 
		.((!empty($zip))?"'".$zip."'":"NULL").", " 
		.((!empty($zipExt))?"'".$zipExt."'":"NULL").", " 
		.((!empty($phoneNumber))?"'".$phoneNumber."'":"NULL").", " 
		.((!empty($company))?"'".$company."'":"NULL").") ";
		$result=$updater->query($query);
		if($result)
		{
			$return['registered']=true;
			$return['uid']=$updater->insert_id;
		}
		else
		{
			$error['DBError']=$updater->error();
		}
	}
	
	
	$values['username']=$username;
	$values['fname']=$fname;
	$values['lname']=$lname;
	$values['email']=$email;
	$values['$zip']=$zip;
	$values['zipExt']=$zipExt;
	$values['phoneNumber']=$phoneNumber;
	$values['company']=$company;
	
	$return['values']=$values;
	if(isset($error))
	{
		$return['error']=$error;
	}
	
	return $return;
}

?>