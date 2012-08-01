<?php

/**
 * @defgroup plugins_themes_etcDefault
 */
 
/**
 * @file plugins/themes/etcDefault/index.php
 *
 * Copyright (c) 2003-2008 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_themes_etcDefault
 * @brief Wrapper for Electronic Text Centre's default theme plugin.
 *
 */

// $Id: index.php 12 2008-10-17 20:29:40Z jwhitney $


require_once('EtcDefaultThemePlugin.inc.php');

return new EtcDefaultThemePlugin();

?>
