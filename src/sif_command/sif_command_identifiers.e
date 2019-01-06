note
	description: "Summary description for {SIF_COMMAND_IDENTIFIERS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_COMMAND_IDENTIFIERS

feature {NONE} -- Enumeration main groups systems wise
	--
	-- A command identifier may not be 0 ever.
	--
	Ci_general_lowest: INTEGER_64 = 1

	Ci_lowest: INTEGER_64
		once
			Result := Ci_general_lowest
		end

	Ci_general_highest: INTEGER_64 = 9999

	Ci_product_lowest: INTEGER_64 = 10000
	Ci_product_highest: INTEGER_64 = 59999

	Ci_web_ewf_lowest: INTEGER_64 = 60000
	Ci_web_ewf_highest: INTEGER_64 = 69999

	Ci_highest: INTEGER_64
		once
			Result := Ci_product_highest
		end
	Ci_general_multiple_select: INTEGER_64
		once
			Result := Ci_general_lowest
		end
	Ci_general_log_facility: INTEGER_64
		once
			Result := Ci_general_lowest + 1
		end
	Ci_general_authorise: INTEGER_64
		once
			Result := Ci_general_lowest + 2
		end
	Ci_general_control: INTEGER_64
		once
			Result := Ci_general_lowest + 3
		end
	Ci_general_media: INTEGER_64
		once
			Result := Ci_general_lowest + 4
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end


