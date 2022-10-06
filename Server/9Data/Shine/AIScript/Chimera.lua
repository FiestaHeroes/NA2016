-- Ű�޶� ���� ��ũ��Ʈ
-- ��ų 1 : �����ð� �������� ������ �̻� �޾��� �� �ߵ�
-- ��ų 2 : HP�� ���� �ߵ�

-- ��ũ��Ʈ�� ���ϰ�
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- ��� AI��ƾ ��
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- ��Ʒ� �Ϻ� ó���� �� cpp�� AI��ƾ ����

--�ι�° Ű�޶� ������Ű�� ��𼱰� Fail
-- ��� ����

--Chimera_Skill_W03_2Target.nif �ҵ��� �������� ����Ʈ �� Ÿ�� ����Ʈ
--Psy_Chimera_Skill_W03_3DOT.nif ��Ʈ����Ʈ
--Psy_Chimera_Skill_W03_3DOTLoop.nif ��Ʈ ���� ����Ʈ


C = {}
C.Immune = {}		-- ������ �鿪 ��ų
C.Immune.SkillIndex = "Chimera_Skill_N_ACS"	-- ��ų �̸�
C.Immune.Interval = 600		-- 600�� �� 500,000 �̻��� �������� �޾��� ��
C.Immune.Damage = 500000	--

C.LethalMoveTime = {}	-- �ʻ�� ���̺�

C.LethalMoveTime[1] = 950	-- 95% ������ �� �ѹ� ���
C.LethalMoveTime[2] = 850	-- 85% ������ �� �ѹ� ���
C.LethalMoveTime[3] = 750	-- 75% ������ �� �ѹ� ���
C.LethalMoveTime[4] = 650	-- 65% ������ �� �ѹ� ���
C.LethalMoveTime[5] = 550	-- 55% ������ �� �ѹ� ���
C.LethalMoveTime[6] = 450	-- 45% ������ �� �ѹ� ��� 
C.LethalMoveTime[7] = 350	-- 35% ������ �� �ѹ� ���
C.LethalMoveTime[8] = 250	-- 25% ������ �� �ѹ� ���
C.LethalMoveTime[9] = 200	-- 20% ������ �� �ѹ� ���
C.LethalMoveTime[10] = 150	-- 15% ������ �� �ѹ� ���
C.LethalMoveTime[11] = 100	-- 10% ������ �� �ѹ� ���
C.LethalMoveTime[12] = 50	-- 5% ������ �� �ѹ� ���
C.LethalMoveTime.Instance = {}								-- ������������ų
C.LethalMoveTime.Instance.SkillIndexPush = "Chimera_Skill_W03_1"	-- ��ų �̸�(������ �ߵ��ϴ� ��ų)
C.LethalMoveTime.Instance.SkillIndexDamage = "Chimera_Skill_W03_2"	-- ��ų �̸�(�ߵ������� ������ 2���������� ����ϱ� ���� ��ų)
C.LethalMoveTime.Instance.Range = 1000							-- ��ų �����Ÿ�
C.LethalMoveTime.Instance.SpotViewSec = 3						-- ��ų �߻� 3�� �� ���������� ���
C.LethalMoveTime.Instance.SpotLifeTime = 7						-- �ҵ�� ����Ʈ�� ���ӽð�
C.LethalMoveTime.Instance.SpotDamageSecond = 4					-- �ҵ�� ����Ʈ �� ������ ��� �ð�
C.LethalMoveTime.Instance.DamageArea = 150						-- ������ ����(������)
C.LethalMoveTime.Instance.Meteor = {}
C.LethalMoveTime.Instance.Meteor.Number = 5						-- �ҵ��� 5���� ������
C.LethalMoveTime.Instance.Meteor.Interval = 0.5					-- 0.5�ʰ���

-- ������ ���Ŀ� ���� ������ ����� ��
C.LethalMoveTime.Instance.MinMA = 10000							-- �������ݷ�
C.LethalMoveTime.Instance.MaxMA = 15000							-- �������ݷ�
C.LethalMoveTime.Instance.MH = 5000								-- ������Ʈ

-- HP�� ���� �������� �޶��� ���
C.LethalMoveTime.Instance.DamageRate = 980                      -- MaxHP�� 98% ������


C.LethalMoveTime.MagicFieldSkill = "Chimera_Skill_W03_2"		-- � ��ų�� ���� �����ʵ�����
C.LethalMoveTime.MagicFieldLocX = 3677							-- �ʵ��� �߽���
C.LethalMoveTime.MagicFieldLocY = 18467
C.LethalMoveTime.MagicFieldWhen = "First"						-- ù("First")/��("Last") �ҵ��̰� �������� ��

C.LethalMoveTime.TotalSecond = 10


MemBlock = {}

