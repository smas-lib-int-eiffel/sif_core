note
	description: "Summary description for {SIF_IV_DATE_GENERIC}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IV_DATE_GENERIC
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
			sif_input_validator_regular_expression_make(Ivi_date_generic)
			-- Date with leap years.
			-- Accepts '.' '-' and '/' as separators d.m.yy to dd.mm.yyyy (or d.mm.yy, etc) Ex: dd-mm-yyyy d.mm/yy dd/m.yyyy etc etc Accept 00 years also.
			-- Regular expression taken from: http://regexlib.com/DisplayPatterns.aspx?cattabindex=4&categoryId=5
			regular_expression.compile ("((((0?[1-9]|[12]\d|3[01])[\.\-\/](0?[13578]|1[02])[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|((0?[1-9]|[12]\d|30)[\.\-\/](0?[13456789]|1[012])[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|((0?[1-9]|1\d|2[0-8])[\.\-\/]0?2[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|(29[\.\-\/]0?2[\.\-\/]((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)|00)))|(((0[1-9]|[12]\d|3[01])(0[13578]|1[02])((1[6-9]|[2-9]\d)?\d{2}))|((0[1-9]|[12]\d|30)(0[13456789]|1[012])((1[6-9]|[2-9]\d)?\d{2}))|((0[1-9]|1\d|2[0-8])02((1[6-9]|[2-9]\d)?\d{2}))|(2902((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)|00))))")
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
