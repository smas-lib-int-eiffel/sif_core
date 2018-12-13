note
	description: "Summary description for {SIF_PERMISSION_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_PERMISSION_TYPE

create
	make

feature	-- Creation

	make
		do
			i_type := spt_read
		ensure
			valid_type: valid_type (i_type)
		end

feature -- Element Change

	put_type( a_type: like i_type )
		require
			valid_type: valid_type (a_type)
		do
			i_type := a_type
		ensure
			type_set: type = a_type
		end

feature -- Status

	type: like i_type
		do
			Result := i_type
		end

	valid_type( a_type: like i_type ): BOOLEAN
		do
			Result := set_of_valid_types.count = spt_higest and then set_of_valid_types.has (a_type)
		end

feature {SIF_PERMISSION_TYPE} -- Types

	spt_lowest: like type = 1

	spt_read: INTEGER
		once
			Result := spt_lowest
		end

	spt_create: INTEGER
		once
			Result := spt_lowest + 1
		end

	spt_change: INTEGER
		once
			Result := spt_lowest + 2
		end

	spt_delete: INTEGER
		once
			Result := spt_lowest + 3
		end

	spt_view: INTEGER
		once
			Result := spt_lowest + 4
		end

	spt_higest: INTEGER
		once
			Result := spt_view
		end

feature {NONE} -- Implementation

	i_type: INTEGER

	set_of_valid_types: ARRAYED_SET[INTEGER]
		once
			create Result.make (0)
			Result.extend (spt_read)
			Result.extend (spt_create)
			Result.extend (spt_change)
			Result.extend (spt_delete)
			Result.extend (spt_view)
		end

end
