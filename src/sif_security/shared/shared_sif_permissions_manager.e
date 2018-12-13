note
	description: "Summary description for {SHARED_SIF_PERMISSION_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_SIF_PERMISSIONS_MANAGER

feature -- Access

	permissions_manager: SIF_PERMISSIONS_MANAGER
			-- Singleton object
		once ("PROCESS")
			create Result.make
		ensure
			singleton_not_void: Result /= Void
		end

end
