note
	description: "Summary description for {SIF_ENUM_INTERACTION_ELEMENT_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

class
	SIF_ENUM_INTERACTION_ELEMENT_TYPE

feature -- Types

	enum_mandatory: like type = 1
			-- Meaning the interaction element is necessary for a resource

	enum_optional: like type = 2
			-- Meaning the interaction element is optional for a resource

	enum_control: like type = 3
			-- Meaning the interaction element is not used for a resource

	enum_descriptive: like type = 4
			-- Meaning the interaction element is descriptive

	enum_result: like type = 5
			-- Meaning the interaction element is used in a result

feature -- Contract support

	is_type_valid (a_type: like type): BOOLEAN
			-- If `a_type' valid?
		do
			inspect a_type
			when enum_mandatory, enum_optional, enum_control, enum_descriptive, enum_result then
				Result := True
			else
			end
		end

feature {NONE} frozen -- Type information

	type : INTEGER

;note
	copyright: "Copyright (c) 2017-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end


