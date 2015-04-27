<!---
This CFC is released under the Apache 2.0 License
For more info, read: http://www.apache.org/licenses/LICENSE-2.0

Author Chuck Savage
© Copyright SeaRisen LLC 2009
Created November of 2009

Need to ReplaceAll
mg.model.linkedlist.LinkedList with (your location)

This is SAMPLE code, don't look for documentation.  It isn't a part of
the LinkedList package, but is only a sample example of how you _could_
use the linked list.

The Purpose:
This file was created for use in a project that needed several series
of files that would rotate based on page refreshes.  This is an alpha of
what could be done, not final code.  It does work, but Refresh() needs to
be called, and the data isn't stored in any manner other than in the
linked list.

See the demo at: http://www.SeaRisen.com/mg/?event=demo.linkedseries

I put this code in this package because someone from the blog I posted on
about this project may be interested in it.  Unfortunately I don't have a link
to that blog page, though its on www.coldfusionjedi.com Ray Camden's blog.
--->
<cfcomponent name="LinkedSeries" output="false">  
   
<cffunction name="Init" returntype="any" access="public" output="false">
	<cfargument name="numRanks" type="numeric" default="10" hint="Length of Array">
  <cfif numRanks LT 1 >
  	<cfthrow message="Number of ranks must be 1 or more">
	</cfif>
  <cfset variables.max = numRanks>
	<cfset variables.array = ArrayNew(1)>
  <cfloop index="i" from="1" to="#variables.max#">
  	<cfset variables.array[i] = CreateObject("component", "mg.model.linkedlist.LinkedList")>
  </cfloop>
	<cfreturn this />  
</cffunction>  

<cffunction name="ValidateRank" returntype="void" access="private" output="no">
  <cfargument name="rank" type="numeric" required="yes" hint="Rank to validate">
  <cfif not IsValid("range", rank, 1, variables.max)>
		<cfthrow message="Rank out of bounds" />
	</cfif>
  <cfif not StructKeyExists(variables, 'array')>
		<cfset Init()>
	</cfif>
</cffunction>

<cffunction name="Add" returntype="void" access="public" output="false">  
  <cfargument name="rank" type="numeric" required="no" default="1" hint="Rank to add value too">
  <cfargument name="value" type="any" required="yes" hint="Value to add">

  <cfset ValidateRank(rank)>
  <cfset variables.array[rank].Add(value)>
</cffunction>  

<cffunction name="First" 
						returntype="any" 
            access="public" 
            output="false"
            description="Get first value in rank">
  <cfargument name="rank" 
  						type="numeric" 
              required="no" 
              default="1" 
              hint="Rank to get value from">
  
  <cfset ValidateRank(rank)>
  <cfreturn variables.array[rank].First()>
</cffunction>

<cffunction name="Next" 
						returntype="any" 
            access="public" 
            output="no"
            description="Get next value in rank">
  <cfargument name="rank" 
  						type="numeric" 
              required="no" 
              default="1" 
              hint="Rank to get value from">

  <cfset ValidateRank(rank)>
  <cfreturn variables.array[rank].Next()>
</cffunction>

<cffunction name="Refresh" 
						returntype="void" 
            access="public" 
            output="no" 
            description="move fronts to end of lists">

  <cfloop index="i" from="1" to="#variables.max#">
    <cftry> <!--- Pop() throws error if list empty --->
      <cfset variables.array[i].Add( variables.array[i].Pop() )>
      <cfcatch type="any"></cfcatch>
    </cftry>
  </cfloop>
</cffunction>

<cffunction name="Clear" 
						returntype="void" 
            access="public" 
            output="no" 
            description="Clear rank or all">
	<cfargument name="rank" type="numeric" required="no" default="0" hint="Rank to clear">
  
  <cfif rank LT 1>
    <cfloop index="i" from="1" to="#variables.max#">
    	<cfset variables.array[i].Clear()>
    </cfloop>
	<cfelse>
  	<cfif rank LTE variables.max>
			<cfset variables.array[rank].Clear()>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="Dump" returntype="void" access="public" output="yes">
  <cfargument name="rank" type="numeric" required="no" hint="Rank to dump, or all if not passed in">

	<cfif StructKeyExists( arguments, 'rank' )>
    <cfset variables.array[rank].Dump()>
	<cfelse>  
    <cfloop index="i" from="1" to="#variables.max#">
    	<cfoutput>Rank: #i# -</cfoutput>
      <cftry>
	      <cfset variables.array[i].DumpValues()>
        <br>
      <cfcatch type="any">
      	is Empty<br>
      </cfcatch>
      </cftry>
    </cfloop>
	</cfif>
</cffunction>

</cfcomponent>
