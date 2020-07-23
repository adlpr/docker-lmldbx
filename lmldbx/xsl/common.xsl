<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.xobis.info/ns/2.0/" xmlns:xobis="http://www.xobis.info/ns/2.0/">

<xsl:import href="img-templates.xsl"/>
<xsl:import href="lang-codes.xsl"/>

<!-- ==================================== -->
<!-- ======== NAMES / QUALIFIERS ======== -->
<!-- ==================================== -->

<!-- format a generic <name> -->
<xsl:template match="*[not(self::xobis:work)]/*[self::xobis:entry|self::xobis:time]/xobis:name|*[not(self::xobis:record|self::xobis:variants)]/*[self::xobis:being|self::xobis:concept|self::xobis:event|self::xobis:language|self::xobis:object|self::xobis:organization|self::xobis:place|self::xobis:string|self::xobis:work]/xobis:name">
  <xsl:choose>
    <!-- name with <part>s -->
    <xsl:when test="xobis:part">
      <xsl:for-each select="xobis:part">
        <span><xsl:apply-templates select="@lang"/>
          <xsl:choose>
            <xsl:when test="position()=1 and contains(@type,'surname')">
              <!-- if the surname is first, append a comma -->
              <xsl:value-of select="."/>,
            </xsl:when>
            <xsl:when test="@type='expansion'">
              <!-- put parens around expansions -->
              (<xsl:value-of select="."/>)
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:for-each>
    </xsl:when>
    <!-- single <name> -->
    <xsl:otherwise>
      <span><xsl:apply-templates select="@lang"/><xsl:value-of select="."/></span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- works have special structure interleaving name parts and qualifiers -->
<xsl:template match="xobis:work/xobis:entry|*[not(self::xobis:record|self::xobis:variants|self::xobis:target)]/xobis:work">
  <xsl:choose>
    <!-- name with <part>s/qualifiers -->
    <xsl:when test="xobis:part">
      <xsl:for-each select="*">
        <xsl:choose>
          <xsl:when test="name(.)='part'">
            <!-- name part -->
            <a><xsl:if test="not(contains(../@href, 'unverified') or contains(../@href, 'conflict'))"><xsl:copy-of select="../@href"/></xsl:if><xsl:copy-of select="../@title"/><xsl:apply-templates select="@lang"/><xsl:value-of select="."/></a>
          </xsl:when>
          <xsl:otherwise>
            <!-- qualifiers -->
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(position()=last())"> · </xsl:if>
      </xsl:for-each>
    </xsl:when>
    <!-- single <name> -->
    <xsl:otherwise>
      <xsl:for-each select="*">
        <xsl:choose>
          <xsl:when test="name(.)='name'">
            <!-- name -->
            <a><xsl:if test="not(contains(../@href, 'unverified') or contains(../@href, 'conflict'))"><xsl:copy-of select="../@href"/></xsl:if><xsl:copy-of select="../@title"/><xsl:apply-templates select="@lang"/><xsl:value-of select="."/></a>
          </xsl:when>
          <xsl:otherwise>
            <!-- qualifiers -->
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(position()=last())"> · </xsl:if>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- <qualifiers>/<prequalifiers> list -->
<xsl:template match="xobis:qualifiers|xobis:prequalifiers">
  <!-- format each Element Ref separately and join -->
  <xsl:for-each select="*">
    <xsl:apply-templates select="."/>
    <xsl:if test="not(position()=last())"> · </xsl:if>
  </xsl:for-each>
</xsl:template>




<!-- ==================================== -->
<!-- ========= TIME / DURATION ========== -->
<!-- ==================================== -->

<!-- Time (main or variant) entry -->
<xsl:template name="time-entry">
  <!-- scheme? group attrs? -->
  <xsl:call-template name="time-content-single"/>
  <xsl:if test="xobis:calendar">
    <xsl:apply-templates select="xobis:calendar"/>
  </xsl:if>
</xsl:template>


<!-- smallest unit of Time content -->
<xsl:template name="time-content-single">
  <!-- TODO: generic type? -->
  <xsl:value-of select="@quality"/>
  <xsl:choose>
    <xsl:when test="@certainty='implied'">
      [<xsl:call-template name="time-content-elements"/>]
    </xsl:when>
    <xsl:when test="@certainty='estimated'">
      <xsl:call-template name="time-content-elements"/>?
    </xsl:when>
    <xsl:when test="@certainty='approximate'">
      approximately <xsl:call-template name="time-content-elements"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="time-content-elements"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Time content innermost elements -->
