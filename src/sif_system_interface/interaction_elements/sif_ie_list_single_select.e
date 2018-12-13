note
	description: "Summary description for {SIF_IE_LIST_SINGLE_SELECT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_LIST_SINGLE_SELECT

	inherit
	SIF_INTERACTION_ELEMENT
		redefine
			make
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create event_list
			create event_label
			create event_output_selection
			create event_input_selection
			create event_list_update
			create event_get_selection
			create list.make_empty

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event_list)
			events.extend (event_label)
			events.extend (event_output_selection)
			events.extend (event_input_selection)
			events.extend (event_list_update)
			events.extend (event_get_selection)

			selection := 1
			event_list.subscribe (agent handle_new_list)
		end

feature -- Element Change

	input_selection (a_selection: INTEGER)
		do
			selection := a_selection
			event_input_selection.publish (a_selection)
		end

	output_selection (a_selection: INTEGER)
		do
			selection := a_selection
			event_output_selection.publish (selection)
		end

feature -- Validations

	is_valid: BOOLEAN
		do
			if is_mandatory then
				if selection /= 1 then
					Result := true
				end
			else
				Result := true
			end
		end

feature -- Access

	list: ARRAY[ARRAY[STRING]]

	selection: INTEGER

feature -- Event types

	event_list: SIF_EVENT_TYPE [TUPLE [ARRAY[ARRAY[STRING]]]]
			-- event to be used to publish an event from a system interface

	event_list_update: SIF_EVENT_TYPE [TUPLE []]
			-- event to be used to receive an event when a system interface has to update the list

	event_label: SIF_EVENT_TYPE [TUPLE[STRING]]
			-- event to be used to publish a label text change event to a system interface

	event_output_selection: SIF_EVENT_TYPE [TUPLE[INTEGER]]
			-- event to be used to output a selection controlled by an interactor

	event_input_selection: SIF_EVENT_TYPE [TUPLE[INTEGER]]
			-- event to be used to signal a selection from the system interface	

	event_get_selection: SIF_EVENT_TYPE [TUPLE []]
			-- event to be used to signal to get a selection info from the system interface

feature {NONE} -- Implementation

	handle_new_list (a_list: ARRAY[ARRAY[STRING]])
		local
			new_row: ARRAY[STRING]
			i: INTEGER
		do
			if is_mandatory then
				list.make_empty
				create new_row.make_empty
				new_row.force ("", new_row.count + 1)
				list.force (new_row, list.count + 1)
				from
					i := 1
				until
					i > a_list.count
				loop
					create new_row.make_empty
					new_row.force (a_list.at (i).at (1), new_row.count + 1)
					list.force (new_row, list.count + 1)
					i := i + 1
				end
			else
				list.copy (a_list)
			end
			event_list_update.publish ([])
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
