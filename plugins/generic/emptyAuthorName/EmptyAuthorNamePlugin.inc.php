<?php

import('lib.pkp.classes.plugins.GenericPlugin');

class EmptyAuthorNamePlugin extends GenericPlugin {
  /**
   * Called as a plugin is registered to the registry
   * @param $category String Name of category plugin was registered to
   * @return boolean True iff plugin initialized successfully; if false,
   *      the plugin will not be registered.
   */
  function register($category, $path) {
    $success = parent::register($category, $path);
    if ($success && $this->getEnabled()) {
      HookRegistry::register('metadataform::validate', array($this, 'callbackSaveMetadata')); 
    }
    return $success;
  }

  function getDisplayName() {
    return __('plugins.generic.emptyAuthorName.displayName');
  }

  function getDescription() {
    return __('plugins.generic.emptyAuthorName.description');
  }

  /*
   * this hook interecepts the Action::saveMetadata hook called by saveMetadata in classes/submission/common/Action.inc.php.
   * $params contains one argument - the Article object being saved.
   * The callback removes the author email constraint if it detects it in the list of Form errors.
   */
  function callbackSaveMetadata($hookName, $params) {
    $metadataForm =& $params[0];
    if (isset($metadataForm->errorFields['authors'])) {
      $errorIndex = 0;
      foreach ($metadataForm->_errors as $field => $formError) {
        if ($formError->field == 'authors'){
          unset($metadataForm->_errors[$errorIndex]);
        }
        $errorIndex++;
      }
    }

    return false;
  }
}
?>
