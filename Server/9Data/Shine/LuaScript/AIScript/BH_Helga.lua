--[[
보스 상위버전 - 헬가

9Data/Here/World/FineScript.txt 필요
9Data/Hero/Script/BH_Helga.txt 필요
]]

-- 헬가 일어날때 스킬사용(일어나는 동작 애니)

-- 스크립트의 리턴값
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림

--[[ TODO
	플레이어가 전멸하여 타겟을 잃었을때, 헬가의 DuringReturn2Regen()루틴에 의해 강화버프가 당장 사라짐
		- 처리방안 필요
]]


HelgaIndex = "BH_Helga"
KarasianIndex = {}
KarasianIndex[1] = "BH_KaraTemplerAC"
KarasianIndex[2] = "BH_KaraTemplerMR"
BijouIndex = "BH_HelgaBall"

HelgaReadyAbstate = "StaBH_Helga_Idle01"		-- 최초 헬가가 웅크리고 있는 상태이상
HelgaBuffByBijou = "StaBH_HelgaAPU01"		-- 비쥬에 의해 헬가에 걸리는 중복버프
HelgaBufByKarasian = "StaBH_HelgaDRT01"		-- 카라사안에 의해 헬가에 걸리는 데미지반사버프
BijouBuffByKarasian = "StaHelgaBall"			-- 카라시안이 비쥬에 거는 버프(비쥬가 빛나도록)
KarasianSelfBuff = "StaBH_KaraTempler_None"	-- 카라시안이 비쥬에 에너지를 쏘는 모습

HelgaRaiseSkill = "BH_Helga_Skill_N_None"		-- 헬가가 일어날때의 애니메이션


KarasianRegenSec = 60


-- 비쥬와 카라시안들이 서있을 장소 리스트
BijouLoc = {}
KarasianLocate = {}

-- 첫째 그룹
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

-- 둘째그룹
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

-- 세째그룹
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

-- 네째그룹
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


----------------------------------------------------------------------
-- Mantis 8164
-- 보물상자 소환 정보
BH_HelgaBox =
{
	{ Index = "BH_Helga_X", ItemDropMobIndex = "BH_Helga_O", 	x = 1605, y =  1638, Radius = 1032 },
	{ Index = "BH_Helga_X", ItemDropMobIndex = "BH_Helga_O_02",	x = 1605, y =  1638, Radius = 1032 },
}
----------------------------------------------------------------------




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
function MainRoutine(Handle, MapIndex)    -- 카라시안에서 호출된 경우
cExecCheck "MainRoutine"
	if MobID == Karasian1ID or MobID == Karasian2ID then
		Karasian_Main(Handle, MobID, MapIndex)
		return ReturnAI.END
	elseif MobID == BijouID then            -- 비쥬에서 호출된 경우
		Bijou_Main(Handle, MobID, MapIndex)
		return ReturnAI.END
	elseif MobID == HelgaID then        -- 보스(헬가)에서 호출된 경우
		return Helga_Main(Handle, MobID, MapIndex)
	end
	return ReturnAI.END
end
]]

---------------------------------------------------------------------
------------------------    Common Part   ---------------------------
---------------------------------------------------------------------
function Common_Nothing()  -- 지울것
cExecCheck "Common_Nothing"
	return ReturnAI.END   -- 모든 AI루틴 끝
end

function Common_Wait(Var)  -- Var.Wait.Second까지 기다린 후 StepFunc을 WaitFunction으로 세팅
cExecCheck "Common_Wait"
--	----cDebugLog("Common_Wait " .. Var.Me)
		-- 공용이므로 헬가, 비쥬, 카라시안 등의 Var에 Wait.Second, Wait.NextFunc, StepFunc가 있어야 함
	if cCurSec() >= Var.Wait.Second then
		Var.StepFunc = Var.Wait.NextFunc
	end
	return Var.Wait.Rtn
end

