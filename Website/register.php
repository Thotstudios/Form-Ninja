<?php
require_once('_Body.php');
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
	
}
ob_start();
if(isset($register['registered']))
{
	echo "<h1>User registered -- congratulations!</h1>";
}
else
{

?>

<?php echo isset($register['error']['DBError'])? "<h1>DB Error -- registration not inserted</h1>" : ""?>

<form action="register.php" method="POST">
	<fieldset><legend>Registration</legend>
		<label for="username"><span id="username" class="<?php
			if(isset($register['error']['usernameExists']))
			{
				echo "error\">Username already exists!";
			}
			else if (isset($register['error']['usernameInvalid']))
			{
				echo "error\">Selected Username is invalid!";
			}
			else
			{
				echo "\">Username";
			}
		?></span><input type="text" name="username" value="<?php 
			echo (isset($register['values']['username']))?$register['values']['username']:""; 
		?>" />
		<br />
		
		
		<label for="password"><span id="password" class="<?php
			if (isset($register['error']['passwordInvalid']))
			{
				echo "error\">Invalid password!";
			}
			else if (isset($register['error']['passwordMismatch']))
			{
				echo "error\">Password mismatch!";
			}
			else
			{
				echo "\">Password";
			}
		?></span><input type="password" name="password" value="" />
		<br />
		
		<label for="password2"><span id="password2" class="<?php
			if (isset($register['error']['passwordInvalid']))
			{
				echo "error\">Confirm Password:";
			}
			else
			{
				echo "\">Confirm Password";
			}
		?></span><input type="password" name="password2" value="" />
		<br />
		
		<label for="email"><span id="email" class="<?php
			if(isset($register['error']['emailExists']))
			{
				echo "error\">E-mail already in use!";
			}
			else if (isset($register['error']['emailInvalid']))
			{
				echo "error\">The E-Mail is invalid!";
			}
			else
			{
				echo "\">E-Mail";
			}
		?></span><input type="text" name="email" value="<?php 
			echo (isset($register['values']['email']))?$register['values']['email']:""; 
		?>" />
		<br />
		
		<label for="lname"><span id="lname" class="">Last Name</span></label>
		<input type="text" name="lname" value="<?php echo isset($register['values']['lname'])? $register['values']['lname']:"" ;?>" />
		<br />
		
		<label for="fname"><span id="fname" class="">First Name</span></label>
		<input type="text" name="fname" value="<?php echo isset($register['values']['fname'])? $register['values']['fname']:"" ;?>" />
		<br />
		
		<label for="zip"><span id="zip" class="<?php
			if (isset($register['error']['zipInvalid']))
			{
				echo "error\">Invalid Zipcode!";
			}
			else
			{
				echo "\">Zipcode";
			}
		?></span><input type="text" name="zip" value="<?php 
			echo (isset($register['values']['zip']))?$register['values']['zip']:""; 
		?>" />
		<input type="text" name="zipExt" value="<?php 
			echo (isset($register['values']['zipExt']))?$register['values']['zipExt']:""; 
		?>" />
		<br />
		
		
		<label for="phoneNumber"><span id="phoneNumber" class="<?php
			if (isset($register['error']['passwordInvalid']))
			{
				echo "error\">Invalid Phone Number:";
			}
			else
			{
				echo "\">Phone Number";
			}
		?></span><input type="text" name="phoneNumber" value="<?php 
			echo (isset($register['values']['phoneNumber']))?$register['values']['phoneNumber']:""; 
		?>" />
		<br />
		
		<label for="company"><span id="company" class="">Company</span></label>
		<input type="text" name="company" value="<?php echo isset($register['values']['company'])? $register['values']['company']:"" ;?>" />
		<br />
		
		<input type="submit" value="register" />

		<?php
}
$body=ob_get_clean();

outputBody('Test', $body);

?>