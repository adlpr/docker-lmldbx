<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.xobis.info/ns/2.0/" xmlns:xobis="http://www.xobis.info/ns/2.0/">

<!-- Principal Elements -->

<xsl:template name="icon-being">
  <img src="../static/img/elements/being.svg" title="Being"/>
</xsl:template>

<xsl:template name="icon-concept">
  <img src="../static/img/elements/concept.svg" title="Concept"/>
</xsl:template>

<xsl:template name="icon-event">
  <img src="../static/img/elements/event.svg" title="Event"/>
</xsl:template>

<xsl:template name="icon-language">
  <img src="../static/img/elements/language.svg" title="Language"/>
</xsl:template>

<xsl:template name="icon-object">
  <img src="../static/img/elements/object.svg" title="Object"/>
</xsl:template>

<xsl:template name="icon-organization">
  <img src="../static/img/elements/organization.svg" title="Organization"/>
</xsl:template>

<xsl:template name="icon-place">
  <img src="../static/img/elements/place.svg" title="Place"/>
</xsl:template>

<xsl:template name="icon-string">
  <img src="../static/img/elements/string.svg" title="String"/>
</xsl:template>

<xsl:template name="icon-time">
  <img src="../static/img/elements/time.svg" title="Time"/>
</xsl:template>

<xsl:template name="icon-work">
  <img src="../static/img/elements/work.svg" title="Work"/>
</xsl:template>

<xsl:template name="icon-holdings">
  <img src="../static/img/elements/holdings.svg" title="Holdings"/>
</xsl:template>



<!-- Roles -->

<xsl:template name="icon-role-authority">
  <img src="../static/img/roles/authority.svg" title="authority"/>
</xsl:template>

<xsl:template name="icon-role-instance">
  <img src="../static/img/roles/instance.svg" title="instance"/>
</xsl:template>

<xsl:template name="icon-role-authority-instance">
  <img src="../static/img/roles/autinst.svg" title="authority instance"/>
</xsl:template>



<!-- Classes -->

<xsl:template name="icon-class-collective">
  <img src="../static/img/classes/collective.svg" title="collective"/>
</xsl:template>

<xsl:template name="icon-class-familial">
  <img src="../static/img/classes/familial.svg" title="familial"/>
</xsl:template>

<xsl:template name="icon-class-individual">
  <img src="../static/img/classes/individual.svg" title="individual"/>
</xsl:template>

<xsl:template name="icon-class-referential">
  <img src="../static/img/classes/referential.svg" title="referential"/>
</xsl:template>

<xsl:template name="icon-class-serial">
  <img src="../static/img/classes/serial.svg" title="serial"/>
</xsl:template>

<xsl:template name="icon-class-undifferentiated">
  <img src="../static/img/classes/undifferentiated.svg" title="undifferentiated"/>
</xsl:template>

<xsl:template name="icon-class-word">
  <img src="../static/img/classes/individual.svg" title="word"/>
</xsl:template>

<xsl:template name="icon-class-phrase">
  <img src="../static/img/classes/phrase.svg" title="phrase"/>
</xsl:template>



<!-- Types -->

<xsl:template name="icon-type-being-human">
  <img src="../static/img/types/being-human.svg" title="human"/>
</xsl:template>

<xsl:template name="icon-type-being-nonhuman">
  <img src="../static/img/types/being-nonhuman.svg" title="nonhuman"/>
</xsl:template>

<xsl:template name="icon-type-being-special">
  <img src="../static/img/types/being-special.svg" title="special"/>
</xsl:template>

<xsl:template name="icon-type-concept-abstract">
  <img src="../static/img/types/concept-abstract.svg" title="abstract"/>
</xsl:template>

<xsl:template name="icon-type-concept-collective">
  <img src="../static/img/classes/collective.svg" title="collective"/>
</xsl:template>

<xsl:template name="icon-type-concept-control">
  <img src="../static/img/types/concept-control.svg" title="control"/>
</xsl:template>

<xsl:template name="icon-type-concept-specific">
  <img src="../static/img/types/concept-specific.svg" title="specific"/>
</xsl:template>

<xsl:template name="icon-subtype-concept-general">
  <img src="../static/img/types/miscellaneous.svg" title="general"/>
</xsl:template>

<xsl:template name="icon-subtype-concept-form">
  <img src="../static/img/elements/object.svg" title="form"/>
</xsl:template>

