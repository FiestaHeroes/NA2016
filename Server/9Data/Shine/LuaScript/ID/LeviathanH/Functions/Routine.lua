--------------------------------------------------------------------------------
-- ※ DummyRoutineFunc
--------------------------------------------------------------------------------
function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end

--------------------------------------------------------------------------------
-- ※ PlayerMapLogin
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

	-- 첫 플레이어의 맵 로그인 체크
	Var["bPlayerMapLogin"] = true
end


--------------------------------------------------------------------------------
-- ※ Routine_BossLive
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


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end

	return ReturnAI["CPP"]
end


--------------------------------------------------------------------------------
-- ※ Routine_BossDead
--------------------------------------------------------------------------------
function Routine_BossDead( MapIndex, AttackerHandle, Handle )
cExecCheck "Routine_BossDead"

	DebugLog("Routine_BossDead::루틴실행")

	-- 함수 인자 확인
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

	-- 필드 버퍼 확인
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
-- ※ Routine_Leviathan
--------------------------------------------------------------------------------
function Routine_Leviathan( Handle, MapIndex )
cExecCheck "Routine_Leviathan"

	-- 함수 인자 확인
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


	-- 필드 버퍼 확인
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
		ErrorLog("Routine_Leviathan::테이블 생성")
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

		-- GuardianEgg 테이블 초기화
			Var["Routine_Leviathan"][Handle]["GuardianEgg"]["RegenTick"] 		= Var["CurSec"] + CurSkillInfo["GuardianEgg"]["RegenTick"]
			Var["Routine_Leviathan"][Handle]["GuardianEgg"]["RegenMob"] 		= CurSkillInfo["GuardianEgg"]["RegenMob"]
			Var["Routine_Leviathan"][Handle]["GuardianEgg"]["RegenMaxCount"] 	= 0

		-- GuardEgg 테이블 관련 초기화

			Var["Routine_Leviathan"][Handle]["GuardEgg"]["RegenTick"] 			= Var["CurSec"] + CurSkillInfo["GuardEgg"]["RegenTick"]
			Var["Routine_Leviathan"][Handle]["GuardEgg"]["RegenMob"] 			= CurSkillInfo["GuardEgg"]["RegenMob"]
			Var["Routine_Leviathan"][Handle]["GuardEgg"]["RegenMaxCount"] 		= 0

		-- BuffEgg 테이블 관련 초기화

			Var["Routine_Leviathan"][Handle]["BuffEgg"]["RegenTick"] 			= Var["CurSec"] + CurSkillInfo["BuffEgg"]["RegenTick"]
			Var["Routine_Leviathan"][Handle]["BuffEgg"]["RegenMob"] 			= CurSkillInfo["BuffEgg"]["RegenMob"]
			Var["Routine_Leviathan"][Handle]["BuffEgg"]["RegenMaxCount"] 		= 0

		end
	end

	-- HP가 CurSkillInfo["HPRateToRegenEgg"]% 이하로 떨어진 적 없는 레비아탄은 return
	if Var["Routine_Leviathan"][Handle] == nil
	then
		return ReturnAI["CPP"]
	end


	-- 죽었는지 확인
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


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"][ Handle ] <= cCurrentSecond()
	then
		Var["RoutineTime"][ Handle ] = cCurrentSecond() + 5
	else
		return ReturnAI["CPP"]
	end

	--------------------------------------------------------------------
	-- GuardianEgg 리젠처리
	--------------------------------------------------------------------
	if Var["Routine_Leviathan"][Handle]["GuardianEgg"] ~= nil
	then

		local MyVar 			= Var["Routine_Leviathan"][Handle]["GuardianEgg"]
		local MyCurSkillInfo 	= CurSkillInfo["GuardianEgg"]

		-- RegenMaxCount 확인
		if MyVar["RegenMaxCount"] > MyCurSkillInfo["RegenMaxCount"]
		then
			DebugLog("Routine_Leviathan::Over RegenMaxCount..GuardianEgg")

			Var["Routine_Leviathan"][Handle]["GuardianEgg"] = nil
			return ReturnAI["CPP"]
		end

		-- 리젠할 시간인지 확인
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
	-- GuardEgg 리젠처리
	--------------------------------------------------------------------
	if Var["Routine_Leviathan"][Handle]["GuardEgg"] ~= nil
	then

		local MyVar 			= Var["Routine_Leviathan"][Handle]["GuardEgg"]
		local MyCurSkillInfo 	= CurSkillInfo["GuardEgg"]

		-- RegenMaxCount 확인
		if MyVar["RegenMaxCount"] > MyCurSkillInfo["RegenMaxCount"]
		then
			DebugLog("Routine_Leviathan::Over RegenMaxCount..GuardEgg")

			Var["Routine_Leviathan"][Handle]["GuardEgg"] = nil
			return ReturnAI["CPP"]
		end

		-- 리젠할 시간인지 확인
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
	-- BuffEgg 리젠처리
	--------------------------------------------------------------------
	if Var["Routine_Leviathan"][Handle]["BuffEgg"] ~= nil
	then

		local MyVar 			= Var["Routine_Leviathan"][Handle]["BuffEgg"]
		local MyCurSkillInfo 	= CurSkillInfo["BuffEgg"]

		-- RegenMaxCount 확인
		if MyVar["RegenMaxCount"] > MyCurSkillInfo["RegenMaxCount"]
		then
			DebugLog("Routine_Leviathan::Over RegenMaxCount..BuffEgg")

			Var["Routine_Leviathan"][Handle]["BuffEgg"] = nil
			return ReturnAI["CPP"]
		end

		-- 리젠할 시간인지 확인
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
-- ※ Routine_GuardianEgg	-- 큰 알
--------------------------------------------------------------------------------
function Routine_GuardianEgg( Handle, MapIndex )
cExecCheck "Routine_GuardianEgg"

	-- 함수 인자 확인
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


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_GuardianEgg::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 스킬데이터 변수설정
	local CurSkillInfo = LeviathanSkillInfo["Routine_GuardianEgg"]

	if Var["Routine_GuardianEgg"] == nil
	then
		Var["Routine_GuardianEgg"] = {}
		DebugLog("Routine_GuardianEgg:: Table Create")
	end

	-- 변수 초기화
	if Var["Routine_GuardianEgg"][Handle] == nil
	then

		Var["Routine_GuardianEgg"][Handle] = {}
		Var["Routine_GuardianEgg"][Handle]["EggBrakeTime"] 	= Var["CurSec"] + CurSkillInfo["EggBrakeTime"]
		Var["Routine_GuardianEgg"][Handle]["IsReadySummon"]	= false
	end

	local MyVar = Var["Routine_GuardianEgg"][Handle]

	-- 알 깨지고 뱀 소환할 시간인지 체크
	if MyVar ~= nil
	then
		-- 부화 처리할 시간인지 체크
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


		-- 부화 처리할 준비가 됐으면, 정해진 몹을 정해진 마리만큼 소환하고, 스크립트를 부착한다.
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

			-- 알이 처리해야할 일 다 처리했으니깐, 사라져준다.
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
-- ※ Routine_GuardEgg	-- 작은 알
--------------------------------------------------------------------------------
function Routine_GuardEgg( Handle, MapIndex )
cExecCheck "Routine_GuardEgg"

	-- 함수 인자 확인
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


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_GuardEgg::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 스킬데이터 변수설정
	local CurSkillInfo = LeviathanSkillInfo["Routine_GuardEgg"]

	if Var["Routine_GuardEgg"] == nil
	then
		Var["Routine_GuardEgg"] = {}
		DebugLog("Routine_GuardEgg:: Table Create")
	end

	-- 변수 초기화
	if Var["Routine_GuardEgg"][Handle] == nil
	then
		Var["Routine_GuardEgg"][Handle] = {}

		Var["Routine_GuardEgg"][Handle]["EggBrakeTime"] 	= Var["CurSec"] + CurSkillInfo["EggBrakeTime"]
		Var["Routine_GuardEgg"][Handle]["IsReadySummon"]	= false

	end


	local MyVar = Var["Routine_GuardEgg"][Handle]

	-- 알 깨지고 뱀 소환할 시간인지 체크
	if MyVar ~= nil
	then

		-- 부화 처리할 시간인지 체크
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


		-- 부화 처리할 준비가 됐으면, 정해진 몹을 정해진 마리만큼 소환하고, 스크립트를 부착한다.
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

			-- 알이 처리해야할 일 다 처리했으니깐, 사라져준다.
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
-- ※ Routine_BuffEgg	-- 버프 알
--------------------------------------------------------------------------------
function Routine_BuffEgg( Handle, MapIndex )
cExecCheck "Routine_BuffEgg"

	-- 함수 인자 확인
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


	-- 필드 버퍼 확인
	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Routine_BuffEgg::Var == nil"..MapIndex )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	-- 스킬데이터 변수설정
	local CurSkillInfo = LeviathanSkillInfo["Routine_BuffEgg"]

	if Var["Routine_BuffEgg"] == nil
	then
		Var["Routine_BuffEgg"] = {}
		DebugLog("Routine_BuffEgg:: Table Create")
	end


	-- 변수 초기화
	if Var["Routine_BuffEgg"][Handle] == nil
	then
		Var["Routine_BuffEgg"][Handle] = {}
		Var["Routine_BuffEgg"][Handle]["IsReadyBuff"]	= false
	end


	local MyVar = Var["Routine_BuffEgg"][Handle]

	-- 알 깨지고 뱀 소환할 시간인지 체크
	if MyVar ~= nil
	then
		-- 부화 처리할 시간인지 체크
		if MyVar["IsReadyBuff"] == false
		then
			if cIsObjectDead( Handle ) == 1
			then
				MyVar["IsReadyBuff"] = true
			else
				return ReturnAI["CPP"]
			end
		end


		-- 부화 처리할 준비가 됐으면, 정해진 몹을 정해진 마리만큼 소환하고, 스크립트를 부착한다.
		if MyVar["IsReadyBuff"] == true
		then

			ErrorLog("Routine_BuffEgg::WhoKillBuffEgg : cMobSuicide( MapIndex, Handle )")

			-- 알이 처리해야할 일 다 처리했으니깐, 사라져준다.
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

			-- 알이 처리해야할 일 다 처리했으니깐, 사라져준다.
			--cMobSuicide( MapIndex, Handle )
			--cAIScriptSet( Handle )

			return ReturnAI["END"]
		end

	end

	return ReturnAI["END"]

end


