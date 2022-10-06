--------------------------------------------------------------------------------
--                        Emperor Slime Progress Func                         --
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


	-- ���̾�α�(���̽���) index üũ �� ����
	if Var["GuideOfGuard"]["NoticeStepNo"] <= #NPC_GuardChat["StartWarnDialog"]
	then

		-- ���̽��� ó��
		if Var["GuideOfGuard"]["NoticeStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["StartWarnDialog"][ Var["GuideOfGuard"]["NoticeStepNo"] ]["Index"] )

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

		-- ŷ�� ����Ʈ�� �����ϴ� �÷��̾� ���� üũ
		Var["PlayerCount"] = cObjectCount( Var["MapIndex"], ObjectType["Player"] )
		if Var["PlayerCount"] == 1 -- ȥ�� �׽�Ʈ�ϴ� �뵵
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


-- 1, 2, 3��
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

	-- �� �� �ʱ� ����
	if Var["LowerFloor"..CurFloorNo ] == nil
	then

		DebugLog( "Start Floor "..CurFloorNo )

		Var["LowerFloor"..CurFloorNo ] = {}

		local CurFloor = FloorNameTable[ CurFloorNo ]	-- ���̸� �޾ƿ���


		-- �׷� ��
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


		-- �� �� ��
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


	-- �� ���� �ð��� ��ٷ��� �� Ŭ���� üũ�� �ϱ� ���ؼ� ���� �ð��� ��ٷ���
	if Var["LowerFloor"..CurFloorNo ]["WaitSecDuringMobGen"] > Var["CurSec"]
	then
		return
	end

	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["LowerFloor"..CurFloorNo ] = nil
		Var["LowerFloor"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["LowerFloor"..CurFloorNo ] = nil
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
		-- ������
		cDoorAction( Var["Door"..CurFloorNo ], RegenInfo["Stuff"]["Door"..CurFloorNo ]["Block"], "open" )

		-- ŷ������ ���̽���
		if CurFloorNo <= #KingSlimeChat["FloorClearDialog"]
		then
			cMobDialog( Var["MapIndex"], KingSlimeChat["SpeakerIndex"], KingSlimeChat["ScriptFileName"], KingSlimeChat["FloorClearDialog"][ CurFloorNo ]["Index"] )
		end

		-- ���� ������
		Var["LowerFloor"..CurFloorNo ] = nil

		DebugLog( "End Floor "..CurFloorNo )

		Var["LowerFloor"]["FloorNumber"] = Var["LowerFloor"]["FloorNumber"] + 1

		-- 1,2,3���� ��� Ŭ���� �Ǹ� ŷ�����Ӱ��� ����!
		if Var["LowerFloor"]["FloorNumber"] > 3
		then

			Var["LowerFloor"] = nil
			GoToNextStep( Var )
			return
		end

		return
	end

end


-- ŷ�����Ӿ�� �ֻ���
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

		-- Ȳ�������� ����� �ð��� �ܰ� �ʱ�ȭ
		Var["TopFloor"]["WarnStepSec"] 			= Var["CurSec"]
		Var["TopFloor"]["WarnStepNo"] 			= 1
		Var["TopFloor"]["WaitSecDuringBossGen"] = Var["CurSec"] + DelayTime["AfterMobGen"]

		Var["TopFloor"]["bBossTurning"] 			= false
		Var["TopFloor"]["BossAnimationStopStepSec"] = Var["CurSec"]

		Var["TopFloor"]["AllCompletingStepSec"]	= nil

	end


------ EmperorSlime�� ���

	-- ���̽��� �ܰ� üũ �� ����
	if Var["TopFloor"]["WarnStepNo"] <= #EmperorSlimeChat["WarningDialog"]
	then

		-- ���̾�α� ó��
		if Var["TopFloor"]["WarnStepSec"] <= Var["CurSec"]
		then
			cMobDialog( Var["MapIndex"], EmperorSlimeChat["SpeakerIndex"], EmperorSlimeChat["ScriptFileName"], EmperorSlimeChat["WarningDialog"][ Var["TopFloor"]["WarnStepNo"] ]["Index"] )

			Var["TopFloor"]["WarnStepNo"] 	= Var["TopFloor"]["WarnStepNo"] + 1								-- ���� �ܰ� ��ȣ ����
			Var["TopFloor"]["WarnStepSec"] 	= Var["CurSec"] + DelayTime["BetweenEmperorSlimeWarnDialog"] 	-- ���� ���̽��� ��� �ð� ����
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
	local bEndTopFloor = false

	if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
	then
		if Var["TopFloor"]["AllCompletingStepSec"] == nil
		then
			Var["TopFloor"]["AllCompletingStepSec"] = Var["CurSec"] + DelayTime["AfterKillBoss"]
		end
		bEndTopFloor = true
	end


	-- Success Case : ��� ���� �׿��� ��
	if bEndTopFloor == true
	then
		-- Ŭ���� �� �ܰ谡 �Ѿ����� ���� �ð����� ������ ��
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

		-- Success ����
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- �÷��̾�� Ŭ���� ���� �ֱ�
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill ����.
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1

	end


	-- ���â���� �޼���
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

