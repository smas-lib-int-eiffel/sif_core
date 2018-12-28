note
	description: "Summary description for {SIF_IE_QUESTIONS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_IE_QUESTIONS
	inherit
		SIF_INTERACTION_ELEMENT
			redefine
				make
			end

create
	make

feature -- Creation

	make (an_interaction_element_identifier: INTEGER_64; a_sorted_set_of_interaction_elements : SIF_INTERACTION_ELEMENT_SORTED_SET; a_type: like {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.type; a_descriptor: like descriptor )
		local
			empty_tuple: TUPLE
		do
			create event_question_categories
			create event_questions_update
			create empty_tuple
			--
			-- Questions related creations
			--
			create categorized_questions.make(0)

			Precursor (an_interaction_element_identifier, a_sorted_set_of_interaction_elements, a_type, a_descriptor)

			events.extend (event_question_categories)
			events.extend (event_questions_update)

			event_question_categories.subscribe (agent handle_new_categorized_questions)
		end

feature -- Access questions

	categorized_questions: HASH_TABLE[ TUPLE, INTEGER ]

feature -- Event types

	event_question_categories: EVENT_TYPE [TUPLE [like categorized_questions]]
			-- event to be used to publish the activities to present

	event_questions_update: EVENT_TYPE [TUPLE ]
			-- event to be used to receive an event when a system interface has to update the questions.

feature {NONE} -- Implementation

	handle_new_categorized_questions ( all_categorized_questions: like categorized_questions)
		do
			categorized_questions.copy (all_categorized_questions)
			--event_activities_update.publish ([])
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