function Common_RemoveTreasure(MapIndex)
cExecCheck "Common_RemoveTreasure"
	cDebugLog "Common_RemoveTreasure"

	cRegenGroupActiv("BH_Helga", "BH_HelgaBox", 0)	-- 상자가 나오지 않도록(세번째 인수를 생략하거나 1이면 activ)
--	cVanishAll(MapIndex, "BH_Helga_O")
--	cVanishAll(MapIndex, "BH_Helga_O_02")
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
		if MapIndex ~= "BH_Helga" then	-- 맵이 잘못되었음
			cAIScriptSet(Handle)	-- AI스크립트 제거
			return ReturnAI.END
		end

		-- 헬가가 처음 리젠되었을 때 자신의 메모리 초기화
		-- 밑에서 헬가가 죽었을때 메모리 해제하는 부분이 있기에,
		--		 계속 할당과 해제되는 것을 막기 위해 죽었는지(cIsObjectDead)도 확인
------cDebugLog("Helga Initialize")
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Me = "Helga"   -- 디버깅시 사용하기 위해
		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.BuffCharge = 0  -- 이 값이 40이 되면 버프 충전
		Var.TargetLostSec = 0  -- 타겟을 잃은 후 일정 시간 후 전투를 끝내기 위해(다음 타겟 찾는 시간)

		cSetAbstate(Var.Handle, HelgaReadyAbstate, 1, 2000000000)
		cSetAbstate(Var.Handle, "StaImmortal", 1, 2000000000)

		Var.StepFunc = Helga_BijouRegen		-- 다음 루틴에서 비쥬 리젠
	end

	if cIsObjectDead(Handle) ~= nil
	then
		if Var ~= nil then
-----cDebugLog "Helga Dead"
			-- 투명인간 소환 - 보물상자 제어용
			local InvisibleHandle = cMobRegen_Obj("InvisibleMan", Handle)
			if InvisibleHandle ~= nil
			then
				-- 보물상자 제어용 스크립트 설정
				cAIScriptSet(InvisibleHandle, Handle)

				MemBlock[InvisibleHandle] = {}
				MemBlock[InvisibleHandle].Handle 	= InvisibleHandle
				MemBlock[InvisibleHandle].MapIndex 	= MapIndex
				MemBlock[InvisibleHandle].StepFunc 	= Invisible_Init
			end

			-- 헬가가 죽었을 때
			-- 모든 비쥬, 카라시안들 죽임
			-- 다음 헬가가 리젠될때 다시 처음부터 시작
			for b = 1, 4
			do
				local BijouInfo = Var.BijouInfo[b]
				if BijouInfo ~= nil
				then
					-- 비쥬에 할당된 카라시안 죽임
					for k = 1, 3
					do
						local KaraInfo = BijouInfo.KarasianInfo[k]
						if KaraInfo ~= nil
						then
							cNPCVanish(KaraInfo.Handle)

							-- 카라시안에 할당된 메모리 삭제
							-- 같은 메모리가 Var.BijouInfo.KaraInfo에도 있으므로 여기서는 실제로 메모리삭제 안됨
							MemBlock[KaraInfo.Handle] = nil
						end
					end

					cNPCVanish(BijouInfo.Handle)

					-- 비쥬에 할당된 메모리 삭제(이때 Bijou.KarasianInfo도 해제됨)
					-- 같은 메모리가 Var.BijouInfo에도 있으므로 여기서는 실제로 메모리삭제 안됨
					MemBlock[BijouInfo.Handle] = nil
				end
			end

			-- 헬가에 할당된 메모리 삭제(이때 Var.BijouInfo도 해제됨)
			MemBlock[Var.Handle]	= nil
			Var						= nil
		end

		return ReturnAI.END
	end

	return Var.StepFunc(Var)
end

