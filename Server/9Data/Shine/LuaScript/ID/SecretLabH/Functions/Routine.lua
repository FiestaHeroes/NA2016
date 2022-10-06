--------------------------------------------------------------------------------
--                     Secret Laboratory Routine                              --
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

end


function ExitGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "ExitGateClick"

	DebugLog( "ExitGateClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "ExitGateClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "ExitGateClick::PlyHandle == nil" )
		return
	end


	cLinkTo( PlyHandle, LinkInfo["ReturnMapOnGateClick"]["MapIndex"], LinkInfo["ReturnMapOnGateClick"]["x"], LinkInfo["ReturnMapOnGateClick"]["y"] )

	DebugLog( "ExitGateClick::End" )
end


function PrisonClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "PrisonClick"

	DebugLog( "PrisonClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "PrisonClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "PrisonClick::PlyHandle == nil" )
		return
	end


	local MapIndex = cGetCurMapIndex( PlyHandle )

	if MapIndex == nil
	then
		ErrorLog( "PrisonClick::MapIndex == nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "PrisonClick::Var == nil" )
		return
	end

	if Var["Prison"] == nil
	then
		ErrorLog( "PrisonClick::Var[\"Prison\"] == nil" )
		return
	end

	if Var["Prison"]["RegenInfo"] == nil
	then
		ErrorLog( "PrisonClick::Var[\"Prison\"][\"RegenInfo\"] == nil" )
		return
	end


	-- �ش� ���谡 ���� ���� ������ ���� ���踦 ������� ��
	local nLotKey = cGetItemLot( PlyHandle, PrisonKeyIndex )
	if nLotKey > 0
	then
		if cInvenItemDestroy( PlyHandle, PrisonKeyIndex, nLotKey ) ~= 1
		then
			return
		end

		cDoorAction( NPCHandle, Var["Prison"]["RegenInfo"]["Block"], "open" )
		Var["Prison"]["bOpened"] = true
	end


	DebugLog( "PrisonClick::End" )
end


function SemiBossRoutine( Handle, MapIndex )
cExecCheck "SemiBossRoutine"

	if Handle == nil
	then
		ErrorLog( "SemiBossRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "SemiBossRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "SemiBossRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- SemiBoss ���
	if cIsObjectDead( Handle ) == 1
	then
		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	-- �Ʒ� ��Ʈ�� �� ���� �������� �����.

	if Var["EachFloor"] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	local CurStepNo = Var["EachFloor"]["StepNumber"]

	if Var["EachFloor"..CurStepNo ] == nil
	then
		ErrorLog( "SemiBossRoutine::Var[\"EachFloor\""..CurStepNo.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	local sAbstateIndex
	if Var["Enemy"][ Handle ]["Index"] == "Lab_Slime"
	then
		sAbstateIndex = SemiBossAbstate["TimeAttackMini"]["Index"]
	else
		sAbstateIndex = SemiBossAbstate["TimeAttack"]["Index"]
	end

	local AbstateStrength, AbstateRestTime = cGetAbstate( Handle, sAbstateIndex )
	if AbstateStrength == nil or AbstateStrength == 0 or AbstateRestTime == nil or AbstateRestTime == 0
	then
		-- �Ȱɷ��ִ� ���� : ��� ���� Ȥ�� ������ ����� ����
		if cIsObjectDead( Handle ) == nil
		then
			-- �� ��Ȳ���� ������ �ɷȴٴ� ���� ������ ����Ǿ��ٴ� ���
			local ImmortalStrength, ImmortalRestTime = cGetAbstate( Handle, SemiBossAbstate["Immortal"]["Index"] )
			if ImmortalStrength == 1
			then
				cMobSuicide( Var["MapIndex"], Handle )
				cAIScriptSet( Handle )
				Var["Enemy"][ Handle ] = nil
				return ReturnAI["END"]
			else
			-- ������ �Ȱɷȴٸ� ��� ���¸� �����.
				Var["EachFloor"..CurStepNo ]["bSemiBossAwakened"] = true

				--�Ѹ����� ����� Ư�� ������ ���� �� ����.
				Var["bSpecialRewardMode"] = false
			end
		end

		-- �߰� ��� ��� �����Ѵ�.( ������Ƿ�.. )
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
	elseif AbstateStrength == 2
	then
		-- �Ѵ� ���� ���� : �߰� ��� ��� �����Ѵ�.( ���� �ð��� �޶����� ���ʾȿ� �����ϹǷ�.. )
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
		Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
	end

	-- �����̻��� �ɷ��ִ� ���¿��� �ֺ������� �� ������ �� ���� �״´�.(������ƾ���� ���� �ڻ�ó����)
	if AbstateStrength == 1 or AbstateStrength == 2
	then
		-- �ٸ� ������ �� �Ǵ� �ð��� ��ٷȴٰ� üũ
		if Var["CurSec"] >= Var["EachFloor"..CurStepNo ]["WaitMobGenSec"]
		then
			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) == 1
			then
				cSetAbstate( Handle, SemiBossAbstate["Immortal"]["Index"], SemiBossAbstate["Immortal"]["Strength"], SemiBossAbstate["Immortal"]["KeepTime"] )
				cResetAbstate( Handle, sAbstateIndex )

				-- �߰� ��� ��� �����Ѵ�.( �������̹Ƿ�.. )
				Var["EachFloor"..CurStepNo ]["bSemiBossWarned60Sec"] = true
				Var["EachFloor"..CurStepNo ]["bSemiBossWarned30Sec"] = true
			end
		end
	end

	return ReturnAI["CPP"]
end


function MidBossRoutine( Handle, MapIndex )
cExecCheck "MidBossRoutine"

	if Handle == nil
	then
		ErrorLog( "MidBossRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "MidBossRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "MidBossRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "MidBossRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "MidBossRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- Mid Boss ���
	if cIsObjectDead( Handle ) == 1
	then
		-- �ܸ� ��� �ڻ�
		cMobSuicide( Var["MapIndex"] )

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "MidBossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end



-------------------------------------------------------------------------------------------------------
function BossDamaged( MapIndex, AttackerHandle, MaxHP, CurHP, DefenderHandle )
cExecCheck "BossDamaged"

	if DefenderHandle == nil
	then
		ErrorLog( "BossDamaged::DefenderHandle == nil" )
		return
	end

	if MapIndex == nil
	then
		ErrorLog( "BossDamaged::MapIndex == nil" )
		return
	end

	if MaxHP == nil or CurHP == nil
	then
		ErrorLog( "BossDamaged::HP Info is nil" )
		return
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "BossDamaged::Var == nil" )
		return
	end

	if Var["Enemy"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"Enemy\"] == nil" )
		return
	end

	if Var["Enemy"][ DefenderHandle ] == nil
	then
		ErrorLog( "BossDamaged::Var[\"Enemy\"]["..DefenderHandle.."] == nil" )
		return
	end

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["BossBattle"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"BossBattle\"] == nil" )
		return
	end


	-- �����߿� ���� ������ �����ϰ� �����ϱ� ����
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP

	local nBossType = Var["StageInfo"]["BossTypeNo"]

	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ������� ��ų��������� �ʱ�ȭ
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- ���� ��ų ������ ���� ���̺��� ������� ����
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end


		-- ��ų ������ ����
		local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1"
		local nCurPhase = Var["BossBattle"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sThresholdTableIndex ]

		if sSkillName ~= "PeriodicSummon"
		then
			if nCurPhase <= nMaxPhase
			then
				-- ���� HP�� ��ų�� Threshold �� ���Ͽ� ���������� �ұ� �����Ͽ� ����
				while ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
				do
					-- ������ ��ų�� ���̺� �� �ε��� �޾ƿ���
					local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"
					local sBossSkillTableIndex = sThresholdTableIndex -- �����ϰ� ������

					if BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ] ~= nil
					then
						-- ��ų�� ��ƾ���� �����ϵ��� ����
						if Var["BossBattle"][ sSkillName ][ nCurPhase ] == nil
						then
							Var["BossBattle"][ sSkillName ][ nCurPhase ] = {}
							Var["BossBattle"][ sSkillName ][ nCurPhase ]["bCasting"] = true
							Var["BossBattle"][ sSkillName ][ nCurPhase ]["sSkillTableIndex"] = sCurSkillIndex
							DebugLog( "BossDamaged::SetSkillCasting-"..sSkillName.." "..sCurSkillIndex.." "..nCurPhase )
						end
					end

					nCurPhase = nCurPhase + 1
					if nCurPhase > nMaxPhase
					then
						break
					end

				end -- ��ų�� �����϶�� ������� �������ִ� ����

				-- �޸��� ��ų ������ ���� �� ����
				Var["BossBattle"][ sSkillName.."PhaseNo"] = nCurPhase

			end -- �� ��ų�� ������ �ʰ��ߴ��� Ȯ�����ִ� ���ǹ� //

		end -- �ֱ����� ��ų üũ�� ��ƾ���� �� //

	end -- ��ų���� �ѹ��� Ž���ϴ� ���� //

end


function BossRoutine( Handle, MapIndex )
cExecCheck "BossRoutine"

	if Handle == nil
	then
		ErrorLog( "BossRoutine::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "BossRoutine::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "BossRoutine::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	if Var["Enemy"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"Enemy\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Enemy"][ Handle ] == nil
	then
		ErrorLog( "BossRoutine::Var[\"Enemy\"]["..Handle.."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["StageInfo"]["BossTypeNo"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"StageInfo\"][\"BossTypeNo\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	if Var["BossBattle"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"BossBattle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	if Var["EachFloor"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	if Var["EachFloor"..Var["EachFloor"]["StepNumber"] ] == nil
	then
		ErrorLog( "BossRoutine::Var[ EachFloor"..Var["EachFloor"]["StepNumber"].."] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	-- Boss ���
	if cIsObjectDead( Handle ) ~= nil
	then
		DebugLog( "BossRoutine::BossDead" )
		cMobSuicide( Var["MapIndex"] )

		-- ��ų���� �޸� �ʱ�ȭ
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			Var["BossBattle"][ sSkillName ] = nil
			Var["BossBattle"][ sSkillName.."PhaseNo"] = nil
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end

	local CurStepNo = Var["EachFloor"]["StepNumber"]
	local nBossType = Var["StageInfo"]["BossTypeNo"]

--///////---------------------- �ֱ��� ������ �����ϱ� ���� ��ƾ �� üũ ------------------------------------

	-- �����߿� ���� ������ �����ϰ� �����ϱ� ����
	if Var["BossBattle"]["Casting"] == nil
	then
		Var["BossBattle"]["Casting"] = {}
	end

	local CurHP, MaxHP = cObjectHP( Handle )

	-- HP �ҷ����� ���н� Full�� ����
	local HP_Rate = 1000
	if CurHP ~= nil
	then
		if MaxHP > 0
		then
			HP_Rate = ( CurHP * 1000 ) / MaxHP
		end
	end

	if #BossSkillNameTable >= 2
	then
		-- �ֱ��� ��ȯ ��ų�� Ž��
		local sSkillName = BossSkillNameTable[2]	-- ex) sSkillName = "PeriodicSummon"

		-- ������� ��ų��������� �ʱ�ȭ
		if Var["BossBattle"][ sSkillName.."PhaseNo"] == nil
		then
			Var["BossBattle"][ sSkillName.."PhaseNo"] = 1
		end

		-- ���� ��ų ������ ���� ���̺��� ������� ����
		if Var["BossBattle"][ sSkillName ] == nil
		then
			Var["BossBattle"][ sSkillName ] = {}
		end


		-- ��ų ������ ����
		local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "PeriodicSummonHP_Boss1"

		-- �� �ֱ����� ��ų�� ��Ģ�� ������ ����
		-- HP�� ���� ������ �� �ߵ�
		-- ���̾� ��ų�� HP �� ���� �ߵ��� �ȴٸ� �Ѱ����� �ߵ�
		-- HP�� �ش� ��ų�� �ߵ��Ǵ� ������ ����� ������ �� ��ų�� �ʱ�ȭ
		-- �ʱ�ȭ �� ���´� ó���� ���Ƽ� �ٽ� HP�� ��ų�ߵ��� �ش�Ǵ� ��Ȳ�̸� �״�� �ߵ�
		--
		for nCurPhase = 1, #ThresholdTable[ sThresholdTableIndex ]
		do
			-- ��ų ���� �� ������ ���̺�
			if Var["BossBattle"][ sSkillName ][ nCurPhase ] == nil
			then
				Var["BossBattle"][ sSkillName ][ nCurPhase ] = {}
			end

			local CurPhaseCastingInfo = Var["BossBattle"][ sSkillName ][ nCurPhase ]

			-- ���� HP�� ��ų�� Threshold �� ���Ͽ� �ش�Ǵ� �κ� ���� ��û

			local bCastCurPhaseSkill = false

			-- HP ���� üũ
			if ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
			then
				if ThresholdTable[ sThresholdTableIndex ][ nCurPhase + 1 ] ~= nil
				then
					if ThresholdTable[ sThresholdTableIndex ][ nCurPhase + 1 ] < HP_Rate
					then
						bCastCurPhaseSkill = true
					else
						-- HP ������ �ش� ����� ����� ���� �ֱ�� �ʱ�ȭ �ȴ�.
						CurPhaseCastingInfo["dLastCastedTime"] = 0

						-- ��ȯ ���� ���̽����� ���� ��Ȳ�� ��쿡�� �ʱ�ȭ����
						if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] == true
						then
							Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = nil
							Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] = nil
						end
					end
				else
					bCastCurPhaseSkill = true
				end
			else
				-- HP ������ �ش� ����� ����� ���� �ֱ�� �ʱ�ȭ �ȴ�.
				CurPhaseCastingInfo["dLastCastedTime"] = 0

				-- ��ȯ ���� ���̽����� ���� ��Ȳ�� ��쿡�� �ʱ�ȭ����
				if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] == true
				then
					Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = nil
					Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] = nil
				end
			end

			-- ������ ��ų�� ���̺� �� �ε��� �޾ƿ���
			local sBossSkillTableIndex = sThresholdTableIndex -- �����ϰ� ������ ex ) "SummonHP_Boss1"
			local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"


			-- HP ���� üũ ��� ��ų�� �� Ÿ�̹��� ���
			if bCastCurPhaseSkill == true
			then

				if CurPhaseCastingInfo["dLastCastedTime"] == nil
				then
					CurPhaseCastingInfo["dLastCastedTime"] = 0
				end

				if BossSkill[ sBossSkillTableIndex ] ~= nil
				then
					local CurBossSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ]

					if CurPhaseCastingInfo["nSummonCount"] == nil
					then
						CurPhaseCastingInfo["nSummonCount"] = 0
					end

					if CurBossSkillInfo ~= nil and CurBossSkillInfo["SummonMobs"] ~= nil
					then
						for nCurSubPhase = 1, #CurBossSkillInfo["SummonMobs"]
						do
							if CurBossSkillInfo["SummonMobs"][ nCurSubPhase ] ~= nil
							then
								local CurSubPhaseInfo = CurBossSkillInfo["SummonMobs"][ nCurSubPhase ]

								-- �� ��ȯ Ƚ���� 0���� �����Ǿ������� ������ ��ȯ / 0�� �ƴ϶�� �ش� Ƚ����ŭ ��ȯ
								if CurPhaseCastingInfo["nSummonCount"] < CurSubPhaseInfo["SummonCount"] or CurSubPhaseInfo["SummonCount"] == 0
								then
									if Var["CurSec"] >= CurPhaseCastingInfo["dLastCastedTime"] + CurSubPhaseInfo["Interval"]
									then
										if CurPhaseCastingInfo["bCasting"] ~= true
										then
											-- ��ų�� ��ƾ���� �����ϵ��� ����
											CurPhaseCastingInfo["bCasting"] = true
											CurPhaseCastingInfo["sSkillTableIndex"] = sCurSkillIndex
											DebugLog( "BossRoutine::SetSkillCasting-"..sSkillName.." "..sCurSkillIndex.." "..nCurPhase )
										end
									end
								end
							end
						end
					else
						ErrorLog( "BossRoutine::CurBossSkillInfo does not exist.")
					end
				else
					ErrorLog( "BossRoutine::BossSkillInfo does not exist.")
				end

			end

		end

	end

