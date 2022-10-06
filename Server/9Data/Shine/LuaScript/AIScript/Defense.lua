--[[
���潺����
MasterNPC�� WOOD7, GateNPC�� DLich�� �ӽ÷� ����. ���߿� �ٸ� NPC�� �̸� �ٲܰ�
�¸����� : GateNPC�� �����߸��ų� ��� �������� �����Ŵ(Master_Success�Լ����� ó��)
�й����� : ��� NPC �Զ�(Master_Fail���� ó��)
Damage�� Castle�� ���� HP�� ���߾� ���ҽ�Ŵ. - ��û�� �������� ������ ���� ���� �� �ֵ���
		���� ������ ������ 1000, NPC�� ���� HP 900�̸�, �� NPC�� �����߸��� ���� NPC�� 100�� ������
���� ���������� Hold�� SpeedDown � �ɷ��� ��� �ڵ��� ������ Ȯ�� ������, Ȯ���� ����
]]

-- ��ũ��Ʈ�� ���ϰ�
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- ��� AI��ƾ ��
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- ��Ʒ� �Ϻ� ó���� �� cpp�� AI��ƾ ����


Course = {
			{X = 6489, Y =  5994,},
			{X = 6487, Y =  6805,},		-- �ڽ��� �� ��ǥ
			{X = 6609, Y =  6982,},
			{X = 7526, Y =  6882,},
			{X = 7618, Y =  5769,},
			{X = 5428, Y =  5725,},
			{X = 5466, Y =  6878,},
			{X = 6528, Y =  6853,},
			{X = 6585, Y =  7424,},
			{X = 6551, Y =  7943,},
			{X = 6516, Y =  8749,},
			{X = 7091, Y =  8799,},
			{X = 7125, Y =  9306,},
			{X = 6943, Y =  9616,},
			{X = 6550, Y =  9999,},
			{X = 6475, Y = 10418,},
		 }

Castle = {
			{NPC = "Job2_BraveR", X = 6487, Y = 6805, HP = 1000},	-- �� �Ʊ� NPC�� ��ġ, ü��, ID
			{NPC = "Job2_BraveR", X = 7526, Y = 6882, HP = 1000},
			{NPC = "Job2_BraveR", X = 7618, Y = 5769, HP = 1000},
			{NPC = "Job2_BraveR", X = 5428, Y = 5725, HP = 1000},
			{NPC = "Job2_YongE",  X = 6585, Y = 7424, HP = 1000},
			{NPC = "Job2_YongE",  X = 6516, Y = 8749, HP = 1000},
			{NPC = "Job2_YongE",  X = 7091, Y = 8799, HP = 1000},
			{NPC = "Job2_YongE",  X = 6550, Y = 9999, HP = 1000},
		 }

-- MobResist.shn �� ���ǵ� �̸���� ��� ����
ResistNormalMob = {ResDot = 0, ResStun = 0, ResMoveSpeed = 0, ResFear = 0, ResBinding = 0, ResReverse = 0, ResMesmerize = 0, ResSeverBone = 0, ResKnockBack = 0, ResTBMinus = 0}
ResistBossMob   = {ResDot = 0, ResStun = 0, ResMoveSpeed = 0, ResFear = 0, ResBinding = 0, ResReverse = 0, ResMesmerize = 0, ResSeverBone = 0, ResKnockBack = 0, ResTBMinus = 0}

