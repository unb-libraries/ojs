<?php

/**
 * @defgroup oai_format_erudit
 */

/**
 * @file classes/oai/format/OAIMetadataFormat_Erudit.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class OAIMetadataFormat_Erudit
 * @ingroup oai_format
 * @see OAI
 *
 * @brief OAI metadata format class -- EruditArticle
 */


// Location of Erudit source XML
// @todo plugin configuration setting?
define ('ERUDIT_SOURCE_DIR', '/etcdata/journals/etc_journals');

class OAIMetadataFormat_Erudit extends OAIMetadataFormat {

  /**
   * @see OAIMetadataFormat#toXml
   */
  function toXml(&$record, $format = null) {

    $journal =& $record->getData('journal');
    $article =& $record->getData('article');
    
    // Begin OAI response
    $response = '';

    // Add URIs for each of the article's galleys
    foreach ($article->getGalleys() as $galley) {
      $response .= 
        $this->formatSelfUri(
          Request::url($journal->getPath(), 'article', 'view',  array($article->getBestArticleId(), $galley->getId()) ),
          $galley->getFileType()
        );
    }

    // Next, determine the Erudit XML filename we expect for this article
    $eruditXmlFileName = $this->getEruditXmlFileName($article->getId());
    
    if (! $eruditXmlFileName) {
      trigger_error("Can't identify Érudit XML file for article ID $articleId");
      $response .= $this->formatError("No metadata available.");
      return $response;
    }

    // Locate the Erudit XML file 
    $eruditXmlFiles = $this->findFiles(ERUDIT_SOURCE_DIR, $eruditXmlFileName);

    if (! sizeof($eruditXmlFiles)) {
      trigger_error("Érudit XML file '$eruditXmlFileName' not found for article ID $articleId");
      $response .= $this->formatError("No metadata available.");
      return $response;
    }
    
    // @todo what if there are multiple files?
    // For now, grab the first file in list
    $eruditXml = file_get_contents($eruditXmlFiles[0]);

    if (! $eruditXml) {
      trigger_error("Can't read Érudit XML file '$eruditXmlFileName' for article ID $articleId");
      $response .= $this->formatError("No metadata available.");
      return $response;
    }
    
    // Add Erudit XML to response
    $response .= $this->formatEruditArticle($eruditXml);
    
    // That's it.
    return $response;  
	}
	
	/**
	* Element <self-uri> identifies alternate versions of this document: in this
	* case, HTML and/or PDF galleys.
	*/
	private function formatSelfUri($href, $contentType) {
    $selfUri = '<self-uri ' . 
                  'xmlns:xlink="http://www.w3.org/1999/xlink" ' . 
                  'content-type="' . htmlspecialchars(Core::cleanVar($contentType)) . '" ' .
                  'xlink:href="' . htmlspecialchars(Core::cleanVar($href)) . '" ' .
                '/>';
                
    return $selfUri;
  }
  
  /** 
   * Element <article> is Erudit Article 3.0 DTD -compliant XML
   */
 private function formatEruditArticle($eruditXml) {
   // Strip XML, doc type declarations, etc. from XML source, and 
   // return <article> element
   return preg_replace("{^.*?<article}is", "<article", $eruditXml);
 }
 
  /**
   * Element <error> adds an error message to the response
   */
  private function formatError($errorMessage) {
    return "<error>$errorMessage</error>";
  }
  
  // Erudit XML files *should* follow the naming convention used for PDF and
  // HTML galley filenames, i.e.,
  // [journal_id][vol](_[issue](_[part])?)?[article_type_id][article_no].[pdf|html]
  // 
  // E.g., 
  //  ageo47art07.html     => AGEO Vol. 47, article 07, HTML galley
  //  scl36_1art05.pdf     => SCL Vol. 36, Issue 1, article 05, PDF galley
  //  tric30_1_2art03.html => TRIC Vol. 30, Issue 1, part 2, article 03, HTML galley
  //
  // For the galleys above, we should be able to locate these XML files:
  //  ageo47art07.xml
  //  scl36_1art05.xml
  //  tric30_1_2art03.xml
  //
  private function getEruditXmlFileName($articleId) {

    $articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
    $articleFiles = $articleFileDao->getArticleFilesByArticle($articleId);

    // First parenthesized subpattern captures filename excluding extension.    
    $fileNameRegExp = "/^([A-Za-z]+\d+_?(\d+)?(_\d+)*[a-z]+\d+)\.(pdf|html)$/";

    // Examine files with type = 'public' to find a candidate galley upon
    // which to base the search for the corresponding Erudit XML file. 
    
    $eruditXmlFileName = '';
    
    foreach ($articleFiles as $articleFile) {
      // We're only interested in public galleys
      if ($articleFile->getType() == 'public') {

        // Galley filenames may have been changed to follow naming convention:
        // filter out any that don't correspond.
        if (preg_match($fileNameRegExp, $articleFile->getOriginalFileName(), $matches)) {
          
          // Seems fine.  Build Erudit XML filename 
          $eruditXmlFileName = $matches[1] . ".xml";
          break;
        }
      }

    } // end foreach ($articleFiles as $articleFile)
    
    return $eruditXmlFileName;
  }
  
  // Return a list of file names matching $pattern in $path or its subdirectories
  private function findFiles($dir, $pattern) {
    $dir = escapeshellcmd($dir);
    $files = glob("$dir/$pattern");
    
    // Get sub-directories in current directory. Ignore hidden directories.
    foreach (glob("$dir/*", GLOB_ONLYDIR) as $subdir) {
      $subdirFiles = $this->findFiles($subdir, $pattern);  // resursive call
      $files = array_merge($files, $subdirFiles); // merge array with files from subdirectory
    }
    
    return $files;
  }
}
?>
