note
	description: "Summary description for {SIF_INPUT_VALIDATOR_DATE_FORMAT_DD_MM_YYYY_DASHED_SEPERATOR}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INPUT_VALIDATOR_DATE_FORMAT_DD_MM_YYYY_DASHED_SEPERATOR
	inherit
		SIF_INPUT_VALIDATOR
		rename
			make as sif_input_validator_make
		end

		SIF_INPUT_VALIDATOR_IDENTIFIERS

create make

feature -- Validation

	validate(an_input_text: STRING):BOOLEAN
		local
			l_date: DATE
		do
			create l_date.make_now
			Result := l_date.date_valid (an_input_text, date_format_string)
		end

feature -- Initialization

	make
		do
			sif_input_validator_make(Ivi_date_format_dd_mm_yyyy_dashed_seperator)
		end

feature {NONE} -- Implementation

	date_format_string: STRING = "[0]dd-[0]mm-yyyy"

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
