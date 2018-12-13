note
	description: "Summary description for {SHARED_TM_AUTHORISER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_SHARED_AUTHORISER

feature -- Access

	authoriser: SIF_AUTHORISER
			-- Singleton object
		do
			Result := internal_authoriser_cell.item
		ensure
			singleton_not_void: Result /= Void
		end

feature -- Element change

	put_authoriser(a_authoriser: like authoriser)
			-- Put a new authoriser
		do
			internal_authoriser_cell.replace (a_authoriser)
		end

feature {NONE} -- Implementation

	internal_authoriser_cell: CELL[  SIF_AUTHORISER ]
			-- Location to store the authoriser single instance (Singleton)
		once
			create Result.put (create {SIF_AUTHORISER})
		end

end
