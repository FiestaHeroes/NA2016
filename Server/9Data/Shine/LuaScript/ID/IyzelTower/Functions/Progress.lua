--------------------------------------------------------------------------------
--                       Tower Of Iyzel Progress Func                         --
--------------------------------------------------------------------------------

-- ���� �ʱ�ȭ
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- �ν��Ͻ� ���� ���� ���� �÷��̾��� ù �α����� ��ٸ���.
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

		-- �� ���̿� �ִ� �� ����
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

					-- ���� ���� ����
					Var["Door"][ nCurDoorHandle ] = CurRegenDoor

					-- �ڵ� ���� : ���ٿ�����
					Var["Door"..(i+1) ] = nCurDoorHandle
				end
			end

		end

		-- �Ա��� �ⱸ����Ʈ ����
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

		-- ���ð� ����
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end

	-- ��� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- 1~19 ��° ���� ����� ������
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


	-- �ܰ� ��ȣ ����
	if Var["EachFloor"]["StepNumber"] == nil
	then
		Var["EachFloor"]["StepNumber"] = 1
	end


	-- �ܰ��̸� �޾ƿ���
	local CurStepNo = Var["EachFloor"]["StepNumber"]	-- ex) 1
	local CurStep = StepNameTable[ CurStepNo ]			-- ex) Floor01


	-- �� �ܰ� �ʱ� ����
	if Var["EachFloor"..CurStepNo ] == nil
	then

		DebugLog( "Start EachFloor "..CurStepNo )

		Var["EachFloor"..CurStepNo ] = {}


		-- �� �׷� ��
		local CurStepRegen 	= RegenInfo["Group"][ CurStep ]

		for i = 1, #CurStepRegen
		do
			cGroupRegenInstance( Var["MapIndex"], CurStepRegen[i] )
		end

		-- ���� ��( ������� Only : 4, 9, 13, 19 �� )
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

		-- ���̽��� �ܰ� ���п� ���� ����
		Var["EachFloor"..CurStepNo ]["StartDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["StartDialogStepNo"] = 1
		Var["EachFloor"..CurStepNo ]["ClearDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["ClearDialogStepNo"] = 1
		Var["EachFloor"..CurStepNo ]["BossBattleDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["BossBattleDialogStepNo"] = 1

		-- ���̽��� ���� ���� ����
		Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bBossBattleDialogEnd"] = false

		-- �� ���� ���� ����
		Var["EachFloor"..CurStepNo ]["bMobEliminated"] = false

		Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]
	end

	-- �ش� �ܰ� ���۽��� ���̽���
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

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["EachFloor"..CurStepNo ]["bStartDialogEnd"] = true
	end


	-- �� ����üũ
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
		-- �ش� �� �� ���� ��

		-- Ŭ���� ���̽���
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

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] = true
		end
	end


	-- Next Case : �ش� ���� �� ���� �� Ŭ���� ���̽��� ���ο� ���� �� ���̽� ���� �����ϸ�.
	if Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] <= Var["CurSec"]
	then
		if Var["EachFloor"..CurStepNo ]["bClearDialogEnd"] == true
		then
			-- �ش� �� �� ���� ��Ȳ�� �ƴѰ�� �����ܰ�� �Ѿ�� �ʴ´�.
			if Var["EachFloor"..CurStepNo ]["bMobEliminated"] ~= true
			then
				return
			end

			-- Ŭ���� �׼�
			if Var["Door"..CurStepNo ] ~= nil
			then
				cDoorAction( Var["Door"..CurStepNo ], Var["Door"][ Var["Door"..CurStepNo ] ]["Block"], "open" )
			end

			-- ���� �ܰ��
			Var["EachFloor"..CurStepNo ] = nil
			Var["EachFloor"]["StepNumber"] = CurStepNo + 1

			DebugLog( "End EachFloor "..CurStepNo )

			-- ��� �� Ŭ���� ��
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


-- ŷ�� ����Ʈ Ŭ���� : ID ���� ��� ���� ����
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end

	DebugLog( "Start QuestSuccess" )

	-- Quest Mob Kill ����.
	cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

	GoToNextStep( Var )

	DebugLog( "End QuestSuccess" )

end


-- ŷ�� ����Ʈ ���� : ID ���� ��� ����
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


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
ID_StepsList =
{
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = EachFloor,    Name = "EachFloor",    },
	{ Function = QuestSuccess, Name = "QuestSuccess", },
	{ Function = QuestFailed,  Name = "QuestFailed",  },
	{ Function = ReturnToHome, Name = "ReturnToHome", },
}

-- ������ ����Ʈ
ID_StepsIndexList =
{
}

for index, funcValue in pairs ( ID_StepsList )
do
	ID_StepsIndexList[ funcValue["Name"] ] = index
end
