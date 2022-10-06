--------------------------------------------------------------------------------
--               Mini Dragon (Hard Mode) Progress Func                        --
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

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]

	end

	-- 일정 시간 뒤 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then

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

		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 1, 2, 3, 4 번째 필드 쫄들과 중간보스 몹들과의 전투
function MidBossStep( Var )
cExecCheck "MidBossStep"

	if Var == nil
	then
		return
	end

	if Var["MidBossStep"] == nil
	then
		Var["MidBossStep"] = {}
	end

	if Var["MidBossStep"]["StepNumber"] == nil
	then
		Var["MidBossStep"]["StepNumber"] = 1
	end

	local CurStepNo = Var["MidBossStep"]["StepNumber"]

	-- 각 단계 초기 설정
	if Var["MidBossStep"..CurStepNo ] == nil
	then

		DebugLog( "Start MidBossStep "..CurStepNo )

		Var["MidBossStep"..CurStepNo ] = {}

		-- 단계이름 받아오기
		local CurStep 		= StepNameTable[ CurStepNo ]

		-- 몹 그룹 젠
		local CurStepRegen 	= RegenInfo["Group"][ CurStep ]

		for i = 1, #CurStepRegen
		do
			cGroupRegenInstance( Var["MapIndex"], CurStepRegen[i] )
		end

		-- 중간보스 젠
		local RegenMidBoss	= nil
		local MidBossHandle = nil

		for MobName, MobRegenInfo in pairs ( RegenInfo["Mob"][ CurStep ] )
		do
			RegenMidBoss 	= MobRegenInfo
			MidBossHandle  	= cMobRegen_XY( Var["MapIndex"], RegenMidBoss["Index"], RegenMidBoss["x"], RegenMidBoss["y"], RegenMidBoss["dir"] )
		end

		if MidBossHandle ~= nil
		then
			Var["Enemy"][ MidBossHandle ] = RegenMidBoss
			Var["MidBossStep"..CurStepNo ]["MidBossHandle"] = MidBossHandle

			Var["RoutineTime"][ MidBossHandle ] = cCurrentSecond()
			cSetAIScript ( MainLuaScriptPath, MidBossHandle )
			cAIScriptFunc( MidBossHandle, "Entrance", "MidBossRoutine" )
		end

	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["MidBossStep"..CurStepNo ] = nil
		Var["MidBossStep"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["MidBossStep"..CurStepNo ] = nil
		Var["MidBossStep"] = nil
		return
	end

	local nMidBossHandle = Var["MidBossStep"..CurStepNo ]["MidBossHandle"]

	-- Next Case : 중간보스 사망시
	if Var["Enemy"][ nMidBossHandle ] == nil
	then
		-- 안 죽은 잔몹 자살
		cMobSuicide( Var["MapIndex"] )

		-- 다음 단계로
		Var["MidBossStep"..CurStepNo ] = nil
		Var["MidBossStep"]["StepNumber"] = CurStepNo + 1

		DebugLog( "End MidBossStep "..CurStepNo )

		-- 중간보스 올 클리어 : 보스 전으로
		if Var["MidBossStep"]["StepNumber"] >= #StepNameTable
		then

			Var["MidBossStep"] = nil
			GoToNextStep( Var )
			return
		end

		return
	end

end


-- 보스 미니드래곤과의 전투
function BossBattle( Var )
cExecCheck "BossBattle"


	if Var == nil
	then
		return
	end


	-- 보스전 셋팅
	if Var["BossBattle"] == nil
	then
		DebugLog( "Start BossBattle" )

		Var["BossBattle"] = {}


		-- 미니 드래곤 젠
		local RegenMiniDragon	= RegenInfo["Mob"]["BossBattle"]["MiniDragon"]
		local MiniDragonHandle	= cMobRegen_XY( Var["MapIndex"], RegenMiniDragon["Index"], RegenMiniDragon["x"], RegenMiniDragon["y"], RegenMiniDragon["dir"] )

		if MiniDragonHandle ~= nil
		then
			Var["Enemy"][ MiniDragonHandle ] = RegenMiniDragon
			Var["BossBattle"]["BossHandle"]  = MiniDragonHandle

			cMobDetectRange( MiniDragonHandle, BossDetectRange["Regen"] )

			Var["RoutineTime"][ MiniDragonHandle ] = cCurrentSecond()
			cSetAIScript ( MainLuaScriptPath, MiniDragonHandle )
			cAIScriptFunc( MiniDragonHandle, "Entrance", "MiniDragonRoutine" )
		end

	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["BossBattle"] = nil
		return
	end

	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["BossBattle"] = nil
		return
	end


	-- Success Case : 미니드래곤 사망시
	local nBossHandle = Var["BossBattle"]["BossHandle"]
	if Var["Enemy"][ nBossHandle ] == nil
	then
		GoToSuccess( Var )
		Var["BossBattle"] = nil
		DebugLog( "End BossBattle" )
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
		Var["QuestSuccess"]["WaitSecAfterKillBoss"] = Var["CurSec"] + DelayTime["WaitAfterKillBoss"]
	end

	-- 보스 죽인 후 잠시 기다려 줌
	if Var["QuestSuccess"]["WaitSecAfterKillBoss"] <= Var["CurSec"]
	then
		-- Success 띄우고
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- 플레이어에게 클리어 보상 주기
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill 세기.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		-- 보상용 광석그룹 젠
		cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["QuestSuccess"] )

		-- 귀환 하러
		GoToNextStep( Var )
		DebugLog( "End QuestSuccess" )
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

		Var["ReturnToHome"]["ReturnStepNo"]  = 1
		Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"]

		if Var["QuestSuccess"] ~= nil
		then
			-- 성공시
			Var["ReturnToHome"]["ReturnNoticeIndex"] = "KQReturn"
			Var["QuestSuccess"] = nil
		else
			-- 실패시
			Var["ReturnToHome"]["ReturnNoticeIndex"] = "KQFReturn"
		end


	end

	local sReturnNoticeIndex = Var["ReturnToHome"]["ReturnNoticeIndex"]

	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo[ sReturnNoticeIndex ]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then

			-- Notice of Escape
			if NoticeInfo[ sReturnNoticeIndex ][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo[ sReturnNoticeIndex ][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapKQReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo[ sReturnNoticeIndex ]
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
	{ Function = MidBossStep,  Name = "MidBossStep",  },
	{ Function = BossBattle,   Name = "BossBattle",   },
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
