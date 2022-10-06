-- 프시켄을 위한 스크립트
-- 스킬 1 : 일정시간 데미지를 일정량 이상 받았을 때 발동
-- 스킬 2 : HP에 따라 발동

-- 스크립트의 리턴값
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림


-- 상수 정의
C = {}
C.Immune = {}		-- 데미지 면역 스킬
C.Immune.SkillIndex = "Psy_Psyken_Skill_N_MRS"	-- 스킬 이름 -- MobAttackSequence에서는 제거
C.Immune.Interval = 20	-- 20초 내 20000 이상의 데미지를 받았을 때
C.Immune.Damage = 50000	--

C.SummonTable = {}	-- 필살기 테이블
C.SummonTable[1] = {}
C.SummonTable[1].HPRate = 950	-- 95% 이하일 때 한번 사용
C.SummonTable[1].Summon = {}
C.SummonTable[1].Summon[1] = "Psy_PsykenDog"
--C.SummonTable[1].Summon[2] = "Psy_PsykenDog"
-- PsykenDog 2마리 소환(더 있으면 C.SummonTable[1].Summon[3] 이후에 추가

C.SummonTable[2] = {}
C.SummonTable[2].HPRate = 700	-- 70% 이하일 때 한번 사용
C.SummonTable[2].Summon = {}
C.SummonTable[2].Summon[1] = "Psy_PsykenDog"
C.SummonTable[2].Summon[2] = "Psy_PsykenDog"
--C.SummonTable[2].Summon[3] = "Psy_PsykenDog"
-- PsykenDog 3마리 소환(더 있으면 C.SummonTable[2].Summon[3] 이후에 추가

C.SummonTable[3] = {}
C.SummonTable[3].HPRate = 300	-- 30% 이하일 때 한번 사용
C.SummonTable[3].Summon = {}
C.SummonTable[3].Summon[1] = "Psy_PsykenDog"
C.SummonTable[3].Summon[2] = "Psy_PsykenDog"
C.SummonTable[3].Summon[3] = "Psy_PsykenDog"
-- PsykenDog 3마리 소환(더 있으면 C.SummonTable[2].Summon[3] 이후에 추가

MemBlock = {}

function Psy_Psyken(Handle, MapIndex)
cExecCheck "Psy_Psyken"

	if cIsObjectDead(Handle) then	-- 죽었음
		cAIScriptSet(Handle)	-- 스크립트 없앰
		MemBlock[Handle] = nil	-- 메모리해제
		cDebugLog "Psy_Psyken Dead"
		return
	end

	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex

		Var.LastCheck = cCurSec()	-- 1초에 한번씩 체크하기 위해


		Var.ImmunManage = {}		-- HP 감소를 감시하는 테이블(면역스킬을 위한)
		Var.ImmunManage.QueueHead = 1
		for k = 1, C.Immune.Interval do
			Var.ImmunManage[k] = cObjectHP(Var.Handle)
		end

		Var.NextSummonIndex = 1	-- 필살기를 사용하기 위한 테이블 C.SummonTable[1].HPRate까지 기다림

		Var.StepFunc = Psyken_Default
	end
	Var.StepFunc(Var)
	return ReturnAI.CPP
end

function Psyken_Default(Var)
cExecCheck "Psyken_Default"

	local CurSec = cCurSec()
	if Var.LastCheck == CurSec then
		return
	end

	Var.LastCheck = CurSec

	-- 1초에 한번씩 체크 시작

	local CurHP, MaxHP = cObjectHP(Var.Handle)


	-- HP 감소율 감시
	Var.ImmunManage.QueueHead = Var.ImmunManage.QueueHead + 1
	if Var.ImmunManage.QueueHead > C.Immune.Interval then
		Var.ImmunManage.QueueHead = 1
	end

	local LastHP = Var.ImmunManage[Var.ImmunManage.QueueHead]
	Var.ImmunManage[Var.ImmunManage.QueueHead] = CurHP

	if LastHP - CurHP > C.Immune.Damage then
		Var.StepFunc = Psyken_ImmunSkill	-- 면역스킬 발동
		return
	end


	-- HP 감시
	if CurHP == MaxHP then
		Var.NextSummonIndex = 1
	else
		local HPRate = CurHP * 1000 / MaxHP
		if C.SummonTable[Var.NextSummonIndex] ~= nil and HPRate < C.SummonTable[Var.NextSummonIndex].HPRate then
			Var.StepFunc = Psyken_Summon		-- 소환스킬
			return
		end
	end
end

function Psyken_ImmunSkill(Var)	-- 면역스킬 발동
cExecCheck "Psyken_ImmunSkill"

	if cSkillBlast(Var.Handle, Var.Handle, C.Immune.SkillIndex) == nil then  -- 실패
		cDebugLog "Psyken_ImmunSkill : Other Skill using"
		return	-- 다른 스킬 사용중이므로 실패 - 다음 루틴에서 다시 시도
	end

	cDebugLog "Psyken_ImmunSkill : Blast"

	for k = 1, C.Immune.Interval do
		Var.ImmunManage[k] = cObjectHP(Var.Handle)
	end

	Var.StepFunc = Psyken_Default
end

function Psyken_Summon(Var)		-- 소환스킬
cExecCheck "Psyken_Summon"

	-- 적당한 스킬 넣을것
	--if cSkillBlast(Var.Handle, var.Handle, C.SummonTable.SkillIndexA) == nil then  -- 실패
	--	cDebugLog "Psyken_SummonA : Other Skill using"
	--	return	-- 다른 스킬 사용중이므로 실패 - 다음 루틴에서 다시 시도
	--end
	-- 소환물 리젠
	for k = 1, #C.SummonTable[Var.NextSummonIndex].Summon do
		local Handle = cMobRegen_Obj(C.SummonTable[Var.NextSummonIndex].Summon[k], Var.Handle)
		MemBlock[Handle] = {}
		MemBlock[Handle].Handle = Handle
		MemBlock[Handle].Master = Var.Handle
		cAIScriptSet(Handle, Var.Handle)
		cAIScriptFunc(Handle, "Entrance", "PsykenPet") --입구함수는 PsykenPet
	end

	Var.NextSummonIndex = Var.NextSummonIndex + 1
	Var.StepFunc = Psyken_Default
end

---------------------------------------------------------------

function PsykenPet(Handle, MapIndex)
cExecCheck "Psyken_Summon"


	if cIsObjectDead(Handle) then	-- 죽었음
		cAIScriptSet(Handle)	-- 스크립트 없앰
		MemBlock[Handle] = nil	-- 메모리해제
		cDebugLog "Pen Dead"
		return ReturnAI.END
	end

	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = nil
		cNPCVanish(Handle)
		cAIScriptSet(Handle)	-- 스크립트 없앰
		return ReturnAI.END
	end

	if cIsObjectDead(Var.Master) then -- 프시켄이 죽었음
		MemBlock[Handle] = nil
		cNPCVanish(Handle)
		cAIScriptSet(Handle)	-- 스크립트 없앰
		return ReturnAI.END
	end

	local HP, MaxHP = cObjectHP(Var.Master)
	if HP == MaxHP then	-- 평화모드로 피가 가득 찼음
		MemBlock[Handle] = nil
		cNPCVanish(Handle)
		cAIScriptSet(Handle)	-- 스크립트 없앰
		return ReturnAI.END
	end

	return ReturnAI.CPP
end
