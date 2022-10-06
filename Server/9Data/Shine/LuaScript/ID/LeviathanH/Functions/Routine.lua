--------------------------------------------------------------------------------
-- �� DummyRoutineFunc
--------------------------------------------------------------------------------
function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end

--------------------------------------------------------------------------------
-- �� PlayerMapLogin
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


--------------------------------------------------------------------------------
-- �� Routine_BossLive
--------------------------------------------------------------------------------
function Routine_BossLive( Handle, MapIndex )
cExecCheck "Routine_BossLive"

	if Handle == nil
	then
		ErrorLog( "Routine_BossLive::Handle == nil" )
		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_BossLive::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_BossLive::Var == nil" )
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

	return ReturnAI["CPP"]
end


--------------------------------------------------------------------------------
-- �� Routine_BossDead
--------------------------------------------------------------------------------
function Routine_BossDead( MapIndex, AttackerHandle, Handle )
cExecCheck "Routine_BossDead"

	DebugLog("Routine_BossDead::��ƾ����")

	-- �Լ� ���� Ȯ��
	if Handle == nil
	then
		ErrorLog( "Routine_Guard::Handle == nil" )

		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "Routine_Guard::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	DebugLog("Routine_BossDead::MapIndex :"..MapIndex )

	-- �ʵ� ���� Ȯ��
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_Guard::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	local CurDoor = Var["Boss"][Handle]["Door"]

	if CurDoor["IsOpen"] == false
	then
		CurDoor["IsOpen"] = true

		cAIScriptSet( Handle )
	end

	return ReturnAI["END"]
end





