<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.xobis.info/ns/2.0/" xmlns:xobis="http://www.xobis.info/ns/2.0/">

<xsl:import href="common.xsl"/>

<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes" media-type="text/html"/>

<!-- record body -->

<xsl:template match="/xobis:record">

  <div class="container-fluid" id="record">
    <xsl:apply-templates select="@lang"/>

    <div class="row" id="top">
      <div class="col-sm-2 order-sm-1" id="lane-control-number">
        <!-- primary ID (control number) value -->
        <xsl:value-of select="xobis:controlData/xobis:id/xobis:value"/>
        <!-- role -->
        <xsl:choose>
          <xsl:when test="*/@role='authority'">
            <xsl:call-template name="icon-role-authority"/>
          </xsl:when>
          <xsl:when test="*/@role='instance'">
            <xsl:call-template name="icon-role-instance"/>
          </xsl:when>
          <xsl:when test="*/@role='authority instance'">
            <xsl:call-template name="icon-role-authorityinstance"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </div>
      <div class="col">
        <div class="media" id="heading">
          <div class="align-self-center text-center" id="main-entry-icons">
            <!-- main entry class/type icons -->
            <xsl:apply-templates select="*"/>
          </div>
          <div class="media-body">
            <xsl:for-each select="xobis:controlData/xobis:types/xobis:type">
              <xsl:if test="@title='Stanford-Related'">
                <!-- SU tree if Stanford-Related:
                testing each record-type for target == 'Stanford-Related' is
                inefficient, better to rely on some index -->
                <img src="../static/img/su_tree.png" id="sutree" title="Stanford-Related"/>
              </xsl:if>
            </xsl:for-each>
            <div id="main-entry">
              <!-- main entry name/qualifiers -->
              <xsl:apply-templates select="*/xobis:entry"/>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Variants -->

    <xsl:if test="*/xobis:variants">

      <div class="row section-head" id="variants-head">
        <div class="col" data-toggle="collapse" href="#variants-body" role="button" aria-expanded="true" aria-controls="variants-body">
          <div class="media">
            <xsl:call-template name="icon-variants"/>
            <h3 class="media-body">Variants</h3>
          </div>
        </div>
      </div>

      <div class="row section-body collapse show" id="variants-body" aria-labelledby="variants-head" data-parent="#variants-head">
        <div class="col">
          <div class="card card-body">
            <!--
              variants have:
              - subsumption (includes/broader/narrower/related) groups
              - type [w/href]
              - chronology [w/href]
              - entry [w/href] [may have an id or be in a group]
              - notes [w/href]
            -->
            <xsl:apply-templates select="*/xobis:variants"/>

            <!-- <ul class="card-text list-group list-group-flush">
              <li class="list-group-item"><img src="../static/img/elements/organization.svg" title="Organization"/>Example Organization</li>
              <li class="list-group-item">
                <img src="../static/img/elements/organization.svg" title="Organization"/>Organization Example
                <ul class="notelist">
                  <li>Note about this ID</li>
                  <li>A second note</li>
                </ul>
              </li>
              <li class="list-group-item">
                <img src="../static/img/elements/organization.svg" title="Organization"/><b>Another name</b>: ExOrg
                <ul class="notelist">
                  <li>Note about variant with a type</li>
                </ul>
              </li>
              <li class="list-group-item"><img src="../static/img/elements/organization.svg" title="Organization"/><i>(1984-1989)</i> Late Eighties Example Org</li>
              <li class="list-group-item"><img src="../static/img/elements/organization.svg" title="Organization"/><b>Different type</b> <i>(2010-)</i>: Samplorg</li>
              <li class="list-group-item">
                <h4>Includes narrower:</h4>
                <ul class="card-text list-group list-group-flush">
                  <li class="list-group-item"><img src="../static/img/elements/organization.svg" title="Organization"/>Sample Child Org</li>
                  <li class="list-group-item">
                    <img src="../static/img/elements/organization.svg" title="Organization"/><b>Acronym/initialism</b> <i>(-2011)</i>: SCO
                    <ul class="notelist">
                      <li>Here's a note about a subsumed variant within a group.</li>
                    </ul>
                  </li>
                  <li class="list-group-item"><img src="../static/img/elements/organization.svg" title="Organization"/><b>Acronym/initialism</b> <i>(2011-)</i>: SChO</li>
                </ul>
              </li>
              <li class="list-group-item">
                <h4>Includes:</h4>
                <ul class="card-text list-group list-group-flush">
                  <li class="list-group-item"><img src="../static/img/elements/organization.svg" title="Organization"/><i>(1994-)</i> Different Sample Org but Treated the Same</li>
                </ul>
              </li>
            </ul> -->

          </div>
        </div>
      </div>

    </xsl:if>


    <!-- Summary (holdings) -->

    <xsl:if test="xobis:holdings/xobis:summary">

      <div class="row section-head" id="summary-head">
        <div class="col" data-toggle="collapse" href="#summary-body" role="button" aria-expanded="true" aria-controls="summary-body">
          <div class="media">
            <xsl:call-template name="icon-summary"/>
            <h3 class="media-body">Summary</h3>
          </div>
        </div>
      </div>

      <div class="row section-body collapse show" id="summary-body" aria-labelledby="summary-head" data-parent="#summary-head">
        <div class="col">
          <div class="card card-body container-fluid">
            <xsl:call-template name="summary"/>
          </div>
        </div>
      </div>

    </xsl:if>


    <!-- Relationships -->

    <xsl:if test="xobis:relationships">

      <div class="row section-head" id="relationships-head">
        <div class="col" data-toggle="collapse" href="#relationships-body" role="button" aria-expanded="true" aria-controls="relationships-body">
          <div class="media">
            <xsl:call-template name="icon-relationships"/>
            <h3 class="media-body">Relationships</h3>
          </div>
        </div>
      </div>

      <div class="row section-body collapse show" id="relationships-body" aria-labelledby="relationships-head" data-parent="#relationships-head">
        <div class="col">
          <div class="card card-body container-fluid">
            <xsl:call-template name="relationships"/>
          </div>
        </div>
      </div>

    </xsl:if>

    <!-- Notes -->

    <xsl:if test="*/xobis:noteList or */xobis:note">

      <div class="row section-head" id="notes-head">
        <div class="col" data-toggle="collapse" href="#notes-body" role="button" aria-expanded="true" aria-controls="notes-body">
          <div class="media">
            <xsl:call-template name="icon-notes"/>
            <h3 class="media-body">Notes</h3>
          </div>
        </div>
      </div>

      <div class="row section-body collapse show" id="notes-body" aria-labelledby="notes-head" data-parent="#notes-head">
        <div class="col">
          <div class="card card-body">
            <xsl:call-template name="entry-note-list"/>
          </div>
        </div>
      </div>

    </xsl:if>

    <!-- Control data -->

    <xsl:if test="xobis:controlData/xobis:id/xobis:alternates or xobis:controlData/xobis:types or xobis:controlData/xobis:actions">

      <div class="row section-head" id="controldata-head">
        <div class="col" data-toggle="collapse" href="#controldata-body" role="button" aria-expanded="true" aria-controls="controldata-body">
          <div class="media">
            <xsl:call-template name="icon-controldata"/>
            <h3 class="media-body">Control Data</h3>
          </div>
        </div>
      </div>

      <div class="row section-body collapse show" id="controldata-body" aria-labelledby="controldata-head" data-parent="#controldata-head">
        <div class="col">
          <div class="card card-body">
            <div class="card-text">
              <xsl:call-template name="control-data"/>
            </div>
          </div>
        </div>
      </div>

    </xsl:if>

  </div>

