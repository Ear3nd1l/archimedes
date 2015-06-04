<!--- Set up the application. --->
<cfset Application.SiteID = THIS.xmlArchimedesConfiguration['Archimedes']['SiteSettings']['SiteID'].xmlText />
<cfset Application.URLRoot = THIS.xmlArchimedesConfiguration['Archimedes']['SiteSettings']['UrlRoot'].xmlText />
<cfset Application.HelperPath = THIS.xmlArchimedesConfiguration['Archimedes']['SiteSettings']['HelperPath'].xmlText />

<!--- Set up the data source --->
<cfset VARIABLES.days = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Days'].xmlText />
<cfset VARIABLES.hours = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Hours'].xmlText />
<cfset VARIABLES.minutes = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Minutes'].xmlText />
<cfset VARIABLES.seconds = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['CachedWithin']['Seconds'].xmlText />

<cfset Application.DSN = THIS.xmlArchimedesConfiguration['Archimedes']['DataSettings']['DatasourceName'].xmlText />
<cfset Application.CachedWithin = CreateTimeSpan(VARIABLES.days,VARIABLES.hours,VARIABLES.minutes,VARIABLES.seconds) />
