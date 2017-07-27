<stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg">

  <!-- convert an SVG font into a SQL file usable for codepoints.net. -->

  <output method="text" />

  <template match="text() | comment()" />

  <template match="svg:font">
    <text>INSERT INTO codepoint_image ( cp, image, font, width, height ) VALUES </text>
    <apply-templates select="./svg:glyph[string-length(@unicode) = 1]">
      <with-param name="font" select="./svg:font-face/@font-family" />
      <with-param name="ascent" select="./svg:font-face/@ascent" />
      <with-param name="descent" select="./svg:font-face/@descent" />
      <with-param name="default-adv">
        <if test="@horiz-adv-x">
          <value-of select="@horiz-adv-x" />
        </if>
      </with-param>
      <with-param name="units-per-em" select="./svg:font-face/@units-per-em" />
    </apply-templates>
    <text>
      ON DUPLICATE KEY UPDATE cp=cp;
    </text>
    <!-- == ignore the new row -->
  </template>

  <template match="svg:glyph">
    <param name="font" />
    <param name="ascent" />
    <param name="descent" />
    <param name="default-adv" />
    <param name="units-per-em" />

    <text>&#xA;( </text>
    <value-of select="string-to-codepoints(@unicode)"/>
    <text>, </text>
    <text>'data:image/svg+xml,</text>
    <value-of select="encode-for-uri('&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 ')"/>
      <choose>
        <when test="@horiz-adv-x">
          <value-of select="@horiz-adv-x"/>
        </when>
        <otherwise>
          <value-of select="$units-per-em"/>
        </otherwise>
      </choose>
      <value-of select="encode-for-uri(concat(
        ' ',
        abs($descent) + $ascent,
        '&quot; style=&quot;overflow:visible&quot;>',
        '&lt;path transform=&quot;translate(0, ',
        $ascent,
        ') scale(1,-1)&quot; d=&quot;',
        @d,
        '&quot;/>&lt;/svg>'
        ))"/>
    <text>', '</text>
    <value-of select="$font"/>
    <text>', </text>
    <choose>
      <when test="@horiz-adv-x">
        <value-of select="@horiz-adv-x"/>
      </when>
      <otherwise>
        <value-of select="$default-adv"/>
      </otherwise>
    </choose>
    <text>, </text>
    <value-of select="abs($descent) + $ascent"/>
    <text>)</text>
    <if test="position() != last()">
      <text>,</text>
    </if>
  </template>

</stylesheet>