function Helga_BijouRegen(Var)	-- 비쥬 리젠시킴
cExecCheck "Helga_BijouRegen"
	----cDebugLog("Bijou Regen from " .. Var.Handle)
	Var.BijouInfo = {}
	for b = 1, 4 do
		local BijouHandle = cMobRegen_XY(Var.MapIndex, BijouIndex, BijouLoc[b].X, BijouLoc[b].Y, BijouLoc[b].D)
		cDebugLog("Bijou Regen : " .. BijouHandle)

		local BijouInfo = {}
		MemBlock[BijouHandle] = BijouInfo		-- 핸들에 맞추어 메모리블럭 만듦
		Var.BijouInfo[b] = BijouInfo

		BijouInfo.Me = "Bijou"   -- 디버깅시 사용하기 위해
		BijouInfo.Handle = BijouHandle
		BijouInfo.HelgaInfo = Var
		BijouInfo.MapIndex = Var.MapIndex
		BijouInfo.KarasianOffset = b * 3 - 2	-- 이 비쥬에 할당된 카라시안들의 슬롯번호 계산
												-- 베이스가 1이므로 조금 계산식 복잡함
												--     비쥬 1 -> 카라시안  1,  2,  3
												--     비쥬 2 -> 카라시안  4,  5,  6
												--     비쥬 3 -> 카라시안  7,  8,  9
												--     비쥬 4 -> 카라시안 10, 11, 12
		cAIScriptSet(BijouHandle, Var.Handle) -- 비쥬의 AI스크립트를 Var.Handle(헬가)의 AI스크립트로 세팅
		BijouInfo.StepFunc = Bijou_KarasianRegen		-- 비쥬의 다음 액션은 카라시안 만즐기
	end

	Var.StepFunc = Helga_TreasureVanish
	return ReturnAI.END
end

function Helga_TreasureVanish(Var)
cExecCheck "Helga_TreasureVanish"

	cDebugLog "Helga_TreasureVanish"
	Common_RemoveTreasure(Var.MapIndex)

	-- 10초에 한번씩 상자 지움(다른 문제로 상자가 나타날지...)
	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 10
	Var.Wait.NextFunc = Helga_TreasureVanish
	Var.Wait.Rtn = ReturnAI.END
	Var.StepFunc = Common_Wait
	cDebugLog("Common_Wait - Helga_TreasureVanish")


	-- 헬가 피 다시 채움
	local HP, MaxHP = cObjectHP(Var.Handle)
	cSetNPCParam(Var.Handle, "HP", MaxHP)
end

function Helga_Awake(Var)		-- 카라시안들에 의해 깨어난 후 처리
cExecCheck "Helga_Awake"
	----cDebugLog("Awake - Skill Blast")		-- 깨어나기 위한 스킬 발동

	cResetAbstate(Var.Handle, HelgaReadyAbstate)-- 공격받지 않기 위한 무적상태이상 해제
	cResetAbstate(Var.Handle, "StaImmortal")	-- 공격받지 않기 위한 무적상태이상 해제
	------cDebugLog("Awake - Skill Blast")		-- 깨어나기 위한 스킬 발동

	cNPCSkillUse(Var.Handle, Var.Handle, HelgaRaiseSkill)	-- 일어나는 애니메이션

	-- 스킬발동을 위해 3초간 대기 후 Helga_Attack으로 바꿈(함수 Common_Wait 참조)
	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 3
	Var.Wait.NextFunc = Helga_PreAttack	-- 공격하기 전 준비
	Var.Wait.Rtn = ReturnAI.END
	Var.StepFunc = Common_Wait
	cDebugLog("Common_Wait - Helga_Awake")

	Var.BuffCharge = 0  -- 이 값은 Bijou_BuffToHelga()에서 충전, 40이 되면 버프 충전

	return ReturnAI.END
end

function Helga_PreAttack(Var)
cExecCheck "Helga_PreAttack"
	Var.TargetLostSec = cCurSec()  -- 지금 타겟을 잃었음
	Var.StepFunc = Helga_Attack
