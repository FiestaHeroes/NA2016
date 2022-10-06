--------------------------------------------------------------------------------
--                          Emperor Slime Routine                             --
--------------------------------------------------------------------------------

function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	if MapIndex == nil
	then
		DebugLog( "PlayerMapLogin::MapIndex == nil")
		return
	end

	if Handle == nil
	then
		DebugLog( "PlayerMapLogin::Handle == nil")
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		DebugLog( "PlayerMapLogin::Var == nil")
		return
	end

	-- ù �÷��̾��� �� �α��� üũ
	Var["bPlayerMapLogin"] = true

	-- �ð� ������ ���� ���� ���� ��쿡�� �ƹ��͵� �������� �ʴ´�.
	if Var["KQLimitTime"] == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	-- ���� �ð� �������� ���ѽð��� �޾Ƽ� ��û�Ѵ�.
	local nLimitSec = Var["KQLimitTime"] - Var["CurSec"]

	cShowKQTimerWithLife_Obj( Handle, nLimitSec )

end

function KingSlimeRoutine( Handle, MapIndex )
cExecCheck "KingSlimeRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local RoutineTimeIndex = ""..Handle

	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end


	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["LowerFloor"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["LowerFloor"]["FloorNumber"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local CurFloorNo = Var["LowerFloor"]["FloorNumber"]

	if Var["LowerFloor"..CurFloorNo ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	-- ���
	if cIsObjectDead( Handle ) == 1
	then
		Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] = Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] - 1

		if Var["LowerFloor"..CurFloorNo ]["nKingSlimeCount"] > 0
		then
			cMobShout( Handle, KingSlimeChat["ScriptFileName"], KingSlimeChat["DeathDialogIndex"] )
		else
			cMobSuicide( MapIndex )
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

end


function EmperorSlimeRoutine( Handle, MapIndex )
cExecCheck "EmperorSlimeRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local RoutineTimeIndex = ""..Handle

	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end


	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["TopFloor"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ]["PhaseNumber"] == nil
	then
		Var["Enemy"][ Handle ]["PhaseNumber"] = 1
	end

	local CurPhaseNumber = Var["Enemy"][ Handle ]["PhaseNumber"]

	-- ���������� �װų� ����� ��� ���� ���� ����̹Ƿ� �ش� ����Ʈ ����
	if CurPhaseNumber == 5 or CurPhaseNumber == 3
	then
		if Var["QueenSlimeHandle"] ~= nil
		then
			for i = 1, #Var["QueenSlimeHandle"]
			do
				if cIsObjectDead( Var["QueenSlimeHandle"][ i ] ) == 1 or cIsObjectDead( Handle ) == 1
				then
					if Var["HealEffect"] ~= nil
					then
						if Var["HealEffect"][ i ]["Boss"] ~= nil
						then
							cNPCVanish( Var["HealEffect"][ i ]["Boss"] )
							DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Boss"] )
						end

						if Var["HealEffect"][ i ]["Queen"] ~= nil
						then
							cNPCVanish( Var["HealEffect"][ i ]["Queen"] )
							DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Queen"] )
						end

						Var["HealEffect"][ i ] = {}
					else
						ErrorLog( "Var[\"HealEffect\"] ~= nil" )
					end
				end
			end
		end
	end


	-- Emperor Slime ���
	if cIsObjectDead( Handle ) == 1
	then
		cMobDialog( MapIndex, EmperorSlimeChat["SpeakerIndex"], EmperorSlimeChat["ScriptFileName"], EmperorSlimeChat["DeathDialogIndex"] )
		cMobSuicide( MapIndex )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ]["PhaseNumber"] = nil
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	-- ������ ���ڸ� ���� ���� ��ų�� ���� ���
	if Var["TopFloor"]["bBossTurning"] == true
	then
		if Var["TopFloor"]["BossAnimationStopStepSec"] <= Var["CurSec"]
		then
			cAnimate( Handle, "stop" )
			Var["TopFloor"]["bBossTurning"] = false
		end
	end


	-- ������ ���� üũ �� �ൿ
	local CurHP, MaxHP	= cObjectHP( Handle )
	local RoutineStepFunc = DummyPhaseFunc

	if CurHP == MaxHP
	then
		-- ���� ���¿��� ��׷θ� ���� ����� ���ٸ� ���� ������ �ʱ�ȭ
		if cAggroListSize( Handle ) == 0
		then
			if CurPhaseNumber ~= 1
			then
				Var["Enemy"][ Handle ]["PhaseNumber"] = 1
				Var["TopFloor"]["bCurPhaseSummonEnd"] = false
				Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"]
				Var["TopFloor"]["QueenRevivalStepSec"] = nil

				cVanishAll( MapIndex, "Emp_Tornado" )
				cVanishAll( MapIndex, "Emp_Slime2" )
				cVanishAll( MapIndex, "Emp_FireSlime2" )
				cVanishAll( MapIndex, "Emp_IronSlime2" )
				cVanishAll( MapIndex, "Emp_QueenSlime2" )
			end
		end

		return ReturnAI["CPP"]
	end

	-- ������ ��ȣ�� ���� ������ ��ȣ�� ����ϱ� ���Ͽ� ������ ��ȣ üũ
	if CurPhaseNumber >= #BossPhaseNameTable
	then
		return ReturnAI["CPP"]
	end

	-- ����, ���� ������ ��ȣ�� ��ȿ �� ���
	local CurBossPhaseName	= BossPhaseNameTable[ CurPhaseNumber ]
	local NextBossPhaseName	= BossPhaseNameTable[ CurPhaseNumber + 1 ]
	local CurPhaseSkill		= EmperorSlimeSkill[ CurBossPhaseName ]
	local NextPhaseSkill	= EmperorSlimeSkill[ NextBossPhaseName ]
	local HP_RealRate		= ( CurHP * 1000 ) / MaxHP -- 1000����

	-- ���� ������ ���������� ���
	if HP_RealRate <= NextPhaseSkill["HP_Rate"]
	then
		-- ���� �� ������� �ٲ� ��, �������� ���� �׼� ����
		Var["Enemy"][ Handle ]["PhaseNumber"] = CurPhaseNumber + 1
		RoutineStepFunc	= PhaseActionFunc


		-- ��ȯ ȸ�� ���� �ʱ�ȭ
		Var["TopFloor"]["CurSummonCount"] = 1
		Var["TopFloor"]["bCurPhaseSummonEnd"] = false
		Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"]


		-- ��ȯ Ƚ���� �������� �ƴ� ��쿡 ���ؼ� ��ȯ Ƚ�� üũ
		if NextPhaseSkill["SummonCount"] ~= nil
		then
			if NextPhaseSkill["SummonCount"] <= Var["TopFloor"]["CurSummonCount"]
			then
				Var["TopFloor"]["bCurPhaseSummonEnd"] = true
			end
		end

		-- ��ȯ�� ��ȯ ������ �ð��� ��ȿ�� �ƴ� ��쿡 ���ؼ� �ð� ���� : ��ȿ�� ��� �ش� �������� ��ȯ�� �̹� ������ �����
		if NextPhaseSkill["SummonGapSec"] ~= nil
		then
			Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"] + NextPhaseSkill["SummonGapSec"]
		else
			Var["TopFloor"]["bCurPhaseSummonEnd"] = true
		end

	-- ���� ������ ���� ���� �ȵ� & ���� ������� ������ ���Ұų� ��� ���� ����
	else
		-- ���� ������� ��ȯ�� ��� �������� ���� ������ ���ǿ� ������ ������ ���
		if Var["TopFloor"]["bCurPhaseSummonEnd"] == true
		then
			return ReturnAI["CPP"]
		end

	-- ��ȯ�� ���۵Ǳ� ������ �ƹ��͵� ���� �ʴ´�.
		if CurPhaseNumber == 1
		then
			return ReturnAI["CPP"]
		end

		-- ��ȯ ������ �ð��� ��ȿ�� ��� �ѹ� ��ȯ�� ���� �� ��������� ��ȯ�� ���� ����
		if CurPhaseSkill["SummonGapSec"] == nil
		then
			-- Ȥ�� �� ���Ǳ��� ������ ��츦 ����Ͽ� ó���� �ѹ� �� ��
			Var["TopFloor"]["bCurPhaseSummonEnd"] = true

			return ReturnAI["CPP"]
		end

		-- �ð��� ���� ��ȯ Ÿ�̹�
		if Var["TopFloor"]["CurPhaseNextSummonStepSec"] <= Var["CurSec"]
		then

			local bSummonTiming = true

			-- ���̾� ������ ��ȯ �ÿ��� HP ������ �ѹ� �� üũ �Ѵ�.
			if CurPhaseNumber == 4
			then
				-- ������ �ǰ� ��ȯ �ܰ� ���� ���Ǻ��� �������� ��ȯ�� ��� ����.
				if HP_RealRate > CurPhaseSkill["HP_Rate"]
				then
					bSummonTiming = false
				end
			end

			if bSummonTiming == true
			then
				RoutineStepFunc	= PhaseActionFunc

				-- ��ȯ ȸ�� ����
				Var["TopFloor"]["CurSummonCount"] = Var["TopFloor"]["CurSummonCount"] + 1

				-- ��ȯ Ƚ���� �������� �ƴ� ��쿡 ���ؼ� ��ȯ Ƚ�� üũ
				if CurPhaseSkill["SummonCount"] ~= nil
				then
					if CurPhaseSkill["SummonCount"] <= Var["TopFloor"]["CurSummonCount"]
					then
						Var["TopFloor"]["bCurPhaseSummonEnd"] = true
					end
				end

				-- ���� ��ȯ �ð� ����
				Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"] + CurPhaseSkill["SummonGapSec"]

			else
				-- ��ȯ�� ��� �����ϸ鼭 �ǰ� �ٽ� ����ġ ���Ϸ� ���� �� �� �ٷ� ��ȯ�ϵ��� �ð� ����.
				Var["TopFloor"]["CurPhaseNextSummonStepSec"] = Var["CurSec"]

				return ReturnAI["CPP"]
			end

		end
	end

	RoutineStepFunc( Handle, MapIndex )

	return ReturnAI["CPP"]

