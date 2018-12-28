note
	description: "Summary description for {SIF_IE_BOOLEAN}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_BOOLEAN

inherit

	SIF_INTERACTION_ELEMENT
		redefine
			make,
			is_valid_input
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create event_input
			create event_output
			create causality_events.make

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event_input)
			events.extend (event_output)

			event_input.subscribe (agent handle_boolean_changed)
			event_output.subscribe (agent handle_boolean_changed)
		end

feature -- Access

	boolean: BOOLEAN

feature -- Element change

	put_causality_item( a_causality_item: SIF_INTERACTION_ELEMENT )
		do
			causality_events.put( a_causality_item )
		end

	is_valid_input( an_input_string: STRING ): BOOLEAN
			-- <Precursor>
		local
			l_string: STRING
		do
			l_string := an_input_string.twin
			l_string.to_lower
			Result := l_string.is_equal ("true") or else l_string.is_equal ("false")
		end

feature -- Event types

	event_input: EVENT_TYPE [TUPLE [BOOLEAN]]
			-- event to be used to publish an event from a system interface

	event_output: EVENT_TYPE [TUPLE [BOOLEAN]]
			-- event to be used to publish an event from the model

feature {NONE} -- Implementation

	handle_boolean_changed (a_new_boolean: BOOLEAN)
		do
			boolean := a_new_boolean
			if boolean then
				causality_events.enable_all
			else
				causality_events.disable_all
			end
		end

	causality_events: SIF_INTERACTION_ELEMENT_SORTED_SET

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
