--------------------------------------------------------------------------------
--                          KDFargels Progress Func                           --
--------------------------------------------------------------------------------


-- Init Function
function EVENT_INIT_FUNCTION_1( EventMemory )
cExecCheck( "EVENT_INITFUNCTION_1" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 1 then

		return

	end

end


function EVENT_INIT_FUNCTION_2( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_2" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 2 then

		return

	end

	-- 리젠 오브젝트 소환(감시초소, 케이지 포함)

	function SetRegenObject( Object, Data )

		local RegenData		= Data["REGEN_DATA"]
		local RegenInfoList = {}

		for i = 1, #RegenData do

			local RegenInfo = { }

			RegenInfo["REGEN_DATA"]		= RegenData[i]
			RegenInfo["CheckTime"] 		= 0
			RegenInfo["CheckCount"] 	= 0
			RegenInfoList[i] 			= RegenInfo

		end

		Object["RegenInfoList"]		= RegenInfoList
		Object["CheckCondition"] 	= false
		Object["REGENOBJECT_DATA"]	= Data
		Object["EventNumber"]		= EventMemory["EventNumber"]

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "REGENOBJECT_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "REGENOBJECT", "RegenObjectList", SetRegenObject )


	-- 다크 리치 소환
	function SetDLich( Object, Data )

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "DLICH_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "DLICH", "DLichList", SetDLich )

end


function EVENT_INIT_FUNCTION_3( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_3" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 3 then

		return

	end

	-- 토린 소환
	function SetTorin( Object, Data )

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "TORIN_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "TORIN", "TorinList", SetTorin )

	-- 리젠 오브젝트 소환

	function SetRegenObject( Object, Data )

		local RegenData		= Data["REGEN_DATA"]
		local RegenInfoList = {}

		for i = 1, #RegenData do

			local RegenInfo = { }

			RegenInfo["REGEN_DATA"]		= RegenData[i]
			RegenInfo["CheckTime"] 		= 0
			RegenInfo["CheckCount"] 	= 0
			RegenInfoList[i] 			= RegenInfo

		end

		Object["RegenInfoList"]		= RegenInfoList
		Object["CheckCondition"] 	= false
		Object["REGENOBJECT_DATA"]	= Data
		Object["EventNumber"]		= EventMemory["EventNumber"]

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "REGENOBJECT_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "REGENOBJECT", "RegenObjectList", SetRegenObject )


	-- 다크 리치 소환
	function SetDLich( Object, Data )

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "DLICH_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "DLICH", "DLichList", SetDLich )

end

function EVENT_INIT_FUNCTION_4( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_4" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 4 then

		return

	end

	-- 리젠 오브젝트 소환(경보석 포함)

	function SetRegenObject( Object, Data )

		local RegenData		= Data["REGEN_DATA"]
		local RegenInfoList = {}

		for i = 1, #RegenData do

			local RegenInfo = { }

			RegenInfo["REGEN_DATA"]		= RegenData[i]
			RegenInfo["CheckTime"] 		= 0
			RegenInfo["CheckCount"] 	= 0
			RegenInfoList[i] 			= RegenInfo

		end

		Object["RegenInfoList"]		= RegenInfoList
		Object["CheckCondition"] 	= false
		Object["REGENOBJECT_DATA"]	= Data
		Object["EventNumber"]		= EventMemory["EventNumber"]

		cSetAbstate( Object["Handle"], "StaImmortal", 1, 99999999 )
		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "REGENOBJECT_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "REGENOBJECT", "RegenObjectList", SetRegenObject )


	-- 에피스 소환
	function SetEpis( Object, Data )

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "EPIS_ROUTINE" )

	end

	CreateObjectList_XY( EventMemory, "EPIS", "EpisList", SetEpis )

end

function EVENT_INIT_FUNCTION_5( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_5" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 5 then

		return

	end

	-- 파겔스 소환
	function SetFargels( Object, Data )

		Object["SkillList"] = { }

		for i = 1, #FARGELS_SKILL do

			-- skill
			Object["SkillList"][i] 						= { }
			Object["SkillList"][i]["CheckTime"] 		= 0

			-- abstate
			Object["SkillList"][i]["AbstateList"]		= { }

			local AbstateData = FARGELS_SKILL[i]["ABSTATE"]

			if AbstateData ~= nil then

				for j = 1, #AbstateData do

					Object["SkillList"][i]["AbstateList"][j]						= { }
					Object["SkillList"][i]["AbstateList"][j]["CheckKeepTime"] 		= 0
					Object["SkillList"][i]["AbstateList"][j]["CheckPrepareTime"]	= 0
					Object["SkillList"][i]["AbstateList"][j]["CheckIntervalTime"]	= 0
					Object["SkillList"][i]["AbstateList"][j]["Enable"]				= false

				end

			end

		end

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "FARGELS_ROUTINE" )

		cSetAbstate( Object["Handle"], "StaImmortal", 1, 99999999 )

	end

	CreateObjectList_XY( EventMemory, "FARGELS", "FargelsList", SetFargels )


	-- 성역 기사단 소환
	function SetGuardians( Object, Data )

		cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
		cAIScriptFunc( Object["Handle"], "Entrance", "GUARDIANS_ROUTINE" )

		cSetAbstate( Object["Handle"], "StaImmortal", 1, 99999999 )

	end

	CreateObjectList_XY( EventMemory, "GUARDIANS", "GuardiansList", SetGuardians )

end

function EVENT_INIT_FUNCTION_6( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_6" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 6 then

		return

	end

end


-- DeInit Function
function EVENT_DEINIT_FUNCTION( EventMemory )
cExecCheck( "EVENT_INIT_FUNCTION_1" )

	EventMemory["EM_STATE"] 	= EM_STATE["Start"]
	EventMemory["EventNumber"] 	= EventMemory["EventNumber"] + 1
	EventMemory["EventState"] 	= ES_STATE["STATE_1"]

end


-- Event Routine
function EVENT_ROUTINE_1( EventMemory )
cExecCheck( "EVENT_ROUTINE_1" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventNumber"] ~= 1 then

		return

	end

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		EventMemory["FaceCut"]["CheckTime"] = EventMemory["CurrentTime"] + 20

		--cDebugLog( "FaceCut CheckTime :" .. EventMemory["FaceCut"]["CheckTime"] )

		EventMemory["EventState"] = ES_STATE["STATE_2"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		-- timer
		if EventMemory["MapIndex"] ~= nil then

			local LimitTime = cGetKQLimitSecond( EventMemory["MapIndex"] )

			if LimitTime ~= nil then

				EventMemory["CheckLimitTime"] = cCurrentSecond() + LimitTime

				--cTimer()
				cShowKQTimerWithLife( EventMemory["MapIndex"], LimitTime )

			end

		end

		function SetAbstate( Object, Data )

			cSetAbstate( Object["Handle"], "StaImmortal", 1, 99999999 )

		end

		CreateObjectList_XY( EventMemory, "TORIN", "TorinList", SetAbstate )

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

		local TorinList = EventMemory["EventData"]["TorinList"]

		for index, value in pairs( TorinList ) do

			local Torin = TorinList[index]

			if Torin ~= nil then

				if Torin["Handle"] ~= nil then

					cNPCVanish( Torin["Handle"] )

				end

			end
		end

		function SetScript( Object, Data )

			cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
			cAIScriptFunc( Object["Handle"], "Entrance", "DLICH_ROUTINE" )

		end

		CreateObjectList_XY( EventMemory, "DLICH", "DLichList", SetScript )

		EventMemory["EventState"] = ES_STATE["STATE_7"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_7"] then

		local DLichList = EventMemory["EventData"]["DLichList"]

		for index, value in pairs( DLichList ) do

			local DLich = DLichList[index]

			if DLich ~= nil then

				if DLich["Handle"] ~= nil then

					return

				end

			end

		end

		CameraMoveStart( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_8"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_8"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		CameraMoveEnd( EventMemory )

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

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_2"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		local DLichList = EventMemory["EventData"]["DLichList"]

		for index, value in pairs( DLichList ) do

			local DLich = DLichList[index]

			if DLich ~= nil then

				if DLich["Handle"] ~= nil then

					return

				end

			end

		end

		-- 리젠 몬스터 스턴
		--StunRegenObjectAll( EventMemory )

		CameraMoveStart( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_3"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		CameraMoveEnd( EventMemory )

		-- 리젠 몬스터 스턴 리셋
		--ResetStunRegenObjectAll( EventMemory )

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

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_2"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		FaceCut( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_3"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		if EventMemory["FaceCut"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		EventMemory["EventState"] = ES_STATE["STATE_4"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_4"] then

		local DLichList = EventMemory["EventData"]["DLichList"]

		for index, value in pairs( DLichList ) do

			local DLich = DLichList[index]

			if DLich ~= nil then

				if DLich["Handle"] ~= nil then

					return

				end

			end

		end

		-- 리젠 몬스터 스턴
		--StunRegenObjectAll( EventMemory )

		CameraMoveStart( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_5"]

	elseif EventMemory["EventState"] == ES_STATE["STATE_5"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		CameraMoveEnd( EventMemory )

		-- 리젠 몬스터 스턴 리셋
		--ResetStunRegenObjectAll( EventMemory )

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

	FaceCutThread( EventMemory )

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

		local EpisList = EventMemory["EventData"]["EpisList"]

		for index, value in pairs( EpisList ) do

			local Epis = EpisList[index]

			if Epis ~= nil then

				if Epis["Handle"] ~= nil then

					return

				end

			end

		end

		-- 리젠 몬스터 스턴
		--StunRegenObjectAll( EventMemory )

		FaceCutThreadStart( EventMemory, 4 )

		CameraMoveStart( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_9"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_9"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		CameraMoveEnd( EventMemory )

		-- 리젠 몬스터 스턴 리셋
		--ResetStunRegenObjectAll( EventMemory )

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

	FaceCutThread( EventMemory )

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		local FargelsList 	= EventMemory["EventData"]["FargelsList"]
		local FargelsHandle = nil

		if FargelsList ~= nil then

			for index, value in pairs( FargelsList ) do

				local Fargels = FargelsList[index]

				if Fargels ~= nil then

					if Fargels["Handle"] ~= nil then

						FargelsHandle = Fargels["Handle"]

					end

				end

			end

		end

		if FargelsHandle == nil then

			return

		end

		local FindPlayer = cObjectFind( FargelsHandle, 1000, ObjectType["Player"], "so_ObjectType" )

		if FindPlayer == nil then

			return

		end

		cResetAbstate( FargelsHandle, "StaImmortal" )

		local GuardiansList = EventMemory["EventData"]["GuardiansList"]

		if GuardiansList ~= nil then

			for index, value in pairs( GuardiansList ) do

				local Guardian = GuardiansList[index]

				if Guardian ~= nil then

					if Guardian["Handle"] ~= nil then

						cResetAbstate( Guardian["Handle"], "StaImmortal" )
						cAggroSet( Guardian["Handle"], FargelsHandle )

					end

				end

			end

		end

		local GuardianHandle = cObjectFind( FargelsHandle, 500, ObjectType["Mob"], "so_ObjectType" )

		if GuardianHandle ~= nil then

			cAggroSet( FargelsHandle, GuardianHandle )

		end

		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
		EventMemory["CameraMove"]["Focus"]["X"] 	= 9723
		EventMemory["CameraMove"]["Focus"]["Y"] 	= 10109
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( 0 + 180 ) * (-1)

		CameraMove( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_2"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_2"] then

		if EventMemory["CameraMove"]["CheckTime"] > EventMemory["CurrentTime"] then

			return

		end

		CameraMoveEnd( EventMemory )

		EventMemory["EventState"] = ES_STATE["STATE_3"]

		return

	elseif EventMemory["EventState"] == ES_STATE["STATE_3"] then

		local FargelsList = EventMemory["EventData"]["FargelsList"]

		if FargelsList ~= nil then

			for index, value in pairs( FargelsList ) do

				local Fargels = FargelsList[index]

				if Fargels ~= nil then

					if Fargels["Handle"] ~= nil then

						return

					end

				end

			end

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

	if EventMemory["EventState"] == ES_STATE["STATE_1"] then

		-- 보상
		--local PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		--for i = 1, #PlayerList do

			--if cIsKQJoiner( PlayerList[i] ) == true then

				--for j = 1, #REWARD_INFO do

					--cKQRewardIndex( PlayerList[i], REWARD_INFO[j]["REWARD_INDEX"] )

				--end

			--end

		--end

		cReward( EventMemory["MapIndex"], "KQ" )

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

		-- linkto, 킹퀘 종료]
		--cTimer()
		cShowKQTimerWithLife( EventMemory["MapIndex"], 0 )
		-- Quest Mob Kill 세기.
		cQuestMobKill_AllInMap( EventMemory["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )
		cLinkToAll( EventMemory["MapIndex"], LINK_INFO["RETURNMAP1"]["MAP_INDEX"], LINK_INFO["RETURNMAP1"]["X"], LINK_INFO["RETURNMAP1"]["Y"])
		cEndOfKingdomQuest( EventMemory["MapIndex"] )

		return

	end

	--cDebugLog( "Game Over" )
	EVENT_GAME_OVER = true

end

EVENT_ROUTINE = { }
EVENT_ROUTINE[1] = EVENT_ROUTINE_1
EVENT_ROUTINE[2] = EVENT_ROUTINE_2
EVENT_ROUTINE[3] = EVENT_ROUTINE_3
EVENT_ROUTINE[4] = EVENT_ROUTINE_4
EVENT_ROUTINE[5] = EVENT_ROUTINE_5
EVENT_ROUTINE[6] = EVENT_ROUTINE_6

EVENT_INIT_FUCTION 		= { }
EVENT_INIT_FUCTION[1] 	= EVENT_INIT_FUNCTION_1
EVENT_INIT_FUCTION[2] 	= EVENT_INIT_FUNCTION_2
EVENT_INIT_FUCTION[3] 	= EVENT_INIT_FUNCTION_3
EVENT_INIT_FUCTION[4] 	= EVENT_INIT_FUNCTION_4
EVENT_INIT_FUCTION[5] 	= EVENT_INIT_FUNCTION_5
EVENT_INIT_FUCTION[6] 	= EVENT_INIT_FUNCTION_6