function Chimera(Handle, MapIndex)
cExecCheck "Chimera"

	if cIsObjectDead(Handle) then	-- �׾���
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		MemBlock[Handle] = nil	-- �޸�����
		cDebugLog "Chimera Dead"
		return ReturnAI.END
	end

	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex

		Var.LastCheck = cCurSec()	-- 1�ʿ� �ѹ��� üũ�ϱ� ����

		Var.Lethal = {}
		Var.Lethal.SkillBlastSec = 0		-- ��ų�� �ߵ��� �ð� - ��ų �����ϱ� ����

		Var.ImmunManage = {}		-- HP ���Ҹ� �����ϴ� ���̺�(�鿪��ų�� ����)
		Var.ImmunManage.QueueHead = 1
		for k = 1, C.Immune.Interval do
			Var.ImmunManage[k] = cObjectHP(Var.Handle)
		end

		Var.MeteorTargetList = {}	-- �ҵ���� Ÿ�ٵ��� �����ϱ� ���� ���̺�
		Var.MeteorTick = 0.0		-- �ҵ���� �������� �����ϴ� �ð�
		Var.MeteorNumber = 0		-- ������ �ҵ�� ����

		Var.NextLethalIndex = 1	-- �ʻ�⸦ ����ϱ� ���� ���̺� C.LethalMoveTime[1]���� ��ٸ�

		Var.StepFunc = Chimera_Default
	end
	return Var.StepFunc(Var)
end

function Chimera_Default(Var)
cExecCheck "Chimera_Default"

	local CurSec = cCurSec()
	if Var.LastCheck == CurSec then
		return ReturnAI.CPP
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
		Var.StepFunc = Chimera_ImmunSkill	-- �鿪��ų �ߵ�
		return ReturnAI.CPP
	end


	-- HP ����
	if CurHP == MaxHP then
		Var.NextLethalIndex = 1
	else
		local HPRate = CurHP * 1000 / MaxHP
		if C.LethalMoveTime[Var.NextLethalIndex] ~= nil and HPRate < C.LethalMoveTime[Var.NextLethalIndex] then
			Var.NextLethalIndex = Var.NextLethalIndex + 1
			Var.StepFunc = Chimera_LethalMove		-- �ʻ�� �ߵ�
			return ReturnAI.CPP
		end
	end
	return ReturnAI.CPP
end

function Chimera_ImmunSkill(Var)	-- �鿪��ų �ߵ�
cExecCheck "Chimera_ImmunSkill"

	if cSkillBlast(Var.Handle, Var.Handle, C.Immune.SkillIndex) == nil then  -- ����
		cDebugLog "Chimera_ImmunSkill : Other Skill using"
		return ReturnAI.CPP	-- �ٸ� ��ų ������̹Ƿ� ���� - ���� ��ƾ���� �ٽ� �õ�
	end

	cDebugLog "Chimera_ImmunSkill : Blast"

	for k = 1, C.Immune.Interval do
		Var.ImmunManage[k] = cObjectHP(Var.Handle)
	end

	Var.StepFunc = Chimera_Default
	return ReturnAI.CPP
end

function Chimera_LethalMove(Var)		-- �ʻ�� �ߵ�
cExecCheck "Chimera_LethalMove"

	if cSkillBlast(Var.Handle, Var.Handle, C.LethalMoveTime.Instance.SkillIndexPush) == nil then  -- ����
		cDebugLog "Chimera_LethalMove : Other Skill using"
		return ReturnAI.CPP	-- �ٸ� ��ų ������̹Ƿ� ���� - ���� ��ƾ���� �ٽ� �õ�
	end

	cDebugLog "Chimera_LethalMove : Blast"

	Var.Lethal.SkillBlastSec = cCurSec()

	Var.StepFunc = Chimera_Spotting
	return ReturnAI.END
end

