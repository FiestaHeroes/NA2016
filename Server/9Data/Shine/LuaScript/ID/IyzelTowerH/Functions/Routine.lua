--------------------------------------------------------------------------------
--                        Tower Of Iyzel Routine                              --
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

	if Var["EachFloor"] == nil
	then
		ErrorLog( "BossDamaged::Var[\"EachFloor\"] == nil" )
		return
	end


	-- �����߿� ���� ������ �����ϰ� �����ϱ� ����
	if Var["EachFloor"]["Casting"] == nil
	then
		Var["EachFloor"]["Casting"] = {}
	end


	local HP_Rate = ( CurHP * 1000 ) / MaxHP


	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ������� ��ų��������� �ʱ�ȭ
		if Var["EachFloor"][ sSkillName.."PhaseNo"] == nil
		then
			Var["EachFloor"][ sSkillName.."PhaseNo"] = 1
		end

		-- ���� ��ų ������ ���� ���̺��� ������� ����
		if Var["EachFloor"][ sSkillName ] == nil
		then
			Var["EachFloor"][ sSkillName ] = {}
		end


		-- �ܰ��̸� �޾ƿ���
		local CurFloorNo = Var["EachFloor"]["StepNumber"]
		local CurFloor = StepNameTable[ CurFloorNo ]

		-- ��ų ������ ����
		local sThresholdTableIndex = sSkillName.."HP_"..CurFloor -- ex ) "SummonHP_Floor04
		local nCurPhase = Var["EachFloor"][ sSkillName.."PhaseNo"]
		local nMaxPhase = #ThresholdTable[ sThresholdTableIndex ]

		if nCurPhase <= nMaxPhase
		then
			-- ���� HP�� ��ų�� Threshold �� ���Ͽ� ���������� �ұ� �����Ͽ� ����
			while ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] >= HP_Rate
			do
				-- ������ ��ų�� ���̺� �� �ε��� �޾ƿ���
				local sCurSkillIndex = "HP"..ThresholdTable[ sThresholdTableIndex ][ nCurPhase ] -- ex) "HP800"
				local sBossSkillTableIndex = sSkillName.."_"..CurFloor -- ex) "Summon_Floor04"

				if BossSkill[ sBossSkillTableIndex ][ sCurSkillIndex ] ~= nil
				then
					-- ��ų�� ��ƾ���� �����ϵ��� ����
					if Var["EachFloor"][ sSkillName ][ nCurPhase ] == nil
					then
						Var["EachFloor"][ sSkillName ][ nCurPhase ] = {}
						Var["EachFloor"][ sSkillName ][ nCurPhase ]["bCasting"] = true
						Var["EachFloor"][ sSkillName ][ nCurPhase ]["sSkillTableIndex"] = sCurSkillIndex
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
			Var["EachFloor"][ sSkillName.."PhaseNo"] = nCurPhase

		end -- �� ��ų�� ������ �ʰ��ߴ��� Ȯ�����ִ� ���ǹ� //

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


	-- Boss ���
	if cIsObjectDead( Handle ) == 1
	then
		DebugLog( "BossRoutine::BossDead" )
		cMobSuicide( Var["MapIndex"] )

		-- ��ų���� �޸� �ʱ�ȭ
		for nIndex, sSkillName in pairs ( BossSkillNameTable )
		do
			Var["EachFloor"][ sSkillName ] = nil
			Var["EachFloor"][ sSkillName.."PhaseNo"] = nil
		end

		cAIScriptSet( Handle )
		Var["Enemy"][ Handle ] = nil
		return ReturnAI["END"]
	end


	if Var["EachFloor"] == nil
	then
		ErrorLog( "BossRoutine::Var[\"EachFloor\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- MobDamaged ��ƾ ���
	cAIScriptFunc( Handle, "MobDamaged", "BossDamaged" )


	-- ��ų���� �ѹ� �� Ž��
	for nIndex, sSkillName in pairs ( BossSkillNameTable )
	do
		-- ���� ��ų ������ �ش� ��ų �������̺��� ���ٸ� ���� ������ �ȵ� ���̹Ƿ� �н�
		if Var["EachFloor"][ sSkillName.."PhaseNo"] ~= nil and Var["EachFloor"][ sSkillName ] ~= nil
		then
			-- �������ε� ��ų�鸸 ������� �����ؾ���.
			for i = 1, #Var["EachFloor"][ sSkillName ]
			do
				-- ����üũ
				if Var["EachFloor"][ sSkillName ][ i ] == nil
				then
					break
				end

				-- �غ�� ��ų ����
				if Var["EachFloor"][ sSkillName ][ i ]["bCasting"] == true
				then
					local sCurSkillTableIndex = Var["EachFloor"][ sSkillName ][ i ]["sSkillTableIndex"] -- ex) "HP800"

					-- �ܰ��̸� �޾ƿ���
					local CurFloorNo = Var["EachFloor"]["StepNumber"]
					local CurFloor = StepNameTable[ CurFloorNo ]

					-- ��ų ���̺� �ε��� ����
					local sBossSkillTableIndex = sSkillName.."_"..CurFloor -- ex) "Summon_Floor04"

					-- ��ų ���� ��������
					local CurSkillInfo = BossSkill[ sBossSkillTableIndex ][ sCurSkillTableIndex ]

					-- �ܸ� ��ȯ
					if sSkillName == "Summon"
					then
						DebugLog( "BossRoutine::StartSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

						for i = 1, #CurSkillInfo["SummonMobs"]
						do
							cMobRegen_Obj( CurSkillInfo["SummonMobs"][ i ], Handle )
							DebugLog( "BossRoutine::CastSkill-"..sSkillName.." "..sCurSkillTableIndex.." ("..i.."/"..#CurSkillInfo["SummonMobs"]..") :"..CurSkillInfo["SummonMobs"][ i ] )
						end

						-- ����� ������ ��ȯ ��ų�� ������ִ� ���̽���
						if NPC_GuardChat["BossBattleDialog"][ CurFloor ] ~= nil
						then
							cMobDialog( Var["MapIndex"], NPC_GuardChat["SpeakerIndex"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["BossBattleDialog"][ CurFloor ][ i ]["Index"] )
						else
							ErrorLog( "BossRoutine::There is no face-cut at This Floor" )
						end
						-- ���� �Ϸ� ó��
						Var["EachFloor"][ sSkillName ][ i ]["bCasting"] = false
						DebugLog( "BossRoutine::EndSkillCasting-"..sSkillName.." "..sCurSkillTableIndex.." "..i )

					end -- ��ų �̸� ���� ���ǹ� //

				end -- ��ų ������ �غ� �Ǿ����� Ȯ���ϴ� ���ǹ� //

			end -- �� ��ų�� ���� ������ ���� ���� //

		end -- ��ų ���� ��ü�� �ߴ°� Ȯ���ϴ� ���ǹ� //

	end -- �� ��ų�� �ѹ��� Ž���ϴ� ���� //

	return ReturnAI["CPP"]

end
