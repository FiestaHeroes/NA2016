require( "ID/WarLH/WarLHData" )

GATE_MAP_INDEX = { }

function MAPMARK( EventMemory )
cExecCheck( "MAPMARK" )

	if EventMemory == nil then

		return

	end


	local MapMarkTable	= { }
	local Num			= 0


	if EventMemory["DoorList"] ~= nil then

		for index, value in pairs( EventMemory["DoorList"] ) do

			if value["X"] ~= 0 and value["Y"] ~= 0
			then

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

	end

	if EventMemory["StartGate"] ~= nil then

		local MapMark		= { }

		MapMark["Group"] 		= MAP_MARK_DATA["LINKTOWN"]["GROUP"]
		MapMark["x"]			= GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"]
		MapMark["y"]			= GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"]
		MapMark["KeepTime"]		= MAP_MARK_DATA["LINKTOWN"]["KEEPTIME"]
		MapMark["IconIndex"]	= MAP_MARK_DATA["LINKTOWN"]["ICON"]

		MapMarkTable[MapMark["Group"]] = MapMark

	end

	if EventMemory["EndGate"] ~= nil then

		local MapMark		= { }

		MapMark["Group"] 		= MAP_MARK_DATA["LINKTOWN"]["GROUP"] + 2
		MapMark["x"]			= GATE_DATA["END_GATE"]["REGEN_POSITION"]["X"]
		MapMark["y"]			= GATE_DATA["END_GATE"]["REGEN_POSITION"]["Y"]
		MapMark["KeepTime"]		= MAP_MARK_DATA["LINKTOWN"]["KEEPTIME"]
		MapMark["IconIndex"]	= MAP_MARK_DATA["LINKTOWN"]["ICON"]

		MapMarkTable[MapMark["Group"]] = MapMark

	end

	cMapMark( EventMemory["MapIndex"], MapMarkTable )

end


function PlayerMapLogin( Field, Player )

	local EventMemory = InstanceField[Field]

	if EventMemory == nil then

		return

	end

	cMapObjectControl( EventMemory["MapIndex"], "L_Line", EventMemory["ObjectState"]["L_Line"], 1 )
	cMapObjectControl( EventMemory["MapIndex"], "R_Line", EventMemory["ObjectState"]["R_Line"], 1 )

	MAPMARK( EventMemory )

end



function DOOR_N_GATE_CREATE( EventMemory )
cExecCheck( "DOOR_N_GATE_CREATE" )

	EventMemory["StartGate"] = { }

	local DoorList 			= { }
	local DoorCount			= 1
	local Gate				= { }

	for index, value in pairs( DOOR_BLOCK_DATA ) do

		local Door 			= { }


		Door["Handle"] = cDoorBuild( EventMemory["MapIndex"], value["DOOR_INDEX"],
												value["REGEN_POSITION"]["X"], value["REGEN_POSITION"]["Y"], value["REGEN_POSITION"]["DIR"], 1000 )

		if Door["Handle"] ~= nil then

			Door["Index"]	= value["DOOR_BLOCK"]
			Door["X"]		= value["REGEN_POSITION"]["X"]
			Door["Y"]		= value["REGEN_POSITION"]["Y"]
			DoorList[DoorCount] = Door
			DoorCount 			= DoorCount + 1
			cDoorAction( Door["Handle"], Door["Index"], "close" )

		end

	end


	Gate["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], GATE_DATA["START_GATE"]["GATE_INDEX"],
											GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["DIR"] )


	if Gate["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Gate["Handle"] )
		cAIScriptFunc	( Gate["Handle"], "Entrance", "GateRoutine" )
		cAIScriptFunc	( Gate["Handle"], "NPCClick", "GateClick"   )
		GATE_MAP_INDEX[Gate["Handle"]] = EventMemory["MapIndex"]

	end

	EventMemory["StartGate"]		 	= Gate
	EventMemory["DoorList"] 			= DoorList

end


function GateRoutine( Handle, MapIndex )
cExecCheck( "GateRoutine" )

	local EventMemory


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["StartGate"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["StartGate"]["Handle"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory["StartGate"] = nil
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
										GATE_TITLE["Start"]["Yes"], "LinkToTownStart",
										GATE_TITLE["Start"]["No"],  "GateDummy")

end


function LinkToTownStart( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToStart" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end


	local EventMemory


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		return

	end

	if EventMemory["StartGate"] == nil then

		return

	end

	cLinkTo( PlyHandle, GATE_DATA["START_GATE"]["LINK"]["FIELD"], GATE_DATA["START_GATE"]["LINK"]["X"], GATE_DATA["START_GATE"]["LINK"]["Y"] )
end


function GateDummy( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "GateDummy" )


end


function EVNET_NO1_INIT_FUNC( EventMemory )

	local EventData 		= { }
	local ForasChiefData	= { }


	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
	ForasChiefData	= EventData["FORASCHIEF"]



	local ForasChief = { }


	ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], ForasChiefData["MOBINDEX"],
										ForasChiefData["REGENPOSITION"]["X"], ForasChiefData["REGENPOSITION"]["Y"], ForasChiefData["REGENPOSITION"]["DIR"] )

	if ForasChief["Handle"]  ~= nil then

		cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
		cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEF_ROUTINE" )
		cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 99999999 )

		ForasChief["FC_STATE"] 		 = FC_STATE["Dialog1"]
		ForasChief["CheckTime"]		 = EventMemory["CurrentTime"] + 1
		ForasChief["FollowDistance"] = ForasChiefData["FOLLOWDISTANCE"]
		ForasChief["DialogData"]	 = ForasChiefData["DIALOGINFO"]
		ForasChief["MasterPlayer"]	 = nil
		ForasChief["DelayTime"]		 = EventMemory["CurrentTime"] + ForasChiefData["DELAYTIME"]

	end

	EventMemory["ForasChief"] = ForasChief

