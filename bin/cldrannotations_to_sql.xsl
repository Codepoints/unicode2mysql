<stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- convert CLDR emoji annotations into a SQL file usable for codepoints.net. -->

  <output method="text" />

  <template match="text() | comment()" />

  <param name="lang" select="'en'" />

  <template match="annotations">
    <text>INSERT IGNORE INTO codepoint_annotation ( cp, annotation, `type`, lang ) VALUES </text>
    <apply-templates select="./annotation">
      <with-param name="lang" select="$lang" />
    </apply-templates>
    <text>
     ( 0, '', 'tag', 'x-none');
    </text>
  </template>

  <template match="annotation">
    <param name="lang" />
    <param name="node" select="." />
    <if test="string-length(@cp) = 1">
      <analyze-string select="." regex="\s*\|\s*">
        <non-matching-substring>
          <call-template name="generate-sql">
            <with-param name="input" select="."/>
            <with-param name="lang" select="$lang" />
            <with-param name="node" select="$node" />
          </call-template>
        </non-matching-substring>
      </analyze-string>
    </if>
  </template>

  <template name="generate-sql">
    <param name="input" />
    <param name="lang" />
    <param name="node" />

    <text>&#xA;( </text>
      <value-of select="string-to-codepoints($node/@cp)"/>
      <text>, '</text>
      <value-of select="$input"/>
      <text>', '</text>
      <choose>
        <when test="$node/@type">
          <value-of select="$node/@type"/>
        </when>
        <otherwise>
          <text>tag</text>
        </otherwise>
      </choose>
      <text>', '</text>
      <value-of select="$lang" />
      <text>'),</text>
      <!--
    <choose>
      <when test="$node/position() mod 500 = 0 and $node/position() != last()">
        <text> ON DUPLICATE KEY UPDATE cp=cp;&#xA;</text>
        <text>INSERT INTO codepoint_annotation ( cp, annotation, `type`, lang ) VALUES </text>
      </when>
      <when test="$node/position() != last()">
        <text>,</text>
      </when>
    </choose>
    -->
  </template>

</stylesheet>
