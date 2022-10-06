require( "common" )
require( "ID/WarBLH/WarBLHData" )
require( "ID/WarBLH/WarBLHEventRoutine" )
require( "ID/WarBLH/WarBLHInitFuntion" )
require( "ID/WarBLH/WarBLHDeInitFuntion" )
require( "ID/WarBLH/WarBLHEventMobRoutine" )


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    �����Լ�						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Main( Field )
cExecCheck( "Main" )

	local RoomEvent = InstanceField[Field]


	if RoomEvent == nil then

		InstanceField[Field] = { }


		RoomEvent				 	= InstanceField[Field]

		-- ���η�ƾ ����
		RoomEvent["MapIndex"]		= Field
		RoomEvent["MRE_State"]		= MRE_START


		-- �� �������
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
-- --					    ���η�ƾ						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function MainRoutine( RoomEvent )
cExecCheck( "MainRoutine" )

	if RoomEvent == nil then
		return
	end


	RoomEvent["CurrentTime"] = cCurrentSecond()


	-- �̺�Ʈ ��ƾ
	if RoomEvent["MRE_State"] == MRE_PLAY then

		local ReturnValue


		ReturnValue = EVENT_ROOM_ROUTINE[RoomEvent["Room"]["RoomNumber"]] ( RoomEvent )


		if ReturnValue == EVENT_ROUTINE_END then

			RoomEvent["MRE_State"] = MRE_END

		end


	-- �ʱ�ȭ / ������ ����
	elseif RoomEvent["MRE_State"] == MRE_START then

		RoomEvent["MRE_State"]	= MRE_PLAY
		EVENT_ROOM_INIT_FUNC[RoomEvent["Room"]["RoomNumber"]] ( RoomEvent )


	-- ����
	elseif RoomEvent["MRE_State"] == MRE_END then

		EVENT_ROOM_DEINIT_FUNC[RoomEvent["Room"]["RoomNumber"]] ( RoomEvent )

		RoomEvent["Room"]["RoomNumber"] 	= RoomEvent["Room"]["RoomNumber"] + 1

	end

end












