note
	description: "[
				This concept is to be used for each feature (functionality) of the software system. 
				It's main purpose is that it can be executed. During execution it enforces some 
				necessary dynamic actions. The most important is that it constructs the necessary 
				interaction elements used to interact with the outside world through the system interface. 
				Each feature (system functionality) of the software system needs to be derived from this class in order to be able to 
				interact with the outside world through the system interface. This is done by 
				implementing feature do_execute. When this feature is called all interaction 
				elements are created and coupled with the executing system interface, so it is 
				able to interact by publishing information to the enviroment through the avaliable 
				interaction elements. While feature execute has an argument of type SIF_SYSTEM_INTERFACE 
				it means that the interactor through, run time dynamic binding, iteracts on an outside environment 
				which is unknown to the interactor. This relationship between SIF_SYSTEM_INTERFACE 
				and SIF_INTERACTOR is the core design of the SIF core framework. The interactor is the owner of the 
				created interaction elements stored in a sorted set through the relationship called interaction_elements.
	]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=interactor system functionality"
	legal: "See notice at end of class."

deferred class
	SIF_INTERACTOR
	inherit

		SIF_INTERACTION_ELEMENT_IDENTIFIERS

		DATE_TIME_TOOLS
			rename
				name as date_time_tools_name
			undefine
				default_create
			end

		SIF_PERMISSION_TYPE
			rename
				make as sif_permission_type_make,
				type as sif_permission_type
			undefine
				default_create
			end

		SHARED_LOG_FACILITY
			undefine
				default_create
			end

