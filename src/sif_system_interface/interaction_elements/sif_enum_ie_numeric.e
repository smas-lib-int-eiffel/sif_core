note
	description: "Summary description for {SIF_ENUM_IE_NUMERIC}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_ENUM_IE_NUMERIC

create
	make

feature -- Creation

	make(a_type: like {SIF_ENUM_IE_NUMERIC}.type)
			-- Create a numerical type
		do
			type := a_type
		ensure
			correct_type: type = a_type
		end

feature -- Types

	enum_natural: like type = 1
			-- Meaning the interaction element numeric is a natural type

feature -- Contract support

	is_type_valid (a_type: like type): BOOLEAN
			-- If `a_type' valid?
		do
			inspect a_type
			when enum_natural then
				Result := True
			else
			end
		end

feature frozen -- Type information

	type : INTEGER

invariant

	correct_type: is_type_valid(type)

;note
	copyright: "Copyright (c) 2017-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
