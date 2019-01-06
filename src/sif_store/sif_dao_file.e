note
	description: "Summary description for {SIF_DAO_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_DAO_FILE

inherit
	SIF_DAO [FILE]
		redefine
			do_load_by_identification
		end

	OPERATING_ENVIRONMENT

create
	make

feature -- Creation

	make
		do
			create {LINKED_LIST [FILE]} last_list.make
		end

feature -- Input

	do_load_by_criteria (a_criteria: CRITERIA [ANY])
			-- Load all items meeting `a_criteria'.
		do
		end

	do_load_by_identification (an_identification: STRING)
			-- Retrieve a data item indentified by identification
		do
			file_name := an_identification
			do_load_all
		end

	do_load_all
			-- Load all items.
			-- Make result available in `last_list'.
		require else
			file_name_available: attached file_name
		local
			l_media_file: RAW_FILE
			l_file_name_copy: STRING
			l_root_path_copy: STRING
			l_media_path: PATH
		do
			last_list.wipe_out
			if attached file_name as la_file_name then
				create l_file_name_copy.make_from_string (la_file_name)
				create l_root_path_copy.make_empty
				if attached root_path as la_root_path then
					l_root_path_copy.make_from_string (la_root_path + Directory_separator.out)
				end
				create l_media_path.make_from_string (l_root_path_copy + l_file_name_copy)
				create l_media_file.make_with_path (l_media_path)
				if l_media_file.exists and l_media_file.is_readable then
					last_list.extend (l_media_file)
					is_ok := true
				end
			end
			file_name := void
		end

feature -- Element change

	put_file_name(a_file_name: like file_name)
		require
			file_name_not_empty: attached a_file_name as la_file_name and then not la_file_name.is_empty
		do
			file_name := a_file_name
		end

	put_root_path(a_root_path: like root_path)
		require
			root_path_not_empty: attached a_root_path as la_root_path and then not la_root_path.is_empty
		do
			root_path := a_root_path
		end

feature -- Implementation

	file_name: detachable STRING

	root_path: detachable STRING

end
