<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xlink xd" version="2.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>Converts journal articles encoded according to Érudit Article 3.0 DTD to XHTML 1.0 Strict.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:output 
    encoding="UTF-8"
    method="xhtml"
    omit-xml-declaration="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
  
  <xsl:strip-space elements="*"/>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Global variables: OJS base URL; default is <xd:i><xd:a href="http://journals.hil.unb.ca">http://journals.hil.unb.ca</xd:a></xd:i></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="OJS_BASE_URL" select="string('http://journals.hil.unb.ca')"/>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Global variables: path to PHP thumbnail generator; default is <xd:i><xd:a href="http://journals.hil.unb.ca">http://journals.hil.unb.ca/Texts/XSLT/thumb.php</xd:a></xd:i></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="THUMBNAIL_GENERATOR_URL" select="concat($OJS_BASE_URL, '/Texts/XSLT/thumb.php')"/>

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document template: Generates HTML document then selects front matter, body, and back matter.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:call-template name="get-metadata-title"/></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      </head>
      <body>
        <div id="body">
          <!-- front matter -->
          <xsl:apply-templates select="/article/liminaire"/>
          
          <!-- article body -->
          <xsl:apply-templates select="/article/corps"/>
          
          <!-- back matter -->
          <xsl:apply-templates select="/article/partiesann"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>XHTML document metadata: title</xd:p>
      <xd:p>Document title is selected from group title's biblio reference, if present; otherwise,
        title is composed of group title's non-empty child elements.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template name="get-metadata-title">
    <xsl:value-of select="//grtitre/child::*[not(name()=trefbiblio) and not(empty(text()))]" separator=" - "/>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="liminaire">
    <div id="front-matter">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: title group</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="grtitre">
    <div class="title-group">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: title group, super-title</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="surtitre[descendant-or-self::text()]">
    <h2 class="supertitle"><xsl:apply-templates/></h2>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Front matter: title group, title</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="grtitre/titre[descendant-or-self::text()]">
    <h3 class="article-title"><xsl:apply-templates/></h3>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Front matter: title group, subtitle</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="sstitre[descendant-or-self::text()]">
    <h4 class="subtitle"><xsl:apply-templates/></h4>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Front matter: title group, biblio reference</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="trefbiblio[descendant-or-self::text()]">
    <h3 class="biblioref"><xsl:apply-templates/></h3>
  </xsl:template>
    

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: author group</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="grauteur">
    <div class="author-group">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: author</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="auteur">
    <div class="author">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: author, affiliation</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="affiliation">
    <div class="affiliation">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: author, e-mail address</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="courriel">
    <div class="email">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: editorial note</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="noteedito">
    <div class="editorial-note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: abstract</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="resume">
    <div class="abstract">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: abstract, title</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="resume/titre">
    <h4 class="abstract-title"><xsl:apply-templates/></h4>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: abstract sub-sections</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="resume/alinea">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: keyword group</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="grmotcle">
    <div class="keyword-group">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Front matter: keyword group, keyword</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="motcle[descendant-or-self::text()]">
    <span class="keyword"><xsl:apply-templates/></span><xsl:text> </xsl:text>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document body</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="corps">
    <div id="document-body">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document body: dedication</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="dedicace">
    <div class="dedication">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document body: text</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="corps/texte">
    <div class="document-body-text">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document body: sections, levels 1-6</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="node()[starts-with(name(), 'section')]">
    <div class="{name()}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document body: section titles, levels 1-6</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="node()[starts-with(name(), 'section')]/titre">
    <xsl:variable name="heading-level" select="concat('h', substring-after(name(parent::node()), 'section'))"/>
    <xsl:element name="{$heading-level}"><xsl:apply-templates/></xsl:element>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Document body: all other titles</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="titre">
    <div class="title-block">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="partiesann">
    <div id="back-matter">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: appendix</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="annexe">
    <div class="appendix">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: acknowledgments</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="merci">
    <div class="acknowledgments">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: acknowledgements sub-sections</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="merci/alinea">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: group of biographical notes</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="grnotebio">
    <div class="notebio-group">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: biographical note</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="notebio">
    <div class="notebio">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: bibliography</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="biblio">
    <div class="biblio">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: bibliography sub-division</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="divbiblio">
    <div class="divbiblio">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: bibliography reference</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="refbiblio">
    <div class="refbiblio">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: notes group</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="grnote">
    <div class="note-group">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Back matter: note</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="note">
    <xsl:variable name="note-link-id" select="@id"/>
    <xsl:variable name="note-link" select="/article/grlien/lien[@xlink:from=$note-link-id]"/>
    <div id="{$note-link-id}" class="note">
      <a href="#{$note-link/@xlink:to}" title="{$note-link/@xlink:title}"><xsl:value-of select="no"/></a>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: citation</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="bloccitation">
    <div class="citation">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: epigraph</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="epigraphe">
    <div class="epigraph">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: epigraph sub-sections</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="epigraphe/alinea">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: verbatim</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="verbatim">
    <div class="verbatim">
      <xsl:apply-templates/>
    </div>    
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: verbatim, sub-block</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="bloc">
    <div class="verbatim-block">
      <xsl:apply-templates/>
    </div>    
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: verbatim, line of text</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="ligne">
    <xsl:apply-templates/><br/>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: source of encosing block (citation, epigraph, etc.)</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="source">
    <div class="source"><xsl:apply-templates/></div>
  </xsl:template>
  
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: paragraph</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="para">
    <div class="para">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: paragraph alinea</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="para/alinea">
    <p>
      <!-- Include paragraph number, if it exists and this is the first <alinea/> child -->  
      <xsl:if test=".=../alinea[position()=1] and exists(../no)">
        <span class="no"><xsl:value-of select="../no"/></span><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Block text: caption describing enclosing block (table, figure, etc.)</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="legende">
    <div class="legend">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: superscript</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="exposant">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: subscript</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="indice">
    <sub><xsl:apply-templates/></sub>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: simple links</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="liensimple">
    <a href="{@xlink:href}"><xsl:apply-templates/></a>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: footnotes</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="renvoi">
    <xsl:variable name="footnote-id" select="@id"/>
    <xsl:variable name="footnote-link" select="/article/grlien/lien[@xlink:from=$footnote-id]"/>
    <a id="{$footnote-link/@xlink:from}" href="{concat('#', $footnote-link/@xlink:to)}" title="{$footnote-link/@xlink:title}" class="footnote">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: typography, strikethrough</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="marquage[@typemarq='barre']"><span class="strikethrough"><xsl:apply-templates/></span></xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: typography, bold</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="marquage[@typemarq='gras']"><strong><xsl:apply-templates/></strong></xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: typography, italics</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="marquage[@typemarq='italique']"><i><xsl:apply-templates/></i></xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: typography, uppercase</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="marquage[@typemarq='majuscule']"><span class="uppercase"><xsl:apply-templates/></span></xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: typography, small capitals</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="marquage[@typemarq='petitecap']"><span class="smallcaps"><xsl:apply-templates/></span></xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Text elements: typography, underline</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="marquage[@typemarq='souligne']"><span class="underline"><xsl:apply-templates/></span></xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Names: personal name</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="nompers">
    <span class="name-pers"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Names: personal name, prefix</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="prefixe[descendant-or-self::text()]">
    <span class="name-prefix"><xsl:apply-templates/></span><xsl:text> </xsl:text>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Names: personal name, given name</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="prenom[descendant-or-self::text()]">
    <span class="name-given"><xsl:apply-templates/></span><xsl:text> </xsl:text>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Names: personal name, middle name</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="autreprenom[descendant-or-self::text()]">
    <span class="name-middle"><xsl:apply-templates/></span><xsl:text> </xsl:text>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Names: personal name, surname</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="nomfamille[descendant-or-self::text()]">
    <span class="name-surname"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Names: organization name</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="nomorg">
    <span class="name-org"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Multimedia: image, equation</xd:p>
      <xd:p><xd:i>@todo: use JQuery for images</xd:i></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="image[@typeimage='equation']">      
    <!-- select the pointeur node which has an xlink:label that defines our fullsize image, and store it in a variable -->
    <xsl:variable name="label" select="concat(@id, 'n')"/>
    <xsl:variable name="pointeur-fullsize" select="//pointeur[@xlink:label=$label]"/>
    
    <!-- use both images to generate the link and the img tag of our thumbnail -->
    <img class="equation" src="{$OJS_BASE_URL}{$pointeur-fullsize/@xlink:href}" alt="{$pointeur-fullsize/@xlink:title}"/>
    
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Multimedia: image, types other than equation</xd:p>
      <xd:p>Érudit Article DTD allows element <xd:i>objetmedia</xd:i> to be a child of inline elements
        (<xd:i>marquage</xd:i>, <xd:i>indice</xd:i>, etc.)  To produce valid XHTML, we must avoid
        block-level elements to format <xd:i>objetmedia</xd:i> and its descendants.</xd:p>
      <xd:p><xd:i>@todo: JQuery for images</xd:i></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="image">
 
    <xsl:variable name="thumbnail-label" select="concat(@id, 't')"/>
    <xsl:variable name="thumbnail-pointer" select="/article/grlien/pointeur[@xlink:label=$thumbnail-label]"/>
  
    <xsl:variable name="fullsize-label" select="concat(@id, 'n')"/>
    <xsl:variable name="fullsize-pointer" select="/article/grlien/pointeur[@xlink:label=$fullsize-label]"/>
        
    <xsl:variable name="fullsize-link" select="/article/grlien/lien[@xlink:to=$fullsize-label]"/>

    <a href="{$OJS_BASE_URL}{$fullsize-pointer/@xlink:href}">
      <img src="{$THUMBNAIL_GENERATOR_URL}?{$thumbnail-pointer/@xlink:href}" alt="{$thumbnail-pointer/@xlink:title}"/>
    </a>      
    <span class="image-title"><a href="{$OJS_BASE_URL}{$fullsize-pointer/@xlink:href}"><xsl:value-of select="$fullsize-link/@xlink:title"/></a></span>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Multimedia: image caption. Suppressed; <xd:i>&lt;image&gt;</xd:i> element selects its own caption</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="objetmedia/texte"/>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Numbering: suppressed for all divisions except <xd:i>&lt;para&gt;</xd:i> and <xd:i>note</xd:i>;
        see templates matching <xd:i>para/alinea</xd:i> and <xd:i>note</xd:i> for details.
      </xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="no"/> 
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Lists: unordered list</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="listenonord">
    <ul>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@signe='carre'">bullet-square</xsl:when>
          <xsl:when test="@signe='cercle'">bullet-circle</xsl:when>
          <xsl:when test="@signe='tiret'">bullet-dash</xsl:when>
          <xsl:when test="@signe='nul'">bullet-none</xsl:when>
          <xsl:otherwise>bullet-disc</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Lists: ordered list</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="listeord">
    <ol>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@numeration='lettremin'">bullet-lower-alpha</xsl:when>
          <xsl:when test="@numeration='lettremaj'">bullet-upper-alpha</xsl:when>
          <xsl:when test="@numeration='romainmin'">bullet-lower-roman</xsl:when>
          <xsl:when test="@numeration='romainmaj'">bullet-upper-roman</xsl:when>
          <xsl:otherwise>bullet-decimal</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Lists: list item</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="elemliste">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Figures</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="figure">
    <div class="figure-block">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xd:doc scope="component">
    <xd:desc>
      <xd:p>Tables</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="tableau">
    <div class="table-block">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
