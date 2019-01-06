note
	description: "[
			Summary description for {SIF_COMMAND_LOG_FACILITY_EXTENDED}.
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
	SIF_COMMAND_LOG_FACILITY_EXTENDED

inherit

	SIF_COMMAND_GENERAL[SIF_DAO_LOG_FACILITY_EXTENDED]
		rename
			caption_identifier as Iei_generic_log_facility_caption,
			Iei_resource_identification as Iei_generic_log_facility_identification,
			Iei_resource_list as Iei_generic_log_facility_list,
			item_ies as log_facility_ies
		redefine
			pre_execute,
			update_item
		end

create
	make

feature -- Initialization

	make
			-- Create a new "Update Log Facility" command.
		do
			command_descriptors.put("Log facility", Ci_general_log_facility)

			make_command (Ci_general_log_facility)
		end

feature -- Execution

	pre_execute( si : SIF_SYSTEM_INTERFACE )
			-- <Precursor>
		do
			Precursor(si)
		end

	do_execute (si: SIF_SYSTEM_INTERFACE)
			-- <Precursor>
		do
			ie_log_facility_priority.event_output.publish (ie_log_facility_priority.text)
		end

feature -- Data Access Object - DAO

	update_item
			-- Map interaction elements into an instance of an object which can be updated by the data access object from an existing item
		do
			data_access_object.load_all
			if data_access_object.is_ok and then
			   data_access_object.last_count = 1 then
				if attached data_access_object.last_item as la_last_item then
					la_last_item.change_all_log_priority_from_string (ie_log_facility_priority.text)
					data_access_object.update_item (la_last_item)
				end
			end
		end

feature -- Output

	log_facility_ies (an_item: like data_access_object.last_item; is_filtered: BOOLEAN): SIF_INTERACTION_ELEMENT_SORTED_SET
			-- Result set for `a_brand'
		local
			l_ie_file: SIF_IE_FILE
		do
			create Result.make
			check attached an_item as la_log_facility then
				set_result_text (Iei_generic_log_facility_priority, Result, la_log_facility.priority_out)
			end
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
