note
	description: "Summary description for {SIF_INPUT_VALIDATOR_REGULAR_EXPRESSION}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

deferred class
	SIF_INPUT_VALIDATOR_REGULAR_EXPRESSION
	inherit
		SIF_INPUT_VALIDATOR
		rename
			make as sif_input_validator_make
		end

feature -- Initialization

	make(an_identifier: INTEGER_64)
		do
			create regular_expression.make
			sif_input_validator_make(an_identifier)
		end

feature -- Validation

	validate(an_input_text: STRING):BOOLEAN
		do
			Result := regular_expression.recognizes (an_input_text)
		end

feature {NONE} -- Implementation

	regular_expression: RX_PCRE_REGULAR_EXPRESSION

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
