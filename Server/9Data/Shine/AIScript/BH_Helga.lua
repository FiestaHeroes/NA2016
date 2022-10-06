--[[
���� �������� - �ﰡ

9Data/Here/World/FineScript.txt �ʿ�
9Data/Hero/Script/BH_Helga.txt �ʿ�
]]

-- �ﰡ �Ͼ�� ��ų���(�Ͼ�� ���� �ִ�)

-- ��ũ��Ʈ�� ���ϰ�
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- ��� AI��ƾ ��
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- ��Ʒ� �Ϻ� ó���� �� cpp�� AI��ƾ ����

--[[ TODO
	�÷��̾ �����Ͽ� Ÿ���� �Ҿ�����, �ﰡ�� DuringReturn2Regen()��ƾ�� ���� ��ȭ������ ���� �����
		- ó����� �ʿ�
]]


HelgaIndex = "BH_Helga"
KarasianIndex = {}
KarasianIndex[1] = "BH_KaraTemplerAC"
KarasianIndex[2] = "BH_KaraTemplerMR"
BijouIndex = "BH_HelgaBall"

HelgaReadyAbstate = "StaBH_Helga_Idle01"		-- ���� �ﰡ�� ��ũ���� �ִ� �����̻�
HelgaBuffByBijou = "StaBH_HelgaAPU01"		-- ���꿡 ���� �ﰡ�� �ɸ��� �ߺ�����
HelgaBufByKarasian = "StaBH_HelgaDRT01"		-- ī���ȿ� ���� �ﰡ�� �ɸ��� �������ݻ����
BijouBuffByKarasian = "StaHelgaBall"			-- ī��þ��� ���꿡 �Ŵ� ����(���갡 ��������)
KarasianSelfBuff = "StaBH_KaraTempler_None"	-- ī��þ��� ���꿡 �������� ��� ���

HelgaRaiseSkill = "BH_Helga_Skill_N_None"		-- �ﰡ�� �Ͼ���� �ִϸ��̼�


KarasianRegenSec = 60


-- ����� ī��þȵ��� ������ ��� ����Ʈ
BijouLoc = {}
KarasianLocate = {}

-- ù° �׷�
BijouLoc[1] = {}
BijouLoc[1].X = 2483
BijouLoc[1].Y = 870
BijouLoc[1].D = 0
KarasianLocate[ 1] = {}
KarasianLocate[ 1].X = 2539
KarasianLocate[ 1].Y = 852
KarasianLocate[ 1].D = -89
KarasianLocate[ 2] = {}
KarasianLocate[ 2].X = 2442
KarasianLocate[ 2].Y = 833
KarasianLocate[ 2].D = 38
KarasianLocate[ 3] = {}
KarasianLocate[ 3].X = 2477
KarasianLocate[ 3].Y = 929
KarasianLocate[ 3].D = 165

-- ��°�׷�
BijouLoc[2] = {}
BijouLoc[2].X = 681
BijouLoc[2].Y = 879
BijouLoc[2].D = 0
KarasianLocate[ 4] = {}
KarasianLocate[ 4].X = 733
KarasianLocate[ 4].Y = 852
KarasianLocate[ 4].D = -76
KarasianLocate[ 5] = {}
KarasianLocate[ 5].X = 635
KarasianLocate[ 5].Y = 849
KarasianLocate[ 5].D = 50
KarasianLocate[ 6] = {}
KarasianLocate[ 6].X = 677
KarasianLocate[ 6].Y = 935
KarasianLocate[ 6].D = -172

-- ��°�׷�
BijouLoc[3] = {}
BijouLoc[3].X = 2503
BijouLoc[3].Y = 2290
BijouLoc[3].D = 0
KarasianLocate[ 7] = {}
KarasianLocate[ 7].X = 2556
KarasianLocate[ 7].Y = 2268
KarasianLocate[ 7].D = -79
KarasianLocate[ 8] = {}
KarasianLocate[ 8].X = 2457
KarasianLocate[ 8].Y = 2251
KarasianLocate[ 8].D = 52
KarasianLocate[ 9] = {}
KarasianLocate[ 9].X = 2507
KarasianLocate[ 9].Y = 2345
KarasianLocate[ 9].D = -177