---------------------- �ֱ��� ������ �����ϱ� ���� ��ƾ �� üũ ------------------------------------/////


-------------�����ܰ�---------------------------------------------------------

	-- ���� ��ȯ��ų ���� ���̽����� �ȳ����ٸ� ���������� ��ٸ���.
	if Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] ~= false -- true or nil �϶� ����
	then
		-- ��ų���� �ѹ� �� Ž��
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			-- ��ų ������ ����
			local sThresholdTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "PeriodicSummonHP_Boss1"

			-- ���� ��ų ������ �ش� ��ų �������̺��� ���ٸ� ���� ������ �ȵ� ���̹Ƿ� �н�
			if Var["BossBattle"][ sSkillName.."PhaseNo"] ~= nil and Var["BossBattle"][ sSkillName ] ~= nil
			then
				-- �������ε� ��ų�鸸 ������� �����ؾ���.
				for nCurPhase = 1, #Var["BossBattle"][ sSkillName ]
				do
					-- ����üũ
					if Var["BossBattle"][ sSkillName ][ nCurPhase ] == nil
					then
						break
					end

					local CurPhaseCastingInfo = Var["BossBattle"][ sSkillName ][ nCurPhase ]

					-- �غ�� ��ų ����
					if CurPhaseCastingInfo["bCasting"] == true
					then
						local sCurSkillTableIndex = CurPhaseCastingInfo["sSkillTableIndex"] -- ex) "HP800"

						local sBossSkillTableIndex = sSkillName.."HP_Boss"..nBossType -- ex ) "SummonHP_Boss1"
						local CurSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillTableIndex ]

						-- �ܸ� ��ȯ
						if sSkillName == "Summon"
						then
							DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..nCurPhase )

							for nCurSubPhase = 1, #CurSkillInfo["SummonMobs"]
							do
								for k = 1, CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Count"]
								do
									cMobRegen_Obj( CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"], Handle )
									DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..k.."/"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Count"]..") :"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"] )
								end
							end

						elseif sSkillName == "PeriodicSummon"
						then
							DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..nCurPhase )

							for nCurSubPhase = 1, #CurSkillInfo["SummonMobs"]
							do
								for k = 1, CurSkillInfo["SummonMobs"][ nCurSubPhase ]["CountPerSummon"]
								do
									cMobRegen_Obj( CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"], Handle )
									DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..k.."/"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["CountPerSummon"]..") :"..CurSkillInfo["SummonMobs"][ nCurSubPhase ]["Index"] )
								end
							end

							if CurPhaseCastingInfo["nSummonCount"] == nil
							then
								CurPhaseCastingInfo["nSummonCount"] = 0
							end

							-- �ش� ȸ�� ���� �Ϸ� ó��
							CurPhaseCastingInfo["dLastCastedTime"] = Var["CurSec"]
							CurPhaseCastingInfo["nSummonCount"] = CurPhaseCastingInfo["nSummonCount"] + 1

						else
							ErrorLog( "BossRoutine::This name of skill("..sSkillName..") is invalid." )
						end -- ��ų �̸� ���� ���ǹ� //


						-- ���� �Ϸ� ó��
						CurPhaseCastingInfo["bCasting"] = false
						DebugLog( "BossRoutine::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..nCurPhase )

						-- ���̽��� ����
						Var["EachFloor"..CurStepNo ]["bBossSummonDialogEnd"] = false
						Var["EachFloor"..CurStepNo ]["nHP_BossSummonDialog"] = ThresholdTable[ sThresholdTableIndex ][ nCurPhase ]

					end -- ��ų ������ �غ� �Ǿ����� Ȯ���ϴ� ���ǹ� //

				end -- �� ��ų�� ���� ������ ���� ���� //

			end -- ��ų ���� ��ü�� �ߴ°� Ȯ���ϴ� ���ǹ� //

		end -- �� ��ų�� �ѹ��� Ž���ϴ� ���� //

	end -- ��ȯ��ų ��� ���� ���̽����� ���������� Ȯ���ϴ� ���ǹ� //

	return ReturnAI["CPP"]

end
