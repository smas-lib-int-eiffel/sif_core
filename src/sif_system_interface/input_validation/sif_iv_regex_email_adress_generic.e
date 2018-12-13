note
	description: "Summary description for {SIF_IV_REGEX_EMAIL_ADRESS_GENERIC}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IV_REGEX_EMAIL_ADRESS_GENERIC
	inherit
		SIF_INPUT_VALIDATOR_REGULAR_EXPRESSION
		rename
			make as sif_input_validator_regular_expression_make
		end

		SIF_SHARED_INPUT_VALIDATORS

		SIF_INPUT_VALIDATOR_IDENTIFIERS

create make

feature -- Initialization

	make
		do
			sif_input_validator_regular_expression_make(Ivi_email_generic)
			regular_expression.compile ("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$")
			check
				regular_expression.is_compiled
			end
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
