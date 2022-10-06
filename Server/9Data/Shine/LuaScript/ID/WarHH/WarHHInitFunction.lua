require( "ID/WarHH/WarHHData" )

function EVENT_INIT_FUNCTION_1( EventMemory )
cExecCheck( "EVENT_INITFUNCTION_1" )

	local EventData 		= { }
	local ForasChiefData
	local FenceData
	local DevildomData
	local HighDevildomData
	local FMCorpsData


	EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
	ForasChiefData		= FORAS_CHIEF
	FenceData			= EventData["FENCE"]
	DevildomData		= EventData["DEVILDOM"]
	HighDevildomData	= EventData["HIGH_DEVILDOM"]
	FMCorpsData			= EventData["FMCORPS"]


	local PlayerList
	local ForasChief = { }


	PlayerList	= { cGetPlayerList( EventMemory["MapIndex"] ) }
	ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], ForasChiefData["MOBINDEX"],
										ForasChiefData["REGEN_POSITION"]["X"], ForasChiefData["REGEN_POSITION"]["Y"], ForasChiefData["REGEN_POSITION"]["DIR"] )

	if ForasChief["Handle"]  ~= nil then

		cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
		cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEF_ROUTINE" )
		cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 99999999 )

		ForasChief["CheckTime"] = EventMemory["CurrentTime"]
		ForasChief["FC_STATE"] 	= FC_STATE["FOLLOW"]

		if PlayerList[1] ~= nil then

			ForasChief["MasterPlayer"]	= PlayerList[1]

		end

	end

	EventMemory["ForasChief"] = ForasChief


	local FenceList 	= { }


	for i = 1, #FenceData["REGEN_POSITION"] do

		local Fence	= { }


		Fence["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FenceData["MOBINDEX"],
										FenceData["REGEN_POSITION"][i]["X"], FenceData["REGEN_POSITION"][i]["Y"], FenceData["REGEN_POSITION"][i]["DIR"] )

		if Fence["Handle"]  ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Fence["Handle"] )
			cAIScriptFunc	( Fence["Handle"], "Entrance", "EVENT_1_FENCE_ROUTINE" )

			FenceList[Fence["Handle"]] = Fence

		end

	end

	EventMemory["EventData"]["FenceList"] = FenceList


	local DevildomList = { }


	for i = 1, #DevildomData["REGEN_POSITION"] do

		local Devildom		= { }

		Devildom["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], DevildomData["MOBINDEX"],
										DevildomData["REGEN_POSITION"][i]["X"], DevildomData["REGEN_POSITION"][i]["Y"], DevildomData["REGEN_POSITION"][i]["DIR"] )

		if Devildom["Handle"]  ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Devildom["Handle"] )
			cAIScriptFunc	( Devildom["Handle"], "Entrance", "EVENT_1_DEVILDOM_ROUTINE" )

			Devildom["CheckTime"]				= EventMemory["CurrentTime"]
			DevildomList[Devildom["Handle"]] 	= Devildom

		end

	end

	EventMemory["EventData"]["DevildomList"] = DevildomList



	local HighDevildomList = { }


	for i = 1, #HighDevildomData["REGEN_POSITION"] do

		local HighDevildom		= { }

		HighDevildom["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], HighDevildomData["MOBINDEX"],
										HighDevildomData["REGEN_POSITION"][i]["X"], HighDevildomData["REGEN_POSITION"][i]["Y"], HighDevildomData["REGEN_POSITION"][i]["DIR"] )

		if HighDevildom["Handle"]  ~= nil then

			cSetAIScript	( SCRIPT_MAIN, HighDevildom["Handle"] )
			cAIScriptFunc	( HighDevildom["Handle"], "Entrance", "HIGH_DEVILDOM_ROUTINE" )

			HighDevildomList[HighDevildom["Handle"]] 	= HighDevildom

		end

	end

	EventMemory["EventData"]["HighDevildomList"] = HighDevildomList



	local FMcorpsList 	= { }


	for i = 1, #FMCorpsData["REGEN_POSITION"] do

		local FMcorps		= { }

		FMcorps["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FMCorpsData["MOBINDEX"],
										FMCorpsData["REGEN_POSITION"][i]["X"], FMCorpsData["REGEN_POSITION"][i]["Y"], FMCorpsData["REGEN_POSITION"][i]["DIR"] )

		if FMcorps["Handle"]  ~= nil then

			cSetAIScript	( SCRIPT_MAIN, FMcorps["Handle"] )
			cAIScriptFunc	( FMcorps["Handle"], "Entrance", "EVENT_1_FMCORPS_ROUTINE" )

			FMcorpsList[FMcorps["Handle"]] = FMcorps

		end

	end

	EventMemory["EventData"]["FMcorpsList"] = FMcorpsList

