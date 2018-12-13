note
	description: "Summary description for {SIF_PERMISSION_VIEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_PERMISSION_VIEW
	inherit
		SIF_PERMISSION
			redefine
				is_granted
			end

create
	make_from_view_identifier

feature -- Creation

	make_from_view_identifier( a_view_identifier: like view_identifier )
		do
			make
			put_type (spt_view)
			view_identifier := a_view_identifier
		end

feature -- Status

	is_granted_view(a_view_identifier: like view_identifier) : BOOLEAN
		do
			if a_view_identifier = view_identifier and then is_granted then
				Result := true
			end
		end

	view_identifier: INTEGER_64

feature {NONE} -- Implementation

	is_granted: BOOLEAN
		do
			Result := Precursor
		end

end
