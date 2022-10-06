-- �������� ���� ��ũ��Ʈ
-- ��ų 1 : �����ð� �������� ������ �̻� �޾��� �� �ߵ�
-- ��ų 2 : HP�� ���� �ߵ�

-- ��ũ��Ʈ�� ���ϰ�
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- ��� AI��ƾ ��
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- ��Ʒ� �Ϻ� ó���� �� cpp�� AI��ƾ ����


-- ��� ����
C = {}
C.Immune = {}		-- ������ �鿪 ��ų
C.Immune.SkillIndex = "Psy_Psyken_Skill_N_MRS"	-- ��ų �̸� -- MobAttackSequence������ ����
C.Immune.Interval = 20	-- 20�� �� 20000 �̻��� �������� �޾��� ��
C.Immune.Damage = 50000	--

C.SummonTable = {}	-- �ʻ�� ���̺�
C.SummonTable[1] = {}
C.SummonTable[1].HPRate = 950	-- 95% ������ �� �ѹ� ���
C.SummonTable[1].Summon = {}
C.SummonTable[1].Summon[1] = "Psy_PsykenDog"
--C.SummonTable[1].Summon[2] = "Psy_PsykenDog"
-- PsykenDog 2���� ��ȯ(�� ������ C.SummonTable[1].Summon[3] ���Ŀ� �߰�

C.SummonTable[2] = {}
C.SummonTable[2].HPRate = 700	-- 70% ������ �� �ѹ� ���
C.SummonTable[2].Summon = {}
C.SummonTable[2].Summon[1] = "Psy_PsykenDog"
C.SummonTable[2].Summon[2] = "Psy_PsykenDog"
--C.SummonTable[2].Summon[3] = "Psy_PsykenDog"
-- PsykenDog 3���� ��ȯ(�� ������ C.SummonTable[2].Summon[3] ���Ŀ� �߰�

C.SummonTable[3] = {}
C.SummonTable[3].HPRate = 300	-- 30% ������ �� �ѹ� ���
C.SummonTable[3].Summon = {}
C.SummonTable[3].Summon[1] = "Psy_PsykenDog"
C.SummonTable[3].Summon[2] = "Psy_PsykenDog"
C.SummonTable[3].Summon[3] = "Psy_PsykenDog"
-- PsykenDog 3���� ��ȯ(�� ������ C.SummonTable[2].Summon[3] ���Ŀ� �߰�

MemBlock = {}

function Psy_Psyken(Handle, MapIndex)
cExecCheck "Psy_Psyken"

	if cIsObjectDead(Handle) then	-- �׾���
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		MemBlock[Handle] = nil	-- �޸�����
		cDebugLog "Psy_Psyken Dead"
		return
	end

	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex

		Var.LastCheck = cCurSec()	-- 1�ʿ� �ѹ��� üũ�ϱ� ����


		Var.ImmunManage = {}		-- HP ���Ҹ� �����ϴ� ���̺�(�鿪��ų�� ����)
		Var.ImmunManage.QueueHead = 1
		for k = 1, C.Immune.Interval do
			Var.ImmunManage[k] = cObjectHP(Var.Handle)
		end

		Var.NextSummonIndex = 1	-- �ʻ�⸦ ����ϱ� ���� ���̺� C.SummonTable[1].HPRate���� ��ٸ�

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

	-- 1�ʿ� �ѹ��� üũ ����

	local CurHP, MaxHP = cObjectHP(Var.Handle)


	-- HP ������ ����
	Var.ImmunManage.QueueHead = Var.ImmunManage.QueueHead + 1
	if Var.ImmunManage.QueueHead > C.Immune.Interval then
		Var.ImmunManage.QueueHead = 1
	end

	local LastHP = Var.ImmunManage[Var.ImmunManage.QueueHead]
	Var.ImmunManage[Var.ImmunManage.QueueHead] = CurHP

	if LastHP - CurHP > C.Immune.Damage then
		Var.StepFunc = Psyken_ImmunSkill	-- �鿪��ų �ߵ�
		return
	end


	-- HP ����
	if CurHP == MaxHP then
		Var.NextSummonIndex = 1
	else
		local HPRate = CurHP * 1000 / MaxHP
		if C.SummonTable[Var.NextSummonIndex] ~= nil and HPRate < C.SummonTable[Var.NextSummonIndex].HPRate then
			Var.StepFunc = Psyken_Summon		-- ��ȯ��ų
			return
		end
	end
end

function Psyken_ImmunSkill(Var)	-- �鿪��ų �ߵ�
cExecCheck "Psyken_ImmunSkill"

	if cSkillBlast(Var.Handle, Var.Handle, C.Immune.SkillIndex) == nil then  -- ����
		cDebugLog "Psyken_ImmunSkill : Other Skill using"
		return	-- �ٸ� ��ų ������̹Ƿ� ���� - ���� ��ƾ���� �ٽ� �õ�
	end

	cDebugLog "Psyken_ImmunSkill : Blast"

	for k = 1, C.Immune.Interval do
		Var.ImmunManage[k] = cObjectHP(Var.Handle)
	end

	Var.StepFunc = Psyken_Default
end

function Psyken_Summon(Var)		-- ��ȯ��ų
cExecCheck "Psyken_Summon"

	-- ������ ��ų ������
	--if cSkillBlast(Var.Handle, var.Handle, C.SummonTable.SkillIndexA) == nil then  -- ����
	--	cDebugLog "Psyken_SummonA : Other Skill using"
	--	return	-- �ٸ� ��ų ������̹Ƿ� ���� - ���� ��ƾ���� �ٽ� �õ�
	--end
	-- ��ȯ�� ����
	for k = 1, #C.SummonTable[Var.NextSummonIndex].Summon do
		local Handle = cMobRegen_Obj(C.SummonTable[Var.NextSummonIndex].Summon[k], Var.Handle)
		MemBlock[Handle] = {}
		MemBlock[Handle].Handle = Handle
		MemBlock[Handle].Master = Var.Handle
		cAIScriptSet(Handle, Var.Handle)
		cAIScriptFunc(Handle, "Entrance", "PsykenPet") --�Ա��Լ��� PsykenPet
	end

	Var.NextSummonIndex = Var.NextSummonIndex + 1
	Var.StepFunc = Psyken_Default
end

---------------------------------------------------------------

function PsykenPet(Handle, MapIndex)
cExecCheck "Psyken_Summon"


	if cIsObjectDead(Handle) then	-- �׾���
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		MemBlock[Handle] = nil	-- �޸�����
		cDebugLog "Pen Dead"
		return ReturnAI.END
	end

	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = nil
		cNPCVanish(Handle)
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		return ReturnAI.END
	end

	if cIsObjectDead(Var.Master) then -- �������� �׾���
		MemBlock[Handle] = nil
		cNPCVanish(Handle)
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		return ReturnAI.END
	end

	local HP, MaxHP = cObjectHP(Var.Master)
	if HP == MaxHP then	-- ��ȭ���� �ǰ� ���� á��
		MemBlock[Handle] = nil
		cNPCVanish(Handle)
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		return ReturnAI.END
	end

	return ReturnAI.CPP
end
