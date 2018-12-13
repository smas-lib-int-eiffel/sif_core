note
	description: "Summary description for {SIF_SHARED_COMMAND_MANAGER}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_SHARED_COMMAND_MANAGER

feature -- Access

	command_manager: SIF_COMMAND_MANAGER
			-- Singleton object
		once ("THREAD")
			create Result.make
		ensure
			singleton_not_void: Result /= Void
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
