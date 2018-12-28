note
	description: "Summary description for {SIF_IE_GRID}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_GRID

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
			create event_output_header
			create event_input_row_selected
			create event_output_row_selected
			create list.make_empty

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			last_selected_index := -1;

			event_list.subscribe (agent handle_new_list)
			event_input_row_selected.subscribe (agent handle_input_row_selected)


			events.extend (event_list)
			events.extend (event_output_header)
			events.extend (event_input_row_selected)
			events.extend (event_output_row_selected)
		end

feature -- Presentation

	resize_all_columns_to_content
		do
			if attached call_back_resize_all_columns_to_content as l_call_back_resize_all_columns_to_content then
				l_call_back_resize_all_columns_to_content.call
			end
		end

feature -- Selection

	output_selection(a_row_index: INTEGER)
		-- Select the row indicated by index
			require
				valid_row_index: a_row_index > 0
			do
				check call_back_selected_index_installed: attached call_back_selected_index end
				check call_back_is_selected_installed: attached call_back_is_selected end

				event_output_row_selected.publish(a_row_index)
				last_selected_index := -1
				if attached call_back_is_selected as l_call_back_is_selected and then
				   attached call_back_selected_index as l_call_back_selected_index then
				   	if l_call_back_is_selected.item (void) then
						last_selected_index := l_call_back_selected_index.item (void)
				   	end
				end
			end

	current_selected_index: INTEGER
		-- Get the current selected row in the grid
			require
				selection_exists: is_selected
			do
				Result := last_selected_index
			end

	is_selected: BOOLEAN
		-- Indicate if a selection exists
			do
				if attached call_back_is_selected as l_call_back_is_selected then
					Result := l_call_back_is_selected.item(void)
				end
			end

feature -- System interface Control callbacks

	set_call_back_is_selected( a_call_back_is_selected: like call_back_is_selected )
		do
			call_back_is_selected := a_call_back_is_selected
		end

	set_call_back_selected_index( a_call_back_selected_index: like call_back_selected_index )
		do
			call_back_selected_index := a_call_back_selected_index
		end

	set_call_back_resize_all_columns_to_content( a_call_back_resize_all_columns_to_content: like call_back_resize_all_columns_to_content )
		do
			call_back_resize_all_columns_to_content := a_call_back_resize_all_columns_to_content
		end

feature -- Access

	list: ARRAY[ARRAY[STRING]]

	last_selected_index : INTEGER

feature {NONE} -- Implementation

	handle_new_list(a_list: ARRAY[ARRAY[STRING]])
		do
			list.copy (a_list)
			if list.count = 0 then
				last_selected_index := -1
			end
		end

	handle_input_row_selected( a_selected_index: INTEGER )
		do
			last_selected_index := a_selected_index
		end

feature -- Event types

	event_list: EVENT_TYPE [TUPLE [ARRAY[ARRAY[STRING]]]]
			-- event to be used to manage the content of the list of the grid

	event_output_header: EVENT_TYPE [TUPLE [ARRAY [STRING]] ]
			-- event to be used to manage the content of a header of the grid

	event_input_row_selected: EVENT_TYPE [TUPLE[INTEGER]]
			-- event to be used when a row in the grid is selected by user interaction

	event_output_row_selected: EVENT_TYPE [TUPLE[INTEGER]]
			-- event to be used when a row is selected by the model

feature {NONE} -- System interface control side call_backs

	call_back_is_selected: detachable FUNCTION [ANY, TUPLE, BOOLEAN ]

	call_back_selected_index: detachable FUNCTION [ANY, TUPLE, INTEGER ]

	call_back_resize_all_columns_to_content: detachable PROCEDURE [ANY, TUPLE ]

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
