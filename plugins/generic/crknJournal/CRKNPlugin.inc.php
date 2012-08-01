<?php

import('lib.pkp.classes.plugins.GenericPlugin');

class CRKNPlugin extends GenericPlugin {

  /**
  * Called as a plugin is registered to the registry
  * @param $category String Name of category plugin was registered to
  * @return boolean True iff plugin initialized successfully; if false,
  *      the plugin will not be registered.
  */
  function register($category, $path) {
    $success = parent::register($category, $path);
    if ($success && $this->getEnabled()) {
      HookRegistry::register('OAIDAO::_getRecords', array($this, 'filterEruditOAI'));
    }
    return $success;
  }

  function getDisplayName() {
    return __('plugins.generic.CRKN.displayName');
  }

  function getDescription() {
    return __('plugins.generic.CRKN.description');
  }
  
  /**
   * Set the page's breadcrumbs, given the plugin's tree of items
   * to append.
   * @param $subclass boolean
   */
  function setBreadcrumbs($isSubclass = false) {
    $templateMgr =& TemplateManager::getManager();
    $pageCrumbs = array(
      array(
        Request::url(null, 'user'),
        'navigation.user'
      ),
      array(
        Request::url(null, 'manager'),
        'user.role.manager'
      )
    );
    
    if ($isSubclass) $pageCrumbs[] = array(
      Request::url(null, 'manager', 'plugins'),
      'manager.plugins'
    );

    $templateMgr->assign('pageHierarchy', $pageCrumbs);
  }  
  
  /**
   * Display verbs for the management interface.
   */
  function getManagementVerbs() {
    $verbs = array();
    if ($this->getEnabled()) {
      $verbs[] = array('settings', __('plugins.generic.CRKN.manager.settings'));
    } 
    return parent::getManagementVerbs($verbs);
  }
  
  /**
   * Hook callback function 
   */
  function filterEruditOAI($hookName, $params) {
    $sql       =& $params[0];
    $sqlParams =& $params[1];
    $value     =& $params[2];

    $page = Request::getRequestedPage();
    if ($page == 'oai') {
      if (Request::getUserVar('metadataPrefix') == 'erudit') {
        $journalDao =& DAORegistry::getDAO('JournalDAO');
        $pluginSettingsDao =& DAORegistry::getDAO('PluginSettingsDAO');
        $journals =& $journalDao->getEnabledJournals();
        $journals =& $journals->toArray();
        $crknJournalIds = array();
        foreach ($journals as $journal) {
          if ($pluginSettingsDao->getSetting($journal->getId(), 'crknPlugin', 'CRKNJournal') == '1') {
            $crknJournalIds[] = $journal->getId();
          }
        }

        $sqlModification = " AND j.journal_id IN (" . join(",", $crknJournalIds) . ")";
        $sql = preg_replace("{ ORDER}", " $sqlModification ORDER", $sql);
        return false;
      }
    }
  }

  /**
   * Execute a management verb on this plugin
   * @param $verb string
   * @param $args array
   * @param $message string Result status message
   * @param $messageParams array Parameters for the message key
   * @return boolean
   */
  function manage($verb, $args, &$message) {
    if (!parent::manage($verb, $args, $message)) return false;
    
    switch ($verb) {
      case 'settings':
        $templateMgr =& TemplateManager::getManager();
        $templateMgr->register_function('plugin_url', array(&$this, 'smartyPluginUrl'));
        $journal =& Request::getJournal();
        
        $this->import('CRKNSettingsForm');
        $form = new CRKNSettingsForm($this, $journal->getId());
        
        if (Request::getUserVar('save')) {
          $form->readInputData();
          if ($form->validate()) {
            $form->execute();
            Request::redirect(null, 'manager', 'plugin');
            return false;
          } 
          else {
            $this->setBreadCrumbs(true);
            $form->display();
          }
        } // else, ! Request::getUserVar('save'):
        else {
          $this->setBreadCrumbs(true);
          $form->initData();
          $form->display();
        }
        return true;
        
      default:
        // Unknown management verb
        assert(false);
        return false;
    }
  }
}

?>
