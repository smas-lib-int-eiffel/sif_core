note
	description: "Summary description for {SIF_IE_TEXT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_TEXT

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

	SIF_SHARED_INPUT_VALIDATORS
		undefine
			default_create,
			is_equal
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create event_input
			create event_output
			create event_input_valid
			create event_focus

			create text.make_empty

			input_validator := input_validators.validator_always_ok

			sif_interaction_element_make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event_input)
			events.extend (event_output)
			events.extend (event_input_valid)
			events.extend (event_focus)

			event_input.subscribe (agent handle_text_input)
			event_output.subscribe (agent handle_text_output)
		end

feature -- Validations

	put_validation( a_validation: SIF_INPUT_VALIDATOR )
		do
			input_validator := a_validation
		end

	is_valid: BOOLEAN
		do
			if text.is_empty then
				if is_mandatory then
					Result := input_validator.validate (Current.text)
				else
					Result := true
				end
			else
				Result := input_validator.validate (Current.text)
			end
		end

	force_input_validation
		do
			event_input_valid.publish (is_valid)
		end

feature -- Status report

	is_valid_input( an_input_string: STRING ): BOOLEAN
			-- True, when an_input_string is convertable to the type of the interaction element
		do
			Result := input_validator.validate (an_input_string)
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
			correct_other: attached {SIF_IE_TEXT}other
		do
			if attached {SIF_IE_TEXT}other as l_other then
				text := l_other.text
			end
		end

feature {SIF_INTERACTION_ELEMENT} -- Conversion

	do_to_string( a_result: like to_string)
		-- Convert the contents of Current to a string representation
		do
			a_result.append (text)
		end

feature -- Implementation

	text: STRING_32

feature -- Event types

	event_output: EVENT_TYPE [TUPLE [STRING_32]]
			-- event to be used to publish changes to the text presented by the system interface

	event_input: EVENT_TYPE [TUPLE [STRING_32]]
			-- event to be used to publish changes to the text used by the problem domain

	event_input_valid: EVENT_TYPE [TUPLE [BOOLEAN]]
			-- event to be used to publish if state of the input is valid, according to the applied input validator

	event_focus: EVENT_TYPE [TUPLE[]]
			-- event to used to force the input focus

feature {NONE} -- Private implementation

	input_validator: SIF_INPUT_VALIDATOR

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

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
