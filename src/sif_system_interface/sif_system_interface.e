note
	description: "[
				The interface between the software system and the enviroment using the system, 
				hence the name: system interface. Features of a software system can be executed 
				by the environment. Features of	the software system are to be implemented by so called interactors. 
				When an interactor is executed, it interacts with the environment using the abstract feature 
				interact using a sorted set of interaction elements as an argument. 
				Each interaction element in the sorted set of elements determines the type of 
				interaction with the environment.
				 ]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=system interface"
	legal: "See notice at end of class."

deferred class
	SIF_SYSTEM_INTERFACE
	inherit
		SIF_SYSTEM_INTERFACE_IDENTIFIERS

		SHARED_SIF_PERMISSIONS_MANAGER
			undefine
				default_create
			end

feature -- Interaction

	interact(an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
			-- interact through the set of interaction elements
		require
			set_not_void: an_interaction_elements_set /= void
		deferred
		end

	human: BOOLEAN
			-- True, when system interface is used for interaction with human beings.
		deferred
		end

feature -- Access

	destroy
			-- Destroy the system interface
		deferred
		end

feature -- Identification

	id : INTEGER
			-- Return the correct system interface identifier as defined in SIF_SYSTEM_INTERFACE_IDENTIFIERS
		deferred
		end

feature -- Error handling

	error (an_error: STRING)
			-- an error ocurred, make sure the external user or system is notified
		do
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end

