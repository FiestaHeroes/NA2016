--------------------------------------------------------------------------------
--                         Anti Henis Progress Func                           --
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

		local Doors = RegenInfo["Stuff"]

		-- �� ����
		Var["Door1"] = cDoorBuild( Var["MapIndex"], Doors["Door1"]["Index"], Doors["Door1"]["x"], Doors["Door1"]["y"], Doors["Door1"]["dir"], Doors["Door1"]["scale"] )
		Var["Door2"] = cDoorBuild( Var["MapIndex"], Doors["Door2"]["Index"], Doors["Door2"]["x"], Doors["Door2"]["y"], Doors["Door2"]["dir"], Doors["Door2"]["scale"] )
		Var["Door3"] = cDoorBuild( Var["MapIndex"], Doors["Door3"]["Index"], Doors["Door3"]["x"], Doors["Door3"]["y"], Doors["Door3"]["dir"], Doors["Door3"]["scale"] )

		-- �� �ݱ�
		cDoorAction( Var["Door1"], Doors["Door1"]["Block"], "close" )
		cDoorAction( Var["Door2"], Doors["Door2"]["Block"], "close" )
		cDoorAction( Var["Door3"], Doors["Door3"]["Block"], "close" )

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"]

	end

	-- ���� �ð� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] + DelayTime["AfterInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- ������� ���
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

		GuardHandle = cMobRegen_XY( Var["MapIndex"], RegenGuard["Index"], RegenGuard["x"],RegenGuard["y"], RegenGuard["dir"] )

		if GuardHandle ~= nil
		then
			Var["Friend"][ GuardHandle ] 			= RegenGuard
			Var["Friend"][ GuardHandle ]["Handle"] 	= GuardHandle
		end

		Var["GuideOfGuard"] = {}
		Var["GuideOfGuard"]["NoticeStepSec"] 	= Var["CurSec"]
		Var["GuideOfGuard"]["NoticeStepNo"] 	= 1

	end


	-- ���̾�α�(���̽���) index üũ �� ����
	if Var["GuideOfGuard"]["NoticeStepNo"] <= #NPC_GuardChat["StartWarnDialog"]
	then

		-- ���̽��� ó��
		if Var["GuideOfGuard"]["NoticeStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], RegenInfo["NPC"]["NPC_Guard"]["Index"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["StartWarnDialog"][ Var["GuideOfGuard"]["NoticeStepNo"] ]["Index"] )

			Var["GuideOfGuard"]["NoticeStepSec"] = Var["CurSec"] + DelayTime["BetweenGuardWarnDialog"]	-- ���� ���̽� �� ��� �ð� ����
			Var["GuideOfGuard"]["NoticeStepNo"]  = Var["GuideOfGuard"]["NoticeStepNo"] + 1				-- ���� ���̽� ������ �ܰ� ����
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
			-- Real Kingdom Quest ���� !!!!
			Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
			-- Ÿ�̸� ����!
			cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
		end

		GoToNextStep( Var )
		Var["GuideOfGuard"]	= nil
		DebugLog( "End GuideOfGuard" )

		return

	end

end


-- ŷ�����Ӿ�� 1, 2, 3��
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


	-- �� �� �ʱ� ����
	if Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ] == nil
	then

		DebugLog( "Start Floor "..Var["LowerFloor"]["FloorNumber"] )


		local CurFloor = FloorNameTable[ Var["LowerFloor"]["FloorNumber"] ]	-- ���̸� �޾ƿ���

		local CurRegenFloor = {}

		CurRegenFloor = RegenInfo["Group"][ CurFloor ]

		for i = 1, #CurRegenFloor
		do
			cGroupRegenInstance( Var["MapIndex"], CurRegenFloor[i] )
		end

		Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ] = {}
		Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ]["WaitSecDuringMobGen"] = Var["CurSec"] + DelayTime["AfterMobGen"]

	end


	-- �� ���� �ð��� ��ٷ��� �� Ŭ���� üũ�� �ϱ� ���ؼ� ���� �ð��� ��ٷ���
	if Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ]["WaitSecDuringMobGen"] > Var["CurSec"]
	then
		return
	end

	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ] = nil
		Var["LowerFloor"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ] = nil
		Var["LowerFloor"] = nil
		return
	end


	-- ��� ���� �׿����� üũ
	local bEndFloor = false

	if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
	then
		bEndFloor = true
	end

	-- Success Case : ��� ���� �׿��� ��
	if bEndFloor == true
	then
		cDoorAction( Var["Door"..Var["LowerFloor"]["FloorNumber"] ], RegenInfo["Stuff"]["Door"..Var["LowerFloor"]["FloorNumber"] ]["Block"], "open" )

		-- ���� ������
		Var["LowerFloor"..Var["LowerFloor"]["FloorNumber"] ] = nil

		DebugLog( "End Floor "..Var["LowerFloor"]["FloorNumber"] )

		Var["LowerFloor"]["FloorNumber"] = Var["LowerFloor"]["FloorNumber"] + 1

		-- 1,2,3���� ��� Ŭ���� �Ǹ� ����Ͻ����ͺ������� ����!
		if Var["LowerFloor"]["FloorNumber"] > 3
		then

			Var["LowerFloor"] = nil
			GoToNextStep( Var )
			return
		end

		return
	end

