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
          @import url("https://fonts.googleapis.com/css2?family=Noto+Serif:wght@400;700");
          @import url("https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@600");
          
          @font-face {
            font-family: "Noto Serif";
            font-weight: 400;
            src: local("Noto Serif Ethiopic"),
                 local("NotoSerifEthiopic-Regular"),
                 url("https://cdn.jsdelivr.net/gh/googlefonts/noto-fonts/hinted/ttf/NotoSerifEthiopic/NotoSerifEthiopic-Regular.ttf") format("truetype");
            unicode-range: U+1200-1380;
          }
          
          @font-face {
            font-family: "Noto Serif";
            font-weight: 600;
            src: local("Noto Serif Ethiopic"),
                 local("NotoSerifEthiopic-SemiBold"),
                 url("https://cdn.jsdelivr.net/gh/googlefonts/noto-fonts/hinted/ttf/NotoSerifEthiopic/NotoSerifEthiopic-SemiBold.ttf") format("truetype");
            unicode-range: U+1200-1380;
          }
          
          * {
            font-family: "Noto Serif", serif;
          }
          
          h1, h2, h3, h4, h5, h6 {
            font-family: "Roboto Slab", serif;
          }
          
          span.alt-stanza {
            display: block;
          }

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

            <h1 class="title is-3" style="font-family: 'Noto Serif', serif;">
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
                <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='text']/tei:lg|tei:text/tei:body/tei:div[@type='text']/tei:app[@type='stanza']"/>

              </div>

              <xsl:if test="tei:text/tei:body/tei:div[@type='translation']">
              <div class="column content">

                <h2 class="is-4">Translation</h2>
                <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='translation']/tei:lg|tei:text/tei:body/tei:div[@type='translation']/tei:app[@type='stanza']"/>

              </div>
              </xsl:if>

            </div>
          </div>
        </section>

        <section class="section">
          <div class="container content">
            <h2 class="is-4">Notes</h2>
            <ol>
              <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='translation']//tei:note" mode="endnote"/>
            </ol>
          </div>
        </section>

        <footer class="footer">
          <div class="container">
            <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt"/>
            © <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>.
            <br/>
            <a target="_blank">
              <xsl:attribute name="href">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
              </xsl:attribute>
              <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence"/>
            </a>
          </div>
        </footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tei:witness">
    <li>
      <xsl:attribute name="value">
        <xsl:value-of select="translate(@xml:id,'JKLMNOPQRSTUVWXYZABCDEFGHI','11111111112222222')"/>
        <xsl:value-of select="translate(@xml:id,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','12345678901234567890123456')"/>
      </xsl:attribute>
      
      <xsl:apply-templates select="tei:msDesc|tei:bibl"/>

      <xsl:if test="@facs">
        <xsl:text> [</xsl:text>
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="@facs"/>
          </xsl:attribute>
          <xsl:text>Images</xsl:text>
        </a>
        <xsl:text>]</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="tei:msDesc">
    <xsl:value-of select="tei:msIdentifier/tei:repository"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="tei:msIdentifier/tei:collection"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="tei:msIdentifier/tei:idno"/>

    <xsl:apply-templates select="tei:msIdentifier/tei:altIdentifier"/>

    <xsl:if test="tei:history/tei:origin/tei:origPlace">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="tei:history/tei:origin/tei:origPlace"/>
    </xsl:if>

    <xsl:if test="tei:history/tei:origin/tei:origDate">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="tei:history/tei:origin/tei:origDate"/>
    </xsl:if>

    <xsl:text>, ff. </xsl:text>
    <xsl:value-of select="tei:msContents/tei:msItem/tei:locus/@from"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="tei:msContents/tei:msItem/tei:locus/@to"/>
  </xsl:template>

  <xsl:template match="tei:altIdentifier">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="tei:idno"/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:bibl">
    <xsl:value-of select="tei:editor"/>
    <xsl:text>, ed. </xsl:text>
    
    <u><xsl:value-of select="tei:title"/></u>
    <xsl:text>. </xsl:text>
    
    <xsl:value-of select="tei:pubPlace"/>
    <xsl:text>: </xsl:text>
    
    <xsl:value-of select="tei:publisher"/>
    <xsl:text>, </xsl:text>
    
    <xsl:value-of select="tei:date"/>
    <xsl:text>, </xsl:text>
    
    <xsl:text>pp. </xsl:text>
    <xsl:value-of select="tei:citedRange/@from"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="tei:citedRange/@to"/>
  </xsl:template>

  
  <xsl:template match="tei:app[@type='stanza']">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:app[@type='stanza']/tei:rdg">
    <xsl:choose>
      <xsl:when test=".=''">
        <xsl:text>[</xsl:text>
        <em>Stanza om. in </em>
        <xsl:value-of select="translate(translate(@wit,'#',''),' ','')"/>
        <xsl:text>]</xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <span class="alt-stanza mt-4 pl-4">
          <xsl:text>[</xsl:text>
          <em>Alt. stanza in </em>
          <xsl:value-of select="translate(translate(@wit,'#',''),' ','')"/>
          <xsl:text>]</xsl:text>
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="tei:div/tei:lg">
    <p>
      <xsl:attribute name="id">
        <xsl:value-of select="@n"/>
      </xsl:attribute>

      <xsl:apply-templates select="tei:l|tei:app/tei:lem/tei:l|tei:app/tei:rdg/tei:l"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:l">
    <span class="line">
      <xsl:attribute name="id">
        <xsl:value-of select="../@n"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="@n"/>
      </xsl:attribute>

      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:app[@type='line']/tei:lem">
    <xsl:apply-templates/>
    <xsl:if test=".=''"><em>Om.</em></xsl:if>
  </xsl:template>

  <xsl:template match="tei:app[@type='line']/tei:rdg">
    <span class="alt-line pl-4">
      <xsl:value-of select="translate(translate(@wit,'#',''),' ','')"/>
      <xsl:text>] </xsl:text>

      <xsl:apply-templates/>
      <xsl:if test=".=''"><em>Om.</em></xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="tei:app[not(@type)]">
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

  <xsl:template match="tei:app[not(@type)]/tei:rdg">
    <xsl:if test="position()>1"><xsl:text>; </xsl:text></xsl:if>

    <xsl:if test="../tei:lem=''">
      <xsl:text>Add. </xsl:text>
    </xsl:if>

    <xsl:value-of select="."/>
    <xsl:if test=".=''"><xsl:text>Om.</xsl:text></xsl:if>

    <xsl:text> </xsl:text>
    <xsl:value-of select="translate(translate(@wit,'#',''),' ','')"/>
  </xsl:template>


  <xsl:template match="tei:div[@type='translation']//tei:note">
    <sup>
      <a>
        <xsl:attribute name="name">
          <xsl:text>n-</xsl:text>
          <xsl:number level="any" count="tei:note" format="1"/>
          <xsl:text>-ref</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="href">
          <xsl:text>#n-</xsl:text>
          <xsl:number level="any" count="tei:note" format="1"/>
        </xsl:attribute>

        <xsl:number level="any" count="tei:note" format="1"/>
      </a>
    </sup>
  </xsl:template>

  <xsl:template match="tei:div[@type='translation']//tei:note" mode="endnote">
    <li>

      <a>
        <xsl:attribute name="href">
          <xsl:text>#n-</xsl:text>
          <xsl:number level="any" count="tei:note" format="1"/>
          <xsl:text>-ref</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="name">
          <xsl:text>n-</xsl:text>
          <xsl:number level="any" count="tei:note" format="1"/>
        </xsl:attribute>

        <xsl:text>^</xsl:text>
      </a>

      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </li>
  </xsl:template>


  <xsl:template match="tei:respStmt/tei:name">
    <xsl:value-of select="."/>.
    <br/>
  </xsl:template>

</xsl:stylesheet>
