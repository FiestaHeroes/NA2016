--------------------------------------------------------------------------------
--                       Tower Of Iyzel Progress Func                         --
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

		-- 층 사이에 있는 문 생성
		for i = 0, 17
		do
			local DoorTableIndex = nil

			if i < 10
			then
				DoorTableIndex = "Door0"..i
			else
				DoorTableIndex = "Door"..i
			end

			local CurRegenDoor = RegenInfo["Stuff"][ DoorTableIndex ]

			if CurRegenDoor ~= nil
			then
				local nCurDoorHandle = cDoorBuild( Var["MapIndex"], CurRegenDoor["Index"], CurRegenDoor["x"], CurRegenDoor["y"], CurRegenDoor["dir"], CurRegenDoor["scale"] )

				if nCurDoorHandle  ~= nil
				then
					cDoorAction( nCurDoorHandle , CurRegenDoor["Block"], "close" )

					-- 리젠 정보 보관
					Var["Door"][ nCurDoorHandle ] = CurRegenDoor

					-- 핸들 보관 : 접근용으로
					Var["Door"..(i+1) ] = nCurDoorHandle
				end
			end

		end

		-- 입구쪽 출구게이트 생성
		local RegenExitGate  = RegenInfo["Stuff"]["ExitGate"]
		local nExitGateHandle = cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "ExitGateClick" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"ExitGateClick\" ) == nil" )
			end
		end

		-- 대기시간 설정
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end

	-- 대기 후 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 1~19 번째 층의 몹들과 보스전
