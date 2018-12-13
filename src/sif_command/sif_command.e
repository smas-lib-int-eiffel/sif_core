note
	description: "[
		Class SIF_COMMAND encapsulates requests into objects. When an external actor
		(e.g.
			- an interaction element, like IE_EVENT which is attached to a button
			  control in an viewable system interface
			- a web request through a web best api like REST by using the Eiffel
			  Web Framework ;-) in a web system interface
			  )
	    or object (e.g. a controller object) makes a request, a command object will
	    have to be used which can carry out the specific request. Environment requests can
	    be organized into inheritance taxonomies.

	    Besides performing actions needed for environment requests, commands can be used
	    for logging, executing or undoing.
	    
	    With commands software systems will get flexible and extendable system interfaces
	    and requests.

		Commands register themselves at the shared command manager. The shared command
		manager is a singleton which can be used througout the software system to have
		a single point of reference for command handling. 
		
		In multi processor environments,
		the commands from the command manager should be duplicated to avoid concurrency
		problems, so they get there own run-time context.

	    Commands will be uniquely indentifiable. This makes it possible to automate
	    external systems to execute commands automatically or to implement a generic way
	    to execute an identified command.
	    
	    Commands also have a descriptor, which has to be unique for ll commands the command
	    manager is managing. The desciptor can therefore be used also to find a command
	    in cases where an environment wants to reference a command through a readable identification.

	    Commands are inherited from SIF_INTERACTOR and therefor need to
	    interact with the system interface by using interaction elements.

	    Commands need to subscribe the specific business model agents to the interaction
	    elements to react and interchange information in a platform and system interface
	    independent way.
	    
	    Commands follow the following dynamic flow:
	    			-- 1st stage:   do_execute starts the execution, interaction is possible to publish events
	    			-- 2nd stage:   confirm -> confirmation if needed to persist the executed functionality
	    						    cancel  -> cancellation if needed to cancel the executed functionality
	    			-- 3trd stage:  result  -> publish the command results using sorted interaction elements for the
	    									result in the system interface
	    	The separation of the first two stages is most important in system interfaces which are viewable.
	    	This is while the input of information in these kind of environments is done in two stages, first present
	    	the information in a interaction form and second a confirmation of cancellation of the information.
	    	In web based environments this separation is not immediately neccesary but can comply easily for a
	    	uniform command handling in both environments.
	    	The result stage is more related to web based environments where result information is put in responses
	    	to requests.
		 	]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=command system functionality"
	legal: "See notice at end of class."

deferred class
	SIF_COMMAND
	inherit
		SIF_INTERACTOR
			rename
				make as interactor_make
			redefine
				prepare_interaction_elements,
				pre_execute,
				cleanup
			end

		SIF_SHARED_COMMAND_MANAGER
			undefine
				default_create
			end