end


-- �ֻ���
function TopFloor( Var )
cExecCheck "TopFloor"


	if Var == nil
	then
		return
	end


	-- �ֻ��� ����
	if Var["TopFloor"] == nil
	then
		DebugLog( "Start TopFloor" )

		local RegenAntiHenisBoss	= RegenInfo["Mob"]["TopFloor"]["AntiHenisBoss"]
		local AntiHenisBossHandle	= nil

		AntiHenisBossHandle = cMobRegen_XY( Var["MapIndex"], RegenAntiHenisBoss["Index"], RegenAntiHenisBoss["x"], RegenAntiHenisBoss["y"], RegenAntiHenisBoss["dir"] )

		if AntiHenisBossHandle ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, AntiHenisBossHandle )
			cAIScriptFunc( AntiHenisBossHandle, "Entrance", "AntiHenisBossRoutine" )

			Var["Enemy"][ AntiHenisBossHandle ] = RegenAntiHenisBoss
		end

		Var["TopFloor"] = {}
		-- ŷ������ ����� �ð��� �ܰ� �ʱ�ȭ
		Var["TopFloor"]["WarnStepSec"] 			= Var["CurSec"]
		Var["TopFloor"]["WarnStepNo"] 			= 1
		-- ŷ������ �� �� �����̸� �ֱ����� �ð� ����
		Var["TopFloor"]["WaitSecDuringBossGen"] = Var["CurSec"] + DelayTime["AfterMobGen"]

	end


------ AntiHenisBoss�� ���

	-- ���̽��� �ܰ� üũ �� ����
	if Var["TopFloor"]["WarnStepNo"] <= #AntiHenisBossChat["WarningDialog"]
	then

		-- ���̾�α� ó��
		if Var["TopFloor"]["WarnStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], RegenInfo["Mob"]["TopFloor"]["AntiHenisBoss"]["Index"], AntiHenisBossChat["ScriptFileName"], AntiHenisBossChat["WarningDialog"][ Var["TopFloor"]["WarnStepNo"] ]["Index"] )

			Var["TopFloor"]["WarnStepNo"] 	= Var["TopFloor"]["WarnStepNo"] + 1							-- ���� �ܰ� ��ȣ ����
			Var["TopFloor"]["WarnStepSec"] 	= Var["CurSec"] + DelayTime["BetweenAntiHenisBossWarnDialog"] 	-- ���� ���̽��� ��� �ð� ����

		end

		return

	end


	-- ���� �� �ð� ��ٸ���
	if Var["TopFloor"]["WaitSecDuringBossGen"] > Var["CurSec"]
	then
		return
	end


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["TopFloor"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["TopFloor"] = nil
		return
	end


	-- ��� ���� �׿����� üũ
	local bEndTopFloor = true

	for indexHandle, Value in pairs( Var["Enemy"] )
	do
		if Value ~= nil
		then
			bEndTopFloor = false
		end
	end


	-- Success Case : ��� ���� �׿��� ��
	if bEndTopFloor == true
	then
		GoToSuccess( Var )
		Var["TopFloor"] = nil
		DebugLog( "End TopFloor" )
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

		-- Success ����
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- �÷��̾�� Ŭ���� ���� �ֱ�
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill ����.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"] = {}
		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1

	end


	-- ���â���� �޼���
	if Var["QuestSuccess"]["SuccessStepNo"] <= #NPC_GuardChat["SuccessAndThenDialog"]
	then

		if Var["QuestSuccess"]["SuccessStepSec"] <= Var["CurSec"]
		then
			local GuardDialog = NPC_GuardChat["SuccessAndThenDialog"]

			cMobDialog( Var["MapIndex"], GuardDialog["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], GuardDialog[ Var["QuestSuccess"]["SuccessStepNo"] ]["Index"] )

			Var["QuestSuccess"]["SuccessStepNo"]	= Var["QuestSuccess"]["SuccessStepNo"] + 1		-- go to next dialog
			Var["QuestSuccess"]["SuccessStepSec"]	= Var["CurSec"] + DelayTime["BetweenSuccessDialog"]	-- set time for changing step

		end

		return
	end

	-- ���̾�α� ��
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

	Var["QuestFailed"] = {}

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


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
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

-- ������ ����Ʈ
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end

