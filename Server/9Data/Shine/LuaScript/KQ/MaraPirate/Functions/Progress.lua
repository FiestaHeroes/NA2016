--------------------------------------------------------------------------------
--                        Mara Pirate Progress Func                           --
--------------------------------------------------------------------------------

-- 던전 초기화
function InitDungeon( Var )
	cExecCheck( "InitDungeon" )

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

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end


	-- 일정 시간 뒤 다음 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
	end

end


-- 스파이의 거짓말
function SpyLie( Var )
	cExecCheck( "SpyLie" )

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


	if Var["SpyLie"] == nil
	then
		DebugLog( "Start SpyLie" )

		-- 몬스터 그룹 리젠
		for i = 1, #RegenInfo["Group"]["InitDungeonRegen"]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["InitDungeonRegen"][i] )
		end

		-- 경비병(스파이) 생성
		local RegenGuard	= RegenInfo["NPC"]["NPC_Guard"]
		local GuardHandle	= cMobRegen_XY( Var["MapIndex"], RegenGuard["Index"], RegenGuard["x"],RegenGuard["y"], RegenGuard["dir"] )

		if GuardHandle ~= nil
		then
			Var["Friend"]["NPC_Guard"] = GuardHandle
		end

		-- 경비병(스파이) 채팅 설정
		Var["SpyLie"] 					= {}
		Var["SpyLie"]["ChatStepSec"] 	= Var["CurSec"]
		Var["SpyLie"]["ChatStepNo"]		= 1
	end


	-- 경비병(스파이) 채팅
	if Var["SpyLie"]["ChatStepNo"] <= #NPC_GuardChat["SpyLieChat"]
	then
		if Var["SpyLie"]["ChatStepSec"] <= Var["CurSec"]
		then
			if Var["Friend"]["NPC_Guard"] ~= nil
			then
				cMobChat( Var["Friend"]["NPC_Guard"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["SpyLieChat"][ Var["SpyLie"]["ChatStepNo"] ]["Index"], true )
			end

			Var["SpyLie"]["ChatStepSec"] 	= Var["SpyLie"]["ChatStepSec"] + DelayTime["BetweenSpyLieChat"]
			Var["SpyLie"]["ChatStepNo"]  	= Var["SpyLie"]["ChatStepNo"] + 1
		end
	else
		if Var["Friend"]["NPC_Guard"] ~= nil
		then
			cNPCVanish( Var["Friend"]["NPC_Guard"] )
		end

		GoToNextStep( Var )
		Var["SpyLie"] = nil
		DebugLog( "End SpyLie" )
	end

end


-- 스파이의 보고
function SpyReport( Var )
	cExecCheck( "SpyReport" )

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


	if Var["SpyReport"] == nil
	then
		DebugLog( "Start SpyReport" )

		-- 중간 보스(마라, 말론) 생성
		local VirMaraRegenInfo		= RegenInfo["Mob"]["MiddleBoss"]["VirtualMara"]
		local VirMarloneRegenInfo	= RegenInfo["Mob"]["MiddleBoss"]["VirtualMarlone"]
		local VirMaraHad			= nil
		local VirMarloneHnd			= nil

		VirMaraHad					= cMobRegen_XY( Var["MapIndex"], VirMaraRegenInfo["Index"],	   VirMaraRegenInfo["x"],    VirMaraRegenInfo["y"],    VirMaraRegenInfo["dir"] )
		VirMarloneHnd				= cMobRegen_XY( Var["MapIndex"], VirMarloneRegenInfo["Index"], VirMarloneRegenInfo["x"], VirMarloneRegenInfo["y"], VirMarloneRegenInfo["dir"] )

		if VirMaraHad ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, VirMaraHad )
			cAIScriptFunc( VirMaraHad, "Entrance", "MiddleMaraDead" )

			Var["Enemy"]["VirtualMara"] = VirMaraHad
		end

		if VirMarloneHnd ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, VirMarloneHnd )
			cAIScriptFunc( VirMarloneHnd, "Entrance", "MiddleMarloneDead" )

			Var["Enemy"]["VirtualMarlone"] = VirMarloneHnd
		end

		 -- 다이얼 로그(스파이의 보고) 설정
		Var["SpyReport"] 							= {}
		Var["SpyReport"]["WaitSecDuringSpyReport"]	= Var["CurSec"] + DelayTime["BeforeSpyReportDialog"]
		Var["SpyReport"]["DialogStepSec"] 			= Var["SpyReport"]["WaitSecDuringSpyReport"]
		Var["SpyReport"]["DialogStepNo"] 			= 1

	end


	-- 일정 시간 뒤 다이얼 로그 처리
	if Var["SpyReport"]["WaitSecDuringSpyReport"] > Var["CurSec"]
	then
		return
	end


	-- 다이얼 로그(스파이의 보고) 처리
	if Var["SpyReport"]["DialogStepNo"] <= #MiddleBossChat["SpyReportDialog"]
	then
		if Var["SpyReport"]["DialogStepSec"] <= Var["CurSec"]
		then
			local SpyReportDialog = MiddleBossChat["SpyReportDialog"][ Var["SpyReport"]["DialogStepNo"] ]
			cMobDialog( Var["MapIndex"], SpyReportDialog["FaceCut"], MiddleBossChat["ScriptFileName"], SpyReportDialog["Index"] )

			Var["SpyReport"]["DialogStepSec"]	= Var["SpyReport"]["DialogStepSec"] + DelayTime["BetweenSpyReportDialog"]
			Var["SpyReport"]["DialogStepNo"]	= Var["SpyReport"]["DialogStepNo"] + 1
		end
	else
		-- 킹덤 퀘스트 시작 설정
		local nLimitSec = cGetKQLimitSecond( Var["MapIndex"] )

		if nLimitSec == nil
		then
			ErrorLog( "InitDungeon::nLimitSec == nil" )
		else
			Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
			cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
		end

		GoToNextStep( Var )
		Var["SpyReport"] = nil
		return
	end

