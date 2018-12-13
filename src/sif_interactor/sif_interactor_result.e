note
	description: "Summary description for {SIF_INTERACTOR_RESULT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF) - Core"
	legal: "See notice at end of class."

class
	SIF_INTERACTOR_RESULT
	inherit
		ANY
		redefine
			default_create
		end

feature -- Initialization

	default_create
		do
			Precursor
			put_default
		end

feature -- Status

	passed: BOOLEAN
		do
			Result := code = 0
		end

	failed: BOOLEAN
		do
			Result := code = 1
		end

	excepted: BOOLEAN
		do
			Result := code = 2
		end

feature -- Element Change

	reset
		do
			put_default
		end

	put_passed
		do
			code := 0
		end

	put_failed
		do
			code := 1
		end

	put_exception
		do
			code := 2
		end


feature {NONE}-- Implementation

	code: INTEGER_64

	put_default
		do
			code := 0
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