--------------------------------------------------------------------------------
-- �� Routine_Leviathan
--------------------------------------------------------------------------------
function Routine_Leviathan( Handle, MapIndex )
cExecCheck "Routine_Leviathan"

	-- �Լ� ���� Ȯ��
	if Handle == nil
	then
		ErrorLog( "Routine_Leviathan::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_Leviathan::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- �ʵ� ���� Ȯ��
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_Leviathan::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	if Var["Routine_Leviathan"] == nil
	then
		Var["Routine_Leviathan"] = {}
		ErrorLog("Routine_Leviathan::���̺� ����")
	end

	local CurSkillInfo = LeviathanSkillInfo["Routine_Leviathan"]

	local CurHP, MaxHP 	= cObjectHP( Handle )
	local CurHPRate		= ( CurHP / MaxHP ) * 100

	if CurHPRate < CurSkillInfo["HPRateToRegenEgg"]
	then
		if Var["Routine_Leviathan"][Handle] == nil
		then

			Var["Routine_Leviathan"][Handle] = {}

			Var["Routine_Leviathan"][Handle]["GuardianEgg"] = {}
			Var["Routine_Leviathan"][Handle]["GuardEgg"] 	= {}
			Var["Routine_Leviathan"][Handle]["BuffEgg"] 	= {}

		-- GuardianEgg ���̺� �ʱ�ȭ
			Var["Routine_Leviathan"][Handle]["GuardianEgg"]["RegenTick"] 		= Var["CurSec"] + CurSkillInfo["GuardianEgg"]["RegenTick"]
			Var["Routine_Leviathan"][Handle]["GuardianEgg"]["RegenMob"] 		= CurSkillInfo["GuardianEgg"]["RegenMob"]
			Var["Routine_Leviathan"][Handle]["GuardianEgg"]["RegenMaxCount"] 	= 0

		-- GuardEgg ���̺� ���� �ʱ�ȭ

			Var["Routine_Leviathan"][Handle]["GuardEgg"]["RegenTick"] 			= Var["CurSec"] + CurSkillInfo["GuardEgg"]["RegenTick"]
			Var["Routine_Leviathan"][Handle]["GuardEgg"]["RegenMob"] 			= CurSkillInfo["GuardEgg"]["RegenMob"]
			Var["Routine_Leviathan"][Handle]["GuardEgg"]["RegenMaxCount"] 		= 0

		-- BuffEgg ���̺� ���� �ʱ�ȭ

			Var["Routine_Leviathan"][Handle]["BuffEgg"]["RegenTick"] 			= Var["CurSec"] + CurSkillInfo["BuffEgg"]["RegenTick"]
			Var["Routine_Leviathan"][Handle]["BuffEgg"]["RegenMob"] 			= CurSkillInfo["BuffEgg"]["RegenMob"]
			Var["Routine_Leviathan"][Handle]["BuffEgg"]["RegenMaxCount"] 		= 0

		end
	end

	-- HP�� CurSkillInfo["HPRateToRegenEgg"]% ���Ϸ� ������ �� ���� �����ź�� return
	if Var["Routine_Leviathan"][Handle] == nil
	then
		return ReturnAI["CPP"]
	end


	-- �׾����� Ȯ��
	if cIsObjectDead( Handle ) ~= nil
	then

		if Handle == Var["LeviathanStep"]["BossMain"]["Handle"]
		then
			DebugLog("Routine_Leviathan::Leviathan BossMain Dead")
		elseif Handle == Var["LeviathanStep"]["BossHead"]["Handle"]
		then
			DebugLog("Routine_Leviathan::Leviathan BossHead Dead")
		end

		cAIScriptSet( Handle )

		if Var["Routine_Leviathan"] ~= nil
		then

			ErrorLog("local Var[Routine_Leviathan] ~= nil")

			if Var["Routine_Leviathan"][Handle] ~= nil
			then

				Var["Routine_Leviathan"][Handle] = nil
				ErrorLog("local Var[Routine_Leviathan][Handle]  ~= nil")

			end

		end

		return ReturnAI["END"]
	end


	-- 0.2�ʸ��� üũ�ϴ� ��ƾ
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 5
	else
		return ReturnAI["CPP"]
	end

	--------------------------------------------------------------------
	-- GuardianEgg ����ó��
	--------------------------------------------------------------------
	if Var["Routine_Leviathan"][Handle]["GuardianEgg"] ~= nil
	then

		local MyVar 			= Var["Routine_Leviathan"][Handle]["GuardianEgg"]
		local MyCurSkillInfo 	= CurSkillInfo["GuardianEgg"]

		-- RegenMaxCount Ȯ��
		if MyVar["RegenMaxCount"] > MyCurSkillInfo["RegenMaxCount"]
		then
			DebugLog("Routine_Leviathan::Over RegenMaxCount..GuardianEgg")

			Var["Routine_Leviathan"][Handle]["GuardianEgg"] = nil
			return ReturnAI["CPP"]
		end

		-- ������ �ð����� Ȯ��
		if MyVar["RegenTick"] < Var["CurSec"]
		then
			MyVar["RegenTick"] 		= Var["CurSec"] + MyCurSkillInfo["RegenTick"]

			local SummonIndex 		= MyVar["RegenMob"]["Index"]
			local SummonNum 		= MyVar["RegenMob"]["Num"]

			local SummonDir						= cRandomInt( 1, 90 ) * 4
			local SummonRegenX, SummonRegenY	= cGetAroundCoord( Handle, SummonDir, 450 )

			for i = 1, SummonNum
			do
				local CurSummonHandle	= cMobRegen_Circle( Var["MapIndex"], SummonIndex, SummonRegenX, SummonRegenY, 70 )

				if cSetAIScript ( MainLuaScriptPath, CurSummonHandle ) ~= nil
				then
					if cAIScriptFunc( CurSummonHandle, "Entrance", "Routine_GuardianEgg" ) == nil
					then
						ErrorLog("Routine_Leviathan::cAIScriptFunc Fail")
						return ReturnAI["END"]
					end
				end
			end

			DebugLog("Routine_Leviathan::GuardianEgg Regen Count.."..MyVar["RegenMaxCount"])
			MyVar["RegenMaxCount"] = MyVar["RegenMaxCount"] + 1

		end
	end


	--------------------------------------------------------------------
	-- GuardEgg ����ó��
	--------------------------------------------------------------------
	if Var["Routine_Leviathan"][Handle]["GuardEgg"] ~= nil
	then

		local MyVar 			= Var["Routine_Leviathan"][Handle]["GuardEgg"]
		local MyCurSkillInfo 	= CurSkillInfo["GuardEgg"]

		-- RegenMaxCount Ȯ��
		if MyVar["RegenMaxCount"] > MyCurSkillInfo["RegenMaxCount"]
		then
			DebugLog("Routine_Leviathan::Over RegenMaxCount..GuardEgg")

			Var["Routine_Leviathan"][Handle]["GuardEgg"] = nil
			return ReturnAI["CPP"]
		end

		-- ������ �ð����� Ȯ��
		if MyVar["RegenTick"] < Var["CurSec"]
		then
			MyVar["RegenTick"] 		= Var["CurSec"] + MyCurSkillInfo["RegenTick"]

			local SummonIndex 		= MyVar["RegenMob"]["Index"]
			local SummonNum 		= MyVar["RegenMob"]["Num"]

			local SummonDir						= cRandomInt( 1, 90 ) * 4
			local SummonRegenX, SummonRegenY	= cGetAroundCoord( Handle, SummonDir, 450 )

			for i = 1, SummonNum
			do
				local CurSummonHandle	= cMobRegen_Circle( Var["MapIndex"], SummonIndex, SummonRegenX, SummonRegenY, 70 )

				if cSetAIScript ( MainLuaScriptPath, CurSummonHandle ) ~= nil
				then
					if cAIScriptFunc( CurSummonHandle, "Entrance", "Routine_GuardEgg" ) == nil
					then
						ErrorLog("Routine_Leviathan::cAIScriptFunc Fail")
						return ReturnAI["END"]
					end
				end
			end

			DebugLog("Routine_Leviathan::GuardEgg Regen Count.."..MyVar["RegenMaxCount"])
			MyVar["RegenMaxCount"] = MyVar["RegenMaxCount"] + 1

		end
	end



	--------------------------------------------------------------------
	-- BuffEgg ����ó��
	--------------------------------------------------------------------
	if Var["Routine_Leviathan"][Handle]["BuffEgg"] ~= nil
	then

		local MyVar 			= Var["Routine_Leviathan"][Handle]["BuffEgg"]
		local MyCurSkillInfo 	= CurSkillInfo["BuffEgg"]

		-- RegenMaxCount Ȯ��
		if MyVar["RegenMaxCount"] > MyCurSkillInfo["RegenMaxCount"]
		then
			DebugLog("Routine_Leviathan::Over RegenMaxCount..BuffEgg")

			Var["Routine_Leviathan"][Handle]["BuffEgg"] = nil
			return ReturnAI["CPP"]
		end

		-- ������ �ð����� Ȯ��
		if MyVar["RegenTick"] < Var["CurSec"]
		then
			MyVar["RegenTick"] 		= Var["CurSec"] + MyCurSkillInfo["RegenTick"]

			local SummonIndex 		= MyVar["RegenMob"]["Index"]
			local SummonNum 		= MyVar["RegenMob"]["Num"]

			local SummonDir						= cRandomInt( 1, 90 ) * 4
			local SummonRegenX, SummonRegenY	= cGetAroundCoord( Handle, SummonDir, 450 )

			for i = 1, SummonNum
			do
				local CurSummonHandle	= cMobRegen_Circle( Var["MapIndex"], SummonIndex, SummonRegenX, SummonRegenY, 70 )

				if cSetAIScript ( MainLuaScriptPath, CurSummonHandle ) ~= nil
				then

					if cAIScriptFunc( CurSummonHandle, "Entrance", "Routine_BuffEgg" ) == nil
					then
						ErrorLog("Routine_Leviathan::cAIScriptFunc Fail")
						return ReturnAI["END"]
					end

				end
			end

			DebugLog("Routine_Leviathan::BuffEgg Regen Count.."..MyVar["RegenMaxCount"])
			MyVar["RegenMaxCount"] = MyVar["RegenMaxCount"] + 1

		end
	end

	return ReturnAI["CPP"]

end





















--------------------------------------------------------------------------------
-- �� Routine_GuardianEgg	-- ū ��
--------------------------------------------------------------------------------
function Routine_GuardianEgg( Handle, MapIndex )
cExecCheck "Routine_GuardianEgg"

	-- �Լ� ���� Ȯ��
	if Handle == nil
	then
		ErrorLog( "Routine_GuardianEgg::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_GuardianEgg::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- �ʵ� ���� Ȯ��
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_GuardianEgg::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- ��ų������ ��������
	local CurSkillInfo = LeviathanSkillInfo["Routine_GuardianEgg"]

	if Var["Routine_GuardianEgg"] == nil
	then
		Var["Routine_GuardianEgg"] = {}
		DebugLog("Routine_GuardianEgg:: Table Create")
	end

	-- ���� �ʱ�ȭ
	if Var["Routine_GuardianEgg"][Handle] == nil
	then

		Var["Routine_GuardianEgg"][Handle] = {}
		Var["Routine_GuardianEgg"][Handle]["EggBrakeTime"] 	= Var["CurSec"] + CurSkillInfo["EggBrakeTime"]
		Var["Routine_GuardianEgg"][Handle]["IsReadySummon"]	= false
	end

	local MyVar = Var["Routine_GuardianEgg"][Handle]

	-- �� ������ �� ��ȯ�� �ð����� üũ
	if MyVar ~= nil
	then
		-- ��ȭ ó���� �ð����� üũ
		if MyVar["IsReadySummon"] == false
		then

			if MyVar["EggBrakeTime"] <= Var["CurSec"]
			then
				MyVar["IsReadySummon"] = true
			else
				if cIsObjectDead( Handle ) == 1
				then
					MyVar["IsReadySummon"] = true
				else
					return ReturnAI["CPP"]
				end
			end
		end


		-- ��ȭ ó���� �غ� ������, ������ ���� ������ ������ŭ ��ȯ�ϰ�, ��ũ��Ʈ�� �����Ѵ�.
		if MyVar["IsReadySummon"] == true
		then

			local SummonIndex 	= CurSkillInfo["Summon"]["Index"]
			local SummonNum 	= CurSkillInfo["Summon"]["Num"]

			for i = 1, SummonNum
			do
				local CurSummonHandle = cMobRegen_Obj( CurSkillInfo["Summon"]["Index"], Handle )

				--[[
				if cSetAIScript ( MainLuaScriptPath, CurSummonHandle ) ~= nil
				then
					if cAIScriptFunc( CurSummonHandle, "Entrance", "Routine_Guardian" ) == nil
					then
						ErrorLog("Routine_GuardianEgg::cAIScriptFunc Fail")
						return ReturnAI["END"]
					end
				end
				--]]
			end

			-- ���� ó���ؾ��� �� �� ó�������ϱ�, ������ش�.
			cMobSuicide( MapIndex, Handle )
			cAIScriptSet( Handle )

			if Var["Routine_GuardianEgg"] ~= nil
			then

				--ErrorLog("local Var[Routine_GuardianEgg] ~= nil")

				if Var["Routine_GuardianEgg"][Handle] ~= nil
				then

					Var["Routine_GuardianEgg"][Handle] = nil
					--ErrorLog("local Var[Routine_GuardianEgg][Handle]  ~= nil")

				end

			end

			return ReturnAI["END"]
		end

	end

	return ReturnAI["END"]

end


--------------------------------------------------------------------------------
-- �� Routine_GuardEgg	-- ���� ��
--------------------------------------------------------------------------------
function Routine_GuardEgg( Handle, MapIndex )
cExecCheck "Routine_GuardEgg"

	-- �Լ� ���� Ȯ��
	if Handle == nil
	then
		ErrorLog( "Routine_GuardEgg::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_GuardEgg::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- �ʵ� ���� Ȯ��
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_GuardEgg::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- ��ų������ ��������
	local CurSkillInfo = LeviathanSkillInfo["Routine_GuardEgg"]

	if Var["Routine_GuardEgg"] == nil
	then
		Var["Routine_GuardEgg"] = {}
		DebugLog("Routine_GuardEgg:: Table Create")
	end

	-- ���� �ʱ�ȭ
	if Var["Routine_GuardEgg"][Handle] == nil
	then
		Var["Routine_GuardEgg"][Handle] = {}

		Var["Routine_GuardEgg"][Handle]["EggBrakeTime"] 	= Var["CurSec"] + CurSkillInfo["EggBrakeTime"]
		Var["Routine_GuardEgg"][Handle]["IsReadySummon"]	= false

	end


	local MyVar = Var["Routine_GuardEgg"][Handle]

	-- �� ������ �� ��ȯ�� �ð����� üũ
	if MyVar ~= nil
	then

		-- ��ȭ ó���� �ð����� üũ
		if MyVar["IsReadySummon"] == false
		then

			if MyVar["EggBrakeTime"] <= Var["CurSec"]
			then
				MyVar["IsReadySummon"] = true
			else
				if cIsObjectDead( Handle ) == 1
				then
					MyVar["IsReadySummon"] = true
				else
					return ReturnAI["CPP"]
				end
			end
		end


		-- ��ȭ ó���� �غ� ������, ������ ���� ������ ������ŭ ��ȯ�ϰ�, ��ũ��Ʈ�� �����Ѵ�.
		if MyVar["IsReadySummon"] == true
		then

			local SummonIndex 	= CurSkillInfo["Summon"]["Index"]
			local SummonNum 	= CurSkillInfo["Summon"]["Num"]

			for i = 1, SummonNum
			do
				local CurSummonHandle = cMobRegen_Obj( CurSkillInfo["Summon"]["Index"], Handle )

				--[[
				if cSetAIScript ( MainLuaScriptPath, CurSummonHandle ) ~= nil
				then
					if cAIScriptFunc( CurSummonHandle, "Entrance", "Routine_Guard" ) == nil
					then
						ErrorLog("Routine_GuardEgg::cAIScriptFunc Fail")
						return ReturnAI["END"]
					end
				end
				--]]
			end

			-- ���� ó���ؾ��� �� �� ó�������ϱ�, ������ش�.
			cMobSuicide( MapIndex, Handle )
			cAIScriptSet( Handle )

			if Var["Routine_GuardEgg"] ~= nil
			then

				--ErrorLog("local Var[Routine_GuardEgg] ~= nil")

				if Var["Routine_GuardEgg"][Handle] ~= nil
				then

					Var["Routine_GuardEgg"][Handle] = nil
					--ErrorLog("local Var[Routine_GuardEgg][Handle]  ~= nil")

				end

			end

			return ReturnAI["END"]
		end

	end

	return ReturnAI["END"]
end


--------------------------------------------------------------------------------
-- �� Routine_BuffEgg	-- ���� ��
--------------------------------------------------------------------------------
function Routine_BuffEgg( Handle, MapIndex )
cExecCheck "Routine_BuffEgg"

	-- �Լ� ���� Ȯ��
	if Handle == nil
	then
		ErrorLog( "Routine_BuffEgg::Handle == nil" )

		return ReturnAI["END"]
	end


	if MapIndex == nil
	then
		ErrorLog( "Routine_BuffEgg::MapIndex == nil" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- �ʵ� ���� Ȯ��
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_BuffEgg::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	-- ��ų������ ��������
	local CurSkillInfo = LeviathanSkillInfo["Routine_BuffEgg"]

	if Var["Routine_BuffEgg"] == nil
	then
		Var["Routine_BuffEgg"] = {}
		DebugLog("Routine_BuffEgg:: Table Create")
	end


	-- ���� �ʱ�ȭ
	if Var["Routine_BuffEgg"][Handle] == nil
	then
		Var["Routine_BuffEgg"][Handle] = {}
		Var["Routine_BuffEgg"][Handle]["IsReadyBuff"]	= false
	end


	local MyVar = Var["Routine_BuffEgg"][Handle]

	-- �� ������ �� ��ȯ�� �ð����� üũ
	if MyVar ~= nil
	then
		-- ��ȭ ó���� �ð����� üũ
		if MyVar["IsReadyBuff"] == false
		then
			if cIsObjectDead( Handle ) == 1
			then
				MyVar["IsReadyBuff"] = true
			else
				return ReturnAI["CPP"]
			end
		end


		-- ��ȭ ó���� �غ� ������, ������ ���� ������ ������ŭ ��ȯ�ϰ�, ��ũ��Ʈ�� �����Ѵ�.
		if MyVar["IsReadyBuff"] == true
		then

			ErrorLog("Routine_BuffEgg::WhoKillBuffEgg : cMobSuicide( MapIndex, Handle )")

			-- ���� ó���ؾ��� �� �� ó�������ϱ�, ������ش�.
			--cMobSuicide( MapIndex, Handle )
			cAIScriptSet( Handle )

			if Var["Routine_BuffEgg"] ~= nil
			then

				--ErrorLog("local Var[Routine_BuffEgg] ~= nil")

				if Var["Routine_BuffEgg"][Handle] ~= nil
				then

					Var["Routine_BuffEgg"][Handle] = nil
					--ErrorLog("local Var[Routine_BuffEgg][Handle]  ~= nil")

				end

			end

			ErrorLog("Routine_BuffEgg::IsReadySummon == true")

			local TargetHandle = cGetWhoKillMe( Handle )
			DebugLog("Routine_BuffEgg::WhoKillBuffEgg : "..TargetHandle)

			local BuffIndex 	= CurSkillInfo["Buff"]["Index"]
			local BuffStrength 	= CurSkillInfo["Buff"]["Strength"]
			local BuffKeepTime 	= CurSkillInfo["Buff"]["KeepTime"]

			if cSetAbstate( TargetHandle, BuffIndex, BuffStrength, BuffKeepTime ) == nil
			then
				ErrorLog("Routine_BuffEgg::cSetAbstate Fail")
			end

			-- ���� ó���ؾ��� �� �� ó�������ϱ�, ������ش�.
			--cMobSuicide( MapIndex, Handle )
			--cAIScriptSet( Handle )

			return ReturnAI["END"]
		end

	end

	return ReturnAI["END"]

end


