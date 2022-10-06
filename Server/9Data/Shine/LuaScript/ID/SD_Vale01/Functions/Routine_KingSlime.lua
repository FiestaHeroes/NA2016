
--------------------------------------------------------------------------------
-- KingSlime :: ���ʳ���( ���� �� ��ų )
--------------------------------------------------------------------------------

function KS_ShowUp( Handle, MapIndex )
cExecCheck "KS_ShowUp"

	local Var = InstanceField[ MapIndex ]

	if Var["KingSlimeProcess"]["SkillEndTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	-- ��ų ó�� �ٳ�������,
	Var[Handle]["IsProgressSpecialSkill"] 		= false
	Var["KingSlimeProcess"]["SkillStartTime"]	= 0
	Var["KingSlimeProcess"]["SkillEndTime"]		= 0

	cAIScriptSet( Handle )
	return ReturnAI["END"]
end


--------------------------------------------------------------------------------
-- KingSlime :: ����
--------------------------------------------------------------------------------
function KS_Warp( Handle, MapIndex )
cExecCheck "KS_Warp"

	local Var = InstanceField[ MapIndex ]

	if Var["KingSlimeProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo 	= SkillInfo_KingSlime["KS_Warp"]
	local AbStateList 	= SkillInfo["AbState_To_KingSlime"]
	--------------------------------------------------------------------------------
	-- �� KS_Warp ó����, �ѹ��� ����� �ϴ� �κ�(�ʱ�ȭ)
	--------------------------------------------------------------------------------
	if Var["KS_Warp"] == nil
	then
		DebugLog("KS_Warp ���̺� ����")
		Var["KS_Warp"] = {}

		-- ŷ�����ӿ� �����̻� �ɾ��ش�
		cSetAbstate( Handle, AbStateList["NotTargetted"]["Index"], 	AbStateList["NotTargetted"]["Strength"], 	AbStateList["NotTargetted"]["KeepTime"], 	Handle )

		-- �̸� ���� Ÿ�����ϰ��ִ� �÷��̾���� Ÿ���� ����
		local PlayerHandleList = { cGetPlayerList( Var["MapIndex"] ) }
		-- DebugLog( "�ʿ� �ִ� ������ �� : "..#PlayerHandleList )
		for i = 1, #PlayerHandleList
		do
			cTargetChangeNull( PlayerHandleList[i], Handle )
		end
	end

	--------------------------------------------------------------------------------
	-- �� Var["KS_Warp"] ���̺� ������ �� ó���� �κ�
	--------------------------------------------------------------------------------
	if Var["KS_Warp"] ~= nil
	then
		if Var["KingSlimeProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			return ReturnAI["END"]
		end

		if Var["KingSlimeProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			DebugLog("KS_Warp ��� ��ųó���Ϸ�!")
			--�����̻� ����
			cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

			Var["KS_Warp"]								= nil

			-- ��ų ó�� �ٳ�������,
			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingSlimeProcess"]["SkillStartTime"]	= 0
			Var["KingSlimeProcess"]["SkillWorkTime"]	= 0
			Var["KingSlimeProcess"]["SkillEndTime"]		= 0

			Var["KingSlimeProcess"]["CurSkillIndex"]	= nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end
end






--------------------------------------------------------------------------------
-- KingSlime :: ����( �� ��ȯ )
--------------------------------------------------------------------------------

function KS_BombSlimePiece( Handle, MapIndex )
cExecCheck "KS_BombSlimePiece"

	local Var = InstanceField[ MapIndex ]

	if Var["KingSlimeProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_KingSlime["KS_BombSlimePiece"]

	--------------------------------------------------------------------------------
	-- �� KS_BombSlimePiece ó����, �ѹ��� ����� �ϴ� �κ�(�ʱ�ȭ)
	--------------------------------------------------------------------------------
	if Var["KS_BombSlimePiece"] == nil
	then
		Var["KS_BombSlimePiece"] = {}
		--DebugLog("KS_BombSlimePiece ���̺� ����")

		-- ���� ��ȯ�� ��ǥ�� x, y�� SummonRegenLocate ���̺� �����Ѵ�
		if Var["KS_BombSlimePiece"]["SummonRegenLocate"]  == nil
		then
			Var["KS_BombSlimePiece"]["SummonRegenLocate"] = {}

			local CurKingSlimeX, CurKingSlimeY = cObjectLocate( Handle )

			for i = 1, SkillInfo["SummonNum"]
			do
				Var["KS_BombSlimePiece"]["SummonRegenLocate"][i] 		= {}
				Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["x"],
				Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["y"] = cGetCoord_Circle( CurKingSlimeX, CurKingSlimeY, SkillInfo["SummonRadius"] )

				--[[
				-- ������, ���� ��ȯ�� ��ǥ ������ ���
				DebugLog("----["..i.."]----")
				DebugLog("SummonRegenLocate X :"..Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["x"])
				DebugLog("SummonRegenLocate Y :"..Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["y"])
				--]]
			end
		end

		-- ��ȯ�� �ð���, ��ȯ�� �� ���������� �ʱ�ȭ�Ѵ�
		if Var["KS_BombSlimePiece"]["SummonTime"] == nil
		then
			Var["KS_BombSlimePiece"]["SummonTime"] 			= Var["CurSec"]
			Var["KS_BombSlimePiece"]["CurSummonSequence"] 	= 1

			--DebugLog("SummonTime : "		..Var["CurSec"])
			--DebugLog("CurSummonSequence : "	..Var["KS_BombSlimePiece"]["CurSummonSequence"])
		end
	end


	--------------------------------------------------------------------------------
	-- �� Var["KS_BombSlimePiece"] ���̺� ������ �� ó���� �κ�
	--------------------------------------------------------------------------------
	if Var["KS_BombSlimePiece"] ~= nil
	then
		if Var["KS_BombSlimePiece"]["SummonTime"] ~= nil
		then

			if Var["KS_BombSlimePiece"]["SummonTime"] > Var["CurSec"]
			then
				return ReturnAI["END"]
			end

			if Var["KS_BombSlimePiece"]["CurSummonSequence"] <= SkillInfo["SummonNum"]
			then
				-- ��ȯ���� ������ ��ǥ�� �����ϴ� ����
				local CurSummonMob = Var["KS_BombSlimePiece"]["SummonRegenLocate"][Var["KS_BombSlimePiece"]["CurSummonSequence"]]

				-- ��ȯ���� �ε����� ��ȯ���� ����� ��ų�ε���. �������� ����� ��ų�ε����� ���� �ٸ���.
				local CurSummonMobIndex = nil
				local CurSummonSkillIndex = nil

				-- ŷ�������� SD_SlimeLump �� ��ȯ�ϴ� ��ų ����.
				if Var["KingSlimeProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Lump"]
				then
					--DebugLog("ŷ������ ��ȯ��ų.."..SkillInfo["SkillIndex_Lump"] )
					CurSummonMobIndex 	= SkillInfo["SummonLump"]["SummonIndex"]
					CurSummonSkillIndex = SkillInfo["SummonLump"]["SummonSkillIndex"]

				-- ŷ�������� SD_SlimeIce �� ��ȯ�ϴ� ��ų ����.
				elseif Var["KingSlimeProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Ice"]
				then
					--DebugLog("ŷ������ ��ȯ��ų.."..SkillInfo["SkillIndex_Ice"] )
					CurSummonMobIndex 	= SkillInfo["SummonIce"]["SummonIndex"]
					CurSummonSkillIndex = SkillInfo["SummonIce"]["SummonSkillIndex"]

				-- ŷ�������� �� �� ��ȯ�ϴ� ��ų ����.( ¦��/Ȧ�� ����� ��ȯ�� �������� )
				elseif Var["KingSlimeProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_All"]
				then
					--DebugLog("ŷ������ ��ȯ��ų.."..SkillInfo["SkillIndex_All"] )

					if Var["KS_BombSlimePiece"]["CurSummonSequence"] % 2 == 0
					then
						CurSummonMobIndex 	= SkillInfo["SummonLump"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonLump"]["SummonSkillIndex"]

					elseif Var["KS_BombSlimePiece"]["CurSummonSequence"] % 2 == 1
					then
						CurSummonMobIndex 	= SkillInfo["SummonIce"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonIce"]["SummonSkillIndex"]
					end
				-- �̷� ���� ������.. ����� �׽�Ʈ�뵵..
				else
					ErrorLog("KS_BombSlimePiece ��ƾ, �˼����� ��ų �����..")
				end

				-- ��ȯ�� ���� �ڵ鰪�� ���´�.
				local CurSummonHandle = cMobRegen_XY( MapIndex, CurSummonMobIndex, CurSummonMob["x"], CurSummonMob["y"] )

				if CurSummonHandle == nil
				then
					-- DebugLog("�� ���� ����"..Var["KS_BombSlimePiece"]["CurSummonSequence"] )
					-- �������� ������ ��ǥ�� ���� ���, �������� ���������� ������ ����ó���� �����ʴ´�.
					-- �׳� ���� �� �����ϵ��� �Ѿ��.
				end


				if CurSummonHandle ~= nil
				then
					if cSkillBlast( CurSummonHandle, CurSummonHandle, CurSummonSkillIndex ) == nil
					then
						ErrorLog("�� ��ų������"..Var["KS_BombSlimePiece"]["CurSummonSequence"] )
					end
				end


				-- ���� �� ������ ���� ���� ����
				Var["KS_BombSlimePiece"]["CurSummonSequence"] 	= Var["KS_BombSlimePiece"]["CurSummonSequence"] + 1
				Var["KS_BombSlimePiece"]["SummonTime"]			= Var["KS_BombSlimePiece"]["SummonTime"] + SkillInfo["SummonTick"]

				--DebugLog("���� ������ �ð��� : "..Var["KS_BombSlimePiece"]["SummonTime"])

				return ReturnAI["END"]
			end

			-- �������̺� �� �������ϱ�, �ʱ�ȭ
			Var["KS_BombSlimePiece"]["SummonTime"] 			= nil
			Var["KS_BombSlimePiece"]["CurSummonSequence"] 	= nil
		end

		--------------------------------------------------------------------------------
		-- �� �� ��ȯ �۾��� �������Ƿ�, ��ų �����ص� �Ǵ� �ð����� üũ�Ѵ�
		--------------------------------------------------------------------------------
		-- ��ų ó���� �Ϸ�������, ���� ��ȯ�ִϸ��̼� ���̶�� ���
		if Var["KingSlimeProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			--DebugLog("�ö���� �����..")
			return ReturnAI["END"]
		end

		if Var["KingSlimeProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("KS_BombSlimePiece ��� ��ųó���Ϸ�!")
			Var["KS_BombSlimePiece"]					= nil

			-- ��ų ó�� �ٳ�������,
			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingSlimeProcess"]["SkillStartTime"]	= 0
			Var["KingSlimeProcess"]["SkillWorkTime"]	= 0
			Var["KingSlimeProcess"]["SkillEndTime"]		= 0

			Var["KingSlimeProcess"]["CurSkillIndex"]	= nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end

	return ReturnAI["END"]
end
