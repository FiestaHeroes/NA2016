--------------------------------------------------------------------------------
--                        Emperor Slime Progress Func                         --
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


	if Var["InitDungeon"] == nil
	then
		DebugLog( "Start InitDungeon" )

		local Doors = RegenInfo["Stuff"]

		-- 문 생성
		Var["Door1"] = cDoorBuild( Var["MapIndex"], Doors["Door1"]["Index"], Doors["Door1"]["x"], Doors["Door1"]["y"], Doors["Door1"]["dir"], Doors["Door1"]["scale"] )
		Var["Door2"] = cDoorBuild( Var["MapIndex"], Doors["Door2"]["Index"], Doors["Door2"]["x"], Doors["Door2"]["y"], Doors["Door2"]["dir"], Doors["Door2"]["scale"] )
		Var["Door3"] = cDoorBuild( Var["MapIndex"], Doors["Door3"]["Index"], Doors["Door3"]["x"], Doors["Door3"]["y"], Doors["Door3"]["dir"], Doors["Door3"]["scale"] )

		-- 문 닫기
		cDoorAction( Var["Door1"], Doors["Door1"]["Block"], "close" )
		cDoorAction( Var["Door2"], Doors["Door2"]["Block"], "close" )
		cDoorAction( Var["Door3"], Doors["Door3"]["Block"], "close" )

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"]

	end

	-- 일정 시간 뒤 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] + DelayTime["AfterInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 가디언의 경고
function GuideOfGuard( Var )
cExecCheck "GuideOfGuard"

	if Var == nil
	then
		return
	end


	if Var["GuideOfGuard"] == nil
	then
		DebugLog( "Start GuideOfGuard" )

		local RegenGuard	= RegenInfo["NPC"]["NPC_Guard"]
		local GuardHandle	= nil

		GuardHandle = cMobRegen_XY( Var["MapIndex"], RegenGuard["Index"], RegenGuard["x"], RegenGuard["y"], RegenGuard["dir"] )

		if GuardHandle ~= nil
		then
			Var["Friend"][ GuardHandle ] 			= { Index = RegenGuard["Index"], x = RegenGuard["x"], y = RegenGuard["y"], dir = RegenGuard["dir"] }
			Var["Friend"][ GuardHandle ]["Handle"] 	= GuardHandle
		end

		Var["GuideOfGuard"] = {}
		Var["GuideOfGuard"]["NoticeStepSec"] 	= Var["CurSec"]
		Var["GuideOfGuard"]["NoticeStepNo"] 	= 1

	end


	-- 다이얼로그(페이스컷) index 체크 및 실행
	if Var["GuideOfGuard"]["NoticeStepNo"] <= #NPC_GuardChat["StartWarnDialog"]
	then

		-- 페이스컷 처리
		if Var["GuideOfGuard"]["NoticeStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["StartWarnDialog"][ Var["GuideOfGuard"]["NoticeStepNo"] ]["Index"] )

			Var["GuideOfGuard"]["NoticeStepSec"] = Var["CurSec"] + DelayTime["BetweenGuardWarnDialog"]	-- 다음 페이스 컷 띄울 시간 셋팅
			Var["GuideOfGuard"]["NoticeStepNo"]  = Var["GuideOfGuard"]["NoticeStepNo"] + 1				-- 다음 페이스 컷으로 단계 셋팅
		end

	else

		for indexHandle, value in pairs( Var["Friend"] )
		do
			cNPCVanish( indexHandle )
		end

		local nLimitSec = cGetKQLimitSecond( Var["MapIndex"] )

		if nLimitSec == nil
		then
			ErrorLog( "GuideOfGuard::nLimitSec == nil" )
		else
			-- Real Kingdom Quest 시작 !!!!
			Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
			-- 타이머 시작!
			cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
		end

		-- 킹덤 퀘스트를 시작하는 플레이어 수를 체크
		Var["PlayerCount"] = cObjectCount( Var["MapIndex"], ObjectType["Player"] )
		if Var["PlayerCount"] == 1 -- 혼자 테스트하는 용도
		then
			Var["KQ_Difficulty"] = 3
		elseif Var["PlayerCount"] >= 2 and Var["PlayerCount"] <= 5
		then
			Var["KQ_Difficulty"] = 1
		elseif Var["PlayerCount"] >= 6 and Var["PlayerCount"] <= 10
		then
			Var["KQ_Difficulty"] = 2
		elseif Var["PlayerCount"] >= 11 and Var["PlayerCount"] <= 15
		then
			Var["KQ_Difficulty"] = 3
		else
			ErrorLog( "Number of Player("..Var["PlayerCount"]..") is not valid." )
			Var["KQ_Difficulty"] = 3
		end

		GoToNextStep( Var )
		Var["GuideOfGuard"]	= nil
		DebugLog( "End GuideOfGuard" )

		return

	end

end


-- 1, 2, 3층
function LowerFloor( Var )
cExecCheck "LowerFloor"

	if Var == nil
	then
		return
	end


	if Var["LowerFloor"] == nil
	then
		Var["LowerFloor"] = {}
	end

	if Var["LowerFloor"]["FloorNumber"] == nil
	then
		Var["LowerFloor"]["FloorNumber"] = 1
	end

	local CurFloorNo = Var["LowerFloor"]["FloorNumber"]

	-- 각 층 초기 설정
	if Var["LowerFloor"..CurFloorNo ] == nil
	then

		DebugLog( "Start Floor "..CurFloorNo )

		Var["LowerFloor"..CurFloorNo ] = {}

		local CurFloor = FloorNameTable[ CurFloorNo ]	-- 층이름 받아오기


		-- 그룹 젠
		local CurRegenGroup = RegenInfo["Group"][ CurFloor ]

		if CurRegenGroup ~= nil
		then
			for i = 1, #CurRegenGroup
			do
				if cGroupRegenInstance( Var["MapIndex"], CurRegenGroup[i] ) == nil
				then
					ErrorLog( "GroupRegenFail : "..CurRegenGroup[i] )
				end
			end
		end


		-- 각 몹 젠
		local CurRegenMob = RegenInfo["Mob"][ CurFloor ]

		if CurRegenMob ~= nil
		then

			Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] = 0

			for noIndex, CurRegenInfo in pairs ( CurRegenMob )
			do
				local KingSlimeHandle = cMobRegen_XY( Var["MapIndex"], CurRegenInfo["Index"], CurRegenInfo["x"], CurRegenInfo["y"], CurRegenInfo["dir"] )

				if KingSlimeHandle ~= nil
				then
					cSetAIScript ( MainLuaScriptPath, KingSlimeHandle )
					cAIScriptFunc( KingSlimeHandle, "Entrance", "KingSlimeRoutine" )

					Var["Enemy"][ KingSlimeHandle ] = { Index = CurRegenInfo["Index"], x = CurRegenInfo["x"], y = CurRegenInfo["y"], dir = CurRegenInfo["dir"] }

					Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] = Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] + 1
				else
					ErrorLog( "MobRegenFail : "..CurRegenInfo["Index"] )
				end

			end
		else
			if CurFloorNo == 3
			then
				ErrorLog( "Fail : GetMobRegenInfoOfThisFloor : "..CurFloor )
			end
		end

		Var["LowerFloor"..CurFloorNo ]["WaitSecDuringMobGen"] = Var["CurSec"] + DelayTime["AfterMobGen"]

	end


	-- 몹 생성 시간을 기다려준 후 클리어 체크를 하기 위해서 일정 시간을 기다려줌
	if Var["LowerFloor"..CurFloorNo ]["WaitSecDuringMobGen"] > Var["CurSec"]
	then
		return
	end

	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["LowerFloor"..CurFloorNo ] = nil
		Var["LowerFloor"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["LowerFloor"..CurFloorNo ] = nil
		Var["LowerFloor"] = nil
		return
	end


	-- 모든 몹을 죽였는지 체크
	local bEndFloor = false

	if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
	then
		bEndFloor = true
	end

	-- Success Case : 모든 몹을 죽였을 때
	if bEndFloor == true
	then
		-- 문열림
		cDoorAction( Var["Door"..CurFloorNo ], RegenInfo["Stuff"]["Door"..CurFloorNo ]["Block"], "open" )

		-- 킹슬라임 페이스컷
		if CurFloorNo <= #KingSlimeChat["FloorClearDialog"]
		then
			cMobDialog( Var["MapIndex"], KingSlimeChat["SpeakerIndex"], KingSlimeChat["ScriptFileName"], KingSlimeChat["FloorClearDialog"][ CurFloorNo ]["Index"] )
		end

		-- 다음 층으로
		Var["LowerFloor"..CurFloorNo ] = nil

		DebugLog( "End Floor "..CurFloorNo )

		Var["LowerFloor"]["FloorNumber"] = Var["LowerFloor"]["FloorNumber"] + 1

		-- 1,2,3층이 모두 클리어 되면 킹슬라임과의 결전!
		if Var["LowerFloor"]["FloorNumber"] > 3
		then

			Var["LowerFloor"] = nil
			GoToNextStep( Var )
			return
		end

		return
	end

end


-- 킹슬라임언덕 최상층
function TopFloor( Var )
cExecCheck "TopFloor"


	if Var == nil
	then
		return
	end


	-- 최상층 셋팅
	if Var["TopFloor"] == nil
	then
		DebugLog( "Start TopFloor" )

		Var["TopFloor"] = {}

		local RegenEmperorSlime	= RegenInfo["Mob"]["TopFloor"]["EmperorSlime"]
		local EmperorSlimeHandle = cMobRegen_XY( Var["MapIndex"], RegenEmperorSlime["Index"], RegenEmperorSlime["x"], RegenEmperorSlime["y"], RegenEmperorSlime["dir"] )

		if EmperorSlimeHandle ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, EmperorSlimeHandle )
			cAIScriptFunc( EmperorSlimeHandle, "Entrance", "EmperorSlimeRoutine" )

			Var["Enemy"][ EmperorSlimeHandle ] = { Index = RegenEmperorSlime["Index"], x = RegenEmperorSlime["x"], y = RegenEmperorSlime["y"], dir = RegenEmperorSlime["dir"] }
			Var["Enemy"]["BossHandle"] = EmperorSlimeHandle
		end

		-- 황제슬라임 경고의 시간과 단계 초기화
		Var["TopFloor"]["WarnStepSec"] 			= Var["CurSec"]
		Var["TopFloor"]["WarnStepNo"] 			= 1
		Var["TopFloor"]["WaitSecDuringBossGen"] = Var["CurSec"] + DelayTime["AfterMobGen"]

		Var["TopFloor"]["bBossTurning"] 			= false
		Var["TopFloor"]["BossAnimationStopStepSec"] = Var["CurSec"]

		Var["TopFloor"]["AllCompletingStepSec"]	= nil

	end


