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
	    have to be used which can carry out the specific request. Environmental requests can
	    be organized into inheritance taxonomies.

	    Besides performing actions needed for environment requests, commands can be used
	    for logging, executing, undoing or testing.
	    
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
	    
	    Commands also have a descriptor, which has to be unique for all commands the command
	    manager is managing. The desciptor can therefore be used also to find a command
	    in cases where an environment wants to reference a command through a readable identification.

	    Commands are inherited from SIF_INTERACTOR and therefor need to
	    interact with the system interface by using interaction elements.

	    Commands need to subscribe the specific business model agents to the interaction
	    elements to react and interchange information in a platform and system interface
	    independent way.
	    
	    Commands store and access data using Data Access Objects. A command can have, zero,
	    one or more of these DAO's. They can be created statically or dynamically.
	    The DAO makes commands agnostic for the way data is stored, making them completely
	    reusable to be able to be executed on any environment without changing the implementation,
	    which is one of the key factors of the System Interface Framework.
	    
	    Commands follow the following dynamic flow:
	    			-- 1st stage:   pre execution for doing special initialization prior to execution where it
	    			                is not possible to publish events.
	    			-- 2nd stage:	do_execute starts the execution, interaction is possible to publish events,
	    			                which will be needed to supply information to views in case of system
	    			                interfaces, which are intended for human interaction
	    			-- 3hrd stage:  post execution results should be available, human interaction in normal flow
	    							should be ready and controlled. 
	    							   -> publish the command results using sorted interaction elements for the
	    							      result in the system interface.
	    							when results are to be stored, use the data access objects to do so.
	    							post execution is executed automatically for commands executing with attached
	    							system interface which is not used for human interaction. In those systems
	    							controllers should control the post execution. 
	    							This way commands can automatically execute in web API's environments and
	    							controlled by human actions in human/user based system interface environments.
		 	]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=command system functionality"
	legal: "See notice at end of class."

deferred class
	SIF_COMMAND[G -> SIF_DAO[ANY] create make end]

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
			-- Data Access
			create data_access_object.make
			create data_operation_enumeration
			create data_access_object_for_references.make (0)
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
			-- Data Access
			create data_access_object.make
			create data_access_object_for_references.make (0)
			create data_operation_enumeration
			check attached command_descriptors.item (a_command_identifier) as la_descriptor then
				make_with_identifier_and_ie_set (a_command_identifier, la_descriptor, interaction_elements)
			end
			if attached result_interaction_elements as la_result_interaction_elements then
				create the_results.make(Ie_results_resources, la_result_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, "Results resources")
			end
		end

feature -- Basic Interaction elements

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
		local
			l_page_number: STRING
			l_id: STRING
			l_count_total: INTEGER
		do
			check data_operation_enumeration.data_operation /= {SIF_ENUMERATION_DATA_OPERATION}.undefined end

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

			if data_operation_enumeration.data_operation = {SIF_ENUMERATION_DATA_OPERATION}.read then
				l_page_number := interaction_element_string_value (Iei_page_number)
				if filter and then l_page_number.is_empty then
					l_id := interaction_element_string_value (Iei_resource_identification)
					data_access_object.load_by_identification (l_id)
					if not attached data_access_object.last_item then
						--(create {SHOP_LOG_FACILITY}).log_item_not_found (resource_name, l_id)
						execution_result.put_failed
					end
				elseif
					--attached {SIF_SYSTEM_INTERFACE_WEB_EWF} si as la_si and then
					--attached {STRING_TABLE [WSF_VALUE]} la_si.request.query_parameters as la_paras and then
					--attached query_interaction_elements as la_query_interaction_elements
					filter
				then
					--data_access_object.load_by_criteria (to_criteria (la_paras))
				else
					if pagination_capable then
						data_access_object.load_item_count
						if l_page_number.is_empty then
							l_page_number := "1"
						end
						set_pagination (l_page_number.to_natural, data_access_object.last_count.to_natural_32)
						data_access_object.load_page ((l_page_number.to_natural - 1) * command_manager.count_per_page + 1, command_manager.count_per_page)
					else
						data_access_object.load_all
					end
				end
			end
		end


	post_execute( si : SIF_SYSTEM_INTERFACE )
			-- Perform post-execution of the current interactor
		do
			if not si.human then
				if data_operation_enumeration.data_operation = {SIF_ENUMERATION_DATA_OPERATION}.create_ then
					-- Map interaction elements to an item, so it is able to be stored by the data access object
					store_item
				end

				if data_operation_enumeration.data_operation = {SIF_ENUMERATION_DATA_OPERATION}.update then
					-- Map interaction elements to an item, so it is able to be stored by the data access object
					update_item
				end

				if data_operation_enumeration.data_operation = {SIF_ENUMERATION_DATA_OPERATION}.delete then
					-- Map interaction elements to an item, so it is able to be stored by the data access object
					delete_item
				end

				if execution_result.passed and data_access_object.is_ok then
					update_result (data_access_object.last_list, filter)
				end
			end
		end

