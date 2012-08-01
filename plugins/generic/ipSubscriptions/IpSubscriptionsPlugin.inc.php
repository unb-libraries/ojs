<?php

/**
 * @file IpSubscriptionsPlugin.inc.php
 *
 * @class IpSubscriptionsPlugin
 */

import('lib.pkp.classes.plugins.GenericPlugin');

class IpSubscriptionsPlugin extends GenericPlugin {
  /**
   * Called when a plugin is registered in the registry
   *
   * @param $category
   *  String. Name of category plugin was registered in.
   * @return boolean
   *  True IFF plugin initialized successfully.  If false, the plugin will not
   *  be registered.
   */
  function register($category, $path) {
    $success = parent::register($category, $path);
    if ($success && $this->getEnabled()) {
      $this->import('IpSubscriptionsDAO');
      $ipDao = new IpSubscriptionsDAO($this->getName());
      $returner =& DAORegistry::registerDAO('IpSubscriptionsDAO', $ipDao);

      // Grant / deny access based on subscriber IP address
      HookRegistry::register('IssueAction::subscriptionRequired', array($this, 'validSubscriptionIp'));      
    }
    return $success;
  }
  
  function getDisplayName() {
    return __('plugins.generic.ipSubscriptions.name');
  }

  function getDescription() {
    return __('plugins.generic.ipSubscriptions.description');
  }
  

  /**
   * Hook callback function for IssueAction::subscriptionRequired
   */
  function validSubscriptionIp($hookName, $args) {
    $result =& $args[2];
    $ipDao = &DAORegistry::getDAO('IpSubscriptionsDAO');    

    if ($ipDao->isCRKNSubscriber(Request::getRemoteAddr())) {
      $result = false; // CRKN IP and past moving wall - subscription not required
      return true;
    }
    return false;
  }

}

?>