end


-- 중간 보스(마라, 말론)
function MiddleBoss( Var )
	cExecCheck( "MiddleBoss" )

	if Var == nil
	then
		return
	end


	--1초마다 체크
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["MiddleBoss"] == nil
	then
		DebugLog( "Start MiddleBoss" )

		-- 몬스터 그룹 리젠
		for i = 1, #RegenInfo["Group"]["MiddleBossRegen"]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["MiddleBossRegen"][i] )
		end

		Var["MiddleBoss"] = {}

	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- 중간 보스(마라, 말론)가 죽었는지 체크
	local VirtualMaraDied		= false
	local VirtualMarloneDied	= false

	if Var["Enemy"]["VirtualMara"] == nil
	then
		VirtualMaraDied = true
	else
		if cIsObjectDead( Var["Enemy"]["VirtualMara"] ) == 1
		then
			Var["Enemy"]["VirtualMara"] = nil
			VirtualMaraDied 			= true
		end
	end

	if Var["Enemy"]["VirtualMarlone"] == nil
	then
		VirtualMarloneDied = true
	else
		if cIsObjectDead( Var["Enemy"]["VirtualMarlone"] ) == 1
		then
			Var["Enemy"]["VirtualMarlone"]	= nil
			VirtualMarloneDied 				= true
		end
	end


	-- Success Case : 중간 보스(마라, 말론) 죽음
	if VirtualMaraDied == true and VirtualMarloneDied == true
	then
		GoToNextStep( Var )
		Var["MiddleBoss"] = nil
		DebugLog( "End MiddleBoss" )
		return
	end

end