</xsl:template>

<!-- ==================================== -->
<!-- ============ MAIN ENTRY ============ -->
<!-- ==================================== -->

<!-- main entry class/type icons -->
<xsl:template match="/xobis:record/*">
  <xsl:choose>
    <xsl:when test="name(.)='being'">
      <xsl:call-template name="icon-being"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='human'">
          <xsl:call-template name="icon-type-being-human"/>
        </xsl:when>
        <xsl:when test="@type='nonhuman'">
          <xsl:call-template name="icon-type-being-nonhuman"/>
        </xsl:when>
        <xsl:when test="@type='special'">
          <xsl:call-template name="icon-type-being-special"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='concept'">
      <xsl:call-template name="icon-concept"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@subtype='general'">
          <xsl:call-template name="icon-subtype-concept-general"/>
        </xsl:when>
        <xsl:when test="@subtype='form'">
          <xsl:call-template name="icon-subtype-concept-form"/>
        </xsl:when>
        <xsl:when test="@subtype='topical'">
          <xsl:call-template name="icon-subtype-concept-topical"/>
        </xsl:when>
        <xsl:when test="@subtype='unspecified'">
          <xsl:call-template name="icon-subtype-concept-unspecified"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='event'">
      <xsl:call-template name="icon-event"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='natural'">
          <xsl:call-template name="icon-type-event-natural"/>
        </xsl:when>
        <xsl:when test="@type='meeting'">
          <xsl:call-template name="icon-type-event-meeting"/>
        </xsl:when>
        <xsl:when test="@type='journey'">
          <xsl:call-template name="icon-type-event-journey"/>
        </xsl:when>
        <xsl:when test="@type='occurrence'">
          <xsl:call-template name="icon-type-event-occurrence"/>
        </xsl:when>
        <xsl:when test="@type='miscellaneous'">
          <xsl:call-template name="icon-type-event-miscellaneous"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='language'">
      <xsl:call-template name="icon-language"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='natural'">
          <xsl:call-template name="icon-type-language-natural"/>
        </xsl:when>
        <xsl:when test="@type='constructed'">
          <xsl:call-template name="icon-type-language-constructed"/>
        </xsl:when>
        <xsl:when test="@type='script'">
          <xsl:call-template name="icon-type-language-script"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='object'">
      <xsl:call-template name="icon-object"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='natural'">
          <xsl:call-template name="icon-type-object-natural"/>
        </xsl:when>
        <xsl:when test="@type='crafted'">
          <xsl:call-template name="icon-type-object-crafted"/>
        </xsl:when>
        <xsl:when test="@type='manufactured'">
          <xsl:call-template name="icon-type-object-manufactured"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='organization'">
      <xsl:call-template name="icon-organization"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='business'">
          <xsl:call-template name="icon-type-organization-business"/>
        </xsl:when>
        <xsl:when test="@type='government'">
          <xsl:call-template name="icon-type-organization-government"/>
        </xsl:when>
        <xsl:when test="@type='nonprofit'">
          <xsl:call-template name="icon-type-organization-nonprofit"/>
        </xsl:when>
        <xsl:when test="@type='other'">
          <xsl:call-template name="icon-type-organization-other"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='place'">
      <xsl:call-template name="icon-place"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='natural'">
          <xsl:call-template name="icon-type-place-natural"/>
        </xsl:when>
        <xsl:when test="@type='constructed'">
          <xsl:call-template name="icon-type-place-constructed"/>
        </xsl:when>
        <xsl:when test="@type='jurisdictional'">
          <xsl:call-template name="icon-type-place-jurisdictional"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='string'">
      <xsl:call-template name="icon-string"/><br/>
      <xsl:choose>
        <xsl:when test="@class='word'">
          <xsl:call-template name="icon-class-word"/>
        </xsl:when>
        <xsl:when test="@class='phrase'">
          <xsl:call-template name="icon-class-phrase"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@type='textual'">
          <xsl:call-template name="icon-type-string-textual"/>
        </xsl:when>
        <xsl:when test="@type='numeric'">
          <xsl:call-template name="icon-type-string-numeric"/>
        </xsl:when>
        <xsl:when test="@type='mixed'">
          <xsl:call-template name="icon-type-string-mixed"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='time' or name(.)='duration'">
      <xsl:call-template name="icon-time"/><br/>
      <xsl:call-template name="get-class-icon"/>
    </xsl:when>
    <xsl:when test="name(.)='work'">
      <xsl:call-template name="icon-work"/><br/>
      <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='intellectual'">
          <xsl:call-template name="icon-type-work-intellectual"/>
        </xsl:when>
        <xsl:when test="@type='artistic'">
          <xsl:call-template name="icon-type-work-artistic"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='holdings'">
      <xsl:call-template name="icon-holdings"/>
      <!-- <xsl:call-template name="get-class-icon"/>
      <xsl:choose>
        <xsl:when test="@type='intellectual'">
          <xsl:call-template name="icon-type-work-intellectual"/>
        </xsl:when>
        <xsl:when test="@type='artistic'">
          <xsl:call-template name="icon-type-work-artistic"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose> -->
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-class-icon">
  <xsl:choose>
    <xsl:when test="@class='individual'">
      <xsl:call-template name="icon-class-individual"/>
    </xsl:when>
    <xsl:when test="@class='collective'">
      <xsl:call-template name="icon-class-collective"/>
    </xsl:when>
    <xsl:when test="@class='referential'">
      <xsl:call-template name="icon-class-referential"/>
    </xsl:when>
    <xsl:when test="@class='familial'">
      <xsl:call-template name="icon-class-familial"/>
    </xsl:when>
    <xsl:when test="@class='serial'">
      <xsl:call-template name="icon-class-serial"/>
    </xsl:when>
    <xsl:when test="@class='undifferentiated'">
      <xsl:call-template name="icon-class-undifferentiated"/>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<!-- main entry name and qualifiers (except Time/Duration/Holdings) -->
