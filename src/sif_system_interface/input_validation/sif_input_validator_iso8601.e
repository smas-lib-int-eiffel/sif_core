note
	description: "Summary description for {SIF_INPUT_VALIDATOR_ISO8601}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_INPUT_VALIDATOR_ISO8601
	inherit
		SIF_INPUT_VALIDATOR
		rename
			make as sif_input_validator_make
		end

		SIF_INPUT_VALIDATOR_IDENTIFIERS

		ISO8601_ROUTINES

create make

feature -- Validation

	validate(an_input_text: STRING):BOOLEAN
		do
			Result := valid_iso8601_date_time (an_input_text)
			if not Result then
				Result := valid_iso8601_date (an_input_text)
				if not Result then
					Result := valid_iso8601_time (an_input_text)
				end
			end
		end

feature -- Initialization

	make
		do
			sif_input_validator_make(Ivi_iso_8601)
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
