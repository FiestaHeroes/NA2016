require( "ID/WarLH/WarLHData" )


function FORASCHIEF_ROUTINE( Handle, MapIndex )

	local EventMemory
	local ForasChief


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	ForasChief = EventMemory["ForasChief"]

	if ForasChief == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		EventMemory["ForasChief"] = nil

		return ReturnAI["END"]

	end

	if ForasChief["CheckTime"] > EventMemory["CurrentTime"] then

		return ReturnAI["END"]

	end

	ForasChief["CheckTime"] = ForasChief["CheckTime"] + 1

	if ForasChief["FC_STATE"] == FC_STATE["Dialog1"] then

		if ForasChief["DelayTime"] < EventMemory["CurrentTime"] then

			ForasChief["FC_STATE"] = FC_STATE["Dialog2"]
			cMobDialog( EventMemory["MapIndex"], DIALOGINFO[1]["FACECUT"], DIALOGINFO[1]["FILENAME"], DIALOGINFO[1]["INDEX"] )
			ForasChief["DelayTime"] = ForasChief["DelayTime"] + 2

		end

	elseif ForasChief["FC_STATE"] == FC_STATE["Dialog2"] then

		if ForasChief["DelayTime"] > EventMemory["CurrentTime"] then

			return

		end

		local FindPlayer


		FindPlayer = cObjectFind( ForasChief["Handle"], 500, ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			ForasChief["MasterPlayer"] = FindPlayer
			ForasChief["FC_STATE"] 									= FC_STATE["Follow"]
			EventMemory[EventMemory["EventNumber"]]["EventState"]	= ES_STATE["State2"]

		end

	elseif ForasChief["FC_STATE"] == FC_STATE["Follow"] then

		cFollow( ForasChief["Handle"], ForasChief["MasterPlayer"], ForasChief["FollowDistance"], 1500 )

		if cDistanceSquar( ForasChief["Handle"], ForasChief["MasterPlayer"] ) > ( 1500 * 1500 ) then

			local FindPlayer


			FindPlayer = cObjectFind( ForasChief["Handle"], 1000, ObjectType["Player"], "so_ObjectType" )

			if FindPlayer ~= nil then

				ForasChief["MasterPlayer"] = FindPlayer

			end

		end

	end

end

function FORASCHIEFEND_ROUTINE( Handle, MapIndex )

	local EventMemory
	local ForasChief


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	ForasChief = EventMemory["ForasChiefEnd"]

	if ForasChief == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		EventMemory["ForasChief"] = nil

		return ReturnAI["END"]

	end

end




function EVENT_NO2_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 2 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end

	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	DavildomList = EventData["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Davildom = nil
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Davildom["D_State"] == D_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1


		if Davildom["AggroPlayer"] == nil then

			DavildomList[Handle]["D_State"]	= D_STATE["Battle"]

			return

		end

		local PlayerPos		= { }
		local DavildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Davildom["AggroPlayer"] )
		DavildomPos["X"], DavildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( Davildom["AggroDistance"] * Davildom["AggroDistance"] ) then

			cAggroSet( Handle, Davildom["AggroPlayer"], Davildom["AGGRO_POINT"] )
			DavildomList[Handle]["D_State"] 	= D_STATE["Battle"]

		end

	end

	return ReturnAI["CPP"]

end



function EVENT_NO3_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 3 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end

	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	DavildomList = EventData["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Davildom = nil
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Davildom["D_State"] == D_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Davildom["AggroPlayer"] == nil then

			DavildomList[Handle]["D_State"]	= D_STATE["Battle"]

			return

		end

		local PlayerPos		= { }
		local DavildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Davildom["AggroPlayer"] )
		DavildomPos["X"], DavildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( Davildom["AggroDistance"] * Davildom["AggroDistance"] ) then

			cAggroSet( Handle, Davildom["AggroPlayer"], Davildom["AGGRO_POINT"] )
			DavildomList[Handle]["D_State"] 	= D_STATE["Battle"]

		end

	end

	return ReturnAI["CPP"]

end

function BRAINWASH_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local BrainWash


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	BrainWash = EventMemory["BrainWash"]

	if BrainWash == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory["BrainWash"] = nil

		return ReturnAI["END"]

	end



	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory["BrainWash"] = nil

		return ReturnAI["END"]

	end


end

function BRAINWASH_DAMAGED( MapIndex, AttackerHandle, MaxHP, CurHP )

	local EventMemory
	local EventData
	local BrainWash


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	BrainWash = EventMemory["BrainWash"]

	if BrainWash == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if AttackerHandle == nil then

		return

	end


	if MaxHP == 0 then

		return

	end

	local HPRate


	HPRate = CurHP / MaxHP * 100

	if BrainWash["BW_State"] == BW_SATATE["BrainWash"] then

		local Damage


		Damage = MaxHP - CurHP

		cDamaged( AttackerHandle, 10000 )
		cSetAbstate( AttackerHandle, STA_BRAINWASH, 1, 25000 )
		cHeal( BrainWash["Handle"], Damage )

		return

	elseif BrainWash["BW_State"] == BW_SATATE["Damage1"] then

		if HPRate < BrainWash["Damage"][1] then

			EventMemory["BrainWash"]["BW_State"] = BW_SATATE["Damage2"]

		end

		return

	elseif BrainWash["BW_State"] == BW_SATATE["Damage2"] then

		if HPRate < BrainWash["Damage"][2] then

			EventMemory["BrainWash"]["BW_State"] = BW_SATATE["Damage3"]

		end

		return

	elseif BrainWash["BW_State"] == BW_SATATE["Damage3"] then

		if HPRate < BrainWash["Damage"][3] then

			EventMemory["BrainWash"]["BW_State"] = BW_SATATE["Damage4"]

		end

		return

	elseif BrainWash["BW_State"] == BW_SATATE["Damage4"] then

		if HPRate < BrainWash["Damage"][4] then

			EventMemory["BrainWash"]["BW_State"] = BW_SATATE["Damage5"]

		end

		return

	elseif BrainWash["BW_State"] == BW_SATATE["Damage5"] then

		if HPRate < BrainWash["Damage"][5] then

			EventMemory["BrainWash"]["BW_State"] = BW_SATATE["End"]

		end

		return

	end

end

function PFORAS_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local PForasList
	local PForas

	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	PForasList = EventMemory["PForasList"]

	if PForasList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	PForas = PForasList[Handle]

	if PForas == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory["PForasList"][Handle] = nil

		return ReturnAI["END"]

	end


	if (EventMemory["PForasState"] == PF_STATE["RUNAWAY"]) and ( PForas["PF_State"] == PF_STATE["STUN"]) then

		cRunTo( Handle, GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"] )
		EventMemory["PForasList"][Handle]["PF_State"]  = PF_STATE["RUNAWAY"]

	end


end

function EVENT_NO4_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 4 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Davildom = nil
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Davildom["D_State"] == D_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Davildom["AggroPlayer"] == nil then

			DavildomList[Handle]["D_State"]	= D_STATE["Battle"]

			return

		end

		local PlayerPos	= { }
		local DavildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Davildom["AggroPlayer"] )
		DavildomPos["X"], DavildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( Davildom["AggroDistance"] * Davildom["AggroDistance"] ) then

			cAggroSet( Handle, Davildom["AggroPlayer"], Davildom["AGGRO_POINT"] )
			DavildomList[Handle]["D_State"] 	= D_STATE["Battle"]

		end

	end

	return ReturnAI["CPP"]

end


function EVENT_NO5_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 5 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = nil

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] == RS_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Handle, Davildom["AggroRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] = RS_STATE["Battle"]

		end

		return ReturnAI["END"]

	end


	return ReturnAI["CPP"]

end

function EVENT_NO5_FORAS_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local ForasList
	local Foras


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 5 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	ForasList = EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"]

	if ForasList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"] = nil

		return ReturnAI["END"]

	end


	Foras = ForasList[Handle]

	if Foras == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"][Handle] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"][Handle] = nil

		return ReturnAI["END"]

	end


	if EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] == RS_STATE["Aggro"] then

		if Foras["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		Foras["CheckTime"] = EventMemory["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Foras["Handle"], Foras["AggroRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] = RS_STATE["Battle"]

		end

	end


	return ReturnAI["CPP"]

end


function PORE_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local Pore


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	Pore = EventData["Pore"]

	if Pore == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end

function PORE_DAMAGED( MapIndex, AttackerHandle, MaxHP, CurHP )

	local EventMemory
	local EventData
	local Pore


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Pore = EventData["Pore"]

	if Pore == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DavildomList
	local ForasList


	DavildomList 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]
	ForasList 		= EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"]


	if (next( DavildomList ) == nil) and (next(ForasList) == nil) then

		if MaxHP == 0 then

			return

		end

		local HPRate


		HPRate = CurHP / MaxHP * 100

		if EventData["Pore"]["PR_State"] == PR_STATE["Normal"] then

			if HPRate < Pore["Damage"][1] then

				EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"] = PR_STATE["Damage1"]

			end

		elseif EventData["Pore"]["PR_State"] == PR_STATE["Damage1"] then

			if HPRate < Pore["Damage"][2] then

				EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"] = PR_STATE["Damage2"]

			end

		elseif EventData["Pore"]["PR_State"] == PR_STATE["Damage2"] then

			if HPRate < Pore["Damage"][3] then

				EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"] = PR_STATE["Damage3"]

			end

		end

		return

	end

	Damage = MaxHP - CurHP
	cSetAbstate	( AttackerHandle, STA_BRAINWASH, 1, 25000 )
	cHeal		( Pore["Handle"], Damage )

end

function EVNET_NO6_CITRIE_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local Citrie


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Citrie = EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"]

	if Citrie == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] = nil

		return ReturnAI["END"]

	end


	if Citrie["C_State"] == CT_STATE["Aggro"] then

		if Citrie["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		Citrie["CheckTime"] = EventMemory["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Citrie["Handle"], Citrie["AggroRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"]["C_State"] = CT_STATE["Battle"]

		end

	end


	return ReturnAI["CPP"]

end

function EVENT_NO6_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Davildom 				= nil
		DavildomList[Handle] 	= nil

		return ReturnAI["END"]

	end

	if Davildom["DeleteTime"] < EventMemory["CurrentTime"] then

		DavildomList[Handle] 	= nil

		return

	end


	if Davildom["D_State"] == D_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Davildom["AggroPlayer"] == nil then

			DavildomList[Handle]["D_State"]	= D_STATE["Battle"]

			return

		end

		local PlayerPos	= { }
		local DavildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Davildom["AggroPlayer"] )
		DavildomPos["X"], DavildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( Davildom["AggroDistance"] * Davildom["AggroDistance"] ) then

			cAggroSet( Handle, Davildom["AggroPlayer"], Davildom["AGGRO_POINT"] )
			DavildomList[Handle]["D_State"] 	= D_STATE["Battle"]

		end

	end

	return ReturnAI["CPP"]

