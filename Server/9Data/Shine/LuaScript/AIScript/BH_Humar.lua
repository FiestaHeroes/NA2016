--[[
���� �������� - �ĸ���

9Data/Here/World/FineScript.txt �ʿ�
9Data/Hero/Script/BH_Humar.txt �ʿ�
]]

-- ��ũ��Ʈ�� ���ϰ�
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- ��� AI��ƾ ��
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- ��Ʒ� �Ϻ� ó���� �� cpp�� AI��ƾ ����


--BossIndex = "BH_Humar"
FellowIndex = {}
FellowIndex[1] = "BH_Looter"
FellowIndex[2] = "BH_Guardian"

HumarBuffSkill = "BH_Humar_Skill_N_APU"
HumarBuffAbState = "StaMobAPU01"
HumarBuffSec = 60

SummonSkillName = "BH_Humar_Skill_S"
SummonSkillCastSecond = 5

--��׷� ���Ž� ���� ���ְ� inactiv���·�
SummonRate = {}
SummonRate[1] = 750		-- 75%, 50%, 25%���� �ѹ��� ���ϵ� ����
SummonRate[2] = 500
SummonRate[3] = 250
SummonRate[4] = 0		-- �������� �׻� 0�ΰ� �߰� �ʿ�

MemBlock = {}

----------------------------------------------------------------------
-- Mantis 7984
-- �������� ��ȯ ����
BH_HumarBox =
{
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O", 	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O_02",	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O_03",	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O_04",	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
}
HumarBox_VanishTime = 60 -- Time for Chests to Despawn.
HumarBox_ChestsSpawns = 24 -- Chest Amount to Spawn.
----------------------------------------------------------------------
HumarBox_VanishTime = 60 -- When Chests despawn.
HumarBox_ChestsSpawns = 24 -- How many Chests should spawn.


function Common_RemoveTreasure(MapIndex)
cExecCheck "Common_RemoveTreasure"
	cDebugLog "Common_RemoveTreasure"

	cRegenGroupActiv("BH_Cracker", "BH_HumarBox", 0)	-- ���ڰ� ������ �ʵ���(����° �μ��� �����ϰų� 1�̸� activ)
--	cVanishAll(MapIndex, "BH_Humar_O")
--	cVanishAll(MapIndex, "BH_Humar_O_02")
--	cVanishAll(MapIndex, "BH_Humar_O_03")
--	cVanishAll(MapIndex, "BH_Humar_O_04")
	cVanishAll(MapIndex, "BH_Humar_X")
end


-- ���ϵ��� ��ũ��Ʈó�� ���� - CPP ��ƾ ���

------------------------------------------------------------------
-----------------------    Humar Part   --------------------------
------------------------------------------------------------------

function BH_Humar(Handle, MapIndex)
cExecCheck "BH_Humar"
	local Var = MemBlock[Handle]
	if cIsObjectDead(Handle) ~= nil then
		if Var ~= nil then   -- ������ �׾���
			cDebugLog("Boss Dead")
			for k = 1, 2 do
				if Var.FellowHandle[k] ~= -1 then
					cNPCVanish(Var.FellowHandle[k])
					Var.FellowHandle[k] = -1
				end
			end

			-- �����ΰ� ��ȯ - �������� �����
			local InvisibleHandle = cMobRegen_Obj("InvisibleMan", Handle)
			cAIScriptSet(InvisibleHandle, Handle) -- ������ AI��ũ��Ʈ�� Var.Handle(�ﰡ)�� AI��ũ��Ʈ�� ����
			MemBlock[InvisibleHandle] = {}
			MemBlock[InvisibleHandle].Handle = InvisibleHandle
			MemBlock[InvisibleHandle].MapIndex = MapIndex
			MemBlock[InvisibleHandle].StepFunc = Invisible_Init

			MemBlock[Handle] = nil
		end
		return ReturnAI.END
	end


	if Var == nil then    -- ó�� �����Ǿ���
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]

		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.FellowHandle = {}
		Var.FellowHandle[1] = -1
		Var.FellowHandle[2] = -1

		Var.NextSummonIndex = 1
		Var.BoxVanish = 0		-- 10�ʿ� �ѹ��� �ڽ��� ����� ����

		Var.TargetLostSec = 0 	-- Ÿ���� ���� �ð�
		Var.NextBuff = 0		-- ������ �������� �ð�

		Var.Wait = {}
		Var.Wait.Second = 0;
		Var.Wait.NextFunc = nil

		Var.StepFunc = Boss_WaitInvader
	end

	return Var.StepFunc(Var)
end

function Boss_Wait(Var)  -- Var.Wait.Second���� ��ٸ� �� StepFunc�� WaitFunction���� ����
cExecCheck "Boss_Wait"
	if cCurSec() >= Var.Wait.Second then
		Var.StepFunc = Var.Wait.NextFunc
	end
end

