--------------------------------------------------------------------------------
--                         Gold Hill Progress Func                            --
--------------------------------------------------------------------------------

-- 던전 초기화
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- 킹덤 퀘스트 시작 전에 플레이어의 첫 로그인을 기다린다.
	if Var["bPlayerMapLogin"] == nil
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			GoToFail( Var )
			return
		end

		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["InitDungeon"] == nil
	then
		DebugLog( "Start InitDungeon" )

		local Doors = RegenInfo["Stuff"]
		Var["Door"] = {}

		-- 문 생성
		for i = 1, #LayerNameTable
		do
			local LayerName 			= LayerNameTable[ i ]
			Var["Door"][ LayerName ]	= cDoorBuild( Var["MapIndex"], Doors[ LayerName ]["Index"], Doors[ LayerName ]["x"], Doors[ LayerName ]["y"], Doors[ LayerName ]["dir"], Doors[ LayerName ]["scale"] )

			if Var["Door"][ LayerName ] ~= nil
			then
				cSetAIScript ( MainLuaScriptPath, Var["Door"][ LayerName ] )
				cAIScriptFunc( Var["Door"][ LayerName ], "NPCClick", "DoorClick" )

				cDoorAction( Var["Door"][ LayerName ], Doors[ LayerName ]["Block"], "close" )
			end
		end

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]

	end

	-- 일정 시간 뒤 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 인트로
