note
	description: "Summary description for {SIF_INPUT_VALIDATOR_ALWAYS_OK}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INPUT_VALIDATOR_ALWAYS_OK
	inherit
		SIF_INPUT_VALIDATOR
		rename
			make as sif_input_validator_make
		end

		SIF_SHARED_INPUT_VALIDATORS

		SIF_INPUT_VALIDATOR_IDENTIFIERS

create make

feature -- Validation

	validate (an_input_text: STRING): BOOLEAN
			-- True
		do
			Result := True
		end

feature -- Initialization

	make
		do
			identifier := Ivi_always_ok
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