<!-- based on ISO 8601 formatting: yyyy-mm-ddThh:mm:ss.mmm+zh:zs -->
<xsl:template name="time-content-elements">
  <a><xsl:if test="not(contains(@href, 'unverified') or contains(@href, 'conflict'))"><xsl:copy-of select="@href"/></xsl:if><xsl:copy-of select="@title"/>
    <xsl:choose>
      <xsl:when test="xobis:name">
        <xsl:apply-templates select="xobis:name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose><xsl:when test="xobis:year"><xsl:value-of select="xobis:year"/></xsl:when><xsl:otherwise><xsl:if test="xobis:month|xobis:day">-</xsl:if></xsl:otherwise></xsl:choose><xsl:choose><xsl:when test="xobis:month">-<xsl:value-of select="format-number(xobis:month,'00')"/><xsl:if test="xobis:day">-<xsl:value-of select="format-number(xobis:day,'00')"/></xsl:if></xsl:when><xsl:otherwise><xsl:if test="xobis:day">-<xsl:value-of select="format-number(xobis:day,'000')"/></xsl:if></xsl:otherwise></xsl:choose><xsl:if test="xobis:hour|xobis:minute|xobis:second|xobis:millisecond|xobis:tzHour|xobis:tzMinute">T<xsl:if test="xobis:hour"><xsl:value-of select="format-number(xobis:hour,'00')"/></xsl:if><xsl:if test="xobis:minute|xobis:second|xobis:millisecond">:<xsl:if test="xobis:minute"><xsl:value-of select="format-number(xobis:minute,'00')"/></xsl:if><xsl:if test="xobis:second|xobis:millisecond">:<xsl:if test="xobis:second"><xsl:value-of select="format-number(xobis:second,'00')"/></xsl:if><xsl:if test="xobis:millisecond">.<xsl:value-of select="format-number(xobis:millisecond,'000')"/></xsl:if></xsl:if></xsl:if><xsl:choose><xsl:when test="xobis:tzHour and xobis:tzMinute and xobis:tzHour=0 and xobis:tzMinute=0">Z</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="xobis:tzHour"><xsl:if test="not(starts-with(xobis:tzHour,'-'))">+</xsl:if><xsl:value-of select="format-number(xobis:tzHour,'00')"/><xsl:if test="xobis:tzMinute">:<xsl:value-of select="format-number(xobis:tzMinute,'00')"/></xsl:if></xsl:when><xsl:otherwise><xsl:if test="xobis:tzMinute">+00:<xsl:value-of select="format-number(xobis:tzMinute,'00')"/></xsl:if></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<!-- readable:
  <xsl:choose>
    <xsl:when test="xobis:year">
      <xsl:value-of select="xobis:year"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="xobis:month|xobis:day">-</xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="xobis:month">
      -<xsl:value-of select="format-number(xobis:month,'00')"/>
      <xsl:if test="xobis:day">
        -<xsl:value-of select="format-number(xobis:day,'00')"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="xobis:day">
        -<xsl:value-of select="format-number(xobis:day,'000')"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="xobis:hour|xobis:minute|xobis:second|xobis:millisecond|xobis:tzHour|xobis:tzMinute">
    T
    <xsl:if test="xobis:hour">
      <xsl:value-of select="format-number(xobis:hour,'00')"/>
    </xsl:if>
    <xsl:if test="xobis:minute|xobis:second|xobis:millisecond">
      :
      <xsl:if test="xobis:minute">
        <xsl:value-of select="format-number(xobis:minute,'00')"/>
      </xsl:if>
      <xsl:if test="xobis:second|xobis:millisecond">
        :
        <xsl:if test="xobis:second">
          <xsl:value-of select="format-number(xobis:second,'00')"/>
        </xsl:if>
        <xsl:if test="xobis:millisecond">
          .<xsl:value-of select="format-number(xobis:millisecond,'000')"/>
        </xsl:if>
      </xsl:if>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="xobis:tzHour and xobis:tzMinute and xobis:tzHour=0 and xobis:tzMinute=0">
        Z
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="xobis:tzHour">
            <xsl:if test="not(starts-with(xobis:tzHour,'-'))">+</xsl:if>
            <xsl:value-of select="format-number(xobis:tzHour,'00')"/>
            <xsl:if test="xobis:tzMinute">
              :<xsl:value-of select="format-number(xobis:tzMinute,'00')"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="xobis:tzMinute">
              +00:<xsl:value-of select="format-number(xobis:tzMinute,'00')"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
-->


<!-- calendar -->
<xsl:template match="xobis:calendar">
  (<a><xsl:if test="not(contains(@href, 'unverified') or contains(@href, 'conflict'))"><xsl:copy-of select="@href"/></xsl:if><xsl:copy-of select="@title"/><xsl:value-of select="@title"/></a>)
</xsl:template>




<!-- ==================================== -->
<!-- =========== ELEMENT REFS =========== -->
<!-- ==================================== -->

