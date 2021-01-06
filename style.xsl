<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html" indent="no"/>

  <xsl:template match="tei:TEI">
    <html>
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@xml:lang='gez']"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@xml:lang='en']"/>
          <xsl:text>)</xsl:text>
        </title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.1/css/bulma.min.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@creativebulma/bulma-tooltip@1.2.0/dist/bulma-tooltip.min.css"/>
        <style>
          span.line:before {
            content: attr(id) ". ";
          }

          span.line, span.alt-line {
            display: block;
          }

          span.app:empty {
            min-height: 12px;
            min-width: 5px;
          }

          span.app:empty:before {
            content: "...";
          }
        </style>
      </head>
      <body>
        <section class="section">
          <div class="container content">

            <h1 class="title is-3">
              <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@xml:lang='gez']"/>
            </h1>
            <h2 class="subtitle is-5">
              <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@xml:lang='en']"/>
            </h2>

            <h2 class="is-4">Witnesses</h2>
            <ol type="A">
              <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness"/>
            </ol>
          
          </div>
        </section>
        
        <section class="section">
          <div class="container">
          <div class="columns">

          <div class="column content">

            <h2 class="is-4">Text</h2>
            <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='text']/tei:lg"/>

          </div>

          <xsl:if test="tei:text/tei:body/tei:div[@type='translation']">
          <div class="column content">

            <h2 class="is-4">Translation</h2>
            <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='translation']/tei:lg"/>

          </div>
          </xsl:if>

          </div>
          </div>
        </section>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tei:witness">
    <li>
      <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:repository"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:collection"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:idno"/>

      <xsl:apply-templates select="tei:msDesc/tei:msIdentifier/tei:altIdentifier"/>

      <xsl:if test="tei:msDesc/tei:history/tei:origin/tei:origPlace">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="tei:msDesc/tei:history/tei:origin/tei:origPlace"/>
      </xsl:if>

      <xsl:text>, </xsl:text>
      <xsl:value-of select="tei:msDesc/tei:history/tei:origin/tei:origDate"/>

      <xsl:text>, ff. </xsl:text>
      <xsl:value-of select="tei:msDesc/tei:msContents/tei:msItem/tei:locus/@from"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="tei:msDesc/tei:msContents/tei:msItem/tei:locus/@to"/>

      <xsl:text> [</xsl:text>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:value-of select="@facs"/>
        </xsl:attribute>
        <xsl:text>Images</xsl:text>
      </a>
      <xsl:text>]</xsl:text>
    </li>
  </xsl:template>

  <xsl:template match="tei:altIdentifier">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="tei:idno"/>
    <xsl:text>)</xsl:text>
  </xsl:template>


  <xsl:template match="tei:lg">
    <p>
      <xsl:attribute name="id">
        <xsl:value-of select="@n"/>
      </xsl:attribute>

      <xsl:apply-templates select="tei:l|tei:app/tei:lem/tei:l|tei:app/tei:rdg/tei:l"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:lg/tei:l|tei:lem/tei:l">
    <span class="line">
      <xsl:attribute name="id">
        <xsl:value-of select="../@n"/>
        <xsl:if test="name(..)='lem'"><xsl:value-of select="../../../@n"/></xsl:if>

        <xsl:text>.</xsl:text>
        <xsl:value-of select="@n"/>
      </xsl:attribute>

      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:rdg/tei:l">
    <span class="alt-line pl-4">
      <xsl:value-of select="translate(translate(../@wit,'#',''),' ','')"/>
      <xsl:text>] </xsl:text>

      <xsl:apply-templates/>
      <xsl:if test=".=''"><em>Om.</em></xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="tei:app">
    <span>
      <xsl:attribute name="data-tooltip">
        <xsl:apply-templates select="tei:rdg"/>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="tei:lem">
          <xsl:attribute name="class">
            <xsl:text>app has-tooltip-arrow has-background-light</xsl:text>
          </xsl:attribute>

          <xsl:value-of select="tei:lem"/>
          <xsl:if test="tei:lem=''"><xsl:text>__</xsl:text></xsl:if>

        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:text>app has-tooltip-arrow has-background-warning-light</xsl:text>
          </xsl:attribute>

          <xsl:value-of select="tei:rdg[1]"/>
          <xsl:if test="tei:rdg[1]=''"><xsl:text>__</xsl:text></xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template match="tei:rdg">
    <xsl:if test="position()>1"><xsl:text>; </xsl:text></xsl:if>

    <xsl:value-of select="."/>
    <xsl:if test=".=''"><xsl:text>Om.</xsl:text></xsl:if>

    <xsl:text> </xsl:text>
    <xsl:value-of select="translate(translate(@wit,'#',''),' ','')"/>
  </xsl:template>

</xsl:stylesheet>