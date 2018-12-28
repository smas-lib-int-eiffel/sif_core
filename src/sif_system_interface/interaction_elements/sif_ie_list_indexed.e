note
	description: "Summary description for {SIF_IE_LIST_INDEXED}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_LIST_INDEXED

	inherit
	SIF_INTERACTION_ELEMENT
		redefine
			make
		end

create
	make

feature -- Event types

	event_list_indexed: EVENT_TYPE [TUPLE [ARRAY[TUPLE[INTEGER,STRING]]]]
			-- event to be used to publish an event from a system interface

	event_label: EVENT_TYPE [TUPLE[STRING]]
			-- event to be used to publish a label text change event to a system interface

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create event_list_indexed
			create event_label

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend(event_list_indexed)
			events.extend(event_label)
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
