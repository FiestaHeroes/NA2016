require( "common" )
require( "ID/WarH/WarHData" )
require( "ID/WarH/WarHEventRoutine" )
require( "ID/WarH/WarHFunction" )
require( "ID/WarH/WarHInitFunction" )
require( "ID/WarH/WarHDeInitFunction" )
require( "ID/WarH/WarHEventMobRoutine" )


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

		EventMemory["MapIndex"]						= Field
		EventMemory["CurrentTime"]					= nil
		EventMemory["EventNumber"]					= 1
		EventMemory["EventData"] 					= { }
		EventMemory["CheckTime"]					= 1
		EventMemory["MonsterRegenTime"]				= 1

		EventMemory["EM_STATE"]						= EM_STATE["Start"]
		EventMemory["EventState"]					= ES_STATE["STATE_1"]

		EventMemory["CameraMove"]					= { }
		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["NORMAL"]
		EventMemory["CameraMove"]["CheckTime"]		= 0
		EventMemory["CameraMove"]["Number"]			= 1

		EventMemory["CameraMove"]["Focus"]			= { }
		EventMemory["CameraMove"]["Focus"]["X"] 	= 0
		EventMemory["CameraMove"]["Focus"]["Y"] 	= 0
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= 0

		EventMemory["FaceCut"]						= { }
		EventMemory["FaceCut"]["Number"]			= 1
		EventMemory["FaceCut"]["CheckTime"]			= 0

		EventMemory["PlayerList"]					= { }

		cSetFieldScript( Field, SCRIPT_MAIN )
		DoorCreate( EventMemory )
		GateCreate( EventMemory )

		cFieldScriptFunc( EventMemory["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end

	MainRoutine( EventMemory )

end


function MainRoutine( EventMemory )
cExecCheck( "Main" )

	if EventMemory == nil then

		return

	end

	EventMemory["CurrentTime"] = cCurrentSecond()

	if EventMemory["EM_STATE"] == EM_STATE["Play"] then

		local ReturnValue = EVENT_ROUTINE[EventMemory["EventNumber"]]( EventMemory )

		if ReturnValue == EVENT_ROUTINE_END then

			EventMemory["EM_STATE"] = EM_STATE["End"]

		end

		return

	elseif EventMemory["EM_STATE"] == EM_STATE["Start"] then

		EVENT_INIT_FUCTION[EventMemory["EventNumber"]]( EventMemory )

		EventMemory["EM_STATE"] = EM_STATE["Play"]

		return

	elseif EventMemory["EM_STATE"] == EM_STATE["End"] then

		EVENT_DEINIT_FUNCTION( EventMemory )

		return

	end

end
