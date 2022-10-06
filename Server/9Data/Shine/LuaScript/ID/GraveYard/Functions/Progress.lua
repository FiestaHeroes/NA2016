--------------------------------------------------------------------------------
--                      	Progress Func 			                          --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- InitDungeon
--------------------------------------------------------------------------------
-- 던전 초기화
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- 인스턴스 던전 시작 전에 플레이어의 첫 로그인을 기다린다.
	if Var["bPlayerMapLogin"] == nil
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			GoToFail( Var )
			return
		end

		return
	end

	if Var["InitDungeon"] == nil
	then
		DebugLog( "Start InitDungeon" )

		Var["InitDungeon"] = {}


		-- 문 생성
		for i = 1, #RegenInfo["Stuff"]["Door"]
		do
			local CurRegenDoor 	= RegenInfo["Stuff"]["Door"][ i ]
			local CurDoorInfo 	= DoorInfo[ CurRegenDoor["Name"] ]

			if CurRegenDoor == nil
			then
				ErrorLog( "InitDungeon::Door CurRegenDoor == nil : "..i )
			else
				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle == nil
				then
					ErrorLog( "InitDungeon::Door was not created. : "..i )
				else
					cDoorAction( nCurDoorHandle, CurDoorInfo["Block"], "close" )

					-- 아이템으로 여는 문 설정
					if CurDoorInfo["NeedItem"] ~= nil
					then
						if cSetAIScript ( MainLuaScriptPath, nCurDoorHandle ) == nil
						then
							ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nCurDoorHandle ) == nil : "..i )
						end

						if  cAIScriptFunc( nCurDoorHandle, "NPCClick", "Click_Door" ) == nil
						then
							ErrorLog( "InitDungeon::cAIScriptFunc( nCurDoorHandle, \"NPCClick\", \"Click_Door\" ) : "..i )
						end

						if  cAIScriptFunc( nCurDoorHandle, "NPCMenu", "Menu_Door" ) == nil
						then
							ErrorLog( "InitDungeon::cAIScriptFunc( nCurDoorHandle, \"NPCMenu\", \"Menu_Door\" ) : "..i )
						end
					end

					-- 문 정보 보관
					Var["Door"][ nCurDoorHandle ]			= {}
					Var["Door"][ nCurDoorHandle ]["Info"]	= CurDoorInfo
					Var["Door"][ nCurDoorHandle ]["IsOpen"]	= false
					Var["Door"][ CurRegenDoor["Name"] ] 	= nCurDoorHandle

					-- 쌍둥이 게이트 있으면, 그 정보도 저장
					if CurDoorInfo["TwinGate"] ~= nil
					then
						Var["Door"][ nCurDoorHandle ]["TwinGate"] = CurDoorInfo["TwinGate"]
					end
				end
			end
		end

		-- 입구쪽 출구게이트 생성
		local RegenExitGate  	= RegenInfo["Stuff"]["StartExitGate"]
		local nExitGateHandle 	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			DebugLog("InitDungeon::입구쪽 출구게이트 생성")

			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
			end
		end

		-- 몬스터 그룹별 생성
		local RegenMobGroupList = RegenInfo["Mob"]["InitDungeon"]["NormalMobGroup"]

		if RegenMobGroupList ~= nil
		then
			DebugLog("InitDungeon::몬스터 생성")

			for i = 1, #RegenMobGroupList
			do
				cGroupRegenInstance( Var["MapIndex"], RegenMobGroupList[ i ] )
			end
		end

		-- 대기시간 설정
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end


	-- 대기 후 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end

	--GoToNextStep( Var )
	Var["StepFunc"]		= Step_Routine
	Var["InitDungeon"] 	= nil
	DebugLog( "End InitDungeon" )
	return
end

