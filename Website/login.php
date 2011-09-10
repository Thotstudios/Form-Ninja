<?php
require_once('_Login.php');
require_once('_Body.php');

if(isset($_POST['username']) and isset($_POST['password']))
{
	$logged=logUserIn($_POST['username'], $_POST['password']);
	if($logged['logged'])
	{
		$output="<p>Username / Password combo accepted</p>";
	}
	else
	{
		if(isset($logged['error']['username']))
		{
			$output="<p>Username was invalid.</p>";
		}
		else if(isset($logged['error']['userpass']))
		{
			$output="<p>Username/Password combo does not exist</p>";
		}
		elseif(isset($logged['error']['database']))
		{
			$output="<p>There was an error with our database, please try again later.</p>";
		}
		else
		{
			$output="<p>Unkown error detected.</p>";
		}
	}
}

ob_start();
?>

<h1>Log User In</h1>
<?php echo isset($output)?$output:""; ?>
<form action="login.php" method="POST">
<fieldset><legend>Login</legend>
<label for="username">Username:</label><input type="text" name="username" /><br>
<label for="password">Password</label><input type="password" name="password" />
<input type="submit" value="Submit">
</fieldset>
</form>

<?php
$body=ob_get_clean();

outputBody('Login Text', $body);

?>