feature {NONE} -- Initialization

	make(an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
		do
			create execution_result
			create event_ended
			interaction_elements := an_interaction_elements_set
			prepare_interaction_elements
		end

feature -- Initialization run time creation

	create_new_context: SIF_INTERACTOR
			-- Create a new context, meaning create a new instance of Current and a new set of references for a new context
		do
			Result := Current.deep_twin
			Result.cleanup
		end

feature {NONE} -- Initialization basic interaction elements

	create_basic_interaction_elements
			-- Create the basic interaction elements
		do
			create ie_caption.make (caption_identifier, interaction_elements,{SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "caption" )
		end

feature frozen -- Execution

	execute( si : SIF_SYSTEM_INTERFACE )
			-- Guarded execution of an interactor.
			-- While execution behaviour can be of any kind, but also with outside environments,
			-- the execute feature has a rescue and retry mechanism to handle possible exception cases in a common sense.
		local
			l_retry_count: INTEGER
		do
			if l_retry_count < 2 then
				-- Commands are reused, so the former execution should have been properly cleaned up...
				if l_retry_count = 0 then
					check system_interface = void end
				end

				execution_result.reset

				interaction_elements.wipe_out
				prepare_interaction_elements

				interaction_elements.put_system_interface(si)
				system_interface := si

				si.interact (interaction_elements)

				pre_execute( si )

				write_debug ("%T[Interactor]: " + Current.generator + " is being executed.")
				do_execute( si )
				write_debug ("%T[Interactor]: " + Current.generator + " is ended.")

				-- Now presentation is possible, so publish the caption of this interactor.
				publish_caption

				handle_input
			else
				execution_result.put_exception
			end
		rescue
			if
				attached (create {EXCEPTION_MANAGER}).last_exception as la_exception and then
				attached la_exception.trace as la_trace then
					write_error (la_trace)
			end
			l_retry_count := l_retry_count + 1
			retry
		end

feature -- Execution

	pre_execute( si : SIF_SYSTEM_INTERFACE )
			-- Perform pre-execution of the current interactor
		do
			-- Intended to do nothing			
		end

	do_execute( si : SIF_SYSTEM_INTERFACE )
			-- Perform execution of the current interactor
		deferred
		end

	is_executing: BOOLEAN
			-- Is the current interactor busy interacting, is execute called and not ended?
		do
			Result := system_interface /= void and not interaction_elements.is_empty and ie_caption /= void
		end

	is_ended: BOOLEAN
			-- True, when the command has ended
		do
			Result := system_interface = void
		end

	event_ended: EVENT_TYPE[ TUPLE[SIF_INTERACTOR]]
			-- The event to publish to indicate that the interactor has ended interaction

	end_execution
			-- End the current execution
		require
			executing: is_executing
		do
			ended
		end

feature -- Access

	has_ie_caption: BOOLEAN
			-- Has an ie_caption been instantiated or not?
			do
				Result := ie_caption /= void
			end

	has_interaction_element(an_identifier: INTEGER_64) : BOOLEAN
		do
			Result := interaction_elements.has_interaction_element (an_identifier)
		end

	interaction_element(an_identifier: INTEGER_64): detachable SIF_INTERACTION_ELEMENT
		require
			element_exists: has_interaction_element(an_identifier)
		do
			Result := interaction_elements.interaction_element (an_identifier)
		end

	interaction_elements: SIF_INTERACTION_ELEMENT_SORTED_SET
			-- The sorted interaction elements of the interactor
			-- The set is sorted to make it possible to handle interactions in a predefined order.
			-- A predefined order is for example useful in textual user system interfaces to request
			-- information one line after another.

	descriptors: HASH_TABLE [STRING, INTEGER_64]
			-- Table associating identifiers with descriptors
		once
			create Result.make (100)

			Result.put ("log_priority", Iei_generic_log_facility_priority)
		end

feature {NONE} -- Interaction

	publish_caption
		do
			if attached ie_caption as l_ie_caption then
				do_publish_caption(l_ie_caption)
			end
		end

	do_publish_caption( an_ie_caption: SIF_IE_EVENT)
		-- Identify this interactor by publishing a caption, which can be used for presentation by the system interface
		deferred
		end

	caption_identifier: INTEGER_64
		-- Return the caption identifier for the caption interaction element, each interactor needs a unique caption identifier.
		deferred
		end

feature -- Control flow

	execution_result : SIF_INTERACTOR_RESULT

feature {NONE} -- Validation

	mandatory_input_ok: BOOLEAN
		-- True, if all mandatory input fields of type text are valid.
		do
			Result := true
			from
				interaction_elements.start
			until
				interaction_elements.after --and Result
			loop
				if interaction_elements.item.is_mandatory then
					if attached {SIF_IE_TEXT}interaction_elements.item as l_ie_text_item then
						if not l_ie_text_item.is_valid then
							Result := false
						end
					end
					if attached {SIF_IE_LIST_SINGLE_SELECT}interaction_elements.item as l_ie_list_single_select_item then
						if not l_ie_list_single_select_item.is_valid then
							Result := false
						end
					end
				end
				interaction_elements.forth
			end
		end

	all_input_valid: BOOLEAN
		-- True, if all input fields of type text are valid.
		do
			Result := true
			from
				interaction_elements.start
			until
				interaction_elements.after --and Result
			loop
				if attached {SIF_IE_TEXT}interaction_elements.item as l_ie_text_item then
					if not l_ie_text_item.is_valid then
						Result := false
					end
				end
				if attached {SIF_IE_LIST_SINGLE_SELECT}interaction_elements.item as l_ie_list_single_select_item then
					if not l_ie_list_single_select_item.is_valid then
						Result := false
					end
				end
				interaction_elements.forth
			end
		end

	handle_text_input( an_input_text: STRING_32 )
		do
			handle_input
		end

	handle_selection_input( an_input_selection: INTEGER )
		do
			handle_input
		end

	handle_input
		do
			if mandatory_input_ok and all_input_valid then
				handle_all_input_valid(true)
			else
				handle_all_input_valid(false)
			end
		end

	handle_all_input_valid( input_is_valid: BOOLEAN)
		do
			-- Intended to be empty.
			-- Always usefull for commands without input to be validated.
		end

	force_input_validation
			-- When text fields which need input validation are filled from the model, it is
			-- needed to perform a forced check, if the information is valid.
		do
			-- First handle a dummy input, so the current command is able to perform the proper actions in feature
			-- handle_all_input_valid. After that the input is forced to check if it's valid.
			handle_input
			from
				interaction_elements.start
			until
				interaction_elements.after
			loop
				if attached {SIF_IE_TEXT}interaction_elements.item as l_ie_text_item then
					l_ie_text_item.force_input_validation
				end
				interaction_elements.forth
			end
		end

feature {NONE} -- Basic Interaction elements

	prepare_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		do
			create_basic_interaction_elements
			do_prepare_interaction_elements
		end


feature {NONE} -- Interaction elements derived

	ie_caption: SIF_IE_EVENT
			-- Interacters must identify themselves through a caption, which makes it possible to
			-- make a presentation of the interaction on the system interface

	do_prepare_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		deferred
		end

feature {NONE} -- Implementation

	system_interface: detachable SIF_SYSTEM_INTERFACE
			-- The system interface where the controller is executed

	ended
			-- Publish that interactor has ended and do the proper clean ups so the next execute can be invoked.
		do
			event_ended.publish (Current)
			cleanup
		end

feature {NONE} -- Generic Dynamic Interaction elements

	create_general_dynamic_interaction_elements
			-- Create a set of generic interaction elements, for example for use with generic dialogs
			-- They need to be dynamically created each time they are used, that's why the feature
			--
		local
			l_ie: SIF_INTERACTION_ELEMENT
		do
			create dynamic_elements.make
			if attached dynamic_elements as l_dynamic_elements then
				l_ie := create {SIF_IE_TEXT}.make (Iei_generic_dynamic_caption, l_dynamic_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "generic_caption")
				l_ie := create {SIF_IE_TEXT}.make (Iei_generic_dynamic_text, l_dynamic_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "generic_text")
				l_ie := create {SIF_IE_EVENT}.make (Iei_generic_dynamic_ok, l_dynamic_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "generic_ok")
				l_ie := create {SIF_IE_EVENT}.make (Iei_generic_dynamic_cancel, l_dynamic_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "generic_cancel")
			end
		end

	dynamic_elements: detachable SIF_INTERACTION_ELEMENT_SORTED_SET

feature {SIF_INTERACTOR} -- Implementation

	cleanup
			-- Cleanup for proper next execution
		do
			system_interface := void
		end

feature -- Convenience

	set_result_date (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_date_time: DATE_TIME)
			-- Add a date result element with `an_id' to `a_parent' and fill it with `a_date_time'.
		local
			l_text: SIF_IE_TEXT_ISO_8601
		do
			check attached descriptors.item (an_id) as la_descriptor then
				create l_text.make_date_time (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, la_descriptor)
				l_text.put_input_date_time (a_date_time.out)
			end
		end

	set_text (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_text: STRING)
			-- Add an element with `an_id' and `a_type' to `a_parent' and fill it with `a_text'.
		local
			l_text: SIF_IE_TEXT
		do
			check attached descriptors.item (an_id) as la_descriptor then
				create l_text.make (an_id, a_parent, a_type, la_descriptor)
				l_text.put_input (a_text)
			end
		end

	set_number (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_number: NATURAL)
			-- Add an element with `an_id' and `a_type' to `a_parent' and fill it with `a_number'.
		local
			l_number: SIF_IE_NUMERIC
			l_numeric_natural: SIF_ENUM_IE_NUMERIC
		do
			check attached descriptors.item (an_id) as la_descriptor then
				create l_numeric_natural.make ({SIF_ENUM_IE_NUMERIC}.enum_natural)
				create l_number.make (an_id, a_parent, a_type, la_descriptor, l_numeric_natural)
				l_number.put_input (a_number.out)
			end
		end

	set_boolean (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_boolean: BOOLEAN)
			-- Add an element with `an_id' and `a_type' to `a_parent' and fill it with `a_boolean'.
		local
			l_boolean: SIF_IE_BOOLEAN
		do
			check attached descriptors.item (an_id) as la_descriptor then
				create l_boolean.make (an_id, a_parent, a_type, la_descriptor)
				l_boolean.put_input (a_boolean.out.as_lower)
			end
		end

	set_result_text (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_text: STRING)
			-- Add a result element with `an_id' to `a_parent' and fill it with `a_text'.
		do
			set_text (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, a_text)
		end

	set_result_number (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_number: NATURAL)
			-- Add a result element with `an_id' to `a_parent' and fill it with `a_number'.
		do
			set_number (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, a_number)
		end

	set_result_boolean (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_boolean: BOOLEAN)
			-- Add a result element with `an_id' to `a_parent' and fill it with `a_boolean'.
		do
			set_boolean (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, a_boolean)
		end

	set_descriptive_text (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_text: STRING)
			-- Add a descriptive element with `an_id' to `a_parent' and fill it with `a_text'.
		do
			set_text (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, a_text)
		end

	new_result_list (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET): SIF_IE_LIST
			-- New result list with `an_id', added to `a_parent'
		do
			check attached Descriptors.item (an_id) as la_descriptor then
				create Result.make (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, la_descriptor)
			end
		end

	new_ie_event (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type): SIF_IE_EVENT
			-- New text element with `an_id' and `a_type', added to `a_parent'
		do
			check attached Descriptors.item (an_id) as la_descriptor then
				create Result.make (an_id, a_parent, a_type, la_descriptor)
			end
		end

	new_ie_text (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type): SIF_IE_TEXT
			-- New text element with `an_id' and `a_type', added to `a_parent'
		do
			check attached Descriptors.item (an_id) as la_descriptor then
				create Result.make (an_id, a_parent, a_type, la_descriptor)
			end
		end

	new_ie_number (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type): SIF_IE_NUMERIC
			-- New number element with `an_id' and `a_type', added to `a_parent'
		local
			l_numeric_natural: SIF_ENUM_IE_NUMERIC
		do
			check attached Descriptors.item (an_id) as la_descriptor then
				create l_numeric_natural.make ({SIF_ENUM_IE_NUMERIC}.enum_natural)
				create Result.make (an_id, a_parent, a_type, la_descriptor, l_numeric_natural)
			end
		end

	new_mandatory_text (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET): SIF_IE_TEXT
			-- New mandatory text element with `an_id', added to `a_parent'
		do
			Result := new_ie_text (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_mandatory)
		end

	new_mandatory_number (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET): SIF_IE_NUMERIC
			-- New mandatory number element with `an_id', added to `a_parent'
		do
			Result := new_ie_number (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_mandatory)
		end

	new_optional_text (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET): SIF_IE_TEXT
			-- New optional text element with `an_id', added to `a_parent'
		do
			Result := new_ie_text (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_optional)
		end

	new_control_event (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET): SIF_IE_EVENT
			-- New optional text element with `an_id', added to `a_parent'
		do
			Result := new_ie_event (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control)
		end

	new_object (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type;): SIF_IE_OBJECT
			-- New object with `an_id', added to `a_parent'
		do
			check attached Descriptors.item (an_id) as la_descriptor then
				create Result.make (an_id, a_parent, a_type, la_descriptor)
			end
		end

	new_result_object (an_id: INTEGER_64; a_parent: SIF_INTERACTION_ELEMENT_SORTED_SET): SIF_IE_OBJECT
			-- New result object with `an_id', added to `a_parent'
		do
			Result := new_object (an_id, a_parent, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result)
		end

note
	copyright: "Copyright (c) 2014-2018, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
