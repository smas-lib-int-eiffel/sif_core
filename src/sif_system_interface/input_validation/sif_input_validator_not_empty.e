note
	description: "Summary description for {SIF_INPUT_VALIDATOR_NOT_EMPTY}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INPUT_VALIDATOR_NOT_EMPTY
	inherit
		SIF_INPUT_VALIDATOR
		rename
			make as sif_input_validator_make
		end

		SIF_SHARED_INPUT_VALIDATORS

		SIF_INPUT_VALIDATOR_IDENTIFIERS

create make

feature -- Validation

	validate(an_input_text: STRING):BOOLEAN
		do
			-- For now we will handle issue #33 here until it is solved in the Eiffel ABEL SQLlite library.
			Result := not an_input_text.is_empty and not (an_input_text.has (''') or an_input_text.has (';'))
		end

feature -- Initialization

	make
		do
			sif_input_validator_make(Ivi_not_empty)
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