----cDebugLog("Helga_PreAttack " .. Var.TargetLostSec)
end

function Helga_Attack(Var)
cExecCheck "Helga_Attack"


if LastWrite ~= cCurSec() then
	cDebugLog("Helga_Attack " .. Var.TargetLostSec .. " " .. cCurSec())
	LastWrite = cCurSec()
end

	-- 헬가에 버핑
	if Var.BuffCharge >= 240 then
		----cDebugLog("HelgaBuff")
		if cTargetHandle(Var.Handle) ~= nil then
			cMessage(Var.Handle, "BH_Helga_Buff")
			cSetAbstate(Var.Handle, HelgaBuffByBijou, 1, 200000000)
		end
		Var.BuffCharge = Var.BuffCharge - 240
	end

	local TargetHandle = cTargetHandle(Var.Handle)
	if TargetHandle ~= nil and cObjectType(TargetHandle) == 2 then	-- 타겟이 있고 플레이어면 (SHINEOBJECT_PLAYER == 2)
		Var.TargetLostSec = cCurSec()
	elseif Var.TargetLostSec + 10 < cCurSec() then	-- 적이 사라진지 10초 후
		cResetAbstate(Var.Handle, KarasianSelfBuff)	-- 강화버프 제거
		cResetAbstate(Var.Handle, HelgaBuffByBijou)	-- 강화버프 제거
		Var.BuffCharge = 0  -- 이 값이 40이 되면 버프 충전
		-- 타겟 전멸시 모든 비쥬, 카라시안 삭제
		for b = 1, 4 do
			cNPCVanish(Var.BijouInfo[b].Handle)
			for k = 1, 3 do
				cNPCVanish(Var.BijouInfo[b].KarasianInfo[k].Handle)
			end
		end

		MemBlock = {} -->모든 메모리 삭제 - 처음부터 다시 시작
	end

	return ReturnAI.CPP	-- 이후 헬가는 CPP의 AI루틴 적용(헬가의 죽음 체크는 Helga_Main에서)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Helga_AllBijouStepFunc(Var, func)	-- 모든 비쥬들의 StepFunc를 일괄적으로 바꿈
cExecCheck "Helga_AllBijouStepFunc"
	----cDebugLog("Helga_AllBijouStepFunc")
	for b = 1, 4 do
		----cDebugLog("   " .. Var.BijouInfo[b].Me)
		Var.BijouInfo[b].StepFunc = func
	end
end

function Helga_AllKarasianStepFunc(Var, func)	-- 모든 카라시안들의 StepFunc를 일괄적으로 바꿈
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
	local Var = MemBlock[Handle]		-- 핸들을 기반으로 메모리블럭 찾음
	if Var == nil then
		----cDebugLog("Bijou Handle Error:" .. Handle)
		return
	end

	Var.StepFunc(Var)
end

function Bijou_KarasianRegen(Var)		-- 카라시안을 리젠하는 함수
cExecCheck "Bijou_KarasianRegen"
	----cDebugLog "Bijou_KarasianRegen"
				-- 전투중 카라시안들이 전멸했을때도 리젠해야 하므로 독립된 함수로 사욘

	Bijou_SummonKarasian(Var, Karasian_WaitInvader)
		-- 이 비쥬에 할당된 슬롯의 카라시안들을 리젠시키고 그들이 Karasian_WaitInvader행동을 하도록 설정

	Var.StepFunc = Common_Nothing	-- 아무것도 안함(역시 카라시안들에 의해 깨어남)
end

