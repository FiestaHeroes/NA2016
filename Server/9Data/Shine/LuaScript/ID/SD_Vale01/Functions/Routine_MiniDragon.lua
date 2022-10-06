

--------------------------------------------------------------------------------
-- MiniDragon :: ������ ����
--------------------------------------------------------------------------------

function MD_ShowUp( Handle, MapIndex )
cExecCheck "MD_ShowUp"

	local Var = InstanceField[ MapIndex ]

	if Var["MiniDragonProcess"]["SkillEndTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	-- ��ų ó�� �ٳ�������,
	Var[Handle]["IsProgressSpecialSkill"] 		= false
	Var["MiniDragonProcess"]["SkillStartTime"]	= 0
	Var["MiniDragonProcess"]["SkillEndTime"]	= 0

	cAIScriptSet( Handle )
	return ReturnAI["END"]

end

--------------------------------------------------------------------------------
-- MiniDragon :: ���ɼ�ȯ
--------------------------------------------------------------------------------

function MD_SummonSoul( Handle, MapIndex )
cExecCheck "MD_SummonSoul"

	local Var = InstanceField[ MapIndex ]

	if Var["MiniDragonProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_MiniDragon["MD_SummonSoul"]

	--------------------------------------------------------------------------------
	-- �� MD_SummonSoul ó����, �ѹ��� ����� �ϴ� �κ�(�ʱ�ȭ)
	--------------------------------------------------------------------------------
	if Var["MD_SummonSoul"] == nil
	then

		Var["MD_SummonSoul"] = {}
		--DebugLog("KS_BombSlimePiece ���̺� ����")

		-- ���� ��ȯ�� ��ǥ�� x, y�� SummonRegenLocate ���̺� �����Ѵ�
		if Var["MD_SummonSoul"]["SummonRegenLocate"]  == nil
		then
			Var["MD_SummonSoul"]["SummonRegenLocate"] = {}

			local CurDragonX, CurDragonY = cObjectLocate( Handle )

			for i = 1, SkillInfo["SummonNum"]
			do
				Var["MD_SummonSoul"]["SummonRegenLocate"][i] 		= {}
				Var["MD_SummonSoul"]["SummonRegenLocate"][i]["x"],
				Var["MD_SummonSoul"]["SummonRegenLocate"][i]["y"] 	= cGetCoord_Circle( CurDragonX, CurDragonY, SkillInfo["SummonRadius"] )

				--[[
				-- ������, ���� ��ȯ�� ��ǥ ������ ���
				DebugLog("----["..i.."]----")
				DebugLog("SummonRegenLocate X :"..Var["MD_SummonSoul"]["SummonRegenLocate"][i]["x"])
				DebugLog("SummonRegenLocate Y :"..Var["MD_SummonSoul"]["SummonRegenLocate"][i]["y"])
				--]]
			end
		end

		-- ��ȯ�� �ð���, ��ȯ�� �� ���������� �ʱ�ȭ�Ѵ�
		if Var["MD_SummonSoul"]["SummonTime"] == nil
		then
			Var["MD_SummonSoul"]["SummonTime"] 			= Var["CurSec"]
			Var["MD_SummonSoul"]["CurSummonSequence"] 	= 1

			--DebugLog("SummonTime : "		..Var["CurSec"])
			--DebugLog("CurSummonSequence : "	..Var["MD_SummonSoul"]["CurSummonSequence"])
		end
	end


	--------------------------------------------------------------------------------
	-- �� Var["KS_BombSlimePiece"] ���̺� ������ �� ó���� �κ�
	--------------------------------------------------------------------------------
	if Var["MD_SummonSoul"] ~= nil
	then
		if Var["MD_SummonSoul"]["SummonTime"] ~= nil
		then

			if Var["MD_SummonSoul"]["SummonTime"] > Var["CurSec"]
			then
				return ReturnAI["END"]
			end

			if Var["MD_SummonSoul"]["CurSummonSequence"] <= SkillInfo["SummonNum"]
			then
				-- ��ȯ���� ������ ��ǥ�� �����ϴ� ����
				local CurSummonMob = Var["MD_SummonSoul"]["SummonRegenLocate"][Var["MD_SummonSoul"]["CurSummonSequence"]]

				-- ��ȯ���� �ε����� ��ȯ���� ����� ��ų�ε���. �������� ����� ��ų�ε����� ���� �ٸ���.
				local CurSummonMobIndex 		= nil
				local CurSummonSkillIndex 		= nil

				-- �̴ϵ巡���� SD_SpiritFire �� ��ȯ�ϴ� ��ų ����.
				if Var["MiniDragonProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Fire"]
				then
					--DebugLog("�̴ϵ巡�� ��ȯ��ų.."..SkillInfo["SkillIndex_Fire"] )
					CurSummonMobIndex 		= SkillInfo["SummonFire"]["SummonIndex"]
					CurSummonSkillIndex 	= SkillInfo["SummonFire"]["SummonSkillIndex"]

				-- �̴ϵ巡���� SD_SpiritIce �� ��ȯ�ϴ� ��ų ����.
				elseif Var["MiniDragonProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Ice"]
				then
					--DebugLog("�̴ϵ巡�� ��ȯ��ų.."..SkillInfo["SkillIndex_Ice"] )
					CurSummonMobIndex 		= SkillInfo["SummonIce"]["SummonIndex"]
					CurSummonSkillIndex 	= SkillInfo["SummonIce"]["SummonSkillIndex"]

				-- �̴ϵ巡���� �� �� ��ȯ�ϴ� ��ų ����.( ¦��/Ȧ�� ����� ��ȯ�� �������� )
				elseif Var["MiniDragonProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_All"]
				then
					--DebugLog("�̴ϵ巡�� ��ȯ��ų.."..SkillInfo["SkillIndex_All"] )

					if Var["MD_SummonSoul"]["CurSummonSequence"] % 2 == 0
					then
						CurSummonMobIndex 	= SkillInfo["SummonFire"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonFire"]["SummonSkillIndex"]

					elseif Var["MD_SummonSoul"]["CurSummonSequence"] % 2 == 1
					then
						CurSummonMobIndex 	= SkillInfo["SummonIce"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonIce"]["SummonSkillIndex"]
					end
				-- �̷� ���� ������.. ����� �׽�Ʈ�뵵..
				else
					ErrorLog("MD_SummonSoul ��ƾ, �˼����� ��ų �����..")
				end


				-- ��ȯ�� ���� �ڵ鰪�� ���´�.
				local CurSummonHandle = cMobRegen_XY( MapIndex, CurSummonMobIndex, CurSummonMob["x"], CurSummonMob["y"] )

				if CurSummonHandle == nil
				then
					-- DebugLog("�� ���� ����"..Var["MD_SummonSoul"]["CurSummonSequence"] )
					-- �������� ������ ��ǥ�� ���� ���, �������� ���������� ������ ����ó���� �����ʴ´�.
					-- �׳� ���� �� �����ϵ��� �Ѿ��.
				end

				if CurSummonHandle ~= nil
				then
					if cSkillBlast( CurSummonHandle, CurSummonHandle, CurSummonSkillIndex ) == nil
					then
						ErrorLog("�� ��ų������"..Var["MD_SummonSoul"]["CurSummonSequence"] )
					end
				end

				-- ���� �� ������ ���� ���� ����
				Var["MD_SummonSoul"]["CurSummonSequence"] 	= Var["MD_SummonSoul"]["CurSummonSequence"] + 1
				Var["MD_SummonSoul"]["SummonTime"]			= Var["MD_SummonSoul"]["SummonTime"] + SkillInfo["SummonTick"]

				--DebugLog("���� ������ �ð��� : "..Var["MD_SummonSoul"]["SummonTime"])

				return ReturnAI["END"]
			end

			-- �������̺� �� �������ϱ�, �ʱ�ȭ
			Var["MD_SummonSoul"]["SummonTime"] 			= nil
			Var["MD_SummonSoul"]["CurSummonSequence"] 	= nil

		end


		--------------------------------------------------------------------------------
		-- �� �� ��ȯ �۾��� �������Ƿ�, ��ų �����ص� �Ǵ� �ð����� üũ�Ѵ�
		--------------------------------------------------------------------------------
		-- ��ų ó���� �Ϸ�������, ���� ��ȯ�ִϸ��̼� ���̶�� ���
		if Var["MiniDragonProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			--DebugLog("�ִϸ��̼� ������ ��� �����..")
			return ReturnAI["END"]
		end

		if Var["MiniDragonProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("MD_SummonSoul ��� ��ųó���Ϸ�!")
			Var["MD_SummonSoul"]					= nil

			-- ��ų ó�� �ٳ�������,
			Var[Handle]["IsProgressSpecialSkill"] 			= false

			Var["MiniDragonProcess"]["SkillStartTime"]		= 0
			Var["MiniDragonProcess"]["SkillWorkTime"]		= 0
			Var["MiniDragonProcess"]["SkillEndTime"]		= 0

			Var["MiniDragonProcess"]["CurSkillIndex"]		= nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end

	return ReturnAI["END"]
end
