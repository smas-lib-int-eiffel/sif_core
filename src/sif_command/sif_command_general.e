note
	description: "Summary description for {SIF_COMMAND_GENERAL}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

deferred class
	SIF_COMMAND_GENERAL[G -> SIF_DAO[ANY] create make end ]
	inherit
		SIF_COMMAND[G]
			redefine
--				default_create,
				make_with_identifier_and_ie_set
			select
				default_create
			end

		SIF_COMMAND_IDENTIFIERS
			undefine
				default_create
			end

		SIF_INTERACTION_ELEMENT_IDENTIFIERS
			rename
				default_create as sif_interaction_element_identifiers_default_create
			end

feature {NONE} -- Initialization

--	default_create
--		do
--			command_descriptors.put ("Log facility extended", Ci_general_log_facility)
--		end

	make_with_identifier_and_ie_set (a_command_identifier : INTEGER_64; a_descriptor: like descriptor; an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
		do
			sif_interaction_element_identifiers_default_create
			Precursor(a_command_identifier, a_descriptor, an_interaction_elements_set)
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
