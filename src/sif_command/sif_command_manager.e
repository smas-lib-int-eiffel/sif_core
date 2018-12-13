note
	description: "Summary description for {SIF_COMMAND_MANAGER}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_COMMAND_MANAGER

inherit

	SIF_SHARED_COMMAND_MANAGER

create {SIF_SHARED_COMMAND_MANAGER}

	make

feature -- Status

	has_unique_descriptor( a_command: SIF_COMMAND ): BOOLEAN
			-- True when a_command descriptor is already used for another command
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > internal_commands.count or Result
			loop
				if attached internal_commands.at (i) as l_command then
					Result := l_command.descriptor.is_equal(a_command.descriptor)
				end
				i := i + 1
			end
		end

feature -- Access

	command( a_command_identifier: like {SIF_COMMAND}.identifier ): detachable SIF_COMMAND
			-- Not void result means the result is referencing a commmand for the requested identifier
		do
			Result := internal_commands.at (a_command_identifier)
		end

	create_command( a_command_identifier: like {SIF_COMMAND}.identifier ): detachable SIF_COMMAND
			-- Creae a new instance of a_command_identifier, void when identifier does not exist
		do
			Result := internal_commands.at (a_command_identifier)
			if attached Result as l_interactor and then
			   attached {SIF_COMMAND} l_interactor.create_new_context as la_command then
				Result := la_command
			end
		end

	command_by_descriptor( a_command_descriptor: like {SIF_COMMAND}.descriptor ): detachable SIF_COMMAND
			-- Not void result means the result is referencing a commmand for the requested descriptor
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i > internal_commands.count - 1 or Result /= void
			loop
				if attached internal_commands.iteration_item (i) as l_command then
					if l_command.descriptor.is_equal(a_command_descriptor) then
						Result := l_command
					end
				end
				i := i + 1
			end
		end

	count_per_page: NATURAL
			-- Specifies the maximum count items per page for large collections

feature {SIF_PRODUCT} -- Implementation

	commands: like internal_commands
		do
			Result := internal_commands
		end

feature -- Element change

	extend( a_command: SIF_COMMAND )
			-- Extend a_command to the internally managed commands, but only, if
			-- a_command descriptor does not exist. Command descriptors need to
			-- be unique per command manager in a software system.
		require
			not_exists_command_descriptor: not has_unique_descriptor (a_command)
		do
			internal_commands.extend (a_command, a_command.identifier)
		end

feature {NONE} -- Implementation

	internal_commands: HASH_TABLE[SIF_COMMAND, INTEGER_64]
			-- All available commands in the software system

feature {NONE} -- Initialization

	make
		do
			create internal_commands.make(0)
			count_per_page := 20
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