<xsl:template name="icon-subtype-concept-topical">
  <img src="../static/img/types/being-special.svg" title="topical"/>
</xsl:template>

<xsl:template name="icon-subtype-concept-unspecified">
  <img src="../static/img/classes/undifferentiated.svg" title="unspecified"/>
</xsl:template>

<xsl:template name="icon-type-event-natural">
  <img src="../static/img/types/natural.svg" title="natural"/>
</xsl:template>

<xsl:template name="icon-type-event-meeting">
  <img src="../static/img/types/event-meeting.svg" title="meeting"/>
</xsl:template>

<xsl:template name="icon-type-event-journey">
  <img src="../static/img/types/event-journey.svg" title="journey"/>
</xsl:template>

<xsl:template name="icon-type-event-occurrence">
  <img src="../static/img/types/event-occurrence.svg" title="occurrence"/>
</xsl:template>

<xsl:template name="icon-type-event-miscellaneous">
  <img src="../static/img/types/miscellaneous.svg" title="miscellaneous"/>
</xsl:template>

<xsl:template name="icon-type-language-natural">
  <img src="../static/img/types/natural.svg" title="natural"/>
</xsl:template>

<xsl:template name="icon-type-language-constructed">
  <img src="../static/img/types/constructed.svg" title="constructed"/>
</xsl:template>

<xsl:template name="icon-type-language-script">
  <img src="../static/img/types/language-script.svg" title="script"/>
</xsl:template>

<xsl:template name="icon-type-object-natural">
  <img src="../static/img/types/natural.svg" title="natural"/>
</xsl:template>

<xsl:template name="icon-type-object-crafted">
  <img src="../static/img/types/object-crafted.svg" title="crafted"/>
</xsl:template>

<xsl:template name="icon-type-object-manufactured">
  <img src="../static/img/types/object-manufactured.svg" title="manufactured"/>
</xsl:template>

<xsl:template name="icon-type-organization-business">
  <img src="../static/img/types/organization-business.svg" title="business"/>
</xsl:template>

<xsl:template name="icon-type-organization-government">
  <img src="../static/img/types/organization-government.svg" title="government"/>
</xsl:template>

<xsl:template name="icon-type-organization-nonprofit">
  <img src="../static/img/types/organization-nonprofit.svg" title="nonprofit"/>
</xsl:template>

<xsl:template name="icon-type-organization-other">
  <img src="../static/img/types/miscellaneous.svg" title="other"/>
</xsl:template>

<xsl:template name="icon-type-place-natural">
  <img src="../static/img/types/natural.svg" title="natural"/>
</xsl:template>

<xsl:template name="icon-type-place-constructed">
  <img src="../static/img/types/constructed.svg" title="constructed"/>
</xsl:template>

<xsl:template name="icon-type-place-jurisdictional">
  <img src="../static/img/types/place-jurisdictional.svg" title="jurisdictional"/>
</xsl:template>

<xsl:template name="icon-type-string-textual">
  <img src="../static/img/types/string-textual.svg" title="textual"/>
</xsl:template>

<xsl:template name="icon-type-string-numeric">
  <img src="../static/img/types/string-numeric.svg" title="numeric"/>
</xsl:template>

<xsl:template name="icon-type-string-mixed">
  <img src="../static/img/types/string-mixed.svg" title="mixed"/>
</xsl:template>

<xsl:template name="icon-type-work-intellectual">
  <img src="../static/img/types/work-intellectual.svg" title="intellectual"/>
</xsl:template>

<xsl:template name="icon-type-work-artistic">
  <img src="../static/img/types/work-artistic.svg" title="artistic"/>
</xsl:template>



<!-- Sections -->

<xsl:template name="icon-variants">
  <img class="align-self-center" src="../static/img/sections/variants.svg" title="Variants"/>
</xsl:template>

<xsl:template name="icon-summary">
  <img class="align-self-center" src="../static/img/sections/summary.svg" title="Summary"/>
</xsl:template>

<xsl:template name="icon-relationships">
  <img class="align-self-center" src="../static/img/sections/relationships.svg" title="Relationships"/>
</xsl:template>

<xsl:template name="icon-notes">
  <img class="align-self-center" src="../static/img/sections/notes.svg" title="Notes"/>
</xsl:template>

<xsl:template name="icon-controldata">
  <img class="align-self-center" src="../static/img/sections/controldata.svg" title="Control Data"/>
</xsl:template>



</xsl:stylesheet>
