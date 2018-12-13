note
	description: "Summary description for {SIF_IE_LIST_MULTIPLE_SELECT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_LIST_MULTIPLE_SELECT
inherit

	SIF_INTERACTION_ELEMENT
		redefine
			make,
			copy,
			reset_events,
			do_restore_subscriptions,
			do_suspend_subscriptions
		select
			default_create
		end

	SIF_INTERACTION_ELEMENT_IDENTIFIERS
		rename
			default_create as sif_iei_default_create
		undefine
			is_equal,
			copy
		end

	SIF_SHARED_INPUT_VALIDATORS
		undefine
			default_create,
			is_equal,
			copy
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create ie_name.make( Iei_multiple_select_name, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_descriptive, "name")
			if attached input_validators.validators.item (Ivi_not_empty) as l_ivi_not_empty then
				ie_name.put_validation(l_ivi_not_empty)
			end
			create ie_source_list.make( Iei_multiple_select_source_list, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "source")
			create ie_selected_list.make (Iei_multiple_select_selected_list, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, "selected")
			create ie_event_add_selected.make (Iei_multiple_source_add_selected, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "remove_selected")
			create ie_event_remove_selected.make (Iei_multiple_selected_remove_selected, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "remove_selected")
			create ie_event_source_add_all.make (Iei_multiple_source_add_all, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "source_add_all")
			create ie_event_selected_remove_all.make (Iei_multiple_selected_remove_all, a_sorted_set_of_interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "selected_remove_all")
			create selections.make_empty
			sif_iei_default_create
			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)
		end

feature -- Initialization

	reset_events
		do
			Precursor
			if attached ie_name as l_ie_name then
				l_ie_name.reset_events
			end
			ie_source_list.reset_events
			ie_selected_list.reset_events
			ie_event_add_selected.reset_events
			ie_event_remove_selected.reset_events
			ie_event_source_add_all.reset_events
			ie_event_selected_remove_all.reset_events
		end

feature -- Duplication

	copy (other: like Current)
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		require else
			other_name_not_void: other.ie_name /= void
			other_selections_not_void: other.selections /= void
		do
			if attached other.ie_name as l_source_name then
				if attached ie_name as l_target_name then
					l_target_name.text.copy (l_source_name.text)
				end
				selections.copy (other.selections)
			end
		end

feature -- Functionality

	do_restore_subscriptions
		do
			if attached ie_name as l_ie_name then
				l_ie_name.restore_subscriptions
			end
			ie_event_add_selected.restore_subscriptions
			ie_event_remove_selected.restore_subscriptions
			ie_event_source_add_all.restore_subscriptions
			ie_event_selected_remove_all.restore_subscriptions
		end

	do_suspend_subscriptions
		do
			if attached ie_name as l_ie_name then
				l_ie_name.suspend_subscriptions
			end
			ie_event_add_selected.suspend_subscriptions
			ie_event_remove_selected.suspend_subscriptions
			ie_event_source_add_all.suspend_subscriptions
			ie_event_selected_remove_all.suspend_subscriptions
		end

feature -- Access

	selections: ARRAY[INTEGER]
		-- Selections from the source list and stored as the indexes of the source list.

	ie_name : SIF_IE_TEXT
		-- Name to be presented for identifying the source for which the selecttions are made.

	ie_source_list: SIF_IE_LIST_SINGLE_SELECT
		-- The source list of items to choose from.

	ie_selected_list: SIF_IE_LIST_SINGLE_SELECT
		-- The list of selected items from the source list.

	ie_event_add_selected: SIF_IE_EVENT
		-- Event which indicates selections made have to be added to the list of selected items.

	ie_event_remove_selected: SIF_IE_EVENT
		-- Event which indicates selected items have to be removed from the list of selected items.

	ie_event_source_add_all: SIF_IE_EVENT
		-- Event which indicates all items in the source list have to be added to the list of selected items.

	ie_event_selected_remove_all: SIF_IE_EVENT
		-- Event which indicates all items of the selected items have to be removed.

	convert_selections_to_list : ARRAY[ARRAY[STRING]]
		local
			new_row : ARRAY[STRING]
			i: INTEGER
		do
			create Result.make_empty
			from
				i := 1
			until
				i > selections.count
			loop
				if selections.at (i) < ie_source_list.list.count + 1 then
					create new_row.make_empty
					new_row.force (ie_source_list.list.at (selections.at (i)).at (1), new_row.count + 1)
					Result.force (new_row, Result.count + 1)
				end
				i := i + 1
			end
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end

