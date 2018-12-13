note
	description: "Summary description for {SIF_INPUT_VALIDATORS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INPUT_VALIDATORS
	inherit
		SIF_INPUT_VALIDATOR_IDENTIFIERS

create make

feature -- Access

	validator_always_ok : SIF_INPUT_VALIDATOR_ALWAYS_OK

	validators: HASH_TABLE[SIF_INPUT_VALIDATOR, INTEGER_64]
			-- All available validator functions in the system

feature {NONE} -- Initialization

	make
		do
			create validator_always_ok.make
			create validators.make (50)
			validators.extend (validator_always_ok, Ivi_always_ok)
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
