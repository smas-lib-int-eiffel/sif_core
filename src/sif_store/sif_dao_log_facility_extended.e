note
	description: "Summary description for {SIF_DAO_LOG_FACILITY_EXTENDED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_DAO_LOG_FACILITY_EXTENDED

inherit
	SIF_DAO [LOG_FACILITY_EXTENDED]
		redefine
			do_update_item
		end

	OPERATING_ENVIRONMENT

	SHARED_LOG_FACILITY

create
	make

feature -- Creation

	make
		do
			create {LINKED_LIST [LOG_FACILITY_EXTENDED]} last_list.make
		end

feature {NONE} -- Implementation

	do_load_all
			-- Load all items.
			-- Make result available in `last_list'.
		do
			last_list.wipe_out
			last_list.extend (facility)
			is_ok := true
		end

	do_load_by_criteria (a_criteria: CRITERIA [ANY])
			-- Load all items meeting `a_criteria'.
		do
		end


feature -- Element change

	do_update_item (an_item: LOG_FACILITY_EXTENDED)
			-- Update a specific item in the store
		do
			is_ok := true
		end

end
