<?php

/**
 * @file StatisticsAggregationSettingsForm.inc.php
 *
 * Copyright (c) 2003-2010 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class CRKNSettingsForm
 * @ingroup plugins_generic_CRKN
 *
 * @brief Form for journal managers to add / remove journals from CRKN bundle
 */

// $Id$

import('lib.pkp.classes.form.Form');

class CRKNSettingsForm extends Form {

  /** @var $journalId int */
  var $journalId;

  /** @var $plugin object */
  var $plugin;

  /**
   * Constructor
   * @param $plugin object
   * @param $journalId int
   */
  function CRKNSettingsForm(&$plugin, $journalId) {
    $this->journalId = $journalId;
    $this->plugin =& $plugin;

    parent::Form($plugin->getTemplatePath() . 'settingsForm.tpl');
  }

  /**
   * Initialize form data.
   */
  function initData() {
    $journalId = $this->journalId;
    $plugin =& $this->plugin;

    $this->_data = array(
      'CRKNJournal' => $plugin->getSetting($journalId, 'CRKNJournal')
    );
  }

  /**
   * Assign form data to user-submitted data.
   */
  function readInputData() {
    $this->readUserVars(array('CRKNJournal'));
  }

  /**
   * Save settings.
   */
  function execute() {
    $plugin =& $this->plugin;
    $journalId = $this->journalId;

    $plugin->updateSetting($journalId, 'CRKNJournal', trim($this->getData('CRKNJournal'), "\"\';"), 'string');
  }
}

?>
