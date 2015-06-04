<cfset THIS.xmlArchimedesConfiguration = XmlParse("../archimedes.config", "yes") />

<cfset Application.HelperPath = THIS.xmlArchimedesConfiguration['Archimedes']['SiteSettings']['HelperPath'].xmlText />

<!--- Set up the data source --->
<cfset VARIABLES.days = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Days'].xmlText />
<cfset VARIABLES.hours = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Hours'].xmlText />
<cfset VARIABLES.minutes = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Minutes'].xmlText />
<cfset VARIABLES.seconds = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Seconds'].xmlText />

<cfset DSN = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['DatasourceName'].xmlText />
<cfset CachedWithin = CreateTimeSpan(VARIABLES.days,VARIABLES.hours,VARIABLES.minutes,VARIABLES.seconds) />