end


function DummyPhaseFunc( )
cExecCheck "DummyPhaseFunc"

end


function PhaseActionFunc( BossHandle, MapIndex )
cExecCheck "PhaseActionFunc"

	if BossHandle == nil
	then
		return
	end

	if MapIndex == nil
	then
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		return
	end


	local PhaseNumber 	= Var["Enemy"][ BossHandle ]["PhaseNumber"]

	if PhaseNumber == 1
	then
		ErrorLog( "PhaseActionFunc::Normal-Phase does not have Phase-Action." )
		return
	elseif PhaseNumber < 1 and PhaseNumber > #BossPhaseNameTable
	then
		-- ������ ���̽�
		ErrorLog( "PhaseActionFunc::Invalid-Phase" )
		return
	end

	local BossPhase 	= BossPhaseNameTable[ PhaseNumber ]

	DebugLog( "Start PhaseActionFunc::"..BossPhase )


	if EmperorSlimeChat["SummonMobShout"][ BossPhase ] ~= nil
	then
		if Var["TopFloor"]["CurSummonCount"] == 1
		-- ������ ���� �ÿ��� ��ħ
		then
			cMobShout( BossHandle, EmperorSlimeChat["ScriptFileName"], EmperorSlimeChat["SummonMobShout"][ BossPhase ]["Index"] )
		end
	end


	local i = 1

	local SummonMobTableInfo = nil

	if EmperorSlimeSkill[ BossPhase ] ~= nil
	then
		SummonMobTableInfo = RegenInfo["Mob"]["TopFloor"][ EmperorSlimeSkill[ BossPhase ]["SummonMobsTableIndex"] ]

		-- ��ȯ�ϸ鼭 ������ ȸ���ϴ� �κ�
		if EmperorSlimeSkill[ BossPhase ]["bBossSpinning"] == true
		then
			cAnimate( BossHandle, "start", EmperorSlimeSkill["SummonEffect"]["EffectSkillIndex"] )
			Var["TopFloor"]["bBossTurning"] = true
			Var["TopFloor"]["BossAnimationStopStepSec"] = Var["CurSec"] + EmperorSlimeSkill["SummonEffect"]["AnimationKeepSec"] + 1 -- + 1 �� �ణ�� �ð����� ���� ����
		end

	else
		ErrorLog( "SummonMobInfo is not exist( BossPhase : ".. BossPhase.." )" )
	end

	if SummonMobTableInfo ~= nil
	then
		-- �� ������ ��ȯ ������ �ٸ�
		for k = 1, #SummonMobTableInfo
		do
			if SummonMobTableInfo[ k ] ~= nil
			then
				local SummonMobInfo = { Index = SummonMobTableInfo[ k ]["Index"], x = SummonMobTableInfo[ k ]["x"], y = SummonMobTableInfo[ k ]["y"], dir = 0, }

				-- ������ ������ġ�� ���� �����Ÿ� �̻� �������� ��� �ܸ��� ������ �߽����� ��ȯ
				local BossX, BossY = cObjectLocate( BossHandle )
				local OriginX = Var["Enemy"][ BossHandle ]["x"]
				local OriginY = Var["Enemy"][ BossHandle ]["y"]
				local LimitSquare = EmperorSlimeSkill["LimitDistanceFromOrigin"] * EmperorSlimeSkill["LimitDistanceFromOrigin"]

				-- �Ÿ� �ʰ���
				if cDistanceSquar( BossX, BossY, OriginX, OriginY ) > LimitSquare
				then
					SummonMobInfo["x"] = BossX
					SummonMobInfo["y"] = BossY
				end

				-- ����̵� ��ȯ
				if EmperorSlimeSkill[ BossPhase ]["bSummonAreaCenterTornado"] == true
				then
					local TornadoHandle = cMobRegen_XY( MapIndex, EmperorSlimeSkill["TornadoEffect"]["CenterMobIndex"], SummonMobInfo["x"], SummonMobInfo["y"], 0 )

					if TornadoHandle ~= nil
					then
						cSetAIScript ( MainLuaScriptPath, TornadoHandle )
						cAIScriptFunc( TornadoHandle, "Entrance", "SummonMobRoutine" )

						local TornadoInfo = { Index = EmperorSlimeSkill["TornadoEffect"]["CenterMobIndex"], x = SummonMobInfo["x"], y = SummonMobInfo["y"], dir = 0, }

						Var["Enemy"][ TornadoHandle ] = TornadoInfo
						if EmperorSlimeSkill["TornadoEffect"]["MobLifeSec"] ~= nil
						then
							Var["Enemy"][ TornadoHandle ]["DieStepSec"] = Var["CurSec"] + EmperorSlimeSkill["TornadoEffect"]["MobLifeSec"]
						end
					else
						ErrorLog( "Summon Tornado Fail"..TornadoInfo["Index"] )
					end
				end

				-- ���� ������ ������ ����ŭ �� ��ȯ
				if Var["KQ_Difficulty"] == nil
				then
					Var["KQ_Difficulty"] = 3
				end

				for nSummonCount = 1, SummonMobTableInfo[ k ]["count"..Var["KQ_Difficulty"] ]
				do
					local SummonMobHandle = nil

					-- ���������� ���� ������ ��ȯ
					if PhaseNumber == 5
					then
						SummonMobInfo["x"] = BossX
						SummonMobInfo["y"] = BossY
					end

					SummonMobHandle = cMobRegen_Circle( MapIndex, SummonMobInfo["Index"], SummonMobInfo["x"], SummonMobInfo["y"], SummonMobInfo["radius"] )

					if SummonMobHandle ~= nil
					then
						cSetAIScript ( MainLuaScriptPath, SummonMobHandle )
						cAIScriptFunc( SummonMobHandle, "Entrance", "SummonMobRoutine" )

						Var["Enemy"][ SummonMobHandle ] = SummonMobInfo
						if EmperorSlimeSkill[ BossPhase ]["MobLifeSec"] ~= nil
						then
							Var["Enemy"][ SummonMobHandle ]["DieStepSec"] = Var["CurSec"] + EmperorSlimeSkill[ BossPhase ]["MobLifeSec"]
						end

						if PhaseNumber == 5
						then
							if Var["QueenSlimeHandle"] == nil
							then
								Var["QueenSlimeHandle"] = {}
							end

							Var["QueenSlimeHandle"][ nSummonCount ] = SummonMobHandle
						end
					else
						ErrorLog( "Summon Mob Fail : "..SummonMobInfo["Index"] )
					end
				end
			end
		end
	end

	DebugLog( "End PhaseActionFunc::"..BossPhase )

