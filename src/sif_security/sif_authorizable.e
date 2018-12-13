note
	description: "Summary description for {SIF_AUTHORIZABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIF_AUTHORIZABLE

inherit ANY
	rename
		is_equal as any_is_equal
	end


feature -- Query

	identifier : STRING
			-- A unique identifier
		deferred
		end

	role : detachable SIF_ROLE
			-- A role, e.g. a function a person hired or within a company

	has_identifier(a_identifier: like identifier) : BOOLEAN
		require
			identifier_not_empty: not a_identifier.is_empty
		do
			Result := a_identifier.is_equal (identifier)
		end

	has_system_access : BOOLEAN
			-- True, when the authorizable has system access
		deferred
		end

	password: STRING
			-- Password storage for a authorizable, use with care due to security reasons

	enabled: BOOLEAN
			-- True, when the authorizable is enabled for the current system running

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := other.has_identifier( identifier )
		end

end
