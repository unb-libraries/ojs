<?php
  /*
   * creates a PNG thumbnail, based on an image handed to it, and width and height parameters
   */

  error_reporting(E_ERROR);

  function createThumbnail($tmp_path, $smallest_measurement) {
    $size = GetImageSize($tmp_path);
    switch ($size[2]) {
      case 2:
            $source_im = ImageCreateFromJPEG($tmp_path);
            break;
      case 3:
            $source_im = ImageCreateFromPNG($tmp_path);
            break;
    }


    $width  = imagesx($source_im);
    $height = imagesy($source_im);


    if (imagesx($source_im) <= imagesy($source_im) && imagesx($source_im) > $smallest_measurement) {

      $width  = $smallest_measurement;
      $ratio  = $smallest_measurement/imagesx($source_im);
      $height = round(imagesy($source_im) * $ratio);


    } else if (imagesy($source_im) < imagesx($source_im) && imagesy($source_im) > $smallest_measurement) {


      $height = $smallest_measurement;
      $ratio = $smallest_measurement/imagesy($source_im);
      $width = round(imagesx($source_im) * $ratio);
    } 

    // occasionally, images  are less than 200 high and are still way too wide.
    if ($width >= 600) {
      $width = 550;
      $ratio = 550/$width;
      $height = round($height * $ratio);  
    }


    if (isset($source_im) && $source_im) {
      $thumb = ImageCreateTrueColor($width, $height);
      ImageCopyResampled($thumb, $source_im, 0, 0, 0, 0, $width, $height, $size[0], $size[1]);   
      return ImagePNG($thumb);
    } else
       return false;
  }

  unset ($img);
  $img = $_SERVER['QUERY_STRING'];

  $img = str_replace("..", "", $img);
  $img = "/var/www/journals.lib.unb.ca/htdocs" . $img;

 header("Content-type: image/png");
if (file_exists($img)) {
	print createThumbnail($img, 200); 
}

?>
