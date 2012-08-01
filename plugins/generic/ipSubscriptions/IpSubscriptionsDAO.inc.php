<?php
/**
 * @file IpSubscriptionsDAO.inc.php
 *
 * @class IpSubscriptionsDAO
 *
 * @brief Operations for querying CRKN IP data.
 */

import('lib.pkp.classes.db.DAO');

class IpSubscriptionsDAO extends DAO {
  /** @var $parentPluginName string Name of parent plugin */
  var $parentPluginName;
  
  /**
   * Constructor.
   */
  function IpSubscriptionsDAO($parentPluginName) {
    $this->parentPluginName = $parentPluginName;
    parent::DAO();
  }

  /**
   * Determine if $ip falls within ranges defined for CRKN subscribers
   *
   * @param $ip string
   * @return boolean
   */
  function isCRKNSubscriber($ip) {
    $isSubscriber = FALSE;

    // Convert to IP string to integer
    $integer_ip = (substr($ip, 0, 3) > 127) ? ((ip2long($ip) & 0x7FFFFFFF) + 0x80000000) : ip2long($ip);

    $result =& $this->retrieve(
      'SELECT ip FROM crkn_ips WHERE start <= ? AND ? <= end',
      array($integer_ip, $integer_ip)
    );

    // No returner: we only verify presence / absence of IP
    if ($result->RecordCount() != 0) {
      $isSubscriber = TRUE;
    }
    $result->Close();
    
    return $isSubscriber;
  }
}

?>
