note
	description: "Summary description for {SIF_IE_LIST_N_LIST_MULTIPLE_SELECT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_LIST_N_LIST_MULTIPLE_SELECT
inherit

	SIF_INTERACTION_ELEMENT
		rename
			make as sif_interaction_element_make
		redefine
			reset_events,
			do_restore_subscriptions,
			do_suspend_subscriptions
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor; a_source_list_multiple_selection: ARRAY[ARRAY[STRING]] )
		do
			create list_n_multiple_select.make_empty
			ie_source_list_multiple_selection := a_source_list_multiple_selection

			sif_interaction_element_make(an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor )
		end

feature -- Initialization

	reset_events
		do
			Precursor
			if attached ie_name as l_ie_name then
				l_ie_name.reset_events
			end
		end

feature -- Element Change

	create_multiple_selections( a_name: STRING; a_list_of_selections: ARRAY[ARRAY[STRING]] )
		local
			i : INTEGER
			j : INTEGER
			l_selections: ARRAY[INTEGER]
		do
			create l_selections.make_empty
			ie_source_list_multiple_selection.compare_objects
			from
				i := 1
			until
				i > a_list_of_selections.count
			loop
				from
					j := 1
				until
					j > ie_source_list_multiple_selection.count
				loop
					ie_source_list_multiple_selection.at (j).compare_objects
					a_list_of_selections.at (i).compare_objects
					if ie_source_list_multiple_selection.at (j).is_equal (a_list_of_selections.at (i)) then
						l_selections.force (j, l_selections.count + 1)
					end
					j := j + 1
				end
				i := i + 1
			end
			extend(a_name, l_selections)
		end

	extend( a_name: STRING; a_selections: ARRAY[INTEGER] )
		local
			new_multiple_selections: TUPLE[STRING, ARRAY[INTEGER]]
			name: STRING
			selections: ARRAY[INTEGER]
		do
			create new_multiple_selections
			create name.make_from_string (a_name)
			new_multiple_selections[1] := name
			create selections.make_from_array (a_selections)
			new_multiple_selections[2] := selections
			list_n_multiple_select.force (new_multiple_selections, list_n_multiple_select.count + 1)
		end

	convert_names_to_list: ARRAY[ARRAY[STRING]]
		local
			i: INTEGER
			new_row : ARRAY[STRING];
		do
			create Result.make_empty
			from
				i := 1
			until
				i > list_n_multiple_select.count
			loop
				if attached {STRING}list_n_multiple_select.at (i)[1] as l_name then
					create new_row.make_empty
					new_row.force (l_name, new_row.count + 1 )
					Result.force (new_row, Result.count + 1)
				end
				i := i + 1
			end
		end
feature -- Functionality

	do_restore_subscriptions
		do
			if attached ie_name as l_ie_name then
				l_ie_name.restore_subscriptions
			end
		end

	do_suspend_subscriptions
		do
			if attached ie_name as l_ie_name then
				l_ie_name.suspend_subscriptions
			end
		end

feature -- Access

	list_n_multiple_select: ARRAY[ TUPLE[ STRING, ARRAY[INTEGER] ] ]
		-- A list of multiple selections of the source list.
		-- The tuple stores the name of the group and the selections made.

	ie_name : detachable SIF_IE_TEXT

	ie_source_list_multiple_selection: ARRAY[ARRAY[STRING]]

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
