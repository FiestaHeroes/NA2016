-- 키메라를 위한 스크립트
-- 스킬 1 : 일정시간 데미지를 일정량 이상 받았을 때 발동
-- 스킬 2 : HP에 따라 발동

-- 스크립트의 리턴값
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림

--두번째 키메라 리젠시키면 어디선가 Fail
-- 상수 정의

--Chimera_Skill_W03_2Target.nif 불덩이 떨어지는 이펙트 및 타겟 이펙트
--Psy_Chimera_Skill_W03_3DOT.nif 도트이펙트
--Psy_Chimera_Skill_W03_3DOTLoop.nif 도트 루프 이펙트


C = {}
C.Immune = {}		-- 데미지 면역 스킬
C.Immune.SkillIndex = "Chimera_Skill_N_ACS"	-- 스킬 이름
C.Immune.Interval = 600		-- 600초 내 500,000 이상의 데미지를 받았을 때
C.Immune.Damage = 500000	--

C.LethalMoveTime = {}	-- 필살기 테이블

C.LethalMoveTime[1] = 950	-- 95% 이하일 때 한번 사용
C.LethalMoveTime[2] = 850	-- 85% 이하일 때 한번 사용
C.LethalMoveTime[3] = 750	-- 75% 이하일 때 한번 사용
C.LethalMoveTime[4] = 650	-- 65% 이하일 때 한번 사용
C.LethalMoveTime[5] = 600	-- 60% 이하일 때 한번 사용
C.LethalMoveTime[6] = 550	-- 55% 이하일 때 한번 사용
C.LethalMoveTime[7] = 450	-- 45% 이하일 때 한번 사용 
C.LethalMoveTime[8] = 350	-- 35% 이하일 때 한번 사용
C.LethalMoveTime[9] = 300	-- 30% 이하일 때 한번 사용
C.LethalMoveTime[10] = 250	-- 25% 이하일 때 한번 사용
C.LethalMoveTime[11] = 200	-- 20% 이하일 때 한번 사용
C.LethalMoveTime[12] = 150	-- 15% 이하일 때 한번 사용
C.LethalMoveTime[13] = 120	-- 12% 이하일 때 한번 사용
C.LethalMoveTime[14] = 90	-- 9% 이하일 때 한번 사용
C.LethalMoveTime[15] = 50	-- 5% 이하일 때 한번 사용
C.LethalMoveTime.Instance = {}								-- 순간데미지스킬
C.LethalMoveTime.Instance.SkillIndexPush = "Chimera_Skill_W03_1"	-- 스킬 이름(실제로 발동하는 스킬)
C.LethalMoveTime.Instance.SkillIndexDamage = "Chimera_Skill_W03_2"	-- 스킬 이름(발동하지는 않지만 2차데미지를 계산하기 위한 스킬)
C.LethalMoveTime.Instance.Range = 2000							-- 스킬 사정거리
C.LethalMoveTime.Instance.SpotViewSec = 3						-- 스킬 발사 3초 후 데미지범위 출력
C.LethalMoveTime.Instance.SpotLifeTime = 7						-- 불덩어리 이펙트의 지속시간
C.LethalMoveTime.Instance.SpotDamageSecond = 4					-- 불덩어리 이펙트 후 데미지 계산 시간
C.LethalMoveTime.Instance.DamageArea = 150						-- 데미지 넒이(반지름)
C.LethalMoveTime.Instance.Meteor = {}
C.LethalMoveTime.Instance.Meteor.Number = 16						-- 불덩이 10 개가 떨어짐
C.LethalMoveTime.Instance.Meteor.Interval = 0.4					-- 0.0 초간격

-- 데미지 공식에 의해 데미지 계산할 때
C.LethalMoveTime.Instance.MinMA = 10000							-- 마법공격력
C.LethalMoveTime.Instance.MaxMA = 15000							-- 마법공격력
C.LethalMoveTime.Instance.MH = 5000								-- 마법히트

-- HP에 따라 데미지가 달라질 경우
C.LethalMoveTime.Instance.DamageRate = 980                      -- MaxHP의 98% 데미지


C.LethalMoveTime.MagicFieldSkill = "Chimera_Skill_W03_2"		-- 어떤 스킬에 의한 매직필드인지
C.LethalMoveTime.MagicFieldLocX = 3677							-- 필드의 중심점
C.LethalMoveTime.MagicFieldLocY = 18467
C.LethalMoveTime.MagicFieldWhen = "Last"						-- 첫("First")/막("Last") 불덩이가 떨어질때 깔림

