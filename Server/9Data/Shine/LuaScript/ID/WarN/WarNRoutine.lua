--[[*****																*****]]--
--[[*****						���̸�, ��� ��ƾ						*****]]--
--[[*****		: HP��ȭ�� ���� �ִϸ��̼ǰ� �����̻� ó��			*****]]--
--[[*****																*****]]--
function FriendMobRoutine( Handle, MapIndex )
cExecCheck( "FriendMobRoutine" )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["Guardian"] == nil then

		if InstanceField[MapIndex]["Airi"] == Handle then
			InstanceField[MapIndex]["Airi"] = nil
		end

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["Guardian"][Handle]

	if Var == nil then

		if InstanceField[MapIndex]["Airi"] == Handle then
			InstanceField[MapIndex]["Airi"] = nil
		end

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then

		if InstanceField[MapIndex]["Airi"] == Handle then
			InstanceField[MapIndex]["Airi"] = nil
		end

		cAIScriptSet( Handle )
		InstanceField[MapIndex]["Guardian"][Handle] = nil

		return ReturnAI["END"]
	end



	if Var["State"] == FM_STATE["Stop"] then

		return ReturnAI["END"]

	end


	local CurSec = cCurrentSecond()

	if Var["CheckTime"] + MOB_CHK_DELAY > CurSec then
		return
	end

	Var["CheckTime"] = CurSec



	local CurHP, MaxHP = cObjectHP( Var["Handle"] )
	local HPRate = (CurHP * 1000) / MaxHP

	if Var["Data"]["InjuryHPRate"] > HPRate then

		if Var["State"] == FM_STATE["Normal"] then

			Var["State"] = FM_STATE["Injury"]

			cSetAbstate( Var["Handle"], STA_IMMORTAL, 1, 20000000 )
			cAnimate( Var["Handle"], "start", Var["Data"]["InjuryAniIndex"] )

		end

	else

		if Var["State"] == FM_STATE["Injury"] then

			Var["State"] = FM_STATE["Normal"]

			cResetAbstate( Var["Handle"], STA_IMMORTAL )
			cAnimate( Var["Handle"], "stop" )

		end

	end



	local rtn = ReturnAI["CPP"]

	if Var["State"] == FM_STATE["Injury"] then
		rtn = ReturnAI["END"]
	end

	return rtn

end



