note
	description: "Summary description for {SIF_DAO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIF_DAO [G]

inherit
	DAO_LOADER [G]


feature -- Input

	do_load_by_identification (an_identification: STRING)
			-- Retrieve a data item indentified by identification
		do
		end

	do_load_item_count
			-- Retrieve the available item count in the store
		do
		end

	do_load_page (offset, count: NATURAL): INTEGER
			-- Load a page of items count by offset
		do
			Result := 0
		end

feature -- Element change

	save_item (a_item: G)
			-- Save a specific item in the store
		do
			is_ok := false
			last_saved_item.wipe_out
			do_save_item (a_item)
			if is_ok then
				last_count := 1
				last_saved_item.extend (a_item)
			else
				last_count := 0
			end
		end

	update_item (a_item: G)
			-- Update a specific item in the store
		do
			is_ok := false
			last_updated_item.wipe_out
			do_update_item (a_item)
			if is_ok then
				last_count := 1
				last_updated_item.extend (a_item)
			else
				last_count := 0
			end
		end

	delete_item (an_item: G)
			-- Delete a specific item from the store
		do
			is_ok := false
			do_delete_item (an_item)
			last_count := 0
		end

feature -- Access

	last_saved_item: like last_list
			-- is_ok, will hold the last saved item
		deferred
		end

	last_updated_item: like last_list
			-- is_ok, will hold the last updated item
		deferred
		end

feature {NONE} -- Implementation

	do_save_item (an_item: G)
			-- Save a specific item in the store
		do
		end

	do_update_item (an_item: G)
			-- Update a specific item in the store
		do
		end

	do_delete_item (an_item: G)
			-- Delete a specific item from the store
		do
		end

feature -- Status report

	has (an_item: G): BOOLEAN
			-- True, when item exists in the store
		do
			Result := false
		end

end
