<?php

/**
 * @file plugins/oaiMetadata/erudit/index.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup oai_format_erudit
 * @brief Wrapper for the OAI EruditArticle format plugin.
 *
 */

require_once('OAIMetadataFormatPlugin_Erudit.inc.php');
require_once('OAIMetadataFormat_Erudit.inc.php');

return new OAIMetadataFormatPlugin_Erudit();

?>
