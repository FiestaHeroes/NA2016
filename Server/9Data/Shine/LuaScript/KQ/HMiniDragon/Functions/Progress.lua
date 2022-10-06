--------------------------------------------------------------------------------
--               Mini Dragon (Hard Mode) Progress Func                        --
--------------------------------------------------------------------------------

-- ���� �ʱ�ȭ
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- ŷ�� ����Ʈ ���� ���� �÷��̾��� ù �α����� ��ٸ���.
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

	-- ���� �ð� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then

		local nLimitSec = cGetKQLimitSecond( Var["MapIndex"] )

		if nLimitSec == nil
		then
			ErrorLog( "GuideOfGuard::nLimitSec == nil" )
		else
			-- Real Kingdom Quest ���� !!!!
			Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
			-- Ÿ�̸� ����!
			cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
		end

		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 1, 2, 3, 4 ��° �ʵ� �̵�� �߰����� ������� ����
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

	-- �� �ܰ� �ʱ� ����
	if Var["MidBossStep"..CurStepNo ] == nil
	then

		DebugLog( "Start MidBossStep "..CurStepNo )

		Var["MidBossStep"..CurStepNo ] = {}

		-- �ܰ��̸� �޾ƿ���
		local CurStep 		= StepNameTable[ CurStepNo ]

		-- �� �׷� ��
		local CurStepRegen 	= RegenInfo["Group"][ CurStep ]

		for i = 1, #CurStepRegen
		do
			cGroupRegenInstance( Var["MapIndex"], CurStepRegen[i] )
		end

		-- �߰����� ��
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


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["MidBossStep"..CurStepNo ] = nil
		Var["MidBossStep"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["MidBossStep"..CurStepNo ] = nil
		Var["MidBossStep"] = nil
		return
	end

	local nMidBossHandle = Var["MidBossStep"..CurStepNo ]["MidBossHandle"]

	-- Next Case : �߰����� �����
	if Var["Enemy"][ nMidBossHandle ] == nil
	then
		-- �� ���� �ܸ� �ڻ�
		cMobSuicide( Var["MapIndex"] )

		-- ���� �ܰ��
		Var["MidBossStep"..CurStepNo ] = nil
		Var["MidBossStep"]["StepNumber"] = CurStepNo + 1

		DebugLog( "End MidBossStep "..CurStepNo )

		-- �߰����� �� Ŭ���� : ���� ������
		if Var["MidBossStep"]["StepNumber"] >= #StepNameTable
		then

			Var["MidBossStep"] = nil
			GoToNextStep( Var )
			return
		end

		return
	end

end


-- ���� �̴ϵ巡����� ����
function BossBattle( Var )
cExecCheck "BossBattle"


	if Var == nil
	then
		return
	end


	-- ������ ����
	if Var["BossBattle"] == nil
	then
		DebugLog( "Start BossBattle" )

		Var["BossBattle"] = {}


		-- �̴� �巡�� ��
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


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["BossBattle"] = nil
		return
	end

	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["BossBattle"] = nil
		return
	end


	-- Success Case : �̴ϵ巡�� �����
	local nBossHandle = Var["BossBattle"]["BossHandle"]
	if Var["Enemy"][ nBossHandle ] == nil
	then
		GoToSuccess( Var )
		Var["BossBattle"] = nil
		DebugLog( "End BossBattle" )
		return
	end

end


-- ŷ�� ����Ʈ Ŭ����
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

	-- ���� ���� �� ��� ��ٷ� ��
	if Var["QuestSuccess"]["WaitSecAfterKillBoss"] <= Var["CurSec"]
	then
		-- Success ����
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- �÷��̾�� Ŭ���� ���� �ֱ�
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill ����.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		-- ����� �����׷� ��
		cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["QuestSuccess"] )

		-- ��ȯ �Ϸ�
		GoToNextStep( Var )
		DebugLog( "End QuestSuccess" )
	end

end


-- ŷ�� ����Ʈ ����
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end


	DebugLog( "Start QuestFailed" )

	-- Fail ����
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Fail" )

	GoToNextStep( Var )

	DebugLog( "End QuestFailed" )

end


-- ��ȯ
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
			-- ������
			Var["ReturnToHome"]["ReturnNoticeIndex"] = "KQReturn"
			Var["QuestSuccess"] = nil
		else
			-- ���н�
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


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
KQ_StepsList =
{
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = MidBossStep,  Name = "MidBossStep",  },
	{ Function = BossBattle,   Name = "BossBattle",   },
	{ Function = QuestSuccess, Name = "QuestSuccess", },
	{ Function = QuestFailed,  Name = "QuestFailed",  },
	{ Function = ReturnToHome, Name = "ReturnToHome", },
}

-- ������ ����Ʈ
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end
