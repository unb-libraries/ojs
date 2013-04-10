<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xlink"
                version="1.0">
<xsl:output  method="xhtml" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes"
                 />
  <xsl:template match="/"><html>
<head>
<title><xsl:call-template name="titleTemplate" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />


</head>
<body>



<div id="body">
<xsl:apply-templates/>
</div>
</body>
</html>
</xsl:template>

<!-- Article header information -->

<xsl:template match="admin/infoarticle"/>
<xsl:template match="admin/revue/idissn"/>
 <xsl:template match="admin/revue/idissnnum"/>
 <xsl:template match="admin/revue/directeur"/>
 <xsl:template match="admin/revue/redacteurchef"/>
<xsl:template match="admin/numero"/>
<xsl:template match="admin/editeur"/>
<xsl:template match="admin/prodnum"/>	
<xsl:template match="admin/diffnum"/>
<xsl:template match="admin/titrerev"/>
<xsl:template match="admin/titrerevabr"/>
 <xsl:template match="admin/prod"/>

<xsl:template match="admin/droitsauteur"/>

<!-- Introductory information including article title, author, abstract --> 

<xsl:template match="liminaire/grtitre">

<!--

<br /><xsl:apply-templates/><br />


-->

  <xsl:choose>
  <xsl:when test="./trefbiblio!=''">
    <p><b><xsl:value-of select="trefbiblio" /></b></p>
  </xsl:when>
  <xsl:otherwise>
    <h3>
      <xsl:if test="surtitre!=''">
         <xsl:value-of select="surtitre" /><br />
      </xsl:if>
      <xsl:if test="titre!=''">
        <!-- <xsl:value-of select="titre" /><br /> -->
        <xsl:apply-templates select="titre" /><br />
      </xsl:if>
      <xsl:if test="sstitre!=''">
         <xsl:value-of select="sstitre" />
      </xsl:if>
    </h3>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="titleTemplate">
    <xsl:choose>
  <xsl:when test="/article/liminaire/grtitre/trefbiblio!=''">
    <xsl:value-of select="/article/liminaire/grtitre/trefbiblio" />
  </xsl:when>
  <xsl:otherwise>

      <xsl:if test="/article/liminaire/grtitre//surtitre!=''">
         <xsl:value-of select="/article/liminaire/grtitre//surtitre" /> - 
      </xsl:if>
      <xsl:if test="/article/liminaire/grtitre//titre!=''">
         <xsl:value-of select="/article/liminaire/grtitre//titre" /> - 
      </xsl:if>
      <xsl:if test="/article/liminaire/grtitre//sstitre!=''">
         <xsl:value-of select="/article/liminaire/grtitre//sstitre" />
      </xsl:if>

  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
<xsl:template match="liminaire/grtitre/titre">
 <h3><xsl:apply-templates/></h3>
</xsl:template>
-->
<xsl:template match="liminaire/grtitre/sstitre">
<!--  <xsl:if test=".!=''">
     <h3><xsl:apply-templates/></h3>
  </xsl:if>
 -->
 </xsl:template>
 
 <xsl:template match="liminaire/grtitre/trefbiblio">
<!--	<xsl:if test=".!=''">
		<b><xsl:apply-templates/></b>
	</xsl:if>
 -->
</xsl:template>

<xsl:template match="liminaire/grauteur">
<xsl:apply-templates/><br />
</xsl:template>

<xsl:template match="liminaire/grauteur/auteur">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="liminaire/grauteur/auteur//prefixe">
<xsl:if test=".!=''"><xsl:apply-templates/> </xsl:if>
</xsl:template>

<xsl:template match="liminaire/grauteur/auteur//autreprenom">
<xsl:text> </xsl:text><xsl:apply-templates/>
</xsl:template>

<xsl:template match="liminaire/grauteur/auteur//nomfamille">
<xsl:text> </xsl:text><xsl:apply-templates/>
</xsl:template>

<xsl:template match="liminaire/grauteur/auteur/affiliation">
<br /><xsl:apply-templates/><br />
</xsl:template>


<xsl:template match="liminaire//courriel">
<xsl:apply-templates/><br />
</xsl:template>

<xsl:template match="liminaire//motcle">
<xsl:apply-templates/><xsl:text> </xsl:text>
</xsl:template>	




<!--- following templates for extended links for notes -->

<xsl:template match="renvoi[@idref]">

  <xsl:variable name="noteId" select="@id" />

  <xsl:variable name="lienToNote" select="//lien[@xlink:from=$noteId]" />
  <a>
     <xsl:attribute name="href">#<xsl:value-of select="$lienToNote/@xlink:to" /></xsl:attribute>
     <xsl:attribute name="title"><xsl:value-of select="$lienToNote/@xlink:title" /></xsl:attribute> 
     <xsl:attribute name="id"><xsl:value-of select="$lienToNote/@xlink:from" /></xsl:attribute>
     <xsl:apply-templates/>
  </a></xsl:template>   
         
 <xsl:template match="note[@id]">


      <xsl:variable name="noteId" select="@id" />
      <xsl:variable name="lienFromNote" select="//lien[@xlink:from=$noteId]" />

      <div>
       <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
       <a><xsl:attribute name="href">#<xsl:value-of select="$lienFromNote/@xlink:to" /></xsl:attribute>
          <xsl:attribute name="title"><xsl:value-of select="$lienFromNote/@xlink:title" /></xsl:attribute><xsl:value-of select="no" /></a> <xsl:text> </xsl:text>
      <xsl:apply-templates/></div><br />