-- ��°�׷�
BijouLoc[4] = {}
BijouLoc[4].X = 670
BijouLoc[4].Y = 2275
BijouLoc[4].D = 0
KarasianLocate[10] = {}
KarasianLocate[10].X = 725
KarasianLocate[10].Y = 2247
KarasianLocate[10].D = -75
KarasianLocate[11] = {}
KarasianLocate[11].X = 621
KarasianLocate[11].Y = 2244
KarasianLocate[11].D = 41
KarasianLocate[12] = {}
KarasianLocate[12].X = 667
KarasianLocate[12].Y = 2329
KarasianLocate[12].D = 177


MemBlock = {}
HelgaHandle = 0

function ViewHandle()
cExecCheck "ViewHandle"
	local Var = MemBlock[HelgaHandle]
	local x, y = cObjectLocate(Var.Handle)
	cDebugLog("Helga : " .. Var.Handle .. '(' .. x .. ',' .. y .. ')')

	for b = 1, 4 do
		local BVar = Var.BijouInfo[b]
		local x, y = cObjectLocate(BVar.Handle)
		cDebugLog(" Bijou : " .. BVar.Handle .. '(' .. x .. ',' .. y .. ')')
		for k = 1, 3 do
			local KVar = BVar.KarasianInfo[k]
			local x, y = cObjectLocate(KVar.Handle)
			cDebugLog("  Karasian : " .. KVar.Handle .. '(' .. x .. ',' .. y .. ')')
		end
	end
end

--[[
function MainRoutine(Handle, MapIndex)    -- ī��þȿ��� ȣ��� ���
cExecCheck "MainRoutine"
	if MobID == Karasian1ID or MobID == Karasian2ID then
		Karasian_Main(Handle, MobID, MapIndex)
		return ReturnAI.END
	elseif MobID == BijouID then            -- ���꿡�� ȣ��� ���
		Bijou_Main(Handle, MobID, MapIndex)
		return ReturnAI.END
	elseif MobID == HelgaID then        -- ����(�ﰡ)���� ȣ��� ���
		return Helga_Main(Handle, MobID, MapIndex)
	end
	return ReturnAI.END
end
]]

---------------------------------------------------------------------
------------------------    Common Part   ---------------------------
---------------------------------------------------------------------
function Common_Nothing()  -- �����
cExecCheck "Common_Nothing"
	return ReturnAI.END   -- ��� AI��ƾ ��
end

function Common_Wait(Var)  -- Var.Wait.Second���� ��ٸ� �� StepFunc�� WaitFunction���� ����
cExecCheck "Common_Wait"
--	----cDebugLog("Common_Wait " .. Var.Me)
		-- �����̹Ƿ� �ﰡ, ����, ī��þ� ���� Var�� Wait.Second, Wait.NextFunc, StepFunc�� �־�� ��
	if cCurSec() >= Var.Wait.Second then
		Var.StepFunc = Var.Wait.NextFunc
	end
	return Var.Wait.Rtn
end

function Common_RemoveTreasure(MapIndex)
cExecCheck "Common_RemoveTreasure"
	cDebugLog "Common_RemoveTreasure"

	cRegenGroupActiv("BH_Helga", "BH_HelgaBox", 0)	-- ���ڰ� ������ �ʵ���(����° �μ��� �����ϰų� 1�̸� activ)
	cVanishAll(MapIndex, "BH_Helga_O")
	cVanishAll(MapIndex, "BH_Helga_O_02")
	cVanishAll(MapIndex, "BH_Helga_X")
end

---------------------------------------------------------------------
--------------------------   Helga Part   ----------------------------
---------------------------------------------------------------------
function BH_Helga(Handle, MapIndex)
cExecCheck "BH_Helga"
--	----cDebugLog "Helga_Main"
	local Var = MemBlock[Handle]

	if cIsObjectDead(Handle) == nil and Var == nil then
		HelgaHandle = Handle
		if MapIndex ~= "BH_Helga" then	-- ���� �߸��Ǿ���
			cAIScriptSet(Handle)	-- AI��ũ��Ʈ ����
			return ReturnAI.END
		end

		-- �ﰡ�� ó�� �����Ǿ��� �� �ڽ��� �޸� �ʱ�ȭ
		-- �ؿ��� �ﰡ�� �׾����� �޸� �����ϴ� �κ��� �ֱ⿡,
		--		 ��� �Ҵ�� �����Ǵ� ���� ���� ���� �׾�����(cIsObjectDead)�� Ȯ��
