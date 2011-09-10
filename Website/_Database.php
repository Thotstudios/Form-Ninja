<?php
//This file provides functions that produce a link to the database.

//It relies on _Constants.php for the necessary information
require_once('_Constants.php');

function get_updater_MYSQL(){
	static $updater_MYSQL;
	if (isset($updater_MYSQL))
		return $updater_MYSQL;
	else
	{
		$updater_MYSQL=new mysqli($GLOBALS['db_host'],$GLOBALS['updater_login'],$GLOBALS['updater_password'],$GLOBALS['db_name']);
		return $updater_MYSQL;
	}
}

function get_user_MYSQL(){
	static $user_DB;
	if (isset($user_DB))
		return $user_DB;
	else
	{
		$user_DB=new mysqli($GLOBALS['db_host'],$GLOBALS['selector_login'],$GLOBALS['selector_password'],$GLOBALS['db_name']);
		return $user_DB;
	}
}

function prepStringForSQL($string)
{
	$selector=get_user_MYSQL();
	return $selector->real_escape_string($string);
}

?>