</xsl:template>   

<xsl:template match="note/no"/>
<!-- <xsl:apply-templates/><xsl:text> </xsl:text>
</xsl:template> -->

<xsl:template match="note//alinea">
<xsl:text> </xsl:text> <xsl:apply-templates/>
</xsl:template> 


<!-- end templates for extended links for notes -->


<!-- Simple links -->


 <xsl:template match="liensimple[@xlink:href]">
  <a><xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
<xsl:apply-templates/>  
  </a>
  </xsl:template>


<!-- texte -->

<xsl:template match="//texte"/>




<!-- Bibliographic entries -->

<xsl:template match="divbiblio/titre">
<b><p><xsl:apply-templates/></p></b>
</xsl:template>

<xsl:template match="refbiblio">
<p><xsl:apply-templates/></p>
</xsl:template>




<!-- Lists -->

<xsl:template match="listenonord[@signe='carre']">
<ul type="square"><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="listenonord[@signe='disque']">
<ul type="disc"><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="listenonord[@signe='cercle']">
<ul type="circle"><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="listenonord[@signe='nul']">
<ul class="nodisplay"><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="listenonord[@signe='tiret']">
	<ul class="dash">
		<xsl:apply-templates/>
	</ul>
</xsl:template>

<xsl:template match="listenonord">
	<ul><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="elemliste">
<li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="listeord[@numeration='lettremin']">
<ol type="a"><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="listeord[@numeration='decimal']">
<ol type="1"><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="listeord[@numeration='lettremaj']">
<ol type="A"><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="listeord[@numeration='romainmaj']">
<ol type="I"><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="listeord[@numeration='romainmin']">
<ol type="i"><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="listeord">
	<xsl:apply-templates/>
</xsl:template>


<!-- Poetry -->

<!-- Keep?

<xsl:template match="ligne">
<xsl:apply-templates/><br />
</xsl:template>

<xsl:template match="bloc">
<xsl:apply-templates/><br /><br />
</xsl:template>

-->

<!-- Dedications -->

<xsl:template match="dedicace">
<p><xsl:apply-templates/></p>
</xsl:template>

<!-- Sections -->

