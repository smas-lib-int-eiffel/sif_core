note
	description: "Summary description for {SIF_PERMISSION_SCHEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_PERMISSION_SCHEME

create
	make

feature -- Creation

	make( a_name: STRING )
		require
			valid_name: not a_name.is_empty
		do
			create name.make_from_string (a_name)
			create permissions.make (0)
			create view_permissions.make
		ensure
			valid_name: not name.is_empty
		end

feature -- Element Change

	put_permission( a_permission: SIF_PERMISSION )
		require
			non_existing_type: not has_permission_type (a_permission.type)
		do
			permissions.put (a_permission, a_permission.type)
		ensure
			has_new_type: has_permission_type (a_permission.type)
		end

	put_view_permission( a_view_permission: SIF_PERMISSION_VIEW )
		require
			identifier_not_present: not has_view_permission (a_view_permission.view_identifier)
		do
			view_permissions.force (a_view_permission)
		end

feature -- Status

	scheme_name: like name
		do
			Result := name
		end

	has_permission_type( a_type: INTEGER): BOOLEAN
		do
			Result := permissions.has_key (a_type)
		end

	get_permission( a_type: INTEGER): detachable SIF_PERMISSION
		require
			valid_permission_type: has_permission_type (a_type)
		do
			Result := permissions.at (a_type)
		end

	get_permissions: like permissions
		do
			Result := permissions
		end

	get_view_permissions: like view_permissions
		do
			Result := view_permissions
		end

	has_view_permission( a_view_identifier: INTEGER_64 ): BOOLEAN
		local
			i: INTEGER
		do
			from
				i := 1
				Result := false
			until
				i > view_permissions.count or Result
			loop
				if view_permissions.at (i).view_identifier = a_view_identifier then
					Result := true
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	name: STRING

	permissions: HASH_TABLE[ SIF_PERMISSION, INTEGER ]

	view_permissions: LINKED_LIST[ SIF_PERMISSION_VIEW ]

end
