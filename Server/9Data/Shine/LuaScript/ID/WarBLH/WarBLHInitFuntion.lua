require( "ID/WarBLH/WarBLHData" )


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --				      던전 초기화						-- --
-- --														-- --
-- --				   ( 도어 / 게이트 )					-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --




GATE_MAP_INDEX = { }

function MAPMARK( RoomEvent )
cExecCheck( "MAPMARK" )

	if RoomEvent == nil then

		return

	end


	local MapMarkTable	= { }
	local Num			= 0


	if RoomEvent["DoorList"] ~= nil then

		for index, value in pairs( RoomEvent["DoorList"] ) do

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


	if RoomEvent["StartGate"] ~= nil then

		local MapMark		= { }

		MapMark["Group"] 		= MAP_MARK_DATA["LINKTOWN"]["GROUP"]
		MapMark["x"]			= GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"]
		MapMark["y"]			= GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"]
		MapMark["KeepTime"]		= MAP_MARK_DATA["LINKTOWN"]["KEEPTIME"]
		MapMark["IconIndex"]	= MAP_MARK_DATA["LINKTOWN"]["ICON"]

		MapMarkTable[MapMark["Group"]] = MapMark

	end


	if RoomEvent["MiddleGate"] ~= nil then

		local MapMark		= { }

		MapMark["Group"] 		= MAP_MARK_DATA["LINKTOWN"]["GROUP"] + 1
		MapMark["x"]			= GATE_DATA["MIDDLE_GATE"]["REGEN_POSITION"]["X"]
		MapMark["y"]			= GATE_DATA["MIDDLE_GATE"]["REGEN_POSITION"]["Y"]
		MapMark["KeepTime"]		= MAP_MARK_DATA["LINKTOWN"]["KEEPTIME"]
		MapMark["IconIndex"]	= MAP_MARK_DATA["LINKTOWN"]["ICON"]

		MapMarkTable[MapMark["Group"]] = MapMark

	end


	if RoomEvent["EndGate"] ~= nil then

		local MapMark		= { }

		MapMark["Group"] 		= MAP_MARK_DATA["LINKTOWN"]["GROUP"] + 2
		MapMark["x"]			= GATE_DATA["END_GATE"]["REGEN_POSITION"]["X"]
		MapMark["y"]			= GATE_DATA["END_GATE"]["REGEN_POSITION"]["Y"]
		MapMark["KeepTime"]		= MAP_MARK_DATA["LINKTOWN"]["KEEPTIME"]
		MapMark["IconIndex"]	= MAP_MARK_DATA["LINKTOWN"]["ICON"]

		MapMarkTable[MapMark["Group"]] = MapMark

	end

	cMapMark( RoomEvent["MapIndex"], MapMarkTable )

end


function PlayerMapLogin( Field, Player )

	local RoomEvent = InstanceField[Field]

	if RoomEvent == nil then

		return

	end

	MAPMARK( RoomEvent )

end




