{**
 * settingsForm.tpl
 *
 * Copyright (c) 2003-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * CRKN plugin settings
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="plugins.generic.CRKN.manager.CRKNSettings"}
{include file="common/header.tpl"}
{/strip}
<div id="CRKNSettings">
<div id="description">{translate key="plugins.generic.CRKN.manager.settings.description"}</div>

<div class="separator"></div>

<br />

<form method="post" action="{plugin_url path="settings"}">
{include file="common/formErrors.tpl"}

<table width="100%" class="data">
	<tr valign="top">
		<td width="30%" class="label">{fieldLabel name="CRKNJournal" required="true" key="plugins.generic.CRKN.manager.settings.CRKNJournal"}</td>
		<td width="70%" class="value"><input type="checkbox" name="CRKNJournal" id="CRKNJournal" value="1" {if $CRKNJournal} checked="checked"{/if} class="checkbox" /></td>
	</tr>
</table>

<br/>

<input type="submit" name="save" class="button defaultButton" value="{translate key="common.save"}"/><input type="button" class="button" value="{translate key="common.cancel"}" onclick="history.go(-1)"/>
</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</div>
{include file="common/footer.tpl"}
