<?php 

/**
 * @defgroup plugins_generic_cms
 */
 
/**
 * @file plugins/generic/cms/index.php
 *
 * Copyright (c) 2006-2007 Gunther Eysenbach, Juan Pablo Alperin, MJ Suhonos
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_generic_cms
 * @brief Wrapper for CMS plugin.
 *
 */

// $Id: index.php,v 1.10 2008/07/01 01:16:13 asmecher Exp $


require_once('CmsPlugin.inc.php'); 

return new CmsPlugin(); 

?> 
