note
	description: "Summary description for {SIF_ENUMERATION_DATA_OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_ENUMERATION_DATA_OPERATION

inherit
	ANY
		redefine
			default_create
		end

feature -- Creation

	default_create
		do
			data_operation := undefined
		end

feature -- Types

	undefined: like data_operation = 0
			-- Indication of an undifined data operation

	create_: like data_operation = 1
			-- Create new data object instance

	read: like data_operation = 2
			-- Read existing data object(s) instance(s)

	update: like data_operation = 3
			-- Update existing data object instance

	delete: like data_operation = 4
			-- Delete existing data object instance

feature -- Contract support

	is_data_operation_valid (a_data_operation: like data_operation): BOOLEAN
			-- If `a_data_operation' valid?
		do
			inspect a_data_operation
			when undefined, create_, read, update, delete then
				Result := true
			else
			end
		end

feature -- Query

	data_operation_as_string( a_data_operation: like data_operation ): STRING
			-- Result is a string data_operation of a_data_operation.
		do
			create Result.make_empty
			inspect a_data_operation
			when undefined then
				create Result.make_from_string("Undefined")
			when create_ then
				create Result.make_from_string("Create")
			when read then
				create Result.make_from_string("Read")
			when update then
				create Result.make_from_string("Update")
			when delete then
				create Result.make_from_string("Delete")
			end
		end

	is_data_operation_type_mappable( a_data_operation: STRING ): BOOLEAN
			-- Is result data_operation type mappable to a known data operation?
		do
			a_data_operation.to_lower
			if a_data_operation.is_equal ("undefined") then
				Result := true
			end
			if a_data_operation.is_equal ("create") then
				Result := true
			end
			if a_data_operation.is_equal ("read") then
				Result := true
			end
			if a_data_operation.is_equal ("update") then
				Result := true
			end
			if a_data_operation.is_equal ("delete") then
				Result := true
			end
		end

	map_data_operation_type( a_data_operation: STRING ): like data_operation
			-- Map the data operation string, to a data operation type
		require
			content_is_mappable: is_data_operation_type_mappable( a_data_operation )
		do
			a_data_operation.to_lower
			if a_data_operation.is_equal ("undefined") then
				Result := undefined
			end
			if a_data_operation.is_equal ("create") then
				Result := create_
			end
			if a_data_operation.is_equal ("read") then
				Result := read
			end
			if a_data_operation.is_equal ("update") then
				Result := update
			end
			if a_data_operation.is_equal ("delete") then
				Result := delete
			end
		end

feature frozen -- Type information

	data_operation : INTEGER

feature -- Element change

	set_data_operation (a_data_operation: like data_operation)
			--
		require
			valid_data_operation: is_data_operation_valid (a_data_operation)
		do
			data_operation := a_data_operation
		ensure
			data_operation_set: data_operation = a_data_operation
		end

invariant

	correct_data_operation: is_data_operation_valid(data_operation)
			-- The data operation should always contain a valid specified value
end