function EachFloor( Var )
cExecCheck "EachFloor"

	if Var == nil
	then
		return
	end

	if Var["EachFloor"] == nil
	then
		Var["EachFloor"] = {}
	end


	-- 단계 번호 설정
	if Var["EachFloor"]["StepNumber"] == nil
	then
		Var["EachFloor"]["StepNumber"] = 1
	end


	-- 단계이름 받아오기
	local CurStepNo = Var["EachFloor"]["StepNumber"]	-- ex) 1
	local CurStep = StepNameTable[ CurStepNo ]			-- ex) Floor01


	-- 각 단계 초기 설정
	if Var["EachFloor"..CurStepNo ] == nil
	then

		DebugLog( "Start EachFloor "..CurStepNo )

		Var["EachFloor"..CurStepNo ] = {}


		-- 몹 그룹 젠
		local CurStepRegen 	= RegenInfo["Group"][ CurStep ]

		for i = 1, #CurStepRegen
		do
			cGroupRegenInstance( Var["MapIndex"], CurStepRegen[i] )
		end

		-- 보스 젠( 있을경우 Only : 4, 9, 13, 19 층 )
		if RegenInfo["Mob"][ CurStep ] ~= nil
		then
			local RegenBoss	= nil
			local BossHandle = nil

			for MobName, MobRegenInfo in pairs ( RegenInfo["Mob"][ CurStep ] )
			do
				RegenBoss 	= MobRegenInfo
				BossHandle  = cMobRegen_XY( Var["MapIndex"], RegenBoss["Index"], RegenBoss["x"], RegenBoss["y"], RegenBoss["dir"] )
			end

			if BossHandle ~= nil
			then
				Var["Enemy"][ BossHandle ] = RegenBoss
				Var["EachFloor"..CurStepNo ]["BossHandle"] = BossHandle

				Var["RoutineTime"][ BossHandle ] = cCurrentSecond()
				cSetAIScript ( MainLuaScriptPath, BossHandle )
				cAIScriptFunc( BossHandle, "Entrance", "BossRoutine" )
			end
		end

		-- 페이스컷 단계 구분용 변수 설정
		Var["EachFloor"..CurStepNo ]["StartDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] = 1
		Var["EachFloor"..CurStepNo ]["ClearDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] = 1
		Var["EachFloor"..CurStepNo ]["BossBattleDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["BossBattleDialogStepNo"] = 1

		-- 페이스컷 종료 여부 설정
		Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bBossBattleDialogEnd"] = false

		-- 몹 전멸 여부 설정
		Var["EachFloor"..CurStepNo ]["bMobEliminated"] = false

		Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]
	end

	-- 해당 단계 시작시의 페이스컷
	if NPC_GuardChat["StartDialog"][ CurStep ] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] == false
		then
			if Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] <= #NPC_GuardChat["StartDialog"][ CurStep ]
			then
				if Var["EachFloor"..CurStepNo ]["StartDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["StartDialog"][ CurStep ][ Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] ]["Index"] )
					DebugLog( "EachFloor"..CurStepNo.."::Index("..NPC_GuardChat["StartDialog"][ CurStep ][ Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] ]["Index"].."), StepNo("..Var["EachFloor"..CurStepNo ]["StartDialogStepNo"]..")" )

					Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] = Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] + 1
					Var["EachFloor"..CurStepNo ]["StartDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
				return
			else
				-- 페이스컷 종료
				Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] = true
			end
		end
	else
		-- 페이스컷 자체가 없을 때
		Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] = true
	end


	-- 몹 전멸체크
	if Var["EachFloor"..CurStepNo ]["bMobEliminated"] == false
	then
		if Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] <= Var["CurSec"]
		then
			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
			then
				Var["EachFloor"..CurStepNo ]["bMobEliminated"] = true
			end
		end

		return
	else
		-- 해당 층 몹 전멸 시

		-- 클리어 페이스컷
		if NPC_GuardChat["ClearDialog"][ CurStep ] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] == false
			then
				if Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] <= #NPC_GuardChat["ClearDialog"][ CurStep ]
				then
					if Var["EachFloor"..CurStepNo ]["ClearDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["ClearDialog"][ CurStep ][ Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] ]["Index"] )
						DebugLog( "EachFloor"..CurStepNo.."::Index("..NPC_GuardChat["ClearDialog"][ CurStep ][ Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] ]["Index"].."), StepNo("..Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"]..")" )

						Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] = Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["ClearDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- 해당 페이스컷 타이밍이 될 때까지 다른기능 실행 없이 딜레이 걸기
					return
				else
					-- 페이스컷 종료
					Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] = true
				end
			end
		else
			-- 페이스컷 자체가 없을 때
			Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] = true
		end
	end


	-- Next Case : 해당 층의 몹 전멸 후 클리어 페이스컷 여부에 따라 그 페이스 컷이 종료하면.
	if Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] <= Var["CurSec"]
	then
		if Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] == true
		then
			-- 해당 층 몹 전멸 상황이 아닌경우 다음단계로 넘어가지 않는다.
			if Var["EachFloor"..CurStepNo ]["bMobEliminated"] ~= true
			then
				return
			end

			-- 클리어 액션
			if Var["Door"..CurStepNo ] ~= nil
			then
				cDoorAction( Var["Door"..CurStepNo ], Var["Door"][ Var["Door"..CurStepNo ] ]["Block"], "open" )
			end

			-- 다음 단계로
			Var["EachFloor"..CurStepNo ] = nil
			Var["EachFloor"]["StepNumber"] = CurStepNo + 1

			DebugLog( "End EachFloor "..CurStepNo )

			-- 모든 층 클리어 시
			if Var["EachFloor"]["StepNumber"] > #StepNameTable
			then

				Var["EachFloor"] = nil
				GoToSuccess( Var )
				return
			end

			return
		end
	end

end


-- 킹덤 퀘스트 클리어 : ID 에선 기능 거의 없음
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end

	DebugLog( "Start QuestSuccess" )

	-- Quest Mob Kill 세기.
	cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

	GoToNextStep( Var )

	DebugLog( "End QuestSuccess" )

end


-- 킹덤 퀘스트 실패 : ID 에선 기능 없음
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end


	DebugLog( "Start QuestFailed" )
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
		Var["ReturnToHome"]["ReturnNoticeIndex"] = "IDReturn"
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
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapIDReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo[ sReturnNoticeIndex ]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_ID
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMapOnClear"]["MapIndex"], LinkInfo["ReturnMapOnClear"]["x"], LinkInfo["ReturnMapOnClear"]["y"] )

			GoToNextStep( Var )
			Var["ReturnToHome"] = nil

			DebugLog( "End ReturnToHome" )
		end

		return

	end


end


-- 스텝 구분을 위한 던전 진행 함수 리스트
ID_StepsList =
{
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = EachFloor,    Name = "EachFloor",    },
	{ Function = QuestSuccess, Name = "QuestSuccess", },
	{ Function = QuestFailed,  Name = "QuestFailed",  },
	{ Function = ReturnToHome, Name = "ReturnToHome", },
}

-- 역참조 리스트
ID_StepsIndexList =
{
}

for index, funcValue in pairs ( ID_StepsList )
do
	ID_StepsIndexList[ funcValue["Name"] ] = index
end
