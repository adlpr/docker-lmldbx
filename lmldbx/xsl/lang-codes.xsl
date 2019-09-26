<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.xobis.info/ns/2.0/" xmlns:xobis="http://www.xobis.info/ns/2.0/">

<!-- Convert authorized language name to RFC 3066 code -->

<xsl:template match="@lang">
  <xsl:attribute name="lang">
    <xsl:choose>
      <xsl:when test=".='Afrikaans'">af</xsl:when>
      <xsl:when test=".='Albanian'">sq</xsl:when>
      <xsl:when test=".='Amharic'">am</xsl:when>
      <xsl:when test=".='Arabic'">ar</xsl:when>
      <xsl:when test=".='Aramaic'">arc</xsl:when>
      <xsl:when test=".='Armenian'">hy</xsl:when>
      <xsl:when test=".='Azerbaijani'">az</xsl:when>
      <xsl:when test=".='Baluchi'">bal</xsl:when>
      <xsl:when test=".='Bashkir'">ba</xsl:when>
      <xsl:when test=".='Basque'">eu</xsl:when>
      <xsl:when test=".='Batak'">btk</xsl:when>
      <xsl:when test=".='Bengali'">bn</xsl:when>
      <xsl:when test=".='Bilingual'">mul</xsl:when>
      <xsl:when test=".='Bosnian'">bs</xsl:when>
      <xsl:when test=".='British English'">en-GB</xsl:when>
      <xsl:when test=".='Bulgarian'">bg</xsl:when>
      <xsl:when test=".='Burmese'">my</xsl:when>
      <xsl:when test=".='Byelorussian'">be</xsl:when>
      <xsl:when test=".='Catalan'">ca</xsl:when>
      <xsl:when test=".='Central American Indian (Other)'">cai</xsl:when>
      <xsl:when test=".='Chinese'">zh</xsl:when>
      <xsl:when test=".='Coptic'">cop</xsl:when>
      <xsl:when test=".='Croatian'">hr</xsl:when>
      <xsl:when test=".='Czech'">cs</xsl:when>
      <xsl:when test=".='Danish'">da</xsl:when>
      <xsl:when test=".='Delaware (Language)'">del</xsl:when>
      <xsl:when test=".='Dravidian'">dra</xsl:when>
      <xsl:when test=".='Dutch'">nl</xsl:when>
      <xsl:when test=".='Dutch, Middle'">dum</xsl:when>
      <xsl:when test=".='Egyptian'">egy</xsl:when>
      <xsl:when test=".='English'">en</xsl:when>
      <xsl:when test=".='English, Middle (ca. 1100-1500)'">enm</xsl:when>
      <xsl:when test=".='English, Old (ca. 450-1100)'">ang</xsl:when>
      <xsl:when test=".='Eskimo-Aleut'">esx</xsl:when> <!-- ISO 639-5 macro code, technically invalid under RFC -->
      <xsl:when test=".='Esperanto'">eo</xsl:when>
      <xsl:when test=".='Estonian'">et</xsl:when>
      <xsl:when test=".='Ethiopic'">gez</xsl:when>
      <xsl:when test=".='Faroese'">fo</xsl:when>
      <xsl:when test=".='Finnish'">fi</xsl:when>
      <xsl:when test=".='French'">fr</xsl:when>
      <xsl:when test=".='French, Middle'">frm</xsl:when>
      <xsl:when test=".='French, Old'">fro</xsl:when>
      <xsl:when test=".='Frisian'">fy</xsl:when>
      <xsl:when test=".='Gaelic (Scots)'">gd</xsl:when>
      <xsl:when test=".='Gallegan'">gl</xsl:when>
      <xsl:when test=".='Georgian'">ka</xsl:when>
      <xsl:when test=".='German'">de</xsl:when>
      <xsl:when test=".='German, Middle High (ca. 1050-1500)'">gmh</xsl:when>
      <xsl:when test=".='Greek, Ancient'">grc</xsl:when>
      <xsl:when test=".='Greek, Modern'">el</xsl:when>
      <xsl:when test=".='Gujarati'">gu</xsl:when>
      <xsl:when test=".='Haitian French Creole'">ht</xsl:when>
      <xsl:when test=".='Hausa'">ha</xsl:when>
      <xsl:when test=".='Hawaiian'">haw</xsl:when>
      <xsl:when test=".='Hebrew'">he</xsl:when>
      <xsl:when test=".='Hindi'">hi</xsl:when>
      <xsl:when test=".='Hungarian'">hu</xsl:when>
      <xsl:when test=".='Icelandic'">is</xsl:when>
      <xsl:when test=".='Igbo'">ig</xsl:when>
      <xsl:when test=".='Indonesian'">id</xsl:when>
      <xsl:when test=".='Interlingua'">ia</xsl:when>
      <xsl:when test=".='Irish'">ga</xsl:when>
      <xsl:when test=".='Italian'">it</xsl:when>
      <xsl:when test=".='Japanese'">ja</xsl:when>
      <xsl:when test=".='Javanese'">jv</xsl:when>
      <xsl:when test=".='Kazakh'">kk</xsl:when>
      <xsl:when test=".='Khmer'">km</xsl:when>
      <xsl:when test=".='Korean'">ko</xsl:when>
      <xsl:when test=".='Kurdish'">ku</xsl:when>
      <xsl:when test='.="Langue d&apos;oc"'>oc</xsl:when>
      <xsl:when test=".='Lao'">lo</xsl:when>
      <xsl:when test=".='Latin'">la</xsl:when>
      <xsl:when test=".='Latvian'">lv</xsl:when>
      <xsl:when test=".='Lithuanian'">lt</xsl:when>
      <xsl:when test=".='Luxembourgish'">lb</xsl:when>
      <xsl:when test=".='Macedonian'">mk</xsl:when>
      <xsl:when test=".='Malagasy'">mg</xsl:when>
      <xsl:when test=".='Malay'">ms</xsl:when>
      <xsl:when test=".='Malayalam'">ml</xsl:when>
      <xsl:when test=".='Maltese'">mt</xsl:when>
      <xsl:when test=".='Maori'">mi</xsl:when>
      <xsl:when test=".='Marathi'">mr</xsl:when>
      <xsl:when test=".='Masai'">mas</xsl:when>
      <xsl:when test=".='Mixed'">mul</xsl:when>
      <xsl:when test=".='Moldavian'">ro-MD</xsl:when>
      <xsl:when test=".='Mongolian'">mn</xsl:when>
      <xsl:when test=".='Multilingual'">mul</xsl:when>
      <xsl:when test=".='Nahuatl'">nah</xsl:when>
      <xsl:when test=".='Ndebele (Zimbabwe)'">nd</xsl:when>
      <xsl:when test=".='Nepali'">ne</xsl:when>
      <xsl:when test=".='No Linguistic Content'">zxx</xsl:when>
      <xsl:when test=".='North American Indian (Other)'">nai</xsl:when>
      <xsl:when test=".='Norwegian'">nb</xsl:when> <!-- assumes bokmål -->
      <xsl:when test=".='Oirat'">xal</xsl:when>
      <xsl:when test=".='Pali'">pi</xsl:when>
      <xsl:when test=".='Panjabi'">pa</xsl:when>
      <xsl:when test=".='Persian'">fa</xsl:when>
      <xsl:when test=".='Persian, Middle'">pal</xsl:when>
      <xsl:when test=".='Persian, Old'">peo</xsl:when>
      <xsl:when test=".='Polish'">pl</xsl:when>
      <xsl:when test=".='Portuguese'">pt</xsl:when>
      <xsl:when test=".='Provençal'">pro</xsl:when>
      <xsl:when test=".='Pushto'">ps</xsl:when>
      <xsl:when test=".='Raeto-Romance'">rm</xsl:when>
      <xsl:when test=".='Romanian'">ro</xsl:when>
      <xsl:when test=".='Russian'">ru</xsl:when>
      <xsl:when test=".='Sanskrit'">sa</xsl:when>
      <xsl:when test=".='Serbian'">sr</xsl:when>
      <xsl:when test=".='Shona'">sn</xsl:when>
      <xsl:when test=".='Singhalese'">si</xsl:when>
      <xsl:when test=".='Slavic (Other)'">sla</xsl:when>
      <xsl:when test=".='Slovak'">sk</xsl:when>
      <xsl:when test=".='Slovenian'">sl</xsl:when>
      <xsl:when test=".='Somali'">so</xsl:when>
      <xsl:when test=".='Spanish'">es</xsl:when>
      <xsl:when test=".='Sundanese'">su</xsl:when>
      <xsl:when test=".='Swahili'">sw</xsl:when>
      <xsl:when test=".='Swedish'">sv</xsl:when>
      <xsl:when test=".='Syriac'">syr</xsl:when>
      <xsl:when test=".='Tagalog'">tl</xsl:when>
      <xsl:when test=".='Tajik'">tg</xsl:when>
      <xsl:when test=".='Tamil'">ta</xsl:when>
      <xsl:when test=".='Tatar'">tt</xsl:when>
      <xsl:when test=".='Telugu'">te</xsl:when>
      <xsl:when test=".='Thai'">th</xsl:when>
      <xsl:when test=".='Tibetan'">bo</xsl:when>
      <xsl:when test=".='Tswana'">tn</xsl:when>
      <xsl:when test=".='Turkish'">tr</xsl:when>
      <xsl:when test=".='Turkish, Ottoman'">ota</xsl:when>
      <xsl:when test=".='Uighur'">ug</xsl:when>
      <xsl:when test=".='Ukrainian'">uk</xsl:when>
      <xsl:when test=".='Urdu'">ur</xsl:when>
      <xsl:when test=".='Uzbek'">uz</xsl:when>
      <xsl:when test=".='Vietnamese'">vi</xsl:when>
      <xsl:when test=".='Welsh'">cy</xsl:when>
      <xsl:when test=".='Xhosa'">xh</xsl:when>
      <xsl:when test=".='Yiddish'">yi</xsl:when>
      <xsl:when test=".='Yoruba'">yo</xsl:when>
      <xsl:when test=".='Zulu'">zu</xsl:when>
      <xsl:otherwise>und</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>
