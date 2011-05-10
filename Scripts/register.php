<?PHP
//insure HTTPS, otherwise 404

//Check for post data
if($_POST['username'])
{
	//login to database
	$link = mysql_connect('localhost', 'rilbur5_ninja', 'ninja');
	if(!$link)
		die('Could not connect: ' . mysql_error());
	//echo 'connected';
	
	if(mysql_select_db('rilbur5_school'))
	{
		//echo "\ndatabase selected";
		
		//VALIDATE inputs!
		
		//SELECT to see if username / email combo exists
		$queryResult=mysql_query('select * from USER where USERNAME="'.$_POST['username'].'" OR EMAIL="'.$_POST['email'].'"');
		if(!$queryResult)
			die("Select error: ".mysql_error());
		//echo "\n Number of rows is ".mysql_num_rows($queryResult);
		//$row=mysql_fetch_row($queryResult);
		if(mysql_numrows($queryResult)==0)
		{
		//if so, create session
			session_start();
			$query="INSERT INTO `USER` (`USERID`, `USERNAME`, `PASSWORD`, `NAME`, `EMAIL`, `COMPANY`, `PHONENUMBER`, `SECURITYQUESTION`, `SECURITYANSWER`, `ZIPCODE`, `ZIPCODEEXT`) values (NULL, '";
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
			print <<<HEREDOC
<HTML>
<HEAD><title>Access approved</title></head>
<p>
HEREDOC;
print $query;
print
<<<HEREDOC
</p>
</HTML>
HEREDOC;
		}
		else
		{
			//should check to see if username or email is already used, then report that
			echo 'return 404';
			
		}
	}
	else{
		die ('error, no connection'.mysql_error());
	}
	
	
	
	//close out connection
	mysql_close($link);

}

else
{
	// send 404 -- page not found
}

?>