------cDebugLog("Helga Initialize")
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Me = "Helga"   -- ������ ����ϱ� ����
		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.BuffCharge = 0  -- �� ���� 40�� �Ǹ� ���� ����
		Var.TargetLostSec = 0  -- Ÿ���� ���� �� ���� �ð� �� ������ ������ ����(���� Ÿ�� ã�� �ð�)

		cSetAbstate(Var.Handle, HelgaReadyAbstate, 1, 2000000000)
		cSetAbstate(Var.Handle, "StaImmortal", 1, 2000000000)

		Var.StepFunc = Helga_BijouRegen		-- ���� ��ƾ���� ���� ����
	end

	if cIsObjectDead(Handle) ~= nil then
		if Var ~= nil then
-----cDebugLog "Helga Dead"
			-- �����ΰ� ��ȯ - �������� �����
			local InvisibleHandle = cMobRegen_Obj("InvisibleMan", Handle)
			cAIScriptSet(InvisibleHandle, Handle) -- ������ AI��ũ��Ʈ�� Var.Handle(�ﰡ)�� AI��ũ��Ʈ�� ����
			MemBlock[InvisibleHandle] = {}
			MemBlock[InvisibleHandle].Handle = InvisibleHandle
			MemBlock[InvisibleHandle].MapIndex = MapIndex
			MemBlock[InvisibleHandle].StepFunc = Invisible_Init

			-- �ﰡ�� �׾��� ��
			-- ��� ����, ī��þȵ� ����
			-- ���� �ﰡ�� �����ɶ� �ٽ� ó������ ����
			for b = 1, 4 do
				local BijouInfo = Var.BijouInfo[b]
				for k = 1, 3 do	-- ���꿡 �Ҵ�� ī��þ� ����
					local KaraInfo = BijouInfo.KarasianInfo[k]
					cNPCVanish(KaraInfo.Handle)
					MemBlock[KaraInfo.Handle] = nil		-- ī��þȿ� �Ҵ�� �޸� ����
														-- ���� �޸𸮰� Var.BijouInfo.KaraInfo���� �����Ƿ� ���⼭�� ������ �޸𸮻��� �ȵ�
				end
				cNPCVanish(BijouInfo.Handle)
				MemBlock[BijouInfo.Handle] = nil	-- ���꿡 �Ҵ�� �޸� ����(�̶� Bijou.KarasianInfo�� ������)
													-- ���� �޸𸮰� Var.BijouInfo���� �����Ƿ� ���⼭�� ������ �޸𸮻��� �ȵ�
			end

			MemBlock[Var.Handle] = nil
			Var = nil					-- �ﰡ�� �Ҵ�� �޸� ����(�̶� Var.BijouInfo�� ������)
		end
		return ReturnAI.END
	end

	return Var.StepFunc(Var)
end

function Helga_BijouRegen(Var)	-- ���� ������Ŵ
cExecCheck "Helga_BijouRegen"
	----cDebugLog("Bijou Regen from " .. Var.Handle)
	Var.BijouInfo = {}
	for b = 1, 4 do
		local BijouHandle = cMobRegen_XY(Var.MapIndex, BijouIndex, BijouLoc[b].X, BijouLoc[b].Y, BijouLoc[b].D)
		cDebugLog("Bijou Regen : " .. BijouHandle)

		local BijouInfo = {}
		MemBlock[BijouHandle] = BijouInfo		-- �ڵ鿡 ���߾� �޸𸮺� ����
		Var.BijouInfo[b] = BijouInfo

		BijouInfo.Me = "Bijou"   -- ������ ����ϱ� ����
		BijouInfo.Handle = BijouHandle
		BijouInfo.HelgaInfo = Var
		BijouInfo.MapIndex = Var.MapIndex
		BijouInfo.KarasianOffset = b * 3 - 2	-- �� ���꿡 �Ҵ�� ī��þȵ��� ���Թ�ȣ ���
												-- ���̽��� 1�̹Ƿ� ���� ���� ������
												--     ���� 1 -> ī��þ�  1,  2,  3
												--     ���� 2 -> ī��þ�  4,  5,  6
												--     ���� 3 -> ī��þ�  7,  8,  9
												--     ���� 4 -> ī��þ� 10, 11, 12
		cAIScriptSet(BijouHandle, Var.Handle) -- ������ AI��ũ��Ʈ�� Var.Handle(�ﰡ)�� AI��ũ��Ʈ�� ����
		BijouInfo.StepFunc = Bijou_KarasianRegen		-- ������ ���� �׼��� ī��þ� �����
	end

	Var.StepFunc = Helga_TreasureVanish
	return ReturnAI.END
