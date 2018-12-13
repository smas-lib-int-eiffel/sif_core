note
	description: "Summary description for {SIF_IE_TEXT_ISO_8601}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_IE_TEXT_ISO_8601
	inherit
		SIF_IE_TEXT
			rename
				is_equal as ie_text_is_equal
			redefine
				make
			end

		ISO8601_ROUTINES
			select
				is_equal
			end

		SIF_SHARED_INPUT_VALIDATORS
			rename
				is_equal as shared_input_validators_is_equal
			end

create
	make_date, make_time, make_date_time

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor)
		do
			Precursor(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			check input_validators.validators.has(Ivi_iso_8601) end
			if attached input_validators.validators.item (Ivi_iso_8601) as l_input_validator then
				put_validation (l_input_validator)
			end
		end

	make_date (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			mode := mode_date
			make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)
		end

	make_time (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			mode := mode_time
			make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)
		end

	make_date_time (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			mode := mode_date_time
			make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)
		end

feature -- Element change

	put_input_date( an_input_string: STRING )
			-- an_input string will be converted according to the mode set
			-- an_input string should be a valid Eiffel date format
		require
			correct_mode: mode = mode_date
		local
			l_date: DATE
		do
			create l_date.make_now
			if l_date.date_valid_default (an_input_string) then
				l_date.make_from_string_default (an_input_string)
				text := date_to_iso8601_string(l_date)
			else
				-- We should nerver get here --> means programming error
				check false end
				text.make_empty
			end
		end

	put_input_time( an_input_string: STRING )
			-- an_input string will be converted according to the mode set
			-- an_input string should be a valid Eiffel time format
		require
			correct_mode: mode = mode_time
		local
			l_time: TIME
		do
			create l_time.make_now
			if l_time.time_valid (an_input_string, default_time_format) then
				l_time.make_from_string_default (an_input_string)
				text := time_to_iso8601_string (l_time)
			else
				-- We should nerver get here --> means programming error
				check false end
				text.make_empty
			end
		end

	put_input_date_time( an_input_string: STRING )
			-- an_input string will be converted according to the mode set
			-- an_input string should be a valid Eiffel date_time format
		require
			correct_mode: mode = mode_date_time
		local
			l_date_time: DATE_TIME
		do
			create l_date_time.make_now
			if l_date_time.date_time_valid (an_input_string, {DATE_TIME_TOOLS}.default_format_string) then
				l_date_time.make_from_string_default (an_input_string)
				text := date_time_to_iso8601_string(l_date_time)
			else
				-- We should nerver get here --> means programming error
				check false end
				text.make_empty
			end
		end


feature -- enumeration

	mode: INTEGER
			-- The mode in which the ISO8601 is working

	mode_date: like mode = 1

	mode_time: like mode = 2

	mode_date_time: like mode = 3

end