<xsl:template match="/xobis:record/*[not(self::xobis:time|self::xobis:duration|self::xobis:holdings)]/xobis:entry">
  <xsl:for-each select="*">
    <xsl:choose>
      <xsl:when test="name(.)='name' or name(.)='part'">
        <h1><xsl:apply-templates select="."/></h1>
      </xsl:when>
      <xsl:when test="name(.)='qualifiers' or name(.)='prequalifiers'">
        <h2><xsl:apply-templates select="."/></h2>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<!-- Time/Duration main entry -->
<xsl:template match="/xobis:record/xobis:time/xobis:entry">
  <h1><xsl:call-template name="time-entry"/></h1>
</xsl:template>

<xsl:template match="/xobis:record/xobis:duration/xobis:entry">
  <h1><xsl:call-template name="duration-entry"/></h1>
</xsl:template>


<!-- Holdings main entry -->
<xsl:template match="/xobis:record/xobis:holdings/xobis:entry">
  <xsl:for-each select="*">
    <xsl:choose>
      <!-- linked bib -->
      <xsl:when test="name(.)='work' or name(.)='object'">
        <h1><xsl:apply-templates select="."/></h1>
      </xsl:when>
      <!-- material type -->
      <xsl:when test="name(.)='concept'">
        <h1><xsl:apply-templates select="."/></h1>
      </xsl:when>
      <!-- etc -->
      <xsl:when test="name(.)='qualifiers'">
        <h2><xsl:apply-templates select="."/></h2>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<!-- ==================================== -->