function DOOR_N_GATE_CREATE( RoomEvent )
cExecCheck( "DOOR_N_GATE_CREATE" )

	RoomEvent["DoorList"] 	= { }
	RoomEvent["StartGate"] 	= { }


	local Gate		= { }
	local i 		= 1


	local Num = 0
	for index, value in pairs( DOOR_BLOCK_DATA ) do

		local DOOR 		= { }

		DOOR["Handle"] = cDoorBuild( RoomEvent["MapIndex"], value["DOOR_INDEX"],
												value["REGEN_POSITION"]["X"], value["REGEN_POSITION"]["Y"], value["REGEN_POSITION"]["DIR"], 1000 )

		DOOR["Index"]	= value["DOOR_BLOCK"]
		DOOR["X"]		= value["REGEN_POSITION"]["X"]
		DOOR["Y"]		= value["REGEN_POSITION"]["Y"]

		cDoorAction( DOOR["Handle"], DOOR["Index"], "close" )

		RoomEvent["DoorList"][i] = DOOR
		i = i + 1

	end




	Gate["Handle"] = cMobRegen_XY( RoomEvent["MapIndex"], GATE_DATA["START_GATE"]["GATE_INDEX"],
											GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["DIR"] )


	if Gate["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Gate["Handle"] )
		cAIScriptFunc	( Gate["Handle"], "Entrance", "GateRoutine" )
		cAIScriptFunc	( Gate["Handle"], "NPCClick", "GateClick"   )

		Gate["X"] = GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"]
		Gate["Y"] = GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"]

		GATE_MAP_INDEX[Gate["Handle"]] = RoomEvent["MapIndex"]

	end

	RoomEvent["StartGate"][Gate["Handle"]] = Gate

end

function GateRoutine( Handle, MapIndex )
cExecCheck( "GateRoutine" )

	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if RoomEvent["StartGate"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if RoomEvent["StartGate"][Handle] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		RoomEvent["StartGate"] = nil
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["END"]

end


function GateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "GateClick" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end

	if InstanceField[MapIndex] == nil then
		return
	end


	cServerMenu( PlyHandle, NPCHandle, 	GATE_TITLE["Start"]["Title"],
										GATE_TITLE["Start"]["Yes"], "LinkToStart",
										GATE_TITLE["Start"]["No"],  "GateDummy")

end


function LinkToStart( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToStart" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end


	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent == nil then

		return

	end

	if RoomEvent["StartGate"] == nil then

		return

	end

	cLinkTo( PlyHandle, GATE_DATA["START_GATE"]["LINK"]["FIELD"], GATE_DATA["START_GATE"]["LINK"]["X"], GATE_DATA["START_GATE"]["LINK"]["Y"] )

end


function GateDummy( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "GateDummy" )


end


function MiddleGateRoutine( Handle, MapIndex )
cExecCheck( "MiddleGateRoutine" )

	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if RoomEvent["MiddleGate"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["END"]

end


function MiddleGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "MiddleGateClick" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end


	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent == nil then

		return

	end


	if RoomEvent["MiddleGate"] == nil then

		return

	end



	cServerMenu( PlyHandle, NPCHandle, 	GATE_TITLE["Middle"]["Title"],
										GATE_TITLE["Middle"]["Yes"], "LinkToMiddle",
										GATE_TITLE["Middle"]["No"],  "GateDummy")

end


function LinkToMiddle( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToStart" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end


	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent == nil then

		return

	end


	if RoomEvent["MiddleGate"] == nil then

		return

	end



	local RegenLocNum



	RegenLocNum = RoomEvent["MiddleGate"]["RegenLocNum"]

	cLinkTo( PlyHandle, MapIndex, GATE_DATA["MIDDLE_GATE"]["LINK"][RegenLocNum]["X"], GATE_DATA["MIDDLE_GATE"]["LINK"][RegenLocNum]["Y"] )

end




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 1							-- --
-- --														-- --
-- --					  ( 초기화 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_ONE_INIT( RoomEvent )
cExecCheck( "EVENT_ROOM_ONE_INIT" )

	local Event_Foras_Data 		= { }
	local Event_Foras_List		= { }
	local Event_Foras_Position	= { }



	Event_Foras_List["List"]	= { }
	Event_Foras_Data			= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["ENVENT_FORAS"]
	Event_Foras_Position		= Event_Foras_Data["FORAS_POSITION"]


	for i = 1, #Event_Foras_Position do


		local Event_Foras			= { }


		Event_Foras["Handle"]		= cMobRegen_XY( RoomEvent["MapIndex"], Event_Foras_Data["MOB_INDEX"],
												Event_Foras_Position[i]["REGEN_POS"]["X"], Event_Foras_Position[i]["REGEN_POS"]["Y"], Event_Foras_Position[i]["REGEN_POS"]["DIR"] )

		if Event_Foras["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Event_Foras["Handle"] )
			cAIScriptFunc	( Event_Foras["Handle"], "Entrance", "ROOM_ONE_FORAS_ROUTINE" )
			cAnimate		( Event_Foras["Handle"], "start", Event_Foras_Data["ANIMATION"] )
			cSetAbstate		( Event_Foras["Handle"], STA_IMMORTAL, 1, 20000000 )

			Event_Foras["Path"] 			= Event_Foras_Position[i]["PATH"]
			Event_Foras["PathNumber"]		= 1
			Event_Foras["SearchRange"] 		= Event_Foras_Data["SEARCH_RANGE"]
			Event_Foras["DelayTime"]		= Event_Foras_Data["DELAY_TIME"]
			Event_Foras["CheckTime"]		= RoomEvent["CurrentTime"]
			Event_Foras["ChatCheckTime"]	= RoomEvent["CurrentTime"]
			Event_Foras["MobChatData"]		= Event_Foras_Data["MOB_CHAT"]
			Event_Foras["IsSurprise"]		= 0

		end

		Event_Foras_List["List"][Event_Foras["Handle"]] = Event_Foras
		Event_Foras_List["List"]["FindPlayer"]			= nil
	end


	Event_Foras_List["CheckTime"]			= nil
	Event_Foras_List["FL_State"]			= FL_SEARCH
	RoomEvent["Room"]["Data"]["ForasList"] 	= Event_Foras_List



	local Event_Davildom_Data 	= { }
	local Event_Davildom		= { }


	Event_Davildom_Data 				= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["EVNET_DAVILDOM"]


	Event_Davildom["List"]				= { }
	Event_Davildom["SearchRange"]		= Event_Davildom_Data["SEARCH_RANGE"]
	Event_Davildom["RegenCount"]		= 1
	Event_Davildom["RegenCheckTime"]	= RoomEvent["CurrentTime"]

	RoomEvent["Room"]["Data"]["Davildom"] 			= Event_Davildom
	RoomEvent["Room"]["Data"]["NoticeCheckTime"]	= RoomEvent["CurrentTime"]

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 2							-- --
-- --														-- --
-- --					  ( 초기화 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function EVENT_ROOM_TWO_INIT( RoomEvent )
cExecCheck( "EVENT_ROOM_TWO_INIT" )

	local Icitrie_Data	= { }
	local Icitrie 		= { }


	Icitrie_Data 		= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["ROOM_CITRIE"]

	Icitrie["Handle"] 	= cMobRegen_XY( RoomEvent["MapIndex"], Icitrie_Data["MOB_INDEX"],
												Icitrie_Data["START_POSITION"]["X"], Icitrie_Data["START_POSITION"]["Y"], Icitrie_Data["START_POSITION"]["DIR"] )


	if Icitrie["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Icitrie["Handle"] )
		cAIScriptFunc	( Icitrie["Handle"], "Entrance", "ROOM_TWO_CITRIE_ROUTINE" )

		RoomEvent["Room"]["Data"]["Citrie"] = Icitrie

	end

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 3							-- --
-- --														-- --
-- --					  ( 초기화 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_THREE_INIT( RoomEvent )
cExecCheck( "EVENT_ROOM_THREE_INIT" )

	local EventForasData 		= { }
	local ForasGroupList		= { }
	local ForasList				= { }


	EventForasData 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["EVENT_FORAS"]

	for i = 1, #EventForasData["Group"] do

		local ForasGroup			= { }
		local ForasGroupListState	= { }

		for j = 1, #EventForasData["Group"][i] do

			local Foras			= { }


			Foras["Handle"] =  cMobRegen_XY( RoomEvent["MapIndex"], EventForasData["MOB_INDEX"],
												EventForasData["Group"][i][j]["REGEN_POS"]["X"],
												EventForasData["Group"][i][j]["REGEN_POS"]["Y"],
												EventForasData["Group"][i][j]["REGEN_POS"]["DIR"] )


			if Foras["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, Foras["Handle"] )
				cAIScriptFunc	( Foras["Handle"], "Entrance", "ROOM_THREE_FORAS_ROUTINE" )
				cAnimate		( Foras["Handle"], "start", EventForasData["ANIMATION"] )
				cSetAbstate		( Foras["Handle"], STA_IMMORTAL, 1, 20000000 )

				Foras["Path"]					= EventForasData["PATH"]
				Foras["PathNumber"] 			= 1
				Foras["CheckTime"]				= RoomEvent["CurrentTime"] + 1
				Foras["MobChat"]				= EventForasData["MOB_CHAT"]
				ForasGroup[Foras["Handle"]] 	= Foras

				ForasList[Foras["Handle"]] = i

			end

		end


		ForasGroupListState["List"] 	= ForasGroup
		ForasGroupListState["FG_State"]	= FG_WORKING
		ForasGroupList[i]				= ForasGroupListState

	end

	RoomEvent["Room"]["Data"]["ForasList"] 		= ForasList
	RoomEvent["Room"]["Data"]["ForasGroupList"]	= ForasGroupList
	RoomEvent["Room"]["Data"]["EscapeStateNum"]	= 0


	local EventDavildomData			= { }
	local DavildomGroupList			= { }
	local DavildomList				= { }


	EventDavildomData	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["EVENT_DAVILDOM"]

	for i = 1, #EventDavildomData["Group"] do

		local DavildomGroup				= { }
		local DavildomGroupListState	= { }


		for j = 1, #EventDavildomData["Group"][i] do

			local Davildom				= { }


			Davildom["Handle"] =  cMobRegen_XY( RoomEvent["MapIndex"], EventDavildomData["MOB_INDEX"],
												EventDavildomData["Group"][i][j]["REGEN_POS"]["X"],
												EventDavildomData["Group"][i][j]["REGEN_POS"]["Y"],
												EventDavildomData["Group"][i][j]["REGEN_POS"]["DIR"] )

			if Davildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
				cAIScriptFunc	( Davildom["Handle"], "Entrance", "ROOM_THREE_DAVILDOM_ROUTINE" )
				Davildom["D_State"] 		= D_NORMAL
				Davildom["AggroPoint"]		= EventDavildomData["AGGRO_POINT"]
				Davildom["SearchRange"]		= EventDavildomData["SEARCH_RANGE"]
				Davildom["CheckTime"]		= RoomEvent["CurrentTime"] + 1

				if EventDavildomData["Group"][i][j]["ANIMATION"] == 1 then

					cAnimate	( Davildom["Handle"], "start", EventDavildomData["ANIMATION"] )

				end

				DavildomGroup[Davildom["Handle"]] 	 = Davildom
				DavildomList[Davildom["Handle"]] 	 = i

			end

		end

		DavildomGroupListState["List"]		= DavildomGroup
		DavildomGroupListState["DG_State"]	= DG_NORMAL
		DavildomGroupList[i]				= DavildomGroupListState

	end

	RoomEvent["Room"]["Data"]["DavildomList"] 		= DavildomList
	RoomEvent["Room"]["Data"]["DavildomGroupList"]	= DavildomGroupList

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 4							-- --
-- --														-- --
-- --					  ( 초기화 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_FOUR_INIT( RoomEvent )
cExecCheck( "EVENT_ROOM_FOUR_INIT" )

	local ForasChiefData 		= { }
	local ForasChief			= { }
	local DavildomData			= { }
	local DavildomList			= { }


	ForasChiefData 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]
	DavildomData	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["EVENT_DAVILDOM"]



	ForasChief["Handle"] = cMobRegen_XY( RoomEvent["MapIndex"], ForasChiefData["MOB_INDEX"],
															ForasChiefData["REGEN_POSITION"]["X"],
															ForasChiefData["REGEN_POSITION"]["Y"],
															ForasChiefData["REGEN_POSITION"]["DIR"] )

	if ForasChief["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
		cAIScriptFunc	( ForasChief["Handle"], "Entrance", "ROOM_FOUR_FORAS_CHIEF_ROUTINE" )
		cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 60000000 )
		cAnimate		( ForasChief["Handle"], "start", ForasChiefData["ANIMATION"]["DAMAGE"] )

		ForasChief["FC_State"] 		= FC_DAMAGE
		ForasChief["CheckTime"]		= RoomEvent["CurrentTime"] + 1
		ForasChief["HealCheckTime"]	= RoomEvent["CurrentTime"] + 5


		ForasChief["MasterPlayer"]	= nil
		ForasChief["FollowData"]	= ForasChiefData["FOLLOW_DATA"]
		ForasChief["MaskItem"]		= ForasChiefData["MASKITEM"]
		ForasChief["EndPosition"]	= ForasChiefData["END_POSITION"]
		ForasChief["MobChatData"]	= ForasChiefData["MOB_CHAT"]

	end

	RoomEvent["Room"]["Data"]["ForasChief"] = ForasChief



	for i = 1, #DavildomData["DAVILDOM_POSITION"] do

		local Davildom				= { }

		Davildom["Handle"] = cMobRegen_XY( RoomEvent["MapIndex"], DavildomData["MOB_INDEX"],
															DavildomData["DAVILDOM_POSITION"][i]["X"],
															DavildomData["DAVILDOM_POSITION"][i]["Y"],
															DavildomData["DAVILDOM_POSITION"][i]["DIR"] )

		if Davildom["Handle"] ~= nil then

			local RandTime


			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "ROOM_FOUR_DEVILDOM_ROUTINE" )
			--cAnimate		( Davildom["Handle"], "start", DavildomData["ANIMATION"] )

			RandTime = cRandomInt(0, 2)

			Davildom["AnimateStartTime"]	= RoomEvent["CurrentTime"] + RandTime
			Davildom["D_State"] 			= D_AnimateStart
			Davildom["CheckTime"]			= RoomEvent["CurrentTime"] + 1


			DavildomList[Davildom["Handle"]] = Davildom

		end

	end

	RoomEvent["Room"]["Data"]["DavildomList"] = DavildomList

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 5							-- --
-- --														-- --
-- --					  ( 초기화 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_FIVE_INIT( RoomEvent )
cExecCheck( "EVENT_ROOM_FIVE_INIT" )

	local CitrieData	= { }
	local Citrie 		= { }


	CitrieData 		= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["SCITRIE"]


	Citrie["Handle"] = cMobRegen_XY( RoomEvent["MapIndex"], CitrieData["MOB_INDEX"],
															CitrieData["REGEN_POSITION"]["X"],
															CitrieData["REGEN_POSITION"]["Y"],
															CitrieData["REGEN_POSITION"]["DIR"] )


	if Citrie["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Citrie["Handle"] )
		cAIScriptFunc	( Citrie["Handle"], "Entrance", "ROOM_FIVE_SCITRIE_ROUTINE" )

		Citrie["C_State"]	= C_HP_90_UNDER
		Citrie["AI"]		= CitrieData["AI_DATA"]
		Citrie["SUMMON"]	= CitrieData["SUMMON"]

	end

	RoomEvent["Room"]["Data"]["Citrie"] 		= Citrie
	RoomEvent["Room"]["Data"]["RegenDavildom"]	= { }

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    ENDING							-- --
-- --														-- --
-- --					  ( 초기화 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_ENDING_INIT( RoomEvent )
cExecCheck( "EVENT_ROOM_ENDING_INIT" )

	local EndingData


	EndingData = EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["KQReturn"]
	RoomEvent["Room"]["Data"]["EndingData"] 		= EndingData
	RoomEvent["Room"]["Data"]["EndingCheckTime"]	= RoomEvent["CurrentTime"]

end



EVENT_ROOM_INIT_FUNC = { }


EVENT_ROOM_INIT_FUNC[1] = EVENT_ROOM_ONE_INIT
EVENT_ROOM_INIT_FUNC[2] = EVENT_ROOM_TWO_INIT
EVENT_ROOM_INIT_FUNC[3] = EVENT_ROOM_THREE_INIT
EVENT_ROOM_INIT_FUNC[4] = EVENT_ROOM_FOUR_INIT
EVENT_ROOM_INIT_FUNC[5] = EVENT_ROOM_FIVE_INIT
EVENT_ROOM_INIT_FUNC[6] = EVENT_ROOM_ENDING_INIT