feature {NONE} -- Initialization

	make_with_identifier_and_ie_set (a_command_identifier : INTEGER_64; a_descriptor: like descriptor; an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
		require
			command_identifier_is_not_0: a_command_identifier /= 0
		do
			create internal_elements.make(0)
			interactor_make(an_interaction_elements_set)
			identifier := a_command_identifier
			descriptor := a_descriptor
			command_manager.extend (Current)
		end

	make_command (a_command_identifier: INTEGER_64)
			-- Create a new command with `a_command_identifier'.
		do
			default_create
			create interaction_elements.make
			create query_interaction_elements.make
			create result_interaction_elements.make
			create internal_elements.make(0)
			check attached command_descriptors.item (a_command_identifier) as la_descriptor then
				make_with_identifier_and_ie_set (a_command_identifier, la_descriptor, interaction_elements)
			end
			if attached result_interaction_elements as la_result_interaction_elements then
				create the_results.make(Ie_results_resources, la_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, "Results resources")
			end
		end

feature {NONE} -- Basic Interaction elements

	prepare_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		local
			l_text: SIF_IE_TEXT
			l_ie_numeric: SIF_IE_NUMERIC
		do
			if attached query_interaction_elements as l_query_interaction_elements then
				l_query_interaction_elements.wipe_out
				-- Create a basic page number optional query element
				create l_text.make(Iei_page_number, l_query_interaction_elements, {SIF_INTERACTION_ELEMENT}.enum_optional, "page")
			end
			if attached result_interaction_elements as l_result_interaction_elements then
				l_result_interaction_elements.wipe_out
				-- Create some basic result interaction elements
				create l_ie_numeric.make(Iei_count_total, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, "total", create {SIF_ENUM_IE_NUMERIC}.make ({SIF_ENUM_IE_NUMERIC}.enum_natural))
				create l_ie_numeric.make(Iei_count_current, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, "total_current", create {SIF_ENUM_IE_NUMERIC}.make ({SIF_ENUM_IE_NUMERIC}.enum_natural))

				-- Create descriptive result interaction elements for pagination use when dealing with large collections
				create l_text.make(Iei_previous, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "previous")
				create l_text.make(Iei_next, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "next")
				create l_text.make(Iei_first, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "first")
				create l_text.make(Iei_last, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "last")
				create l_text.make(Iei_self_identifier, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "self_identifier")
			end

			Precursor
		end

feature -- Execution

	pre_execute( si : SIF_SYSTEM_INTERFACE )
			-- Perform pre-execution of the current interactor
		do
			filter := false
			if attached query_interaction_elements as l_query_iess then
				across l_query_iess as l_ie loop
					if attached {SIF_IE_TEXT}l_ie.item as l_ie_text then
						if not l_ie_text.to_string.is_empty then
							filter := true
						end
					end
				end
			end
		end

feature {NONE} -- Query interaction

	create_optional_query_element(a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier)
		require
			query_interaction_elements_created: attached query_interaction_elements
		local
			l_text: SIF_IE_TEXT
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				if attached query_interaction_elements as l_query_interaction_elements then
					create l_text.make(a_ie_identifier, l_query_interaction_elements, {SIF_INTERACTION_ELEMENT}.enum_optional, la_descriptor)
				end
			end
		end

	create_mandatory_query_element(a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier)
		require
			query_interaction_elements_created: attached query_interaction_elements
		local
			l_text: SIF_IE_TEXT
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				if attached query_interaction_elements as l_query_interaction_elements then
					create l_text.make(a_ie_identifier, l_query_interaction_elements, {SIF_INTERACTION_ELEMENT}.enum_mandatory, la_descriptor)
				end
			end
		end

feature {SIF_INTERACTOR} -- Result interaction

	results: LIST[SIF_INTERACTION_ELEMENT_SORTED_SET]
			-- Results, only valid when execution result is passed.
		require
			correct_result: execution_result.passed
		do
			Result := internal_elements
			if attached the_results as la_the_results then
				Result := la_the_results.elements
			end
		end

	create_list_result_element(a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier)
		require
			result_interaction_elements_created: attached result_interaction_elements
		local
			l_list: SIF_IE_LIST
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				if attached result_interaction_elements as l_result_interaction_elements then
					create l_list.make(a_ie_identifier, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, la_descriptor)
				end
			end
		end

	create_text_result_element_descriptive( a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier)
		require
			result_interaction_elements_created: attached result_interaction_elements
		local
			l_text: SIF_IE_TEXT
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				if attached result_interaction_elements as l_result_interaction_elements then
					create l_text.make(a_ie_identifier, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, la_descriptor)
				end
			end
		end

	create_text_result_element( a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier)
		require
			result_interaction_elements_created: attached result_interaction_elements
		local
			l_text: SIF_IE_TEXT
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				if attached result_interaction_elements as l_result_interaction_elements then
					create l_text.make(a_ie_identifier, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, la_descriptor)
				end
			end
		end

	create_numeric_result_element( a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier; a_numeric_type: SIF_ENUM_IE_NUMERIC)
		require
			result_interaction_elements_created: attached result_interaction_elements
		local
			l_ie_numeric: SIF_IE_NUMERIC
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				if attached result_interaction_elements as l_result_interaction_elements then
					create l_ie_numeric.make(a_ie_identifier, l_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, la_descriptor, a_numeric_type)
				end
			end
		end

feature -- Pagination

	set_pagination_capable(a_pagination_capable: like pagination_capable)
			-- Set pagination capableness of the command
		do
			pagination_capable := a_pagination_capable
		end

	set_pagination(a_current_page_number: NATURAL; a_count_items: NATURAL)
			-- Set the pagination correctly according to the current page number
			-- Page number can be '0', this is handled as if no page number has been chosen,
			-- but available information will be given.
		require
			command_is_pagination_capable: is_pagination_capable
		local
			l_page_number: NATURAL
			l_nr_of_pages: NATURAL
		do
			if attached result_interaction_elements as l_result_interaction_elements then
				l_nr_of_pages := a_count_items.quotient (command_manager.count_per_page).rounded.to_natural_32
				if l_nr_of_pages.product (command_manager.count_per_page) < a_count_items then
					l_nr_of_pages := l_nr_of_pages + 1
				end
				if attached l_result_interaction_elements.interaction_element (Iei_previous) as l_ie_previous then
					if a_current_page_number > 0 then
						l_page_number := a_current_page_number - 1
				   		l_ie_previous.put_input (l_page_number.out)
				   	else
				   		l_ie_previous.put_input ("0")
				   	end
				end
				if attached l_result_interaction_elements.interaction_element (Iei_next) as l_ie_next then
					if a_current_page_number >= l_nr_of_pages then
						l_ie_next.put_input ("0")
				   	else
				   		if a_current_page_number = 0 then
				   			if l_nr_of_pages > 1 then
				   				l_page_number := 2
				   			else
				   				l_page_number := 0
				   			end
				   		else
							l_page_number := a_current_page_number + 1
						end
				   		l_ie_next.put_input (l_page_number.out)
				   	end
				end
				if attached l_result_interaction_elements.interaction_element (Iei_first) as l_ie_first then
					if l_nr_of_pages > 0 then
				   		l_ie_first.put_input ("1")
				   	else
						l_ie_first.put_input ("0")
				   	end
				end
				if attached l_result_interaction_elements.interaction_element (Iei_last) as l_ie_last then
					if l_nr_of_pages > 0 then
				   		l_ie_last.put_input (l_nr_of_pages.out)
				   	else
						l_ie_last.put_input ("0")
				   	end
				end
			end
		end

feature -- Result interaction

	result_list (an_id: INTEGER_64): detachable SIF_IE_LIST
			-- List from `result_interaction_elements' associated with `an_id'
		do
			if attached result_interaction_elements as l_interaction_elements then
				if attached {SIF_IE_LIST} l_interaction_elements.interaction_element (an_id) as la_list then
					Result := la_list
				end
			end
		end

feature -- Output

	add_self (a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; an_id: STRING; is_filtered: BOOLEAN)
			-- Add an `Iei_self_identifier' element to `a_parent'.
			-- If `is_filtered' fill it with `an_id'.
		local
--			l_url: STRING
			l_text: SIF_IE_TEXT
--			l_descriptor: STRING
		do
			--l_descriptor := "The url to this resource"
			create l_text.make (Iei_self_identifier, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "self")
			l_text.put_input (an_id)
		end

feature -- Access

	command_descriptors: HASH_TABLE [STRING, INTEGER_64]
			-- Table associating identifiers with command descriptors
		once
			create Result.make (50)
		end

	query_interaction_elements: detachable SIF_INTERACTION_ELEMENT_SORTED_SET
			-- The sorted set of interaction elements to be used to interact the commands query possibilities
			-- to the environment before a command has been executed, these should be the same or a subset
			-- of the set of interaction elements. They determine the result set when collections are the
			-- result of a command, reflected in the result interaction elements.

	result_interaction_elements: detachable SIF_INTERACTION_ELEMENT_SORTED_SET
			-- The sorted set of interaction elements to be used to present a result to the environment after
			-- a command has been executed.

	interaction_element_string_value(a_ie_id: like {SIF_INTERACTION_ELEMENT}.identifier): STRING
			-- Result contains a string representation of an_interaction_element if found, else the result will be empty
		do
			create Result.make_empty
			if interaction_elements.has_interaction_element (a_ie_id) and then
			   attached interaction_elements.interaction_element (a_ie_id) as l_ie then
				Result := l_ie.to_string
			else
				if attached query_interaction_elements as l_query_interaction_elements and then
				   attached l_query_interaction_elements.interaction_element (a_ie_id) as l_ie_query then
					Result := l_ie_query.to_string
				else
					if attached result_interaction_elements as l_result_interaction_elements and then
					   attached l_result_interaction_elements.interaction_element (a_ie_id) as l_ie_result then
					   	Result := l_ie_result.to_string
					end
				end
			end
		end

	interaction_element_string_value_from_set(a_ie_id: like {SIF_INTERACTION_ELEMENT}.identifier; a_sorted_set: SIF_INTERACTION_ELEMENT_SORTED_SET): STRING
			-- Result contains a string representation of an_interaction_element if found, else the result will be empty
		do
			create Result.make_empty
			if a_sorted_set.has_interaction_element (a_ie_id) and then
			   attached a_sorted_set.interaction_element (a_ie_id) as l_ie then
				Result := l_ie.to_string
			end
		end

	is_pagination_capable: BOOLEAN
			-- True when the command is pagination capable
		do
			Result := pagination_capable
		end

feature -- Implementation

	identifier: INTEGER_64
			-- Unique command identifier which goes beyond system uniqueness
			-- Command identifiers are to be uniquely defined within a company while
			-- they can be used by external systems

	descriptor: STRING
			-- Unique commmand descriptor. Needs to be unique within a system, this is
			-- accomplished by using the command manager

feature {SIF_INTERACTOR} -- Implementation

	cleanup
			-- <PreCursor>
		do
			Precursor
			event_ended.wipe_out
			pagination_capable := false
		end

feature {NONE} -- Implementation

	filter: BOOLEAN
			-- True when at least one of the query interaction elements is not empty indicating a collection needs to be filtered

	pagination_capable: BOOLEAN
			-- True when command is pagination capable

	update_counts (count_total, count_current: INTEGER)
			-- Update the count elements (total and current) with `count_total' and `count_current'.
		do
			check attached result_interaction_elements as la_result_interaction_elements then
				if attached {SIF_IE_NUMERIC} la_result_interaction_elements.interaction_element (Iei_count_total) as l_ie_numeric_count then
					l_ie_numeric_count.text.make_from_string (count_total.out)
				end
				if attached {SIF_IE_NUMERIC} la_result_interaction_elements.interaction_element (Iei_count_current) as l_ie_numeric_count then
					l_ie_numeric_count.text.make_from_string (count_current.out)
				end
			end
		end

	disable_counts
			-- Update the count elements (total and current).
		do
			check attached result_interaction_elements as la_result_interaction_elements then
				if attached {SIF_IE_NUMERIC}la_result_interaction_elements.interaction_element( Iei_count_total ) as l_ie_numeric_count then
					l_ie_numeric_count.disable
				end
				if attached {SIF_IE_NUMERIC}la_result_interaction_elements.interaction_element( Iei_count_current ) as l_ie_numeric_count then
					l_ie_numeric_count.disable
				end
			end
		end

	the_results: detachable SIF_IE_LIST
			-- The resulting list of sets of interaction elements. All results of commands contain a list of 0, 1 or more results.
			-- Each resulting item in the array of the list contains a set of sorted interaction elements that describe the
			-- properties of the problem domain concept or resource in interaction elements.

	internal_elements: like {SIF_IE_LIST}.elements
			-- An internal placeholder for client convenience, while results are detachable

invariant

	identifier_not_0: identifier /= 0

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