--------------------------------------------------------------------------------
-- Step_Routine ( 보스몹에 붙여줄 스크립트 )
--------------------------------------------------------------------------------
function Step_Routine( Var )
cExecCheck "Step_Routine"

	if Var == nil
	then
		return
	end



	-- 열린 문에 해당하는 몹 리젠 처리해준다.
	if Var["GateProcess"] ~= nil
	then
		for i, v in pairs( Var["GateProcess"] )
		do
			local StepIndex = tostring( i )

			if v["IsProceed"] == false
			then

				-- 일반 몹 그룹 리젠
				local RegenMobGroupList = RegenInfo["Mob"][ StepIndex ]["NormalMobGroup"]

				if RegenMobGroupList ~= nil
				then
					for i = 1,#RegenMobGroupList
					do
						cGroupRegenInstance( Var["MapIndex"], RegenMobGroupList[ i ] )
					end
				end

				-- 보스 생성
				local RegenBossMobList = RegenInfo["Mob"][ StepIndex ]["Boss"]

				for i = 1, #RegenBossMobList
				do
					local CurRegenBoss	= RegenBossMobList[ i ]
					local nBossHandle 	= cMobRegen_XY( Var["MapIndex"], CurRegenBoss["Index"], CurRegenBoss["x"], CurRegenBoss["y"], CurRegenBoss["dir"] )

					if nBossHandle == nil
					then
						ErrorLog( StepIndex.."::Boss was not created. : "..i )
					else
						-- 보스 AI 설정
						local CurRegenBossInfo = BossInfo[ CurRegenBoss["Index"] ]

						if CurRegenBossInfo ~= nil
						then
							if cSetAIScript ( MainLuaScriptPath, nBossHandle ) == nil
							then
								ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nCurDoorHandle ) == nil : "..i )
							end

							if  cAIScriptFunc( nBossHandle, "Entrance", CurRegenBossInfo["Lua_EntranceFunc"] ) == nil
							then
								ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"Entrance\", "..CurRegenBossInfo["Lua_EntranceFunc"].." ) : "..i )
							end
						end

						-- 보스 정보 설정
						Var["Enemy"][ CurRegenBoss["Index"] ]		= nBossHandle

						Var["Enemy"][ nBossHandle ]					= {}
						Var["Enemy"][ nBossHandle ]["Index"]		= CurRegenBoss["Index"]
						Var["Enemy"][ nBossHandle ]["Info"]			= CurRegenBossInfo
						Var["Enemy"][ nBossHandle ]["Phase"]		= 1

						Var["RoutineTime"][ nBossHandle ]			= cCurrentSecond()
					end
				end
				-- 처리완료했으므로 true로 세팅
				v["IsProceed"] = true
			end
		end
	end



	-- 보스방 문이 열렸는지 체크
	if Var["GateProcess"]["DoorBoss"] ~= nil
	then
		-- 보스방 몹들 리젠 처리가 완료됐는지 체크
		if Var["GateProcess"]["DoorBoss"]["IsProceed"] == true
		then

			if Var["Step_Routine_Boss"] == nil
			then
				Var["Step_Routine_Boss"] = {}
				DebugLog("Step_Routine_Boss 테이블 생성")
			end

			if Var["Step_Routine_Boss"] ~= nil
			then
				-- 대사 처리
				if Var["Step_Routine_Boss"]["Chat"] == nil
				then
					local BossIndex 	= RegenInfo["Mob"]["DoorBoss"]["Boss"][1]["Index"]
					local BossHandle 	= Var["Enemy"][ BossIndex ]

					if cIsObjectDead( BossHandle ) == nil
					then
						return
					end

					Var["Step_Routine_Boss"]["Chat"] = {}
					DebugLog("Step_Routine_Boss :: Chat 테이블 생성")

					if ChatInfo[BossIndex] ~= nil
					then
						cMobChat( BossHandle, ChatInfo["ScriptFileName"], ChatInfo[BossIndex]["Index"], ChatInfo[BossIndex]["IsShowChatWindow"] )
					end
				end

				if Var["Step_Routine_Boss"]["IDEnd"] == nil
				then
					Var["Step_Routine_Boss"]["IDEnd"] = {}
					DebugLog("Step_Routine_Boss :: IDEnd 테이블 생성")

					-- 일일퀘스트 처리
					cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

					-- 출구게이트 생성
					local RegenExitGate		= RegenInfo["Stuff"]["EndExitGate"]
					local nExitGateHandle	= cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

					if nExitGateHandle ~= nil
					then
						if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
						then
							ErrorLog( "ReturnToHome::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
						end

						if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
						then
							ErrorLog( "ReturnToHome::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
						end
					end
				end
			end
		end
	end

end

