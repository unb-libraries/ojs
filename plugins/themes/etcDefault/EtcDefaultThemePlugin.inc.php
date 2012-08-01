<?php

/**
 * @file EtcDefaultThemePlugin.inc.php
 *
 * Copyright (c) 2003-2008 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class EtcDefaultThemePlugin
 * @ingroup plugins_themes_etcDefault
 *
 * @brief Electronic Text Centre's default theme plugin
 */

// $Id: EtcDefaultThemePlugin.inc.php 12 2008-10-17 20:29:40Z jwhitney $


import('classes.plugins.ThemePlugin');

class EtcDefaultThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'EtcDefaultThemePlugin';
	}

	function getDisplayName() {
		return 'ETC Default Theme';
	}

	function getDescription() {
		return 'Electronic Text Centre\'s default theme';
	}

	function getStylesheetFilename() {
		return 'etcDefault.css';
	}

	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
