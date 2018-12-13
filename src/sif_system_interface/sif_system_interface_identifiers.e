note
	description: "Summary description for {SIF_SYSTEM_INTERFACE_IDENTIFIERS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_SYSTEM_INTERFACE_IDENTIFIERS

feature {NONE} -- Enumeration of all system identifiers.
	--
	-- A system interface identifier may not be 0 ever.
	--
	Sii_user_viewable_eiffel_vision: INTEGER = 1
	Sii_web_api_interface_based_on_Eiffel_Web_Framework: INTEGER = 2
	Sii_web_application_interface_based_on_Eiffel_Web_Framework_and_websocket: INTEGER = 3

;note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