end

function Helga_TreasureVanish(Var)
cExecCheck "Helga_TreasureVanish"

	cDebugLog "Helga_TreasureVanish"
	Common_RemoveTreasure(Var.MapIndex)

	-- 10�ʿ� �ѹ��� ���� ����(�ٸ� ������ ���ڰ� ��Ÿ����...)
	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 10
	Var.Wait.NextFunc = Helga_TreasureVanish
	Var.Wait.Rtn = ReturnAI.END
	Var.StepFunc = Common_Wait
	cDebugLog("Common_Wait - Helga_TreasureVanish")


	-- �ﰡ �� �ٽ� ä��
	local HP, MaxHP = cObjectHP(Var.Handle)
	cSetNPCParam(Var.Handle, "HP", MaxHP)
end

function Helga_Awake(Var)		-- ī��þȵ鿡 ���� ��� �� ó��
cExecCheck "Helga_Awake"
	----cDebugLog("Awake - Skill Blast")		-- ����� ���� ��ų �ߵ�

	cResetAbstate(Var.Handle, HelgaReadyAbstate)-- ���ݹ��� �ʱ� ���� ���������̻� ����
	cResetAbstate(Var.Handle, "StaImmortal")	-- ���ݹ��� �ʱ� ���� ���������̻� ����
	------cDebugLog("Awake - Skill Blast")		-- ����� ���� ��ų �ߵ�

	cNPCSkillUse(Var.Handle, Var.Handle, HelgaRaiseSkill)	-- �Ͼ�� �ִϸ��̼�

	-- ��ų�ߵ��� ���� 3�ʰ� ��� �� Helga_Attack���� �ٲ�(�Լ� Common_Wait ����)
	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 3
	Var.Wait.NextFunc = Helga_PreAttack	-- �����ϱ� �� �غ�
	Var.Wait.Rtn = ReturnAI.END
	Var.StepFunc = Common_Wait
	cDebugLog("Common_Wait - Helga_Awake")

	Var.BuffCharge = 0  -- �� ���� Bijou_BuffToHelga()���� ����, 40�� �Ǹ� ���� ����

	return ReturnAI.END
end

function Helga_PreAttack(Var)
cExecCheck "Helga_PreAttack"
	Var.TargetLostSec = cCurSec()  -- ���� Ÿ���� �Ҿ���
	Var.StepFunc = Helga_Attack
----cDebugLog("Helga_PreAttack " .. Var.TargetLostSec)
end

function Helga_Attack(Var)
cExecCheck "Helga_Attack"


if LastWrite ~= cCurSec() then
	cDebugLog("Helga_Attack " .. Var.TargetLostSec .. " " .. cCurSec())
	LastWrite = cCurSec()