Wave = {
		{Mob = "Slime",       Num = 30, Damage =  300, HP = 3000, EXP = 2, AC =  50, MR =  50, SpeedRate = 300, Interval = 1, Resist = ResistNormalMob,},
		{Mob = "MushRoom",    Num = 30, Damage =  330, HP = 3000, EXP = 3, AC =  50, MR =  50, SpeedRate = 300, Interval = 2, Resist = ResistNormalMob, WaitSecond =  5},
		{Mob = "Crab",        Num = 30, Damage =  370, HP = 3000, EXP = 4, AC =  50, MR =  50, SpeedRate = 300, Interval = 3, Resist = ResistNormalMob, WaitSecond =  5},
		{Mob = "Honeying",    Num = 30, Damage =  400, HP = 3000, EXP = 5, AC =  50, MR =  50, SpeedRate = 290, Interval = 3, Resist = ResistNormalMob, WaitSecond =  5},
		{Mob = "Boogy",       Num = 30, Damage =  430, HP = 3000, EXP = 6, AC =  50, MR =  50, SpeedRate = 320, Interval = 3, Resist = ResistNormalMob, WaitSecond = 10},
		{Mob = "Kebing",      Num = 30, Damage =  470, HP = 3000, EXP = 7, AC =  50, MR =  50, SpeedRate = 290, Interval = 3, Resist = ResistNormalMob, WaitSecond = 10},
		{Mob = "MageBook",    Num = 30, Damage =  500, HP = 3000, EXP = 8, AC =  50, MR =  50, SpeedRate = 290, Interval = 3, Resist = ResistNormalMob, WaitSecond = 10},
		{Mob = "Skeleton",    Num = 30, Damage =  530, HP = 3000, EXP = 9, AC =  50, MR =  50, SpeedRate = 215, Interval = 4, Resist = ResistNormalMob, WaitSecond = 10},
		{Mob = "Bat",         Num = 30, Damage =  570, HP = 3000, EXP = 2, AC =  50, MR =  50, SpeedRate = 290, Interval = 4, Resist = ResistNormalMob, WaitSecond = 15},
		{Mob = "Spider",      Num =  3, Damage = 1000, HP = 5000, EXP = 2, AC = 100, MR = 100, SpeedRate = 290, Interval = 4, Resist = ResistBossMob,   WaitSecond = 15},
		{Mob = "FlyingStaff", Num = 20, Damage =  630, HP = 3000, EXP = 2, AC =  50, MR =  50, SpeedRate = 320, Interval = 4, Resist = ResistNormalMob, WaitSecond = 15},
		{Mob = "Zombie",      Num = 20, Damage =  670, HP = 3000, EXP = 2, AC =  50, MR =  50, SpeedRate = 215, Interval = 5, Resist = ResistNormalMob, WaitSecond = 15},
		{Mob = "OldFox",      Num = 20, Damage =  700, HP = 3000, EXP = 2, AC =  50, MR =  50, SpeedRate = 290, Interval = 5, Resist = ResistNormalMob, WaitSecond = 15},
		{Mob = "FireViVi",    Num = 20, Damage =  730, HP = 3000, EXP = 2, AC =  50, MR =  50, SpeedRate = 290, Interval = 5, Resist = ResistNormalMob, WaitSecond = 15},
		{Mob = "Ghost",       Num =  1, Damage = 3000, HP = 8000, EXP = 2, AC = 300, MR = 300, SpeedRate = 250, Interval = 5, Resist = ResistBossMob,   WaitSecond = 25},
	   } 	-- �� ���̺��� ��, ������, ü��, ����, ����, �ӵ�(õ����), ID, ���� ���� ���ð�


GateLoc = {X = 6444, Y = 5734, HP = 50000, AC = 1000, MR = 1000, EXP = 0}	-- ����Ʈ�� ��ġ, ü��, ����
-- Hold

MemBlock = {}
MainHandle = nil

function DefenseStart(act)
cExecCheck "DefenseStart"
	MemBlock[MainHandle].StepFunc = Master_Start
end

function Dummy()
	return ReturnAI.END
end

function WOOD7(Handle, MapIndex)
cExecCheck "WOOD7"
	local Var = MemBlock[Handle]
	if Var == nil then
		MainHandle = Handle
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.StepFunc = Dummy
	end
	Var.StepFunc(Var)
	return ReturnAI.END
end

function Master_Start(Var)
cExecCheck "Master_Start"

	Var.Castle = {}
	for k = 1, #Castle do
		Var.Castle[k] = {}
		Var.Castle[k].Master = Var
		Var.Castle[k].Handle = cMobRegen_XY(Var.MapIndex, Castle[k].NPC, Castle[k].X, Castle[k].Y, 180)
		cAIScriptSet(Var.Castle[k].Handle, Var.Handle)
		cAIScriptFunc(Var.Castle[k].Handle, "Entrance", "CastleMain") --�Ա��Լ��� HorseMain
		cSetNPCParam(Var.Castle[k].Handle, "MaxHP", Castle[k].HP)
		cSetNPCParam(Var.Castle[k].Handle, "HP", Castle[k].HP)
		MemBlock[Var.Castle[k].Handle] = Var.Castle[k]
	end
	Var.TargetCastle = 1

	Var.Gate = {}
	Var.Gate.Master = Var
	Var.Gate.Handle = cMobRegen_XY(Var.MapIndex, "DLich", GateLoc.X, GateLoc.Y, 0)
	cAIScriptSet(Var.Gate.Handle, Var.Handle)
	cSetNPCParam(Var.Gate.Handle, "MaxHP", GateLoc.HP)
	cSetNPCParam(Var.Gate.Handle, "EXP",   GateLoc.EXP)
	cSetNPCParam(Var.Gate.Handle, "HP",    GateLoc.HP)
	cSetNPCParam(Var.Gate.Handle, "AC",    GateLoc.AC)
	cSetNPCParam(Var.Gate.Handle, "MR",    GateLoc.MR)
	cSetNPCIsItemDrop(Var.Gate.Handle, 0)
	Var.Gate.ActivRunner = 0	-- Ȱ������ ���ϵ�
	Var.Gate.RegenTick = cCurSec()
	Var.Gate.Wave = {}
	Var.Gate.Wave.Step = 1
	Var.Gate.Wave.Number = 0
	Var.Gate.StepFunc = Gate_Summon
	MemBlock[Var.Gate.Handle] = Var.Gate
	cNPCChatTest(Var.Gate.Handle, "Wave 1 Start")

	Var.StepFunc = Dummy
