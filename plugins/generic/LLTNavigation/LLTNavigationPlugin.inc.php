<?php
/**
 * @file LLTNavigationPlugin.inc.php
 *
 * Copyright (c) 2003-2007 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @package plugins.generic.LLTNavigationPlugin
 * @class LLTNavigationPlugin
 *
 * $Id: LLTNavigationPlugin.inc.php,v 1.22 2007/10/30 23:06:05 jnugent Exp $
 */

import('lib.pkp.classes.plugins.GenericPlugin');

class LLTNavigationPlugin extends GenericPlugin {
  /**
   * Called as a plugin is registered to the registry
   * @param $category String Name of category plugin was registered to
   * @return boolean True iff plugin initialized successfully; if false,
   *  the plugin will not be registered.
   */
  function register($category, $path) {
    $success = parent::register($category, $path);
    if ($success && $this->getEnabled()) {
      HookRegistry::register('TemplateManager::display', array($this, 'redirectRequest'));
    }
    return $success;
  }
  
  function getDisplayName() {
    return __('plugins.generic.LLTNavigation.name');
  }

  function getDescription() {
    return __('plugins.generic.LLTNavigation.description');
  }
  
  /**
   * Hook callback function
   */
  function redirectRequest($hookName, $args) {
    $templateManager =& $args[0];
    $template =& $args[1];

    $page = Request::getRequestedPage();
    $user = Request::getUser();

    if (!$user || $user->getUsername() != 'administrator' ) {
      if ($page == 'user' || $page == 'about') {
        Request::redirectUrl('http://www.lltjournal.ca/index.php/llt');
      }
    }
    
    return false;
  }

}

?>
