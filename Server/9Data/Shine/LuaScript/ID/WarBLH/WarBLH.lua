require( "common" )
require( "ID/WarBLH/WarBLHData" )
require( "ID/WarBLH/WarBLHEventRoutine" )
require( "ID/WarBLH/WarBLHInitFuntion" )
require( "ID/WarBLH/WarBLHDeInitFuntion" )
require( "ID/WarBLH/WarBLHEventMobRoutine" )


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    메인함수						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Main( Field )
cExecCheck( "Main" )

	local RoomEvent = InstanceField[Field]


	if RoomEvent == nil then

		InstanceField[Field] = { }


		RoomEvent				 	= InstanceField[Field]

		-- 메인루틴 상태
		RoomEvent["MapIndex"]		= Field
		RoomEvent["MRE_State"]		= MRE_START


		-- 룸 진행상태
		RoomEvent["Room"]				= { }
		RoomEvent["Room"]["RoomNumber"]	= 1
		RoomEvent["Room"]["Data"]		= { }
		RoomEvent["DoorList"]			= { }
		RoomEvent["GateList"]			= { }
		RoomEvent["Room"]["RE_State"]	= RE_STATE_1
		RoomEvent["CurrentTime"]		= nil


		cSetFieldScript( RoomEvent["MapIndex"], SCRIPT_MAIN )
		DOOR_N_GATE_CREATE( RoomEvent )
		cFieldScriptFunc( RoomEvent["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end


	MainRoutine( RoomEvent )

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    메인루틴						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function MainRoutine( RoomEvent )
cExecCheck( "MainRoutine" )

	if RoomEvent == nil then
		return
	end


	RoomEvent["CurrentTime"] = cCurrentSecond()


	-- 이벤트 루틴
	if RoomEvent["MRE_State"] == MRE_PLAY then

		local ReturnValue


		ReturnValue = EVENT_ROOM_ROUTINE[RoomEvent["Room"]["RoomNumber"]] ( RoomEvent )


		if ReturnValue == EVENT_ROUTINE_END then

			RoomEvent["MRE_State"] = MRE_END

		end


	-- 초기화 / 데이터 셋팅
	elseif RoomEvent["MRE_State"] == MRE_START then

		RoomEvent["MRE_State"]	= MRE_PLAY
		EVENT_ROOM_INIT_FUNC[RoomEvent["Room"]["RoomNumber"]] ( RoomEvent )


	-- 종료
	elseif RoomEvent["MRE_State"] == MRE_END then

		EVENT_ROOM_DEINIT_FUNC[RoomEvent["Room"]["RoomNumber"]] ( RoomEvent )

		RoomEvent["Room"]["RoomNumber"] 	= RoomEvent["Room"]["RoomNumber"] + 1

	end

end












