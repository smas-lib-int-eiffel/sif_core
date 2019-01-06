note
	description: "Summary description for {SIF_COMMAND_MEDIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_COMMAND_MEDIA

inherit

	SIF_COMMAND_GENERAL[SIF_DAO_FILE]
		rename
			caption_identifier as Iei_media_caption,
			Iei_resource_identification as Iei_media_name,
			Iei_resource_list as Iei_media_list,
			item_ies as media_ies
		redefine
			pre_execute
		end

create make

feature -- Initialization

	make
		do
			command_descriptors.put ("Media command", Ci_general_media)
			make_command(Ci_general_media)
		end

feature -- Execution

	pre_execute( si : SIF_SYSTEM_INTERFACE )
			-- <Precursor>
		local
			l_media_config: JSON_CONFIG_DAO [SIF_CONFIGURATION_MEDIA]
		do
			create l_media_config.make_from_file ("./config/config_media.json")
			l_media_config.load_for_component(void)
			if
				attached l_media_config.last_item as la_media_config and then
				attached {ALPHA_CFG_FILE} la_media_config.media_path as la_media_path and then
				not la_media_path.path.is_empty
			then
				data_access_object.put_root_path (la_media_path.path)
				data_access_object.put_file_name (interaction_element_string_value (Iei_media_name))
			end
			Precursor(si)
		end

	do_execute( si : SIF_SYSTEM_INTERFACE )
		do
			if data_access_object.is_ok then
				-- ToDo: Publish to the SIF_IE_FILE so system interface component is notified about the media file
			end
		end

feature -- Output

	media_ies (an_item: like data_access_object.last_item; is_filtered: BOOLEAN): SIF_INTERACTION_ELEMENT_SORTED_SET
			-- Result set for `a_brand' depending if it `is_alone' or not
		local
			l_ie_file: SIF_IE_FILE
		do
			create Result.make
			check attached descriptors.item (Iei_media) as la_descriptor and attached an_item as la_item_file then
				create l_ie_file.make(Iei_media, Result, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_result, la_descriptor)
				l_ie_file.put_file(la_item_file)
			end
		end

feature -- Interaction

	do_publish_caption( an_ie_caption: SIF_IE_EVENT)
		-- Identify this interactor by setting a caption, which can be used for presentation by the system interface
		do
			an_ie_caption.event_label.publish ("Media file presentor")
		end

feature {NONE} -- Interaction elements

	do_prepare_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		do
			create_interaction_elements
		end

	create_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		do
			create_mandatory_query_element(Iei_media_name)
			create_list_result_element (Iei_media_list)
		end

end