function Intro( Var )
cExecCheck "Intro"

	if Var == nil
	then
		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["Intro"] == nil
	then
		DebugLog( "Start Intro" )

		Var["Intro"] = {}
		Var["Intro"]["DialogStepSec"] 	= Var["CurSec"]
		Var["Intro"]["DialogStepNo"] 	= 1

	end


	-- 다이얼로그(페이스컷) 단계 체크 및 실행
	if Var["Intro"]["DialogStepNo"] <= #TombRaiderChat["Intro"]
	then

		-- 페이스컷 처리
		if Var["Intro"]["DialogStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], RegenInfo["Mob"]["TombRaider"]["Index"], TombRaiderChat["ScriptFileName"], TombRaiderChat["Intro"][ Var["Intro"]["DialogStepNo"] ]["Index"] )

			Var["Intro"]["DialogStepSec"] = Var["CurSec"] + DelayTime["BetweenIntroDialog"]	-- 다음 페이스 컷 띄울 시간 셋팅
			Var["Intro"]["DialogStepNo"]  = Var["Intro"]["DialogStepNo"] + 1				-- 다음 페이스 컷으로 단계 셋팅
		end

	else

		GoToNextStep( Var )
		Var["Intro"]	= nil
		DebugLog( "End Intro" )
		return

	end

end


-- 황금언던 Layer 1 ~ 4
function LayerStep( Var )
cExecCheck "LayerStep"

	if Var == nil
	then
		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["LayerStep"] == nil
	then
		Var["LayerStep"] = {}
		Var["LayerStep"]["LayerNumber"] = 1
	end


	if Var["LayerStep"]["LayerNumber"] <= #LayerNameTable
	then

		local LayerName = LayerNameTable[ Var["LayerStep"]["LayerNumber"] ]
		if Var[ LayerName ] == nil
		then
			DebugLog( "Start LayerStep "..LayerName )

			-- 몬스터 소환
			local CurRegenLayer = RegenInfo["Group"][ LayerName ]
			for i = 1, #CurRegenLayer
			do
				cGroupRegenInstance( Var["MapIndex"], CurRegenLayer[i] )
			end


			Var[ LayerName ] = {}
--			Var[ LayerName ]["WaitSecDuringMobGen"]	= Var["CurSec"] + DelayTime["AfterMobGen"]


			-- 제한 시간 설정
			Var["KQLimitTime"] = Var["CurSec"] + LimitTime[ LayerName ]
			cShowKQTimerWithLife( Var["MapIndex"], LimitTime[ LayerName ] )
			return;
		end

		if Var[ LayerName ]["KeyCore"] == nil
		then

			-- 다이얼로그 출력
			cMobDialog( Var["MapIndex"], RegenInfo["Mob"]["TombRaider"]["Index"], TombRaiderChat["ScriptFileName"], TombRaiderChat[ LayerName ]["Index"] )

			-- 광석 열쇠 드랍 설정
			local TotalCore	= 0
			for i = 1, #ItemDrop["DropMob"]
			do
				local CoreList	= { cFindNearestMobList( Var["MapIndex"], ItemDrop["DropMob"][ i ] ) }
				TotalCore 		= TotalCore + #CoreList

				for j = 1, #CoreList
				do
					if CoreList[ j ] ~= nil
					then
						cSetAIScript ( MainLuaScriptPath, CoreList[ j ] )
						cAIScriptFunc( CoreList[ j ], "Entrance", "CoreBreakRoutine" )
					end
				end
			end

			local ItemDropInfo 					= ItemDrop[ LayerName ]
			Var[ LayerName ]["KeyCore"] 		= {}
			Var[ LayerName ]["DeadCoreCount"]	= 0
			for i = 1, #ItemDropInfo
			do
				Var[ LayerName ]["KeyCore"][i] = cRandomInt( ItemDropInfo[i]["RandMin"], ItemDropInfo[i]["RandMax"] )
				Var[ LayerName ]["KeyCore"][i] = (Var[ LayerName ]["KeyCore"][i] * TotalCore) / 100
			end

		end


		-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
		if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
		then
			GoToFail( Var )

			Var[ LayerName ] = nil
			Var["LayerStep"] = nil
			return
		end


		-- Fail Case : 타임 오버
		if IsKQTimeOver( Var ) == true
		then
			GoToFail( Var )

			Var[ LayerName ] = nil
			Var["LayerStep"] = nil
			return
		end

	else

		DebugLog( "End LayerStep" )

		Var["LayerStep"] = nil
		GoToNextStep( Var )
		return

	end

end


-- 보스 전투
function LastBattle( Var )
cExecCheck "LastBattle"


	if Var == nil
	then
		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- 최상층 셋팅
	if Var["LastBattle"] == nil
	then
		DebugLog( "Start LastBattle" )

		local RegenTombRaider		= RegenInfo["Mob"]["TombRaider"]
		Var["Enemy"]["TombRaider"]	= cMobRegen_XY( Var["MapIndex"], RegenTombRaider["Index"], RegenTombRaider["x"], RegenTombRaider["y"], RegenTombRaider["dir"] )

		Var["LastBattle"] = {}
		Var["LastBattle"]["DialogStepSec"]	= Var["CurSec"]
		Var["LastBattle"]["DialogStepNo"] 	= 1

		-- 제한 시간 설정
		Var["KQLimitTime"] = Var["CurSec"] + LimitTime[ "LastBattle" ]
		cShowKQTimerWithLife( Var["MapIndex"], LimitTime[ "LastBattle" ] )
	end


	-- 다이얼로그(페이스컷) 단계 체크 및 실행
	if Var["LastBattle"]["DialogStepNo"] <= #TombRaiderChat["LastBattle"]
	then

		-- 다이얼로그 처리
		if Var["LastBattle"]["DialogStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], RegenInfo["Mob"]["TombRaider"]["Index"], TombRaiderChat["ScriptFileName"], TombRaiderChat["LastBattle"][ Var["LastBattle"]["DialogStepNo"] ]["Index"] )

			Var["LastBattle"]["DialogStepSec"] 	= Var["CurSec"] + DelayTime["BetweenLastBattleDialog"] 	-- 다음 페이스컷 띄울 시간 셋팅
			Var["LastBattle"]["DialogStepNo"] 	= Var["LastBattle"]["DialogStepNo"] + 1					-- 다음 단계 변호 셋팅
		end

	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["LastBattle"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["LastBattle"] = nil
		return
	end


	--
	local bEndLastBattle = true
	if Var["Enemy"]["TombRaider"] ~= nil
	then
		if cIsObjectDead( Var["Enemy"]["TombRaider"] ) == nil
		then
			bEndLastBattle = false
		end
	end


	-- Success Case :
	if bEndLastBattle == true
	then
		GoToNextStep( Var )
		Var["LastBattle"] 			= nil
		Var["Enemy"]["TombRaider"] 	= nil
		DebugLog( "End LastBattle" )
		return
	end

end

-- 킹덤 퀘스트 완료 게이트
function EndGate( Var )
cExecCheck "EndGate"


	if Var == nil
	then
		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["EndGate"] == nil
	then
		DebugLog( "Start EndGate" )

		local RegenNPC 	= RegenInfo["NPC"]["Gate"]
		local NPCHandle	= cMobRegen_XY( Var["MapIndex"], RegenNPC["Index"], RegenNPC["x"], RegenNPC["y"], RegenNPC["dir"] )

		if NPCHandle ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, NPCHandle )

			cAIScriptFunc( NPCHandle, "Entrance", "DummyFunc" )
			cAIScriptFunc( NPCHandle, "NPCClick", "EndGateClick" )
		end

		 Var["EndGate"] = {}
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["LastBattle"] = nil
		return
	end

end

-- 킹덤 퀘스트 클리어
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end


	DebugLog( "Start QuestSuccess" )

	-- Success 띄우고
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Success" )

	-- 플레이어에게 클리어 보상 주기
	cReward( Var["MapIndex"], "KQ" )

	-- Quest Mob Kill 세기.
	cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )


	GoToNextStep( Var )
	Var["QuestSuccess"] = nil
	DebugLog( "End QuestSuccess" )

end


-- 킹덤 퀘스트 실패
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end


	DebugLog( "Start QuestFailed" )

	-- Fail 띄우고
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Fail" )

	GoToNextStep( Var )

	DebugLog( "End QuestFailed" )

	Var["QuestFailed"] = {}

end


-- 귀환
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )
		Var["ReturnToHome"] = {}
		Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"]  = 1
	end


	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo["KQReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then

			-- Notice of Escape
			if NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["BetweenKQReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["KQReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_KQ
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

			GoToNextStep( Var )
			Var["ReturnToHome"] = nil

			if cEndOfKingdomQuest( Var["MapIndex"] ) == nil
			then
				ErrorLog( "ReturnToHome::Function cEndOfKingdomQuest failed" )
			end

			DebugLog( "End ReturnToHome" )
		end

		return

	end


end


-- 스텝 구분을 위한 던전 진행 함수 리스트
KQ_StepsList =
{
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = Intro, 	   Name = "Intro",        },
	{ Function = LayerStep,    Name = "LayerStep",    },
	{ Function = LastBattle,   Name = "LastBattle",   },
	{ Function = EndGate,      Name = "EndGate",      },
	{ Function = QuestSuccess, Name = "QuestSuccess", },
	{ Function = QuestFailed,  Name = "QuestFailed",  },
	{ Function = ReturnToHome, Name = "ReturnToHome", },
}

-- 역참조 리스트
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end
