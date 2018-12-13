note
	description: "Summary description for {SIF_INTERACTION_ELEMENT_SORTED_SET}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INTERACTION_ELEMENT_SORTED_SET

inherit

	PART_SORTED_SET [SIF_INTERACTION_ELEMENT]
		redefine
			make,
			put,
			extend
		end

create
	make, make_sublist

feature  -- Initialization

	make
		do
			Precursor
			object_comparison := true
		end

feature -- Element change

	extend (v: SIF_INTERACTION_ELEMENT)
			-- Ensure that structure includes `v'.
		do
			implementation_put_extend (v)
			Precursor (v)
		end

	put (v: SIF_INTERACTION_ELEMENT)
			-- Ensure that structure includes `v'.
		do
			implementation_put_extend (v)
			Precursor (v)
		end

feature -- Functionality

	restore_subscriptions
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.restore_subscriptions
				Current.forth
			end
		end

	suspend_subscriptions
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.suspend_subscriptions
				Current.forth
			end
		end

	put_system_interface( a_system_interface: SIF_SYSTEM_INTERFACE)
		require
			a_system_interface_not_void: a_system_interface /= void
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.put_system_interface(a_system_interface)
				Current.forth
			end
		end

	remove_system_interface
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.remove_system_interface
				Current.forth
			end
		end

	enable_all
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.event_enable.publish ([])
				Current.forth
			end
		end

	disable_all
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.event_disable.publish ([])
				Current.forth
			end
		end

	clear_events
		do
			from
				Current.start
			until
				Current.after
			loop
				Current.item.reset_events
				Current.forth
			end
		end

feature -- Access

	has_interaction_element( an_interaction_element_id: INTEGER_64): BOOLEAN
			-- Does the sorted set of interactionelements have an element identified by an_interaction_element_id?
		do
			from
				Current.start
			until
				Current.after or else Current.item.interaction_element_identifier = an_interaction_element_id
			loop
				Current.forth
			end
			Result := not Current.after
		ensure
			correct_result: Current.after implies Result = false
		end

	interaction_element( an_interaction_element_id: INTEGER_64): detachable SIF_INTERACTION_ELEMENT
			-- Retrieve the interaction element indentified by an_interaction_id
		do
			from
				Current.start
			until
				Current.after or else Result /= void
			loop
				if Current.item.interaction_element_identifier = an_interaction_element_id then
					Result := Current.item
				end
				Current.forth
			end
		end

feature {NONE} -- Supporting class features

	implementation_put_extend (v: SIF_INTERACTION_ELEMENT)
		do
			v.set_sorting_number( count )
		end

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
