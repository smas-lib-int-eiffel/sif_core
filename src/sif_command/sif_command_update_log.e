note
	description: "[
			Summary description for {SIF_COMMAND_UPDATE_LOG}.
			#define	LOG_EMERG	0	/* system is unusable */
			#define	LOG_ALERT	1	/* action must be taken immediately */
			#define	LOG_CRIT	2	/* critical conditions */
			#define	LOG_ERR		3	/* error conditions */
			#define	LOG_WARNING	4	/* warning conditions */
			#define	LOG_NOTICE	5	/* normal but significant condition */
			#define	LOG_INFO	6	/* informational */
			#define	LOG_DEBUG	7	/* debug-level messages */
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_COMMAND_UPDATE_LOG
	inherit
		SIF_COMMAND_GENERAL
			rename
				caption_identifier as Iei_generic_log_facility_caption
			end

create
	make

feature -- Initialization

	make
			-- Create a new "Update Log Facility" command.
		do
			descriptors.put("log_priority", Iei_generic_log_facility_priority)
			descriptors.put ("log_facilities", Iei_generic_log_facility_list)

			command_descriptors.put("Update log facility", Ci_general_update_log_facility)

			make_command (Ci_general_update_log_facility)
		end

feature -- Execution

	do_execute (si: SIF_SYSTEM_INTERFACE)
			-- <Precursor>
		do
			if facility.is_priority_mappable (ie_log_facility_priority.text) then
				facility.change_all_log_priority_from_string (ie_log_facility_priority.text)
				check attached result_interaction_elements as la_result_interaction_elements then
					update_result
				end
			else
				execution_result.put_failed
			end
		end

feature -- Output

	update_result
			-- Update result set with data from the log facility.
		do
			if attached result_list (Iei_generic_log_facility_list) as l_ie_list_log_facilities then
				l_ie_list_log_facilities.elements.force (log_facility_ies)
				disable_counts
			end
		end

feature {NONE} -- Results

	log_facility_ies : SIF_INTERACTION_ELEMENT_SORTED_SET
			-- Result set for a log facility
		do
			create Result.make
			set_result_text (Iei_generic_log_facility_priority, Result, facility.priority_out)
		end

feature -- Interaction

	do_publish_caption (an_ie_caption: SIF_IE_EVENT)
			-- <Precursor>
		do
			an_ie_caption.event_label.publish (descriptor)
		end

feature {NONE} -- Interaction elements

	do_prepare_interaction_elements
			-- <Precursor>
		do
			create_interaction_elements
		end

	create_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		do
			ie_log_facility_priority := new_ie_text (Iei_generic_log_facility_priority, interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_mandatory)
			create_list_result_element(Iei_generic_log_facility_list)
		end

	ie_log_facility_priority: SIF_IE_TEXT

end