------ EmperorSlime의 경고

	-- 페이스컷 단계 체크 및 실행
	if Var["TopFloor"]["WarnStepNo"] <= #EmperorSlimeChat["WarningDialog"]
	then

		-- 다이얼로그 처리
		if Var["TopFloor"]["WarnStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], EmperorSlimeChat["SpeakerIndex"], EmperorSlimeChat["ScriptFileName"], EmperorSlimeChat["WarningDialog"][ Var["TopFloor"]["WarnStepNo"] ]["Index"] )

			Var["TopFloor"]["WarnStepNo"] 	= Var["TopFloor"]["WarnStepNo"] + 1								-- 다음 단계 변호 셋팅
			Var["TopFloor"]["WarnStepSec"] 	= Var["CurSec"] + DelayTime["BetweenEmperorSlimeWarnDialog"] 	-- 다음 페이스컷 띄울 시간 셋팅
		end

		return

	end


	-- 보스 젠 시간 기다리기
	if Var["TopFloor"]["WaitSecDuringBossGen"] > Var["CurSec"]
	then
		return
	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["TopFloor"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["TopFloor"] = nil
		return
	end


	-- 모든 몹을 죽였는지 체크
	local bEndTopFloor = false

	if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
	then
		if Var["TopFloor"]["AllCompletingStepSec"] == nil
		then
			Var["TopFloor"]["AllCompletingStepSec"] = Var["CurSec"] + DelayTime["AfterKillBoss"]
		end
		bEndTopFloor = true
	end


	-- Success Case : 모든 몹을 죽였을 때
	if bEndTopFloor == true
	then
		-- 클리어 후 단계가 넘어가기까지 일정 시간동안 여유를 둠
		if Var["TopFloor"]["AllCompletingStepSec"] > Var["CurSec"]
		then
			return
		end

		GoToSuccess( Var )

		Var["Friend"] 	= nil
		Var["Enemy"]	= nil
		Var["TopFloor"] = nil
		DebugLog( "End TopFloor" )
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


	if Var["QuestSuccess"] == nil
	then

		DebugLog( "Start QuestSuccess" )

		Var["QuestSuccess"] = {}

		-- Success 띄우고
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- 플레이어에게 클리어 보상 주기
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill 세기.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1

	end


	-- 경비창병의 메세지
	if Var["QuestSuccess"]["SuccessStepNo"] <= #NPC_GuardChat["SuccessAndThenDialog"]
	then

		if Var["QuestSuccess"]["SuccessStepSec"] <= Var["CurSec"]
		then
			local GuardDialog = NPC_GuardChat["SuccessAndThenDialog"]

			cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], GuardDialog[ Var["QuestSuccess"]["SuccessStepNo"] ]["Index"] )

			Var["QuestSuccess"]["SuccessStepNo"]	= Var["QuestSuccess"]["SuccessStepNo"] + 1		-- go to next dialog
			Var["QuestSuccess"]["SuccessStepSec"]	= Var["CurSec"] + DelayTime["BetweenSuccessDialog"]	-- set time for changing step

		end

		return
	end

	-- 다이얼로그 끝
	if Var["QuestSuccess"]["SuccessStepNo"] > #NPC_GuardChat["SuccessAndThenDialog"]
	then

		if Var["QuestSuccess"]["SuccessStepSec"] <= Var["CurSec"]
		then
			GoToNextStep( Var )
			Var["QuestSuccess"] = nil
			DebugLog( "End QuestSuccess" )
		end

	end

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
	{ Function = GuideOfGuard, Name = "GuideOfGuard", },
	{ Function = LowerFloor,   Name = "LowerFloor",   },
	{ Function = TopFloor,     Name = "TopFloor",     },
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

