require( "ID/WarHH/WarHHData" )

function EVENT_ROUTINE_1( EventMemory )
cExecCheck( "EVENT_ROUTINE_1" )

	if EventMemory == nil then

		return

	end


	if EventMemory["EventNumber"] ~= 1 then

		return

	end


	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		EventMemory["FaceCut"]["CheckTime"] = EventMemory["CurrentTime"] + 5

		EventMemory["EventState"] = ES_STATE["STATE_2"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )
		FaceCut( EventMemory )

		local EventData
		local EventDevildomData
		local EventTDevildomData


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventDevildomData 	= EventData["EVENT_DEVILDOM"]
		EventTDevildomData 	= EventData["EVENT_TDEVILDOM"]


		local PlayerList
		local PlayerAggroList 	= { }
		local Count				= 1


		PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i = 1, #PlayerList do

			local CurPlayerPos		= { }
			local DevildomPos


			CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )
			DevildomPos 							= EventDevildomData["REGEN_POSITION"]

			if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( SEARCH_RANGE * SEARCH_RANGE ) then

				PlayerAggroList[Count] = PlayerList[i]
				Count = Count + 1

			end

		end

		local EventDevildomList 	= { }


		for i = 1, EventDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventDevildom			= { }


			EventDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventDevildomData["MOBINDEX"],
												EventDevildomData["REGEN_POSITION"]["X"], EventDevildomData["REGEN_POSITION"]["Y"], EventDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventDevildom["Handle"] )
				cAIScriptFunc	( EventDevildom["Handle"], "Entrance", "EVENT_1_REGEN_DEVILDOM_ROUTINE" )

				EventDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventDevildom["MS_STATE"] 					= MONSTER_STATE["AGGRO"]
				PlayerHandle 								= cRandomInt(1, #PlayerAggroList)
				EventDevildom["AggroPlayer"] 				= PlayerAggroList[PlayerHandle]

				EventDevildomList[EventDevildom["Handle"]] 	= EventDevildom

			end

		end

		EventMemory["EventData"]["EventDevildomList"] = EventDevildomList


		local EventTDevildomList 	= { }


		for i = 1, EventTDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventTDevildom		= { }


			EventTDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventTDevildomData["MOBINDEX"],
												EventTDevildomData["REGEN_POSITION"]["X"], EventTDevildomData["REGEN_POSITION"]["Y"], EventTDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventTDevildom["Handle"]  ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventTDevildom["Handle"] )
				cAIScriptFunc	( EventTDevildom["Handle"], "Entrance", "EVENT_1_REGEN_TDEVILDOM_ROUTINE" )

				EventTDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventTDevildom["MS_STATE"] 						= MONSTER_STATE["AGGRO"]
				PlayerHandle 									= cRandomInt(1, #PlayerAggroList)
				EventTDevildom["AggroPlayer"] 					= PlayerAggroList[PlayerHandle]

				EventTDevildomList[EventTDevildom["Handle"]] 	= EventTDevildom

			end

		end

		EventMemory["EventData"]["EventTDevildomList"] = EventTDevildomList
		EventMemory["EventState"] = ES_STATE["STATE_5"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		local EventData
		local FenceList
		local DevildomList
		local HighDevildomList
		local EventDevildomList
		local EventTDevildomList


		EventData 			= EventMemory["EventData"]

		FenceList			= EventData["FenceList"]
		DevildomList		= EventData["DevildomList"]
		HighDevildomList	= EventData["HighDevildomList"]
		EventDevildomList	= EventData["EventDevildomList"]
		EventTDevildomList	= EventData["EventTDevildomList"]


		if next( FenceList ) ~= nil or next( DevildomList ) ~= nil or next( EventDevildomList ) ~= nil or next( EventTDevildomList ) ~= nil or next( HighDevildomList ) ~= nil then

			return

		end

		EventMemory["ForasChief"] = nil
		EventMemory["EventState"] = ES_STATE["STATE_6"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_6"] then

		local PlayerList
		local ForasChiefPosition
		local ForasChief 		= { }


		PlayerList			= { cGetPlayerList( EventMemory["MapIndex"] ) }
		ForasChiefPosition	= FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]

		ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FORAS_CHIEF["MOBINDEX"],
											ForasChiefPosition["START_POS"]["X"], ForasChiefPosition["START_POS"]["Y"], ForasChiefPosition["START_POS"]["DIR"] )

		if ForasChief["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
			cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEF_ROUTINE" )
			cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 99999999 )

			ForasChief["FC_STATE"] 	= FC_STATE["MOVE"]
			ForasChief["CheckTime"]	= EventMemory["CurrentTime"]

			if PlayerList[1] ~= nil then

				ForasChief["MasterPlayer"]	= PlayerList[1]

			end

		end

		EventMemory["ForasChief"] = ForasChief
		EventMemory["EventState"] = ES_STATE["STATE_7"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_7"] then

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]


		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2
		EventMemory["EventState"] = ES_STATE["STATE_8"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_8"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["EventState"] = ES_STATE["STATE_9"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_9"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_10"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_10"] then

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 1

		EventMemory["EventState"] = ES_STATE["STATE_11"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_11"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		cAnimate( EventMemory["ForasChief"]["Handle"], "start", FORAS_CHIEF["ANIMATION"] )
		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + ANIMATION_CHECK_TIME

		EventMemory["EventState"] = ES_STATE["STATE_12"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_12"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local LockInfo


		LockInfo = EventMemory["EventData"]["LockList"][EventMemory["EventNumber"]]

		cDoorAction( LockInfo["Handle"], LockInfo["Index"], "open" )

		EventMemory["EventState"] = ES_STATE["STATE_13"]

		cAnimate( EventMemory["ForasChief"]["Handle"], "stop" )

		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CameraMove"]["CheckTime"] + 2

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_13"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )


		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["DoorCheckTime"] 	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME
		EventMemory["EventState"] 		= ES_STATE["STATE_14"]

		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + 6

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_14"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local DoorInfo


		DoorInfo = EventMemory["EventData"]["DoorList"][EventMemory["EventNumber"]]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )


		EventMemory["EventState"] = ES_STATE["STATE_15"]


		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_15"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		EventMemory["EventState"] = ES_STATE["STATE_16"]

		CameraMove( EventMemory )

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_16"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["ForasChief"]["FC_STATE"] = FC_STATE["FOLLOW"]

		FaceCut( EventMemory )

		return EVENT_ROUTINE_END

	end

end


function EVENT_ROUTINE_2( EventMemory )
cExecCheck( "EVENT_ROUTINE_2" )

	if EventMemory == nil then

		return

	end


	if EventMemory["EventNumber"] ~= 2 then

		return

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		FaceCut( EventMemory )
		FaceCut( EventMemory )

		local EventData
		local EventDevildomData
		local EventSDevildomData


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventDevildomData 	= EventData["EVENT_DEVILDOM"]
		EventSDevildomData 	= EventData["EVENT_SDEVILDOM"]


		local PlayerList
		local PlayerAggroList 	= { }
		local Count				= 1


		PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i = 1, #PlayerList do

			local CurPlayerPos		= { }
			local DevildomPos


			CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )
			DevildomPos 							= EventDevildomData["REGEN_POSITION"]

			if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( SEARCH_RANGE * SEARCH_RANGE ) then

				PlayerAggroList[Count] = PlayerList[i]
				Count = Count + 1

			end

		end

		local EventDevildomList 	= { }


		for i = 1, EventDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventDevildom			= { }


			EventDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventDevildomData["MOBINDEX"],
												EventDevildomData["REGEN_POSITION"]["X"], EventDevildomData["REGEN_POSITION"]["Y"], EventDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventDevildom["Handle"] )
				cAIScriptFunc	( EventDevildom["Handle"], "Entrance", "EVENT_2_REGEN_DEVILDOM_ROUTINE" )

				EventDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventDevildom["MS_STATE"] 					= MONSTER_STATE["AGGRO"]
				PlayerHandle 								= cRandomInt(1, #PlayerAggroList)
				EventDevildom["AggroPlayer"] 				= PlayerAggroList[PlayerHandle]

				EventDevildomList[EventDevildom["Handle"]] 	= EventDevildom

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventDevildomList"] = EventDevildomList


		local EventSDevildomList 	= { }


		for i = 1, EventSDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventSDevildom		= { }


			EventSDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventSDevildomData["MOBINDEX"],
												EventSDevildomData["REGEN_POSITION"]["X"], EventSDevildomData["REGEN_POSITION"]["Y"], EventSDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventSDevildom["Handle"]  ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventSDevildom["Handle"] )
				cAIScriptFunc	( EventSDevildom["Handle"], "Entrance", "EVENT_2_REGEN_SDEVILDOM_ROUTINE" )

				EventSDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventSDevildom["MS_STATE"] 						= MONSTER_STATE["AGGRO"]
				PlayerHandle 									= cRandomInt(1, #PlayerAggroList)
				EventSDevildom["AggroPlayer"] 					= PlayerAggroList[PlayerHandle]

				EventSDevildomList[EventSDevildom["Handle"]] 	= EventSDevildom

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventSDevildomList"] = EventSDevildomList
		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		local EventData
		local DevildomList

		local EventDevildomList
		local EventSDevildomList
		local SCtrie
		local SFocalor
		local SRangeList
		local HighDevildomList

		EventData 			= EventMemory["EventData"]

		DevildomList		= EventData[EventMemory["EventNumber"]]["DevildomList"]
		EventDevildomList	= EventData[EventMemory["EventNumber"]]["EventDevildomList"]
		EventSDevildomList	= EventData[EventMemory["EventNumber"]]["EventSDevildomList"]
		SCtrieList			= EventData[EventMemory["EventNumber"]]["SCtrieList"]
		SFocalor			= EventData[EventMemory["EventNumber"]]["SFocalor"]
		SRangeList			= EventData[EventMemory["EventNumber"]]["SRangeList"]
		HighDevildomList	= EventData["HighDevildomList"]


		if next( DevildomList ) ~= nil or next( EventDevildomList ) ~= nil or next( EventSDevildomList ) ~= nil or next( SCtrieList ) ~= nil or next( HighDevildomList ) ~= nil or next( SRangeList ) then

			return

		end

		if SFocalor ~= nil then

			return

		end

		EventMemory["ForasChief"] = nil
		EventMemory["EventState"] = ES_STATE["STATE_4"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		local PlayerList
		local ForasChiefPosition
		local ForasChief 		= { }


		PlayerList			= { cGetPlayerList( EventMemory["MapIndex"] ) }
		ForasChiefPosition	= FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]

		ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FORAS_CHIEF["MOBINDEX"],
											ForasChiefPosition["START_POS"]["X"], ForasChiefPosition["START_POS"]["Y"], ForasChiefPosition["START_POS"]["DIR"] )

		if ForasChief["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
			cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEF_ROUTINE" )
			cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 99999999 )

			ForasChief["FC_STATE"] 	= FC_STATE["MOVE"]
			ForasChief["CheckTime"]	= EventMemory["CurrentTime"]

			if PlayerList[1] ~= nil then

				ForasChief["MasterPlayer"]	= PlayerList[1]

			end

		end

		EventMemory["ForasChief"] = ForasChief
		EventMemory["EventState"] = ES_STATE["STATE_5"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]


		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2
		EventMemory["EventState"] = ES_STATE["STATE_6"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_6"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["EventState"] = ES_STATE["STATE_7"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_7"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_8"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_8"] then

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2

		EventMemory["EventState"] = ES_STATE["STATE_9"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_9"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		FaceCut( EventMemory )

		cAnimate( EventMemory["ForasChief"]["Handle"], "start", FORAS_CHIEF["ANIMATION"] )
		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + ANIMATION_CHECK_TIME

		EventMemory["EventState"] = ES_STATE["STATE_10"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_10"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local LockInfo


		LockInfo = EventMemory["EventData"]["LockList"][EventMemory["EventNumber"]]
		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + 2
		cAnimate( EventMemory["ForasChief"]["Handle"], "stop" )
		cDoorAction( LockInfo["Handle"], LockInfo["Index"], "open" )

		EventMemory["EventState"] = ES_STATE["STATE_11"]


		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_11"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )


		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["DoorCheckTime"] 	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME
		EventMemory["EventState"] 		= ES_STATE["STATE_12"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_12"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local DoorInfo


		DoorInfo = EventMemory["EventData"]["DoorList"][EventMemory["EventNumber"]]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + 2

		EventMemory["EventState"] = ES_STATE["STATE_13"]


		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_13"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 1

		EventMemory["EventState"] = ES_STATE["STATE_14"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_14"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["ForasChief"]["FC_STATE"] = FC_STATE["FOLLOW"]

		FaceCut( EventMemory )

		return EVENT_ROUTINE_END

	end


end

function EVENT_ROUTINE_3( EventMemory )
cExecCheck( "EVENT_ROUTINE_3" )

	if EventMemory == nil then

		return

	end


	if EventMemory["EventNumber"] ~= 3 then

		return

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		FaceCut( EventMemory )
		FaceCut( EventMemory )

		local EventData
		local EventDevildomData
		local EventSDevildomData


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventDevildomData 	= EventData["EVENT_DEVILDOM"]
		EventSDevildomData 	= EventData["EVENT_IDEVILDOM"]


		local PlayerList
		local PlayerAggroList 	= { }
		local Count			= 1


		PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i = 1, #PlayerList do

			local CurPlayerPos		= { }
			local DevildomPos


			CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )
			DevildomPos 							= EventDevildomData["REGEN_POSITION"]

			if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( SEARCH_RANGE * SEARCH_RANGE ) then

				PlayerAggroList[Count] = PlayerList[i]
				Count = Count + 1

			end

		end

		local EventDevildomList 	= { }


		for i = 1, EventDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventDevildom			= { }


			EventDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventDevildomData["MOBINDEX"],
												EventDevildomData["REGEN_POSITION"]["X"], EventDevildomData["REGEN_POSITION"]["Y"], EventDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventDevildom["Handle"] )
				cAIScriptFunc	( EventDevildom["Handle"], "Entrance", "EVENT_2_REGEN_DEVILDOM_ROUTINE" )

				EventDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventDevildom["MS_STATE"] 					= MONSTER_STATE["AGGRO"]
				PlayerHandle 								= cRandomInt(1, #PlayerAggroList)
				EventDevildom["AggroPlayer"] 				= PlayerAggroList[PlayerHandle]

				EventDevildomList[EventDevildom["Handle"]] 	= EventDevildom

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventDevildomList"] = EventDevildomList


		local EventSDevildomList 	= { }


		for i = 1, EventSDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventSDevildom		= { }


			EventSDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventSDevildomData["MOBINDEX"],
												EventSDevildomData["REGEN_POSITION"]["X"], EventSDevildomData["REGEN_POSITION"]["Y"], EventSDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventSDevildom["Handle"]  ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventSDevildom["Handle"] )
				cAIScriptFunc	( EventSDevildom["Handle"], "Entrance", "EVENT_2_REGEN_SDEVILDOM_ROUTINE" )

				EventSDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventSDevildom["MS_STATE"] 						= MONSTER_STATE["AGGRO"]
				PlayerHandle 									= cRandomInt(1, #PlayerAggroList)
				EventSDevildom["AggroPlayer"] 					= PlayerAggroList[PlayerHandle]

				EventSDevildomList[EventSDevildom["Handle"]] 	= EventSDevildom

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventSDevildomList"] = EventSDevildomList
		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		local EventData
		local DevildomList
		local EventDevildomList
		local EventSDevildomList
		local SCtrieList
		local SFocalor
		local SRangeList
		local HighDevildomList


		EventData 			= EventMemory["EventData"]

		DevildomList		= EventData[EventMemory["EventNumber"]]["DevildomList"]
		EventDevildomList	= EventData[EventMemory["EventNumber"]]["EventDevildomList"]
		EventSDevildomList	= EventData[EventMemory["EventNumber"]]["EventSDevildomList"]
		SCtrieList			= EventData[EventMemory["EventNumber"]]["SCtrieList"]
		SFocalor			= EventData[EventMemory["EventNumber"]]["SFocalor"]
		SRangeList				= EventData[EventMemory["EventNumber"]]["SRangeList"]
		HighDevildomList	= EventData["HighDevildomList"]

		if next( DevildomList ) ~= nil or next( EventDevildomList ) ~= nil or next( EventSDevildomList ) ~= nil or next( SCtrieList ) ~= nil or next( HighDevildomList ) ~= nil or next( SRangeList ) then

			return

		end

		if  SFocalor ~= nil then

			return

		end

		EventMemory["EventState"] = ES_STATE["STATE_4"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		local EventData
		local EventMeleeData
		local Melee = { }

		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventMeleeData 		= EventData["EVENT_IMELEE"]


		Melee["Handle"] 	= cMobRegen_XY( EventMemory["MapIndex"], EventMeleeData["MOBINDEX"],
												EventMeleeData["REGEN_POSITION"]["X"], EventMeleeData["REGEN_POSITION"]["Y"], EventMeleeData["REGEN_POSITION"]["DIR"] )

		if Melee["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Melee["Handle"] )
			cAIScriptFunc	( Melee["Handle"], "Entrance", "EVENT_3_MELEE_ROUTINE" )
			cSetAbstate		( Melee["Handle"], STA_MELEEATTACK, 1, 99999999 )

			Melee["State"]	= MONSTER_STATE["CAMERA"]

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["Melee"] = Melee

		EventMemory["EventState"] = ES_STATE["STATE_5"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		local MeleeData


		MeleeData = EVNET_DATA[EventMemory["EventNumber"]]["EVENT_IMELEE"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= MeleeData["REGEN_POSITION"]["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= MeleeData["REGEN_POSITION"]["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( MeleeData["REGEN_POSITION"]["DIR"] + 140 )

		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_6"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_6"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		CameraMove( EventMemory )

		EventMemory["EventData"][EventMemory["EventNumber"]]["Melee"]["State"]	= MONSTER_STATE["NORMAL"]

		EventMemory["EventState"] = ES_STATE["STATE_7"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_7"] then

		if EventMemory["EventData"][EventMemory["EventNumber"]]["Melee"] ~= nil then

			return

		end

		EventMemory["ForasChief"] = nil
		EventMemory["EventState"] = ES_STATE["STATE_8"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_8"] then

		local PlayerList
		local ForasChiefPosition
		local ForasChief 		= { }


		PlayerList			= { cGetPlayerList( EventMemory["MapIndex"] ) }
		ForasChiefPosition	= FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]

		ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FORAS_CHIEF["MOBINDEX"],
											ForasChiefPosition["START_POS"]["X"], ForasChiefPosition["START_POS"]["Y"], ForasChiefPosition["START_POS"]["DIR"] )

		if ForasChief["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
			cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEF_ROUTINE" )
			cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 99999999 )

			ForasChief["FC_STATE"] 	= FC_STATE["MOVE"]
			ForasChief["CheckTime"]	= EventMemory["CurrentTime"]

			if PlayerList[1] ~= nil then

				ForasChief["MasterPlayer"]	= PlayerList[1]

			end

		end

		EventMemory["ForasChief"] = ForasChief
		EventMemory["EventState"] = ES_STATE["STATE_9"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_9"] then

		local FocusPosition


		FocusPosition = FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]["END_POS"]


		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= FocusPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= FocusPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( FocusPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2
		EventMemory["EventState"] 			= ES_STATE["STATE_10"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_10"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_11"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_11"] then

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_12"]

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_12"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		cAnimate( EventMemory["ForasChief"]["Handle"], "start", FORAS_CHIEF["ANIMATION"] )
		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + ANIMATION_CHECK_TIME

		EventMemory["EventState"] = ES_STATE["STATE_13"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_13"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local LockInfo


		LockInfo = EventMemory["EventData"]["LockList"][EventMemory["EventNumber"]]

		cDoorAction( LockInfo["Handle"], LockInfo["Index"], "open" )
		cAnimate( EventMemory["ForasChief"]["Handle"], "stop" )
		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + 2

		EventMemory["EventState"] = ES_STATE["STATE_14"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_14"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["DoorCheckTime"] 	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME
		EventMemory["EventState"] 		= ES_STATE["STATE_15"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_15"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local DoorInfo


		DoorInfo = EventMemory["EventData"]["DoorList"][EventMemory["EventNumber"]]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

		EventMemory["EventState"] = ES_STATE["STATE_16"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_16"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_17"]

		EventMemory["FaceCut"]["CheckTime"] = EventMemory["CurrentTime"] + 1

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_17"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["ForasChief"]["FC_STATE"] = FC_STATE["FOLLOW"]

		FaceCut( EventMemory )

		return EVENT_ROUTINE_END

	end

end


function EVENT_ROUTINE_4( EventMemory )
cExecCheck( "EVENT_ROUTINE_4" )

	if EventMemory == nil then

		return

	end


	if EventMemory["EventNumber"] ~= 4 then

		return

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		FaceCut( EventMemory )
		FaceCut( EventMemory )

		local EventData
		local EventDevildomData
		local EventSDevildomData


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventDevildomData 	= EventData["EVENT_DEVILDOM"]
		EventSDevildomData 	= EventData["EVENT_FDEVILDOM"]


		local PlayerList
		local PlayerAggroList 	= { }
		local Count				= 1


		PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i = 1, #PlayerList do

			local CurPlayerPos		= { }
			local DevildomPos


			CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )
			DevildomPos 							= EventDevildomData["REGEN_POSITION"]

			if cDistanceSquar( DevildomPos["X"], DevildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( SEARCH_RANGE * SEARCH_RANGE ) then

				PlayerAggroList[Count] = PlayerList[i]
				Count = Count + 1

			end

		end

		local EventDevildomList 	= { }


		for i = 1, EventDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventDevildom			= { }


			EventDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventDevildomData["MOBINDEX"],
												EventDevildomData["REGEN_POSITION"]["X"], EventDevildomData["REGEN_POSITION"]["Y"], EventDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventDevildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventDevildom["Handle"] )
				cAIScriptFunc	( EventDevildom["Handle"], "Entrance", "EVENT_2_REGEN_DEVILDOM_ROUTINE" )

				EventDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventDevildom["MS_STATE"] 					= MONSTER_STATE["AGGRO"]
				PlayerHandle 								= cRandomInt(1, #PlayerAggroList)
				EventDevildom["AggroPlayer"] 				= PlayerAggroList[PlayerHandle]

				EventDevildomList[EventDevildom["Handle"]] 	= EventDevildom

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventDevildomList"] = EventDevildomList


		local EventSDevildomList 	= { }


		for i = 1, EventSDevildomData["MOBCOUNT"] do

			local PlayerHandle
			local EventSDevildom		= { }


			EventSDevildom["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], EventSDevildomData["MOBINDEX"],
												EventSDevildomData["REGEN_POSITION"]["X"], EventSDevildomData["REGEN_POSITION"]["Y"], EventSDevildomData["REGEN_POSITION"]["RADIUS"] )

			if EventSDevildom["Handle"]  ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventSDevildom["Handle"] )
				cAIScriptFunc	( EventSDevildom["Handle"], "Entrance", "EVENT_2_REGEN_SDEVILDOM_ROUTINE" )

				EventSDevildom["CheckTime"] 					= EventMemory["CurrentTime"]
				EventSDevildom["MS_STATE"] 						= MONSTER_STATE["AGGRO"]
				PlayerHandle 									= cRandomInt(1, #PlayerAggroList)
				EventSDevildom["AggroPlayer"] 					= PlayerAggroList[PlayerHandle]

				EventSDevildomList[EventSDevildom["Handle"]] 	= EventSDevildom

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventSDevildomList"] = EventSDevildomList
		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		local EventData
		local DevildomList
		local EventDevildomList
		local EventSDevildomList
		local SCtrieList
		local SFocalor
		local SRangeList
		local HighDevildomList

		EventData 			= EventMemory["EventData"]

		DevildomList		= EventData[EventMemory["EventNumber"]]["DevildomList"]
		EventDevildomList	= EventData[EventMemory["EventNumber"]]["EventDevildomList"]
		EventSDevildomList	= EventData[EventMemory["EventNumber"]]["EventSDevildomList"]
		SCtrieList			= EventData[EventMemory["EventNumber"]]["SCtrieList"]
		SFocalor			= EventData[EventMemory["EventNumber"]]["SFocalor"]
		SRangeList			= EventData[EventMemory["EventNumber"]]["SRangeList"]
		HighDevildomList	= EventData["HighDevildomList"]

		if next( DevildomList ) ~= nil or next( EventDevildomList ) ~= nil or next( EventSDevildomList ) ~= nil or next( SRangeList ) ~= nil or next( SCtrieList ) ~= nil or next( HighDevildomList ) ~= nil then

			return

		end

		if SFocalor ~= nil then

			return

		end

		EventMemory["ForasChief"] = nil
		EventMemory["EventState"] = ES_STATE["STATE_4"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		local EventData
		local EventMeleeData


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		EventMeleeData 		= EventData["EVENT_FMELEE"]


		local EventMeleeList	= { }


		for i = 1, #EventMeleeData["REGEN_POSITION"] do

			local EventMelee = { }

			EventMelee["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], EventMeleeData["MOBINDEX"],
												EventMeleeData["REGEN_POSITION"][i]["X"], EventMeleeData["REGEN_POSITION"][i]["Y"], EventMeleeData["REGEN_POSITION"][i]["DIR"] )

			if EventMelee["Handle"]  ~= nil then

				cSetAIScript	( SCRIPT_MAIN, EventMelee["Handle"] )
				cAIScriptFunc	( EventMelee["Handle"], "Entrance", "EVENT_TWINS_MELEE_ROUTINE" )
				cSetAbstate		( EventMelee["Handle"], STA_MELEEATTACK, 1, 99999999 )

				EventMelee["CheckTime"] 		= EventMemory["CurrentTime"]
				EventMelee["MS_STATE"] 			= MS_STATE["CAMERA"]
				EventMelee["SummonCheckTime"]	= 0

				EventMeleeList[EventMelee["Handle"]] = EventMelee

			end

		end

		EventMemory["EventData"][EventMemory["EventNumber"]]["EventMeleeList"] = EventMeleeList

		EventMemory["EventState"] = ES_STATE["STATE_5"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		local MeleeData


		MeleeData = EVNET_DATA[EventMemory["EventNumber"]]["EVENT_FMELEE"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= MeleeData["REGEN_POSITION"][1]["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= MeleeData["REGEN_POSITION"][1]["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( MeleeData["REGEN_POSITION"][1]["DIR"] + 180 )

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 1

		EventMemory["EventState"] = ES_STATE["STATE_6"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_6"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_7"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_7"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		CameraMove( EventMemory )


		for index, value in pairs( EventMemory["EventData"][EventMemory["EventNumber"]]["EventMeleeList"] ) do

			value["MS_STATE"] = MS_STATE["NORMAL"]

		end


		EventMemory["EventState"] = ES_STATE["STATE_8"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_8"] then

		local MeleeList


		MeleeList		= EventMemory["EventData"][EventMemory["EventNumber"]]["EventMeleeList"]

		if next( MeleeList )~= nil then

			return

		end

		EventMemory["ForasChief"] = nil
		EventMemory["EventState"] = ES_STATE["STATE_9"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_9"] then

		local PlayerList
		local ForasChiefPosition
		local ForasChief 	= { }


		PlayerList			= { cGetPlayerList( EventMemory["MapIndex"] ) }
		ForasChiefPosition	= FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]

		ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FORAS_CHIEF["MOBINDEX"],
											ForasChiefPosition["START_POS"]["X"], ForasChiefPosition["START_POS"]["Y"], ForasChiefPosition["START_POS"]["DIR"] )

		if ForasChief["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
			cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEF_ROUTINE" )
			cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 99999999 )

			ForasChief["FC_STATE"] 	= FC_STATE["MOVE"]
			ForasChief["CheckTime"]	= EventMemory["CurrentTime"]

			if PlayerList[1] ~= nil then

				ForasChief["MasterPlayer"]	= PlayerList[1]

			end

		end

		EventMemory["ForasChief"] = ForasChief
		EventMemory["EventState"] = ES_STATE["STATE_10"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_10"] then

		local FocusPosition


		FocusPosition = FORAS_CHIEF["EVENT_POSITION"][EventMemory["EventNumber"]]["END_POS"]


		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= FocusPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= FocusPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( FocusPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 2
		EventMemory["EventState"] = ES_STATE["STATE_11"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_11"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		EventMemory["EventState"] = ES_STATE["STATE_12"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_12"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_13"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_13"] then

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 1

		EventMemory["EventState"] = ES_STATE["STATE_14"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_14"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		FaceCut( EventMemory )

		cAnimate( EventMemory["ForasChief"]["Handle"], "start", FORAS_CHIEF["ANIMATION"] )
		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + ANIMATION_CHECK_TIME

		EventMemory["EventState"] = ES_STATE["STATE_15"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_15"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local LockInfo


		LockInfo = EventMemory["EventData"]["LockList"][EventMemory["EventNumber"]]

		cDoorAction( LockInfo["Handle"], LockInfo["Index"], "open" )
		cAnimate( EventMemory["ForasChief"]["Handle"], "stop" )
		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + 3

		EventMemory["EventState"] = ES_STATE["STATE_16"]

		return


	elseif EventMemory["EventState"] == ES_STATE["STATE_16"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]
		CameraMove( EventMemory )

		local DoorPosition


		DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["DoorCheckTime"] 	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME
		EventMemory["EventState"] 		= ES_STATE["STATE_17"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_17"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local DoorInfo


		DoorInfo = EventMemory["EventData"]["DoorList"][EventMemory["EventNumber"]]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

		EventMemory["EventState"] = ES_STATE["STATE_18"]


		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_18"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + 1

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_19"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_19"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["ForasChief"]["FC_STATE"] = FC_STATE["FOLLOW"]

		FaceCut( EventMemory )

		return EVENT_ROUTINE_END

	end


end


function EVENT_ROUTINE_5( EventMemory )
cExecCheck( "EVENT_ROUTINE_5" )

	if EventMemory == nil then

		return

	end


	if EventMemory["EventNumber"] ~= 5 then

		return

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		if EventMemory["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		EventMemory["CheckTime"] = EventMemory["CurrentTime"] + 1

		if cGetAreaObjectList( EventMemory["MapIndex"], "Area02", ObjectType["Player"] ) == nil then

			return

		end

		EventMemory["EventState"] = ES_STATE["STATE_2"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		local AvanasPosition


		AvanasPosition = EVNET_DATA[EventMemory["EventNumber"]]["FAVANAS"]["REGEN_POSITION"]

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= AvanasPosition["X"]
		EventMemory["CameraMove"]["Focus"]["Y"] 	= AvanasPosition["Y"]
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( AvanasPosition["DIR"] + 180 )

		EventMemory["CheckTime"] = EventMemory["CurrentTime"] + 1

		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		if EventMemory["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cAnimate( EventMemory["EventData"][EventMemory["EventNumber"]]["Avanas"]["Handle"], "start", "SW_FAvanas_Skill01_W_SS" )
		-- 스킬애니메이션

		EventMemory["EventState"] = ES_STATE["STATE_4"]
		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + 4

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

		CameraMove( EventMemory )

		EventMemory["EventData"][EventMemory["EventNumber"]]["Avanas"]["MS_STATE"] = MS_STATE["NORMAL"]
		EventMemory["EventState"] = ES_STATE["STATE_5"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		if EventMemory["EventData"][EventMemory["EventNumber"]]["Avanas"] == nil then

			EventMemory["EventState"] 						= ES_STATE["STATE_6"]
			EventMemory["EventData"]["RegenMonsterList"]	= nil
			EventMemory["EventData"]["BombList"]			= nil
			EventMemory["EventData"][EventMemory["EventNumber"]]["AvanasGate"] = nil

			return

		end


		if EventMemory["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		EventMemory["CheckTime"] = EventMemory["CurrentTime"] + 1


		cSetAbstateInArea( EventMemory["MapIndex"], "StaBRNWarH", 1, 1000, "WarH_BossRoom", 22255, 12636 )

-- 어그로 있을 때만 수행
		local Avanas


		Avanas = EventMemory["EventData"][EventMemory["EventNumber"]]["Avanas"]

		if cAggroListSize( Avanas["Handle"] ) == 0 then

			return

		end

		RegenBomb( EventMemory )

		if EventMemory["MonsterRegenTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["MonsterRegenTime"] = EventMemory["CurrentTime"] + 60


		local EventData 		= { }
		local FavanasGateData	= { }


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		FavanasGateData		= EventData["FAVANAS_GATE"]


		local RandomInt
		local AvanasGate = { }


		RandomInt = cRandomInt( 1, #FavanasGateData["REGEN_POSITION"] )
		AvanasGate["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], FavanasGateData["MOBINDEX"],
											FavanasGateData["REGEN_POSITION"][RandomInt]["X"], FavanasGateData["REGEN_POSITION"][RandomInt]["Y"], FavanasGateData["REGEN_POSITION"][RandomInt]["DIR"] )

		if AvanasGate["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, AvanasGate["Handle"] )
			cAIScriptFunc	( AvanasGate["Handle"], "Entrance", "EVENT_AVANASGATE_ROUTINE" )

			AvanasGate["RegenNumber"] 	= 1
			AvanasGate["RegenTime"] 	= 1

			AvanasGate["RegenPosition"] 		= { }
			AvanasGate["RegenPosition"]["X"] 	= FavanasGateData["REGEN_POSITION"][RandomInt]["X"]
			AvanasGate["RegenPosition"]["Y"] 	= FavanasGateData["REGEN_POSITION"][RandomInt]["Y"]
			AvanasGate["RegenPosition"]["DIR"] 	= FavanasGateData["REGEN_POSITION"][RandomInt]["DIR"]

			EventMemory["EventData"][EventMemory["EventNumber"]]["AvanasGate"] = AvanasGate

		end

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_6"] then

		FaceCut( EventMemory )

		return EVENT_ROUTINE_END

	end

end



function EVENT_ROUTINE_6( EventMemory )
cExecCheck( "EVENT_ROUTINE_6" )

	if EventMemory == nil then

		return

	end


	if EventMemory["EventNumber"] ~= 6 then

		return

	end

	if EventMemory["AreaStateCheckTime"] < EventMemory["CurrentTime"] then

		cSetAbstateInArea( EventMemory["MapIndex"], "StaBRNWarH", 1, 1000, "WarH_BossRoom", 22255, 12636 )

		EventMemory["AreaStateCheckTime"] = EventMemory["CurrentTime"] + 1

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_2"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_4"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_5"]

		return


	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_6"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_6"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_7"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_7"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_8"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_8"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_9"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_9"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_10"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_10"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cLinkToAll( EventMemory["MapIndex"], GATE_DATA["END_GATE"]["LINK"]["FIELD"], GATE_DATA["END_GATE"]["LINK"]["X"], GATE_DATA["END_GATE"]["LINK"]["Y"] )

		return EVENT_ROUTINE_END

	end


end

function EVENT_ROUTINE_7( EventMemory )
cExecCheck( "EVENT_ROUTINE_7" )

end

EVENT_ROUTINE = { }

EVENT_ROUTINE[1] = EVENT_ROUTINE_1
EVENT_ROUTINE[2] = EVENT_ROUTINE_2
EVENT_ROUTINE[3] = EVENT_ROUTINE_3
EVENT_ROUTINE[4] = EVENT_ROUTINE_4
EVENT_ROUTINE[5] = EVENT_ROUTINE_5
EVENT_ROUTINE[6] = EVENT_ROUTINE_6
EVENT_ROUTINE[7] = EVENT_ROUTINE_7
