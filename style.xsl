<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html" indent="no"/>

  <xsl:template match="tei:TEI">
    <html>
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.1/css/bulma.min.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@creativebulma/bulma-tooltip@1.2.0/dist/bulma-tooltip.min.css"/>
        <style>
          span.line:before {
            content: attr(data-line-num);
          }
          span.line {
            display: block;
          }
        </style>
      </head>
      <body>
        <section class="section">
          <div class="container content">

            <h1 class="title is-3"><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>

            <h2 class="title is-4">Witnesses</h2>
            <ol type="A">
              <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness"/>
            </ol>

            <h2 class="title is-4">Text</h2>
            <xsl:apply-templates select="tei:text/tei:body/tei:div/tei:lg"/>

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

  <xsl:template match="tei:lg">
    <p>
      <xsl:attribute name="id">
        <xsl:value-of select="@n"/>
      </xsl:attribute>

      <xsl:apply-templates select="tei:l"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:l">
    <span class="line">
      <xsl:attribute name="data-line-num">
        <xsl:value-of select="../@n"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>. </xsl:text>
      </xsl:attribute>

      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:app">
    <span class="has-tooltip-arrow">
      <xsl:attribute name="data-tooltip">
        <xsl:apply-templates select="tei:rdg"/>
      </xsl:attribute>

      <xsl:value-of select="tei:rdg[1]"/>
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