end


function EVNET_NO2_INIT_FUNC( EventMemory )

	local EventData		= { }
	local DavildomData		= { }
	local DavildomList		= { }
	local PlayerList
	local PlayerAggroList 	= { }
	local Count			= 1


	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
	DavildomData	= EventData["DAVILDOM"]
	PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }


	for i = 1, #PlayerList do

		local CurPlayerPos		= { }
		local DavildomPos		= { }


		CurPlayerPos["X"], CurPlayerPos["Y"] = cObjectLocate( PlayerList[i] )
		DavildomPos = DavildomData["REGENPOSITION"]

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( DavildomData["SEARCH_RANGE"] * DavildomData["SEARCH_RANGE"] ) then

			PlayerAggroList[Count] = PlayerList[i]
			Count = Count + 1

		end

	end


	for i = 1, DavildomData["MOBCOUNT"] do

		local Davildom = { }


		Davildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											   DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], DavildomData["REGENPOSITION"]["RADIUS"] )

		if Davildom["Handle"] ~= nil then

			local PlayerHandle


			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO2_DAVILDOM_ROUTINE" )


			Davildom["AggroDistance"]	= DavildomData["AGGRO_DISTANCE"]
			Davildom["D_State"] 		= D_STATE["Aggro"]
			Davildom["CheckTime"]		= EventMemory["CurrentTime"] + 1
			PlayerHandle 				= cRandomInt(1, #PlayerAggroList)
			Davildom["AggroPlayer"] 	= PlayerAggroList[PlayerHandle]

		end

		DavildomList[Davildom["Handle"]] = Davildom

	end

	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = DavildomList

end

function EVNET_NO3_INIT_FUNC( EventMemory )

	local PlayerList
	local EventData			= { }
	local DavildomData		= { }
	local DavildomList		= { }
	local PlayerAggroList 	= { }
	local Count				= 1


	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
	DavildomData	= EventData["DAVILDOM"]
	PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }


	for i = 1, #PlayerList do

		local CurPlayerPos		= { }
		local DavildomPos		= { }


		CurPlayerPos["X"], CurPlayerPos["Y"] = cObjectLocate( PlayerList[i] )
		DavildomPos = DavildomData["REGENPOSITION"]

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( DavildomData["SEARCH_RANGE"] * DavildomData["SEARCH_RANGE"] ) then

			PlayerAggroList[Count] = PlayerList[i]
			Count = Count + 1

		end

	end


	for i = 1, DavildomData["MOBCOUNT"] do

		local Davildom = { }


		Davildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											   DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], DavildomData["REGENPOSITION"]["RADIUS"] )

		if Davildom["Handle"] ~= nil then

			local PlayerHandle


			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO3_DAVILDOM_ROUTINE" )


			Davildom["AggroDistance"]	= DavildomData["AGGRO_DISTANCE"]
			Davildom["D_State"] 		= D_STATE["Aggro"]
			Davildom["CheckTime"]		= EventMemory["CurrentTime"] + 1
			PlayerHandle 				= cRandomInt(1, #PlayerAggroList)
			Davildom["AggroPlayer"] 	= PlayerAggroList[PlayerHandle]

		end

		DavildomList[Davildom["Handle"]] = Davildom

	end

	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = DavildomList

end

function EVNET_NO4_INIT_FUNC( EventMemory )

	local EventData			= { }
	local BrainWashData		= { }
	local BrainWash			= { }
	local PForasData		= { }
	local PForasList		= { }


	EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
	BrainWashData 		= EventData["BRAINWASH"]
	BrainWash["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], BrainWashData["MOBINDEX"],
										BrainWashData["REGENPOSITION"]["X"], BrainWashData["REGENPOSITION"]["Y"], BrainWashData["REGENPOSITION"]["DIR"] )

	if BrainWash["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, BrainWash["Handle"] )
		cAIScriptFunc	( BrainWash["Handle"], "Entrance", "BRAINWASH_ROUTINE" )
		cAIScriptFunc	( BrainWash["Handle"], "MobDamaged", "BRAINWASH_DAMAGED" )
		cSetNPCParam	( BrainWash["Handle"], "HPRegen", 0 )

		BrainWash["BW_State"]		= BW_SATATE["BrainWash"]
		BrainWash["Damage"]			= BrainWashData["DAMAGE"]

		local CurHP, MaxHP = cObjectHP( BrainWash["Handle"] )

		BrainWash["BaseDamage"]	= MaxHP / 100 * 8

	end

	EventMemory["BrainWash"] 	= BrainWash


	PForasData 		= EventData["PFORAS"]

	for i = 1, #PForasData do

		local PForas = { }


		PForas["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], PForasData[i]["MOBINDEX"],
										PForasData[i]["REGENPOSITION"]["X"], PForasData[i]["REGENPOSITION"]["Y"], PForasData[i]["REGENPOSITION"]["DIR"] )

		if PForas["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, PForas["Handle"] )
			cAIScriptFunc	( PForas["Handle"], "Entrance", "PFORAS_ROUTINE" )
			cSetAbstate		( PForas["Handle"], STA_IMMORTAL, 1, 99999999 )
			PForas["PF_State"]					= PF_STATE["STUN"]
			PForasList[PForas["Handle"]]		= PForas

		end

	end


	EventMemory["PForasList"] 	= PForasList
	EventMemory["PForasState"]	= PF_STATE["STUN"]


	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]

	EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenCheckTime"]		= EventMemory["CurrentTime"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenDavildomCount"] 	= 1
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]		= { }

