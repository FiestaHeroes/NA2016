--------------------------------------------------------------------------------
--                    Secret Laboratory Progress Func                         --
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
		for i = 0, (#StepNameTable - 2)
		do
			local DoorTableIndex = nil

			DoorTableIndex = "Door"..i

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
					Var["Door"..i ] = nCurDoorHandle
				else
					ErrorLog( "InitDungeon::Door"..i.." was not created." )
				end
			end

		end

		-- �Ա��� �ⱸ����Ʈ ����
		local RegenExitGate  = RegenInfo["Stuff"]["StartExitGate"]
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

		-- ������ ��Ģ�� �ǰ��� �� �� ���� ����
		--[[

		�������̺��� �ϳ��� �����ͼ� �� ���� ������ ���Ѵ�.
		���� �̸��� ������ �ش� ���� ���� �޸𸮿� �����Ѵ�.
		���ؽ� ������� �ϳ��� ä��
		�̸� �迭�� ���� ���Ǳ�� �� ������ üũ�� �صּ� ��ġ�� �ʰ� �ϳ��� ����.
		�׷��� 10�� ������ �����Ѵ�.
		���� �ÿ��� ���ĵ� ������ �ϳ��� ���´�.

		]]

		-- ������ �� ���� ������ ������ �����ϴ� ���̺�
		local PatternSettingTable = {}

		-- �� ������ �����Ͽ� ������ �Űܳ��� ���̺�
		local PatternPointerTable = {}

		-- �� ���� ��
		local nPatternCount = 0
		for i = 1, #PatternNameTable
		do
			-- �� ���� ����
			local sPattern = PatternNameTable[i]

			-- ���ռ����� �� ���� ��Ī
			for k = 1, #RegenInfo["Group"]["EachPattern"][ sPattern ]
			do
				PatternPointerTable[ nPatternCount + k ] = { PatternName = sPattern, PatternOrderNo = k }
			end

			nPatternCount = nPatternCount + #RegenInfo["Group"]["EachPattern"][ sPattern ]
		end

		DebugLog( "InitDungeon::Pattern pointer table was set - Size : "..#PatternPointerTable )

		local CheckPatternSelected = {}			-- �ε���: ���ռ���, ��: üũ �� ��� true
		local nCheckPatternSelectedCount = 0 	-- ���ÿϷ�� ������ ��

		-- ���� ����( �� ���� ��ŭ )
		while nCheckPatternSelectedCount < #FloorPatternInfoTable
		do
			for i = 1, #PatternPointerTable
			do
				-- �ش� ������ �´� ���� ������ ��������� üũ�غ��� ����� �ȰŶ�� ��� �ȵ� ���������� ���õ� ������ ã�´�.
				if PatternPointerTable[ i ]["PatternName"] == FloorPatternInfoTable[ nCheckPatternSelectedCount + 1 ]
				then
					if CheckPatternSelected[ i ] ~= true
					then
						nCurPatternSelected = i
						break
					else
						if i == #PatternPointerTable
						then
							ErrorLog( "InitDungeon::Pattern Setting is Failed(Logic or Data Error)" )
						end
					end
				else
					if i == #PatternPointerTable
					then
						ErrorLog( "InitDungeon::Pattern Setting is Failed(Logic or Data Error)" )
					end
				end
			end


			-- ���ռ����� ������Ī������ ������ ���� ���� �Ұ��ϹǷ� �ش� ���� �н�
			if PatternPointerTable[ nCurPatternSelected ] ~= nil
			then
				-- �̹� ���õ� ���� ����
				if CheckPatternSelected[ nCurPatternSelected ] ~= true
				then
					-- ���� ����
					PatternSettingTable[ nCheckPatternSelectedCount + 1 ] = PatternPointerTable[ nCurPatternSelected ]
					-- ���� ���� ���� üũ
					CheckPatternSelected[ nCurPatternSelected ] = true
					DebugLog( "InitDungeon::Pattern is Selected ( "..PatternPointerTable[ nCurPatternSelected ]["PatternName"].." "..PatternPointerTable[ nCurPatternSelected ]["PatternOrderNo"].." )" )
					-- ī����
					nCheckPatternSelectedCount = nCheckPatternSelectedCount + 1
				end
			end
		end

		-- Ư������ ���� ����
		Var["bSpecialRewardMode"] = true

		-- �޸𸮿� ���� ���� ���� ����
		Var["StageInfo"]["PatternSetting"] = PatternSettingTable


		-- ���ð� ����
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end

	-- ��� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		cDoorAction( Var["Door0"], Var["Door"][ Var["Door0"] ]["Block"], "open" )
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
		return
	end

end


-- �� �� ���� �� ����
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

	-- ���� �߽� ��ǥ ��������
	local CurRegenCoord = RegenInfo["Coord"][ CurStepNo ]


	-- ������ ���� ���� �ʾ����� ���� �Ұ�
	if Var["StageInfo"]["PatternSetting"] == nil
	then
		return
	end

	if Var["StageInfo"]["PatternSetting"][ CurStepNo ] == nil
	then
		return
	end

	local CurPatternInfo = Var["StageInfo"]["PatternSetting"][ CurStepNo ]


	-- �ʱ�ȭ ���� ����
	local bInitFlag = false

	if Var["EachFloor"..CurStepNo ] == nil
	then
		bInitFlag = true
	else
		if Var["EachFloor"..CurStepNo ]["bEntranceArea"] == false
		then
			bInitFlag = true
		end
	end


	-- �� �ܰ� �ʱ� ����
	if bInitFlag == true
	then


		if Var["EachFloor"..CurStepNo ] == nil
		then
			DebugLog( "Start EachFloor "..CurStepNo )
			Var["EachFloor"..CurStepNo ] = {}

			-- ���̽��� �ܰ� ���п� ���� ����
			Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] = Var["CurSec"]
			Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] = 1

			Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepSec"] = Var["CurSec"]
			Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"] = 1

			Var["EachFloor"..CurStepNo ]["BossSummonDialogStepSec"] = Var["CurSec"]
			Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = 1

			Var["EachFloor"..CurStepNo ]["HelpUsChatStepSec"] = Var["CurSec"]

			-- ���̽��� ���� ���� ����
			Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] 			= false
			Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] 	= nil	-- �������� ���� ����� false�� ����
			Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] 		= nil	-- ������ ��ȯ�ϸ� false�� �����Ͽ� ����
			Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] 		= nil	-- ������ ��ȯ�ϸ� �ش� ��ų�� HP������ �Է��Ͽ� ����

			-- ����ܰ� ���� �÷���
			Var["EachFloor"..CurStepNo ]["bMobEliminated"] 			= false -- �������� ���� ������ ���� ��� �׾��� ��� True
			Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] 	= false	-- �������� 2�� �� ��� �� true
			Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] 	= false -- �������� 2�� 30�� �� ��� �� true
			Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedWarn"] 	= false	-- �������� ���� ���d���� ��� �� true
			Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] 		= false	-- �������� ���� ����°�

		end

		Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] = true

		-- Ÿ�Ӿ��� ���Ͽ��� ù ���� üũ( ó�� ������ �ν� �� �� ������ �� )
		if CurPatternInfo["PatternName"] == "Pattern_TimeAttack"
		then
			Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] = false

			if Var["EachFloor"..CurStepNo ]["bEntranceArea"] == nil
			then
				Var["EachFloor"..CurStepNo ]["bEntranceArea"] = false
			end

			local EntranceArea = AreaIndexTable[ CurPatternInfo["PatternOrderNo"] ]
			if EntranceArea ~= nil
			then
				local InBossAreaHandleList = { cGetAreaObjectList( Var["MapIndex"], EntranceArea, ObjectType["Player"] ) }

				if #InBossAreaHandleList > 0
				then
					Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] = true
					Var["EachFloor"..CurStepNo ]["bEntranceArea"] = true
					if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Entrance"]["Code"] ) == nil
					then
						ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - Entrance" )
					end
				else
				-- ���� �ش� ������ ���� ����
				end
			else
				ErrorLog( "EachFloor"..CurStepNo.."::Area Info does not exist!" )
				return
			end
		end


		if CurPatternInfo["PatternName"] == "Pattern_KillBoss"
		then
			if Var["BossBattle"] == nil
			then
				Var["BossBattle"] = {}
			end
		else
			Var["BossBattle"] = nil
		end


		if Var["EachFloor"..CurStepNo ]["bCanGenerateMonsters"] == true
		then

			-- ���� �� ��
			local CurMobRegen = RegenInfo["Mob"]["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

			if CurMobRegen ~= nil
			then
				for MobType, MobRegenInfo in pairs ( CurMobRegen )
				do
					local MobHandle = cMobRegen_XY( Var["MapIndex"], MobRegenInfo["Index"], RegenInfo["Coord"][ CurStepNo ]["x"], RegenInfo["Coord"][ CurStepNo ]["y"], MobRegenInfo["dir"] )

					if MobHandle ~= nil
					then

						Var["Enemy"][ MobHandle ] = { Index = MobRegenInfo["Index"], x = RegenInfo["Coord"][ CurStepNo ]["x"], y = RegenInfo["Coord"][ CurStepNo ]["y"], radius = MobRegenInfo["radius"] }

						Var["RoutineTime"][ MobHandle ] = cCurrentSecond()
						cSetAIScript ( MainLuaScriptPath, MobHandle )

						if MobType == "SemiBoss"
						then
							Var["EachFloor"..CurStepNo ]["SemiBossHandle"] = MobHandle

							-- Ÿ�Ӿ��� ����
							if MobRegenInfo["Index"] == "Lab_Slime"
							then
								cSetAbstate( MobHandle, SemiBossAbstate["TimeAttackMini"]["Index"], SemiBossAbstate["TimeAttackMini"]["Strength"], SemiBossAbstate["TimeAttackMini"]["KeepTime"] )
							else
								cSetAbstate( MobHandle, SemiBossAbstate["TimeAttack"]["Index"], SemiBossAbstate["TimeAttack"]["Strength"], SemiBossAbstate["TimeAttack"]["KeepTime"] )
								cAnimate( MobHandle, "start", "&TimeAttack_Stand" )
							end

							cAIScriptFunc( MobHandle, "Entrance", "SemiBossRoutine" )
						elseif MobType == "MidBoss"
						then
							Var["StageInfo"]["BossTypeNo"] = 1
							Var["EachFloor"..CurStepNo ]["MidBossHandle"] = MobHandle
							cAIScriptFunc( MobHandle, "Entrance",   "BossRoutine" )
							cAIScriptFunc( MobHandle, "MobDamaged", "BossDamaged" )
						elseif MobType == "Boss"
						then
							Var["StageInfo"]["BossTypeNo"] = 2
							Var["EachFloor"..CurStepNo ]["BossHandle"] = MobHandle
							cAIScriptFunc( MobHandle, "Entrance",   "BossRoutine" )
							cAIScriptFunc( MobHandle, "MobDamaged", "BossDamaged" )
						end

					end
				end
			end


			-- �� �׷� ��
			local CurGroupRegen = RegenInfo["Group"]["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

			if CurGroupRegen ~= nil
			then
				for i = 1, #CurGroupRegen
				do
					cGroupRegenInstance( Var["MapIndex"], CurGroupRegen[ i ] )
				end
			end


			-- ���� �� : ���� �������� ������
			if CurStepNo == #StepNameTable - 1
			then
				local CurRegenPrison   = RegenInfo["Stuff"]["Prison"]
				local nCurPrisonHandle = cDoorBuild( Var["MapIndex"], CurRegenPrison["Index"], CurRegenPrison["x"], CurRegenPrison["y"], CurRegenPrison["dir"], CurRegenPrison["scale"] )

				if nCurPrisonHandle  ~= nil
				then
					cDoorAction( nCurPrisonHandle , CurRegenPrison["Block"], "close" )

					Var["Prison"] = {}
					Var["Prison"]["RegenInfo"] 	= CurRegenPrison
					Var["Prison"]["Handle"] 	= nCurPrisonHandle
					Var["Prison"]["bOpened"] 	= false

					if cSetAIScript ( MainLuaScriptPath, nCurPrisonHandle ) == nil
					then
						ErrorLog( "EachFloor "..CurStepNo.."::cSetAIScript ( MainLuaScriptPath, nCurPrisonHandle ) == nil" )
					end

					if cAIScriptFunc( nCurPrisonHandle, "NPCClick", "PrisonClick" ) == nil
					then
						ErrorLog( "EachFloor "..CurStepNo.."::cAIScriptFunc( nCurPrisonHandle, \"NPCClick\", \"PrisonClick\" ) == nil" )
					end

				else
					ErrorLog( "EachFloor "..CurStepNo.."::Prison"..i.." was not created." )
				end
			end


			-- �ð� üũ
			Var["EachFloor"..CurStepNo ]["WaitMobGenSec"]  = Var["CurSec"] + DelayTime["WaitAfterGenMob"]
			Var["EachFloor"..CurStepNo ]["TimeAttack_R60"] = Var["CurSec"] + SemiBossWarning["Remain_60_Sec"]["OccurSec"]
			Var["EachFloor"..CurStepNo ]["TimeAttack_R30"] = Var["CurSec"] + SemiBossWarning["Remain_30_Sec"]["OccurSec"]

		end -- �� �� ���� if�� ����ġ///////

	end -- �ʱ⼳�� ��////////////


	-- Ÿ�Ӿ��� ���� �ĺ��� üũ�ϴ� �κ�
	if CurPatternInfo["PatternName"] == "Pattern_TimeAttack"
	then

		if Var["EachFloor"..CurStepNo ]["bEntranceArea"] == true
		then

			if Var["Enemy"][ Var["EachFloor"..CurStepNo ]["SemiBossHandle"] ] ~= nil
			then

				-- �������� ���� ���
				if Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] == true
				then
					if Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] == nil
					then
						Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] = false
					end
				end

				-- 1���� ���
				if Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] == false
				then
					if Var["CurSec"] >= Var["EachFloor"..CurStepNo ]["TimeAttack_R60"]
					then
						if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Remain_60_Sec"]["Code"] ) == nil
						then
							ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - Remain1min" )
						end
						Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
					end
				end

				-- 30���� ���
				if Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] == false
				then
					if Var["CurSec"] >= Var["EachFloor"..CurStepNo ]["TimeAttack_R30"]
					then
						if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Remain_30_Sec"]["Code"] ) == nil
						then
							ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - Remain30Sec" )
						end
						Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
					end
				end

				-- ��� ���
				if Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedWarn"] == false
				then
					if Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] == true
					then
						if cNoticeRedWarningCode( Var["MapIndex"], SemiBossWarning["Awakened"]["Code"] ) == nil
						then
							ErrorLog( "EachFloor"..CurStepNo.."::cNoticeRedWarningCode is Failed - BeAwakened" )
						end
						Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedWarn"] = true
					end
				end

			else
				--ErrorLog( "EachFloor"..CurStepNo.."::Egg Info does not exist." )
			end

		end

	end



	-- ä��
	local CurChat = ChatInfo["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

	-- ���� ��
	if CurChat["BeforeDialog"] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] == false
		then
			local nCurDialogNo = Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"]

			if nCurDialogNo <= #CurChat["BeforeDialog"]
			then
				if Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["BeforeDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["BeforeDialog"][ nCurDialogNo ]["Index"] )

					Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] = Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] + 1
					Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] = true
	end


	-- Ÿ�Ӿ��� ����� ��� ������ �ؾ� ������ ��Ų��.
	if CurPatternInfo["PatternName"] == "Pattern_TimeAttack"
	then
		if Var["EachFloor"..CurStepNo ]["bEntranceArea"] ~= true
		then
			return
		end
	end


	-- ������ ���� ���̵��� ���ش޶�� �ϴ� ����
	if CurChat["HelpUsChat"] ~= nil
	then
		local nCurDialogNo = cRandomInt( 1, #CurChat["HelpUsChat"] )

		if nCurDialogNo <= #CurChat["HelpUsChat"]
		then
			if Var["EachFloor"..CurStepNo ]["HelpUsChatStepSec"] <= Var["CurSec"]
			then
				cMobChat( Var["Prison"]["Handle"], ChatInfo["ScriptFileName"], CurChat["HelpUsChat"][ nCurDialogNo ]["Index"], true )

				Var["EachFloor"..CurStepNo ]["HelpUsChatStepSec"] = Var["CurSec"] + DelayTime["GapHelpUsChat"]
			end
		end
	end


	-- �������� ���� ����� ��
	if CurChat["SemiBossAwakenedDialog"] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] == false
		then
			local nCurDialogNo = Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"]

			if nCurDialogNo <= #CurChat["SemiBossAwakenedDialog"]
			then
				if Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["SemiBossAwakenedDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["SemiBossAwakenedDialog"][ nCurDialogNo ]["Index"] )

					Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"] = Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepNo"] + 1
					Var["EachFloor"..CurStepNo ]["SemiBossAwakenedDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["EachFloor"..CurStepNo ]["bSemiBossAwakenedDialogEnd"] = true
	end


	-- ������ ���� ��ȯ���� ��
	if Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] ~= nil
	then
		local sDialogIndex = "Summon"..Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"].."Dialog"
		if CurChat[ sDialogIndex ] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"]

				if nCurDialogNo <= #CurChat[ sDialogIndex ]
				then
					if Var["EachFloor"..CurStepNo ]["BossSummonDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat[ sDialogIndex ][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat[ sDialogIndex ][ nCurDialogNo ]["Index"] )
						DebugLog( "EachFloor"..CurStepNo .."::SummonDialog-"..Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"].."/"..nCurDialogNo )

						Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["BossSummonDialogStepSec"] = Var["CurSec"] + DelayTime["GapSummonDialog"]
					end

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = 1
					Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var["EachFloor"..CurStepNo ]["BossSummonDialogStepNo"] = 1
			Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = true
		end
	end


	-- �� ����üũ
	if Var["EachFloor"..CurStepNo ]["bMobEliminated"] == false
	then
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
		then
			Var["EachFloor"..CurStepNo ]["bMobEliminated"] = true
		end

		return
	else
		-- ���� �� ����
		if CurChat["AfterDialog"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"]

				if nCurDialogNo <= #CurChat["AfterDialog"]
				then
					if Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["AfterDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["AfterDialog"][ nCurDialogNo ]["Index"] )

						Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"] = Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] = true
		end
	end


	-- Next Case : �ش� ���� �� ���� �� Ŭ���� ���̽��� ���ο� ���� �� ���̽� ���� �����ϸ�.
	if Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] <= Var["CurSec"]
	then
		if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == true and Var["EachFloor"..CurStepNo ]["bMobEliminated"] == true
		then
			-- Ŭ���� �׼�
			if Var["Door"..CurStepNo ] ~= nil
			then
				cDoorAction( Var["Door"..CurStepNo ], Var["Door"][ Var["Door"..CurStepNo ] ]["Block"], "open" )
			end

			-- ���� �ܰ��
			Var["EachFloor"..CurStepNo ] = nil
			Var["EachFloor"]["StepNumber"] = CurStepNo + 1

			DebugLog( "End EachFloor "..CurStepNo )


			if CurStepNo == #StepNameTable - 1
			then
				Var["EachFloor"] = nil
				GoToNextStep( Var )
				return
			end

			return
		end
	end

end


-- ���̵� ����
function RescuedChildren( Var )
cExecCheck "RescuedChildren"

	if Var == nil
	then
		return
	end


	local nBossType = Var["StageInfo"]["BossTypeNo"]

	if Var["Prison"] == nil
	then
		return
	end

	if Var["Prison"]["bOpened"] == true
	then
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )
	else
		return
	end


	if Var["RescuedChildren"] == nil
	then
		DebugLog( "RescuedChildren::Start" )

		Var["RescuedChildren"] = {}

		-- Ư���� ���� ���� ��
		if Var["bSpecialRewardMode"] == true
		then
			local RewardBoxInfo = RegenInfo["Mob"]["RescuedChildren"]["SpecialRewardBox"]
			local nRewardBoxHandle = cMobRegen_XY( Var["MapIndex"], RewardBoxInfo["Index"], RewardBoxInfo["x"], RewardBoxInfo["y"], RewardBoxInfo["dir"] )
			if nRewardBoxHandle == nil
			then
				ErrorLog( "RescuedChildren::SpecialRewardBox was not created - SpecialRewardMode" )
			end
		end

		-- ���̵� ��
		for Index, ChildRegenInfo in pairs( RegenInfo["NPC"]["RescuedChildren"] )
		do
			if ChildRegenInfo ~= nil
			then
				local nChildHandle = cMobRegen_XY( Var["MapIndex"], ChildRegenInfo["Index"], ChildRegenInfo["x"], ChildRegenInfo["y"], ChildRegenInfo["dir"] )
				if nChildHandle ~= nil
				then
					Var["Friend"][ ChildRegenInfo["Index"] ] = nChildHandle
					DebugLog( "RescuedChildren::Child Gen : "..Index.."-"..ChildRegenInfo["Index"].."-"..nChildHandle )
				else
					ErrorLog( "RescuedChildren::Child Gen Failed" )
				end
			end
		end

		-- ä�� �ܰ� ������ ���� ����
		Var["RescuedChildren"]["PrisonVanishStepSec"] = Var["CurSec"] + DelayTime["BeforePrisonVanish"]

		Var["RescuedChildren"]["SequentialDialogStepSec"] = Var["CurSec"]
		Var["RescuedChildren"]["SequentialDialogStepNo"] = 1
		Var["RescuedChildren"]["AfterAnimationChatStepSec"] = Var["CurSec"]
		Var["RescuedChildren"]["AfterAnimationChatStepNo"] = 1

		Var["RescuedChildren"]["ChildrenRunToExitStepSec"] = Var["CurSec"]
		Var["RescuedChildren"]["ChildrenVanishStepSec"] = Var["CurSec"]


		Var["RescuedChildren"]["bPrisonVanishEnd"] = false
		Var["RescuedChildren"]["bSequentialDialogEnd"] = false
		Var["RescuedChildren"]["bAfterAnimationChatEnd"] = nil -- �ִϸ��̼� ������ false�� �ٲ�� ����
		Var["RescuedChildren"]["bChildrenRunToExitEnd"] = nil -- ���̵� �̾߱� ������ false�� �ٲ�� ����
		Var["RescuedChildren"]["bChildrenVanishEnd"] = nil -- ���̵� �޸��� ������ false�� �ٲ�� ����

	end

---------------------------------------------------------------------------------------------------------------------------------------------------
	-- ���� �������
	if Var["RescuedChildren"]["bPrisonVanishEnd"] == false
	then
		if Var["RescuedChildren"]["PrisonVanishStepSec"] <= Var["CurSec"]
		then
			cAIScriptSet( Var["Prison"]["Handle"] )
			cNPCVanish( Var["Prison"]["Handle"] )
			Var["RescuedChildren"]["bPrisonVanishEnd"] = true
			DebugLog( "RescuedChildren::Prison was vanished." )
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------
	-- �ִϸ��̼�
	if Var["RescuedChildren"]["bSequentialDialogEnd"] == true and Var["RescuedChildren"]["bAfterAnimationChatEnd"] == nil
	then
		for Index, AnimationInfo in pairs ( NPC_Animation )
		do
			if AnimationInfo ~= nil
			then
				local nHandle = Var["Friend"][ AnimationInfo["ActorIndex"] ]
				if nHandle == nil
				then
					ErrorLog( "RescuedChildren::Animation NPC Handle does not exist." )
				else
					cAnimate( nHandle, "start", AnimationInfo["Index"] )
					Var["RescuedChildren"]["AfterAnimationChatStepSec"] = Var["CurSec"] + DelayTime["AnimationTime"] -- �ִϸ��̼��� �� ������ �ֵ��� ���ϰ� �ϱ� ����.
				end
			end
		end

		Var["RescuedChildren"]["bAfterAnimationChatEnd"] = false
	end

	-- ����� ���̵��� �̾߱Ⱑ ������ �޸��� ���� ����
	if Var["RescuedChildren"]["bAfterAnimationChatEnd"] == true and Var["RescuedChildren"]["bChildrenRunToExitEnd"] == nil
	then
		Var["RescuedChildren"]["bChildrenRunToExitEnd"] = false
		Var["RescuedChildren"]["ChildrenRunToExitStepSec"] = Var["CurSec"] + DelayTime["BeforeChildrenRun"]
	end

	-- ���̵��� �޸��� ������� ���� ����
	if Var["RescuedChildren"]["bChildrenRunToExitEnd"] == true and Var["RescuedChildren"]["bChildrenVanishEnd"] == nil
	then
		Var["RescuedChildren"]["bChildrenVanishEnd"] = false
		Var["RescuedChildren"]["ChildrenVanishStepSec"] = Var["CurSec"] + DelayTime["AfterChildrenRun"]
	end

---------------------------------------------------------------------------------------------------------------------------------------------------
	-- ä��
	local CurChat = ChatInfo["RescuedChildren"]

	-- ������ �����ڸ���
	if CurChat["SequentialDialog"] ~= nil
	then
		if Var["RescuedChildren"]["bSequentialDialogEnd"] == false
		then
			local nCurDialogNo = Var["RescuedChildren"]["SequentialDialogStepNo"]

			if nCurDialogNo <= #CurChat["SequentialDialog"]
			then
				if Var["RescuedChildren"]["SequentialDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["SequentialDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["SequentialDialog"][ nCurDialogNo ]["Index"] )

					Var["RescuedChildren"]["SequentialDialogStepNo"] = Var["RescuedChildren"]["SequentialDialogStepNo"] + 1
					Var["RescuedChildren"]["SequentialDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["RescuedChildren"]["bSequentialDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["RescuedChildren"]["bSequentialDialogEnd"] = true
	end


	-- ���� �Ѹ��� �ִϸ��̼��� ����ǰ���..
	if CurChat["AfterAnimationChat"] ~= nil
	then
		if Var["RescuedChildren"]["bAfterAnimationChatEnd"] == false
		then
			local nCurDialogNo = Var["RescuedChildren"]["AfterAnimationChatStepNo"]

			if nCurDialogNo <= #CurChat["AfterAnimationChat"]
			then
				if Var["RescuedChildren"]["AfterAnimationChatStepSec"] <= Var["CurSec"]
				then
					local nHandle = Var["Friend"][ CurChat["AfterAnimationChat"][ nCurDialogNo ]["SpeakerIndex"] ]
					if nHandle == nil
					then
						ErrorLog( "RescuedChildren::Animation NPC Handle does not exist." )
					else
						if nCurDialogNo == 1
						then
							cAnimate( nHandle, "stop" )
						end
						cMobChat( nHandle, ChatInfo["ScriptFileName"], CurChat["AfterAnimationChat"][ nCurDialogNo ]["Index"], true )
					end

					Var["RescuedChildren"]["AfterAnimationChatStepNo"] = Var["RescuedChildren"]["AfterAnimationChatStepNo"] + 1
					Var["RescuedChildren"]["AfterAnimationChatStepSec"] = Var["CurSec"] + DelayTime["GapChildrenChat"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["RescuedChildren"]["bAfterAnimationChatEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["RescuedChildren"]["bAfterAnimationChatEnd"] = true
	end


	-- ���̵� �޸���
	if NPC_RunTo ~= nil
	then
		if Var["RescuedChildren"]["bChildrenRunToExitEnd"] == false
		then
			if Var["RescuedChildren"]["ChildrenRunToExitStepSec"] <= Var["CurSec"]
			then
				for Index, RunInfo in pairs ( NPC_RunTo )
				do
					if RunInfo ~= nil
					then
						if Var["Friend"][ RunInfo["ActorIndex"] ] ~= nil
						then
							if cRunTo( Var["Friend"][ RunInfo["ActorIndex"] ], RunInfo["x"], RunInfo["y"], 1000 ) == nil
							then
								ErrorLog( "RescuedChildren::"..RunInfo["ActorIndex"].."-cRunTo was failed." )
							end
						else
							ErrorLog( "RescuedChildren::RunMode - "..RunInfo["ActorIndex"].." does not exist." )
						end
					end
				end

				Var["RescuedChildren"]["bChildrenRunToExitEnd"] = true
			end

			-- �޸��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
			return
		end
	else
		-- �޸��� ������ ���� ��
		Var["RescuedChildren"]["bChildrenRunToExitEnd"] = true
	end


	-- ���̵� �������(�Ͱ���-_-;)
	if Var["RescuedChildren"]["bChildrenVanishEnd"] == false
	then
		if Var["RescuedChildren"]["ChildrenVanishStepSec"] <= Var["CurSec"]
		then
			for Index, ChildHandle in pairs ( Var["Friend"] )
			do
				cNPCVanish( ChildHandle )
			end

			Var["RescuedChildren"]["bChildrenVanishEnd"] = true
		end

		-- �Ͱ� Ÿ�̹��� �� �� ���� ���
		return
	end


	-- ���̵��� �� ������� �ⱸ ����Ʈ�� ���� �� ����
	if Var["RescuedChildren"]["bChildrenVanishEnd"] == true
	then
		-- �ⱸ�� �ⱸ����Ʈ ����
		local RegenExitGate  = RegenInfo["Stuff"]["EndExitGate"]
		local nExitGateHandle = cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

		if nExitGateHandle ~= nil
		then
			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "ReturnToHome::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "ExitGateClick" ) == nil
			then
				ErrorLog( "ReturnToHome::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"ExitGateClick\" ) == nil" )
			end
		end

		Var["RescuedChildren"] = nil
		Var["Prison"] = nil
		Var["Friend"] = nil
		GoToNextStep( Var )
		DebugLog( "RescuedChildren::End" )
	end

end


-- ŷ�� ����Ʈ Ŭ���� : �� ID ���� ��� ����
function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	if Var == nil
	then
		return
	end

	GoToNextStep( Var )
	DebugLog( "QuestSuccess::End" )

end


-- ŷ�� ����Ʈ ���� : ID ���� ��� ����
function QuestFailed( Var )
cExecCheck "QuestFailed"

	if Var == nil
	then
		return
	end

	GoToNextStep( Var )
	DebugLog( "QuestFailed::End" )

end


-- ��ȯ : ID ���� ��� ����
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end

	GoToNextStep( Var )
	DebugLog( "End ReturnToHome" )

end


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
ID_StepsList =
{
	{ Function = InitDungeon,  		Name = "InitDungeon",  		},
	{ Function = EachFloor,    		Name = "EachFloor",    		},
	{ Function = RescuedChildren,   Name = "RescuedChildren",   },
	{ Function = QuestSuccess, 		Name = "QuestSuccess", 		},
	{ Function = QuestFailed,  		Name = "QuestFailed",  		},
	{ Function = ReturnToHome, 		Name = "ReturnToHome", 		},
}


-- ������ ����Ʈ
ID_StepsIndexList =
{
}

for index, funcValue in pairs ( ID_StepsList )
do
	ID_StepsIndexList[ funcValue["Name"] ] = index
end
