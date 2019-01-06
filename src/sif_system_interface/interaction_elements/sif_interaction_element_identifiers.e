note
	description: "Summary description for {SIF_INTERACTION_ELEMENT_IDENTIFIERS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INTERACTION_ELEMENT_IDENTIFIERS
	inherit
		ANY
			redefine
				default_create
			end

feature {NONE} -- Intialization

	default_create
		do
			create all_unique_identifiers.make
		end

feature {SIF_INTERACTION_ELEMENT_IDENTIFIERS} -- Enumeration
	--
	-- An interaction element identifier may not be 0 ever.
	-- These identifiers could be used by external systems and therefore may never be changed
	-- While the type is an INTEGER_64 type, the main interaction element identifier groups
	-- will have the capacity of 10000 identifiers. This should be sufficient and future proof.
	--
	Iei_lowest: INTEGER_64 = 1

	Iei_highest: INTEGER_64

	Iei_general_lowest: INTEGER_64
		once
			Result := Iei_lowest
		end

	Iei_general_highest: INTEGER_64 = 9999

	Iei_confirm: INTEGER_64
		once
			Result := Iei_general_lowest
		end
	Iei_cancel: INTEGER_64
		once
			Result := Iei_general_lowest + 1
		end
	Iei_count_total: INTEGER_64						-- Useful to interact the total count of a request where the result has
		once										-- an undefined number of items.
			Result := Iei_general_lowest + 2
		end
	Iei_count_current: INTEGER_64					-- Useful to interact the total count of a request where the result has
		once										-- a defined number of current items.
			Result := Iei_general_lowest + 3
		end
	Iei_previous: INTEGER_64						-- Useful to interact a provious page if any else use 0 for none
		once
			Result := Iei_general_lowest + 4
		end
	Iei_next: INTEGER_64							-- Useful to interact a next page if any else use 0 for none
		once
			Result := Iei_general_lowest + 5
		end
	Iei_first: INTEGER_64							-- Useful to interact the first page if any else use 0 for none
		once
			Result := Iei_general_lowest + 6
		end
	Iei_last: INTEGER_64							-- Useful to interact the last page if any else use 0 for none
		once
			Result := Iei_general_lowest + 7
		end
	Iei_page_number: INTEGER_64						-- Useful to interact the requested page number through query
		once
			Result := Iei_general_lowest + 8
		end
	Iei_self_identifier: INTEGER_64					-- Useful to interact the requested page number through query
		once
			Result := Iei_general_lowest + 9
		end
	Iei_redirect: INTEGER_64						-- Useful to interact a redirection in web environments
		once
			Result := Iei_general_lowest + 10
		end
	Iei_main_controller_caption: INTEGER_64
		once
			Result := Iei_general_lowest + 11
		end
	Iei_main_controller_general_refresh: INTEGER_64
		once
			Result := Iei_general_lowest + 12
		end
	Ie_results_resources: INTEGER_64
		once
			Result := Iei_general_lowest + 13
		end

	-- Multiple select assembly primitive
	Iei_multiple_select_caption: INTEGER_64
		once
			Result := Iei_general_lowest + 100
		end
	Iei_multiple_select_ok: INTEGER_64
		once
			Result := Iei_general_lowest + 101
		end
	Iei_multiple_select_cancel: INTEGER_64
		once
			Result := Iei_general_lowest + 102
		end
	Iei_multiple_select: INTEGER_64
		once
			Result := Iei_general_lowest + 103
		end
	Iei_multiple_select_name: INTEGER_64
		once
			Result := Iei_general_lowest + 104
		end
	Iei_multiple_select_source_list: INTEGER_64
		once
			Result := Iei_general_lowest + 105
		end
	Iei_multiple_select_selected_list: INTEGER_64
		once
			Result := Iei_general_lowest + 106
		end
	Iei_multiple_source_add_selected: INTEGER_64
		once
			Result := Iei_general_lowest + 107
		end
	Iei_multiple_selected_remove_selected: INTEGER_64
		once
			Result := Iei_general_lowest + 108
		end
	Iei_multiple_source_add_all: INTEGER_64
		once
			Result := Iei_general_lowest + 109
		end
	Iei_multiple_selected_remove_all: INTEGER_64
		once
			Result := Iei_general_lowest + 110
		end

	-- Generic log facility
	Iei_generic_log_facility_caption: INTEGER_64
		once
			Result := Iei_general_lowest + 200
		end
	Iei_generic_log_facility_priority: INTEGER_64
		once
			Result := Iei_general_lowest + 201
		end
	Iei_generic_log_facility_list: INTEGER_64
		once
			Result := Iei_general_lowest + 202
		end
	Iei_generic_log_facility_identification: INTEGER_64
		once
			Result := Iei_general_lowest + 203
		end

	-- Generic authorisation
	Iei_generic_authorisation_user_identification: INTEGER_64
		once
			Result := Iei_general_lowest + 300
		end
	Iei_generic_authorisation_user_password: INTEGER_64
		once
			Result := Iei_general_lowest + 301
		end
	Iei_generic_authorisation_authorise: INTEGER_64
		once
			Result := Iei_general_lowest + 302
		end
	Iei_generic_authorisation_error: INTEGER_64
		once
			Result := Iei_general_lowest + 303
		end

	-- Generic Dynamic use
	-- To be used and reused within the same interactor execution
	-- Normally interaction elements are created before interactor do_execute
	-- During do_execute the use of dialogs like error and confirmation
	-- can be needed more then once, therefor these need to dynamically allocated
	-- before each use,
	Iei_generic_dynamic_caption: INTEGER_64
		once
			Result := Iei_general_lowest + 400
		end
	Iei_generic_dynamic_ok: INTEGER_64
		once
			Result := Iei_general_lowest + 401
		end
	Iei_generic_dynamic_cancel: INTEGER_64
		once
			Result := Iei_general_lowest + 402
		end
	Iei_generic_dynamic_text: INTEGER_64
		once
			Result := Iei_general_lowest + 403
		end

	-- Control

	Iei_generic_control_caption: INTEGER_64
		once
			Result := Iei_general_lowest + 500
		end

	-- Media

	Iei_media_caption: INTEGER_64
		once
			Result := Iei_general_lowest + 600
		end
	Iei_media_name: INTEGER_64
		once
			Result := Iei_general_lowest + 601
		end
	Iei_media: INTEGER_64
		once
			Result := Iei_general_lowest + 602
		end
	Iei_media_list: INTEGER_64
		once
			Result := Iei_general_lowest + 603
		end

