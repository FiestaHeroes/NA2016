require( "common" )
require( "ID/WarLH/WarLHData" )
require( "ID/WarLH/WarLHEventRoutine" )
require( "ID/WarLH/WarLHInitFuntion" )
require( "ID/WarLH/WarLHDeInitFuntion" )
require( "ID/WarLH/WarLHEventMobRoutine" )


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    메인함수						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Main( Field )
cExecCheck( "Main" )

	local EventMemory = InstanceField[Field]


	if EventMemory == nil then

		InstanceField[Field] = { }


		EventMemory	= InstanceField[Field]

		EventMemory["MapIndex"]		= Field
		EventMemory["CurrentTime"]	= nil
		EventMemory["EventNumber"]	= 1
		EventMemory["EM_STATE"]		= EM_STATE["Start"]

		EventMemory[EventMemory["EventNumber"]]					= { }
		EventMemory[EventMemory["EventNumber"]]["EventData"]	= { }
		EventMemory[EventMemory["EventNumber"]]["EventState"]	= ES_STATE["State1"]

		EventMemory["ObjectState"] 				= { }
		EventMemory["ObjectState"]["L_Line"] 	= 1
		EventMemory["ObjectState"]["R_Line"] 	= 1

		EventMemory["CurrentTime"]			= nil

		cSetFieldScript( EventMemory["MapIndex"], SCRIPT_MAIN )
		DOOR_N_GATE_CREATE( EventMemory )
		cFieldScriptFunc( EventMemory["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end

	MainRoutine( EventMemory )

end


function MainRoutine( EventMemory )

	if EventMemory == nil then

		return

	end

	EventMemory["CurrentTime"] = cCurrentSecond()

	if EventMemory["EM_STATE"] == EM_STATE["Start"] then

		EventMemory["EM_STATE"]	= EM_STATE["Play"]
		EVENT_INIT_FUNC[EventMemory["EventNumber"]] ( EventMemory )

	elseif EventMemory["EM_STATE"] == EM_STATE["Play"] then

		local ReturnValue = EVENT_ROUTINE[EventMemory["EventNumber"]] ( EventMemory )

		if ReturnValue == EVENT_ROUTINE_END then

			EventMemory["EM_STATE"] = EM_STATE["End"]

		end

	elseif EventMemory["EM_STATE"] == EM_STATE["End"] then

		EVENT_DEINIT_FUNC[EventMemory["EventNumber"]] ( EventMemory )
		EventMemory["EventNumber"] = EventMemory["EventNumber"] + 1

	end

end