feature -- Data Access Object - DAO

	data_access_object: G
		-- The data access object for the command.

	data_access_object_for_references: HASH_TABLE[SIF_DAO[ANY], like {SIF_INTERACTION_ELEMENT_IDENTIFIERS}.Iei_lowest]

	data_operation_enumeration: SIF_ENUMERATION_DATA_OPERATION
		-- Default undefined and will be checked during command execution.
		-- Make it read if data should be loaded through DAO when command is executed.
		-- Most commands behave in a way data retrieval is their primary goal.
		-- In a CRUD sense this is the R (Read) element. The experience is that this
		-- is the most used kind of command, the command to read a certain amount of data and
		-- transform/map that data to an object of a Model class and also in the case of
		-- the System Interface Framework to a description in interaction elements so
		-- the SIF based software system is able to interact with the outside world.
		-- The SIF framework forces the caller of a command to set the data operation mode
		-- of the command. So initially the data operation is undefined, making it impossible
		-- to execute the command which is checked in the pre execution phase.

	Iei_resource_identification: INTEGER_64
			--  Identifier for the 'identification' interaction element of this resource
		deferred
		end

	Iei_resource_list: INTEGER_64
			--  Identifier for the 'list' interaction element of this resource
		deferred
		end

	store_item
			-- Map interaction elements into an instance of an object which can be stored by the data access object as an item
		do
			-- Intended to be empty, please redefine when command needs to be able to store new items
		end

	update_item
			-- Map interaction elements into an instance of an object which can be updated by the data access object from an existing item
		do
			-- Intended to be empty, please redefine when command needs to be able to update an existing item
		end

	delete_item
			-- Map interaction elements into an instance of an object which can be deleted by the data access object
		do
			-- Intended to be empty, please redefine when command needs to be able to delete an existing item
		end

feature -- Output

	update_result (some_items: LIST [ANY]; is_filtered: BOOLEAN)
			-- Update result set with data from `some_items', depending on whether it `is_filtered' or not.
		do
			if attached result_list (Iei_resource_list) as l_ie_list_items then
				across
					some_items as items
				loop
					if attached {like {G}.last_item} items.item as la_item then
						l_ie_list_items.elements.extend (item_ies (la_item, is_filtered))
					end
				end
				update_counts (data_access_object.last_count, some_items.count)
			end
		end

	item_ies (an_item: like data_access_object.last_item; is_filtered: BOOLEAN): SIF_INTERACTION_ELEMENT_SORTED_SET
			-- Result set for `an_item' depending on whether it `is_filtered' or not
		deferred
		end

feature {NONE} -- Normal interaction

	create_mandatory_text_element( a_ie_identifier: like {SIF_INTERACTION_ELEMENT}.identifier)
		local
			l_text: SIF_IE_TEXT
		do
			check attached descriptors.item (a_ie_identifier) as la_descriptor then
				create l_text.make(a_ie_identifier, interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_mandatory, la_descriptor)
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
			l_text: SIF_IE_TEXT
		do
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
			-- True when the command is pagination capable, normally usefull when the command can
			-- have a large list of results, which can take a long time to process in certain
			-- environments.
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
			event_ended.dispose
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
