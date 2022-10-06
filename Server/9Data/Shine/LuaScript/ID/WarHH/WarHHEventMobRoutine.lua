require( "ID/WarHH/WarHHData" )

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

	if EventMemory["GateList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["GateList"][Handle] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		GATE_MAP_INDEX[Handle] 	= nil

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


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then
		return
	end

	if EventMemory["GateList"] == nil then
		return
	end


	local Gate = EventMemory["GateList"][NPCHandle]

	if Gate == nil then
		return
	end

	cServerMenu( PlyHandle, NPCHandle, 	GATE_TITLE["Start"]["Title"],
										GATE_TITLE["Start"]["Yes"], "LinkToTown",
										GATE_TITLE["Start"]["No"],  "GateDummy")


end


function LinkToTown( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "GateClick" )

	local MapIndex = GATE_MAP_INDEX[NPCHandle]

	if MapIndex == nil then
		return

	end


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then
		return
	end

	if EventMemory["GateList"] == nil then
		return
	end


	local Gate = EventMemory["GateList"][NPCHandle]

	if Gate == nil then
		return
	end

	if Gate["LinkData"] == nil then
		return
	end

	cLinkTo( PlyHandle, Gate["LinkData"]["FIELD"], Gate["LinkData"]["X"], Gate["LinkData"]["Y"] )

end


function GateDummy( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "GateDummy" )


end


function FORASCHIEF_ROUTINE( Handle, MapIndex )
cExecCheck "FORASCHIEF_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local ForasChief


	ForasChief = EventMemory["ForasChief"]

	if ForasChief == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		ForasChief = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		ForasChief = nil

		return ReturnAI["END"]

	end


	if ForasChief["CheckTime"] > EventMemory["CurrentTime"] then

		return ReturnAI["END"]

	end

	ForasChief["CheckTime"] = ForasChief["CheckTime"] + 1

	if ForasChief["FC_STATE"] == FC_STATE["FOLLOW"] then

		if ForasChief["MasterPlayer"] ~= nil then

			cFollow( Handle, ForasChief["MasterPlayer"], 200, 1500 )

			if cDistanceSquar( Handle, ForasChief["MasterPlayer"] ) > ( 1500 * 1500 ) then

				local FindPlayer


				FindPlayer = cObjectFind( Handle, 1000, ObjectType["Player"], "so_ObjectType" )

				if FindPlayer ~= nil then

					ForasChief["MasterPlayer"] = FindPlayer

				end

			end

		end

	elseif ForasChief["FC_STATE"] == FC_STATE["MOVE"] then

		local CurrentPos 	= { }
		local EndPos


		CurrentPos["X"], CurrentPos["Y"] = cObjectLocate( Handle )
		EndPos	= FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]["END_POS"]

		cRunTo( Handle, EndPos["X"], EndPos["Y"] )
		if cDistanceSquar( CurrentPos["X"], CurrentPos["Y"], EndPos["X"], EndPos["Y"] ) < ( 10 * 10 ) then

			ForasChief["FC_STATE"] = FC_STATE["END"]

		end

	end

	return ReturnAI["CPP"]

end


