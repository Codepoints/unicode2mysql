<stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg">

  <!-- convert an SVG font into a SQL file usable for codepoints.net. -->

  <output method="text" />

  <template match="text() | comment()" />

  <template match="svg:font">
    <text>INSERT INTO codepoint_image ( cp, font, width, height, image ) VALUES </text>
    <apply-templates select="./svg:glyph[string-length(@unicode) = 1]">
      <with-param name="font" select="./svg:font-face/@font-family" />
      <with-param name="ascent" select="./svg:font-face/@ascent" />
      <with-param name="descent" select="./svg:font-face/@descent" />
      <with-param name="default-adv" select="@horiz-adv-x" />
      <with-param name="units-per-em">
        <choose>
          <when test="./svg:font-face/@units-per-em">
            <value-of select="./svg:font-face/@units-per-em" />
          </when>
          <otherwise>
            <text>2048</text>
          </otherwise>
        </choose>
      </with-param>
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
      <text>, '</text>
      <value-of select="$font"/>
      <text>', </text>
      <choose>
        <when test="@horiz-adv-x and (@horiz-adv-x != '0')">
          <value-of select="@horiz-adv-x"/>
        </when>
        <when test="$default-adv and ($default-adv != '0')">
          <value-of select="$default-adv"/>
        </when>
        <otherwise>
          <value-of select="$units-per-em"/>
        </otherwise>
      </choose>
      <text>, </text>
      <value-of select="abs($descent) + $ascent"/>
      <text>, '&lt;svg xmlns="http://www.w3.org/2000/svg" id="U</text>
      <variable name="hexcp">
        <call-template name="ConvertDecToHex">
          <with-param name="index" select="string-to-codepoints(@unicode)"/>
        </call-template>
      </variable>
      <choose>
        <when test="string-length($hexcp) = 1">
          <value-of select="concat('000', $hexcp)"/>
        </when>
        <when test="string-length($hexcp) = 2">
          <value-of select="concat('00', $hexcp)"/>
        </when>
        <when test="string-length($hexcp) = 3">
          <value-of select="concat('0', $hexcp)"/>
        </when>
        <otherwise>
          <value-of select="$hexcp"/>
        </otherwise>
      </choose>
      <text>" viewBox="0 0 </text>
        <choose>
          <when test="@horiz-adv-x and @horiz-adv-x != '0'">
            <value-of select="@horiz-adv-x"/>
          </when>
          <when test="$default-adv and ($default-adv != '0')">
            <value-of select="$default-adv"/>
          </when>
          <otherwise>
            <value-of select="$units-per-em"/>
          </otherwise>
        </choose>
        <value-of select="concat(
          ' ',
          abs($descent) + $ascent,
          '&quot;>',
          '&lt;path transform=&quot;translate(')" />
        <choose>
          <when test="@horiz-adv-x = '0' or (not(@horiz-adv-x) and $default-adv = '0')">
            <!-- when the glyph has no horiz-adv, then it's some kind of
                 modifier. Move it into the middle of the canvas to make it
                 wholy visible. -->
            <value-of select="$units-per-em div 2" />
          </when>
          <otherwise>
            <text>0</text>
          </otherwise>
        </choose>
        <value-of select="concat(', ',
          $ascent,
          ') scale(1,-1)&quot; d=&quot;',
          @d,
          '&quot;/>&lt;/svg>'
          )"/>
      <text>'</text>
      <text>)</text>
    <choose>
      <when test="position() mod 500 = 0 and position() != last()">
        <text> ON DUPLICATE KEY UPDATE cp=cp;&#xA;</text>
        <text>INSERT INTO codepoint_image ( cp, font, width, height, image ) VALUES </text>
      </when>
      <when test="position() != last()">
        <text>,</text>
      </when>
    </choose>
  </template>

  <!-- source: https://gist.github.com/xpathr/2653476 -->
  <template name="ConvertDecToHex">
    <param name="index" />
    <if test="$index > 0">
      <call-template name="ConvertDecToHex">
        <with-param name="index" select="floor($index div 16)" />
      </call-template>
      <choose>
        <when test="$index mod 16 &lt; 10">
          <value-of select="$index mod 16" />
        </when>
        <otherwise>
          <choose>
            <when test="$index mod 16 = 10">A</when>
            <when test="$index mod 16 = 11">B</when>
            <when test="$index mod 16 = 12">C</when>
            <when test="$index mod 16 = 13">D</when>
            <when test="$index mod 16 = 14">E</when>
            <when test="$index mod 16 = 15">F</when>
            <otherwise>A</otherwise>
          </choose>
        </otherwise>
      </choose>
    </if>
  </template>

</stylesheet>
