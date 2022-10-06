--[[
보스 상위버전 - 후마르

9Data/Here/World/FineScript.txt 필요
9Data/Hero/Script/BH_Humar.txt 필요
]]

-- 스크립트의 리턴값
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림


--BossIndex = "BH_Humar"
FellowIndex = {}
FellowIndex[1] = "BH_Looter"
FellowIndex[2] = "BH_Guardian"

HumarBuffSkill = "BH_Humar_Skill_N_APU"
HumarBuffAbState = "StaMobAPU01"
HumarBuffSec = 60

SummonSkillName = "BH_Humar_Skill_S"
SummonSkillCastSecond = 5

--어그로 제거시 부하 없애고 inactiv상태로
SummonRate = {}
SummonRate[1] = 750		-- 75%, 50%, 25%에서 한번씩 부하들 리젠
SummonRate[2] = 500
SummonRate[3] = 250
SummonRate[4] = 0		-- 마지막은 항상 0인것 추가 필요

MemBlock = {}

----------------------------------------------------------------------
-- Mantis 7984
-- 보물상자 소환 정보
BH_HumarBox =
{
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O", 	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O_02",	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O_03",	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
	{ Index = "BH_Humar_X", ItemDropMobIndex = "BH_Humar_O_04",	x = 3060, y =  3126, width = 303, height = 494, rotate = 4 },
}
----------------------------------------------------------------------

function Common_RemoveTreasure(MapIndex)
cExecCheck "Common_RemoveTreasure"
	cDebugLog "Common_RemoveTreasure"

	cRegenGroupActiv("BH_Cracker", "BH_HumarBox", 0)	-- 상자가 나오지 않도록(세번째 인수를 생략하거나 1이면 activ)
--	cVanishAll(MapIndex, "BH_Humar_O")
--	cVanishAll(MapIndex, "BH_Humar_O_02")
--	cVanishAll(MapIndex, "BH_Humar_O_03")
--	cVanishAll(MapIndex, "BH_Humar_O_04")
	cVanishAll(MapIndex, "BH_Humar_X")
end


-- 부하들은 스크립트처리 안함 - CPP 루틴 사용

------------------------------------------------------------------
-----------------------    Humar Part   --------------------------
------------------------------------------------------------------

function BH_Humar(Handle, MapIndex)
cExecCheck "BH_Humar"
	local Var = MemBlock[Handle]
	if cIsObjectDead(Handle) ~= nil then
		if Var ~= nil then   -- 보스가 죽었음
			cDebugLog("Boss Dead")
			for k = 1, 2 do
				if Var.FellowHandle[k] ~= -1 then
					cNPCVanish(Var.FellowHandle[k])
					Var.FellowHandle[k] = -1
				end
			end

			-- 투명인간 소환 - 보물상자 제어용
			local InvisibleHandle = cMobRegen_Obj("InvisibleMan", Handle)
			cAIScriptSet(InvisibleHandle, Handle) -- 비쥬의 AI스크립트를 Var.Handle(헬가)의 AI스크립트로 세팅
			MemBlock[InvisibleHandle] = {}
			MemBlock[InvisibleHandle].Handle = InvisibleHandle
			MemBlock[InvisibleHandle].MapIndex = MapIndex
			MemBlock[InvisibleHandle].StepFunc = Invisible_Init

			MemBlock[Handle] = nil
		end
		return ReturnAI.END
	end


	if Var == nil then    -- 처음 리젠되었음
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]

		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.FellowHandle = {}
		Var.FellowHandle[1] = -1
		Var.FellowHandle[2] = -1

		Var.NextSummonIndex = 1
		Var.BoxVanish = 0		-- 10초에 한번씩 박스를 지우기 위해

		Var.TargetLostSec = 0 	-- 타겟을 잃은 시간
		Var.NextBuff = 0		-- 다음번 버프받을 시간

		Var.Wait = {}
		Var.Wait.Second = 0;
		Var.Wait.NextFunc = nil

		Var.StepFunc = Boss_WaitInvader
	end

	return Var.StepFunc(Var)
end

function Boss_Wait(Var)  -- Var.Wait.Second까지 기다린 후 StepFunc을 WaitFunction으로 세팅
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
		Var.StepFunc = Boss_WaitInvader	-- 전투 끝, 피 회복되었음
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

	-- 부하들 죽었는지 확인
	for fel = 1, 2 do
		if Var.FellowHandle[fel] ~= -1 and cIsObjectDead(Var.FellowHandle[fel]) ~= nil then
			Var.FellowHandle[fel] = -1
		end
	end


	if cTargetHandle(Var.Handle) ~= nil then  -- 타겟 있음
		Var.TargetLostSec = cCurSec()
	elseif Var.TargetLostSec + 10 < cCurSec() then	-- 타겟 사라짐
		Var.StepFunc = Boss_WaitInvader

		cResetAbstate(Var.Handle, HumarBuffAbState)	-- 버프 해제

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
-- 보물상자 제어용 오브젝트

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

	----------------------------------------------------------------------
	-- Mantis 7984
	-- ※ 보물상제 소환 및 아이템드랍그룹 몬스터 셋팅
	for i = 1, #BH_HumarBox
	do
		local BoxHandle = cMobRegen_Rectangle( Var["MapIndex"], BH_HumarBox[i]["Index"], BH_HumarBox[i]["x"], BH_HumarBox[i]["y"], BH_HumarBox[i]["width"], BH_HumarBox[i]["height"], BH_HumarBox[i]["rotate"] )
		if BoxHandle ~= nil
		then
			cSetItemDropMobID( BoxHandle, BH_HumarBox[i]["ItemDropMobIndex"] )
		end
	end
	----------------------------------------------------------------------

	cGroupRegen("BH_Cracker", "BH_HumarBox")	-- 상자가 나오도록


	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 60
	Var.StepFunc = Invisible_AllVanish
end

function Invisible_AllVanish(Var)
cExecCheck "Invisible_AllVanish"

	if cCurSec() > Var.Wait.Second then
		cDebugLog "Invisible_AllVanish"
		cRegenGroupActiv("BH_Cracker", "BH_HumarBox", 0)	-- 상자가 나오지 않도록(세번째 인수를 생략하거나 1이면 activ)

		Common_RemoveTreasure(Var.MapIndex)
		cNPCVanish(Var.Handle)

		Var.StepFunc = nil
	end
end