end

	-- �ﰡ�� ����
	if Var.BuffCharge >= 240 then
		----cDebugLog("HelgaBuff")
		if cTargetHandle(Var.Handle) ~= nil then
			cMessage(Var.Handle, "BH_Helga_Buff")
			cSetAbstate(Var.Handle, HelgaBuffByBijou, 1, 200000000)
		end
		Var.BuffCharge = Var.BuffCharge - 240
	end

	local TargetHandle = cTargetHandle(Var.Handle)
	if TargetHandle ~= nil and cObjectType(TargetHandle) == 2 then	-- Ÿ���� �ְ� �÷��̾�� (SHINEOBJECT_PLAYER == 2)
		Var.TargetLostSec = cCurSec()
	elseif Var.TargetLostSec + 10 < cCurSec() then	-- ���� ������� 10�� ��
		cResetAbstate(Var.Handle, KarasianSelfBuff)	-- ��ȭ���� ����
		cResetAbstate(Var.Handle, HelgaBuffByBijou)	-- ��ȭ���� ����
		Var.BuffCharge = 0  -- �� ���� 40�� �Ǹ� ���� ����
		-- Ÿ�� ����� ��� ����, ī��þ� ����
		for b = 1, 4 do
			cNPCVanish(Var.BijouInfo[b].Handle)
			for k = 1, 3 do
				cNPCVanish(Var.BijouInfo[b].KarasianInfo[k].Handle)
			end
		end

		MemBlock = {} -->��� �޸� ���� - ó������ �ٽ� ����
	end

	return ReturnAI.CPP	-- ���� �ﰡ�� CPP�� AI��ƾ ����(�ﰡ�� ���� üũ�� Helga_Main����)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Helga_AllBijouStepFunc(Var, func)	-- ��� ������� StepFunc�� �ϰ������� �ٲ�
cExecCheck "Helga_AllBijouStepFunc"
	----cDebugLog("Helga_AllBijouStepFunc")
	for b = 1, 4 do
		----cDebugLog("   " .. Var.BijouInfo[b].Me)
		Var.BijouInfo[b].StepFunc = func
	end
end

function Helga_AllKarasianStepFunc(Var, func)	-- ��� ī��þȵ��� StepFunc�� �ϰ������� �ٲ�
cExecCheck "Helga_AllKarasianStepFunc"
	----cDebugLog("Helga_AllKarasianStepFunc")
	for b = 1, 4 do
		for k = 1, 3 do
			----cDebugLog("   " .. Var.BijouInfo[b].KarasianInfo[k].Me)
			Var.BijouInfo[b].KarasianInfo[k].StepFunc = func
		end
	end
end

---------------------------------------------------------------------
-------------------------    Bijou Part   ---------------------------
---------------------------------------------------------------------
function BH_HelgaBall(Handle, MapIndex)
cExecCheck "BH_HelgaBall"
--	----cDebugLog "Bijou_Main"
	local Var = MemBlock[Handle]		-- �ڵ��� ������� �޸𸮺� ã��
	if Var == nil then
		----cDebugLog("Bijou Handle Error:" .. Handle)
		return
	end

	Var.StepFunc(Var)
end

function Bijou_KarasianRegen(Var)		-- ī��þ��� �����ϴ� �Լ�
cExecCheck "Bijou_KarasianRegen"
	----cDebugLog "Bijou_KarasianRegen"
				-- ������ ī��þȵ��� ������������ �����ؾ� �ϹǷ� ������ �Լ��� ���

	Bijou_SummonKarasian(Var, Karasian_WaitInvader)
		-- �� ���꿡 �Ҵ�� ������ ī��þȵ��� ������Ű�� �׵��� Karasian_WaitInvader�ൿ�� �ϵ��� ����

	Var.StepFunc = Common_Nothing	-- �ƹ��͵� ����(���� ī��þȵ鿡 ���� ���)
end

function Bijou_BuffToHelga(Var)		-- ���� ���� �� ī��þȿ��� ����
cExecCheck "Bijou_BuffToHelga"
	--cDebugLog("Bijou[" .. Var.Handle .. "] Buff To Helga")

	-- �� ī��þȵ��� ��� �����ϴ��� Ȯ��
	local karanum = 0
	for k = 1, 3 do
		if cIsObjectDead(Var.KarasianInfo[k].Handle) == nil then	-- ��������� karanum ����
			karanum = karanum + 1
		end
	end

	if karanum > 0 then -- �ϳ��� ���� ������
		local HelgaInfo = Var.HelgaInfo						-- ���ΰ��� �ﰡ�� ���̺� �����Ƿ�
		HelgaInfo.BuffCharge = HelgaInfo.BuffCharge + 1		-- �� ���� 40�� �Ǹ� ���� ����(���� 4���� ��� 10��)