--[[*****																*****]]--
--[[*****						�Ϲ� �� ��ƾ							*****]]--
--[[*****		: ��ȯ�� �Ϲ� ���� �׾����� üũ 						*****]]--
--[[*****																*****]]--
function NormalMobRoutine( Handle, MapIndex )
cExecCheck( "NormalMobRoutine" )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["NormalMobList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["NormalMobList"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["NormalMobList"][Handle] = nil
		return ReturnAI["END"]
	end


	return ReturnAI["CPP"]

end



--[[*****																*****]]--
--[[*****						�Ӽ� �� ��ƾ							*****]]--
--[[*****		: ��ȯ�� �Ӽ� ���� �׾����� üũ, ������ ��ȯó�� 		*****]]--
--[[*****																*****]]--
function ElementMobRoutine( Handle, MapIndex )
cExecCheck( "ElementMobRoutine" )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["ElementMobList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["ElementMobList"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["ElementMobList"][Handle] = nil
		return ReturnAI["END"]
	end


	if Var["SummonStep"] ~= nil then

		if Var["SummonStep"] > 0 then

			local CurSec = cCurrentSecond()

			if Var["CheckTime"] + MOB_CHK_DELAY <= CurSec then

				Var["CheckTime"] = CurSec


				local CurHP, MaxHP = cObjectHP( Var["Handle"] )
				local HPRate = (CurHP * 1000) / MaxHP


				if HPRate < BossSummonElite[Var["SummonStep"]]["HPRate"] then

					local CenterCoord = {}

					CenterCoord["x"], CenterCoord["y"] = cObjectLocate( Var["Handle"] )


					local MobNum = 0

					if Var["Grade"] == E_MOB_GRADE["Boss"] then

						MobNum = BossSummonElite[Var["SummonStep"]]["EliteNum"]

					else

						-- ġ������ ��ȯ ���� ������ 1�ܰ� ��ȯ ����ŭ��
						MobNum = BossSummonElite[#BossSummonElite]["EliteNum"]

					end


					for i=1, MobNum do

						local RegenMob = {}

						RegenMob["Handle"] = cMobRegen_Circle( MapIndex, Var["SummonIndex"],
													CenterCoord["x"],
													CenterCoord["y"],
													BossSummonElite[Var["SummonStep"]]["Range"] )

						if RegenMob["Handle"] ~= nil then

							RegenMob["CheckTime"] = CurSec
							RegenMob["Grade"]     = E_MOB_GRADE["Elite"]

							cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
							cAIScriptFunc( RegenMob["Handle"], "Entrance", "ElementMobRoutine" )

							InstanceField[MapIndex]["ElementMobList"][RegenMob["Handle"]] = RegenMob

						end

					end

					Var["SummonStep"] = Var["SummonStep"] - 1

				end

			end

		end

	end


	return ReturnAI["CPP"]

end



--[[*****																*****]]--
--[[*****							���� ��ƾ							*****]]--
--[[*****		: ���������� HP ȸ���ؼ� ���� �ʵ��� ��					*****]]--
--[[*****																*****]]--
function OreRoutine( Handle, MapIndex )
cExecCheck( "OreRoutine" )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["OreList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["OreList"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["OreList"][Handle] = nil
		return ReturnAI["END"]
	end



	local CurSec = cCurrentSecond()

	if Var["CheckTime"] + MOB_CHK_DELAY > CurSec then
		return ReturnAI["END"]
	end

	Var["CheckTime"] = CurSec


	local CurHP, MaxHP = cObjectHP( Var["Handle"] )

	cHeal( Var["Handle"], MaxHP )



	return ReturnAI["END"]

end



--[[*****																*****]]--
--[[*****							������ ��ƾ							*****]]--
--[[*****		: �̵�, ��ų��� ó��									*****]]--
--[[*****																*****]]--
function TrapMobRoutine( Handle, MapIndex )
cExecCheck( "TrapMobRoutine" )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["TrapMobList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["TrapMobList"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["TrapMobList"][Handle] = nil
		return ReturnAI["END"]
	end



	local CurSec = cCurrentSecond()

	-- �̵� ó��
	if Var["CheckTime"] + MOB_CHK_DELAY <= CurSec then

		local CurCoord  = {}
		local GoalCoord = Var["PatrolPath"][Var["CurGoal"]]

		CurCoord["x"], CurCoord["y"] = cObjectLocate( Var["Handle"] )

		if cDistanceSquar( CurCoord["x"], CurCoord["y"], GoalCoord["x"], GoalCoord["y"] ) < (TRAP_GOAL_INTERVAL * TRAP_GOAL_INTERVAL) then

			Var["CurGoal"] = Var["CurGoal"] + 1

			if Var["CurGoal"] > #Var["PatrolPath"] then

				Var["CurGoal"] = 1

			end

			cRunTo( Var["Handle"], Var["PatrolPath"][Var["CurGoal"]]["x"], Var["PatrolPath"][Var["CurGoal"]]["y"] )

		end


		Var["CheckTime"] = CurSec

	end


	-- ��ų ���
	if Var["DelayTime"] + Var["Data"]["Interval"] <= CurSec then

		if cSkillBlast( Var["Handle"], Var["Handle"], Var["Data"]["SkillIndex"] ) ~= nil then

			-- ��ų ��� �����ϸ� ������üũ�� �ð� �缳��
			Var["DelayTime"] = CurSec

		end

	end


	return ReturnAI["END"]

end



--[[*****																*****]]--
--[[*****							����Ʈ ��ƾ							*****]]--
--[[*****		: �ƹ� ó�� ����										*****]]--
--[[*****																*****]]--
GateMapIndex = {} -- ���Ǿ�Ŭ���ÿ� ���ε����� ���� �ʾ� �����ÿ� ���ε����� ����

function GateRoutine( Handle, MapIndex )
cExecCheck( "GateRoutine" )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["ExitGateList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["ExitGateList"][Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["ExitGateList"][Handle] = nil
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if GateMapIndex[Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		InstanceField[MapIndex]["ExitGateList"][Handle] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["END"]

end


function GateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "GateClick" )

	local MapIndex = GateMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["ExitGateList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["ExitGateList"][NPCHandle]

	if Var == nil then
		return
	end


	cServerMenu( PlyHandle, NPCHandle, GateMenu["Title"],
										GateMenu["Yes"], "LinkToVillage",
										GateMenu["No"],  "GateDummy")

end


function LinkToVillage( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToVillage" )

	local MapIndex = GateMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["ExitGateList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["ExitGateList"][NPCHandle]

	if Var == nil then
		return
	end

	cLinkTo( PlyHandle, Var["Data"]["Field"], Var["Data"]["x"], Var["Data"]["y"] )

end


function GateDummy( NPCHandle, PlyHandle, RegistNumber )
end

