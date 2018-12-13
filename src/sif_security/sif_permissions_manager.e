note
	description: "Summary description for {SIF_PERMISSION_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_PERMISSIONS_MANAGER
	inherit
		SIF_PERMISSION_TYPE
			redefine
				make
			end

create make

feature {SHARED_SIF_PERMISSIONS_MANAGER} -- Creation

	make
		do
			Precursor
			create schemes.make (0)
			use_security := true
		end

	has_interaction_element_permission( ie: SIF_INTERACTION_ELEMENT ): BOOLEAN
		do
			Result := false
			if use_security then
				if attached schemes.at (default_scheme_name) as l_permission_scheme then
					if l_permission_scheme.has_permission_type (ie.permission_type.type) then
						if attached l_permission_scheme.get_permission (ie.permission_type.type) as l_permission then
							Result := l_permission.is_granted
						end
					end
				end
			else
				Result := true
			end
		end

	has_view_identifier_permission( a_view_identifier: INTEGER_64 ): BOOLEAN
		local
			i: INTEGER
		do
			Result := false
			if use_security then
				if attached schemes.at (default_scheme_name) as l_permissions_scheme then
					from
						i := 1
					until
						i > l_permissions_scheme.get_view_permissions.count
					loop
						if l_permissions_scheme.get_view_permissions.at (i).view_identifier = a_view_identifier then
							Result := l_permissions_scheme.get_view_permissions.at (i).is_granted_view (a_view_identifier)
						end
						i := i + 1
					end
				end
			else
				Result := true
			end
		end

feature -- Element Change

	put_scheme( a_scheme: SIF_PERMISSION_SCHEME )
		do
			schemes.put (a_scheme, a_scheme.scheme_name)
		end

	put_use_security(a_use_security: like use_security)
		do
			use_security := a_use_security
		ensure
			use_security: use_security = a_use_security
		end

feature -- Status

	default_scheme_name: STRING
		once
			Result := "Default Permission Scheme"
		end

feature -- Implementation

	use_security: BOOLEAN assign put_use_security

feature {NONE} -- Implementation

	schemes: STRING_TABLE[SIF_PERMISSION_SCHEME]

end
