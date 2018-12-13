note
	description: "Summary description for {SIF_IE_OBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_IE_OBJECT

inherit

	SIF_INTERACTION_ELEMENT
		redefine
			make,
			duplicate
		end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		do
			create event
			create fields.make
			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event)
		end

feature -- Duplication

	duplicate( other: SIF_INTERACTION_ELEMENT )
			-- Duplicate the content of other to Current content
		require else
			not_implemented: False
		do
		end

feature -- Event types

	event: SIF_EVENT_TYPE [TUPLE []]
			-- event to be used to publish an event from a system interface

feature -- Access

	fields: SIF_INTERACTION_ELEMENT_SORTED_SET

;note
	copyright: "Copyright (c) 2014-2018, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