<!-- Element Ref except Time/Duration -->
<xsl:template match="
  *[not(self::xobis:record|self::xobis:variants)]/*[self::xobis:being|self::xobis:concept|self::xobis:event|self::xobis:language|self::xobis:object|self::xobis:organization|self::xobis:place|self::xobis:string|self::xobis:work]">
  <xsl:for-each select="xobis:name|xobis:part|xobis:qualifiers|xobis:prequalifiers">
    <xsl:choose>
      <xsl:when test="name(.)='name' or name(.)='part'">
        <a><xsl:if test="not(contains(../@href, 'unverified') or contains(../@href, 'conflict'))"><xsl:copy-of select="../@href"/></xsl:if><xsl:copy-of select="../@title"/>
          <xsl:apply-templates select="."/>
        </a>
      </xsl:when>
      <xsl:when test="name(.)='qualifiers' or name(.)='prequalifiers'">
        <xsl:apply-templates select="."/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
    <xsl:if test="not(position()=last())"> · </xsl:if>
  </xsl:for-each>
  <!-- <xsl:if test="not(starts-with(@href, '(CStL)'))">EXTERNAL LINK</xsl:if> -->
  <!-- Concept / Language / Organization Ref may have subdivisions w/ separate links -->
  <xsl:for-each select="xobis:subdivision">
    — <!-- separated with em dashes -->
    <a><xsl:if test="not(contains(@href, 'unverified') or contains(@href, 'conflict'))"><xsl:copy-of select="@href"/></xsl:if><xsl:copy-of select="@title"/>
      <span><xsl:apply-templates select="@lang"/>
        <xsl:value-of select="."/>
      </span>
    </a>
  </xsl:for-each>
</xsl:template>


<!-- Time Ref -->
<xsl:template match="*[not(self::xobis:record|self::xobis:variants)]/xobis:time">
  <!-- time content -->
  <xsl:choose>
    <xsl:when test="xobis:part">
      <!-- dual date separated by slash -->
      <xsl:for-each select="xobis:part">
        <xsl:call-template name="time-content-single"/><xsl:if test="position()=1">/</xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <!-- single time content -->
      <xsl:call-template name="time-content-single"/>
    </xsl:otherwise>
  </xsl:choose>
  <!-- calendar -->
  <xsl:if test="xobis:calendar">
    <xsl:apply-templates select="xobis:calendar"/>
  </xsl:if>
</xsl:template>


<!-- Duration Ref -->
<xsl:template match="*[not(self::xobis:record|self::xobis:variants)]/xobis:duration">
  <!-- just two Time Refs separated by an en dash -->
  <xsl:apply-templates select="xobis:time[1]"/>–<xsl:apply-templates select="xobis:time[2]"/>
</xsl:template>



<!-- ==================================== -->
<!-- ============== OTHERS ============== -->
<!-- ==================================== -->

<!-- get icon of current element type -->
<xsl:template name="get-element-icon">
  <xsl:choose>
    <xsl:when test="name(.)='being'">
      <xsl:call-template name="icon-being"/>
    </xsl:when>
    <xsl:when test="name(.)='concept'">
      <xsl:call-template name="icon-concept"/>
    </xsl:when>
    <xsl:when test="name(.)='event'">
      <xsl:call-template name="icon-event"/>
    </xsl:when>
    <xsl:when test="name(.)='language'">
      <xsl:call-template name="icon-language"/>
    </xsl:when>
    <xsl:when test="name(.)='object'">
      <xsl:call-template name="icon-object"/>
    </xsl:when>
    <xsl:when test="name(.)='organization'">
      <xsl:call-template name="icon-organization"/>
    </xsl:when>
    <xsl:when test="name(.)='place'">
      <xsl:call-template name="icon-place"/>
    </xsl:when>
    <xsl:when test="name(.)='string'">
      <xsl:call-template name="icon-string"/>
    </xsl:when>
    <xsl:when test="name(.)='time' or name(.)='duration'">
      <xsl:call-template name="icon-time"/>
    </xsl:when>
    <xsl:when test="name(.)='work'">
      <xsl:call-template name="icon-work"/>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<!-- generic type element -->
<xsl:template match="xobis:type">
  <a><xsl:if test="not(contains(@href, 'unverified') or contains(@href, 'conflict'))"><xsl:copy-of select="@href"/></xsl:if><xsl:copy-of select="@title"/><xsl:value-of select="@title"/></a>
</xsl:template>


<!-- note/note list -->
<xsl:template match="xobis:noteList|xobis:note">
  <ul class="notelist">
    <xsl:choose>
      <xsl:when test="name(.)='noteList'">
        <xsl:for-each select="xobis:note">
          <xsl:call-template name="single-note"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="single-note"/>
      </xsl:otherwise>
    </xsl:choose>
  </ul>
</xsl:template>

<xsl:template name="single-note">
  <li><xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
    <xsl:if test="xobis:type">
      <xsl:apply-templates select="xobis:type"/> :
    </xsl:if>
    <a><xsl:if test="not(contains(@href, 'unverified') or contains(@href, 'conflict'))"><xsl:copy-of select="@href"/></xsl:if><xsl:copy-of select="@title"/>
      <span><xsl:apply-templates select="@lang"/>
        <xsl:value-of select="."/>
      </span>
    </a>
  </li>
</xsl:template>


<xsl:template match="xobis:id">
  <xsl:attribute name="class"><xsl:value-of select="@status"/></xsl:attribute>
  <strong><xsl:apply-templates select="(xobis:organization|xobis:work|xobis:description)"/></strong>:
  <xsl:value-of select="xobis:value"/>
  <!-- optNoteList -->
  <xsl:if test="xobis:noteList|xobis:note">
    <xsl:apply-templates select="xobis:noteList|xobis:note"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