<!-- ============= VARIANTS ============= -->
<!-- ==================================== -->

<!-- variants list -->
<!-- @@@@@ TODO: figure out a way to display romanization groups as well @@@@@ -->
<xsl:key name="variant-group" match="xobis:variants/*/xobis:entry" use="@group"/>
<xsl:template match="/xobis:record/*/xobis:variants">
  <ul class="card-text list-group list-group-flush container-fluid">
    <xsl:for-each select="*">
      <xsl:choose>
        <!-- no group and/or no sumption -->
        <xsl:when test="not(@includes) or xobis:entry[not(@group)]">
          <li class="list-group-item">
            <xsl:apply-templates select="."/>
          </li>
        </xsl:when>
        <!-- only when first in group (once per group ID) -->
        <xsl:when test="xobis:entry[generate-id()=generate-id(key('variant-group',@group)[1])]">
          <li class="list-group-item">
            <!-- sumption heading -->
            <h4>
              <xsl:choose>
                <xsl:when test="@includes='broader'">Includes broader:</xsl:when>
                <xsl:when test="@includes='related'">Includes related:</xsl:when>
                <xsl:otherwise>Includes:</xsl:otherwise>
              </xsl:choose>
            </h4>
            <ul class="card-text list-group list-group-flush">
              <!-- get all with same group ID -->
              <xsl:variable name="group-id" select="xobis:entry/@group"/>
              <xsl:for-each select="../*/xobis:entry[@group=$group-id]">
                <li class="list-group-item">
                  <xsl:apply-templates select=".."/>
                </li>
              </xsl:for-each>
            </ul>
          </li>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:for-each>
  </ul>
</xsl:template>


<!--
<b>Type</b> <i>(Chronology)</i>: Entry with Name/Qualifiers
<ul class="notelist">
  <li>Note 1</li>
  <li>A second note</li>
</ul>
-->

<!-- variant -->
<xsl:template match="xobis:variants/*">
  <xsl:call-template name="variant-type-and-chronology"/>
  <xsl:call-template name="get-element-icon"/>
  <xsl:apply-templates select="xobis:entry"/>
  <!-- note list -->
  <xsl:if test="descendant-or-self::xobis:note">
    <xsl:apply-templates select="xobis:noteList|xobis:note"/>
  </xsl:if>
</xsl:template>

<!-- variant type and/or chronology -->
<xsl:template name="variant-type-and-chronology">
  <!-- type and/or chronology -->
  <xsl:if test="xobis:type or xobis:time or xobis:duration">
    <xsl:if test="xobis:type">
      <b><xsl:apply-templates select="xobis:type"/></b>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:if test="xobis:time or xobis:duration">
      <i><xsl:apply-templates select="xobis:time|xobis:duration"/></i>
    </xsl:if>:
  </xsl:if>
