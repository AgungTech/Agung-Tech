<?php
/*
	Agung Tech Development web framework
	copyright (c) 2015-2016 Agung Tech Development
		web:  www.Agung-Tech.blogspot.com
		mail: hudamaruf@gmail.com

	$Id: resume.php,v 0.0.1 dd/mm/yyyy hh:mm:ss agung Exp $
	description
*/

// dependencies
$upload_folder_temp = "upload/temp/";
$upload_folder_final = "upload/dokumen/";

$admin_notify_email = array(
	"to"		=> "hudamaruf@gmail.com",
	"to_name"	=> "Huda Ma'ruf",

	"from"		=> "{EMAIL}",
	"from_name"	=> "{NAME}",

	"subject"	=> "Anda Menerima Pesan Data Baru",
	"body"		=> <<<EOD
	<p>Letakkan isi pesan disini !</p>
	<p>
		Name: {NAME}<br>
		Email: {EMAIL}<br>
		Phone: {PHONE}<br>
		Attachment: {ATTACHMENT}
		Message <BR>
		{NOTE}
	</p>
EOD
);

$autoresponder_email = array(
	"enable"	=> true,

	"to"		=> "{EMAIL}",
	"to_name"	=> "{NAME}",

	"from"		=> "hudamaruf@gmail.com",
	"from_name" => "Huda Ma'ruf",

	"subject"	=> "Terimakasih telah menghubungi kami",
	"body"		=>  <<<EOD
	<p>Letakkan isi pesan disini</p>
	<p>
		Name: {NAME}<br>
		Email: {EMAIL}<br>
		Phone: {PHONE}<br>
		Message <BR>
		{NOTE}
	</p>
EOD
);


require_once "lib/kirim_pesan.php";
require_once "lib/project.php";

$url = 	dirname((strtoupper($_SERVER["HTTPS"]) == "on" ? "https://" :  "http://") . 
		$_SERVER["HTTP_HOST"] . 
		($_SERVER["SERVER_PORT"] != 80 ? ':' . $_SERVER["SERVER_PORT"] : '') .
		$_SERVER["SCRIPT_NAME"] ) . "/" . $upload_folder_final;	 


if (is_array($_FILES["Filedata"])) {

	if (!$_FILES["Filedata"]["error"]) {
		move_uploaded_file($_FILES["Filedata"]["tmp_name"] , $upload_folder_temp . "resume-" . $_FILES["Filedata"]["name"]);
	}			
	die();
}

	
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$vars = array(
		"name" => stripslashes($_POST["name"]),
		"email" => stripslashes($_POST["email"]),
		"phone" => stripslashes($_POST["phone"]),
		"note" => nl2br(stripslashes($_POST["message"])),
	);


	//process the image if needed
	if ($_POST["file"] != "nofile") {
		//process the file

		$file_name = time() . "-" . $_POST["file"];

		if (file_exists($upload_folder_temp . "resume-" . $_POST["file"])) {
			rename($upload_folder_temp . "resume-" . $_POST["file"] , $upload_folder_final . $file_name );
			chmod($upload_folder_final . $file_name , 0777);
		}

		$vars["attachment"] = $url. $file_name;
	} else 
		$vars["attachment"] = "none";	

	//process the notify email
	$email = array(
		"email_to"			=> $admin_notify_email["to"],
		"email_to_name"		=> $admin_notify_email["to_name"],

		"email_from"		=> $admin_notify_email["from"],
		"email_from_name"	=> $admin_notify_email["from_name"],

		"email_subject"		=> $admin_notify_email["subject"],
		"email_body"		=> $admin_notify_email["body"],
		"email_type"		=> "html"
	);

	foreach ($email as $key => $val) {
		$email[$key] = CTemplateStatic::Replace($val , $vars);
	}

	SendMail($email);

	echo "<table><tr><td><pre style=\"background-color:white\">";
	print_r($email);
	echo "</pre></td></tr></table>";

	//process the autoresponder email

	if ($autoresponder_email["enable"] == true) {
		$email = array(
			"email_to"			=> $autoresponder_email["to"],
			"email_to_name"		=> $autoresponder_email["to_name"],

			"email_from"		=> $autoresponder_email["from"],
			"email_from_name"	=> $autoresponder_email["from_name"],

			"email_subject"		=> $autoresponder_email["subject"],
			"email_body"		=> $autoresponder_email["body"],
			"email_type"		=> "html"
		);

		foreach ($email as $key => $val) {
			$email[$key] = CTemplateStatic::Replace($val , $vars);
		}

		SendMail($email);
	}

	echo "<table><tr><td><pre style=\"background-color:white\">";
	print_r($email);
	echo "</pre></td></tr></table>";

	echo "status=ok";
	die();

}

echo "status=false";
die();

?>
