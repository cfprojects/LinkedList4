<!---
This demo is released under the Apache 2.0 License
For more info, read: http://www.apache.org/licenses/LICENSE-2.0

Author Chuck Savage
© Copyright SeaRisen LLC 2009
Created December of 2009

This code demo assumes that the linked list files are contained in the directory
/mg/model/linkedlist.  As do the linked list cfc's make the same assumption.

This is the code taken from the demo at 
http://www.SeaRisen.com/mg/?event=demo.linkedlist
--->

<h1>Linked List Demo</h1>
<p align="justify">The linked list component has been upgraded, it now includes the LinkedList.cfc, Iterator.cfc and Link.cfc.  <a target="_blank" href="http://linkedlist.riaforge.org/">Code</a> available at <a href="http://riaforge.com">RIAForge</a>.</p>

<cfscript>
	ll = CreateObject("component", "mg.model.linkedlist.linkedlist");
	ll.Add("B"); // Add adds to end of list
	ll.Add("C");
	ll.Push("A"); // Push pushes to front of list
	ll.Add(true);
	ll.Add(false);
	ll.Push(0);
	ll.Dump();
</cfscript>

<!--- There are several ways to do loops, the first is to get the First() value
and then call Next() over and over until Next() throws an error.  That's why we surround the loop in a try/catch block --->

<p>Loop using try/catch and Next() calls</p>

First: <cfdump var="#ll.First()#"><br />
<cftry> <!--- throws error when Next() attempts to read past the end of the list --->
  <cfloop condition="true">
		<cfset value = ll.Next()> <!--- attempt to read value first, instead 
			of placing this in dump statement, so throw doesn't output anything --->
    Next: <cfdump var="#value#"><br />
  </cfloop>
  <cfcatch type="any"></cfcatch>
</cftry>

<!--- Or we can use the Iterator to do the loop.  The iterator has references
to the links, we can iterate over the list forward or backwards depending on the
value we pass to loop(forward=true) to go forwards, or loop(forward=false)
to go backwards FROM the current position. --->

<p>OR We run this much cleaner LOOP w/ iterators built in loop code</p>
<cfset iterator = ll.Iterator()> <!--- defaults to first link --->
<cfloop condition="iterator.loop(forward=true)">
Value: <cfdump var="#iterator.Value()#"><br />
</cfloop>

<!--- since iterator at the last position already, don't need to set it --->

<p>The loop backwards</p>
<cfloop condition="iterator.loop(forward=false)">
  Value: <cfdump var="#iterator.Value()#"><br />
</cfloop>

<p>Loop backwards using try/catch and Prev() calls</p>

Last: <cfdump var="#ll.Last()#"><br />
<cftry> <!--- throws error when Prev() attempts to read past the front of the list --->
  <cfloop condition="true">
		<cfset value = ll.Prev()> <!--- attempt to read value first, instead of placing this in dump statement, so throw doesn't output anything --->
    Prev: <cfdump var="#value#"><br />
  </cfloop>
  <cfcatch type="any"></cfcatch>
</cftry>

<p>Now pop some values, from the back first and then the front to demonstrate
these methods, as well as showing the length.</p>

Length: <cfoutput>#ll.Length()#</cfoutput><br />
PopBack: <cfdump var="#ll.PopBack()#"><br />
<cfset ll.Dump()>

Length: <cfoutput>#ll.Length()#</cfoutput><br />
Pop: <cfdump var="#ll.Pop()#"><br />
<cfset ll.Dump()>

Length: <cfoutput>#ll.Length()#</cfoutput>

<p>Demonstrate InsertAt('Here', iterator {value = 'C'})</p>

<cfset iterator = ll.Iterator()>
<cfloop condition="iterator.loop(forward=true)">
	<cfif iterator.Value() EQ 'C'>
  	<cfset ll.InsertAt('Here',iterator)>
    <cfbreak>
	</cfif>
</cfloop>
<cfset ll.Dump()>

Length: <cfoutput>#ll.Length()#</cfoutput>

<p>Demonstrate InsertAt('Top', ll.Iterator())</p>

<cfset ll.InsertAt('Top', ll.Iterator())>
<cfset ll.Dump()>

<p>Not nearly as efficient as calling Push(), but it works.</p>

Length: <cfoutput>#ll.Length()#</cfoutput>

<p>Demonstrate InsertAt('Last', ll.Iterator())</p>

<cfset iterator = ll.Iterator()>
<cfset iterator.Last()>
<cfset ll.InsertAt('Last', iterator)>
<cfset ll.Dump()>

<p>As you can see, InsertAt() inserted before the last position, not after the
last position.  Use Add() if you want to add after the last position.</p>

Length: <cfoutput>#ll.Length()#</cfoutput>