-- 중간 보스 전투 후 보고
function MiddleReport( Var )
	cExecCheck( "MiddleReport" )

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


	if Var["MiddleReport"] == nil
	then
		DebugLog( "Start MiddleReport" )

		-- 보스(마라, 말론) 생성
		local MaraRegenInfo			= RegenInfo["Mob"]["Boss"]["TrueMara"]
		local MarloneRegenInfo		= RegenInfo["Mob"]["Boss"]["TrueMarlone"]
		local TrueMaraHnd			= cMobRegen_XY( Var["MapIndex"], MaraRegenInfo["Index"], MaraRegenInfo["x"], MaraRegenInfo["y"], MaraRegenInfo["dir"] )
		local TrueMarloneHnd		= cMobRegen_XY( Var["MapIndex"], MarloneRegenInfo["Index"], MarloneRegenInfo["x"], MarloneRegenInfo["y"], MarloneRegenInfo["dir"] )

		if TrueMaraHnd ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, TrueMaraHnd )
			cAIScriptFunc( TrueMaraHnd, "Entrance", "LastMaraDead" )

			Var["Enemy"]["TrueMara"] = TrueMaraHnd
		end

		if TrueMarloneHnd ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, TrueMarloneHnd )
			cAIScriptFunc( TrueMarloneHnd, "Entrance", "LastMarloneDead" )

			Var["Enemy"]["TrueMarlone"] = TrueMarloneHnd
		end


		-- 가짜 보스 소환 : 죽으면 가짜 보스 소환
		local VirMaraRegenInfo		= RegenInfo["Mob"]["Boss"]["VirtualMara"]
		local VirMarloneRegenInfo	= RegenInfo["Mob"]["Boss"]["VirtualMarlone"]

		for i = 1, VirMaraRegenInfo["RegenNumber"]
		do

			local VirMaraHnd = cMobRegen_XY( Var["MapIndex"], VirMaraRegenInfo["Index"], VirMaraRegenInfo["x"], VirMaraRegenInfo["y"], VirMaraRegenInfo["dir"] )

			if VirMaraHnd ~= nil
			then
				cSetAIScript ( MainLuaScriptPath, VirMaraHnd )
				cAIScriptFunc( VirMaraHnd, "Entrance", "VirtualMaraDead" )
			end

		end

		for i = 1, VirMarloneRegenInfo["RegenNumber"]
		do

			local VirMarloneHnd = cMobRegen_XY( Var["MapIndex"], VirMarloneRegenInfo["Index"], VirMarloneRegenInfo["x"], VirMarloneRegenInfo["y"], VirMarloneRegenInfo["dir"] )

			if VirMarloneHnd ~= nil
			then
				cSetAIScript ( MainLuaScriptPath, VirMarloneHnd )
				cAIScriptFunc( VirMarloneHnd, "Entrance", "VirtualMarloneDead" )
			end

		end

		-- 가짜 보스 소환 : -
		local TmpMaraRegenInfo		= RegenInfo["Mob"]["Boss"]["TmpMara"]
		local TmpMarloneRegenInfo	= RegenInfo["Mob"]["Boss"]["TmpMarlone"]

		for i = 1, TmpMaraRegenInfo["RegenNumber"]
		do
			cMobRegen_XY( Var["MapIndex"], TmpMaraRegenInfo["Index"], TmpMaraRegenInfo["x"], TmpMaraRegenInfo["y"], TmpMaraRegenInfo["dir"] )
		end

		for i = 1, TmpMarloneRegenInfo["RegenNumber"]
		do
			cMobRegen_XY( Var["MapIndex"], TmpMarloneRegenInfo["Index"], TmpMarloneRegenInfo["x"], TmpMarloneRegenInfo["y"], TmpMarloneRegenInfo["dir"] )
		end


		-- 다이얼 로그(중간 보고) 설정
		Var["MiddleReport"] 					= {}
		Var["MiddleReport"]["DialogStepSec"] 	= Var["CurSec"]
		Var["MiddleReport"]["DialogStepNo"] 	= 1
	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- 다이얼 로그(중간 보고) 처리
	if Var["MiddleReport"]["DialogStepNo"] <= #MiddleBossChat["MiddleReportDialog"]
	then
		if Var["MiddleReport"]["DialogStepSec"] <= Var["CurSec"]
		then
			local MiddleReportDialog = MiddleBossChat["MiddleReportDialog"][ Var["MiddleReport"]["DialogStepNo"] ]
			cMobDialog( Var["MapIndex"], MiddleReportDialog["FaceCut"], MiddleBossChat["ScriptFileName"], MiddleReportDialog["Index"] )

			Var["MiddleReport"]["DialogStepSec"]	= Var["MiddleReport"]["DialogStepSec"] + DelayTime["BetweenMiddleReportDialog"]
			Var["MiddleReport"]["DialogStepNo"]		= Var["MiddleReport"]["DialogStepNo"] + 1
		end
	else
		GoToNextStep( Var )
		Var["MiddleReport"] = nil
		DebugLog( "End MiddleReport" )
		return
	end

