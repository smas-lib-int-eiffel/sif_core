note
	description: "[
					Abstract notion of an element with which an interactor can interact with it’s environment 
					through the system interface. Interaction elements are to be derived for each type. 
					Examples of interaction elements are elements for text, boolean values, lists etc. 
					
					Interaction is based on an event driven design. Each interaction element has the following basic events:
						- event_disable, to disable the interaction element
						- event_enable, to enable the interaction element
						- event_visible, to make the interaction element visiable if possible
						- event_unvisible, to make the interaction element unvisible if possible
					
					An interaction element is derived from COMPARABLE so it can be used to perform comparison 
					between interaction elements based on features sorting_number and interaction_element_identifier.
					
					An interaction element is derived from SHARED_SIF_PERMISSION_MANAGER making it part 
					of the security system. With this each interaction element can have a permission type 
					which is checked against being granted by the permission manager based on the current permission scheme.

	]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=interaction event driven"
	legal: "See notice at end of class."

deferred class
	SIF_INTERACTION_ELEMENT

inherit
	COMPARABLE
		undefine
			is_equal
		end

	SHARED_SIF_PERMISSIONS_MANAGER
		undefine
			is_equal
		end

	SIF_ENUM_INTERACTION_ELEMENT_TYPE
		undefine
			is_equal
		end

feature -- Creation

	make (a_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
			-- Be sure when an interaction element is initiated, the interaction element identifier is set
		require
			interaction_element_identifier_0: a_interaction_element_identifier /= 0
			sorted_set_of_elements_not_void: a_sorted_set_of_interaction_elements /= void
		do
			interaction_element_identifier := a_interaction_element_identifier
			type := a_type
			descriptor := a_descriptor

			create permission_type.make
			create events.make

			create event_disable
			create event_enable
			create event_visible
			create event_unvisible

			events.extend (event_disable)
			events.extend (event_enable)
			events.extend (event_visible)
			events.extend (event_unvisible)

			-- Interaction elements are default enabled
			-- Remark: To disable an interaction element a feature call to disable must be used.
			create enabled
			enabled := true

			a_sorted_set_of_interaction_elements.extend (Current)
		ensure
			interaction_element_identifier_initialized: interaction_element_identifier /= 0
		end

feature -- Initialization

	reset_events
		do
			events.do_all (agent reset_event)
		end

	reset_event(an_event: EVENT_TYPE[TUPLE])
		do
			an_event.dispose
		end

feature -- Functionality

	restore_subscriptions
		-- Restore all subscription from events
		require
			--has_system_interface: has_system_interface
		do
			across events as l_events loop l_events.item.restore_subscriptions end
			do_restore_subscriptions
		end

	do_restore_subscriptions
		do
			-- Intended to be emtpy.
			-- Override for interaction element which contain interaction elements, so they their subscriptions can also be restored
		end

	suspend_subscriptions
		-- Suspend all subscriptions from events
		do
			across events as l_events loop l_events.item.suspend_subscriptions end
			do_suspend_subscriptions
		end

	do_suspend_subscriptions
		do
			-- Intended to be emtpy.
			-- Override for interaction element which contain interaction elements, so their subscriptions can also be suspended
		end

	enable
		-- Enable the interaction element functionality
		do
			enabled := true
			event_enable.publish ()
		end

	disable
		-- Disable the interaction element functionality
		do
			enabled := false
			event_disable.publish ()
		end

feature -- Element change

	put_system_interface(a_system_interface: SIF_SYSTEM_INTERFACE)
		-- Let the interaction element know on which system interface it has interaction
		require
			a_system_interface_not_void: a_system_interface /= void
		do
			system_interface := a_system_interface
		end

	put_identifier( a_identifier: like interaction_element_identifier)
		do
			interaction_element_identifier := a_identifier
		end

	put_type( a_type: like type)
		do
			type := a_type
		end

	put_descriptor( a_descriptor: like descriptor)
		do
			descriptor := a_descriptor
		end

	remove_system_interface
		require
			system_interface_present: has_system_interface
		do
			system_interface := void
		end

	put_input( an_input_string: STRING )
			-- True, when an_input_string is convertable to the type of the interaction element
		require
			input_is_valid: is_valid_input( an_input_string )
		do

		end

	duplicate( other: SIF_INTERACTION_ELEMENT )
			-- Duplicate the content of other to Current content
		do

		end

feature -- Access

	identifier: like interaction_element_identifier
		do
			Result := interaction_element_identifier
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if Current.sorting_number < other.sorting_number then
				Result := true
			else
				Result := false
			end
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := other.interaction_element_identifier = interaction_element_identifier
		end

feature -- Security

	put_permission( a_permission_type: INTEGER )
		do
			permission_type.put_type (a_permission_type)
		end

	permission_type: SIF_PERMISSION_TYPE

	is_granted: BOOLEAN
		do
			Result := permissions_manager.has_interaction_element_permission (Current)
		end

feature {SIF_INTERACTION_ELEMENT_SORTED_SET} -- Comparison handling

	set_sorting_number ( a_sorting_number: INTEGER )
			-- Set the sorting number of the interaction element
			do
				sorting_number := a_sorting_number
			end

feature {SIF_INTERACTION_ELEMENT, SIF_INTERACTION_ELEMENT_SORTED_SET} -- Implementation

	sorting_number: INTEGER
			-- Used for sorting interaction elements

	events: LINKED_LIST[EVENT_TYPE[TUPLE[]]]
			-- Storage for all events of the interaction element

	system_interface: detachable SIF_SYSTEM_INTERFACE

feature -- Status report

	enabled: BOOLEAN

	has_system_interface: BOOLEAN
		do
			Result := system_interface /= void
		end

	is_mandatory: BOOLEAN
			-- Is the content delivery of this interaction element mandatory?
		do
			Result := type = enum_mandatory
		end

	is_optional: BOOLEAN
			-- Is the content delivery of this interaction element optional?
		do
			Result := type = enum_optional
		end

	is_result: BOOLEAN
			-- Is the content delivery of this interaction element a result type?
		do
			Result := type = enum_result
		end

	is_valid_input( an_input_string: STRING ): BOOLEAN
			-- True, when an_input_string is convertable to the type of the interaction element
		do
		end

feature -- Conversion

	to_string: STRING
			-- Convert the contents of Current to a string representation
		do
			create Result.make_empty
			do_to_string( Result )
		end

feature {SIF_INTERACTION_ELEMENT} -- Conversion

	do_to_string( a_result: like to_string)
		-- Convert the contents of Current to a string representation
		require
			empty_result: a_result.is_empty
		do
			-- This should become deferred in the end...
			a_result.append ("Please implement this feature for : " + Current.generator)
		end

feature	-- Implementation public

	event_disable: EVENT_TYPE [TUPLE[]]

	event_enable: EVENT_TYPE [TUPLE[]]

	event_visible: EVENT_TYPE [TUPLE[]]

	event_unvisible: EVENT_TYPE [TUPLE[]]

feature -- Descriptor

	descriptor: STRING
			-- Descriptor, for different uses e.g. key, tag in communication requests e.g json in http body.

	interaction_element_identifier: INTEGER_64
			-- this identifier is a unique identifier to be able to identify each possible specific interaction
			-- it can also be used for sorting purposes

invariant
	interaction_element_identifier_is_not_0: interaction_element_identifier /= 0

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
