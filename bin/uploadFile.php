<?

	$filename = $_POST["accessToken"]."test.mp3"; // get the filename
	$file = base64_decode($_POST["audioFile"]); // get bytearray

	$fp = fopen( $filename, 'w+' ); // create the file for writing

	fwrite( $fp, $file ); // create the image

	fclose( $fp );
	
	echo $filename;

?>
HOLA