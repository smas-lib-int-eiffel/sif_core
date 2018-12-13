note
	description: "Notion of event type"
	documenatiton: "[
					Usage and architecture described in the book Touch Of Class - Learning to program well 
					'Chapter 18: event driven design,
					by Bertrand Meyer.
					
					This class is the base and core element of the event driven design.
					The class is derived from LINKED_LIST with generic parameter PROCEDURE [ ANY, EVENT_DATA ]. 
					This declaration makes heavy use of some powerfull Eiffel object oriented techniques, 
					being inheritance, genericity and the TUPLE type.
					Basically it means that to declare a class feature of type SIF_EVENT_TYPE which becomes an event, 
					needs an actual TUPLE type. This TUPLE type in fact declares the arguments of a PROCEDURE which 
					describes the signature of all complying class features which can be used to subscribe to this event, 
					by using feature subscribe. To trigger the event the publish feature of the event needs to be used, 
					with complying arguments as declared with the TUPLE type of the event. 
					While SIF_EVENT_TYPE is derived from LINKED_LIST it is able to store the subscriptions 
					(complying class features) in the linked list. Also when publishing it?s, using the list of subscribers 
					and call them to be executed, without having to know who they are.
					]"
	date: "$Date: 2003/01/31"
	revision: "$Revision: 1.0"
	author: "Volkan Arslan"
	institute: "Chair of Software Engineering, ETH Zurich, Switzerland"
	library: "System Interface Framework (SIF) - Core"
	EIS: "name=Design", "protocol=URI", "src=https://bitbucket.org/dev_smas/system-interface-framework/wiki/Design", "tag=event_type event driven"

class
	SIF_EVENT_TYPE [EVENT_DATA -> TUPLE]

inherit
	LINKED_LIST [PROCEDURE [ANY, EVENT_DATA]]
	redefine
		default_create
	end

create default_create, make

feature {NONE} -- Initialization

	default_create
		do
			make
			compare_objects
		end

feature -- Element change

	subscribe (an_action: PROCEDURE [ANY, EVENT_DATA])
			-- Add `an_action' to the subscription list.		
		require
			an_action_not_void: an_action /= Void
			an_action_not_already_subscribed: not has (an_action)
		do
			extend (an_action)
		ensure
			an_action_subscribed: count = old count + 1 and has (an_action)
			--index_at_same_position: index = old index
		end

	unsubscribe (an_action: PROCEDURE [ANY, EVENT_DATA])
			-- Remove `an_action' from the subscription list.
		require
			an_action_not_void: an_action /= Void
			an_action_already_subscribed: has (an_action)
		local
			pos: INTEGER
		do
			pos := index
			start
			search (an_action)
			remove
			go_i_th (pos)
		ensure
			an_action_unsubscribed: count = old count - 1 and not has (an_action)
			index_at_same_position: index = old index
		end

	unsubscribe_all
			-- Remove all actions from the subscruption list
		do
			Current.wipe_out
		end

feature -- Publication

	publish (arguments: EVENT_DATA)
			-- Publish all not suspended actions from the subscription list.
		require
			arguments_not_void: arguments /= Void
		do
			if not is_suspended then
				do_all (agent {PROCEDURE [ANY, EVENT_DATA]}.call (arguments))
			end
		end

feature -- Status report

	is_suspended: BOOLEAN
			-- Is the publication of all actions from the subscription list suspended?
			-- (Answer: no by default.)			

feature -- Status settings

	suspend_subscription
			-- Ignore the call of all actions from the subscription list,
			-- until feature restore_subscription is called.
		do
			is_suspended := True
		ensure
			subscription_suspended: is_suspended
		end

	restore_subscription
			-- Consider again the call of all actions from the subscription list,
			-- until feature suspend_subscription is called.
		do
			is_suspended := False
		ensure
			subscription_not_suspended: not is_suspended
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end -- class EVENT_TYPE
