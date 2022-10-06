require( "ID/WarH/WarHData" )

function GateCreate( EventMemory )
cExecCheck( "GateCreate" )

	if GATE_MAP_INDEX == nil then

		GATE_MAP_INDEX = { }

	end


	EventMemory["GateList"] = { }

	local Gate	= { }


	Gate["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], GATE_DATA["START_GATE"]["GATE_INDEX"],
											GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["DIR"] )


	if Gate["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Gate["Handle"] )
		cAIScriptFunc	( Gate["Handle"], "Entrance", "GateRoutine" )
		cAIScriptFunc	( Gate["Handle"], "NPCClick", "GateClick"   )

		Gate["LinkData"]				= GATE_DATA["START_GATE"]["LINK"]
		GATE_MAP_INDEX[Gate["Handle"]]  = EventMemory["MapIndex"]
		Gate["RegenPosition"]			= GATE_DATA["START_GATE"]["REGEN_POSITION"]

		EventMemory["GateList"][Gate["Handle"]] = Gate

	end

end


function DoorCreate( EventMemory )
cExecCheck( "DoorCreate" )

	EventMemory["EventData"]["DoorList"] = { }
	EventMemory["EventData"]["LockList"] = { }


	local DoorList 		= { }
	local DoorCount		= 1

	for index, value in pairs( DOOR_BLOCK_DATA ) do

		local Door 			= { }


		Door["Handle"] = cDoorBuild( EventMemory["MapIndex"], value["DOOR_INDEX"],
												value["REGEN_POSITION"]["X"], value["REGEN_POSITION"]["Y"], value["REGEN_POSITION"]["DIR"], 1000 )

		if Door["Handle"] ~= nil then

			Door["Index"]			= value["DOOR_BLOCK"]
			Door["X"]				= value["REGEN_POSITION"]["X"]
			Door["Y"]				= value["REGEN_POSITION"]["Y"]
			DoorList[DoorCount] 	= Door
			DoorCount 				= DoorCount + 1

			cDoorAction( Door["Handle"], Door["Index"], "close" )

		end

	end

	local LockList 		= { }
	local LockCount		= 1

	for i = 1, #DOOR_LOCK_DATA do

		local Lock = { }

		Lock["Handle"] = cDoorBuild( EventMemory["MapIndex"], DOOR_LOCK_DATA[i]["LOCK_INDEX"],
												DOOR_LOCK_DATA[i]["REGEN_POSITION"]["X"], DOOR_LOCK_DATA[i]["REGEN_POSITION"]["Y"], DOOR_LOCK_DATA[i]["REGEN_POSITION"]["DIR"], 1000 )

		if Lock["Handle"] ~= nil then

			Lock["Index"]		= DOOR_LOCK_DATA[i]["LOCK_INDEX"]
			LockList[LockCount] = Lock
			LockCount			= LockCount + 1

		end

	end

	EventMemory["EventData"]["DoorList"] = DoorList
	EventMemory["EventData"]["LockList"] = LockList

end


function MAPMARK( EventMemory )
cExecCheck( "MAPMARK" )

	if EventMemory == nil then

		return

	end


	local MapMarkTable	= { }
	local Num			= 0


	if EventMemory["EventData"]["DoorList"] ~= nil then

		for index, value in pairs( EventMemory["EventData"]["DoorList"] ) do

			local MapMark		= { }

			MapMark["Group"] 		= MAP_MARK_DATA["DOOR"]["GROUP"] + Num
			MapMark["x"]			= value["X"]
			MapMark["y"]			= value["Y"]
			MapMark["KeepTime"]		= MAP_MARK_DATA["DOOR"]["KEEPTIME"]
			MapMark["IconIndex"]	= MAP_MARK_DATA["DOOR"]["ICON"]

			MapMarkTable[MapMark["Group"]] = MapMark

			Num = Num + 1

		end

	end

	Num = 0

	for index, value in pairs( EventMemory["GateList"] ) do

		local MapMark	= { }


		MapMark["Group"] 		= MAP_MARK_DATA["LINKTOWN"]["GROUP"] + Num
		MapMark["x"]			= value["RegenPosition"]["X"]
		MapMark["y"]			= value["RegenPosition"]["Y"]
		MapMark["KeepTime"]		= MAP_MARK_DATA["LINKTOWN"]["KEEPTIME"]
		MapMark["IconIndex"]	= MAP_MARK_DATA["LINKTOWN"]["ICON"]

		Num = Num  + 1

	end

	cMapMark( EventMemory["MapIndex"], MapMarkTable )

end



function CameraMove( EventMemory )
cExecCheck( "CameraMove" )

	if EventMemory == nil then

		return

	end

	if EventMemory["CameraMove"] == nil then

		return

	end


	if EventMemory["CameraMove"]["Number"] > #CAMERAMOVE_DATA then

		return

	end


	local CameraData


	CameraData = CAMERAMOVE_DATA[EventMemory["CameraMove"]["Number"]]

	if EventMemory["CameraMove"]["CameraState"] == CAMERA_STATE["MOVE"] then


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], CameraData["AbstateIndex"], 1, CameraData["AbstateTime"] )

		end

		cCameraMove( EventMemory["MapIndex"], EventMemory["CameraMove"]["Focus"]["X"], EventMemory["CameraMove"]["Focus"]["Y"], EventMemory["CameraMove"]["Focus"]["DIR"],
											  CameraData["AngleY"], CameraData["Distance"], 1 )

		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + CameraData["KeepTime"]


		return

	elseif EventMemory["CameraMove"]["CameraState"] == CAMERA_STATE["REMOVE"] then

		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], CameraData["AbstateIndex"] )

		end

		EventMemory["CameraMove"]["CheckTime"] = nil
		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )
		EventMemory["CameraMove"]["Number"] = EventMemory["CameraMove"]["Number"] + 1

		return

	elseif EventMemory["CameraMove"]["CameraState"] == CAMERA_STATE["NEXT_STEP"] then

		EventMemory["CameraMove"]["Number"] = EventMemory["CameraMove"]["Number"] + 1

		return

	end

