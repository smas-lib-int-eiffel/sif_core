note
	description: "Summary description for {SIF_PRODUCT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=software product root"
	legal: "See notice at end of class."

deferred class
	SIF_PRODUCT
	inherit
		SHARED_LOG_FACILITY

		SIF_SHARED_COMMAND_MANAGER

		EXECUTION_ENVIRONMENT
			rename
				launch as ee_launch
			end

feature -- Access

	is_initialized : BOOLEAN

	name: STRING
			-- Result is a derived name from the generating class name
		once
			create Result.make_from_string (Current.generator)
			Result.replace_substring_all ("SIF", "")
			Result.replace_substring_all ("PRODUCT", "")
			Result.replace_substring_all ("_", " ")
			Result.to_lower
		end

feature -- Logging

	use_logging: BOOLEAN
			-- True, means logging is used during execution of the application
		deferred
		end

	create_log_facility
			-- Do product specific initializations
		local
			l_log_facility_creator: LOG_FACILITY_CREATOR
		do
			print ("Using log facilities.%N")
			create l_log_facility_creator.make (true)
		end

feature {NONE} -- Manufacturing

	initialize
			-- Do product specific initializations
		do
			print ("Product :" + name +  " initializing....%N")
			initialize_product
		end

	initialize_product
		do
			print ("Going into manufacturing of the product.%N")

			manufacture

			is_initialized := True

			print ("Going to launch the product.%N")

			launch
		end

	manufacture
			-- Manufacture the specific product
		do
			manufacture_commands

			log_commands

			manufacture_input_validators

			manufacture_system_interfaces
		end

	launch
			-- Launch the product for publicity
		do
			-- Intended to be empty
		end

	manufacture_commands
		deferred
		end

	manufacture_input_validators
		-- Manufacture the input validators
		deferred
		end

	manufacture_system_interfaces
		deferred
		end

	is_authorisable: BOOLEAN
		deferred
		end

	log_commands
		local
			l_first: BOOLEAN
			l_command: SIF_COMMAND[SIF_DAO[ANY]]
		do
			from
				command_manager.commands.start
				l_first := True
			until
				command_manager.commands.off
			loop
				if l_first then
					write_information ("Added the following commands:")
					write_information ("%T" + "Identifier" + "%T" + "Descriptor" + "%T" + "Command class name" )
					l_first := false
				end
				l_command := command_manager.commands.item_for_iteration
				write_information ("%T" + l_command.identifier.out + "%T" + l_command.descriptor + "%T" + l_command.generator)
				command_manager.commands.forth
			end
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
