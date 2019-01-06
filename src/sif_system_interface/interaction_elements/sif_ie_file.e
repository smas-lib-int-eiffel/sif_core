note
	description: "Summary description for {SIF_IE_FILE}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_FILE

inherit

	SIF_INTERACTION_ELEMENT
		redefine
			make,
			duplicate,			-- To be removed when feature gets deferred
			do_to_string		-- To be removed when feature gets deferred
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create {RAW_FILE}file.make ("Initial_dummy_file_name")

			create event_input_file
			create event_output_file

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event_input_file)
			events.extend (event_output_file)
		end

feature -- Element change

	put_file( a_file: FILE )
			-- True, when an_input_string is convertable to the type of the interaction element
		do
			file.make (a_file.name)
		end

	duplicate( other: SIF_INTERACTION_ELEMENT )
			-- Duplicate the content of other to Current content
		require else
			correct_other: attached {SIF_IE_FILE}other
		do
			if attached {SIF_IE_FILE}other as l_other then
				file.make (l_other.file.name)
			end
		end

feature {SIF_INTERACTION_ELEMENT} -- Conversion

	do_to_string( a_result: like to_string)
		-- Convert the contents of Current to a string representation
		do
			a_result.append (file.out)
		end

feature -- Event types

	event_input_file: EVENT_TYPE [TUPLE [FILE]]
			-- event to be used to publish an event from a system interface, a file is supplied by en external environment

	event_output_file: EVENT_TYPE [TUPLE [FILE]]
			-- event to be used to publish an event to a system interface, a file is to be supplied to an external environment

feature -- Implementation

	file: FILE

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