function DOORLOCK_ROUTINE( Handle, MapIndex )
cExecCheck "DOORLOCK_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local LockList
	local Lock


	LockList = EventData["LockList"]

	if LockList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Lock = LockList[Handle]

	if Lock == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		LockList[Handle] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Lock = nil
		LockList[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_1_FENCE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_1_FENCE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local FenceList
	local Fence


	FenceList = EventData["FenceList"]

	if FenceList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Fence = FenceList[Handle]

	if Fence == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		FenceList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Fence = nil
		FenceList[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_1_DEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_1_DEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DevildomList
	local Devildom


	DevildomList = EventData["DevildomList"]

	if DevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Devildom = DevildomList[Handle]

	if Devildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Devildom = nil
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["EventState"] == ES_STATE["STATE_3"] then

		if Devildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		local FindPlayer


		FindPlayer = cObjectFind( Devildom["Handle"], 500, ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory["EventState"] = ES_STATE["STATE_4"]

		end

		Devildom["CheckTime"] = Devildom["CheckTime"] + 1

	end

	return ReturnAI["CPP"]

end


function HIGH_DEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "HIGH_DEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local HighDevildomList
	local HighDevildom


	HighDevildomList = EventData["HighDevildomList"]

	if HighDevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	HighDevildom = HighDevildomList[Handle]

	if HighDevildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		HighDevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		HighDevildom = nil
		HighDevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end




function EVENT_1_REGEN_DEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_1_REGEN_DEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DevildomList
	local Devildom


	DevildomList = EventData["EventDevildomList"]

	if DevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Devildom = DevildomList[Handle]

	if Devildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Devildom = nil
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Devildom["MS_STATE"]  == MONSTER_STATE["AGGRO"] then

		if Devildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		Devildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Devildom["AggroPlayer"] == nil then

			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

			return

		end


		local PlayerPos	= { }
		local DevildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Devildom["AggroPlayer"] )
		DevildomPos["X"], DevildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( AGGRO_RANGE * AGGRO_RANGE ) then

			cAggroSet( Handle, Devildom["AggroPlayer"], 5 )
			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

		end

	end

	return ReturnAI["CPP"]

end


function EVENT_1_REGEN_TDEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_1_REGEN_TDEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DevildomList
	local Devildom


	DevildomList = EventData["EventTDevildomList"]

	if DevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Devildom = DevildomList[Handle]

	if Devildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Devildom = nil
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Devildom["MS_STATE"]  == MONSTER_STATE["AGGRO"] then

		if Devildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		Devildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Devildom["AggroPlayer"] == nil then

			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

			return

		end


		local PlayerPos	= { }
		local DevildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Devildom["AggroPlayer"] )
		DevildomPos["X"], DevildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( AGGRO_RANGE * AGGRO_RANGE ) then

			cAggroSet( Handle, Devildom["AggroPlayer"], 5 )
			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

		end

	end

	return ReturnAI["CPP"]

end


function EVENT_1_FMCORPS_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_1_FMCORPS_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 1 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local FMcorpsList
	local FMcorps


	FMcorpsList = EventData["FMcorpsList"]

	if FMcorpsList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	FMcorps = FMcorpsList[Handle]

	if FMcorps == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		FMcorpsList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		FMcorps = nil
		FMcorpsList[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_2_DEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_DEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DevildomList
	local Devildom


	DevildomList = EventData[EventMemory["EventNumber"]]["DevildomList"]

	if DevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Devildom = DevildomList[Handle]

	if Devildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Devildom = nil
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		if Devildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		local FindPlayer


		FindPlayer = cObjectFind( Devildom["Handle"], 500, ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory["EventState"] = ES_STATE["STATE_2"]

		end

		Devildom["CheckTime"] = Devildom["CheckTime"] + 1

	end

	return ReturnAI["CPP"]

end


function EVENT_2_FMCORPS_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_FMCORPS_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local FMCorpsList
	local FMCorps


	FMCorpsList = EventData[EventMemory["EventNumber"]]["FMCorpsList"]

	if FMCorpsList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	FMCorps = FMCorpsList[Handle]

	if FMCorps == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		FMCorpsList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		FMCorps = nil
		FMCorpsList[Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end




function EVENT_2_SCTRIE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_SCTRIE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData[EventMemory["EventNumber"]]["SCtrieList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData[EventMemory["EventNumber"]]["SCtrieList"][Handle] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData[EventMemory["EventNumber"]]["SCtrieList"][Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_2_SFOCALOR_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_SFOCALOR_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData[EventMemory["EventNumber"]]["SFocalor"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData[EventMemory["EventNumber"]]["SFocalor"] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_2_SRANAGE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_SRANAGE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData[EventMemory["EventNumber"]]["SRange"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData[EventMemory["EventNumber"]]["SRange"] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_2_REGEN_DEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_REGEN_DEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DevildomList
	local Devildom


	DevildomList = EventData[EventMemory["EventNumber"]]["EventDevildomList"]

	if DevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Devildom = DevildomList[Handle]

	if Devildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Devildom = nil
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Devildom["MS_STATE"]  == MONSTER_STATE["AGGRO"] then

		if Devildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		Devildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Devildom["AggroPlayer"] == nil then

			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

			return

		end


		local PlayerPos		= { }
		local DevildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Devildom["AggroPlayer"] )
		DevildomPos["X"], DevildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( AGGRO_RANGE * AGGRO_RANGE ) then

			cAggroSet( Handle, Devildom["AggroPlayer"], 5 )
			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

		end

	end

	return ReturnAI["CPP"]

end


function EVENT_2_REGEN_SDEVILDOM_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_2_REGEN_SDEVILDOM_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DevildomList
	local Devildom


	DevildomList = EventData[EventMemory["EventNumber"]]["EventSDevildomList"]

	if DevildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Devildom = DevildomList[Handle]

	if Devildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Devildom = nil
		DevildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Devildom["MS_STATE"]  == MONSTER_STATE["AGGRO"] then

		if Devildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		Devildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Devildom["AggroPlayer"] == nil then

			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

			return

		end


		local PlayerPos	= { }
		local DevildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Devildom["AggroPlayer"] )
		DevildomPos["X"], DevildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( AGGRO_RANGE * AGGRO_RANGE ) then

			cAggroSet( Handle, Devildom["AggroPlayer"], 5 )
			Devildom["MS_STATE"] = MONSTER_STATE["NORMAL"]

		end

	end

	return ReturnAI["CPP"]

end


function EVENT_3_SRANAGE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_3_SRANAGE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local SRangeList
	local SRange


	SRangeList = EventData[EventMemory["EventNumber"]]["SRangeList"]

	if SRangeList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	SRange = SRangeList[Handle]

	if SRange == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		SRangeList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		SRange 				= nil
		SRangeList[Handle] 	= nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_3_MELEE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_3_MELEE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if EventData[EventMemory["EventNumber"]]["Melee"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData[EventMemory["EventNumber"]]["Melee"] = nil

		return ReturnAI["END"]

	end

	if EventData[EventMemory["EventNumber"]]["Melee"]["State"] == MONSTER_STATE["CAMERA"] then

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_TWINS_MELEE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_TWINS_MELEE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData

	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventMeleeList
	local EventMelee


	EventMeleeList = EventData[EventMemory["EventNumber"]]["EventMeleeList"]

	if EventMeleeList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	EventMelee = EventMeleeList[Handle]

	if EventMelee == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMeleeList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMelee 				= nil
		EventMeleeList[Handle] 	= nil

		return ReturnAI["END"]

	end

	if EventMelee["MS_STATE"] == MS_STATE["CAMERA"] then

		return ReturnAI["END"]

	end

	if EventMelee["CheckTime"] > EventMemory["CurrentTime"] then

		return ReturnAI["CPP"]

	end

	EventMelee["CheckTime"] = EventMemory["CurrentTime"] + 1


	if EventMelee["MS_STATE"] == MS_STATE["NORMAL"] then

		local size


		size = TableLength	( EventMemory["EventData"][EventMemory["EventNumber"]]["EventMeleeList"] )

		if size == 1 then

			EventMelee["SummonCheckTime"] 	= EventMemory["CurrentTime"] + 30
			EventMelee["MS_STATE"] 			= MS_STATE["SUMMON"]
			cSetAbstate			( EventMelee["Handle"], "StaCount30", 1, 30000 )

		end

		return ReturnAI["CPP"]

	elseif EventMelee["MS_STATE"] == MS_STATE["SUMMON"] then

		if EventMelee["SummonCheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end



		local EventData
		local EventMeleeData


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventMeleeData 		= EventData["EVENT_FMELEE"]


		local EventRegenMelee = { }


		EventRegenMelee["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], EventMeleeData["MOBINDEX"],
											EventMeleeData["REVIVAL_POSITION"]["X"], EventMeleeData["REVIVAL_POSITION"]["Y"], EventMeleeData["REVIVAL_POSITION"]["DIR"] )

		if EventRegenMelee["Handle"]  ~= nil then

			cSetAIScript	( SCRIPT_MAIN, EventRegenMelee["Handle"] )
			cAIScriptFunc	( EventRegenMelee["Handle"], "Entrance", "EVENT_TWINS_MELEE_ROUTINE" )

			EventRegenMelee["CheckTime"] 		= EventMemory["CurrentTime"]
			EventRegenMelee["MS_STATE"] 		= MS_STATE["NORMAL"]
			EventRegenMelee["SummonCheckTime"]	= 0

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventMeleeList"][EventRegenMelee["Handle"]] = EventRegenMelee

		EventMelee["MS_STATE"] = MS_STATE["NORMAL"]

		return

	end

	return ReturnAI["CPP"]

end


function EVENT_AVANAS_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_AVANAS_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if EventData[EventMemory["EventNumber"]]["Avanas"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData[EventMemory["EventNumber"]]["Avanas"] = nil

		return ReturnAI["END"]

	end

	if EventData[EventMemory["EventNumber"]]["Avanas"]["MS_STATE"] == MS_STATE["CAMERA"] then

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end


function EVENT_AVANASGATE_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_AVANASGATE_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventMemoryData


	EventMemoryData = EventMemory["EventData"]

	if EventMemoryData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local AvanasGate


	AvanasGate = EventMemoryData[EventMemory["EventNumber"]]["AvanasGate"]

	if AvanasGate == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemoryData[EventMemory["EventNumber"]]["AvanasGate"] = nil

		return ReturnAI["END"]

	end

	if AvanasGate["RegenTime"] > EventMemory["CurrentTime"] then

		return

	end


	local PlayerList
	local PlayerAggroList 	= { }
	local Count			= 1


	PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }

	for i = 1, #PlayerList do

		local CurPlayerPos		= { }
		local AvanasGatePos


		CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )

		if cDistanceSquar( AvanasGate["RegenPosition"]["X"], AvanasGate["RegenPosition"]["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( SEARCH_RANGE * SEARCH_RANGE ) then

			PlayerAggroList[Count] = PlayerList[i]
			Count = Count + 1

		end

	end


	local RegenMosterData 	= EVNET_DATA[EventMemory["EventNumber"]]["FAVANAS_GATE"]["REGEN_MONSTER"][AvanasGate["RegenNumber"]]

	local RegenMonster 	= { }
	local PlayerHandle


	RegenMonster["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], RegenMosterData["MOBINDEX"],
											AvanasGate["RegenPosition"]["X"], AvanasGate["RegenPosition"]["Y"], AvanasGate["RegenPosition"]["DIR"] )


	if RegenMonster["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, RegenMonster["Handle"] )
		cAIScriptFunc	( RegenMonster["Handle"], "Entrance", "EVENT_REGENMONSTER_ROUTINE" )

		RegenMonster["DeleteTime"] 		= EventMemory["CurrentTime"] + 60
		PlayerHandle 					= cRandomInt(1, #PlayerAggroList)
		RegenMonster["AggroPlayer"] 	= PlayerAggroList[PlayerHandle]
		RegenMonster["MS_STATE"]		= MONSTER_STATE["AGGRO"]
		RegenMonster["CheckTime"] 		= EventMemory["CurrentTime"]

		cSetNPCIsItemDrop( RegenMonster["Handle"], 0 )

		EventMemory["EventData"]["RegenMonsterList"][RegenMonster["Handle"]] = RegenMonster

	end

	AvanasGate["RegenTime"] 	= EventMemory["CurrentTime"] + RegenMosterData["REGEN_TIME"]
	AvanasGate["RegenNumber"] 	= AvanasGate["RegenNumber"] + 1

	if AvanasGate["RegenNumber"] > #EVNET_DATA[EventMemory["EventNumber"]]["FAVANAS_GATE"]["REGEN_MONSTER"] then

		EventMemory["EventData"][EventMemory["EventNumber"]]["AvanasGate"] = nil

	end

	return ReturnAI["CPP"]

end



function EVENT_REGENMONSTER_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_REGENMONSTER_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local RegenMonsterList
	local RegenMonster


	RegenMonsterList = EventData["RegenMonsterList"]

	if RegenMonsterList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	RegenMonster = RegenMonsterList[Handle]

	if RegenMonster == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData[EventMemory["EventNumber"]]["RegenMonsterList"][Handle] = nil

		return ReturnAI["END"]

	end




	if RegenMonster["MS_STATE"] == MONSTER_STATE["AGGRO"] then

		if RegenMonster["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		RegenMonster["CheckTime"] = EventMemory["CurrentTime"] + 1

		if RegenMonster["AggroPlayer"] == nil then

			RegenMonster["MS_STATE"] = MONSTER_STATE["NORMAL"]

			return

		end


		local PlayerPos			= { }
		local RegenMonsterPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 				= cObjectLocate( RegenMonster["AggroPlayer"] )
		RegenMonsterPos["X"], RegenMonsterPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( RegenMonsterPos["X"], RegenMonsterPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( AGGRO_RANGE * AGGRO_RANGE ) then

			cAggroSet( Handle, RegenMonster["AggroPlayer"], 5 )
			RegenMonster["MS_STATE"] = MONSTER_STATE["NORMAL"]

		end

	elseif RegenMonster["MS_STATE"] == MONSTER_STATE["NORMAL"] then

		if RegenMonster["DeleteTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["CPP"]

		end

		EventMemory["EventData"]["RegenMonsterList"][Handle] = nil

	end


	return ReturnAI["CPP"]

end


function EVENT_BOMB_ROUTINE( Handle, MapIndex )
cExecCheck "EVENT_BOMB_ROUTINE"

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData


	EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local BombList
	local Bomb


	BombList = EventData["BombList"]

	if BombList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Bomb = BombList[Handle]

	if Bomb == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData["BombList"][Handle] = nil

		return ReturnAI["END"]

	end


	if Bomb["MonsterState"]	== MS_STATE["NORMAL"] then

		if Bomb["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local X, Y = cObjectLocate( Bomb["Handle"] )
		local TargetList = { cGetTargetList( Bomb["Handle"], X, Y, BOMB_DATA["RADIUS"] ) }

		for i = 1, #TargetList do

			cDamaged( TargetList[i], BOMB_DATA["DAMAGE"], Bomb["Handle"] )

		end

		Bomb["MonsterState"] 	= MS_STATE["DEAD"]
		Bomb["CheckTime"] 		= EventMemory["CurrentTime"] + 5

		return

	elseif Bomb["MonsterState"] == MS_STATE["DEAD"] then

		if Bomb["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventData["BombList"][Handle] = nil

		return

	end


	return ReturnAI["CPP"]

end