end

-- -- --  -- --  -- --  -- --  -- --  -- --  -- --  -- --  -- --  -- --  -- --  -- --

function Master_Success(Var)
cExecCheck "Master_Success"
	cDebugLog("����")
	for k = 1, #Castle do
		if MemBlock[Var.Castle[k].Handle] ~= nil then
			cDebugLog(" Castle vanish " .. Var.Castle[k].Handle)
			cNPCVanish(Var.Castle[k].Handle);
			Var.Castle[k] = {}
		end
	end
end

function Master_Fail(Var)
cExecCheck "Master_Fail"
	cDebugLog("������")
	cNPCVanish(Var.Gate.Handle)
end

-----------------------------------------------------------------------------------------

function DLich(Handle, MapIndex)
cExecCheck "DLich"
	local Var = MemBlock[Handle]

	if cIsObjectDead(Var.Handle) then
		Master_Success(Var.Master)
		cAIScriptFunc(Var.Handle, "Entrance", "Dummy") --�Ա��Լ��� HorseMain
		return ReturnAI.END
	end

	Var.StepFunc(Var, MapIndex)
	return ReturnAI.END
end

function Gate_Summon(Var, MapIndex)
cExecCheck "Gate_Summon"
	if Var.Wave.Step > #Wave then
		Var.StepFunc = Gate_SummonEnd
		return
	end

	local CurSec = cCurSec()
	if CurSec >= Var.RegenTick + Wave[Var.Wave.Step].Interval then
		local Runner = {}
		--Var.Wave.Step = 1
		--Var.Wave.Number = 0

		Runner.Handle = cMobRegen_XY(MapIndex, Wave[Var.Wave.Step].Mob, GateLoc.X, GateLoc.Y, 0)
		cAIScriptSet(Runner.Handle, Var.Handle)
		cAIScriptFunc(Runner.Handle, "Entrance", "RunnerMain") --�Ա��Լ��� HorseMain
		cSetNPCParam (Runner.Handle, "MaxHP",  Wave[Var.Wave.Step].HP)
		cSetNPCParam (Runner.Handle, "MobEXP", Wave[Var.Wave.Step].EXP)
		cSetNPCParam (Runner.Handle, "HP",     Wave[Var.Wave.Step].HP)
		cSetNPCParam (Runner.Handle, "AC",     Wave[Var.Wave.Step].AC)
		cSetNPCParam (Runner.Handle, "MR",     Wave[Var.Wave.Step].MR)
		cSetNPCResist(Runner.Handle,           Wave[Var.Wave.Step].Resist)
		cSetNPCIsItemDrop(Runner.Handle, 0)
		Runner.Damage = Wave[Var.Wave.Step].Damage
		Runner.SpeedRate = Wave[Var.Wave.Step].SpeedRate
		Runner.Master = Var.Master
		Runner.Gate = Var
		Runner.Interval = 1
		Runner.StepFunc = Runner_Interval
		MemBlock[Runner.Handle] = Runner

		Var.Wave.Number = Var.Wave.Number + 1
		if Var.Wave.Number >= Wave[Var.Wave.Step].Num then
			Var.Wave.Step = Var.Wave.Step + 1
			Var.Wave.Number = 0

			Var.WaitSec = cCurSec() + Wave[Var.Wave.Step].WaitSecond
			Var.StepFunc = Gate_WaitNextWave
			--cNPCChatTest(Var.Handle, "Wave " .. Var.Wave.Step .. " Start")
			return
		end

		Var.RegenTick = CurSec
	end
end

function Gate_SummonEnd(Var)
cExecCheck "Gate_SummonEnd"
	if Var.ActivRunner == 0 then
		Master_Success(Var.Master)
		cNPCVanish(Var.Handle)
	end
	Var.ActivRunner = 0
end

function Gate_WaitNextWave(Var)
cExecCheck "Gate_WaitNextWave"
	if cCurSec() > Var.WaitSec then
		Var.StepFunc = Gate_Summon
	end