</xsl:template>

<!-- variant entry name and qualifiers (except for Time/Duration and Work) -->
<xsl:template match="xobis:variants/*[not(self::xobis:time|self::xobis:duration|self::xobis:work)]/xobis:entry">
  <xsl:for-each select="*">
    <xsl:choose>
      <xsl:when test="name(.)='name'">
        <xsl:apply-templates select="."/>
      </xsl:when>
      <xsl:when test="name(.)='qualifiers' or name(.)='prequalifiers'">
        <xsl:apply-templates select="."/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
    <xsl:if test="not(position()=last())"> · </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- Time variant entry -->
<xsl:template match="xobis:variants/xobis:time/xobis:entry|xobis:variants/xobis:duration/xobis:entry/xobis:time">
  <xsl:call-template name="time-entry"/>
</xsl:template>

<!-- Duration variant entry -->
<xsl:template match="xobis:variants/xobis:duration/xobis:entry">
  <xsl:apply-templates select="xobis:time[1]"/>–<xsl:apply-templates select="xobis:time[2]"/>
</xsl:template>



<!-- ==================================== -->
<!-- ============= SUMMARY ============== -->
<!-- ==================================== -->

<!-- holdings enumeration/chronology -->

<xsl:template name="summary">
  <xsl:if test="xobis:holdings/xobis:summary/xobis:enumeration">
    <span class="enumeration"><xsl:value-of select="xobis:holdings/xobis:summary/xobis:enumeration"/></span>
  </xsl:if>
  <xsl:if test="xobis:holdings/xobis:summary/xobis:chronology">
    <span class="chronology"><xsl:value-of select="xobis:holdings/xobis:summary/xobis:chronology"/></span>
  </xsl:if>
</xsl:template>


<!-- ==================================== -->
<!-- ========== RELATIONSHIPS =========== -->
<!-- ==================================== -->


<!-- <table class="table table-sm">
  <tr>
    <th scope="row"><a href="#">Author</a></th>
    <td><i>(1 : 1963-1978)</i> <a href="#"><img src="../static/img/elements/being.svg" title="Being"/>Smith, Jane, 1960-</a></td>
  </tr>
  <tr>
    <th scope="row"><a href="#">Topic</a></th>
    <td><a href="#"><img src="../static/img/elements/concept.svg" title="Concept"/>Ornithine Carbamoyltransferase</a></td>
  </tr>
  <tr>
    <th scope="row"><a href="#">Founded</a></th>
    <td><a href="#"><img src="../static/img/elements/time.svg" title="Time"/>1868-05-28</a>
    <div class="relationship-note">Note about this relationship</div></td>
  </tr>
</table> -->


<!-- organize by PE type -->

<xsl:key name="concept-rel-group" match="xobis:relationship" use="name"/>
<xsl:template match="/xobis:record/*/xobis:variants">
  <ul class="card-text list-group list-group-flush container-fluid">
    <xsl:for-each select="*">
      <xsl:choose>
        <!-- no group and/or no sumption -->
        <xsl:when test="not(@includes) or xobis:entry[not(@group)]">
          <li class="list-group-item">
            <xsl:apply-templates select="."/>
          </li>
        </xsl:when>
        <!-- only when first in group (once per group ID) -->
        <xsl:when test="xobis:entry[generate-id()=generate-id(key('variant-group',@group)[1])]">
          <li class="list-group-item">
            <!-- sumption heading -->
            <h4>
              <xsl:choose>
                <xsl:when test="@includes='broader'">Includes broader:</xsl:when>
                <xsl:when test="@includes='related'">Includes related:</xsl:when>
                <xsl:otherwise>Includes:</xsl:otherwise>
              </xsl:choose>
            </h4>
            <ul class="card-text list-group list-group-flush">
              <!-- get all with same group ID -->
              <xsl:variable name="group-id" select="xobis:entry/@group"/>
              <xsl:for-each select="../*/xobis:entry[@group=$group-id]">
                <li class="list-group-item">
                  <xsl:apply-templates select=".."/>
                </li>
              </xsl:for-each>
            </ul>
          </li>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="relationships">
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:being">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:being]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:concept">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:concept]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:event">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:event]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:language">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:language]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:object">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:object]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:organization">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:organization]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:place">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:place]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:string">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:string]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:time">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:time]"/>
    </table>
  </xsl:if>
  <xsl:if test="xobis:relationships/xobis:relationship/xobis:target/xobis:work">
    <table class="table table-sm">
      <xsl:apply-templates select="xobis:relationships/*[xobis:target/xobis:work]"/>
    </table>
  </xsl:if>
