note
	description: "Summary description for {SIF_COMMAND_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_COMMAND_CONTROL

inherit

	SIF_COMMAND_GENERAL
		rename
			caption_identifier as Iei_generic_control_caption
		end

create
	make

feature -- Initialization

	make
			-- Create a new "Control" command.
		do
			command_descriptors.put ("Control", Ci_general_control)
			make_command (Ci_general_control)
		end

feature -- Execution

	do_execute (si: SIF_SYSTEM_INTERFACE)
			-- <Precursor>
		local
			l_pid: INTEGER
		do
			(create {SHARED_LOG_FACILITY}).write_information ("Product was asked to stop!")
			l_pid := (create {BASE_PROCESS_FACTORY}).current_process_info.process_id;
			(create {EXECUTION_ENVIRONMENT}).system ("kill -9 " + l_pid.out)
		end

feature -- Interaction

	do_publish_caption (an_ie_caption: SIF_IE_EVENT)
			-- <Precursor>
		do
		end

feature {NONE} -- Interaction elements

	do_prepare_interaction_elements
			-- <Precursor>
		do
		end

end
