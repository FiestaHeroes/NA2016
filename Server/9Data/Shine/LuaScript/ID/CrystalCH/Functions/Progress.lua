--------------------------------------------------------------------------------
--                       Crystal Castle Progress Func                         --
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
		�����Լ��� �̿��Ͽ� ��ȯ������� �ϳ��� ä��
		�̸� �迭�� ���� ���Ǳ�� �� ������ üũ�� �صּ� ��ġ�� �ʰ� �ϳ��� ����.
		�׷��� 9�� ������ ���� ������ ��� ���´�.
		���� �ű⼭ ���´�. ���� �̸��� ������ �ش� ���� ���� �޸𸮿� �����س��´�.

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
			for k = 1, #RegenInfo["Group"][ sPattern ]
			do
				PatternPointerTable[ nPatternCount + k ] = { PatternName = sPattern, PatternOrderNo = k }
			end

			nPatternCount = nPatternCount + #RegenInfo["Group"][ sPattern ]
		end


		local CheckPatternSelected = {}			-- �ε���: ���ռ���, ��: üũ �� ��� true
		local nCheckPatternSelectedCount = 0 	-- ���ÿϷ�� ������ ��

		-- ���� ����( �� ���� ��ŭ )
		while nCheckPatternSelectedCount < #StepNameTable - 2
		do
			local nCurPatternSelected = cRandomInt( 1, nPatternCount ) -- ��� ������ ���ռ����� �������� ����

			-- ���ռ����� ������Ī������ ������ ���� ���� �Ұ��ϹǷ� �ش� ���� �н�
			if PatternPointerTable[ nCurPatternSelected ] ~= nil
			then
				-- �̹� ���õ� ���� ����
				if CheckPatternSelected[ nCurPatternSelected ] ~= true
				then
					-- ���� 5�� ���� Pattern_KamarisTrap �� ������
					DebugLog( "InitDungeon::Pattern is Tried ( "..PatternPointerTable[ nCurPatternSelected ]["PatternName"].." "..PatternPointerTable[ nCurPatternSelected ]["PatternOrderNo"].." )" )
					if nCheckPatternSelectedCount >= 5 or PatternPointerTable[ nCurPatternSelected ]["PatternName"] ~= "Pattern_KamarisTrap"
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
		end

		-- �޸𸮿� ���� ���� ���� ����
		Var["StageInfo"]["PatternSetting"] = PatternSettingTable



		-- Ȯ�� ���� üũ
		local nTotalProb = BossSelectProbablityPercent["Boss1"] + BossSelectProbablityPercent["Boss2"] + BossSelectProbablityPercent["Boss3"]
		if nTotalProb ~= 100
		then
			ErrorLog( "InitDungeon::TotalProb ~= 100 in Boss Selecting Mode" )
			return
		end

		-- ������ Ȯ���� �ǰ��� ���� ����
		local nPercent = cRandomInt( 1, 100 )

		if nPercent <= BossSelectProbablityPercent["Boss1"]
		then
			Var["StageInfo"]["BossTypeNo"] = 1
		elseif nPercent <= BossSelectProbablityPercent["Boss1"] + BossSelectProbablityPercent["Boss2"]
		then
			Var["StageInfo"]["BossTypeNo"] = 2
		else
			Var["StageInfo"]["BossTypeNo"] = 3
		end


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