C.LethalMoveTime.TotalSecond = 10


MemBlock = {}

function Chimera(Handle, MapIndex)
cExecCheck "Chimera"

	if cIsObjectDead(Handle) then	-- 죽었음
		cAIScriptSet(Handle)	-- 스크립트 없앰
		MemBlock[Handle] = nil	-- 메모리해제
		cDebugLog "Chimera Dead"
		return ReturnAI.END
	end

	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex

		Var.LastCheck = cCurSec()	-- 1초에 한번씩 체크하기 위해

		Var.Lethal = {}
		Var.Lethal.SkillBlastSec = 0		-- 스킬을 발동한 시간 - 스킬 진행하기 위해

		Var.ImmunManage = {}		-- HP 감소를 감시하는 테이블(면역스킬을 위한)
		Var.ImmunManage.QueueHead = 1
		for k = 1, C.Immune.Interval do
			Var.ImmunManage[k] = cObjectHP(Var.Handle)
		end

		Var.MeteorTargetList = {}	-- 불덩어리의 타겟들을 저장하기 위한 테이블
		Var.MeteorTick = 0.0		-- 불덩어리가 떨어지기 시작하는 시간
		Var.MeteorNumber = 0		-- 떨어진 불덩어리 갯수

		Var.NextLethalIndex = 1	-- 필살기를 사용하기 위한 테이블 C.LethalMoveTime[1]까지 기다림

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
		Var.StepFunc = Chimera_ImmunSkill	-- 면역스킬 발동
		return ReturnAI.CPP
	end


	-- HP 감시
	if CurHP == MaxHP then
		Var.NextLethalIndex = 1
	else
		local HPRate = CurHP * 1000 / MaxHP
		if C.LethalMoveTime[Var.NextLethalIndex] ~= nil and HPRate < C.LethalMoveTime[Var.NextLethalIndex] then
			Var.NextLethalIndex = Var.NextLethalIndex + 1
			Var.StepFunc = Chimera_LethalMove		-- 필살기 발동
			return ReturnAI.CPP
		end
	end
	return ReturnAI.CPP
end

function Chimera_ImmunSkill(Var)	-- 면역스킬 발동
cExecCheck "Chimera_ImmunSkill"

	if cSkillBlast(Var.Handle, Var.Handle, C.Immune.SkillIndex) == nil then  -- 실패
		cDebugLog "Chimera_ImmunSkill : Other Skill using"
		return ReturnAI.CPP	-- 다른 스킬 사용중이므로 실패 - 다음 루틴에서 다시 시도
	end

	cDebugLog "Chimera_ImmunSkill : Blast"

	for k = 1, C.Immune.Interval do
		Var.ImmunManage[k] = cObjectHP(Var.Handle)
	end

	Var.StepFunc = Chimera_Default
	return ReturnAI.CPP
end