end


function FaceCut( EventMemory )
cExecCheck( "FaceCut" )

	if EventMemory == nil then

		return

	end

	if EventMemory["FaceCut"] == nil then

		return

	end

	if EventMemory["FaceCut"]["Number"] > #DIALOG_DATA then

		return

	end


	local FacecutData


	FacecutData = DIALOG_DATA[EventMemory["FaceCut"]["Number"]]

	if FacecutData == nil then

		return

	end


	if FacecutData["FACECUT"] == nil then

		cNotice( EventMemory["MapIndex"], FacecutData["FILENAME"], FacecutData["INDEX"] )

	elseif FacecutData["FACECUT"] ~= nil then

		cMobDialog( EventMemory["MapIndex"], FacecutData["FACECUT"], FacecutData["FILENAME"], FacecutData["INDEX"] )

	end

	EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + FacecutData["DELAY"]
	EventMemory["FaceCut"]["Number"]	= EventMemory["FaceCut"]["Number"] + 1

end


function TableLength( t )
cExecCheck "TableLength"

	local count = 0


	for index, value in pairs( t ) do

		count = count + 1

	end


	return count

end


function PlayerMapLogin( Field, Handle )
cExecCheck( "PlayerMapLogin" )

	local EventMemory = InstanceField[Field]

	if EventMemory == nil then

		return

	end


	local PlayerList = EventMemory["PlayerList"]

	if PlayerList == nil then

		return

	end

	if PlayerList[Handle] == nil then

		PlayerList[Handle] 	= { }

	end

	PlayerList[Handle]["CheckTime"] = BOMB_DATA["REGEN_TIME"]
	MAPMARK( EventMemory )

end


function RegenBomb( EventMemory )
cExecCheck( "RegenBomb" )

	if EventMemory == nil then

		return

	end


	local PlayerList = EventMemory["PlayerList"]

	if PlayerList == nil then

		return

	end


	-- 맵에 있는 모든 캐릭터 반복
	for index, value in pairs(PlayerList) do
--[[
		local MoveState, MoveStateTime


		MoveState, MoveStateTime 	= cGetMoveState( index )
--]]
		local MoveState, MoveStateTime, MoveStateSetTime = cGetMoveState( index )

		if MoveState == 0 and MoveStateTime >= value["CheckTime"] then

			if cIsInMap( index, EventMemory["MapIndex"] ) ~= nil then

				if cGetAreaObject( EventMemory["MapIndex"], "Area01", index ) ~= nil then

					local locX, locY	= cObjectLocate( index )
					local Bomb			= { }

					Bomb["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], BOMB_DATA["MOBINDEX"], locX, locY, 0 )

					if Bomb["Handle"] ~= nil then

						cSetAIScript	( SCRIPT_MAIN, Bomb["Handle"] )
						cAIScriptFunc	( Bomb["Handle"], "Entrance", "EVENT_BOMB_ROUTINE" )

						Bomb["MonsterState"]		= MS_STATE["NORMAL"]
						Bomb["CheckTime"] 			= EventMemory["CurrentTime"] + BOMB_DATA["DELAY_TIME"]

						EventMemory["EventData"]["BombList"][Bomb["Handle"]] = Bomb

						cSkillBlast( Bomb["Handle"], Bomb["Handle"], "WarH_FBomb_Skill01_W" )

					end

					value["CheckTime"] = value["CheckTime"] + BOMB_DATA["REGEN_TIME"] + BOMB_DATA["DELAY_TIME"]

				end

			else

				PlayerList[index] = nil

			end

		--elseif MoveState == 1 then
		elseif MoveState == 1 or MoveState == 2 or MoveState == 3 then

			value["CheckTime"] = BOMB_DATA["REGEN_TIME"]

		end

	end

end