function Bijou_BuffToHelga(Var)		-- 전투 시작 후 카라시안에게 버핑
cExecCheck "Bijou_BuffToHelga"
	--cDebugLog("Bijou[" .. Var.Handle .. "] Buff To Helga")

	-- 세 카라시안들이 모두 존재하는지 확인
	local karanum = 0
	for k = 1, 3 do
		if cIsObjectDead(Var.KarasianInfo[k].Handle) == nil then	-- 살아있으면 karanum 증가
			karanum = karanum + 1
		end
	end

	if karanum > 0 then -- 하나라도 남아 있으면
		local HelgaInfo = Var.HelgaInfo						-- 버핑값이 헬가의 테이블에 있으므로
		HelgaInfo.BuffCharge = HelgaInfo.BuffCharge + 1		-- 이 값이 40이 되면 버프 충전(비쥬 4개일 경우 10초)
--cDebugLog("Bijou_BuffToHelga : Buffing " .. HelgaInfo.BuffCharge)

		-- 1초에 한번씩 버프하기 위해
		Var.Wait = {}
		Var.Wait.Second = cCurSec() + 1
		Var.Wait.NextFunc = Bijou_BuffToHelga
		Var.Wait.Rtn = ReturnAI.END

		Var.StepFunc = Common_Wait
		--cDebugLog("Common_Wait - Bijou_BuffToHelga")
	else 	-- 60초후 다시 리젠시킴
--cDebugLog("Bijou_BuffToHelga : Regen " .. Var.Handle)
		-- 60초 후 카라시안들을 다시 리젠시키기 위해
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
		-- 이 비쥬에 할당된 카라시안들을 리젠시키고 Karasian_BuffToBijou활동을 하도록 세팅
	Var.StepFunc = Bijou_WaitBuffing -- 카라시안들이 생기기 전에 계속 리젠 가능하므로 버프가 생길 때까지 대기
end

function Bijou_WaitBuffing(Var)
cExecCheck "Bijou_WaitBuffing"
	--cDebugLog("Bijou_WaitBuffing " .. Var.Handle)
	if cAbstateRestTime(Var.Handle, BijouBuffByKarasian) ~= nil then -- 남은시간 리턴, nil이면 상태이상 없음
		Var.StepFunc = Bijou_BuffToHelga
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Bijou_SummonKarasian(Var, Func)
cExecCheck "Bijou_SummonKarasian"
	----cDebugLog("Karasian Regen from " .. Var.Handle)

	-- 카라시안들의 기존 메모리 해제하기 위해
	if Var.KarasianInfo ~= nil then
		for k = 1, 3 do
			local OldKarahnd = Var.KarasianInfo[k].Handle
			MemBlock[OldKarahnd] = nil	-- 메모리는 Var.KarasianInfo에도 할당되어 있으므로 여기서는 메모리해제 안됨
		end
	end

	Var.KarasianInfo = {}		-- 여기서 실제 메모리해제

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

		cAIScriptSet(KHnd, Var.Handle) -- 카라시안의 AI스크립트를 Var.Handle(비쥬)의 AI스크립트로 세팅
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
	-- 자신이 피해를 입을 때까지
	if cIsObjectDead(Var.Handle) ~= nil or cTargetHandle(Var.Handle) ~= nil then
		------cDebugLog("Warn")
		Var.StepFunc = Karasian_Warning1    -- 주위에 경고를 올림
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
-- 보물상자 제어용 오브젝트

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


	----------------------------------------------------------------------
	-- Mantis 8164
	-- ※ 보물상제 소환 및 아이템드랍그룹 몬스터 셋팅
	for i = 1, #BH_HelgaBox
	do
		local BoxHandle = cMobRegen_Circle( Var["MapIndex"], BH_HelgaBox[i]["Index"], BH_HelgaBox[i]["x"], BH_HelgaBox[i]["y"], BH_HelgaBox[i]["Radius"] )
		if BoxHandle ~= nil
		then
			cSetItemDropMobID( BoxHandle, BH_HelgaBox[i]["ItemDropMobIndex"] )
		end
	end
	----------------------------------------------------------------------


	cGroupRegen("BH_Helga", "BH_HelgaBox")	-- 상자가 나오도록

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
