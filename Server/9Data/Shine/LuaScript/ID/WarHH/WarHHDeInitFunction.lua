require( "ID/WarHH/WarHHData" )


function EVENT_DEINIT_FUNCTION( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_1" )

	EventMemory["EM_STATE"] 	= EM_STATE["Start"]
	EventMemory["EventNumber"] 	= EventMemory["EventNumber"] + 1
	EventMemory["EventState"] 	= ES_STATE["STATE_1"]

end