end


-- 마지막 보스(마라, 말론)
function LastBoss( Var )
	cExecCheck( "LastBoss" )

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


	if Var["LastBoss"] == nil
	then
		DebugLog( "Start LastBoss" )

		Var["LastBoss"] = {}
	end


	-- Fail Case : 전멸 시 혹은 플레이어가 아무도 없을 경우
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- Fail Case : 타임 오버
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- 마지막 보스(마라, 말론)가 죽었는지 체크
	local MaraDied		= false
	local MarloneDied	= false

	if Var["Enemy"]["TrueMara"] == nil
	then
		MaraDied = true
	else
		if cIsObjectDead( Var["Enemy"]["TrueMara"] ) == 1
		then
			MaraDied = true
		end
	end

	if Var["Enemy"]["TrueMarlone"] == nil
	then
		MarloneDied = true
	else
		if cIsObjectDead( Var["Enemy"]["TrueMarlone"] ) == 1
		then
			MarloneDied = true
		end
	end

	-- Success Case : 마지막 보스(마라, 말론) 죽음
	if MaraDied == true and MarloneDied == true
	then
		GoToSuccess( Var )
		Var["LastBoss"]	= nil
		DebugLog( "End LastBoss" )
		return
	end

end


-- 킹덤 퀘스트 클리어
function QuestSuccess( Var )
	cExecCheck( "QuestSuccess" )

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


	if Var["QuestSuccess"] == nil
	then
		-- Success 띄우고
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- 플레이어에게 클리어 보상 주기
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill 세기
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"] = {}
		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1
	end


	GoToNextStep( Var )
	Var["QuestSuccess"] = nil

end


-- 킹덤 퀘스트 실패
function QuestFailed( Var )
	cExecCheck( "QuestFailed" )

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


	if Var["QuestFailed"] == nil
	then
		-- Fail 띄우고
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Fail" )

		-- 다이얼 로그(킹덤 퀘스트 실패) 설정
		Var["QuestFailed"] 							= {}
		Var["QuestFailed"]["DialogStepSec"] 		= Var["CurSec"]
		Var["QuestFailed"]["DialogStepNo"] 			= 1
	end


	-- 다이얼 로그(킹덤 퀘스트 실패) 처리
	if Var["QuestFailed"]["DialogStepNo"] <= #NPC_GuardChat["FailDialog"]
	then
		if Var["QuestFailed"]["DialogStepSec"] <= Var["CurSec"]
		then
			local FailDialog = NPC_GuardChat["FailDialog"][ Var["QuestFailed"]["DialogStepNo"] ]
			cMobDialog( Var["MapIndex"], FailDialog["FaceCut"], NPC_GuardChat["ScriptFileName"], FailDialog["Index"] )

			Var["QuestFailed"]["DialogStepSec"]	= Var["QuestFailed"]["DialogStepSec"] + DelayTime["BetweenKQFailedDialog"]
			Var["QuestFailed"]["DialogStepNo"]	= Var["QuestFailed"]["DialogStepNo"] + 1
		end
	else
		GoToNextStep( Var )
		Var["QuestFailed"] = {}
		return
	end

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
		Var["ReturnToHome"] 					= {}
		Var["ReturnToHome"]["ReturnStepSec"] 	= Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"]  	= 1
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
		end

		return

	end


end


-- 스텝 구분을 위한 던전 진행 함수 리스트
KQ_StepsList =
{
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = SpyLie,       Name = "SpyLie",       },
	{ Function = SpyReport,    Name = "SpyReport",    },
	{ Function = MiddleBoss,   Name = "MiddleBoss",   },
	{ Function = MiddleReport, Name = "MiddleReport", },
	{ Function = LastBoss,     Name = "LastBoss",     },
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