end



function EVENT_INIT_FUNCTION_2( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_2" )

	EventMemory["EventData"][EventMemory["EventNumber"]] = { }


	local EventData 		= { }
	local DevildomData		= { }
	local HighDevildomData	= { }
	local FMCorpsData		= { }
	local SCtrieData		= { }
	local SFocalorData		= { }
	local SRangeData		= { }

	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]


	DevildomData		= EventData["DEVILDOM"]
	HighDevildomData 	= EventData["HIGH_DEVILDOM"]
	FMCorpsData			= EventData["FMCORPS"]
	SCtrieData			= EventData["SCITRIE"]
	SFocalorData		= EventData["SFOCALOR"]
	SRangeData			= EventData["SRANGE"]


	local DevildomList	= { }


	for i = 1, #DevildomData["REGEN"] do

		for j = 1, DevildomData["REGEN"][i]["MOBCOUNT"] do

			local Devildom = { }


			Devildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DevildomData["MOBINDEX"],
										DevildomData["REGEN"][i]["POSITION"]["X"], DevildomData["REGEN"][i]["POSITION"]["Y"], DevildomData["REGEN"][i]["POSITION"]["RADIUS"] )

			if Devildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, Devildom["Handle"] )
				cAIScriptFunc	( Devildom["Handle"], "Entrance", "EVENT_2_DEVILDOM_ROUTINE" )

				Devildom["CheckTime"]				= EventMemory["CurrentTime"]
				DevildomList[Devildom["Handle"]]	= Devildom

			end

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["DevildomList"] = DevildomList



	local HighDevildomList	= { }


	for i = 1, #HighDevildomData["REGEN"] do

		for j = 1, HighDevildomData["REGEN"][i]["MOBCOUNT"] do

			local HighDevildom = { }


			HighDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], HighDevildomData["MOBINDEX"],
										HighDevildomData["REGEN"][i]["POSITION"]["X"], HighDevildomData["REGEN"][i]["POSITION"]["Y"], HighDevildomData["REGEN"][i]["POSITION"]["RADIUS"] )

			if HighDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, HighDevildom["Handle"] )
				cAIScriptFunc	( HighDevildom["Handle"], "Entrance", "HIGH_DEVILDOM_ROUTINE" )

				HighDevildomList[HighDevildom["Handle"]]	= HighDevildom

			end

		end

	end

	EventMemory["EventData"]["HighDevildomList"] = HighDevildomList



	local FMCorpsList	= { }


	for i = 1, #FMCorpsData["REGEN"] do

		for j = 1, FMCorpsData["REGEN"][i]["MOBCOUNT"] do

			local FMCorps = { }


			FMCorps["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], FMCorpsData["MOBINDEX"],
										FMCorpsData["REGEN"][i]["POSITION"]["X"], FMCorpsData["REGEN"][i]["POSITION"]["Y"], FMCorpsData["REGEN"][i]["POSITION"]["RADIUS"] )

			if FMCorps["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, FMCorps["Handle"] )
				cAIScriptFunc	( FMCorps["Handle"], "Entrance", "EVENT_2_FMCORPS_ROUTINE" )

				FMCorpsList[FMCorps["Handle"]]	= FMCorps

			end

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["FMCorpsList"] = FMCorpsList



	local SCtrieList = { }


	for i = 1, #SCtrieData["REGEN_POSITION"] do

		local SCtrie = { }


		SCtrie["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SCtrieData["MOBINDEX"],
											SCtrieData["REGEN_POSITION"][i]["X"], SCtrieData["REGEN_POSITION"][i]["Y"], SCtrieData["REGEN_POSITION"][i]["DIR"] )

		if SCtrie["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, SCtrie["Handle"] )
			cAIScriptFunc	( SCtrie["Handle"], "Entrance", "EVENT_2_SCTRIE_ROUTINE" )

			SCtrieList[SCtrie["Handle"]] = SCtrie

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["SCtrieList"] = SCtrieList


	local SFocalor = { }


	SFocalor["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SFocalorData["MOBINDEX"],
										SFocalorData["REGEN_POSITION"]["X"], SFocalorData["REGEN_POSITION"]["Y"], SFocalorData["REGEN_POSITION"]["DIR"] )

	if SFocalor["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, SFocalor["Handle"] )
		cAIScriptFunc	( SFocalor["Handle"], "Entrance", "EVENT_2_SFOCALOR_ROUTINE" )

		EventMemory["EventData"][EventMemory["EventNumber"]]["SFocalor"] = SFocalor

	end


	local SRangeList = { }


	for i = 1, #SRangeData["REGEN_POSITION"] do

		local SRange = { }


		SRange["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SRangeData["MOBINDEX"],
											SRangeData["REGEN_POSITION"][i]["X"], SRangeData["REGEN_POSITION"][i]["Y"], SRangeData["REGEN_POSITION"][i]["DIR"] )

		if SRange["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, SRange["Handle"] )
			cAIScriptFunc	( SRange["Handle"], "Entrance", "EVENT_3_SRANAGE_ROUTINE" )
			cSetAbstate		( SRange["Handle"], STA_RANGEATTACK, 1, 99999999 )

			SRangeList[SRange["Handle"]] = SRange

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["SRangeList"] = SRangeList

end


function EVENT_INIT_FUNCTION_3( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_3" )

	EventMemory["EventData"][EventMemory["EventNumber"]] = { }


	local EventData 		= { }
	local DevildomData		= { }
	local HighDevildomData	= { }
	local FMCorpsData		= { }
	local SCtrieData		= { }
	local SFocalorData		= { }
	local SRangeData		= { }

	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]


	DevildomData		= EventData["DEVILDOM"]
	HighDevildomData	= EventData["HIGH_DEVILDOM"]
	FMCorpsData			= EventData["FMCORPS"]
	SCtrieData			= EventData["SCITRIE"]
	SFocalorData		= EventData["SFOCALOR"]
	SRangeData			= EventData["SRANGE"]


	local DevildomList	= { }


	for i = 1, #DevildomData["REGEN"] do

		for j = 1, DevildomData["REGEN"][i]["MOBCOUNT"] do

			local Devildom = { }


			Devildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DevildomData["MOBINDEX"],
										DevildomData["REGEN"][i]["POSITION"]["X"], DevildomData["REGEN"][i]["POSITION"]["Y"], DevildomData["REGEN"][i]["POSITION"]["RADIUS"] )

			if Devildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, Devildom["Handle"] )
				cAIScriptFunc	( Devildom["Handle"], "Entrance", "EVENT_2_DEVILDOM_ROUTINE" )

				Devildom["CheckTime"]				= EventMemory["CurrentTime"]
				DevildomList[Devildom["Handle"]]	= Devildom

			end

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["DevildomList"] = DevildomList




	local HighDevildomList	= { }


	for i = 1, #HighDevildomData["REGEN"] do

		for j = 1, HighDevildomData["REGEN"][i]["MOBCOUNT"] do

			local HighDevildom = { }


			HighDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], HighDevildomData["MOBINDEX"],
										HighDevildomData["REGEN"][i]["POSITION"]["X"], HighDevildomData["REGEN"][i]["POSITION"]["Y"], HighDevildomData["REGEN"][i]["POSITION"]["RADIUS"] )

			if HighDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, HighDevildom["Handle"] )
				cAIScriptFunc	( HighDevildom["Handle"], "Entrance", "HIGH_DEVILDOM_ROUTINE" )

				HighDevildomList[HighDevildom["Handle"]]	= HighDevildom

			end

		end

	end

	EventMemory["EventData"]["HighDevildomList"] = HighDevildomList




	local FMCorpsList	= { }


	for i = 1, #FMCorpsData["REGEN"] do

		for j = 1, FMCorpsData["REGEN"][i]["MOBCOUNT"] do

			local FMCorps = { }


			FMCorps["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], FMCorpsData["MOBINDEX"],
										FMCorpsData["REGEN"][i]["POSITION"]["X"], FMCorpsData["REGEN"][i]["POSITION"]["Y"], FMCorpsData["REGEN"][i]["POSITION"]["RADIUS"] )

			if FMCorps["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, FMCorps["Handle"] )
				cAIScriptFunc	( FMCorps["Handle"], "Entrance", "EVENT_2_FMCORPS_ROUTINE" )

				FMCorpsList[FMCorps["Handle"]]	= FMCorps

			end

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["FMCorpsList"] = FMCorpsList



	local SCtrieList = { }


	for i = 1, #SCtrieData["REGEN_POSITION"] do

		local SCtrie = { }


		SCtrie["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SCtrieData["MOBINDEX"],
											SCtrieData["REGEN_POSITION"][i]["X"], SCtrieData["REGEN_POSITION"][i]["Y"], SCtrieData["REGEN_POSITION"][i]["DIR"] )

		if SCtrie["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, SCtrie["Handle"] )
			cAIScriptFunc	( SCtrie["Handle"], "Entrance", "EVENT_2_SCTRIE_ROUTINE" )

			SCtrieList[SCtrie["Handle"]] = SCtrie

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["SCtrieList"] = SCtrieList




	local SFocalor = { }


	SFocalor["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SFocalorData["MOBINDEX"],
										SFocalorData["REGEN_POSITION"]["X"], SFocalorData["REGEN_POSITION"]["Y"], SFocalorData["REGEN_POSITION"]["DIR"] )

	if SFocalor["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, SFocalor["Handle"] )
		cAIScriptFunc	( SFocalor["Handle"], "Entrance", "EVENT_2_SFOCALOR_ROUTINE" )

		EventMemory["EventData"][EventMemory["EventNumber"]]["SFocalor"] = SFocalor

	end


	local SRangeList = { }


	for i = 1, #SRangeData["REGEN_POSITION"] do

		local SRange = { }


		SRange["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SRangeData["MOBINDEX"],
											SRangeData["REGEN_POSITION"][i]["X"], SRangeData["REGEN_POSITION"][i]["Y"], SRangeData["REGEN_POSITION"][i]["DIR"] )

		if SRange["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, SRange["Handle"] )
			cAIScriptFunc	( SRange["Handle"], "Entrance", "EVENT_3_SRANAGE_ROUTINE" )
			cSetAbstate		( SRange["Handle"], STA_RANGEATTACK, 1, 99999999 )

			SRangeList[SRange["Handle"]] = SRange

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["SRangeList"] = SRangeList

end



function EVENT_INIT_FUNCTION_4( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_4" )

	EventMemory["EventData"][EventMemory["EventNumber"]] = { }


	local EventData 		= { }
	local DevildomData		= { }
	local HighDevildomData	= { }
	local FMCorpsData		= { }
	local SCtrieData		= { }
	local SFocalorData		= { }
	local SRangeData		= { }


	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]

	DevildomData		= EventData["DEVILDOM"]
	HighDevildomData	= EventData["HIGH_DEVILDOM"]
	FMCorpsData			= EventData["FMCORPS"]
	SCtrieData			= EventData["SCITRIE"]
	SFocalorData		= EventData["SFOCALOR"]
	SRangeData			= EventData["SRANGE"]


	local DevildomList	= { }


	for i = 1, #DevildomData["REGEN"] do

		for j = 1, DevildomData["REGEN"][i]["MOBCOUNT"] do

			local Devildom = { }


			Devildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], DevildomData["MOBINDEX"],
										DevildomData["REGEN"][i]["POSITION"]["X"], DevildomData["REGEN"][i]["POSITION"]["Y"], DevildomData["REGEN"][i]["POSITION"]["RADIUS"] )

			if Devildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, Devildom["Handle"] )
				cAIScriptFunc	( Devildom["Handle"], "Entrance", "EVENT_2_DEVILDOM_ROUTINE" )

				Devildom["CheckTime"]				= EventMemory["CurrentTime"]
				DevildomList[Devildom["Handle"]]	= Devildom

			end

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["DevildomList"] = DevildomList



	local HighDevildomList	= { }


	for i = 1, #HighDevildomData["REGEN"] do

		for j = 1, HighDevildomData["REGEN"][i]["MOBCOUNT"] do

			local HighDevildom = { }


			HighDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], HighDevildomData["MOBINDEX"],
										HighDevildomData["REGEN"][i]["POSITION"]["X"], HighDevildomData["REGEN"][i]["POSITION"]["Y"], HighDevildomData["REGEN"][i]["POSITION"]["RADIUS"] )

			if HighDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, HighDevildom["Handle"] )
				cAIScriptFunc	( HighDevildom["Handle"], "Entrance", "HIGH_DEVILDOM_ROUTINE" )

				HighDevildomList[HighDevildom["Handle"]]	= HighDevildom

			end

		end

	end

	EventMemory["EventData"]["HighDevildomList"] = HighDevildomList


	local FMCorpsList	= { }


	for i = 1, #FMCorpsData["REGEN"] do

		for j = 1, FMCorpsData["REGEN"][i]["MOBCOUNT"] do

			local FMCorps = { }


			FMCorps["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], FMCorpsData["MOBINDEX"],
										FMCorpsData["REGEN"][i]["POSITION"]["X"], FMCorpsData["REGEN"][i]["POSITION"]["Y"], FMCorpsData["REGEN"][i]["POSITION"]["RADIUS"] )

			if FMCorps["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, FMCorps["Handle"] )
				cAIScriptFunc	( FMCorps["Handle"], "Entrance", "EVENT_2_FMCORPS_ROUTINE" )

				FMCorpsList[FMCorps["Handle"]]	= FMCorps

			end

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["FMCorpsList"] = FMCorpsList


	local SCtrieList = { }


	for i = 1, #SCtrieData["REGEN_POSITION"] do

		local SCtrie = { }


		SCtrie["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SCtrieData["MOBINDEX"],
											SCtrieData["REGEN_POSITION"][i]["X"], SCtrieData["REGEN_POSITION"][i]["Y"], SCtrieData["REGEN_POSITION"][i]["DIR"] )

		if SCtrie["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, SCtrie["Handle"] )
			cAIScriptFunc	( SCtrie["Handle"], "Entrance", "EVENT_2_SCTRIE_ROUTINE" )

			SCtrieList[SCtrie["Handle"]] = SCtrie

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["SCtrieList"] = SCtrieList


	local SFocalor = { }


	SFocalor["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SFocalorData["MOBINDEX"],
										SFocalorData["REGEN_POSITION"]["X"], SFocalorData["REGEN_POSITION"]["Y"], SFocalorData["REGEN_POSITION"]["DIR"] )

	if SFocalor["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, SFocalor["Handle"] )
		cAIScriptFunc	( SFocalor["Handle"], "Entrance", "EVENT_2_SFOCALOR_ROUTINE" )

		EventMemory["EventData"][EventMemory["EventNumber"]]["SFocalor"] = SFocalor

	end



	local SRangeList = { }


	for i = 1, #SRangeData["REGEN_POSITION"] do

		local SRange = { }


		SRange["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], SRangeData["MOBINDEX"],
											SRangeData["REGEN_POSITION"][i]["X"], SRangeData["REGEN_POSITION"][i]["Y"], SRangeData["REGEN_POSITION"][i]["DIR"] )

		if SRange["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, SRange["Handle"] )
			cAIScriptFunc	( SRange["Handle"], "Entrance", "EVENT_3_SRANAGE_ROUTINE" )
			cSetAbstate		( SRange["Handle"], STA_RANGEATTACK, 1, 99999999 )

			SRangeList[SRange["Handle"]] = SRange

		end

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["SRangeList"] = SRangeList

end



function EVENT_INIT_FUNCTION_5( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_5" )

	EventMemory["EventData"][EventMemory["EventNumber"]] = { }


	local EventData 		= { }
	local FavanasData		= { }


	EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
	FavanasData		= EventData["FAVANAS"]


	local Avanas = { }


	Avanas["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FavanasData["MOBINDEX"],
											FavanasData["REGEN_POSITION"]["X"], FavanasData["REGEN_POSITION"]["Y"], FavanasData["REGEN_POSITION"]["DIR"] )

	if Avanas["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, Avanas["Handle"] )
		cAIScriptFunc	( Avanas["Handle"], "Entrance", "EVENT_AVANAS_ROUTINE" )

		Avanas["MS_STATE"] = MS_STATE["CAMERA"]

	end

	EventMemory["EventData"][EventMemory["EventNumber"]]["Avanas"]  	= Avanas
	EventMemory["EventData"]["RegenMonsterList"] 		= { }
	EventMemory["EventData"]["BombList"]				= { }


end

function EVENT_INIT_FUNCTION_6( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_6" )

	local EndGateData	= { }
	local EndGate		= { }


	EndGateData 			= GATE_DATA["END_GATE"]
	EndGate["Handle"]		= cMobRegen_XY( EventMemory["MapIndex"], EndGateData["GATE_INDEX"],
														EndGateData["REGEN_POSITION"]["X"],
														EndGateData["REGEN_POSITION"]["Y"],
														EndGateData["REGEN_POSITION"]["DIR"] )

	if EndGate["Handle"] ~= nil then

		cSetAIScript	( SCRIPT_MAIN, EndGate["Handle"] )
		cAIScriptFunc	( EndGate["Handle"], "Entrance", "GateRoutine" )
		cAIScriptFunc	( EndGate["Handle"], "NPCClick", "GateClick"   )

		EndGate["LinkData"]				= GATE_DATA["END_GATE"]["LINK"]
		EndGate["RegenPosition"]		= GATE_DATA["END_GATE"]["REGEN_POSITION"]

		GATE_MAP_INDEX[EndGate["Handle"]] 			= EventMemory["MapIndex"]
		EventMemory["GateList"][EndGate["Handle"]]  = EndGate

	end

	EventMemory["AreaStateCheckTime"] = EventMemory["CurrentTime"]

	MAPMARK( EventMemory )

end

function EVENT_INIT_FUNCTION_7( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_7" )

end


EVENT_INIT_FUCTION 		= { }
EVENT_INIT_FUCTION[1] 	= EVENT_INIT_FUNCTION_1
EVENT_INIT_FUCTION[2] 	= EVENT_INIT_FUNCTION_2
EVENT_INIT_FUCTION[3] 	= EVENT_INIT_FUNCTION_3
EVENT_INIT_FUCTION[4] 	= EVENT_INIT_FUNCTION_4
EVENT_INIT_FUCTION[5] 	= EVENT_INIT_FUNCTION_5
EVENT_INIT_FUCTION[6] 	= EVENT_INIT_FUNCTION_6
EVENT_INIT_FUCTION[7] 	= EVENT_INIT_FUNCTION_7