end

function EVNET_NO5_INIT_FUNC( EventMemory )

	local EventData			= { }
	local ForasData			= { }
	local PoreData			= { }
	local DavildomData		= { }
	local ForasList			= { }
	local DavildomList		= { }
	local Pore				= { }


	EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
	ForasData	 		= EventData["FORAS"]
	DavildomData		= EventData["DAVILDOM"]
	PoreData			= EventData["PORE"]


	for i = 1, DavildomData["MOBCOUNT"] do

		local Davildom = { }


		Davildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], DavildomData["REGENPOSITION"]["RADIUS"] )

		if Davildom["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO5_DAVILDOM_ROUTINE" )

			Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1
			Davildom["AggroRange"] = DavildomData["AGGRO_RANGE"]

		end

		DavildomList[Davildom["Handle"]] = Davildom

	end



	for i = 1, ForasData["MOBCOUNT"] do

		local Foras = { }


		Foras["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], ForasData["MOBINDEX"],
											ForasData["REGENPOSITION"]["X"], ForasData["REGENPOSITION"]["Y"], ForasData["REGENPOSITION"]["RADIUS"] )

		if Foras["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Foras["Handle"] )
			cAIScriptFunc	( Foras["Handle"], "Entrance", "EVENT_NO5_FORAS_ROUTINE" )

			Foras["CheckTime"] = EventMemory["CurrentTime"] + 1
			Foras["AggroRange"] = ForasData["AGGRO_RANGE"]

		end

		ForasList[Foras["Handle"]] = Foras

	end

	local DoorInfo


	DoorInfo = EventMemory["DoorList"][4]
	cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )
	Pore["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], PoreData["MOBINDEX"],
											PoreData["REGENPOSITION"]["X"], PoreData["REGENPOSITION"]["Y"], PoreData["REGENPOSITION"]["DIR"] )

	if Pore["Handle"]  ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Pore["Handle"] )
		cAIScriptFunc	( Pore["Handle"], "Entrance", "PORE_ROUTINE" )
		cAIScriptFunc	( Pore["Handle"], "MobDamaged", "PORE_DAMAGED" )
		cSetNPCParam	( Pore["Handle"], "HPRegen", 0 )


		Pore["PR_State"] 	= PR_STATE["Normal"]
		Pore["Damage"]		= PoreData["DAMAGE"]

		local CurHP, MaxHP = cObjectHP( Pore["Handle"] )

		Pore["BaseDamage"]	= MaxHP / 100 * 8


	end

	cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "close" )

	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]

	EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] 	 = RS_STATE["Aggro"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = DavildomList
	EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"] 	 = ForasList
	EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] 		 = Pore

