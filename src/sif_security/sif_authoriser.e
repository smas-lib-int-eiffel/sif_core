note
	description: "Summary description for {TM_AUTHORISER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_AUTHORISER

feature -- Authorisation

	authorise( a_identifier: STRING; a_password: STRING ): BOOLEAN
		do
			Result := true
		end

	password( a_password: STRING ): STRING
		do
			create Result.make_empty
		end

	authorizable : detachable SIF_AUTHORIZABLE

feature {NONE} -- Implementation

	authorizable_criteria(a_authorizable: SIF_AUTHORIZABLE): BOOLEAN
		do
			Result := a_authorizable.enabled and a_authorizable.has_system_access
		end

end
