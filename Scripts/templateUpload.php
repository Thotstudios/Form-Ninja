<?PHP
//insure HTTPS, otherwise 404

//Start json array
$response = array();

//Check for post data
if($_POST['userID'] && $_POST['templateData']){

	//login to database
	$link = mysql_connect('localhost', 'though16_ninja', 'o0nxunH(USa,');
	if(!$link){
		$response['uploaded'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		exit;
	}
	
	
	if(mysql_select_db('though16_formninja')){
		$query= "INSERT INTO TEMPLATE (DATA) values ('".$_POST['templateData']."')";
		$queryResult=mysql_query($query);

		
		if(!$queryResult){
			$response['uploaded'] = 'False';
			$response['error'] = "Database insert error";
			print json_encode($response);
			exit;
		}
		
		else{
			$templateID = mysql_insert_id();
			$response['templateID'] = $templateID;
			
			$query= 'INSERT INTO UserTemplateLookup (UserID,TemplateID) values 
				("'.$_POST['userID'].'", "'.$templateID.'")';
			$queryResult=mysql_query($query);
			
			
			if(!$queryResult){
				$response['uploaded'] = 'False';
				$response['error'] = "Database insert error";
				print json_encode($response);
				exit;
			}
			
			else{
				$response['uploaded'] = 'True';
				print json_encode($response);
				exit;
			}
		}
	}
	
	
	else{
		$response['uploaded'] = 'False';
		$response['error'] = 'Database connection error';
		print json_encode($response);
		exit;
	}

}


else{
	$response['uploaded'] = 'False';
	$response['error'] = 'No valid userID or template data sent';
	print json_encode($response);
}

?>