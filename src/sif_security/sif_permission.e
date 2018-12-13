note
	description: "Summary description for {SIF_PERMISSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_PERMISSION
	inherit
		SIF_PERMISSION_TYPE
			rename
				make as sif_permission_type_make
			end

		SIF_SHARED_AUTHORISER

create
	make, make_with_type

feature -- Creation

	make
		do
			sif_permission_type_make
			create granted_roles.make
			granted_roles.compare_objects			-- Roles should be compared based on object comparison.

			create granted_authorizables.make
			create granted_groups.make
		end

	make_with_type( a_type: INTEGER )
		do
			make
			put_type (a_type)
		end

feature -- Status

	is_granted: BOOLEAN
		do
			Result := false
			if attached authoriser.authorizable as l_authorizable then
				if attached l_authorizable.role as l_authorizable_role then
					Result := granted_roles.has (l_authorizable_role)
				end
			end
		end

feature -- Element Change

	put_granted_role(a_role: SIF_ROLE)
		do
			granted_roles.put (a_role)
		end

feature {NONE} -- Implementation

	granted_authorizables: LINKED_SET[SIF_AUTHORIZABLE]
		-- Individual authorizables who are granted for this permission

	granted_groups: LINKED_SET[SIF_GROUP_AUTHORIZABLES]
		-- Groups of authorizables granted for this permission

	granted_roles: LINKED_SET[SIF_ROLE]
		-- Individual roles/functions who are granted for this permission

end
