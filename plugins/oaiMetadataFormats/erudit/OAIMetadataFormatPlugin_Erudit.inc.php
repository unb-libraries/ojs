<?php

/**
 * @file plugins/oaiMetadata/dc/OAIMetadataFormatPlugin_Erudit.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class OAIMetadataFormatPlugin_Erudit
 * @ingroup oai_format_erudit
 * @see OAI
 *
 * @brief EruditArticle metadata format plugin for OAI.  Fetches the stored XML off of disk and dynamically inserts
 * it into the OAI response body.
 */

import('classes.plugins.OAIMetadataFormatPlugin');

class OAIMetadataFormatPlugin_Erudit extends OAIMetadataFormatPlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'OAIMetadataFormatPlugin_Erudit';
	}

	function getDisplayName() {
		return __('plugins.oaiMetadata.erudit.displayName');
	}

	function getDescription() {
		return __('plugins.oaiMetadata.erudit.description');
	}

	function getFormatClass() {
		return 'OAIMetadataFormat_Erudit';
	}

	function getMetadataPrefix() {
		return 'erudit';
	}

	function getSchema() {
		return 'http://www.erudit.org/dtd/article/3.0.0/eruditarticle.dtd';
	}

	function getNamespace() {
		return 'http://www.erudit.org';
	}
}

?>
