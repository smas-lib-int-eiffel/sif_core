note
	description: "Summary description for {SIF_IE_NUMERIC}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_IE_NUMERIC

inherit

	SIF_INTERACTION_ELEMENT
		rename
			make as sif_interaction_element_make
		redefine
			is_valid_input,		-- To be removed when feature gets deferred
			put_input,			-- To be removed when feature gets deferred
			duplicate,			-- To be removed when feature gets deferred
			do_to_string		-- To be removed when feature gets deferred
		end

create
	make, make_with_type

feature -- Creation

	make_with_type(an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor; a_numeric_type: like {SIF_ENUM_IE_NUMERIC}.type )
		local
			l_ie_numeric_type: SIF_ENUM_IE_NUMERIC
		do
			create l_ie_numeric_type.make (a_numeric_type)
			make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor, l_ie_numeric_type)
		end

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor; a_numeric_type: SIF_ENUM_IE_NUMERIC )
		do
			create event_input
			create event_output
			create event_input_valid
			create event_focus

			create text.make_empty
			numeric_type := a_numeric_type

			sif_interaction_element_make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event_input)
			events.extend (event_output)
			events.extend (event_input_valid)
			events.extend (event_focus)

			event_input.subscribe (agent handle_text_input)
			event_output.subscribe (agent handle_text_output)
		end

feature -- Status

	is_valid: BOOLEAN
			-- True, when input is valid
		do
			if numeric_type = {SIF_ENUM_IE_NUMERIC}.enum_natural then
				Result := text.is_natural
			end
		end

	is_valid_input( an_input_string: STRING ): BOOLEAN
			-- True, when an_input_string is convertable to the type of the interaction element
		do
			if numeric_type.type = {SIF_ENUM_IE_NUMERIC}.enum_natural then
				Result := an_input_string.is_natural
			end
		end

feature -- Element change

	put_input( an_input_string: STRING )
			-- True, when an_input_string is convertable to the type of the interaction element
		do
			text := an_input_string
		end

	duplicate( other: SIF_INTERACTION_ELEMENT )
			-- Duplicate the content of other to Current content
		require else
			correct_other: attached {SIF_IE_NUMERIC}other
		do
			if attached {SIF_IE_NUMERIC}other as l_other then
				text := l_other.text
				numeric_type := l_other.numeric_type
			end
		end

feature {SIF_INTERACTION_ELEMENT} -- Conversion

	do_to_string( a_result: like to_string)
		-- Convert the contents of Current to a string representation
		do
			a_result.append (text)
		end

feature -- Implementation

	numeric_type: SIF_ENUM_IE_NUMERIC
		-- The numeric type

	text: STRING_32
		-- Textual numeric representation of the numeric value

feature -- Event types

	event_output: SIF_EVENT_TYPE [TUPLE [STRING_32]]
			-- event to be used to publish changes to the text presented by the system interface

	event_input: SIF_EVENT_TYPE [TUPLE [STRING_32]]
			-- event to be used to publish changes to the text used by the problem domain

	event_input_valid: SIF_EVENT_TYPE [TUPLE [BOOLEAN]]
			-- event to be used to publish if state of the input is valid, according to the applied input validator

	event_focus: SIF_EVENT_TYPE [TUPLE[]]
			-- event to used to force the input focus


feature {SIF_INTERACTION_ELEMENT} -- Interaction

	handle_text_input(a_text: STRING_32)
		-- Set the input text for later retrieval
		do
			text := a_text
			event_input_valid.publish (is_valid)
		end

	handle_text_output(a_text: STRING_32)
		-- Set the output text for later retrieval and proper synchronization
		do
			text := a_text
			event_input_valid.publish (is_valid)
		end

invariant

	correct_natural: numeric_type = {SIF_ENUM_IE_NUMERIC}.enum_natural implies text.is_natural

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
