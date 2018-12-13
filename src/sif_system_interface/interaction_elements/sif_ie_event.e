note
	description: "Summary description for {SIF_IE_EVENT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_EVENT

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
			create event
			create event_label
			create event_output_select
			create event_output_deselect
			create event_add_submit
			create event_submit

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event)
			events.extend (event_output_select)
			events.extend (event_output_deselect)
			events.extend (event_label)
			events.extend (event_add_submit)
			events.extend (event_submit)

			selected := false
			event_output_deselect.subscribe ( agent handle_deselected)
			event_output_select.subscribe (agent handle_selected)
		end

feature -- Event types

	event: SIF_EVENT_TYPE [TUPLE []]
			-- event to be used to publish an event from a system interface

	event_output_select: SIF_EVENT_TYPE [TUPLE []]
			-- event to be used to publish a select event to a system interface component, e.g. a link label

	event_output_deselect: SIF_EVENT_TYPE [TUPLE []]
			-- event to be used to publish a deselect event to a system interface component, e.g. a link label			

	event_label: SIF_EVENT_TYPE [TUPLE[STRING]]
			-- event to be used to publish a label text change event to a system interface component, e.g. a button

	-- Special event to test the submit button on the webpage
	event_add_submit: SIF_EVENT_TYPE [TUPLE []]
			-- special event to be used to publish that it needs to attach a submit function, e.g. a submit button

	event_submit: SIF_EVENT_TYPE [TUPLE [STRING_TABLE[STRING]]]
			-- event to be used to publish submitted information to the system interface, e.g. a submit button

feature -- Status

	is_selected: BOOLEAN
			-- Is Current selected?
		do
			Result := selected
		end

feature {NONE} -- Implementation

	handle_deselected
		do
			 selected := false
		end

	selected: BOOLEAN
			-- Indicated if the current is selected

	handle_selected
		do
			selected := true
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
