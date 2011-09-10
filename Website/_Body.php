<?php

	function outputBody($title, $body)
	{
		?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><?php echo $title;?></title>
</head>

<body>
<?php echo $body;?>
</body>

</html>
		<?php
	}


?>