end


function EVENT_NO7_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 7 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = nil

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Handle] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Davildom = nil
		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Handle] = nil

		return ReturnAI["END"]

	end

	if EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] == RS_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Handle, Davildom["AggroRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] = RS_STATE["Battle"]

		end

		return ReturnAI["END"]

	end


	return ReturnAI["CPP"]

end

function EVENT_NO7_FORAS_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local ForasList
	local Foras


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventMemory["EventNumber"] ~= 7 then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	ForasList = EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"]

	if ForasList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"] = nil

		return ReturnAI["END"]

	end


	Foras = ForasList[Handle]

	if Foras == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"][Handle] = nil

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"][Handle] = nil

		return ReturnAI["END"]

	end


	if EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] == RS_STATE["Aggro"] then

		if Foras["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		Foras["CheckTime"] = EventMemory["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Foras["Handle"], Foras["AggroRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] = RS_STATE["Battle"]

		end

	end


	return ReturnAI["CPP"]

end

function EVNET_NO8_CITRIE_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local Citrie


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Citrie = EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"]

	if Citrie == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] = nil

		return ReturnAI["END"]

	end


	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] = nil

		return ReturnAI["END"]

	end


	if Citrie["C_State"] == CT_STATE["Aggro"] then

		if Citrie["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		Citrie["CheckTime"] = EventMemory["CurrentTime"] + 1


		local FindPlayer


		FindPlayer = cObjectFind( Citrie["Handle"], Citrie["AggroRange"], ObjectType["Player"], "so_ObjectType" )

		if FindPlayer ~= nil then

			EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"]["C_State"] = CT_STATE["Battle"]

		end

	end


	return ReturnAI["CPP"]

end

function EVENT_NO8_DAVILDOM_ROUTINE( Handle, MapIndex )

	local EventMemory
	local EventData
	local DavildomList
	local Davildom


	EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	EventData = EventMemory[EventMemory["EventNumber"]]["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

	if DavildomList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	Davildom = DavildomList[Handle]

	if Davildom == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DavildomList[Handle] = nil

		return ReturnAI["END"]

	end

	if Davildom["DeleteTime"] < EventMemory["CurrentTime"] then

		DavildomList[Handle] 	= nil

		return

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		Davildom 				= nil
		DavildomList[Handle] 	= nil

		return ReturnAI["END"]

	end

	if Davildom["D_State"] == D_STATE["Aggro"] then

		if Davildom["CheckTime"] > EventMemory["CurrentTime"] then

			return ReturnAI["END"]

		end

		Davildom["CheckTime"] = EventMemory["CurrentTime"] + 1

		if Davildom["AggroPlayer"] == nil then

			DavildomList[Handle]["D_State"]	= D_STATE["Battle"]

			return

		end

		local PlayerPos	= { }
		local DavildomPos	= { }


		PlayerPos["X"], PlayerPos["Y"] 		= cObjectLocate( Davildom["AggroPlayer"] )
		DavildomPos["X"], DavildomPos["Y"]	= cObjectLocate( Handle )

		cRunTo( Handle, PlayerPos["X"], PlayerPos["Y"] )

		if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], PlayerPos["X"], PlayerPos["Y"] ) < ( Davildom["AggroDistance"] * Davildom["AggroDistance"] ) then

			cAggroSet( Handle, Davildom["AggroPlayer"], Davildom["AGGRO_POINT"] )
			DavildomList[Handle]["D_State"] 	= D_STATE["Battle"]

		end

	end

	return ReturnAI["CPP"]

end

