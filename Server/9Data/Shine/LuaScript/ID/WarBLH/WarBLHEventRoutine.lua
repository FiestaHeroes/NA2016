require( "ID/WarBLH/WarBLHData" )

function EndGateRoutine( Handle, MapIndex )
cExecCheck( "EndGateRoutine" )

	local RoomEvent


	RoomEvent = InstanceField[MapIndex]

	if RoomEvent == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if RoomEvent["EndGate"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GATE_MAP_INDEX[Handle] = nil

		return ReturnAI["END"]

	end

	if RoomEvent["EndGate"][Handle] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		RoomEvent["EndGate"] = nil
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
										GATE_TITLE["End"]["Yes"], "LinkToEnd",
										GATE_TITLE["End"]["No"],  "GateDummy")

end


function LinkToEnd( NPCHandle, PlyHandle, RegistNumber )
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

	if RoomEvent["EndGate"] == nil then

		return

	end

	cLinkTo( PlyHandle, GATE_DATA["END_GATE"]["LINK"]["FIELD"], GATE_DATA["END_GATE"]["LINK"]["X"], GATE_DATA["END_GATE"]["LINK"]["Y"] )

end







-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 1							-- --
-- --														-- --
-- --					 ( 메인 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_ONE_ROUTINE( RoomEvent )
cExecCheck( "EVENT_ROOM_ONE_ROUTINE" )

	if RoomEvent == nil then
		return
	end


	if RoomEvent["Room"]["RoomNumber"] ~= 1 then
		return
	end


	if RoomEvent["Room"]["Data"] == nil then
		return
	end


	if RoomEvent["Room"]["Data"]["ForasList"] == nil then
		return
	end



	local Event_Foras_Data 		= { }
	local Event_Foras_List		= { }


	Event_Foras_Data 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["ENVENT_FORAS"]
	Event_Foras_List 	= RoomEvent["Room"]["Data"]["ForasList"]

	-- 각 포라스 들이 주변에 캐릭터가 있는지 체크하여 성공시 RE_STATE 변경
	if RoomEvent["Room"]["RE_State"] == RE_STATE_1 then

		-- 주변캐릭터 검색성공
		if Event_Foras_List["FL_State"] == FL_SEARCH_SUCCESS then

			local PlayerList
			local ForasPos


			PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


			for i=1, #PlayerList do

				cSetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"], 1, DOOR_CAMERAMOVE["AbstateTime"] )

			end


			ForasPos = Event_Foras_Data["FORAS_POSITION"][1]["REGEN_POS"]



			-- 서버와 클라 방향 맞춰줌
			local tmpdir = (-48 + 180) * (-1)


			tmpdir = tmpdir % 360

			cCameraMove( RoomEvent["MapIndex"], ForasPos["X"], ForasPos["Y"], tmpdir, FORAS_CAMERAMOVE["AngleY"], FORAS_CAMERAMOVE["Distance"], 1 )

			RoomEvent["Room"]["Data"]["CameraCheckTime"] 	= RoomEvent["CurrentTime"] + FORAS_CAMERAMOVE["KeepTime"]
			RoomEvent["Room"]["Data"]["CheckTime"]			= RoomEvent["CurrentTime"] + 1

			RoomEvent["Room"]["RE_State"] 	= RE_STATE_2

		end

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_2 then

		if RoomEvent["Room"]["Data"]["CheckTime"] > RoomEvent["CurrentTime"] then

			return

		end

		RoomEvent["Room"]["Data"]["CheckTime"] 	= nil
		Event_Foras_List["FL_State"] 			= FL_SURPRISE
		Event_Foras_List["CheckTime"] 			= RoomEvent["CurrentTime"] + Event_Foras_Data["SURPRISE_DELAY"]
		RoomEvent["Room"]["RE_State"] 			= RE_STATE_3

		return

	-- 포라스가 캐릭터를 인식하고 대기중인 상태
	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_3 then

		if RoomEvent["Room"]["Data"]["CameraCheckTime"]  > RoomEvent["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], FORAS_CAMERAMOVE["AbstateIndex"] )

		end

		RoomEvent["Room"]["Data"]["CameraCheckTime"] = nil

		cCameraMove( RoomEvent["MapIndex"], 0, 0, 0, 0, 0, 0 )

		RoomEvent["Room"]["RE_State"] = RE_STATE_4

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_4 then

		if RoomEvent["CurrentTime"] > Event_Foras_List["CheckTime"] then

			Event_Foras_List["FL_State"] 	= FL_ESCAPE
			RoomEvent["Room"]["RE_State"] 	= RE_STATE_5


			for index, value in pairs ( Event_Foras_List["List"] ) do

				local GoalPos = {}


				GoalPos						= value["Path"][value["PathNumber"]]

				cRunTo		( index, GoalPos["X"], GoalPos["Y"] )
				cMobChat	( index, "WarBL", value["MobChatData"]["INDEX"][5] )

			end


			RoomEvent["Room"]["Data"]["NoticeCheckTime"] = RoomEvent["CurrentTime"] + NOTICE_INFO[1]["DelayTime"]

		end



		return
	-- 포라스가 모두 도망 완료 되었는지 체크 - 마계병사 리젠
	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_5 then


		local Event_DavilDom_Data	= { }
		local Event_DavilDom 		= { }
		local Daivildom				= { }
		local Event_Davildom_List	= { }


		Event_DavilDom_Data	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["EVNET_DAVILDOM"]
		Event_DavilDom 		= RoomEvent["Room"]["Data"]["Davildom"]
		Event_Davildom_List = RoomEvent["Room"]["Data"]["Davildom"]["List"]


		if RoomEvent["Room"]["Data"]["NoticeCheckTime"] < RoomEvent["CurrentTime"] then

			cNotice( RoomEvent["MapIndex"], NOTICE_INFO[1]["FileName"], NOTICE_INFO[1]["Index"] )
			RoomEvent["Room"]["Data"]["NoticeCheckTime"] = RoomEvent["Room"]["Data"]["NoticeCheckTime"] + 999999999999

		end

		if RoomEvent["CurrentTime"] > Event_DavilDom["RegenCheckTime"] then

			if Event_DavilDom["RegenCount"] > Event_DavilDom_Data["MOB_TOTAL_COUNT"] then

				RoomEvent["Room"]["RE_State"] 	= RE_STATE_6
				return

			end


			Event_DavilDom["RegenCheckTime"]	= RoomEvent["CurrentTime"] + Event_DavilDom_Data["REGEN_DELAY_TIME"]


			Daivildom["Handle"]		= cMobRegen_XY( RoomEvent["MapIndex"], Event_DavilDom_Data["MOB_INDEX"],
											Event_DavilDom_Data["DAVILDOM_POSITION"]["START_POSITION"]["X"], Event_DavilDom_Data["DAVILDOM_POSITION"]["START_POSITION"]["Y"], Event_DavilDom_Data["DAVILDOM_POSITION"]["START_POSITION"]["DIR"] )

			if Daivildom["Handle"] ~= nil then

				Daivildom["D_State"]								= D_Normal
				Daivildom["CheckTime"]								= RoomEvent["CurrentTime"]
				Event_Davildom_List[Daivildom["Handle"]] 			= Daivildom
				Event_DavilDom["RegenCount"]						= Event_DavilDom["RegenCount"] + 1

				cSetAIScript	( SCRIPT_MAIN, Daivildom["Handle"] )
				cAIScriptFunc	( Daivildom["Handle"], "Entrance", "ROOM_ONE_DAVILDOM_ROUTINE" )
				cRunTo			( Daivildom["Handle"], Event_DavilDom_Data["DAVILDOM_POSITION"]["END_POSITION"]["X"], Event_DavilDom_Data["DAVILDOM_POSITION"]["END_POSITION"]["Y"] )

			end

			return

		end

		return

	-- 전투 완료 후 알림
	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_6 then

		local Event_Davildom_List	= { }


		Event_Davildom_List = RoomEvent["Room"]["Data"]["Davildom"]["List"]

		for index, value in pairs(Event_Davildom_List) do

			return

		end

		cNotice( RoomEvent["MapIndex"], NOTICE_INFO[2]["FileName"], NOTICE_INFO[2]["Index"] )

	end


	return EVENT_ROUTINE_END

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 2							-- --
-- --														-- --
-- --					 ( 메인 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_TWO_ROUTINE( RoomEvent )
cExecCheck( "EVENT_ROOM_TWO_ROUTINE" )


	if RoomEvent == nil then
		return
	end


	if RoomEvent["Room"]["RoomNumber"] ~= 2 then
		return
	end


	if RoomEvent["Room"]["Data"] == nil then
		return
	end

	-- 카메라 워크 ( 도어오픈 )
	if RoomEvent["Room"]["RE_State"] == RE_STATE_1 then


		local PlayerList
		local DoorLoc


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"], 1, DOOR_CAMERAMOVE["AbstateTime"] )

		end


		DoorLoc = DOOR_BLOCK_DATA[1]["REGEN_POSITION"]



		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (DoorLoc["DIR"] + 180) * (-1)


		tmpdir = tmpdir % 360

		cCameraMove( RoomEvent["MapIndex"], DoorLoc["X"], DoorLoc["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		RoomEvent["Room"]["Data"]["CameraCheckTime"] =	RoomEvent["CurrentTime"] + DOOR_CAMERAMOVE["KeepTime"]

		RoomEvent["Room"]["RE_State"] 				 = RE_STATE_2




		RoomEvent["DoorCheckTime"] = RoomEvent["CurrentTime"] + DOOR_CHECK_TIME


		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_2 then


		if RoomEvent["CurrentTime"] < RoomEvent["DoorCheckTime"] then

			return

		end


		local DoorInfo


		DoorInfo = RoomEvent["DoorList"][1]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )


		RoomEvent["Room"]["RE_State"] = RE_STATE_3

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_3 then

		if RoomEvent["Room"]["Data"]["CameraCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end


		RoomEvent["Room"]["RE_State"] = RE_STATE_4


		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"] )

		end

		RoomEvent["CameraCheckTime"] = nil

		cCameraMove( RoomEvent["MapIndex"], 0, 0, 0, 0, 0, 0 )

		cNotice( RoomEvent["MapIndex"], NOTICE_INFO[1]["FileName"], NOTICE_INFO[1]["Index"] )

		return

	-- 시트리 죽었나 확인
	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_4 then

		if RoomEvent["Room"]["Data"]["Citrie"] ~= nil then
			return
		end

		RoomEvent["Room"]["RE_State"] = RE_STATE_5

		cNotice( RoomEvent["MapIndex"], NOTICE_INFO[2]["FileName"], NOTICE_INFO[2]["Index"] )




		local Gate 			= { }
		RoomEvent["MiddleGate"] = { }


		Gate["Handle"] = cMobRegen_XY( RoomEvent["MapIndex"], GATE_DATA["MIDDLE_GATE"]["GATE_INDEX"],
											GATE_DATA["MIDDLE_GATE"]["REGEN_POSITION"]["X"], GATE_DATA["MIDDLE_GATE"]["REGEN_POSITION"]["Y"], GATE_DATA["MIDDLE_GATE"]["REGEN_POSITION"]["DIR"] )


		if Gate["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, Gate["Handle"] )
			cAIScriptFunc	( Gate["Handle"], "Entrance", "MiddleGateRoutine" )
			cAIScriptFunc	( Gate["Handle"], "NPCClick", "MiddleGateClick"   )

			Gate["RegenLocNum"]				= 1
			GATE_MAP_INDEX[Gate["Handle"]] 	= RoomEvent["MapIndex"]

		end

		RoomEvent["MiddleGate"] = Gate

		MAPMARK( RoomEvent )

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_5 then

		local PlayerList
		local DoorLoc


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"], 1, DOOR_CAMERAMOVE["AbstateTime"] )

		end


		DoorLoc = DOOR_BLOCK_DATA[2]["REGEN_POSITION"]



		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (DoorLoc["DIR"] + 180)


		tmpdir = tmpdir % 360

		cCameraMove( RoomEvent["MapIndex"], DoorLoc["X"], DoorLoc["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		RoomEvent["Room"]["Data"]["CameraCheckTime"] =	RoomEvent["CurrentTime"] + DOOR_CAMERAMOVE["KeepTime"]

		RoomEvent["Room"]["RE_State"] 				 = RE_STATE_6


		RoomEvent["DoorCheckTime"] = RoomEvent["CurrentTime"] + DOOR_CHECK_TIME

		return


	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_6 then


		if RoomEvent["CurrentTime"] < RoomEvent["DoorCheckTime"] then

			return

		end


		local DoorInfo


		DoorInfo = RoomEvent["DoorList"][2]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

		RoomEvent["Room"]["RE_State"] = RE_STATE_7


		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_7 then

		if RoomEvent["CurrentTime"] < RoomEvent["Room"]["Data"]["CameraCheckTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"] )

		end

		RoomEvent["CameraCheckTime"] = nil

		cCameraMove( RoomEvent["MapIndex"], 0, 0, 0, 0, 0, 0 )


	end



	return EVENT_ROUTINE_END

end



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 3							-- --
-- --														-- --
-- --					 ( 메인 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function EVENT_ROOM_THREE_ROUTINE( RoomEvent )
cExecCheck( "EVENT_ROOM_THREE_ROUTINE" )


	if RoomEvent == nil then
		return
	end


	if RoomEvent["Room"]["RoomNumber"] ~= 3 then
		return
	end


	if RoomEvent["Room"]["Data"] == nil then
		return
	end


	-- 1. 마계병사 그룹 어그로 확인
	if RoomEvent["Room"]["RE_State"] == RE_STATE_1 then

		local DavildomGroupList
		local DavildomGroup
		local ForasGroupList
		local ForasGroup


		DavildomGroupList 	= RoomEvent["Room"]["Data"]["DavildomGroupList"]
		ForasGroupList		= RoomEvent["Room"]["Data"]["ForasGroupList"]


		if RoomEvent["Room"]["Data"]["EscapeStateNum"] >= #DavildomGroupList then

			RoomEvent["Room"]["RE_State"] = RE_STATE_2

			return

		end


		for i = 1, #DavildomGroupList do

			DavildomGroup 	= DavildomGroupList[i]
			ForasGroup		= ForasGroupList[i]


			if DavildomGroup["DG_State"] == DG_AGGRO then

				DavildomGroup["DG_State"]						= DG_AGGRO_SUCC
				RoomEvent["Room"]["Data"]["EscapeStateNum"] 	= RoomEvent["Room"]["Data"]["EscapeStateNum"] + 1
				ForasGroup["FG_State"] 							= FG_ESCAPE

				for index, value in pairs ( ForasGroup["List"] ) do

					local GoalPos = {}


					GoalPos						= value["Path"][value["PathNumber"]]

					cRunTo		( value["Handle"], GoalPos["X"], GoalPos["Y"] )
					cMobChat	( index, "WarBL", value["MobChat"] )

				end

			end

		end

		return

	-- 2. 모든 마계병사가 죽었는지 확인
	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_2 then

		for index, value in pairs ( RoomEvent["Room"]["Data"]["DavildomList"] ) do

			return

		end

		cMobDialog( RoomEvent["MapIndex"], DialogInfo[1]["Facecut"], DialogInfo[1]["FileName"], DialogInfo[1]["Index"] )

		RoomEvent["Room"]["RE_State"] = RE_STATE_3

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_3 then

		local RegenDavildomData

		local RegenDavildomList		= { }

		RegenDavildomData = EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["REGEN_DAVILDOM"]


		for i = 1, RegenDavildomData["MOB_COUNT"][1] do

			local RegenDavildom 		= { }

			RegenDavildom["Handle"] = cMobRegen_Circle( RoomEvent["MapIndex"], RegenDavildomData["MOB_INDEX"],
														RegenDavildomData["CENTER_POSITION"]["X"], RegenDavildomData["CENTER_POSITION"]["Y"],
														RegenDavildomData["CENTER_POSITION"]["RADIUS"] )


			if RegenDavildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, RegenDavildom["Handle"]  )
				cAIScriptFunc	( RegenDavildom["Handle"], "Entrance", "ROOM_THREE_REGEN_DAVILDOM_ROUTINE" )


				local PlayerList
				local PlayerAggroList	= { }

				local CurPos 			= { }
				local Count				= 1



				CurPos["X"], CurPos["Y"]	= cObjectLocate( RegenDavildom["Handle"] )

				PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }

				for i = 1, #PlayerList do

					local CurPlayerPos		= { }


					CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )

					if cDistanceSquar( CurPos["X"], CurPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( RegenDavildomData["SEARCH_RANGE"] * RegenDavildomData["SEARCH_RANGE"] ) then

						PlayerAggroList[Count] = PlayerList[i]

						Count = Count + 1

					end

				end


				local PlayerHandle


				PlayerHandle = cRandomInt(1, #PlayerAggroList)

				RegenDavildom["AggroPlayer"]	= PlayerAggroList[PlayerHandle]
				RegenDavildom["AggroDistance"]	= RegenDavildomData["AGGRO_DISTANCE"]
				RegenDavildom["AggroPoint"]		= RegenDavildomData["AGGRO_POINT"]
				RegenDavildom["CheckTime"]		= RoomEvent["CurrentTime"]
				RegenDavildom["D_State"]		= D_AGGRO

				RegenDavildomList[RegenDavildom["Handle"]] = RegenDavildom

			end

		end

		RoomEvent["Room"]["Data"]["RegenDavildomList"] = RegenDavildomList

		RoomEvent["Room"]["RE_State"] = RE_STATE_4

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_4 then

		for index, value in pairs(RoomEvent["Room"]["Data"]["RegenDavildomList"]) do

			return

		end

		RoomEvent["Room"]["Data"]["RegenDavildomList"] = nil
		cMobDialog( RoomEvent["MapIndex"], DialogInfo[2]["Facecut"], DialogInfo[2]["FileName"], DialogInfo[2]["Index"] )
		RoomEvent["Room"]["RE_State"] = RE_STATE_5

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_5 then

		local RegenDavildomData
		local RegenDavildomList		= { }

		RegenDavildomData = EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["REGEN_DAVILDOM"]


		for i = 1, RegenDavildomData["MOB_COUNT"][2] do

			local RegenDavildom 		= { }


			RegenDavildom["Handle"] = cMobRegen_Circle( RoomEvent["MapIndex"], RegenDavildomData["MOB_INDEX"],
														RegenDavildomData["CENTER_POSITION"]["X"], RegenDavildomData["CENTER_POSITION"]["Y"],
														RegenDavildomData["CENTER_POSITION"]["RADIUS"] )


			if RegenDavildom["Handle"] ~= nil then

				cSetAIScript	( SCRIPT_MAIN, RegenDavildom["Handle"]  )
				cAIScriptFunc	( RegenDavildom["Handle"], "Entrance", "ROOM_THREE_REGEN_DAVILDOM_ROUTINE" )


				local PlayerList
				local PlayerAggroList	= { }

				local CurPos 			= { }
				local Count				= 1



				CurPos["X"], CurPos["Y"]	= cObjectLocate( RegenDavildom["Handle"] )

				PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }

				for i = 1, #PlayerList do

					local CurPlayerPos		= { }



					CurPlayerPos["X"], CurPlayerPos["Y"] 	= cObjectLocate( PlayerList[i] )

					if cDistanceSquar( CurPos["X"], CurPos["Y"], CurPlayerPos["X"], CurPlayerPos["Y"] ) < ( RegenDavildomData["SEARCH_RANGE"] * RegenDavildomData["SEARCH_RANGE"] ) then

						PlayerAggroList[Count] = PlayerList[i]

						Count = Count + 1

					end

				end


				local PlayerHandle


				PlayerHandle = cRandomInt(1, #PlayerAggroList)

				RegenDavildom["AggroPlayer"]	= PlayerAggroList[PlayerHandle]
				RegenDavildom["AggroDistance"]	= RegenDavildomData["AGGRO_DISTANCE"]
				RegenDavildom["AggroPoint"]		= RegenDavildomData["AGGRO_POINT"]
				RegenDavildom["CheckTime"]		= RoomEvent["CurrentTime"]
				RegenDavildom["D_State"]		= D_AGGRO

				RegenDavildomList[RegenDavildom["Handle"]] = RegenDavildom

			end

		end

		RoomEvent["Room"]["Data"]["RegenDavildomList"] = RegenDavildomList

		RoomEvent["Room"]["RE_State"] = RE_STATE_6

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_6 then

		for index, value in pairs(RoomEvent["Room"]["Data"]["RegenDavildomList"]) do

			return

		end

	end

	return EVENT_ROUTINE_END
end




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 4							-- --
-- --														-- --
-- --					 ( 메인 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_FOUR_ROUTINE( RoomEvent )
cExecCheck( "EVENT_ROOM_THREE_ROUTINE" )


	if RoomEvent == nil then
		return
	end


	if RoomEvent["Room"]["RoomNumber"] ~= 4 then
		return
	end


	if RoomEvent["Room"]["Data"] == nil then
		return
	end



	if RoomEvent["Room"]["RE_State"] == RE_STATE_1 then


		local PlayerList
		local ForasChiefLocation


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], EVENT4_CAMERAMOVE["AbstateIndex"], 1, EVENT4_CAMERAMOVE["AbstateTime"] )

		end


		ForasChiefLocation = EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]["REGEN_POSITION"]


		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (ForasChiefLocation["DIR"] + 180) * (-1)


		tmpdir = tmpdir % 360

		cCameraMove( RoomEvent["MapIndex"], ForasChiefLocation["X"], ForasChiefLocation["Y"], tmpdir, EVENT4_CAMERAMOVE["AngleY"], EVENT4_CAMERAMOVE["Distance"], 1 )

		RoomEvent["Room"]["Data"]["CameraCheckTime"] =	RoomEvent["CurrentTime"] + EVENT4_CAMERAMOVE["KeepTime"]

		RoomEvent["Room"]["RE_State"] 				 = RE_STATE_2



		return


	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_2 then

		if RoomEvent["Room"]["Data"]["CameraCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end


		RoomEvent["Room"]["RE_State"] = RE_STATE_3


		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], EVENT4_CAMERAMOVE["AbstateIndex"] )

		end

		RoomEvent["CameraCheckTime"] = nil

		cCameraMove( RoomEvent["MapIndex"], 0, 0, 0, 0, 0, 0 )

		RoomEvent["Room"]["RE_State"] = RE_STATE_3

		RoomEvent["CameraCheckTime"] = RoomEvent["CurrentTime"] + 1

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_3 then

		if RoomEvent["CameraCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end


		cMobDialog( RoomEvent["MapIndex"], DialogInfo[3]["Facecut"], DialogInfo[3]["FileName"], DialogInfo[3]["Index"] )

		RoomEvent["CameraCheckTime"] = nil

		RoomEvent["Room"]["RE_State"] = RE_STATE_4

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_4 then

		for index, value in pairs(RoomEvent["Room"]["Data"]["DavildomList"]) do

			return

		end

		cAnimate( RoomEvent["Room"]["Data"]["ForasChief"]["Handle"], "stop" )

		RoomEvent["Room"]["RE_State"] = RE_STATE_5

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_5 then

		local EquipItemPlayerList 	= { }
		local nCount
		local MaseterPlayer


		PlayerList 	= { cGetPlayerList( RoomEvent["MapIndex"] ) }
		nCount	   	= 1


		local MasterPlayer = nil


		for i = 1, #PlayerList do

			local PriorityFirst
			local PrioritySecond


			if cIsEquipItem( PlayerList[i], RoomEvent["Room"]["Data"]["ForasChief"]["MaskItem"] ) == 1 then

				if MasterPlayer == nil then

					MasterPlayer = PlayerList[i]

				elseif  MasterPlayer ~= nil then

					PriorityFirst 	= PRIORITY_CLASS[cGetBaseClass( MasterPlayer )]
					PrioritySecond 	= PRIORITY_CLASS[cGetBaseClass( PlayerList[i] )]


					if PriorityFirst > PrioritySecond then

						MasterPlayer = PlayerList[i]

					end

				end

			end

		end


		local ForasChief


		ForasChief = RoomEvent["Room"]["Data"]["ForasChief"]


		if MasterPlayer == nil then

			ForasChief["FC_State"]  = FC_MOVE
			cMobShout	( ForasChief["Handle"], "WarBL", ForasChief["MobChatData"][1] )

		elseif  MasterPlayer ~= nil then

			ForasChief["MasterPlayer"] 	= MasterPlayer
			ForasChief["FC_State"]  	= FC_FOLLOW
			cMobShout	( ForasChief["Handle"], "WarBL", ForasChief["MobChatData"][2] )

		end


		RoomEvent["MiddleGate"]["RegenLocNum"] = 2

		RoomEvent["Room"]["RE_State"] = RE_STATE_6

		RoomEvent["Room"]["Data"]["CheckTime"] = RoomEvent["CurrentTime"] + 4

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_6 then

		if RoomEvent["Room"]["Data"]["CheckTime"] > RoomEvent["CurrentTime"] then

			return

		end

	end

	return EVENT_ROUTINE_END

end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    Room 5							-- --
-- --														-- --
-- --					 ( 메인 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_FIVE_ROUTINE( RoomEvent )
cExecCheck( "EVENT_ROOM_FIVE_ROUTINE" )

	if RoomEvent == nil then
		return
	end


	if RoomEvent["Room"]["RoomNumber"] ~= 5 then
		return
	end


	if RoomEvent["Room"]["Data"] == nil then
		return
	end


	if RoomEvent["Room"]["RE_State"] == RE_STATE_1 then

		local PlayerList
		local DoorLoc


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"], 1, DOOR_CAMERAMOVE["AbstateTime"] )

		end


		DoorLoc = DOOR_BLOCK_DATA[3]["REGEN_POSITION"]



		-- 서버와 클라 방향 맞춰줌
		local tmpdir = (DoorLoc["DIR"] + 180) * (-1)


		tmpdir = tmpdir % 360

		cCameraMove( RoomEvent["MapIndex"], DoorLoc["X"], DoorLoc["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )

		RoomEvent["Room"]["Data"]["CameraCheckTime"] =	RoomEvent["CurrentTime"] + DOOR_CAMERAMOVE["KeepTime"]

		RoomEvent["Room"]["RE_State"] 				 = RE_STATE_2

		RoomEvent["DoorCheckTime"] = RoomEvent["CurrentTime"] + DOOR_CHECK_TIME

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_2 then

		if RoomEvent["CurrentTime"] < RoomEvent["DoorCheckTime"] then

			return

		end


		local DoorInfo


		DoorInfo = RoomEvent["DoorList"][3]

		cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

		RoomEvent["Room"]["RE_State"] = RE_STATE_3

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_3 then

		if RoomEvent["Room"]["Data"]["CameraCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], DOOR_CAMERAMOVE["AbstateIndex"] )

		end

		RoomEvent["CameraCheckTime"] = nil

		cCameraMove( RoomEvent["MapIndex"], 0, 0, 0, 0, 0, 0 )

		RoomEvent["Room"]["RE_State"] = RE_STATE_4


		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_4 then

		if RoomEvent["Room"]["Data"]["Citrie"]  ~= nil then

			return

		end

		RoomEvent["Room"]["Data"]["RegenDavildom"] = nil

		if RoomEvent["Room"]["Data"]["ForasChief"] ~= nil then

			cAIScriptSet( RoomEvent["Room"]["Data"]["ForasChief"]["Handle"] )
			cNPCVanish( RoomEvent["Room"]["Data"]["ForasChief"]["Handle"] )
			RoomEvent["Room"]["Data"]["ForasChief"] = nil

		end

		RoomEvent["Room"]["RE_State"] = RE_STATE_5

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_5 then

		local ForasChiefData 		= { }
		local ForasChief			= { }


		ForasChiefData 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]

		ForasChief["Handle"] = cMobRegen_XY( RoomEvent["MapIndex"], ForasChiefData["MOB_INDEX"],
															ForasChiefData["START_POSITION"]["X"],
															ForasChiefData["START_POSITION"]["Y"],
															ForasChiefData["START_POSITION"]["DIR"] )


		if 	ForasChief["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, ForasChief["Handle"] )
			cAIScriptFunc	( ForasChief["Handle"], "Entrance", "ROOM_FIVE_FORASCHEIF_ROUTINE" )
			cSetAbstate		( ForasChief["Handle"], STA_IMMORTAL, 1, 20000000 )

			ForasChief["MobChatData"]	= ForasChiefData["MOB_CHAT"]
			ForasChief["FC_State"]		= FC_MOVE

		end

		RoomEvent["Room"]["Data"]["ForasChief"] = ForasChief



		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cSetAbstate( PlayerList[i], ENDING_CAMERAMOVE["AbstateIndex"], 1, ENDING_CAMERAMOVE["AbstateTime"] )

		end


		local ForasChiefData 	= { }
		local ForasChief		= RoomEvent["Room"]["Data"]["ForasChief"]


		ForasChiefData 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]


		local tmpdir = (ForasChiefData["START_POSITION"]["DIR"] + 180) * (-1)


		tmpdir = tmpdir % 360
		cCameraMove( RoomEvent["MapIndex"], ForasChiefData["END_POSITION"]["X"], ForasChiefData["END_POSITION"]["Y"], tmpdir, DOOR_CAMERAMOVE["AngleY"], DOOR_CAMERAMOVE["Distance"], 1 )


		RoomEvent["Room"]["RE_State"] = RE_STATE_6

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_6 then

		local ForasChief 		= RoomEvent["Room"]["Data"]["ForasChief"]
		local CurLoc 			= { }
		local ForasChiefData 	= { }


		CurLoc["X"], CurLoc["Y"] = cObjectLocate( ForasChief["Handle"] )
		ForasChiefData 			 = EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]

		if cDistanceSquar( CurLoc["X"], CurLoc["Y"], ForasChiefData["END_POSITION"]["X"], ForasChiefData["END_POSITION"]["Y"] ) < ( MOVE_INTERVER * MOVE_INTERVER ) then

			RoomEvent["Room"]["RE_State"] = RE_STATE_7

		end

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_7 then

		local ForasChiefData 	= { }
		local ForasChief		= RoomEvent["Room"]["Data"]["ForasChief"]


		ForasChiefData 	= EVENT_ROOM_DATA[RoomEvent["Room"]["RoomNumber"]]["FORAS_CHIEF"]


		local tmpdir = (ForasChiefData["START_POSITION"]["DIR"] + 180) * (-1)


		tmpdir = tmpdir % 360
		cCameraMove( RoomEvent["MapIndex"], ForasChiefData["END_POSITION"]["X"], ForasChiefData["END_POSITION"]["Y"], tmpdir, ENDING_CAMERAMOVE["AngleY"], ENDING_CAMERAMOVE["Distance"], 1 )
		RoomEvent["Room"]["Data"]["CameraCheckTime"] =	RoomEvent["CurrentTime"] + ENDING_CAMERAMOVE["KeepTime"]


		ForasChief["ChatCheckTime"]	= RoomEvent["CurrentTime"] + ForasChief["MobChatData"]["DELAY"]

		RoomEvent["Room"]["RE_State"] = RE_STATE_8

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_8 then

		local ForasChief


		ForasChief = RoomEvent["Room"]["Data"]["ForasChief"]

		if ForasChief["ChatCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end



		cMobShout( ForasChief["Handle"], "WarBL", ForasChief["MobChatData"]["INDEX"][1] )
		ForasChief["ChatCheckTime"]	= RoomEvent["CurrentTime"] + ForasChief["MobChatData"]["DELAY"]

		RoomEvent["Room"]["RE_State"] = RE_STATE_9

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_9 then

		local ForasChief


		ForasChief = RoomEvent["Room"]["Data"]["ForasChief"]

		if ForasChief["ChatCheckTime"] < RoomEvent["CurrentTime"] then

			cMobShout( ForasChief["Handle"], "WarBL", ForasChief["MobChatData"]["INDEX"][2] )
			ForasChief["ChatCheckTime"] = RoomEvent["CurrentTime"] + 100

			return

		end

		if RoomEvent["Room"]["Data"]["CameraCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end


		local PlayerList


		PlayerList = { cGetPlayerList( RoomEvent["MapIndex"] ) }


		for i=1, #PlayerList do

			cResetAbstate( PlayerList[i], ENDING_CAMERAMOVE["AbstateIndex"] )

		end

		RoomEvent["CameraCheckTime"] = nil

		cCameraMove( RoomEvent["MapIndex"], 0, 0, 0, 0, 0, 0 )

		RoomEvent["Room"]["RE_State"] = RE_STATE_10

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_10 then

		RoomEvent["EndGate"] = { }


		local EndGateData	= { }
		local EndGate		= { }


		EndGateData 			= GATE_DATA["END_GATE"]
		EndGate["Handle"]		= cMobRegen_XY( RoomEvent["MapIndex"], EndGateData["GATE_INDEX"],
															EndGateData["REGEN_POSITION"]["X"],
															EndGateData["REGEN_POSITION"]["Y"],
															EndGateData["REGEN_POSITION"]["DIR"] )

		if EndGate["Handle"] ~= nil then

			cSetAIScript	( SCRIPT_MAIN, EndGate["Handle"] )
			cAIScriptFunc	( EndGate["Handle"], "Entrance", "EndGateRoutine" )
			cAIScriptFunc	( EndGate["Handle"], "NPCClick", "EndGateClick"   )

		end

		GATE_MAP_INDEX[EndGate["Handle"]] 			= RoomEvent["MapIndex"]

		RoomEvent["EndGate"][EndGate["Handle"]]		= EndGate

		MAPMARK( RoomEvent )

	end

	return EVENT_ROUTINE_END

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    ENDING							-- --
-- --														-- --
-- --					 ( 메인 루틴 )						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function EVENT_ROOM_ENDING_ROUTINE( RoomEvent )
cExecCheck( "EVENT_ROOM_ENDING_ROUTINE" )

if RoomEvent == nil then
		return
	end


	if RoomEvent["Room"]["RoomNumber"] ~= 6 then
		return
	end


	if RoomEvent["Room"]["Data"] == nil then
		return
	end


	local EndingData = RoomEvent["Room"]["Data"]["EndingData"]


	if RoomEvent["Room"]["RE_State"] == RE_STATE_1 then

		cNotice( RoomEvent["MapIndex"], EndingData[1]["FileName"], EndingData[1]["Index"] )

		RoomEvent["Room"]["Data"]["EndingCheckTime"] = RoomEvent["CurrentTime"] + EndingData[1]["WaitTime"]

		RoomEvent["Room"]["RE_State"] = RE_STATE_2

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_2 then

		if RoomEvent["Room"]["Data"]["EndingCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end

		cNotice( RoomEvent["MapIndex"], EndingData[2]["FileName"], EndingData[2]["Index"] )

		RoomEvent["Room"]["Data"]["EndingCheckTime"] = RoomEvent["CurrentTime"] + EndingData[2]["WaitTime"]

		RoomEvent["Room"]["RE_State"] = RE_STATE_3

		return


	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_3 then

		if RoomEvent["Room"]["Data"]["EndingCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end

		cNotice( RoomEvent["MapIndex"], EndingData[3]["FileName"], EndingData[3]["Index"] )

		RoomEvent["Room"]["Data"]["EndingCheckTime"] = RoomEvent["CurrentTime"] + EndingData[3]["WaitTime"]

		RoomEvent["Room"]["RE_State"] = RE_STATE_4

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_4 then

		if RoomEvent["Room"]["Data"]["EndingCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end

		cNotice( RoomEvent["MapIndex"], EndingData[4]["FileName"], EndingData[4]["Index"] )

		RoomEvent["Room"]["Data"]["EndingCheckTime"] = RoomEvent["CurrentTime"] + EndingData[4]["WaitTime"]

		RoomEvent["Room"]["RE_State"] = RE_STATE_5

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_5 then

		if RoomEvent["Room"]["Data"]["EndingCheckTime"] > RoomEvent["CurrentTime"] then

			return

		end


		cLinkToAll( RoomEvent["MapIndex"], GATE_DATA["END_GATE"]["LINK"]["FIELD"], GATE_DATA["END_GATE"]["LINK"]["X"], GATE_DATA["END_GATE"]["LINK"]["Y"] )

		RoomEvent["Room"]["RE_State"] = RE_STATE_6

		return

	elseif RoomEvent["Room"]["RE_State"] == RE_STATE_6 then

		return

	end

	return

end




EVENT_ROOM_ROUTINE = { }


EVENT_ROOM_ROUTINE[1] = EVENT_ROOM_ONE_ROUTINE
EVENT_ROOM_ROUTINE[2] = EVENT_ROOM_TWO_ROUTINE
EVENT_ROOM_ROUTINE[3] = EVENT_ROOM_THREE_ROUTINE
EVENT_ROOM_ROUTINE[4] = EVENT_ROOM_FOUR_ROUTINE
EVENT_ROOM_ROUTINE[5] = EVENT_ROOM_FIVE_ROUTINE
EVENT_ROOM_ROUTINE[6] = EVENT_ROOM_ENDING_ROUTINE