function Boss_WaitInvader(Var)
cExecCheck "Boss_WaitInvader"

	local CurSecond = cCurSec()
	if CurSecond > Var.BoxVanish then
		Common_RemoveTreasure(Var.MapIndex)
		Var.BoxVanish = CurSecond + 10
	end


	local hp
	local maxhp
	hp, maxhp = cObjectHP(Var.Handle)
	if hp < maxhp then
		Var.NextBuff = cCurSec() + HumarBuffSec
		Var.StepFunc = Boss_SummonCheck
	end

	if hp == maxhp and Var.NextSummonIndex ~= 1 then
		Var.NextSummonIndex = 1
		cDebugLog "Summon Reset"
	end

	return ReturnAI.END
end

function Boss_BuffCheck(Var)
cExecCheck "Boss_BuffCheck"
	hp, maxhp = cObjectHP(Var.Handle)
	if hp == maxhp then
		Var.StepFunc = Boss_WaitInvader	-- ���� ��, �� ȸ���Ǿ���
		return
	end

	if cCurSec() >= Var.NextBuff then
		cDebugLog "Buffing"
		if cNPCSkillUse(Var.Handle, Var.Handle, HumarBuffSkill) ~= nil then
			Var.NextBuff = cCurSec() + HumarBuffSec
		else
			cDebugLog "Fail"
		end
	end

	Var.StepFunc = Boss_SummonCheck
end

function Boss_SummonCheck(Var)
cExecCheck "Boss_SummonCheck"
	local hp
	local maxhp
	hp, maxhp = cObjectHP(Var.Handle)
	if hp * 1000 < maxhp * SummonRate[Var.NextSummonIndex] and cNPCSkillUse(Var.Handle, Var.Handle, SummonSkillName) == 1 then
		cDebugLog("Summon Index " .. Var.NextSummonIndex)
		Var.NextSummonIndex = Var.NextSummonIndex + 1

		Var.Wait.Second = cCurSec() + SummonSkillCastSecond
		Var.Wait.NextFunc = Boss_SummomFellow

		Var.StepFunc = Boss_Wait
		return
	end

	-- ���ϵ� �׾����� Ȯ��
	for fel = 1, 2 do
		if Var.FellowHandle[fel] ~= -1 and cIsObjectDead(Var.FellowHandle[fel]) ~= nil then
			Var.FellowHandle[fel] = -1
		end
	end


	if cTargetHandle(Var.Handle) ~= nil then  -- Ÿ�� ����
		Var.TargetLostSec = cCurSec()
	elseif Var.TargetLostSec + 10 < cCurSec() then	-- Ÿ�� �����
		Var.StepFunc = Boss_WaitInvader

		cResetAbstate(Var.Handle, HumarBuffAbState)	-- ���� ����

		-- Remove fallows
		for k = 1, 2 do
			if Var.FellowHandle[k] ~= -1 then
				cNPCVanish(Var.FellowHandle[k])
				Var.FellowHandle[k] = -1
			end
		end
	end

	Var.StepFunc = Boss_BuffCheck

	return ReturnAI.CPP
end

function Boss_SummomFellow(Var)
cExecCheck "Boss_SummomFellow"
	local summon = false
	for fel = 1, 2 do
		if Var.FellowHandle[fel] == -1 then
			Var.FellowHandle[fel] = cMobRegen_Obj(FellowIndex[fel], Var.Handle)
			summon = true
		end
	end
	if summon then
		cNPCChat(Var.Handle, "BH_Humar_Sum")
	end
	Var.StepFunc = Boss_SummonCheck
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

	if Var.StepFunc ~= nil then
		Var.StepFunc(Var)
	end

	return ReturnAI.END
end

function Invisible_Init(Var)
cExecCheck "Invisible_Init"
    cDebugLog "Invisible_Init"

    math.randomseed(os.time())
    local mobtable = {}
	for i = 1, HumarBox_ChestsSpawns do
		local box = BH_HumarBox[((i - 1) % #BH_HumarBox) + 1]
		mobtable[i] = cMobRegen_Rectangle(
			Var["MapIndex"],
			box["Index"],
			box["x"],
			box["y"],
			box["width"],
			box["height"],
			box["rotate"]
		)
	end

    local randomnumbers = {}
    for i = 1, #BH_HumarBox do
        local num = math.random(1, #mobtable)
        if randomnumbers[num] == nil then
            randomnumbers[num] = true
            cSetItemDropMobID( mobtable[num], BH_HumarBox[i]["ItemDropMobIndex"] )
        else
            i = i - 1
        end
    end

    Var.Wait = {}
    Var.Wait.Second = cCurSec() + HumarBox_VanishTime
    Var.StepFunc = Invisible_AllVanish
end

function Invisible_AllVanish(Var)
cExecCheck "Invisible_AllVanish"

	if cCurSec() > Var.Wait.Second then
		cDebugLog "Invisible_AllVanish"
		cRegenGroupActiv("BH_Cracker", "BH_HumarBox", 0)	-- ���ڰ� ������ �ʵ���(����° �μ��� �����ϰų� 1�̸� activ)

		Common_RemoveTreasure(Var.MapIndex)
		cNPCVanish(Var.Handle)

		Var.StepFunc = nil
	end
end