--cDebugLog("Bijou_BuffToHelga : Buffing " .. HelgaInfo.BuffCharge)

		-- 1�ʿ� �ѹ��� �����ϱ� ����
		Var.Wait = {}
		Var.Wait.Second = cCurSec() + 1
		Var.Wait.NextFunc = Bijou_BuffToHelga
		Var.Wait.Rtn = ReturnAI.END

		Var.StepFunc = Common_Wait
		--cDebugLog("Common_Wait - Bijou_BuffToHelga")
	else 	-- 60���� �ٽ� ������Ŵ
--cDebugLog("Bijou_BuffToHelga : Regen " .. Var.Handle)
		-- 60�� �� ī��þȵ��� �ٽ� ������Ű�� ����
		Var.Wait = {}
		Var.Wait.Second = cCurSec() + KarasianRegenSec
		Var.Wait.NextFunc = Bijou_KarasianReRegen
		Var.Wait.Rtn = ReturnAI.END

		Var.StepFunc = Common_Wait
		--cDebugLog("Common_Wait - Bijou_BuffToHelga")
	end
end

function Bijou_KarasianReRegen(Var)
cExecCheck "Bijou_KarasianReRegen"
	--cDebugLog("Bijou_KarasianReRegen " .. Var.Handle)
	Bijou_SummonKarasian(Var, Karasian_BuffToBijou)
		-- �� ���꿡 �Ҵ�� ī��þȵ��� ������Ű�� Karasian_BuffToBijouȰ���� �ϵ��� ����
	Var.StepFunc = Bijou_WaitBuffing -- ī��þȵ��� ����� ���� ��� ���� �����ϹǷ� ������ ���� ������ ���
end

function Bijou_WaitBuffing(Var)
cExecCheck "Bijou_WaitBuffing"
	--cDebugLog("Bijou_WaitBuffing " .. Var.Handle)
	if cAbstateRestTime(Var.Handle, BijouBuffByKarasian) ~= nil then -- �����ð� ����, nil�̸� �����̻� ����
		Var.StepFunc = Bijou_BuffToHelga
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Bijou_SummonKarasian(Var, Func)
cExecCheck "Bijou_SummonKarasian"
	----cDebugLog("Karasian Regen from " .. Var.Handle)

	-- ī��þȵ��� ���� �޸� �����ϱ� ����
	if Var.KarasianInfo ~= nil then
		for k = 1, 3 do
			local OldKarahnd = Var.KarasianInfo[k].Handle
			MemBlock[OldKarahnd] = nil	-- �޸𸮴� Var.KarasianInfo���� �Ҵ�Ǿ� �����Ƿ� ���⼭�� �޸����� �ȵ�
		end
	end

	Var.KarasianInfo = {}		-- ���⼭ ���� �޸�����

	local type = cRandomInt(1, 2)
	for k = 1, 3 do
		local slot = Var.KarasianOffset + k - 1
		local locate = KarasianLocate[slot]
		local KHnd = cMobRegen_XY(Var.MapIndex, KarasianIndex[type], locate.X, locate.Y, locate.D)
		----cDebugLog("Karasian Regen : " .. KHnd)

		local KInfo = {}
		MemBlock[KHnd] = KInfo
		Var.KarasianInfo[k] = KInfo

		KInfo.Me = "Karasian"
		KInfo.Handle = KHnd
		KInfo.BijouInfo = Var
		KInfo.StepFunc = Func

		cAIScriptSet(KHnd, Var.Handle) -- ī��þ��� AI��ũ��Ʈ�� Var.Handle(����)�� AI��ũ��Ʈ�� ����
		cSetAbstate(KHnd, KarasianSelfBuff, 1, 2000000000)
	end
end



---------------------------------------------------------------------
-----------------------    Karasian Part   --------------------------
---------------------------------------------------------------------
function BH_KaraTemplerAC(Handle, MapIndex)
	return Karasian_Main(Handle, MapIndex)
end

function BH_KaraTemplerMR(Handle, MapIndex)
	return Karasian_Main(Handle, MapIndex)
end

function Karasian_Main(Handle, MapIndex)
cExecCheck "Karasian_Main"
	local Var = MemBlock[Handle]
	if Var == nil then
		----cDebugLog("Karasian Handle Error:" .. Handle)
		return
	end

	Var.StepFunc(Var)

	return ReturnAI.END
end

