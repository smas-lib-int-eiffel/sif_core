note
	description: "Summary description for {SIF_INPUT_VALIDATOR_IDENTIFIERS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INPUT_VALIDATOR_IDENTIFIERS

feature {NONE} -- Enumeration main groups systems wise
	--
	-- An input validator identifier may not be 0 ever.
	--
	Ivi_lowest: INTEGER_64 = 1

	Ivi_always_ok: INTEGER_64
		do
			Result := Ivi_lowest
		end

	Ivi_email_generic: INTEGER_64
		do
			Result := Ivi_lowest + 1
		end

	Ivi_first_name_last_name: INTEGER_64
		do
			Result := Ivi_lowest + 2
		end
	Ivi_not_empty: INTEGER_64
		do
			Result := Ivi_lowest + 3
		end
	Ivi_date_generic: INTEGER_64
		do
			Result := Ivi_lowest + 4
		end
	Ivi_date_format_dd_mm_yyyy_dashed_seperator: INTEGER_64
		do
			Result := Ivi_lowest + 5
		end
	Ivi_iso_8601: INTEGER_64
		do
			Result := Ivi_lowest + 6
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end

