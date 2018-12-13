note
	description: "Summary description for {SIF_INPUT_VALIDATOR}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=input validation"
	legal: "See notice at end of class."

deferred class
	SIF_INPUT_VALIDATOR
	inherit
		SIF_SHARED_INPUT_VALIDATORS
		undefine
			is_equal,
			copy
		end

feature -- Initialization

	make(an_identifier: like identifier)
		do
			identifier := an_identifier
			input_validators.validators.extend (Current, an_identifier)
		end

feature {NONE} -- Implementation

	identifier: INTEGER_64

feature -- Validation

	validate(an_input_text: STRING):BOOLEAN
			-- True, when text complies to validation rule(s).
		deferred
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
