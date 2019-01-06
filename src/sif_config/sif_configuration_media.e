note
	description: "Summary description for {SIF_CONFIGURATION_MEDIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_CONFIGURATION_MEDIA

inherit
	ALPHA_CONFIGURATION
		redefine
			default_create
		end

feature -- Initialization

	default_create
			--
		do
			Precursor
			create media_path
		end

feature -- Access

	media_path: ALPHA_CFG_FILE
			-- Path to where the media should reside on the host/server

end