end
-----------------------------------------------------------------------------------------

function CastleMain(Handle, MapIndex)
cExecCheck "CastleMain"
	local Var = MemBlock[Handle]
	if cObjectHP(Var.Handle) < 10 then
		MemBlock[Handle] = nil
		cNPCVanish(Var.Handle)
		Var.Master.TargetCastle = Var.Master.TargetCastle + 1
	end

	return ReturnAI.END
end

-----------------------------------------------------------------------------------------

function RunnerMain(Handle, MapIndex)
cExecCheck "RunnerMain"
	local Var = MemBlock[Handle]

	if cIsObjectDead(Var.Gate.Handle) then
		cNPCVanish(Var.Handle)
		return ReturnAI.END
	end

	Var.StepFunc(Var)
	Var.Gate.ActivRunner = Var.Gate.ActivRunner + 1	-- Ȱ������ ���ϵ�
	return ReturnAI.END
end

function Runner_Interval(Var)
cExecCheck "Runner_Interval"
	if cIsObjectDead(Var.Handle) then
		Var.StepFunc = Dummy
		return
	end

	local interval = cRandomInt(10, 25) * 20	-- 200~500
	local intervalsquar = interval * interval
	local cur = {}
	cur.X, cur.Y = cObjectLocate(Var.Handle)
	local goal = {}
	goal.X = Course[Var.Interval].X
	goal.Y = Course[Var.Interval].Y

	-- �Ÿ��� interval ���ϰ� �� ������ ���� ã��
	while true do
		local dx = goal.X - cur.X
		local dy = goal.Y - cur.Y
		local distsquar = dx * dx + dy * dy
		if distsquar < 100 then  -- ���������� 10grid ����(��ƿ����� double������ �ϹǷ� int�� cObjectLocate()�� ���ϰ��� ��߳�)
			if Var.Interval >= #Course then
				MemBlock[Var.Handle] = nil
				cNPCVanish(Var.Handle)
			else
				Var.Interval = Var.Interval + 1
			end
			return
		end
		if distsquar < intervalsquar then
			break
		end
		goal = Runner_CenterFunc(cur, goal)
	end

	cRunTo(Var.Handle, goal.X, goal.Y, Var.SpeedRate)

	Var.IntervalGoal = goal
	Var.StepFunc = Runner_Step
end

function Runner_Step(Var)
cExecCheck "Runner_Step"
	if cIsObjectDead(Var.Handle) then
		Var.StepFunc = Dummy
		return
	end

	if cIsMovable(Var.Handle) == nil then	-- ������ �� ���� ����
		--cDebugLog("Step Not movable " .. Var.Handle)
		Var.StepFunc = Runner_WaitCanMove
		return
	end

	local cur = {}
	cur.X, cur.Y = cObjectLocate(Var.Handle)

	-- Ÿ�ٰ��� �Ÿ� üũ
	local Target = Var.Master.Castle[Var.Master.TargetCastle];
	if Target == nil then -- ��� �� �Զ�
		Master_Fail(Var.Master)
		return
	end
	if cDistanceSquar(Target.Handle, Var.Handle) < 15 * 15 then
		cDebugLog "Explose"

		local damage = Var.Damage;
		local hp = cObjectHP(Target.Handle)
		if damage > hp then
			damage = hp
		end
		cDebugLog("Damage " .. damage)

		cDamaged(Target.Handle, damage)
		Var.Damage = Var.Damage - damage
		cDebugLog("  Rest " .. Var.Damage)
		if Var.Damage <= 0 then
			MemBlock[Var.Handle] = nil
			cNPCVanish(Var.Handle)
			return
		end
	end


	-- ���� ���� ã��
	local goal = Var.IntervalGoal
	local dx = goal.X - cur.X
	local dy = goal.Y - cur.Y
	local distsquar = dx * dx + dy * dy

	if distsquar < 100 then  -- ���������� 10grid ����(0���� �ص� ������ ��Ȯ�� ���� ���� ��찡 ���� �� ���Ƽ�)
		Var.StepFunc = Runner_Interval
	end
end

function Runner_WaitCanMove(Var)
cExecCheck "Runner_WaitCanMove"
	--cDebugLog("Runner_WaitCanMove " .. Var.Handle)
	if cIsMovable(Var.Handle) ~= nil then	-- ������ �� �ִ� ����
		--cDebugLog("Runner_WaitCanMove esc " .. Var.Handle)
		Var.StepFunc = Horse_Interval
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Runner_CenterFunc(a, b)
cExecCheck "Runner_CenterFunc"
	return {X = (a.X + b.X) / 2, Y = (a.Y + b.Y) / 2,}
end