end


function SummonMobRoutine( Handle, MapIndex )
cExecCheck "SummonMobRoutine"

	local Var = InstanceField[ MapIndex ]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- // 0.2�ʸ��� üũ�ϴ� ��ƾ
	local RoutineTimeIndex = ""..Handle

	if Var["RoutineTime"][ RoutineTimeIndex ] == nil
	then
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end

	if Var["RoutineTime"][ RoutineTimeIndex ] + 0.2 > cCurrentSecond()
	then
		return ReturnAI["CPP"]
	else
		Var["RoutineTime"][ RoutineTimeIndex ] = cCurrentSecond()
	end
	-- 0.2�ʸ��� üũ�ϴ� ��ƾ //


	if Var["Enemy"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	if Var["Enemy"][ Handle ] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	if Var["TopFloor"] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	-- ��ȯ�� �� �����
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end

	-- ���� �����
	if cIsObjectDead( Var["Enemy"]["BossHandle"] ) == 1
	then
		cMobSuicide( MapIndex, Handle )
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end


	local sSkillIndex = ""

	if 	Var["Enemy"][ Handle ]["Index"] == "Emp_Tornado"
	then
		sSkillIndex = "TornadoEffect"

	elseif 	Var["Enemy"][ Handle ]["Index"] == "Emp_Slime2"
	then
		sSkillIndex = "FirstSummon"
	elseif	Var["Enemy"][ Handle ]["Index"] == "Emp_FireSlime2"
	then
		sSkillIndex = "SecondSummon"
	elseif	Var["Enemy"][ Handle ]["Index"] == "Emp_IronSlime2"
	then
		sSkillIndex = "ThirdSummon"
	elseif	Var["Enemy"][ Handle ]["Index"] == "Emp_QueenSlime2"
	then
		sSkillIndex = "LastSummon"

		-- �� ������ �Ҹ� ����
		local CurHP, MaxHP	= cObjectHP( Var["Enemy"]["BossHandle"] )

		local HP_RealRate = 1000

		if MaxHP ~= 0
		then
			HP_RealRate	= ( CurHP * 1000 ) / MaxHP -- 1000����
		end

		if HP_RealRate >= EmperorSlimeSkill[ sSkillIndex ]["MobVanishCondBossHP_Rate"]
		then
			-- ���� �ǰ� ���� �̻� �Ѿ�� �������� �ڵ� �Ҹ� ( �ϳ��� �׾��� �� �ϴ� ó�� ������ �θ����� �ѹ��� ���ش�. )
			cVanishAll( MapIndex, Var["Enemy"][ Handle ]["Index"] )

			for i = 1, #Var["QueenSlimeHandle"]
			do
				local VanishHandle = Var["QueenSlimeHandle"][ i ]
				DebugLog( "VanishedByHP"..EmperorSlimeSkill[ sSkillIndex ]["MobVanishCondBossHP_Rate"].."More : "..sSkillIndex..", Handle("..VanishHandle..")" )
				cAIScriptSet( VanishHandle )
				Var["Enemy"][ VanishHandle ] = nil
				Var["RoutineTime"][ ""..VanishHandle ] = nil
			end

			-- ������ ������ �Ϻ� �ʱ�ȭ : ���� ���� ��� Ŭ���� �Ұ����ϰ� ����
			-- ������ ��ȯ����� ���̾���� ��ȯ ���ķ� �����Ѵ� ( ���� HP�� �����ϰ� ���� )
			Var["Enemy"][ Var["Enemy"]["BossHandle"] ]["PhaseNumber"] = 3
			Var["TopFloor"]["bCurPhaseSummonEnd"] = true

			return ReturnAI["END"]
		end

		-- �� �������� �� ���������� ����ִ� �� ������
		-- �Ѹ����� ������ 30�� �ȿ� �� �� �����ӵ� �׾�� ���������� �� ������ �ʴ´�.
		local QueenDeadCount = 0
		local CurQueenNo = 0
		local DeadQueenNo = 0

		for i = 1, #Var["QueenSlimeHandle"]
		do
			if cIsObjectDead( Var["QueenSlimeHandle"][ i ] ) == 1
			then
				-- ����� �� ������ ī���� �� ��ȣ ���
				QueenDeadCount = QueenDeadCount + 1
				DeadQueenNo = i
			else
				-- ���� ��ƾ�� �� ������ ��ȣ ���
				if Handle == Var["QueenSlimeHandle"][ i ]
				then
					CurQueenNo = i
				end
			end
		end

		-- �� ���üũ�� ����� �̷����� �ִ��� üũ�ϴ� �κ�(������ �α� �߻� ����� ���� ��κ��� ��� ��Ȱ��ȭ �ʿ�)
		--DebugLog( "AtThisRoutine, QueenDeathCount("..QueenDeadCount.."), CurQueenNo("..CurQueenNo.."), DeadQueenNo("..DeadQueenNo..")" )

		-- ���� ��ƾ�� �� �������� ������� �ʰų� ����� �������� �ƴϸ� �ڻ�ó��
		if CurQueenNo == 0
		then
			ErrorLog( "This QueenSlime was aleady died." )
			cMobSuicide( Handle )
			cAIScriptSet( Handle )
			Var["Enemy"][ Handle ] = nil
			Var["RoutineTime"][ RoutineTimeIndex ] = nil
			return ReturnAI["END"]
		end

		if QueenDeadCount == 1
		then
			if Var["TopFloor"]["QueenRevivalStepSec"] ~= nil
			then
				-- �������� �ϳ��� ���� �� �ٸ� �ϳ��� ������ä�� �����ð��� ������ ��Ȱ
				if Var["TopFloor"]["QueenRevivalStepSec"] <= Var["CurSec"]
				then
					DebugLog( "AtThisRoutine, YesQueenRevivalTiming" )
					local BossX, BossY = cObjectLocate( Var["Enemy"]["BossHandle"] )
					local QueenSlimeRegenInfo = RegenInfo["Mob"]["TopFloor"]["TwinQueenSlimes"][ 1 ]
					local QueenSlimeHandle = cMobRegen_Circle( MapIndex, QueenSlimeRegenInfo["Index"], BossX, BossY, QueenSlimeRegenInfo["radius"] )
					if QueenSlimeHandle ~= nil
					then
						DebugLog( "Revival : "..sSkillIndex..", Handle("..QueenSlimeHandle.."), No("..DeadQueenNo..")" )
--						cNoticeString( MapIndex, "Revival : "..sSkillIndex..", Handle("..QueenSlimeHandle.."), No("..DeadQueenNo..")" )
						Var["QueenSlimeHandle"][ DeadQueenNo ] = QueenSlimeHandle

						cSetAIScript ( MainLuaScriptPath, QueenSlimeHandle )
						cAIScriptFunc( QueenSlimeHandle, "Entrance", "SummonMobRoutine" )

						Var["Enemy"][ QueenSlimeHandle ] = { Index = Var["Enemy"][ Handle ]["Index"], x = Var["Enemy"][ Handle ]["x"], y = Var["Enemy"][ Handle ]["y"], dir = 0, }
					else
						ErrorLog( "Summon Queen Fail"..Var["Enemy"][ Handle ]["Index"] )
					end

					Var["TopFloor"]["QueenRevivalStepSec"] = nil
					QueenDeadCount = 0
				else
					-- �� ��Ȱ���� �󸶳� ���Ҵ��� ���
--					DebugLog( "Queen Revival Remain Sec : "..( Var["TopFloor"]["QueenRevivalStepSec"] - Var["CurSec"] ) )
				end
			end


			if QueenDeadCount == 1 and Var["TopFloor"]["QueenRevivalStepSec"] == nil
			then
				local RevivalInfo = QueenSlimeInfo["RevivalInfo"]
				if cGetAbstate( Handle, RevivalInfo["AbstateIndex"] ) == nil
				then
					DebugLog( "AtThisRoutine, NoQueenAbstate" )
					if cSetAbstate( Handle, RevivalInfo["AbstateIndex"], RevivalInfo["AbstateStrength"], RevivalInfo["AbstateKeepTime"] ) == nil
					then
						ErrorLog( "cSetAbstate To Queen : Failed" )
--						cNoticeString( MapIndex, "Queen("..Handle..") Abstate Fail" )
					else
--						cNoticeString( MapIndex, "Queen("..Handle..") Abstate Success" )
					end
					Var["TopFloor"]["QueenRevivalStepSec"] = Var["CurSec"] + RevivalInfo["RevivalSec"]
				else
	--				DebugLog( "AtThisRoutine, YesQueenAbstate" )
				end
			end

		else
			Var["TopFloor"]["QueenRevivalStepSec"] = nil
		end

		-- �� �������� ��
		if Var["Enemy"][ Handle ]["HealStepSec"] == nil
		then
			Var["Enemy"][ Handle ]["HealStepSec"] = Var["CurSec"]
		end

		if Var["Enemy"][ Handle ]["HealStepSec"] <= Var["CurSec"]
		then

			-- �� ����Ʈ �ڵ� ���� ���̺� �ʱ�ȭ
			if Var["HealEffect"] == nil
			then
				Var["HealEffect"] = {}

				for i = 1, #Var["QueenSlimeHandle"]
				do
					Var["HealEffect"][ i ] = {}
				end
			end

			-- �� ����Ʈ ���� Ȯ���ϰ� �ѹ� �� ó���ϱ�
			if Var["QueenSlimeHandle"] ~= nil
			then
				for i = 1, #Var["QueenSlimeHandle"]
				do
					if cIsObjectDead( Var["QueenSlimeHandle"][ i ] ) == 1
					then
						if Var["HealEffect"] ~= nil
						then

							if Var["HealEffect"][ i ]["Boss"] ~= nil
							then
								cNPCVanish( Var["HealEffect"][ i ]["Boss"] )
								DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Boss"] )
							end

							if Var["HealEffect"][ i ]["Queen"] ~= nil
							then
								cNPCVanish( Var["HealEffect"][ i ]["Queen"] )
								DebugLog( "Effect Vanished : "..Var["HealEffect"][ i ]["Queen"] )
							end

							Var["HealEffect"][ i ] = {}

						else
							ErrorLog( "Var[\"HealEffect\"] ~= nil" )
						end
					end
				end
			end

			-- ������
			if Var["KQ_Difficulty"] == nil
			then
				Var["KQ_Difficulty"] = 3
			end

			cHeal( Var["Enemy"]["BossHandle"], QueenSlimeInfo["HealInfo"]["HealAmount"..Var["KQ_Difficulty"] ] )

			local sHealEffectIndex = QueenSlimeInfo["HealInfo"]["HealEffectIndex"]

			-- ����Ʈ�� �������� ����Ʈ�� ����
			if Var["HealEffect"][ CurQueenNo ]["Queen"] == nil
			then
				-- ������Ʈ to ��
				local QueenHealEffectHandle = cEffectRegen_Object( MapIndex, sHealEffectIndex, Handle, 3600000, 1, 1000 )

				if QueenHealEffectHandle ~= nil
				then
					Var["HealEffect"][ CurQueenNo ]["Queen"] = QueenHealEffectHandle
				else
					ErrorLog( "QueenHealEffectHandle is nil" )
				end
			end

			-- ����Ʈ�� �������� ����Ʈ�� ����
			if Var["HealEffect"][ CurQueenNo ]["Boss"] == nil
			then
				-- ������Ʈ to ���۷�
				local BossHealEffectHandle = cEffectRegen_Object( MapIndex, sHealEffectIndex, Var["Enemy"]["BossHandle"], 3600000, 1, 1000 )

				if BossHealEffectHandle ~= nil
				then
					Var["HealEffect"][ CurQueenNo ]["Boss"] = BossHealEffectHandle
				else
					ErrorLog( "BossHealEffectHandle is nil" )
				end
			end


			-- ���� �� ���� ����
			Var["Enemy"][ Handle ]["HealStepSec"] = Var["CurSec"] + QueenSlimeInfo["HealInfo"]["HealGapSec"]

		end

	else
		-- �߸��� ���ε����̹Ƿ� ���� ���ְ� AI�� �����Ѵ�.
		ErrorLog( "MobIndex is invalid : "..Var["Enemy"][ Handle ]["Index"] )

		cNPCVanish( Handle )
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		Var["RoutineTime"][ RoutineTimeIndex ] = nil
		return ReturnAI["END"]
	end

	-- ������ ������ �ִ� ������ ��� üũ�Ͽ� ������ ���ϸ� �ڻ�ó��
	if EmperorSlimeSkill[ sSkillIndex ]["MobLifeSec"] ~= nil
	then
		if Var["Enemy"][ Handle ]["DieStepSec"] <= Var["CurSec"]
		then
			if sSkillIndex == "TornadoEffect"
			then
				-- ����̵��� �������� �ð��� ����� �̻��� ���Ÿ� ���� �Ҹ�ó���� �Ѵ�.
--				DebugLog( "Vanished : "..sSkillIndex..", Handle("..Handle..")" )
				cNPCVanish( Handle )
				cAIScriptSet( Handle )
				Var["Enemy"][ Handle ] = nil
				Var["RoutineTime"][ RoutineTimeIndex ] = nil
				return ReturnAI["END"]
			else
				-- �� ���� ���� ������ ���ϸ� �ڻ��Ѵ�.
--				DebugLog( "Suicided : "..sSkillIndex..", Handle("..Handle..")" )
				cMobSuicide( MapIndex, Handle )
				cAIScriptSet( Handle )
				Var["Enemy"][ Handle ] = nil
				Var["RoutineTime"][ RoutineTimeIndex ] = nil
				return ReturnAI["END"]
			end
		end
	end

	return ReturnAI["CPP"]

end

