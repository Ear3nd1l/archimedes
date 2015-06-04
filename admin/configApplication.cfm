<cfset VARIABLES.days = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['ApplicationTimeout']['Days'].xmlText />
<cfset VARIABLES.hours = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['ApplicationTimeout']['Hours'].xmlText />
<cfset VARIABLES.minutes = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['ApplicationTimeout']['Minutes'].xmlText />
<cfset VARIABLES.seconds = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['ApplicationTimeout']['Seconds'].xmlText />
<cfset VARIABLES.cfcPath = THIS.xmlArchimedesConfiguration['Archimedes']['SiteSettings']['CfcPath'].xmlText />
<cfset VARIABLES.customTagPaths = THIS.xmlArchimedesConfiguration['Archimedes']['SiteSettings']['CustomTagPaths'].xmlText />

<cfset THIS.ApplicationTimeout = CreateTimeSpan(VARIABLES.days,VARIABLES.hours,VARIABLES.minutes,VARIABLES.seconds) />
<cfset THIS.ApplicationName = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['ApplicationName'].xmlText />
<cfset THIS.SetClientCookies = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['SetClientCookies'].xmlText />
<cfset THIS.ShowDebugSettings = THIS.xmlArchimedesConfiguration['Archimedes']['ApplicationSettings']['ShowDebugSettings'].xmlText />
<cfset THIS.mappings['/ArchimedesCFC'] = ExpandPath(VARIABLES.cfcPath) />
<cfset THIS.CustomTagPaths = ExpandPath(VARIABLES.customTagPaths) />