<xsl:template match="section1/titre">
<p><b><xsl:apply-templates/></b><!--(<a><xsl:attribute name="style">font-size:0.6em;</xsl:attribute><xsl:attribute name="href">#toc</xsl:attribute>TOP</a>)--></p>
</xsl:template> 

<xsl:template match="section2/titre">
<p><b><xsl:apply-templates/></b></p>
</xsl:template> 

<xsl:template match="section3/titre">
<p><xsl:apply-templates/></p>
</xsl:template> 

<xsl:template match="section4/titre">
<p><xsl:apply-templates/></p>
</xsl:template> 

<xsl:template match="section5/titre">
<p><xsl:apply-templates/></p>
</xsl:template> 

<xsl:template match="section6/titre">
<p><xsl:apply-templates/></p>
</xsl:template> 


<xsl:template match="section1">
   <div><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:apply-templates />                                                    
   </div>
</xsl:template>

<xsl:template match="section2">
   <div><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:apply-templates />
 </div>
</xsl:template>

<xsl:template match="section3">
   <div><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:apply-templates />
 </div>
</xsl:template>

<xsl:template match="section4">
   <div><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:apply-templates />
 </div>
</xsl:template>



<xsl:template match="section1/no"/>
<xsl:template match="section2/no"/>
<xsl:template match="section3/no"/>
<xsl:template match="section4/no"/>
<xsl:template match="section5/no"/>



<!-- Abstract -->

<xsl:template match="resume/titre">
<p><b><xsl:apply-templates/></b></p>
</xsl:template>


<!-- Paragraphs -->



<xsl:template match="para">
   <p><xsl:apply-templates /></p>
</xsl:template>


<xsl:template match="para/no">
<span class="nopara"><xsl:apply-templates/></span><xsl:text> </xsl:text>
</xsl:template>




<xsl:template match="bloccitation">
<span class="block"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="epigraphe">
<span class="block"><xsl:apply-templates/></span>
</xsl:template>

<!-- Possibly take out -->

<xsl:template match="epigraphe/alinea">
<span class="para"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="verbatim">
<span class="block"><xsl:apply-templates/></span>
</xsl:template>

<!-- Possibly take out -->

<xsl:template match="verbatim/bloc">
<xsl:apply-templates/><br />
</xsl:template>

<!-- Possibly take out -->

<xsl:template match="verbatim/bloc/ligne">
<xsl:apply-templates/><br />
</xsl:template>


<!-- Typographic features -->


<xsl:template match="marquage">
  <xsl:if test=".!=''">
  
  <xsl:variable name="style"><xsl:value-of select="@typemarq" /></xsl:variable>

  <xsl:choose>
     <xsl:when test="$style='italique'">
       <em><xsl:apply-templates /></em>
     </xsl:when>
     <xsl:when test="$style='gras'">
       <strong><xsl:apply-templates /></strong>
     </xsl:when>
     <xsl:when test="$style='souligne'">
       <u><xsl:apply-templates /></u>
     </xsl:when>
         
     
     <xsl:otherwise>
         <xsl:apply-templates />
     </xsl:otherwise>
  </xsl:choose> 
  </xsl:if>
</xsl:template>


<xsl:template match="marquage[@typemarq='gras']">
  <strong><xsl:apply-templates /></strong>
</xsl:template>


<xsl:template match="exposant">
<sup><xsl:apply-templates/></sup>
</xsl:template>

<xsl:template match="indice"><sub><xsl:apply-templates/></sub></xsl:template>







<!--  Back matter -->

<xsl:template match="partiesann/grnote/titre">
<p><b><xsl:apply-templates/></b></p>
</xsl:template>

<xsl:template match="partiesann/biblio/titre">
<p><b><xsl:apply-templates/></b></p>
</xsl:template>

<xsl:template match="partiesann/merci/titre">
<p><b><xsl:apply-templates/></b></p>
</xsl:template>

<!-- Possibly Take Out -->

<xsl:template match="partiesann/merci/alinea">
<span class="para"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="partiesann/annexe//titre">
<p><b><xsl:apply-templates/></b></p>
</xsl:template>







<!-- Table of Contents -->


<xsl:template name="ToC">

  <div id="ToC">
   <h2>Table of Contents</h2>

   <xsl:for-each select="//liminaire/grtitre/titre">
     <p><a><xsl:attribute name="href">#s1n1</xsl:attribute><xsl:value-of select="." /></a></p>
   </xsl:for-each>

   <xsl:for-each select="//corps/section1/section2/titre">
   <p><a><xsl:attribute name="href">#<xsl:value-of select="../@id" /></xsl:attribute><xsl:value-of select="." /></a></p>
   </xsl:for-each>


   <xsl:for-each select="//partiesann/grnote/titre">
     <p><a><xsl:attribute name="href">#no1</xsl:attribute><xsl:value-of select="." /></a></p>
   </xsl:for-each>
 </div>

</xsl:template>

<!-- Images / Figures-->


<xsl:template match="tableau/no"/>
<!-- <p><xsl:apply-templates/></p>
</xsl:template> -->

<xsl:template match="figure/no"/>
<!-- <p><xsl:apply-templates/></p>
</xsl:template> -->

<xsl:template match="figure/legende/titre">
<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="tableau/legende/titre">
<p><xsl:apply-templates/></p>
</xsl:template>

<!--
<xsl:template match="legendealinea">
<p><xsl:apply-templates/></p>
</xsl:template>
-->

<!--<xsl:template match="source">
<p><xsl:apply-templates/></p>
</xsl:template>-->

<xsl:template match="objetmedia/image">
<p>

 <xsl:variable name="typeimage"><xsl:value-of select="@typeimage" /></xsl:variable>

  <xsl:choose>

     <xsl:when test="$typeimage='equation'">

       <xsl:variable name="imgId" select="@id" />

       <!-- select the pointeur node which has an xlink:label that defines our fullsize image, and store it in a variable -->
       <xsl:variable name="pointeurFull" select="//pointeur[@xlink:label=concat($imgId, 'n')]" />

       <!-- use both images to generate the link and the img tag of our thumbnail -->
       <img src="http://journals.hil.unb.ca/{$pointeurFull/@xlink:href}" alt="{$pointeurFull/@xlink:title}" border="0" />

     </xsl:when>

  <xsl:otherwise>

     <xsl:variable name="imgId" select="@id" />

     <!-- select the pointeur node which has an xlink:label that defines our thumbnail image, and store it in a variable -->
     <xsl:variable name="pointeurThumb" select="//pointeur[@xlink:label=concat($imgId, 't')]" />

     <!-- select the pointeur node which has an xlink:label that defines our fullsize image, and store it in a variable -->
     <xsl:variable name="pointeurFull" select="//pointeur[@xlink:label=concat($imgId, 'n')]" />

     <!-- now, select the lien node which links from our thumbnail to our fullsize image -->
     <xsl:variable name="lienTtoF" select="//lien[@xlink:to=concat($imgId, 'n')]" />

     <!-- use both images to generate the link and the img tag of our thumbnail -->
     <img src="http://journals.hil.unb.ca/Texts/XSLT/thumb.php?{$pointeurThumb/@xlink:href}" alt="{$pointeurThumb/@xlink:title}" border="0" /> <br />
     <a href="{$pointeurFull/@xlink:href}"><xsl:value-of select="$lienTtoF/@xlink:title" /></a>

  </xsl:otherwise>

 </xsl:choose>
     
</p>

</xsl:template>

	



</xsl:stylesheet>