function Karasian_WaitInvader(Var)
cExecCheck "Karasian_WaitInvader"
	------cDebugLog("Karasian_WaitInvader")
	-- �ڽ��� ���ظ� ���� ������
	if cIsObjectDead(Var.Handle) ~= nil or cTargetHandle(Var.Handle) ~= nil then
		------cDebugLog("Warn")
		Var.StepFunc = Karasian_Warning1    -- ������ ��� �ø�
	end
end

function Karasian_Warning1(Var)
cExecCheck "Karasian_Warning1"
	----cDebugLog("Karasian_Warning1")
	if cIsObjectDead(Var.Handle) ~= nil then
		Karasian_BattleStart(Var)
	else
		Helga_AllKarasianStepFunc(Var.BijouInfo.HelgaInfo, Common_Nothing)

		cNPCChat(Var.Handle, "BH_Helga_Alert")

		Var.Wait = {}
		Var.Wait.Second = cCurSec() + 2
		Var.Wait.NextFunc = Karasian_Warning2
		Var.Wait.Rtn = ReturnAI.END

		Var.StepFunc = Common_Wait
		cDebugLog("Common_Wait - Karasian_Warning1")
	end
end

function Karasian_Warning2(Var)
cExecCheck "Karasian_Warning2"
	------cDebugLog("Karasian_Warning2")
	cNPCChat(Var.Handle, "BH_Helga_Wake")
	Karasian_BattleStart(Var)
end

function Karasian_BuffToBijou(Var)
cExecCheck "Karasian_BuffToBijou"
	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 1
	Var.Wait.NextFunc = Karasian_BuffToBijou2
	Var.Wait.Rtn = ReturnAI.END

	Var.StepFunc = Common_Wait
	--cDebugLog("Common_Wait - Karasian_BuffToBijou")
end

function Karasian_BuffToBijou2(Var)
cExecCheck "Karasian_BuffToBijou2"

	if cIsObjectDead(Var.Handle) == nil then
		cSetAbstate(Var.BijouInfo.Handle, BijouBuffByKarasian, 1, 1500)
		cSetAbstate(Var.BijouInfo.HelgaInfo.Handle, HelgaBufByKarasian, 1, 1500)
		----cDebugLog("Karasian[" .. Var.Handle .. "] Buff Bijou[" .. Var.BijouInfo.Handle .. "] at " .. cCurSec())
	end

	Var.StepFunc = Karasian_BuffToBijou
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Karasian_BattleStart(Var)
cExecCheck "Karasian_BattleStart"
	----cDebugLog "Karasian_BattleStart"
	Var.BijouInfo.HelgaInfo.StepFunc = Helga_Awake
----cDebugLog "Karasian_BattleStart 1"
	Helga_AllKarasianStepFunc(Var.BijouInfo.HelgaInfo, Karasian_BuffToBijou)
----cDebugLog "Karasian_BattleStart 2"
	Helga_AllBijouStepFunc(Var.BijouInfo.HelgaInfo, Bijou_WaitBuffing)
----cDebugLog "Karasian_BattleStart 3"
end



-------------------------------------------------------------------------
-----------------------    InvisibleMan Part   --------------------------
-------------------------------------------------------------------------
-- �������� ����� ������Ʈ

function InvisibleMan(Handle, MapIndex)
cExecCheck "InvisibleMan"
	local Var = MemBlock[Handle]
	if Var == nil then
		----cDebugLog("InvisibleMan Handle Error:" .. Handle)
		return
	end

	Var.StepFunc(Var)

	return ReturnAI.END
end

function Invisible_Init(Var)
cExecCheck "Invisible_Init"
	cDebugLog "Invisible_Init"

	cGroupRegen("BH_Helga", "BH_HelgaBox")	-- ���ڰ� ��������

	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 60
	Var.Wait.NextFunc = Invisible_AllVanish
	Var.Wait.Rtn = ReturnAI.END
	Var.StepFunc = Common_Wait
	cDebugLog("Common_Wait - Invisible_Init")
end


function Invisible_AllVanish(Var)
cExecCheck "Invisible_AllVanish"
	cDebugLog "Invisible_AllVanish"

	Common_RemoveTreasure(Var.MapIndex)
	cNPCVanish(Var.Handle)

	Var.StepFunc = Common_Nothing
end
