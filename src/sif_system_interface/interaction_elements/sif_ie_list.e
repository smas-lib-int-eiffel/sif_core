note
	description: "Summary description for {SIF_IE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_IE_LIST

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
			create elements.make(0)
			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event)
		end

feature -- Element change

	duplicate( other: SIF_INTERACTION_ELEMENT )
			-- Duplicate the content of other to Current content
		require else
			correct_other: attached {SIF_IE_LIST}other
		local
			i,j: INTEGER
			l_ie: SIF_INTERACTION_ELEMENT
		do
			if attached {SIF_IE_LIST}other as l_other then
				from
					i := 1
				until
					i > l_other.elements.count
				loop
					from
						j := 1
					until
						j > l_other.elements.at (i).count
					loop
						elements.at (i).go_i_th(j)
						l_other.elements.at (i).go_i_th(j)
						elements.at (i).item.duplicate (l_other.elements.at (i).item)
						j := j + 1
					end
					i := i + 1
				end
			end
		end

feature -- Event types

	event: EVENT_TYPE [TUPLE []]
			-- event to be used to publish an event from a system interface

feature -- Implementation

	elements: ARRAYED_LIST[SIF_INTERACTION_ELEMENT_SORTED_SET]

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