</xsl:template>


<!-- each relationship -->
<xsl:template match="xobis:relationships/*">
  <tr>
    <th scope="row"><xsl:call-template name="relationship-info"/></th>
    <td>
      <!-- enumeration/chronology -->
      <xsl:if test="xobis:string or xobis:time or xobis:duration">
        (<i>
        <xsl:if test="xobis:string">
          <xsl:apply-templates select="xobis:string"/>
          <xsl:if test="xobis:time or xobis:duration">
            :
          </xsl:if>
        </xsl:if>
        <xsl:apply-templates select="xobis:time|xobis:duration"/>
        </i>)
      </xsl:if>
      <!-- target -->
      <xsl:for-each select="xobis:target/*">
        <xsl:call-template name="get-element-icon"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <!-- note list -->
      <xsl:if test="descendant-or-self::xobis:note">
        <div class="relationship-note">
          <xsl:apply-templates select="xobis:noteList|xobis:note"/>
        </div>
      </xsl:if>
    </td>
  </tr>
</xsl:template>


<xsl:template name="relationship-info">
  <a>
    <xsl:attribute name="class">
      <!-- type (associative, preordinate etc.) -->
      <xsl:value-of select="@type"/>
      <xsl:if test="@type and @degree"><xsl:text> </xsl:text></xsl:if>
      <!-- degree -->
      <xsl:value-of select="@degree"/>
    </xsl:attribute>
    <!-- name -->
    <xsl:if test="not(xobis:name/@href='unverified')">
      <xsl:copy-of select="xobis:name/@href"/>
    </xsl:if>
    <xsl:copy-of select="xobis:name/@title"/>
    <span><xsl:apply-templates select="xobis:name/@lang"/>
      <xsl:value-of select="xobis:name"/>
    </span>
  </a>
</xsl:template>





<!-- ==================================== -->
<!-- ============== NOTES =============== -->
<!-- ==================================== -->

<!--  ...  ...  ...  ...  ...  ...  -->
<!--  ...  ...  ...  ...  ...  ...  -->
<!--  ...  ...  ...  ...  ...  ...  -->

<xsl:template name="entry-note-list">
  <xsl:apply-templates select="*/xobis:noteList|*/xobis:note"/>
</xsl:template>
<!--
<li lang="eng" class="transcription">Note 1</li>
<li><a href="#">Note 2, with a link</a></li>
<li>Note 3</li> -->

<!-- ==================================== -->
<!-- =========== CONTROL DATA =========== -->
<!-- ==================================== -->

<!--
  <h4>Alternate IDs</h4>
    <ul id="altids">
      <li><a href="#">ORCID</a>: 1902401271</li>
      <li>
        <a href="#">NLM</a>: (DNLM)037296739
        <ul class="notelist">
          <li>Note about this ID</li>
        </ul>
      </li>
      <li><a href="#">NLM</a>: (DNLM)932343139 [invalid]</li>
    </ul>
  <h4>Record Types</h4>
    <ul id="subsets">
      <li><a href="#">Subset, Test</a></li>
      <li><a href="#">LaneConnex</a></li>
      <li><a href="#">NoExport</a></li>
    </ul>
  <h4>Record Actions</h4>
    <ul id="actions">
      <li>time: action</li>
      <li>time: action</li>
      <li>time: action</li>
    </ul>
-->

<xsl:template name="control-data">
  <xsl:if test="xobis:controlData/xobis:id/xobis:alternates">
    <h4>Alternate IDs</h4>
    <ul id="altids">
      <xsl:for-each select="xobis:controlData/xobis:id/xobis:alternates/xobis:id">
        <li><xsl:apply-templates select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:if>
  <xsl:if test="xobis:controlData/xobis:types">
    <h4>Record Types</h4>
    <ul id="subsets">
      <xsl:for-each select="xobis:controlData/xobis:types/xobis:type">
        <li><xsl:apply-templates select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:if>
  <xsl:if test="xobis:controlData/xobis:actions">
    <h4>Record Actions</h4>
    <ul id="actions">
      <xsl:for-each select="xobis:controlData/xobis:actions/xobis:action">
        <li><xsl:apply-templates select="*[self::xobis:time|self::xobis:duration]"/> : <xsl:apply-templates select="xobis:type"/></li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>



</xsl:stylesheet>
