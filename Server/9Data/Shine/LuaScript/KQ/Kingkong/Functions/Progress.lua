--------------------------------------------------------------------------------
--                         Kingkong Progress Func                           --
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

			Var["QuestResult"] = "Fail"

			GoToFail( Var )
			return
		end

		return
	end


	-- 1�ʸ��� üũ
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

	-- ���� �ð� �� ���� �ܰ��
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


	-- 1�ʸ��� üũ
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


	-- �� �� �ʱ� ����
	if Var["FloorInfo"]["Init"] ~= Var["FloorInfo"]["FloorNumber"]
	then

		DebugLog( "Start Floor "..Var["FloorInfo"]["FloorNumber"] )


		local CurFloor = FloorNameTable[ Var["FloorInfo"]["FloorNumber"] ]	-- ���̸� �޾ƿ���

		-- �׷� ����
		local CurRegenGroup = RegenInfo["Group"][ CurFloor ]

		for i = 1, #CurRegenGroup
		do
			cGroupRegenInstance( Var["MapIndex"], CurRegenGroup[i] )
		end

		-- ���� ����
		local CurRegenMob = RegenInfo["BossMob"][ CurFloor ]

		Var["FloorInfo"]["Success"]	= nil
		Var["FloorInfo"]["Fail"]	= nil

		-- �� �� ���� ������ ��
		if CurRegenMob["Success"] ~= nil
		then
			local RegenMob = cMobRegen_XY( Var["MapIndex"], CurRegenMob["Success"]["Index"], CurRegenMob["Success"]["x"], CurRegenMob["Success"]["y"], CurRegenMob["Success"]["dir"] )

			-- ������ ������ ��ũ��Ʈ ����
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

		-- �� �� ���� ������ ��
		if CurRegenMob["Fail"] ~= nil
		then
			local RegenMob = cMobRegen_XY( Var["MapIndex"], CurRegenMob["Fail"]["Index"], CurRegenMob["Fail"]["x"], CurRegenMob["Fail"]["y"], CurRegenMob["Fail"]["dir"] )

			Var["FloorInfo"]["Fail"] = RegenMob

		end


		Var["FloorInfo"]["Init"] = Var["FloorInfo"]["FloorNumber"];

	end



	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )

		Var["FloorInfo"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )

		Var["FloorInfo"] = nil
		return
	end


	-- ���̸� �ȵǴ¸� ������� ����
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

	-- ���� ������ ����
	if Var["FloorInfo"]["Success"] ~= nil
	then
		if cIsObjectDead( Var["FloorInfo"]["Success"] ) == 1
		then
			cAIScriptSet( Var["FloorInfo"]["Success"] )

			-- �� Ŭ����
			if cMobSuicide( Var["MapIndex"] ) == nil
			then
				ErrorLog( "FloorFunc::Suicide Fail" )
			end

			-- ������ ������ ŷ�� ����
			-- �ƴϸ� ������
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



-- ŷ�� ����Ʈ Ŭ����
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	end

	Var["CurSec"] = cCurrentSecond()


	-- ���� ������
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

	-- Success ����
	cVanishTimer( Var["MapIndex"] )
	cQuestResult( Var["MapIndex"], "Success" )

	-- �÷��̾�� Ŭ���� ���� �ֱ�
	cReward( Var["MapIndex"], "KQ" )

	-- Quest Mob Kill ����.
	cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

	GoToNextStep( Var )

	DebugLog( "End QuestSuccess" )

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


	-- 1�ʸ��� üũ
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


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
KQ_StepsList =
{
	{ Function = InitDungeon,	Name = "InitDungeon",	},
	{ Function = FloorFunc,		Name = "FloorFunc",		},
	{ Function = QuestSuccess,	Name = "QuestSuccess",	},
	{ Function = QuestFailed,	Name = "QuestFailed",	},
	{ Function = ReturnToHome,	Name = "ReturnToHome",	},
}

-- ������ ����Ʈ
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end