end


function EVNET_NO6_INIT_FUNC( EventMemory )

	local EventData			= { }
	local CitrieData		= { }
	local Citrie			= { }

	EventData 	= EVNET_DATA[EventMemory["EventNumber"]]
	CitrieData	= EventData["CITRIE"]

	Citrie["Handle"] 	= cMobRegen_XY( EventMemory["MapIndex"], CitrieData["MOBINDEX"],
											CitrieData["REGENPOSITION"]["X"], CitrieData["REGENPOSITION"]["Y"], CitrieData["REGENPOSITION"]["DIR"] )

	if Citrie["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Citrie["Handle"] )
		cAIScriptFunc	( Citrie["Handle"], "Entrance", "EVNET_NO6_CITRIE_ROUTINE" )

		Citrie["CheckTime"] 	= EventMemory["CurrentTime"] + 1
		Citrie["AggroRange"] 	= CitrieData["AGGRO_RANGE"]
		Citrie["C_State"]		= CT_STATE["Aggro"]

	end


	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]

	EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenTime"] 		= EventMemory["CurrentTime"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] 			= Citrie
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] 	= { }

end


function EVNET_NO7_INIT_FUNC( EventMemory )

	local EventData			= { }
	local ForasData			= { }
	local PoreData			= { }
	local DavildomData		= { }
	local ForasList			= { }
	local DavildomList		= { }
	local Pore				= { }


	EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
	ForasData	 		= EventData["FORAS"]
	DavildomData		= EventData["DAVILDOM"]
	PoreData			= EventData["PORE"]


	for i = 1, DavildomData["MOBCOUNT"] do

		local Davildom = { }


		Davildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], DavildomData["REGENPOSITION"]["RADIUS"] )

		if Davildom["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO7_DAVILDOM_ROUTINE" )

			Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1
			Davildom["AggroRange"] = DavildomData["AGGRO_RANGE"]

		end

		DavildomList[Davildom["Handle"]] = Davildom

	end



	for i = 1, ForasData["MOBCOUNT"] do

		local Foras = { }


		Foras["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], ForasData["MOBINDEX"],
											ForasData["REGENPOSITION"]["X"], ForasData["REGENPOSITION"]["Y"], ForasData["REGENPOSITION"]["RADIUS"] )

		if Foras["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Foras["Handle"] )
			cAIScriptFunc	( Foras["Handle"], "Entrance", "EVENT_NO7_FORAS_ROUTINE" )

			Foras["CheckTime"] = EventMemory["CurrentTime"] + 1
			Foras["AggroRange"] = ForasData["AGGRO_RANGE"]

		end

		ForasList[Foras["Handle"]] = Foras

	end


	local DoorInfo


	DoorInfo = EventMemory["DoorList"][5]
	cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )
	Pore["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], PoreData["MOBINDEX"],
											PoreData["REGENPOSITION"]["X"], PoreData["REGENPOSITION"]["Y"], PoreData["REGENPOSITION"]["DIR"] )

	if Pore["Handle"]  ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Pore["Handle"] )
		cAIScriptFunc	( Pore["Handle"], "Entrance", "PORE_ROUTINE" )
		cAIScriptFunc	( Pore["Handle"], "MobDamaged", "PORE_DAMAGED" )
		cSetNPCParam	( Pore["Handle"], "HPRegen", 0 )


		Pore["PR_State"] 	= PR_STATE["Normal"]
		Pore["Damage"]		= PoreData["DAMAGE"]

		local CurHP, MaxHP = cObjectHP( Pore["Handle"] )

		Pore["BaseDamage"]	= MaxHP / 100 * 8

	end

	cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "close" )


	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]

	EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] 	 = RS_STATE["Aggro"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = DavildomList
	EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"] 	 = ForasList
	EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] 		 = Pore

end

