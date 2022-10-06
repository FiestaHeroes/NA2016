--------------------------------------------------------------------------------
--                         Kingkong Progress Func                           --
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

			Var["QuestResult"] = "Fail"

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

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"]

	end

	-- 일정 시간 뒤 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] + DelayTime["AfterInit"] <= Var["CurSec"]
	then

		local nLimitSec = cGetKQLimitSecond( Var["MapIndex"] )

		if nLimitSec == nil
		then
			ErrorLog( "InitDungeon::nLimitSec == nil" )
		else
			Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
			cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
		end

		Var["QuestResult"] = "Fail"

		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end



function FloorFunc( Var )
cExecCheck "FloorFunc"

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


	if Var["FloorInfo"] == nil
	then
		Var["FloorInfo"] = {}
	end

	if Var["FloorInfo"]["FloorNumber"] == nil
	then
		Var["FloorInfo"]["FloorNumber"] = 1
	end

	if Var["FloorInfo"]["Init"] == nil
	then
		Var["FloorInfo"]["Init"] = 0
	end


	-- 각 층 초기 설정
	if Var["FloorInfo"]["Init"] ~= Var["FloorInfo"]["FloorNumber"]
	then

		DebugLog( "Start Floor "..Var["FloorInfo"]["FloorNumber"] )


		local CurFloor = FloorNameTable[ Var["FloorInfo"]["FloorNumber"] ]	-- 층이름 받아오기

		-- 그룹 리젠
		local CurRegenGroup = RegenInfo["Group"][ CurFloor ]

		for i = 1, #CurRegenGroup
		do
			cGroupRegenInstance( Var["MapIndex"], CurRegenGroup[i] )
		end

		-- 개별 리젠
		local CurRegenMob = RegenInfo["BossMob"][ CurFloor ]

		Var["FloorInfo"]["Success"]	= nil
		Var["FloorInfo"]["Fail"]	= nil

		-- 각 층 성공 조건의 몹
		if CurRegenMob["Success"] ~= nil
		then
			local RegenMob = cMobRegen_XY( Var["MapIndex"], CurRegenMob["Success"]["Index"], CurRegenMob["Success"]["x"], CurRegenMob["Success"]["y"], CurRegenMob["Success"]["dir"] )

			-- 마지막 보스면 스크립트 세팅
			if Var["FloorInfo"]["FloorNumber"] >= #FloorNameTable
			then
				if RegenMob == nil
				then
					ErrorLog( "cMobRegen_XY LastBoss Regen failed" )
				else
					cSetAIScript( MainLuaScriptPath, RegenMob )
					cAIScriptFunc( RegenMob, "Entrance", "BossRoutine" )
				end
			end

			Var["FloorInfo"]["Success"] = RegenMob

		end

		-- 각 층 실패 조건의 몹
		if CurRegenMob["Fail"] ~= nil
		then
			local RegenMob = cMobRegen_XY( Var["MapIndex"], CurRegenMob["Fail"]["Index"], CurRegenMob["Fail"]["x"], CurRegenMob["Fail"]["y"], CurRegenMob["Fail"]["dir"] )

			Var["FloorInfo"]["Fail"] = RegenMob

		end


		Var["FloorInfo"]["Init"] = Var["FloorInfo"]["FloorNumber"];

	end



	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["FloorInfo"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["FloorInfo"] = nil
		return
	end


	-- 죽이면 안되는몹 잡았으면 실패
	if Var["FloorInfo"]["Fail"] ~= nil
	then
		if cIsObjectDead( Var["FloorInfo"]["Fail"] ) == 1
		then
			cAIScriptSet( Var["FloorInfo"]["Fail"] )

			GoToFail( Var )

			Var["FloorInfo"] = nil
			return
		end
	end

	-- 보스 잡으면 성공
	if Var["FloorInfo"]["Success"] ~= nil
	then
		if cIsObjectDead( Var["FloorInfo"]["Success"] ) == 1
		then
			cAIScriptSet( Var["FloorInfo"]["Success"] )

			-- 몹 클리어
			if cMobSuicide( Var["MapIndex"] ) == nil
			then
				ErrorLog( "FloorFunc::Suicide Fail" )
			end

			-- 마지막 보스면 킹퀘 성공
			-- 아니면 다음층
			if Var["FloorInfo"]["FloorNumber"] >= #FloorNameTable
			then
				GoToSuccess( Var )
				return
			else
				Var["FloorInfo"]["FloorNumber"] = Var["FloorInfo"]["FloorNumber"] + 1
				return
			end
		end
	end

end



-- 킹덤 퀘스트 클리어
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end


	-- 1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	end

	Var["CurSec"] = cCurrentSecond()


	-- 성공 딜레이
	if Var["QuestSuccessTime"] == nil
	then
		Var["QuestSuccessTime"] = Var["CurSec"]
	end

	if (Var["QuestSuccessTime"] + DelayTime["QuestSuccessDelay"]) > Var["CurSec"]
	then
		return
	end

	DebugLog( "Start QuestSuccess" )

	Var["QuestResult"] = "Success"

	-- Success 띄우고
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Success" )

	-- 플레이어에게 클리어 보상 주기
	cReward( Var["MapIndex"], "KQ" )

	-- Quest Mob Kill 세기.
	cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

	GoToNextStep( Var )

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
	end

	Var["CurSec"] = cCurrentSecond()


	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )
		Var["ReturnToHome"] = {}
		Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"]  = 1
	end


	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo["KQReturn"][Var["QuestResult"]]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then

			-- Notice of Escape
			if NoticeInfo["KQReturn"][Var["QuestResult"]][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["KQReturn"][Var["QuestResult"]][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["BetweenKQReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["KQReturn"][Var["QuestResult"]]
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
	{ Function = InitDungeon,	Name = "InitDungeon",	},
	{ Function = FloorFunc,		Name = "FloorFunc",		},
	{ Function = QuestSuccess,	Name = "QuestSuccess",	},
	{ Function = QuestFailed,	Name = "QuestFailed",	},
	{ Function = ReturnToHome,	Name = "ReturnToHome",	},
}

-- 역참조 리스트
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end