feature {SIF_INTERACTION_ELEMENT_IDENTIFIERS} -- Range setting

	new_highest(a_new_highest_interaction_element_identifier: INTEGER_64)
			-- Setting a new higest interaction element identifier makes identifiers for a certain domain valid
		require
			is_higher: a_new_highest_interaction_element_identifier > Iei_highest
		do
			Iei_highest := a_new_highest_interaction_element_identifier
		ensure
			new_iei_highest_set: iei_highest = a_new_highest_interaction_element_identifier
		end

feature {SIF_INTERACTION_ELEMENT_IDENTIFIERS} -- Validation

	valid (an_interaction_element_identifier: INTEGER_64): BOOLEAN
			-- Is ``an_interaction_element_identifier'' a valid interaction element identifier?
		do
			Result := (an_interaction_element_identifier >= Iei_lowest and then an_interaction_element_identifier <= Iei_highest) and then
						valid_domain_identifier(an_interaction_element_identifier)
		end

feature {SIF_INTERACTION_ELEMENT_IDENTIFIERS} -- Domain validation

	valid_domain_identifier (an_interaction_element_identifier: INTEGER_64): BOOLEAN
			-- Is "an_interaction_element_identifier" valid within the bounderies of the domain
		do
			-- To be deferred later???????
		end

feature {SIF_INTERACTION_ELEMENT_IDENTIFIERS} -- Uniqueness identifiers

	all_unique_identifiers: LINKED_SET[INTEGER_64]
		-- This has to provide a way to force the system to check if created identifiers are unique in one specific system or product.
		-- Specific interaction elements for specific problem domains have to be unique throughout a system.
		-- Defined interaction element constants need to be put in this set. A set is a collection where each element must be unique,
		-- so a set can force all identifiers to be unique and this will be checked at run time.

	put_new_interaction_element_identifier (a_new_interaction_element_identifier: INTEGER_64) : INTEGER_64
			-- Put the new interaction element identifier in the set of all unique identifiers and check if it's valid.
		require
			valid_interaction_element_identifier: valid( a_new_interaction_element_identifier)
			interaction_element_identifier_not_already_created: not all_unique_identifiers.has (a_new_interaction_element_identifier)
		do
			all_unique_identifiers.extend (a_new_interaction_element_identifier)
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