function Chimera_LethalMove(Var)		-- 필살기 발동
cExecCheck "Chimera_LethalMove"

	if cSkillBlast(Var.Handle, Var.Handle, C.LethalMoveTime.Instance.SkillIndexPush) == nil then  -- 실패
		cDebugLog "Chimera_LethalMove : Other Skill using"
		return ReturnAI.CPP	-- 다른 스킬 사용중이므로 실패 - 다음 루틴에서 다시 시도
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

	-- 복수의 타겟설정
	Var.MeteorTargetList = {}	-- 불덩어리의 타겟들을 저장하기 위한 테이블
	local TargetList = {cAggroList(Var.Handle, C.LethalMoveTime.Instance.Range)}	-- Range 안에 있는 적들 리스트 얻음
	local TargetNum = C.LethalMoveTime.Instance.Meteor.Number
	if TargetNum < #TargetList then
		TargetNum = #TargetList
	end

	for k = 1, TargetNum do
		local rnd = cRandomInt(1, #TargetList)
		Var.MeteorTargetList[#Var.MeteorTargetList + 1] = TargetList[rnd]
		-- 마지막 원소를 rnd에 끼워넣고 마지막원소 지움
		TargetList[rnd] = TargetList[#TargetList]
		TargetList[#TargetList] = nil
	end
--for k = 1, #Var.MeteorTargetList do
--	cDebugLog("Target : " .. Var.MeteorTargetList[k])
--end

	Var.MeteorTick = cCurrentSecond()		-- 불덩어리가 떨어지기 시작하는 시간
	Var.MeteorNumber = 0		-- 떨어진 불덩어리 갯수

	Var.StepFunc = Chimera_MeteorShower
	return ReturnAI.END
end

function Chimera_MeteorShower(Var)
cExecCheck "Chimera_MeteorShower"

	local CurrentSecond = cCurrentSecond()
	if CurrentSecond < Var.MeteorTick then
		return ReturnAI.END
	end

	if #Var.MeteorTargetList == 0 then -- 타겟 모두 썼음
		Var.StepFunc = Chimera_SkillEnd
		return ReturnAI.END
	end

	Var.MeteorTick = Var.MeteorTick + C.LethalMoveTime.Instance.Meteor.Interval

	-- 마지막 타겟 꺼냄
	local TargetHandle = Var.MeteorTargetList[#Var.MeteorTargetList]
	Var.MeteorTargetList[#Var.MeteorTargetList] = nil

	local X, Y = cObjectLocate(TargetHandle)
	if X ~= nil and Y ~= nil then
		local SpotHandle = cEffectRegen_XY(Var.MapIndex, "Chimera_Skill_W03_2Target",							-- x, y 위치에 오브젝트 출력
										-- 맵이름,        이펙트 이름,
											X,      Y,      0,  C.LethalMoveTime.Instance.SpotLifeTime, 0)
										--	x좌표,  y좌표, dir, 지속시간,                               루프, [스케일])
		cAIScriptSet(SpotHandle, Var.Handle)
		cAIScriptFunc(SpotHandle, "Entrance", "Effect_TargetSpot") --입구함수는 HorseMain
		MemBlock[SpotHandle] = {}
		MemBlock[SpotHandle].Handle = SpotHandle
		MemBlock[SpotHandle].X = X
		MemBlock[SpotHandle].Y = Y
		MemBlock[SpotHandle].Chimera = Var
		MemBlock[SpotHandle].ExploseTime = CurrentSecond + C.LethalMoveTime.Instance.SpotDamageSecond

		Var.MeteorNumber = Var.MeteorNumber + 1
		-- 매직필드 깔리는 불덩이?
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

	return ReturnAI.CPP	-- SkillEndWait에서 기다리는 동안 전투모드 풀리지 않도록
end

--------------------------------------------------------

function Effect_TargetSpot(Handle, MapIndex)
cExecCheck "Effect_TargetSpot"

	local Var = MemBlock[Handle]
	if Var == nil then
		cAIScriptSet(Handle)	-- 스크립트 없앰
		return
	end

	if cCurrentSecond() < Var.ExploseTime then
		return
	end

	cDebugLog "Effect_TargetSpot : Explose"
	local ChimeraHandle = Var.Chimera.Handle
	local TargetList = {cGetTargetList(ChimeraHandle, Var.X, Var.Y, C.LethalMoveTime.Instance.DamageArea)}
			-- cGetTargetList의 출력은 핸들 여러개이므로 그 핸들들을 하나의 테이블로 만듦

	for k = 1, #TargetList do
		local Target = TargetList[k]
		if Target ~= nil then

			-- CPP의 데미지 공식에 의해 데미지 계산
			--local Damage = cSkillDamageCalculate(Var.Handle, C.LethalMoveTime.Instance.SkillIndexDamage, Target, C.LethalMoveTime.Instance)

			-- HP에 따라 데미지가 달라짐
			local CurHP, MaxHP = cObjectHP(Target)
			local Damage = MaxHP * C.LethalMoveTime.Instance.DamageRate / 1000.


			-- target에 데미지 적용
			if Damage ~= nil then
				cDamaged(Target, Damage, Var.Handle)
			end
		end
	end

	if Var.MagicField then
		cDebugLog "MagicField Spread"
		cMagicFieldSpread(ChimeraHandle, C.LethalMoveTime.MagicFieldLocX, C.LethalMoveTime.MagicFieldLocY, 0, C.LethalMoveTime.MagicFieldSkill, 1)
											-- Tick, Keep, DOT 등 매직필드 정보는 테이블로 전달
	end

	cAIScriptSet(Handle)	-- 스크립트 없앰
	MemBlock[Handle] = nil
end