function EVNET_NO8_INIT_FUNC( EventMemory )

	local EventData			= { }
	local CitrieData		= { }
	local Citrie			= { }

	EventData 	= EVNET_DATA[EventMemory["EventNumber"]]
	CitrieData	= EventData["CITRIE"]

	Citrie["Handle"] 	= cMobRegen_XY( EventMemory["MapIndex"], CitrieData["MOBINDEX"],
											CitrieData["REGENPOSITION"]["X"], CitrieData["REGENPOSITION"]["Y"], CitrieData["REGENPOSITION"]["DIR"] )

	if Citrie["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Citrie["Handle"] )
		cAIScriptFunc	( Citrie["Handle"], "Entrance", "EVNET_NO8_CITRIE_ROUTINE" )

		Citrie["CheckTime"] 	= EventMemory["CurrentTime"] + 1
		Citrie["AggroRange"] 	= CitrieData["AGGRO_RANGE"]
		Citrie["C_State"]		= CT_STATE["Aggro"]

	end

	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]

	EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenTime"] 		= EventMemory["CurrentTime"]
	EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] 			= Citrie
	EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] 	= { }

end

function EVNET_NO9_INIT_FUNC( EventMemory )

	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]

end

function EVNET_NO10_INIT_FUNC( EventMemory )

	EventMemory[EventMemory["EventNumber"]] 				= { }
	EventMemory[EventMemory["EventNumber"]]["EventData"] 	= { }
	EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State1"]


	EventMemory["EndGate"] = { }


	local EndGateData	= { }
	local EndGate		= { }


	EndGateData 			= GATE_DATA["END_GATE"]
	EndGate["Handle"]		= cMobRegen_XY( EventMemory["MapIndex"], EndGateData["GATE_INDEX"],
														EndGateData["REGEN_POSITION"]["X"],
														EndGateData["REGEN_POSITION"]["Y"],
														EndGateData["REGEN_POSITION"]["DIR"] )

	if EndGate["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, EndGate["Handle"] )
		cAIScriptFunc	( EndGate["Handle"], "Entrance", "EndGateRoutine" )
		cAIScriptFunc	( EndGate["Handle"], "NPCClick", "EndGateClick"   )

	end


	GATE_MAP_INDEX[EndGate["Handle"]] 	= EventMemory["MapIndex"]
	EventMemory["EndGate"]				= EndGate

	MAPMARK( EventMemory )

end


function EndGateRoutine( Handle, MapIndex )
cExecCheck( "EndGateRoutine" )

	local EventMemory


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["EndGate"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["EndGate"]["Handle"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory["EndGate"] = nil
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end


	return ReturnAI["END"]

end


function EndGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "EndGateClick" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then

		return

	end

	if InstanceField[MapIndex] == nil then

		return

	end

	if InstanceField[MapIndex]["EndGate"] == nil then

		return

	end

	cServerMenu( PlyHandle, NPCHandle, 	GATE_TITLE["End"]["Title"],
										GATE_TITLE["End"]["Yes"], "LinkToTownEnd",
										GATE_TITLE["End"]["No"],  "GateDummy")
end


function LinkToTownEnd( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToTownEnd" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end


	local EventMemory


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		return

	end

	if EventMemory["EndGate"] == nil then

		return

	end

	cLinkTo( PlyHandle, GATE_DATA["END_GATE"]["LINK"]["FIELD"], GATE_DATA["END_GATE"]["LINK"]["X"], GATE_DATA["END_GATE"]["LINK"]["Y"] )

end


EVENT_INIT_FUNC = { }

EVENT_INIT_FUNC[1] 	= EVNET_NO1_INIT_FUNC
EVENT_INIT_FUNC[2] 	= EVNET_NO2_INIT_FUNC
EVENT_INIT_FUNC[3] 	= EVNET_NO3_INIT_FUNC
EVENT_INIT_FUNC[4] 	= EVNET_NO4_INIT_FUNC
EVENT_INIT_FUNC[5] 	= EVNET_NO5_INIT_FUNC
EVENT_INIT_FUNC[6] 	= EVNET_NO6_INIT_FUNC
EVENT_INIT_FUNC[7] 	= EVNET_NO7_INIT_FUNC
EVENT_INIT_FUNC[8] 	= EVNET_NO8_INIT_FUNC
EVENT_INIT_FUNC[9] 	= EVNET_NO9_INIT_FUNC
EVENT_INIT_FUNC[10] = EVNET_NO10_INIT_FUNC