-- 1~9 ��° ���� ����� ������
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


	-- �� �ܰ� �ʱ� ����
	if Var["EachFloor"..CurStepNo ] == nil
	then

		DebugLog( "Start EachFloor "..CurStepNo )

		Var["EachFloor"..CurStepNo ] = {}


		-- �� �׷� ��
		local CurGroupRegen = RegenInfo["Group"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

		if CurGroupRegen ~= nil
		then
			if CurPatternInfo["PatternName"] ~= "Pattern_KamarisTrap" and CurPatternInfo["PatternName"] ~= "Pattern_OnlyOneIsKey"
			then
				for i = 1, #CurGroupRegen
				do
					cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
				end
			elseif CurPatternInfo["PatternName"] == "Pattern_KamarisTrap"
			then
				-- ī�������� �ҷ���
				for i = 1, #CurGroupRegen[ 1 ]
				do
					cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ 1 ][ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
				end
			end
		end


		-- ���� �� ��
		local CurMobRegen = RegenInfo["Mob"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

		if CurMobRegen ~= nil
		then
			for MobType, MobRegenInfo in pairs ( CurMobRegen )
			do
				local nMobCount = MobRegenInfo["count"]
				if nMobCount == nil
				then
					nMobCount = 1
				end

				for i = 1, nMobCount
				do
					local MobHandle = cMobRegen_Circle( Var["MapIndex"], MobRegenInfo["Index"], RegenInfo["Coord"][ CurStepNo ]["x"], RegenInfo["Coord"][ CurStepNo ]["y"], MobRegenInfo["radius"] )

					if MobHandle ~= nil
					then

						Var["Enemy"][ MobHandle ] = { Index = MobRegenInfo["Index"], x = RegenInfo["Coord"][ CurStepNo ]["x"], y = RegenInfo["Coord"][ CurStepNo ]["y"], radius = MobRegenInfo["radius"] }

						Var["RoutineTime"][ MobHandle ] = cCurrentSecond()
						cSetAIScript ( MainLuaScriptPath, MobHandle )

						if MobType == "Boss"
						then
							Var["EachFloor"..CurStepNo ]["MidBossHandle"] = MobHandle
							cAIScriptFunc( MobHandle, "Entrance", "MidBossMobRoutine" )
						elseif MobType == "Key"
						then
							cAIScriptFunc( MobHandle, "Entrance", "KeyBoxRoutine" )
						elseif MobType == "Mob"
						then
							cAIScriptFunc( MobHandle, "Entrance", "MobBoxRoutine" )
						elseif MobType == "Jewel"
						then
							cAIScriptFunc( MobHandle, "Entrance", "JewelBoxRoutine" )
						end

					end
				end
			end
		end


		-- ���̽��� �ܰ� ���п� ���� ����
		Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] = 1

		Var["EachFloor"..CurStepNo ]["AppearMobDialogStepSec"] = Var["CurSec"]
		Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"] = 1


		-- ���̽��� ���� ���� ����
		Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] = false
		Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = nil	-- �����ڸ� �������� false�� �ǰ� �޼��� �� �� true ��.
		Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = nil -- ��÷���ڸ� ���� false�� �Ǿ� ���ڰ� 1���̹Ƿ� 1ȸ ����
		Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] = false


		-- �� ���� ���� ����
		Var["EachFloor"..CurStepNo ]["bMobEliminated"] = false
		Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] = false


		Var["EachFloor"..CurStepNo ]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]

	end

	-- ä��
	local CurChat = ChatInfo["EachPattern"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

	-- ���� ��
	if CurChat["Before"] ~= nil
	then
		if Var["EachFloor"..CurStepNo ]["bBeforeDialogEnd"] == false
		then
			local nCurDialogNo = Var["EachFloor"..CurStepNo ]["BeforeDialogStepNo"]

			if nCurDialogNo <= #CurChat["Before"]
			then
				if Var["EachFloor"..CurStepNo ]["BeforeDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["Before"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["Before"][ nCurDialogNo ]["Index"] )

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

	-- ���ڿ��� ����
	if CurPatternInfo["PatternName"] == "Pattern_OnlyOneIsKey"
	then
		if Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] == nil
		then
			Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] = 0
		end

		if Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] > 0 and Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] ~= false
		then
			-- ������ ���� ���̾�α� ��쵵�� ����
			Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = false

			-- �� �׷� ��
			local CurGroupRegen = RegenInfo["Group"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

			if CurGroupRegen ~= nil
			then
				-- �� ���ڸ� ���� ��Ÿ���� ��
				for i = 1, #CurGroupRegen
				do
					cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
				end
			end

			-- ä�� �ܰ� ���� �ʱ�ȭ
			Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] = 1
			Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] = Var["CurSec"]

			-- ���� ���� ���� �ϳ� �ٿ���( ���� ���ڿ� ���� ó���� �Ϸ� �߱� ������ )
			Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] = Var["EachFloor"..CurStepNo ]["nMobBoxOpened"] - 1
		end

		if Var["EachFloor"..CurStepNo ]["KeyBoxOpened"] == true
		then
			-- ���� ���� ���� ���̾�α� ��쵵�� ����
			Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = false

			Var["EachFloor"..CurStepNo ]["KeyBoxOpened"] = false
		end


		-- �� ���� ��� : �ݺ�
		if CurChat["OpenMob"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"]

				if nCurDialogNo <= #CurChat["OpenMob"]
				then
					if Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["OpenMob"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["OpenMob"][ nCurDialogNo ]["Index"] )

						Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] = Var["EachFloor"..CurStepNo ]["OpenMobDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["OpenMobDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var["EachFloor"..CurStepNo ]["bOpenMobDialogEnd"] = true
		end

		-- ���ڰ� �� ����� ��� : 1ȸ
		if CurChat["OpenKey"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"]

				if nCurDialogNo <= #CurChat["OpenKey"]
				then
					if Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["OpenKey"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["OpenKey"][ nCurDialogNo ]["Index"] )

						Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"] = Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepNo"] + 1
						Var["EachFloor"..CurStepNo ]["OpenKeyDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
					end

					-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
					return
				else
					-- ���̽��� ����
					Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = true
				end
			end
		else
			-- ���̽��� ��ü�� ���� ��
			Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] = true
		end
	-- ī������ ����
	elseif CurPatternInfo["PatternName"] == "Pattern_KamarisTrap"
	then
		-- �� ����üũ
		if Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] == false
		then
			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
			then
				Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] = true

				-- �� �׷� ��
				local CurGroupRegen = RegenInfo["Group"][ CurPatternInfo["PatternName"] ][ CurPatternInfo["PatternOrderNo"] ]

				if CurGroupRegen ~= nil
				then
					if CurGroupRegen[ 2 ] ~= nil
					then
						-- ī������ �μ� �� ��Ÿ���� ��
						for i = 1, #CurGroupRegen[ 2 ]
						do
							cGroupRegenInstance_XY( Var["MapIndex"], CurGroupRegen[ 2 ][ i ], CurRegenCoord["x"], CurRegenCoord["y"] )
						end
					end
				end
			end

			return
		else
			-- ī�������� �װ� ���� �� �ߵǴ� ��� : 1ȸ
			if CurChat["AppearMob"] ~= nil
			then
				if Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] == false
				then
					local nCurDialogNo = Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"]

					if nCurDialogNo <= #CurChat["AppearMob"]
					then
						if Var["EachFloor"..CurStepNo ]["AppearMobDialogStepSec"] <= Var["CurSec"]
						then
							cMobDialog( Var["MapIndex"], CurChat["AppearMob"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["AppearMob"][ nCurDialogNo ]["Index"] )

							Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"] = Var["EachFloor"..CurStepNo ]["AppearMobDialogStepNo"] + 1
							Var["EachFloor"..CurStepNo ]["AppearMobDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
						end

						-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
						return
					else
						-- ���̽��� ����
						Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] = true
					end
				end
			else
				-- ���̽��� ��ü�� ���� ��
				Var["EachFloor"..CurStepNo ]["bAppearMobDialogEnd"] = true
			end
		end

	else
		-- There is no process here.
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
		-- ���� �� ����
		if CurChat["After"] ~= nil
		then
			if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == false
			then
				local nCurDialogNo = Var["EachFloor"..CurStepNo ]["AfterDialogStepNo"]

				if nCurDialogNo <= #CurChat["After"]
				then
					if Var["EachFloor"..CurStepNo ]["AfterDialogStepSec"] <= Var["CurSec"]
					then
						cMobDialog( Var["MapIndex"], CurChat["After"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["After"][ nCurDialogNo ]["Index"] )

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
		if Var["EachFloor"..CurStepNo ]["bAfterDialogEnd"] == true
		then
			if CurPatternInfo["PatternName"] == "Pattern_KamarisTrap"
			then
				if Var["EachFloor"..CurStepNo ]["bDestroyedKamaris"] ~= true
				then
					return
				end

			elseif CurPatternInfo["PatternName"] == "Pattern_OnlyOneIsKey"
			then
				if Var["EachFloor"..CurStepNo ]["bOpenKeyDialogEnd"] ~= true
				then
					return
				end

			else
				if Var["EachFloor"..CurStepNo ]["bMobEliminated"] ~= true
				then
					return
				end

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
			if Var["EachFloor"]["StepNumber"] > #StepNameTable - 2
			then

				Var["EachFloor"] = nil
				GoToNextStep( Var )
				return
			end

			return
		end
	end

end


-- ������
function BossBattle( Var )
cExecCheck "BossBattle"

	if Var == nil
	then
		return
	end

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossBattle::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		return
	end

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	if Var["BossBattle"] == nil
	then
		DebugLog( "BossBattle::Start" )
		Var["BossBattle"] = {}

		-- �� �׷� ��
		for i = 1, #RegenInfo["Group"]["BossBattle"][ nBossType ]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["BossBattle"][ nBossType ][ i ] )
		end


		-- ���� ��
		if Var["BossBattle"]["BossAC_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossAC_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossMR_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossMR_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossImmortalEffectCount"] == nil
		then
			Var["BossBattle"]["BossImmortalEffectCount"] = 0
		end

		for MobType, MobRegenInfo in pairs( RegenInfo["Mob"]["BossBattle"][ nBossType ] )
		do
			local nMobHandle = cMobRegen_XY( Var["MapIndex"], MobRegenInfo["Index"], MobRegenInfo["x"], MobRegenInfo["y"], MobRegenInfo["dir"] )

			if nMobHandle ~= nil
			then
				-- ���� ó��
				Var["Enemy"][ nMobHandle ] = MobRegenInfo
				Var["RoutineTime"][ nMobHandle ] = cCurrentSecond()
				cSetAIScript ( MainLuaScriptPath, nMobHandle )

				-- �з� ó��
				if MobType == "LizardManGuardian" or MobType == "HeavyOrc" or MobType == "JewelGolem"
				then

					Var["BossHandle"] = nMobHandle
					cAIScriptFunc( nMobHandle, "Entrance",   "BossRoutine" )
					cAIScriptFunc( nMobHandle, "MobDamaged", "BossDamaged" )

				elseif MobType == "PhysicalPillar"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "PhysicalPillarRoutine" )

					-- ���� ���� ��� ��ȭ ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
					Var["BossBattle"]["BossAC_PlusEffectCount"] = Var["BossBattle"]["BossAC_PlusEffectCount"] + 1

				elseif MobType == "MagicalPillar"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "MagicalPillarRoutine" )

					-- ���� ���� ��� ��ȭ ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
					Var["BossBattle"]["BossMR_PlusEffectCount"] = Var["BossBattle"]["BossMR_PlusEffectCount"] + 1

				elseif MobType == "ImmortalPillar1" or MobType == "ImmortalPillar2" or MobType == "ImmortalPillar3" or MobType == "ImmortalPillar4"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "ImmortalPillarRoutine" )

					-- ���� ����ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
					Var["BossBattle"]["BossImmortalEffectCount"] = Var["BossBattle"]["BossImmortalEffectCount"] + 1

				end
			else
				DebugLog( "BossBattle::nMobHandle == nil" )
			end
		end -- ������ for��

		-- ���̽��� �ܰ� ���п� ���� ����
		Var["BossBattle"]["InitDialogStepSec"] = Var["CurSec"]
		Var["BossBattle"]["InitDialogStepNo"] = 1

		Var["BossBattle"]["ReInitDialogStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ReInitDialogStepNo"] = 1

		Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] = 1

		Var["BossBattle"]["ClearDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ClearDialogAndNoticeStepNo"] = 1

		-- ���̽��� ���� ���� ����
		Var["BossBattle"]["bInitDialogEnd"] 				= false
		Var["BossBattle"]["bReInitDialogEnd"] 				= nil -- ����� ���ǽ� false�� �Ǿ� �ʱ�ȭ�� �����.
		Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] 	= nil -- ������ ���ǽ� false�� �Ǿ� �ʱ�ȭ�� �����.
		Var["BossBattle"]["bClearDialogAndNoticeEnd"] 		= nil -- ���� ���ǽ� ����

		-- �� ���� ���� ����
		Var["BossBattle"]["bMobEliminated"] = false

		Var["BossBattle"]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]

	end -- BossBattle �ʱ�ȭ if��


	-- ����� ����
	if Var["BossBattle"]["bRestartCondition"] == true
	then
		DebugLog( "BossBattle::Restart-Vanish All" )

		-- ���� �� �������
		local CenterCoord = { x = RegenInfo["Mob"]["BossBattle"][ 1 ]["LizardManGuardian"]["x"], y = RegenInfo["Mob"]["BossBattle"][ 1 ]["LizardManGuardian"]["y"] }
		local PreviousMobHandleList = { cGetNearObjListByCoord( Var["MapIndex"], CenterCoord["x"], CenterCoord["y"], 1000, ObjectType["Mob"], "so_ObjectType", 50 ) }
		for i = 1, #PreviousMobHandleList
		do
			cNPCVanish( PreviousMobHandleList[ i ] )
		end

		-- �� ������°� üũ�ϱ�
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) > 0
		then
			ErrorLog( "BossBattle::Mob Reinitializing(Vanishing Step) is failed." )
			return
		end

		cDoorAction( Var["Door"..(#StepNameTable - 2) ], RegenInfo["Stuff"]["Door"..(#StepNameTable - 2) ]["Block"], "open" )

		DebugLog( "BossBattle::Restart-Regen" )

		Var["BossBattle"] = nil

		Var["BossBattle"] = {}

		-- �� �׷� ��
		for i = 1, #RegenInfo["Group"]["BossBattle"][ nBossType ]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["BossBattle"][ nBossType ][ i ] )
		end


		-- ���� ��
		if Var["BossBattle"]["BossAC_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossAC_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossMR_PlusEffectCount"] == nil
		then
			Var["BossBattle"]["BossMR_PlusEffectCount"] = 0
		end

		if Var["BossBattle"]["BossImmortalEffectCount"] == nil
		then
			Var["BossBattle"]["BossImmortalEffectCount"] = 0
		end

		for MobType, MobRegenInfo in pairs( RegenInfo["Mob"]["BossBattle"][ nBossType ] )
		do
			local nMobHandle = cMobRegen_XY( Var["MapIndex"], MobRegenInfo["Index"], MobRegenInfo["x"], MobRegenInfo["y"], MobRegenInfo["dir"] )

			if nMobHandle ~= nil
			then
				-- ���� ó��
				Var["Enemy"][ nMobHandle ] = MobRegenInfo
				Var["RoutineTime"][ nMobHandle ] = cCurrentSecond()
				cSetAIScript ( MainLuaScriptPath, nMobHandle )

				-- �з� ó��
				if MobType == "LizardManGuardian" or MobType == "HeavyOrc" or MobType == "JewelGolem"
				then
					-- ���� �ڵ� �߰� ��� �� AI ����
					Var["BossHandle"] = nMobHandle
					cAIScriptFunc( nMobHandle, "Entrance",   "BossRoutine" )
					cAIScriptFunc( nMobHandle, "MobDamaged", "BossDamaged" )

				elseif MobType == "PhysicalPillar"
				then

					cAIScriptFunc( nMobHandle, "Entrance", "PhysicalPillarRoutine" )

					-- ���� ���� ��� ��ȭ ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
					Var["BossBattle"]["BossAC_PlusEffectCount"] = Var["BossBattle"]["BossAC_PlusEffectCount"] + 1

				elseif MobType == "MagicalPillar"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "MagicalPillarRoutine" )

					-- ���� ���� ��� ��ȭ ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
					Var["BossBattle"]["BossMR_PlusEffectCount"] = Var["BossBattle"]["BossMR_PlusEffectCount"] + 1

				elseif MobType == "ImmortalPillar1" or MobType == "ImmortalPillar2" or MobType == "ImmortalPillar3" or MobType == "ImmortalPillar4"
				then
					cAIScriptFunc( nMobHandle, "Entrance", "ImmortalPillarRoutine" )

					-- ���� ����ȿ���� �ִ� �ʷ� ������ �� �� ������ ����
					Var["BossBattle"]["BossImmortalEffectCount"] = Var["BossBattle"]["BossImmortalEffectCount"] + 1

				end
			else
				DebugLog( "BossBattle::nMobHandle == nil" )
			end
		end -- ������ for��

		-- ���̽��� �ܰ� ���п� ���� ����
		Var["BossBattle"]["ReInitDialogStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ReInitDialogStepNo"] = 1

		Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] = 1

		Var["BossBattle"]["ClearDialogAndNoticeStepSec"] = Var["CurSec"]
		Var["BossBattle"]["ClearDialogAndNoticeStepNo"] = 1

		-- ���̽��� ���� ���� ����
		Var["BossBattle"]["bInitDialogEnd"] 				= true  -- �̹� �� �κ��� ���� ��Ȳ��
		Var["BossBattle"]["bReInitDialogEnd"] 				= false -- ����� ������ �Ǿ����Ƿ� �ش� ���̾�α� ����
		Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] 	= nil   -- �� ���� ������ �Ǹ� false�� �Ǿ� ����
		Var["BossBattle"]["bClearDialogAndNoticeEnd"] 		= nil -- Ŭ���� ������ �Ǹ� �ش� ���� ����

		-- �� ���� ���� ����
		Var["BossBattle"]["bMobEliminated"] = false

		Var["BossBattle"]["WaitMobGenSec"] = Var["CurSec"] + DelayTime["WaitAfterGenMob"]

	end -- BossBattle ����ۿ� �ʱ�ȭ if��


	-- �� ���� ���� üũ �� ����
	if Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] == nil
	then
		-- ��� �÷��̾� �� �Ѹ��̶� �����ȿ� ���� ���¿��� �����ð��� ������ ������ ���ϵ��� ���� ���� �ݴ´�.
		local InBossAreaHandleList = { cGetAreaObjectList( Var["MapIndex"], BossArea["Index"], ObjectType["Player"] ) }

		if #InBossAreaHandleList > 0
		then
			if Var["BossBattle"]["InAreaStackCount"] == nil
			then
				Var["BossBattle"]["InAreaStackCount"] = 0
			end

			Var["BossBattle"]["InAreaStackCount"] = Var["BossBattle"]["InAreaStackCount"] + 1

			if Var["BossBattle"]["InAreaStackCount"] > BossArea["TriggerCount"]
			then
				cDoorAction( Var["Door"..(#StepNameTable - 2) ], RegenInfo["Stuff"]["Door"..(#StepNameTable - 2) ]["Block"], "close" )
				Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] = false
			end
		end
	end


	-- Ŭ���� ���� üũ �� ä�� ���� ����
	if Var["BossBattle"]["bClearDialogAndNoticeEnd"] == nil
	then
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) < 1
		then
			Var["BossBattle"]["bClearDialogAndNoticeEnd"] = false
		end
	end

---------------------------------------------------------------------------------------------------------------------------------------------------
	-- ä��
	local CurChat = ChatInfo["BossBattle"]["Boss"..nBossType ]

	-- ���� �ʱ�ȭ ��
	if CurChat["InitDialog"] ~= nil
	then
		if Var["BossBattle"]["bInitDialogEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["InitDialogStepNo"]

			if nCurDialogNo <= #CurChat["InitDialog"]
			then
				if Var["BossBattle"]["InitDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["InitDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["InitDialog"][ nCurDialogNo ]["Index"] )

					Var["BossBattle"]["InitDialogStepNo"] = Var["BossBattle"]["InitDialogStepNo"] + 1
					Var["BossBattle"]["InitDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["BossBattle"]["bInitDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["BossBattle"]["bInitDialogEnd"] = true
	end


	-- ��� �÷��̾ ���� ������ ����� �ʱ�ȭ �� ���
	if CurChat["ReInitDialog"] ~= nil
	then
		if Var["BossBattle"]["bReInitDialogEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["ReInitDialogStepNo"]

			if nCurDialogNo <= #CurChat["ReInitDialog"]
			then
				if Var["BossBattle"]["ReInitDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["ReInitDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["ReInitDialog"][ nCurDialogNo ]["Index"] )

					Var["BossBattle"]["ReInitDialogStepNo"] = Var["BossBattle"]["ReInitDialogStepNo"] + 1
					Var["BossBattle"]["ReInitDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["BossBattle"]["bReInitDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["BossBattle"]["bReInitDialogEnd"] = true
	end


	-- ������ �� ���� ���̾�α� ������ �� ���
	if CurChat["ShutDoorDialog"] ~= nil and CurChat["ShutDoorNotice"] ~= nil
	then
		if Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"]

			if nCurDialogNo <= #CurChat["ShutDoorDialog"]
			then
				if Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["ShutDoorDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["ShutDoorDialog"][ nCurDialogNo ]["Index"] )
					if Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] == 1
					then
						cNotice( Var["MapIndex"], ChatInfo["ScriptFileName"], CurChat["ShutDoorNotice"][ nCurDialogNo ]["Index"] )
					end

					Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] = Var["BossBattle"]["ShutDoorDialogAndNoticeStepNo"] + 1
					Var["BossBattle"]["ShutDoorDialogAndNoticeStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["BossBattle"]["bShutDoorDialogAndNoticeEnd"] = true
	end


	-- ���� Ŭ���� ������ �� ���
	if CurChat["ClearDialog"] ~= nil and CurChat["ClearNotice"] ~= nil
	then
		if Var["BossBattle"]["bClearDialogAndNoticeEnd"] == false
		then
			local nCurDialogNo = Var["BossBattle"]["ClearDialogAndNoticeStepNo"]

			if nCurDialogNo <= #CurChat["ClearDialog"]
			then
				if Var["BossBattle"]["ClearDialogAndNoticeStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], CurChat["ClearDialog"][ nCurDialogNo ]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurChat["ClearDialog"][ nCurDialogNo ]["Index"] )
					if nCurDialogNo == 1
					then
						cNotice( Var["MapIndex"], ChatInfo["ScriptFileName"], CurChat["ClearNotice"][ nCurDialogNo ]["Index"] )
					end

					Var["BossBattle"]["ClearDialogAndNoticeStepNo"] = Var["BossBattle"]["ClearDialogAndNoticeStepNo"] + 1
					Var["BossBattle"]["ClearDialogAndNoticeStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["BossBattle"]["bClearDialogAndNoticeEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["BossBattle"]["bClearDialogAndNoticeEnd"] = true
	end


	-- ���� �ܰ�� �Ѿ ����
	if Var["BossBattle"]["bClearDialogAndNoticeEnd"] == true
	then
		-- Quest Mob Kill ����.
		Var["BossBattle"] = nil
		DebugLog( "BossBattle::End" )
		cDoorAction( Var["Door"..(#StepNameTable - 2) ], RegenInfo["Stuff"]["Door"..(#StepNameTable - 2) ]["Block"], "open" )
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )
		GoToNextStep( Var )
	end

end


-- �������� ����
function IyzelReward( Var )
cExecCheck "IyzelReward"

	if Var == nil
	then
		return
	end


	local nBossType = Var["StageInfo"]["BossTypeNo"]

	if Var["IyzelReward"] == nil
	then
		DebugLog( "IyzelReward::Start" )

		Var["IyzelReward"] = {}

		-- ������ ��
		local IyzelRegenInfo = RegenInfo["NPC"]["IyzelReward"]["Iyzel"]
		local nIyzelHandle = cMobRegen_XY( Var["MapIndex"], IyzelRegenInfo["Index"], IyzelRegenInfo["x"], IyzelRegenInfo["y"], IyzelRegenInfo["dir"] )

		if nIyzelHandle ~= nil
		then
			Var["Enemy"][ nIyzelHandle ] = IyzelRegenInfo
			Var["IyzelHandle"] = nIyzelHandle

			-- ������ ���� ó��
			local AbstateInfo = NPC_Abstate["Immortal"]
			cSetAbstate( nIyzelHandle, AbstateInfo["Index"], AbstateInfo["Strength"], AbstateInfo["KeepTime"] )

		else
			ErrorLog( "IyzelReward::Iyzel Gen Failed" )
		end


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


		-- Ư���� ���� ���� ��
		local TreasureBoxRegenInfo = RegenInfo["Mob"]["IyzelReward"][ nBossType ]
		local nBoxHandle = cMobRegen_Circle( Var["MapIndex"], TreasureBoxRegenInfo["Index"], TreasureBoxRegenInfo["x"], TreasureBoxRegenInfo["y"], TreasureBoxRegenInfo["radius"] )

		if nBoxHandle ~= nil
		then
			Var["Enemy"][ nBoxHandle ] = TreasureBoxRegenInfo
			Var["RoutineTime"][ nBoxHandle ] = cCurrentSecond()

			if cSetAIScript( MainLuaScriptPath, nBoxHandle ) == nil
			then
				ErrorLog( "IyzelReward::Special Box cSetAIScript( ) Failed" )
			end

			if cAIScriptFunc( nBoxHandle, "Entrance", "TreasureBoxRoutine" ) == nil
			then
				ErrorLog( "IyzelReward::Special Box cAIScriptFunc( ) Failed - Entrance Mode" )
			end

			if cAIScriptFunc( nBoxHandle, "ObjectDied", "TreasureBoxOpened" ) == nil
			then
				ErrorLog( "IyzelReward::Special Box cAIScriptFunc( ) Failed - ObjectDied Mode" )
			end

		else
			ErrorLog( "IyzelReward::Special Box Gen Failed" )
		end


		-- ���� ���� �׷� ��
		local RewardBoxesRegenInfo = RegenInfo["Group"]["IyzelReward"][ nBossType ]
		for i = 1, #RewardBoxesRegenInfo
		do
			cGroupRegenInstance( Var["MapIndex"], RewardBoxesRegenInfo[ i ] )
		end


		-- ä�� �ܰ� ������ ���� ����
		Var["IyzelReward"]["AppearDialogStepSec"] = Var["CurSec"]
		Var["IyzelReward"]["AppearDialogStepNo"] = 1
		Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] = Var["CurSec"] + DelayTime["RewardBoxTryTime"]
		Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"] = 1

		Var["IyzelReward"]["bAppearDialogEnd"] = false
		Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = nil -- ���ѽð� ������ false�� �ٲ�� ����

		cTimer( Var["MapIndex"], DelayTime["RewardBoxTryTime"] )
	end


---------------------------------------------------------------------------------------------------------------------------------------------------
	-- �ܰ� ����
	if Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] <= Var["CurSec"]
	then
		Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = false

---[[
		-- �ڽ� �׾ ������ ����� ���
		local HandleList = { cNearObjectList( Var["IyzelHandle"], 500, ObjectType["Mob"] ) }
		for DummyIndex, nTargetHandle in pairs ( HandleList )
		do
			if nTargetHandle ~= Var["IyzelHandle"]
			then
				cMobSuicide( Var["MapIndex"], nTargetHandle )
			end
		end
--]]


--[[
		-- �ڽ� ������� ���
		for nIndex, sIndexName in pairs ( RewardBoxIndexes )
		do
			cVanishAll( Var["MapIndex"], sIndexName )
		end
--]]
	end


---------------------------------------------------------------------------------------------------------------------------------------------------
	-- ä��

	local CurChat = ChatInfo["IyzelReward"]["Boss"..nBossType ]
	local sIyzelIndex = ChatInfo["IyzelReward"]["SpeakerIndex"]

	-- �������� ��Ÿ���ڸ���
	if CurChat["IyzelAppearDialog"] ~= nil
	then
		if Var["IyzelReward"]["bAppearDialogEnd"] == false
		then
			local nCurDialogNo = Var["IyzelReward"]["AppearDialogStepNo"]

			if nCurDialogNo <= #CurChat["IyzelAppearDialog"]
			then
				if Var["IyzelReward"]["AppearDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], sIyzelIndex, ChatInfo["ScriptFileName"], CurChat["IyzelAppearDialog"][ nCurDialogNo ]["Index"] )

					Var["IyzelReward"]["AppearDialogStepNo"] = Var["IyzelReward"]["AppearDialogStepNo"] + 1
					Var["IyzelReward"]["AppearDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["IyzelReward"]["bAppearDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["IyzelReward"]["bAppearDialogEnd"] = true
	end


	-- ������� ���ѽð��� ������ ����
	if CurChat["OpenBoxTimeOverDialog"] ~= nil
	then
		if Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] == false
		then
			local nCurDialogNo = Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"]

			if nCurDialogNo <= #CurChat["OpenBoxTimeOverDialog"]
			then
				if Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] <= Var["CurSec"]
				then
					cMobDialog( Var["MapIndex"], sIyzelIndex, ChatInfo["ScriptFileName"], CurChat["OpenBoxTimeOverDialog"][ nCurDialogNo ]["Index"] )

					Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"] = Var["IyzelReward"]["OpenBoxTimeOverDialogStepNo"] + 1
					Var["IyzelReward"]["OpenBoxTimeOverDialogStepSec"] = Var["CurSec"] + DelayTime["GapDialog"]
				end

				-- �ش� ���̽��� Ÿ�̹��� �� ������ �ٸ���� ���� ���� ������ �ɱ�
				return
			else
				-- ���̽��� ����
				Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = true
			end
		end
	else
		-- ���̽��� ��ü�� ���� ��
		Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] = true
	end


	-- ��
	if Var["IyzelReward"]["bOpenBoxTimeOverDialogEnd"] == true
	then
		Var["IyzelReward"] = nil
		GoToNextStep( Var )
		DebugLog( "IyzelReward::End" )
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
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = EachFloor,    Name = "EachFloor",    },
	{ Function = BossBattle,   Name = "BossBattle",   },
	{ Function = IyzelReward,  Name = "IyzelReward",  },
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