function Chimera_Spotting(Var)
cExecCheck "Chimera_Spotting"

	if cCurSec() < Var.Lethal.SkillBlastSec + C.LethalMoveTime.Instance.SpotViewSec then
		return ReturnAI.END
	end

	-- ������ Ÿ�ټ���
	Var.MeteorTargetList = {}	-- �ҵ���� Ÿ�ٵ��� �����ϱ� ���� ���̺�
	local TargetList = {cAggroList(Var.Handle, C.LethalMoveTime.Instance.Range)}	-- Range �ȿ� �ִ� ���� ����Ʈ ����
	local TargetNum = C.LethalMoveTime.Instance.Meteor.Number
	if TargetNum < #TargetList then
		TargetNum = #TargetList
	end

	for k = 1, TargetNum do
		local rnd = cRandomInt(1, #TargetList)
		Var.MeteorTargetList[#Var.MeteorTargetList + 1] = TargetList[rnd]
		-- ������ ���Ҹ� rnd�� �����ְ� ���������� ����
		TargetList[rnd] = TargetList[#TargetList]
		TargetList[#TargetList] = nil
	end
--for k = 1, #Var.MeteorTargetList do
--	cDebugLog("Target : " .. Var.MeteorTargetList[k])
--end

	Var.MeteorTick = cCurrentSecond()		-- �ҵ���� �������� �����ϴ� �ð�
	Var.MeteorNumber = 0		-- ������ �ҵ�� ����

	Var.StepFunc = Chimera_MeteorShower
	return ReturnAI.END
end

function Chimera_MeteorShower(Var)
cExecCheck "Chimera_MeteorShower"

	local CurrentSecond = cCurrentSecond()
	if CurrentSecond < Var.MeteorTick then
		return ReturnAI.END
	end

	if #Var.MeteorTargetList == 0 then -- Ÿ�� ��� ����
		Var.StepFunc = Chimera_SkillEnd
		return ReturnAI.END
	end

	Var.MeteorTick = Var.MeteorTick + C.LethalMoveTime.Instance.Meteor.Interval

	-- ������ Ÿ�� ����
	local TargetHandle = Var.MeteorTargetList[#Var.MeteorTargetList]
	Var.MeteorTargetList[#Var.MeteorTargetList] = nil

	local X, Y = cObjectLocate(TargetHandle)
	if X ~= nil and Y ~= nil then
		local SpotHandle = cEffectRegen_XY(Var.MapIndex, "Chimera_Skill_W03_2Target",							-- x, y ��ġ�� ������Ʈ ���
										-- ���̸�,        ����Ʈ �̸�,
											X,      Y,      0,  C.LethalMoveTime.Instance.SpotLifeTime, 0)
										--	x��ǥ,  y��ǥ, dir, ���ӽð�,                               ����, [������])
		cAIScriptSet(SpotHandle, Var.Handle)
		cAIScriptFunc(SpotHandle, "Entrance", "Effect_TargetSpot") --�Ա��Լ��� HorseMain
		MemBlock[SpotHandle] = {}
		MemBlock[SpotHandle].Handle = SpotHandle
		MemBlock[SpotHandle].X = X
		MemBlock[SpotHandle].Y = Y
		MemBlock[SpotHandle].Chimera = Var
		MemBlock[SpotHandle].ExploseTime = CurrentSecond + C.LethalMoveTime.Instance.SpotDamageSecond

		Var.MeteorNumber = Var.MeteorNumber + 1
		-- �����ʵ� �򸮴� �ҵ���?
		if Var.MeteorNumber == 1 and C.LethalMoveTime.MagicFieldWhen == "First" then
			MemBlock[SpotHandle].MagicField = true
		end
		if #Var.MeteorTargetList == 0 and C.LethalMoveTime.MagicFieldWhen == "Last" then
			MemBlock[SpotHandle].MagicField = true
		end
	end

	return ReturnAI.END
end

function Chimera_SkillEnd(Var)
	if cCurSec() > Var.Lethal.SkillBlastSec + C.LethalMoveTime.TotalSecond then
		Var.StepFunc = Chimera_Default
		cDebugLog "SkillEnd"
	end

	return ReturnAI.CPP	-- SkillEndWait���� ��ٸ��� ���� ������� Ǯ���� �ʵ���
end

--------------------------------------------------------

function Effect_TargetSpot(Handle, MapIndex)
cExecCheck "Effect_TargetSpot"

	local Var = MemBlock[Handle]
	if Var == nil then
		cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
		return
	end

	if cCurrentSecond() < Var.ExploseTime then
		return
	end

	cDebugLog "Effect_TargetSpot : Explose"
	local ChimeraHandle = Var.Chimera.Handle
	local TargetList = {cGetTargetList(ChimeraHandle, Var.X, Var.Y, C.LethalMoveTime.Instance.DamageArea)}
			-- cGetTargetList�� ����� �ڵ� �������̹Ƿ� �� �ڵ���� �ϳ��� ���̺�� ����

	for k = 1, #TargetList do
		local Target = TargetList[k]
		if Target ~= nil then

			-- CPP�� ������ ���Ŀ� ���� ������ ���
			--local Damage = cSkillDamageCalculate(Var.Handle, C.LethalMoveTime.Instance.SkillIndexDamage, Target, C.LethalMoveTime.Instance)

			-- HP�� ���� �������� �޶���
			local CurHP, MaxHP = cObjectHP(Target)
			local Damage = MaxHP * C.LethalMoveTime.Instance.DamageRate / 1000.


			-- target�� ������ ����
			if Damage ~= nil then
				cDamaged(Target, Damage, Var.Handle)
			end
		end
	end

	if Var.MagicField then
		cDebugLog "MagicField Spread"
		cMagicFieldSpread(ChimeraHandle, C.LethalMoveTime.MagicFieldLocX, C.LethalMoveTime.MagicFieldLocY, 0, C.LethalMoveTime.MagicFieldSkill, 1)
											-- Tick, Keep, DOT �� �����ʵ� ������ ���̺�� ����
	end

	cAIScriptSet(Handle)	-- ��ũ��Ʈ ����
	MemBlock[Handle] = nil
end
