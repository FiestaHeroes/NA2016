require( "ID/WarLH/WarLHData" )



function EVENT_NO1_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO1_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 1 then

		return

	end

	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]


	if EventState == ES_STATE["State1"] then

		return

	elseif EventState == ES_STATE["State2"] then

		return EVENT_ROUTINE_END

	end

end


function EVENT_NO2_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO2_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 2 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]


	if EventState == ES_STATE["State1"] then

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State2"]
		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + 1

		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local ForasChief	= { }


		ForasChief		= EventMemory["ForasChief"]
		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[2]["FACECUT"], DIALOGINFO[2]["FILENAME"], DIALOGINFO[2]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State3"]


		return

	elseif EventState == ES_STATE["State3"] then

		cNotice( EventMemory["MapIndex"], NOTICEINFO[1]["FILENAME"], NOTICEINFO[1]["INDEX"] )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		local DavildomList


		DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

		for index, value in pairs( DavildomList ) do

			return

		end


		cNotice( EventMemory["MapIndex"], NOTICEINFO[2]["FILENAME"], NOTICEINFO[2]["INDEX"] )

		return EVENT_ROUTINE_END

	end

end


function EVENT_NO3_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO3_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 3 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]


	if EventState == ES_STATE["State1"] then

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State2"]

		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + 2

		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[3]["FACECUT"], DIALOGINFO[3]["FILENAME"], DIALOGINFO[3]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State3"]

		return

	elseif EventState == ES_STATE["State3"] then

		cNotice( EventMemory["MapIndex"], NOTICEINFO[1]["FILENAME"], NOTICEINFO[1]["INDEX"] )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		local DavildomList


		DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

		for index, value in pairs( DavildomList ) do

			return

		end

		cNotice( EventMemory["MapIndex"], NOTICEINFO[2]["FILENAME"], NOTICEINFO[2]["INDEX"] )
		EventMemory["DialogCheckTime"] 	= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State5"]


		return

	elseif EventState == ES_STATE["State5"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["DialogCheckTime"] = EventMemory["CurrentTime"] + DIALOGINFO[2]["DELAY"]

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[4]["FACECUT"], DIALOGINFO[4]["FILENAME"], DIALOGINFO[4]["INDEX"] )
		EventMemory["DialogCheckTime"] = EventMemory["CurrentTime"] + DIALOGINFO[4]["DELAY"]

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State7"]

		return


	elseif EventState == ES_STATE["State7"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList
		local DoorLocation		= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		DoorLocation = DOOR_BLOCK_DATA[1]["REGEN_POSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (DoorLocation["DIR"] + 180) * (-1)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], DoorLocation["X"], DoorLocation["Y"], tmpdir, DOOR1_CAMERAMOVE["AngleY"], DOOR1_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 	= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"] + 2
		EventMemory["DoorCheckTime"]	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State8"]

		return


	elseif EventState == ES_STATE["State8"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["DoorCheckTime"]  = nil


		local DoorInfo


		DoorInfo = EventMemory["DoorList"][1]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State9"]

		return

	elseif EventState == ES_STATE["State9"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )
		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State7"]


		return EVENT_ROUTINE_END

	end

end


function EVENT_NO4_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO4_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 4 then

		return

	end


	if EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenCheckTime"] > EventMemory["CurrentTime"] then

		return

	end



	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	if EventState == ES_STATE["State1"] then

		local EventData			= { }
		local DavildomData		= { }
		local PlayerAggroList 	= { }
		local PlayerList
		local Count				= 1

		EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
		DavildomData 	= EventData["DAVILDOM"]

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


		local Davildom = { }


		Davildom["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											   DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], 0 )

		if Davildom["Handle"] ~= nil then

			local PlayerHandle


			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO4_DAVILDOM_ROUTINE" )


			Davildom["AggroDistance"]	= DavildomData["AGGRO_DISTANCE"]
			Davildom["D_State"] 		= D_STATE["Aggro"]
			Davildom["CheckTime"]		= EventMemory["CurrentTime"] + 1
			PlayerHandle 				= cRandomInt(1, #PlayerAggroList)
			Davildom["AggroPlayer"] 	= PlayerAggroList[PlayerHandle]

		end

		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Davildom["Handle"]] = Davildom
		EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenDavildomCount"] = EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenDavildomCount"] + 1


		if EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenDavildomCount"] > DavildomData["MOBCOUNT"] then
			EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State2"]
		end

		EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenCheckTime"] = EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenCheckTime"] + DavildomData["DELAYTIME"]

		return

	elseif EventState == ES_STATE["State2"] then

		local DavildomList


		DavildomList = EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]

		for index, value in pairs (DavildomList) do

			return

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State3"]

		return

	elseif EventState == ES_STATE["State3"] then

		local PlayerList
		local EventData			= { }
		local BrainWashData		= { }
		local BrainWashPosition	= { }


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end

		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		BrainWashData		= EventData["BRAINWASH"]
		BrainWashPosition 	= BrainWashData["REGENPOSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (BrainWashPosition["DIR"] + 180)

		tmpdir = tmpdir % 360

		cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE["AngleY"], BRAINWASH_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DialogCheckTime"] 							= EventMemory["CurrentTime"] + 1
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[6]["FACECUT"], DIALOGINFO[6]["FILENAME"], DIALOGINFO[6]["INDEX"] )

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State5"]

		return

	elseif EventState == ES_STATE["State5"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil
		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )


		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		local PlayerList
		local EventData			= { }


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (LINE_DATA["LEFT_POSITION"]["DIR"] + 180) * (-1)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], LINE_DATA["LEFT_POSITION"]["X"], LINE_DATA["LEFT_POSITION"]["Y"], tmpdir,LINE_CAMERAMOVE["AngleY"], LINE_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DialogCheckTime"] 							= EventMemory["CurrentTime"] + 1
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State7"]

		return

	elseif EventState == ES_STATE["State7"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State8"]

		return

	elseif EventState == ES_STATE["State8"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil
		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )


		return EVENT_ROUTINE_END

	end

end


function EVENT_NO5_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO5_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 5 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	if EventState == ES_STATE["State1"] then

		local PlayerList
		local DoorLocation		= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		DoorLocation = DOOR_BLOCK_DATA[2]["REGEN_POSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (DoorLocation["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], DoorLocation["X"], DoorLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 	= EventMemory["CurrentTime"] + 8
		EventMemory["DoorCheckTime"]	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME
		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State2"]

		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["DoorCheckTime"]  = nil


		local DoorInfo

		DoorInfo = EventMemory["DoorList"][2]
		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )
		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State3"]

		return

	elseif EventState == ES_STATE["State3"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] == RS_STATE["Aggro"] then

			return

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State5"]

		return

	elseif EventState == ES_STATE["State5"] then

		local PlayerList
		local PoreLocation		= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (PoreLocation["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State6"]

		cNotice( EventMemory["MapIndex"], NOTICEINFO[3]["FILENAME"], NOTICEINFO[3]["INDEX"] )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end


		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State7"]

		return



	elseif EventState == ES_STATE["State7"] then


		local DavildomList
		local ForasList


		DavildomList 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]
		ForasList 		= EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"]


		if (next( DavildomList ) == nil) and (next(ForasList) == nil) then

			local PlayerList


			PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }
			for i=1, #PlayerList do

				cStaticDamage( PlayerList[i], STATICDAMAGE )

			end

		else

			return

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State8"]

		return

	elseif EventState == ES_STATE["State8"] then


		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"]  ~= PR_STATE["Damage1"] then

				return

			end


			local PlayerList
			local PoreLocation		= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT, 1, 99999999 )

			PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (PoreLocation["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State9"]


		return

	elseif EventState == ES_STATE["State9"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local Pore
		local PlayerList
		local Damage


		Pore	 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]

		if Pore ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( Pore["Handle"], Pore["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State10"]

		return

	elseif EventState == ES_STATE["State10"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			cResetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State11"]

		return

	elseif EventState == ES_STATE["State11"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"]  ~= PR_STATE["Damage2"] then

				return

			end


			local PlayerList
			local PoreLocation		= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT, 1, 99999999 )

			PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (PoreLocation["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State12"]

		return


	elseif EventState == ES_STATE["State12"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local Pore
		local PlayerList
		local Damage


		Pore	 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]
		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }

		if Pore ~= nil then

			cDamaged( Pore["Handle"], Pore["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State13"]

		return

	elseif EventState == ES_STATE["State13"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			cResetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State14"]

		return


	elseif EventState == ES_STATE["State14"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"]  ~= PR_STATE["Damage3"] then

				return

			end


			local PlayerList
			local PoreLocation		= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT, 1, 99999999 )

			PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (PoreLocation["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"] + 2
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State15"]

		return


	elseif EventState == ES_STATE["State15"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local Pore
		local PlayerList
		local Damage


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
		Pore	 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]

		if Pore ~= nil then

			cDamaged( Pore["Handle"], Pore["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State16"]

		return

	elseif EventState == ES_STATE["State16"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State17"]

		return

	elseif EventState == ES_STATE["State17"] then

		local DoorInfo
		local PlayerList
		local EventData			= { }


		DoorInfo = EventMemory["DoorList"][4]
		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )
		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (LINE_DATA["LEFT_POSITION"]["DIR"] + 180) * (-1)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], LINE_DATA["LEFT_POSITION"]["X"], LINE_DATA["LEFT_POSITION"]["Y"], tmpdir, LINE_CAMERAMOVE["AngleY"], LINE_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["ObjectDeleteTime"]							= EventMemory["CurrentTime"] + 3
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State18"]

		return

	elseif EventState == ES_STATE["State18"] then

		if EventMemory["ObjectDeleteTime"] > EventMemory["CurrentTime"] then

			return

		end

		-- 동력선 제거
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State19"]
		cMapObjectControl( EventMemory["MapIndex"], "L_Line", 0, 1 )
		EventMemory["ObjectState"]["L_Line"] = 0


		return

	elseif EventState == ES_STATE["State19"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cStaticDamage( PlayerList[i], 0 )
			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end


		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		return EVENT_ROUTINE_END

	end

end


function EVENT_NO6_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO6_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 6 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	if EventState == ES_STATE["State1"] then

		local PlayerList
		local EventData			= { }
		local CitrieData		= { }
		local CitriePosition	= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		CitrieData			= EventData["CITRIE"]
		CitriePosition 		= CitrieData["REGENPOSITION"]


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (CitriePosition["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], CitriePosition["X"], CitriePosition["Y"], tmpdir, CITRIE_CAMERAMOVE2["AngleY"], CITRIE_CAMERAMOVE2["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + 3
		EventMemory["DialogCheckTime"] 							= EventMemory["CurrentTime"] + 1
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State2"]


		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[5]["FACECUT"], DIALOGINFO[5]["FILENAME"], DIALOGINFO[5]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State3"]

		return

	elseif EventState == ES_STATE["State3"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList
		local EventData			= { }
		local CitrieData		= { }
		local CitriePosition	= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		CitrieData			= EventData["CITRIE"]
		CitriePosition 		= CitrieData["REGENPOSITION"]


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (CitriePosition["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], CitriePosition["X"], CitriePosition["Y"], tmpdir, CITRIE_CAMERAMOVE["AngleY"], CITRIE_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + 3
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State4"]


		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil
		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State5"]


		return

	elseif EventState == ES_STATE["State5"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"]["C_State"] == CT_STATE["Aggro"] then

			return

		end

		cNotice( EventMemory["MapIndex"], NOTICEINFO[1]["FILENAME"], NOTICEINFO[1]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] == nil then

			cNotice( EventMemory["MapIndex"], NOTICEINFO[2]["FILENAME"], NOTICEINFO[2]["INDEX"] )
			EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State7"]
			EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = nil

			return

		end


		if EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenTime"] > EventMemory["CurrentTime"] then

			return

		end

		local EventData			= { }
		local DavildomData		= { }
		local PlayerAggroList 	= { }
		local PlayerList
		local Count = 1


		EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
		DavildomData 	= EventData["DAVILDOM"]

		PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i = 1, #PlayerList do

			local CurPlayerPos		= { }
			local DavildomPos		= { }


			CurPlayerPos["X"], CurPlayerPos["Y"] = cObjectLocate( PlayerList[i] )
			DavildomPos 						 = DavildomData["REGENPOSITION"]

			if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( DavildomData["SEARCH_RANGE"] * DavildomData["SEARCH_RANGE"] ) then

				PlayerAggroList[Count] = PlayerList[i]
				Count = Count + 1

			end

		end


		local Davildom = { }


		Davildom["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											   DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], 0 )

		if Davildom["Handle"] ~= nil then

			local PlayerHandle


			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO6_DAVILDOM_ROUTINE" )


			Davildom["AggroDistance"]	= DavildomData["AGGRO_DISTANCE"]
			Davildom["D_State"] 		= D_STATE["Aggro"]
			Davildom["CheckTime"]		= EventMemory["CurrentTime"] + 1
			PlayerHandle 				= cRandomInt(1, #PlayerAggroList)
			Davildom["AggroPlayer"] 	= PlayerAggroList[PlayerHandle]
			Davildom["DeleteTime"]		= EventMemory["CurrentTime"] + 60

		end

		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Davildom["Handle"]] = Davildom
		EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenTime"] = EventMemory["CurrentTime"] + DavildomData["DELAYTIME"]

		return

	elseif EventState == ES_STATE["State7"] then

		local PlayerList


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (LINE_DATA["RIGHT_POSITION"]["DIR"] + 180) * (-1)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], LINE_DATA["RIGHT_POSITION"]["X"], LINE_DATA["RIGHT_POSITION"]["Y"], tmpdir, LINE_CAMERAMOVE["AngleY"], LINE_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + 1
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State8"]

		return

	elseif EventState == ES_STATE["State8"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[8]["FACECUT"], DIALOGINFO[8]["FILENAME"], DIALOGINFO[8]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State9"]


		return

	elseif EventState == ES_STATE["State9"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end


		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		return EVENT_ROUTINE_END

	end

end


function EVENT_NO7_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO7_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 7 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	if EventState == ES_STATE["State1"] then

		local PlayerList
		local DoorLocation		= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		DoorLocation = DOOR_BLOCK_DATA[3]["REGEN_POSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (DoorLocation["DIR"] + 180) * (-1)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], DoorLocation["X"], DoorLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 	= EventMemory["CurrentTime"] + 8
		EventMemory["DoorCheckTime"]	= EventMemory["CurrentTime"] + DOOR_CHECK_TIME
		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State2"]

		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DoorCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["DoorCheckTime"]  = nil


		local DoorInfo

		DoorInfo = EventMemory["DoorList"][3]
		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )
		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State3"]

		return

	elseif EventState == ES_STATE["State3"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["RSState"] == RS_STATE["Aggro"] then

			return

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State5"]

		return

	elseif EventState == ES_STATE["State5"] then

		local PlayerList
		local PoreLocation		= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (PoreLocation["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State6"]

		cNotice( EventMemory["MapIndex"], NOTICEINFO[3]["FILENAME"], NOTICEINFO[3]["INDEX"] )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end


		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State7"]

		return

	elseif EventState == ES_STATE["State7"] then

		local DavildomList
		local ForasList


		DavildomList 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"]
		ForasList 		= EventMemory[EventMemory["EventNumber"]]["EventData"]["ForasList"]


		if (next( DavildomList ) == nil) and (next(ForasList) == nil) then

			local PlayerList


			PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }
			for i=1, #PlayerList do

				cStaticDamage( PlayerList[i], STATICDAMAGE )

			end

		else

			return

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State8"]

		return


	elseif EventState == ES_STATE["State8"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"]  ~= PR_STATE["Damage1"] then

				return

			end


			local PlayerList
			local PoreLocation		= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT, 1, 99999999 )

			PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (PoreLocation["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State9"]

		return


	elseif EventState == ES_STATE["State9"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local Pore
		local PlayerList
		local Damage


		Pore	 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]

		if Pore ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( Pore["Handle"], Pore["BaseDamage"], PlayerList[1] )
		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State10"]

		return

	elseif EventState == ES_STATE["State10"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			cResetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State11"]

		return

	elseif EventState == ES_STATE["State11"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"]  ~= PR_STATE["Damage2"] then

				return

			end


			local PlayerList
			local PoreLocation		= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT, 1, 99999999 )

			PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (PoreLocation["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State12"]

		return


	elseif EventState == ES_STATE["State12"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local Pore
		local PlayerList
		local Damage


		Pore	 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]

		if Pore ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( Pore["Handle"], Pore["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State13"]

		return

	elseif EventState == ES_STATE["State13"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			cResetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State14"]

		return


	elseif EventState == ES_STATE["State14"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"] ~= nil then

			if EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["PR_State"]  ~= PR_STATE["Damage3"] then

				return

			end


			local PlayerList
			local PoreLocation		= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]["Handle"], STA_NEGLECT, 1, 99999999 )

			PoreLocation = EVNET_DATA[EventMemory["EventNumber"]]["PORE"]["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (PoreLocation["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], PoreLocation["X"], PoreLocation["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"] + 2
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State15"]

		return


	elseif EventState == ES_STATE["State15"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local Pore
		local PlayerList
		local Damage


		Pore	 	= EventMemory[EventMemory["EventNumber"]]["EventData"]["Pore"]

		if Pore ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( Pore["Handle"], Pore["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State16"]

		return

	elseif EventState == ES_STATE["State16"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State17"]

		return


	elseif EventState == ES_STATE["State17"] then

		local DoorInfo
		local PlayerList


		DoorInfo = EventMemory["DoorList"][5]
		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )
		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (LINE_DATA["RIGHT_POSITION"]["DIR"] + 180) * (-1)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], LINE_DATA["RIGHT_POSITION"]["X"], LINE_DATA["RIGHT_POSITION"]["Y"], tmpdir, LINE_CAMERAMOVE["AngleY"], LINE_CAMERAMOVE["Distance"], 1 )
		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BASE_CAMERAMOVE_DATA["KEEPTIME"]
		EventMemory["ObjectDeleteTime"]							= EventMemory["CurrentTime"] + 3
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State18"]

		return

	elseif EventState == ES_STATE["State18"] then

		if EventMemory["ObjectDeleteTime"] > EventMemory["CurrentTime"] then

			return

		end

		-- 동력선 제거
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State19"]
		cMapObjectControl( EventMemory["MapIndex"], "R_Line", 0, 1 )
		EventMemory["ObjectState"]["R_Line"] = 0

		return

	elseif EventState == ES_STATE["State19"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )
			cStaticDamage( PlayerList[i], 0 )

		end


		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		return EVENT_ROUTINE_END

	end

end

function EVENT_NO8_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO8_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 8 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	if EventState == ES_STATE["State1"] then

		local PlayerList
		local EventData			= { }
		local CitrieData		= { }
		local CitriePosition	= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		CitrieData			= EventData["CITRIE"]
		CitriePosition 		= CitrieData["REGENPOSITION"]


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (CitriePosition["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], CitriePosition["X"], CitriePosition["Y"], tmpdir, CITRIE_CAMERAMOVE2["AngleY"], CITRIE_CAMERAMOVE2["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + 3
		EventMemory["DialogCheckTime"] 							= EventMemory["CurrentTime"] + 1
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State2"]


		return


	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[7]["FACECUT"], DIALOGINFO[7]["FILENAME"], DIALOGINFO[7]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State3"]

		return


	elseif EventState == ES_STATE["State3"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local PlayerList
		local EventData			= { }
		local CitrieData		= { }
		local CitriePosition	= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		EventData 			= EVNET_DATA[EventMemory["EventNumber"]]
		CitrieData			= EventData["CITRIE"]
		CitriePosition 		= CitrieData["REGENPOSITION"]


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (CitriePosition["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], CitriePosition["X"], CitriePosition["Y"], tmpdir, CITRIE_CAMERAMOVE["AngleY"], CITRIE_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + 3
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State4"]


		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )

		end

		EventMemory["CameraCheckTime"] = nil
		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State5"]

		return

	elseif EventState == ES_STATE["State5"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"]["C_State"] == CT_STATE["Aggro"] then

			return

		end

		cNotice( EventMemory["MapIndex"], NOTICEINFO[1]["FILENAME"], NOTICEINFO[1]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		if EventMemory[EventMemory["EventNumber"]]["EventData"]["Citrie"] == nil then

			cNotice( EventMemory["MapIndex"], NOTICEINFO[2]["FILENAME"], NOTICEINFO[2]["INDEX"] )
			EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"] = nil

			return EVENT_ROUTINE_END

		end


		if EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenTime"] > EventMemory["CurrentTime"] then

			return

		end

		local EventData			= { }
		local DavildomData		= { }
		local PlayerAggroList 	= { }
		local PlayerList
		local Count = 1


		EventData 		= EVNET_DATA[EventMemory["EventNumber"]]
		DavildomData 	= EventData["DAVILDOM"]

		PlayerList		= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i = 1, #PlayerList do

			local CurPlayerPos		= { }
			local DavildomPos		= { }


			CurPlayerPos["X"], CurPlayerPos["Y"] = cObjectLocate( PlayerList[i] )
			DavildomPos 						 = DavildomData["REGENPOSITION"]

			if cDistanceSquar( DavildomPos["X"], DavildomPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( DavildomData["SEARCH_RANGE"] * DavildomData["SEARCH_RANGE"] ) then

				PlayerAggroList[Count] = PlayerList[i]
				Count = Count + 1

			end

		end


		local Davildom = { }


		Davildom["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], DavildomData["MOBINDEX"],
											   DavildomData["REGENPOSITION"]["X"], DavildomData["REGENPOSITION"]["Y"], 0 )

		if Davildom["Handle"] ~= nil then

			local PlayerHandle


			cSetAIScript	( SCRIPT_MAIN, Davildom["Handle"] )
			cAIScriptFunc	( Davildom["Handle"], "Entrance", "EVENT_NO8_DAVILDOM_ROUTINE" )


			Davildom["AggroDistance"]	= DavildomData["AGGRO_DISTANCE"]
			Davildom["D_State"] 		= D_STATE["Aggro"]
			Davildom["CheckTime"]		= EventMemory["CurrentTime"] + 1
			PlayerHandle 				= cRandomInt(1, #PlayerAggroList)
			Davildom["AggroPlayer"] 	= PlayerAggroList[PlayerHandle]
			Davildom["DeleteTime"]		= EventMemory["CurrentTime"] + 60

		end

		EventMemory[EventMemory["EventNumber"]]["EventData"]["DavildomList"][Davildom["Handle"]] = Davildom
		EventMemory[EventMemory["EventNumber"]]["EventData"]["RegenTime"] = EventMemory["CurrentTime"] + DavildomData["DELAYTIME"]

		return

	end

end

function EVENT_NO9_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO9_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 9 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	if EventState == ES_STATE["State1"] then

		local PlayerList
		local EventData			= { }
		local BrainWashData		= { }
		local BrainWashPosition	= { }


		PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


		for i=1, #PlayerList do

			cStaticDamage( PlayerList[i], STATICDAMAGE )
			cSetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

		end


		EventData 			= EVNET_DATA[4]
		BrainWashData		= EventData["BRAINWASH"]
		BrainWashPosition 	= BrainWashData["REGENPOSITION"]

		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (BrainWashPosition["DIR"] + 180)

		tmpdir = tmpdir % 360
		cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE["AngleY"], BRAINWASH_CAMERAMOVE["Distance"], 1 )

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BRAINWASH_CAMERAMOVE["KEEPTIME"]
		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + 2

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State2"]

		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[9]["FACECUT"], DIALOGINFO[9]["FILENAME"], DIALOGINFO[9]["INDEX"] )
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State3"]


		return

	elseif EventState == ES_STATE["State3"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BASE_CAMERAMOVE_DATA["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory["BrainWash"] ~= nil then

			EventMemory["BrainWash"]["BW_State"] = BW_SATATE["Damage1"]

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory["BrainWash"] ~= nil then

			if EventMemory["BrainWash"]["BW_State"] ~= BW_SATATE["Damage2"] then

				return

			end

			local PlayerList
			local EventData			= { }
			local BrainWashData		= { }
			local BrainWashPosition	= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT, 1, 99999999 )

			EventData 			= EVNET_DATA[4]
			BrainWashData		= EventData["BRAINWASH"]
			BrainWashPosition 	= BrainWashData["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (BrainWashPosition["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE_DAMGE["AngleY"], BRAINWASH_CAMERAMOVE_DAMGE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BRAINWASH_CAMERAMOVE["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State5"]

		return

	elseif EventState == ES_STATE["State5"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local BrainWash
		local PlayerList
		local Damage


		BrainWash 	= EventMemory["BrainWash"]

		if BrainWash ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( BrainWash["Handle"], BrainWash["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

				return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory["BrainWash"] ~= nil then

			cResetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT )

		end

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State7"]

		return

	elseif EventState == ES_STATE["State7"] then

		if EventMemory["BrainWash"] ~= nil then

			if EventMemory["BrainWash"]["BW_State"] ~= BW_SATATE["Damage3"] then

				return

			end

			local PlayerList
			local EventData			= { }
			local BrainWashData		= { }
			local BrainWashPosition	= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT, 1, 99999999 )

			EventData 			= EVNET_DATA[4]
			BrainWashData		= EventData["BRAINWASH"]
			BrainWashPosition 	= BrainWashData["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (BrainWashPosition["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE_DAMGE["AngleY"], BRAINWASH_CAMERAMOVE_DAMGE["Distance"], 1 )

		end


		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BRAINWASH_CAMERAMOVE["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State8"]

		return

	elseif EventState == ES_STATE["State8"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local BrainWash
		local PlayerList
		local Damage


		BrainWash 	= EventMemory["BrainWash"]

		if BrainWash ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( BrainWash["Handle"], BrainWash["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State9"]

		return

	elseif EventState == ES_STATE["State9"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory["BrainWash"] ~= nil then

			cResetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State10"]

		return

	elseif EventState == ES_STATE["State10"] then

		if EventMemory["BrainWash"] ~= nil then

			if EventMemory["BrainWash"]["BW_State"] ~= BW_SATATE["Damage4"] then

				return

			end

			local PlayerList
			local EventData			= { }
			local BrainWashData		= { }
			local BrainWashPosition	= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT, 1, 99999999 )

			EventData 			= EVNET_DATA[4]
			BrainWashData		= EventData["BRAINWASH"]
			BrainWashPosition 	= BrainWashData["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (BrainWashPosition["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE_DAMGE["AngleY"], BRAINWASH_CAMERAMOVE_DAMGE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BRAINWASH_CAMERAMOVE["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State11"]

		return

	elseif EventState == ES_STATE["State11"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local BrainWash
		local PlayerList
		local Damage


		BrainWash 	= EventMemory["BrainWash"]

		if BrainWash ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( BrainWash["Handle"], BrainWash["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State12"]

		return

	elseif EventState == ES_STATE["State12"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory["BrainWash"] ~= nil then

			cResetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State13"]

		return

	elseif EventState == ES_STATE["State13"] then

		if EventMemory["BrainWash"] ~= nil then

			if EventMemory["BrainWash"]["BW_State"] ~= BW_SATATE["Damage5"] then

				return
			end

			local PlayerList
			local EventData			= { }
			local BrainWashData		= { }
			local BrainWashPosition	= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT, 1, 99999999 )

			EventData 			= EVNET_DATA[4]
			BrainWashData		= EventData["BRAINWASH"]
			BrainWashPosition 	= BrainWashData["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (BrainWashPosition["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE_DAMGE["AngleY"], BRAINWASH_CAMERAMOVE_DAMGE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + BRAINWASH_CAMERAMOVE["KEEPTIME"]
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State14"]

		return

	elseif EventState == ES_STATE["State14"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local BrainWash
		local PlayerList
		local Damage


		BrainWash 	= EventMemory["BrainWash"]

		if BrainWash ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( BrainWash["Handle"], BrainWash["BaseDamage"], PlayerList[1] )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State15"]

		return

	elseif EventState == ES_STATE["State15"] then

		if EventMemory["CameraCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )
			cStaticDamage( PlayerList[i], STATICDAMAGE )

		end

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		if EventMemory["BrainWash"] ~= nil then

			cResetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT )

		end

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State16"]

		return

	elseif EventState == ES_STATE["State16"] then

		if EventMemory["BrainWash"] ~= nil then

			if EventMemory["BrainWash"]["BW_State"] ~= BW_SATATE["End"] then

				return

			end

			local PlayerList
			local EventData			= { }
			local BrainWashData		= { }
			local BrainWashPosition	= { }


			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"], 1, 99999999 )
				cStaticDamage( PlayerList[i], 0 )

			end

			cSetAbstate( EventMemory["BrainWash"]["Handle"], STA_NEGLECT, 1, BASE_CAMERAMOVE_DATA["ABSTATETIME"] )

			EventData 			= EVNET_DATA[4]
			BrainWashData		= EventData["BRAINWASH"]
			BrainWashPosition 	= BrainWashData["REGENPOSITION"]

			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (BrainWashPosition["DIR"] + 180)

			tmpdir = tmpdir % 360
			cCameraMove( EventMemory["MapIndex"], BrainWashPosition["X"], BrainWashPosition["Y"], tmpdir, BRAINWASH_CAMERAMOVE["AngleY"], BRAINWASH_CAMERAMOVE["Distance"], 1 )

		end

		EventMemory["CameraCheckTime"] 							= EventMemory["CurrentTime"] + 10
		EventMemory["DamageCheckTime"]							= EventMemory["CurrentTime"] + 2
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State17"]

		return

	elseif EventState == ES_STATE["State17"] then

		if EventMemory["DamageCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		local BrainWash
		local PlayerList
		local Damage


		BrainWash 	= EventMemory["BrainWash"]

		if BrainWash ~= nil then

			PlayerList 	= { cGetPlayerList( EventMemory["MapIndex"] ) }
			cDamaged( BrainWash["Handle"], BrainWash["BaseDamage"], PlayerList[1] )

		end

		EventMemory["DialogCheckTime"] 							= EventMemory["CurrentTime"] + 5
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State18"]

		return

	elseif EventState == ES_STATE["State18"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[10]["FACECUT"], DIALOGINFO[10]["FILENAME"], DIALOGINFO[10]["INDEX"] )
		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + DIALOGINFO[8]["DELAY"]
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State19"]

		return

	elseif EventState == ES_STATE["State19"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[11]["FACECUT"], DIALOGINFO[11]["FILENAME"], DIALOGINFO[11]["INDEX"] )
		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + DIALOGINFO[9]["DELAY"]
		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State20"]

	elseif EventState == ES_STATE["State20"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			cStaticDamage( PlayerList[i], STATICDAMAGE )
			cResetAbstate( PlayerList[i], BRAINWASH_CAMERAMOVE_DAMGE["ABSTATE"] )

		end


		EventMemory["CameraCheckTime"] = nil

		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )

		EventMemory[EventMemory["EventNumber"]]["EventState"] 	= ES_STATE["State21"]

		EventMemory["DialogCheckTime"]							= EventMemory["CurrentTime"] + DIALOGINFO[9]["DELAY"]

		if EventMemory["ForasChief"] ~= nil then

			EventMemory["ForasChief"] = nil

		end

		return

	elseif EventState == ES_STATE["State21"] then

		if EventMemory["DialogCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		-- 포라스 치프 소환 후 움직이게

		cMobDialog( EventMemory["MapIndex"], DIALOGINFO[12]["FACECUT"], DIALOGINFO[12]["FILENAME"], DIALOGINFO[12]["INDEX"] )

		EventMemory["PForasState"]	= PF_STATE["RUNAWAY"]

		local ForasCheifData 	= { }
		local ForasChief 		= { }


		ForasCheifData = EVNET_DATA[1]["FORASCHIEF"]
		ForasChief["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], ForasCheifData["MOBINDEX"],
										GATE_DATA["END_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["END_GATE"]["REGEN_POSITION"]["Y"], GATE_DATA["END_GATE"]["REGEN_POSITION"]["DIR"] )


		if ForasChief["Handle"]  ~= nil then

			cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
			cAIScriptFunc	( ForasChief["Handle"], "Entrance", "FORASCHIEFEND_ROUTINE" )
			cSetAbstate		( ForasChief["Handle"], STA_NEGLECT, 1, 99999999 )

			cRunTo( ForasChief["Handle"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["START_GATE"]["REGEN_POSITION"]["Y"] )

		end

		EventMemory["ForasChiefEnd"] 	 = ForasChief

		return EVENT_ROUTINE_END

	end

end

function EVENT_NO10_ROUTINE( EventMemory )
cExecCheck( "EVENT_NO10_ROUTINE" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 10 then

		return

	end


	local EventState = EventMemory[EventMemory["EventNumber"]]["EventState"]

	local EndingData = EVENT_ENDING_DATA["KQReturn"]


	if EventState == ES_STATE["State1"] then

		cNotice( EventMemory["MapIndex"], EndingData[1]["FileName"], EndingData[1]["Index"] )

		EventMemory["EndingCheckTime"] = EventMemory["CurrentTime"] + EndingData[1]["WaitTime"]

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State2"]

		return

	elseif EventState == ES_STATE["State2"] then

		if EventMemory["EndingCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cNotice( EventMemory["MapIndex"], EndingData[2]["FileName"], EndingData[2]["Index"] )

		EventMemory["EndingCheckTime"] = EventMemory["CurrentTime"] + EndingData[2]["WaitTime"]

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State3"]

		return


	elseif EventState == ES_STATE["State3"] then

		if EventMemory["EndingCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cNotice( EventMemory["MapIndex"], EndingData[3]["FileName"], EndingData[3]["Index"] )

		EventMemory["EndingCheckTime"] = EventMemory["CurrentTime"] + EndingData[3]["WaitTime"]

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State4"]

		return

	elseif EventState == ES_STATE["State4"] then

		if EventMemory["EndingCheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		cNotice( EventMemory["MapIndex"], EndingData[4]["FileName"], EndingData[4]["Index"] )

		EventMemory["EndingCheckTime"] = EventMemory["CurrentTime"] + EndingData[4]["WaitTime"]

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State5"]

		return

	elseif EventState == ES_STATE["State5"] then

		if EventMemory["EndingCheckTime"] > EventMemory["CurrentTime"] then

			return

		end


		cLinkToAll( EventMemory["MapIndex"], GATE_DATA["END_GATE"]["LINK"]["FIELD"], GATE_DATA["END_GATE"]["LINK"]["X"], GATE_DATA["END_GATE"]["LINK"]["Y"] )

		EventMemory[EventMemory["EventNumber"]]["EventState"] = ES_STATE["State6"]

		return

	elseif EventState == ES_STATE["State6"] then

		return

	end

	return

end


EVENT_ROUTINE = { }

EVENT_ROUTINE[1] = EVENT_NO1_ROUTINE
EVENT_ROUTINE[2] = EVENT_NO2_ROUTINE
EVENT_ROUTINE[3] = EVENT_NO3_ROUTINE
EVENT_ROUTINE[4] = EVENT_NO4_ROUTINE
EVENT_ROUTINE[5] = EVENT_NO5_ROUTINE
EVENT_ROUTINE[6] = EVENT_NO6_ROUTINE
EVENT_ROUTINE[7] = EVENT_NO7_ROUTINE
EVENT_ROUTINE[8] = EVENT_NO8_ROUTINE
EVENT_ROUTINE[9] = EVENT_NO9_ROUTINE
EVENT_ROUTINE[10] = EVENT_NO10_ROUTINE

