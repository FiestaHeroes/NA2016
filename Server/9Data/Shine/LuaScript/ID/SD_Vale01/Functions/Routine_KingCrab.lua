
--------------------------------------------------------------------------------
-- KingCrab :: 휠윈드
--------------------------------------------------------------------------------
function KC_WhirlWind( Handle, MapIndex )
cExecCheck "KC_WhirlWind"

	local Var = InstanceField[ MapIndex ]

	if Var["KingCrabProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_KingCrab["KC_WhirlWind"]

	--------------------------------------------------------------------------------
	-- ★ 휠윈드 처리상, 한번만 해줘야 하는 부분(초기화)
	--------------------------------------------------------------------------------
	if Var["KC_WhirlWind"] == nil
	then
		Var["KC_WhirlWind"] ={}
		--DebugLog("KC_WhirlWind 테이블 생성")

		------------------------------------------------------------------------------------------
		-- 1. 임시 타겟 리스트 생성
		-- 킹크랩과 일정거리 안에 있는 플레이어 리스트 받아옴
		Var["KC_WhirlWind"]["TargetList_Temp"]	= { cNearObjectList( Handle, SkillInfo["Target_SearchArea"], ObjectType["Player"] ) }
		--[[
		DebugLog("========================================================")
		DebugLog("TargetList_Temp 타겟리스트")
		for i = 1, #Var["KC_WhirlWind"]["TargetList_Temp"]
		do
			DebugLog("타겟 핸들[ "..i.." ] :"..Var["KC_WhirlWind"]["TargetList_Temp"][i] )
		end

		DebugLog("========================================================")
		--]]

		Var["KC_WhirlWind"]["CurTargetNum"]			= 1
		Var["KC_WhirlWind"]["CurTargetHandle"]		= INVALID_HANDLE
		Var["KC_WhirlWind"]["IsFollowState"] 		= false
		Var["KC_WhirlWind"]["PathListEachTarget"] 	= {}		-- 타겟별로 path 저장하는 테이블

		------------------------------------------------------------------------------------------
		-- 2. 조건에 맞는 플레이어리스트 다시 생성( 우선순위 조건에 맞게 )
		Var["KC_WhirlWind"]["TargetList"] = {}



		-- TargetList_Temp 돌며, 유저별 우선순위 점수를 부여한다.
		for i, v in pairs( Var["KC_WhirlWind"]["TargetList_Temp"] )
		do
			-- 우선순위 점수 초기화
			Var["KC_WhirlWind"]["TargetList"][v] = 0

			------------------------------------------------------------------------------------------
			-- 1 ) 유저의 직업 체크.
			local Priority_Class 		= SkillInfo["Target_Priority"]["ChrBaseClass"]
			local charBaseClassNum 		= cGetBaseClass( v )

			--DebugLog("charBaseClassNum : "..charBaseClassNum)

			for i = 1, #Priority_Class
			do
				if Priority_Class[i]["class"] == charBaseClassNum
				then
					Var["KC_WhirlWind"]["TargetList"][v] = Var["KC_WhirlWind"]["TargetList"][v] + Priority_Class[i]["arg"]
					--DebugLog("유저직업은 "..charBaseClassNum..", 따라서 +"..Priority_Class[i]["arg"].." = "..Var["KC_WhirlWind"]["TargetList"][v] )
					break
				end
			end

			------------------------------------------------------------------------------------------
			-- 2 ) 유저의 상태이상 체크.
			local Priority_AbState 		= SkillInfo["Target_Priority"]["ChrAbState"]

			for i = 1, #Priority_AbState
			do
				local strength, resttime = cGetAbstate( v, Priority_AbState[i]["Index"] )
				if strength ~= nil
				then
					Var["KC_WhirlWind"]["TargetList"][v] = Var["KC_WhirlWind"]["TargetList"][v] + Priority_AbState[i]["arg"]
					--DebugLog("유저상태는 "..Priority_AbState[i]["Index"]..", 따라서 +"..Priority_AbState[i]["arg"].." = "..Var["KC_WhirlWind"]["TargetList"][v])
				end
			end
		end

		-- 새로 만들어진 타겟리스트 TargetList의 크기를 계산, 값을 갖는다.
		--DebugLog("타겟리스트 출력")
		local TargetListSize = 0
		for i, v in pairs( Var["KC_WhirlWind"]["TargetList"] )
		do
			TargetListSize = TargetListSize + 1
			--DebugLog("TargetList["..i.."] = "..v)
		end

		Var["KC_WhirlWind"]["TargetListSize"] 	= TargetListSize
		Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

		--DebugLog("TargetList 크기는.. "..Var["KC_WhirlWind"]["TargetListSize"] )
		--DebugLog("첫 타겟은 .."..Var["KC_WhirlWind"]["CurTargetHandle"])

		------------------------------------------------------------------------------------------
		-- 3. 킹크랩에 상태이상 걸어준다( 데이터로 처리됨 )
		--		StaSDVale01_Wheel	: 도는 애니메이션 및 주변 데미지 줌

		local AbStateList = SkillInfo["AbState_To_KingCrab"]

		-- 스킬데이터에 상태이상 걸도록 설정되어있지만, keeptime 보다 더 오래 휠윈드 스킬 시전할 수 있는 경우를 고려해, 다시 세팅
		cSetAbstate( Handle, AbStateList["SpinDamage"]["Index"], 	AbStateList["SpinDamage"]["Strength"], 		AbStateList["SpinDamage"]["KeepTime"], 		Handle )
		cSetAbstate( Handle, AbStateList["NotTargetted"]["Index"], 	AbStateList["NotTargetted"]["Strength"], 	AbStateList["NotTargetted"]["KeepTime"], 	Handle )

		-- 미리 몹을 타겟팅하고있던 플레이어들의 타겟팅 해제
		local PlayerHandleList = { cGetPlayerList( Var["MapIndex"] ) }
		-- DebugLog( "맵에 있는 유저의 수 : "..#PlayerHandleList )
		for i = 1, #PlayerHandleList
		do
			cTargetChangeNull( PlayerHandleList[i], Handle )
		end
	end

	------------------------------------------------------------------------------------------
	-- 4. 타겟디테일리스트[1] = {}을 생성, 타겟리스트[1]의 핸들값을 이용해 5개의 랜덤좌표값을 얻는다.
	--		타겟디테일리스트[1][1]["x"] = 2,
	--		타겟디테일리스트[1][1]["y"] = 2,
	--		.....
	--		타겟디테일리스트[1][5]["x"] = 2,
	--		타겟디테일리스트[1][5]["y"] = 2,

	--		타겟디테일리스트 개수는 #타겟리스트 만큼 존재

	--------------------------------------------------------------------------------
	-- ★ Var["KC_WhirlWind"] 테이블 생성된 뒤 처리할 부분
	--------------------------------------------------------------------------------

	if Var["KC_WhirlWind"] ~= nil
	then
		local CurTargetNum			= Var["KC_WhirlWind"]["CurTargetNum"]
		local CurTargetHandle 		= Var["KC_WhirlWind"]["CurTargetHandle"]

		--------------------------------------------------------------------------------
		-- ▼ 휠윈드 최대 지속시간을 체크한다. 어떤 행동중이더라도, 이 시간이 넘으면 무조건 휠윈드 스킬을 마무리짓는다.
		--------------------------------------------------------------------------------
		if Var["KingCrabProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("시간 초과! 행동중지!")
			local AbStateList = SkillInfo["AbState_To_KingCrab"]

			-- 휠윈드 상태이상 해제
			cResetAbstate( Handle, AbStateList["SpinDamage"]["Index"] )
			cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

			Var["KC_WhirlWind"] 						= nil

			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingCrabProcess"]["SkillStartTime"]	= 0
			Var["KingCrabProcess"]["SkillWorkTime"]		= 0
			Var["KingCrabProcess"]["SkillEndTime"]		= 0

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end

		--------------------------------------------------------------------------------
		-- ▼ 타겟리스트에 아직 추적할 유저가 있는 경우
		--------------------------------------------------------------------------------
		-- 추적할 타겟이 남아있으면,

		if CurTargetNum <= Var["KC_WhirlWind"]["TargetListSize"]
		then
			-- 타겟 핸들값이 없으므로, 다음 타겟으로 변경
			if CurTargetHandle == nil or CurTargetHandle == INVALID_HANDLE
			then
				--DebugLog("해당 타겟의 핸들값 == nil or INVALID_HANDLE, 다음 타겟으로 변경")
				Var["KC_WhirlWind"]["IsFollowState"] 	= false
				Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
				Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

				return ReturnAI["END"]
			end

			-- 타겟이 이미 죽었으므로, 다음 타겟으로 변경
			if cIsObjectDead( CurTargetHandle ) == 1 or cIsObjectAlreadyDead( CurTargetHandle ) == 1
			then
				--DebugLog("타겟이 죽거나 없음, 다음 타겟으로 변경")
				Var["KC_WhirlWind"]["IsFollowState"] 	= false
				Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
				Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

				return ReturnAI["END"]
			end


			local PathList = Var["KC_WhirlWind"]["PathListEachTarget"]
			--------------------------------------------------------------------------------
			-- ⊙ 해당 타겟의 개별 path 리스트가 만들어져 있지 않으면, 리스트를 생성한다.
			--------------------------------------------------------------------------------
			if PathList[CurTargetHandle] == nil
			then
				-- 타겟과의 거리가 너무 멀면, 다음 타겟으로 변경
				local distanceWithTarget = cDistanceSquar( Handle, CurTargetHandle )
				--DebugLog("타겟과의 거리["..CurTargetHandle.."] : "..distanceWithTarget)

				if cDistanceSquar( Handle, CurTargetHandle ) > ( SkillInfo["Target_Distance"] * SkillInfo["Target_Distance"] )
				then
					--DebugLog("타겟과의 거리가 너무 멀다.. 다음 타겟으로 변경")
					Var["KC_WhirlWind"]["IsFollowState"] 	= false
					Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
					Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

					return ReturnAI["END"]
				end


				--DebugLog("타겟"..CurTargetHandle.."의 path 생성시작")

				PathList[CurTargetHandle] 					= {}
				PathList[CurTargetHandle]["CurPathNum"] 	= 1

				-- 첫번째 path는 유저가 있던 자리
				PathList[CurTargetHandle][1] 		= {}
				PathList[CurTargetHandle][1]["x"],
				PathList[CurTargetHandle][1]["y"] 	= cObjectLocate( CurTargetHandle )

				PathList[CurTargetHandle][1]["x"]	= PathList[CurTargetHandle][1]["x"] + 5
				PathList[CurTargetHandle][1]["y"]	= PathList[CurTargetHandle][1]["y"] + 5

				-- 2번째 이후부터의 path는 현재 유저 좌표 기준 랜덤 좌표 추출
				for i = 2, SkillInfo["PathListEachTarget"]["ListNum"]
				do
					local Dir				= cRandomInt( 1, 90 ) * 4
					local LocateX, LocateY	= cGetAroundCoord( CurTargetHandle, Dir, SkillInfo["PathListEachTarget"]["Distance"] )

					PathList[CurTargetHandle][i] 		= {}
					PathList[CurTargetHandle][i]["x"] 	= LocateX
					PathList[CurTargetHandle][i]["y"] 	= LocateY
				end

				--[[
				-- 디버깅용. 현재 타겟의 PathList 출력
				for i = 1, SkillInfo["PathListEachTarget"]["ListNum"]
				do
					DebugLog("현재 타겟 "..CurTargetHandle.."의 [ "..i.." ][\"x\"]"..PathList[CurTargetHandle][i]["x"])
					DebugLog("현재 타겟 "..CurTargetHandle.."의 [ "..i.." ][\"y\"]"..PathList[CurTargetHandle][i]["y"])
				end
				--]]
			end

			--------------------------------------------------------------------------------
			-- ⊙ 해당 타겟의 개별 path 리스트가 만들어져 있으면
			--------------------------------------------------------------------------------
			-- 현재 타겟의 개별리스트가 만들어져 있다면, 순서에 맞게 cRunTo한다.
			if PathList[CurTargetHandle] ~= nil
			then

				local CurPathNum = PathList[CurTargetHandle]["CurPathNum"]

				-- 타겟 개별리스트 개수 내에서 정상적으로 돌고있는경우,
				if CurPathNum <= SkillInfo["PathListEachTarget"]["ListNum"]
				then

					-- 현재 path을 추적하고 있는 상태가 아니면, 타겟 추적 시작
					if Var["KC_WhirlWind"]["IsFollowState"] == false
					then
						-- 목적지 좌표값이 nil이라면, 다음 타겟으로!
						-- cRunTo 에서 목적지 좌표값 nil로 했을때 예외처리 안되있드라고...그래서 요기서 미리 해줘야함,
						if PathList[CurTargetHandle][CurPathNum]["x"] == nil or PathList[CurTargetHandle][CurPathNum]["y"] == nil
						then
							--DebugLog("CurTargetHandle의 path가 nil이라, 다음 타겟으로 이동")
							PathList[CurTargetHandle] = nil
							Var["KC_WhirlWind"]["CurTargetNum"] = Var["KC_WhirlWind"]["CurTargetNum"] + 1
							return ReturnAI["END"]
						end

						if cRunTo( Handle, PathList[CurTargetHandle][CurPathNum]["x"], PathList[CurTargetHandle][CurPathNum]["y"], SkillInfo["SpeedRate"] ) == nil
						then
							--DebugLog("달려가기 실패")
							return ReturnAI["END"]
						end
						Var["KC_WhirlWind"]["IsFollowState"] = true
						--DebugLog("출발 path : "..CurPathNum)
					end


					-- 현재 path을 추적하고 있는 상태면, 거리를 체크함
					if Var["KC_WhirlWind"]["IsFollowState"] == true
					then
						local myLocateX, myLocateY = cObjectLocate( Handle )

						--DebugLog("킹크랩 x : "..myLocateX.."킹크랩 y : "..myLocateY )
						--DebugLog("목표좌표 : "..PathList[CurTargetHandle][CurPathNum]["x"]..", "..PathList[CurTargetHandle][CurPathNum]["y"] )

						local dist =  cDistanceSquar( myLocateX, myLocateY, PathList[CurTargetHandle][CurPathNum]["x"], PathList[CurTargetHandle][CurPathNum]["y"] )

						-- 거리가 충분히 가까워지지 않았으면,
						if dist > SkillInfo["PathListEachTarget"]["Distance"]
						then
							--DebugLog("가는중.."..dist)
							return ReturnAI["END"]
						end

						-- 거리가 충분히 가까워졌으면, 다음 path로 변경
						--DebugLog("거리가 충분히 가까워졌음.. 다음 path로 변경")
						PathList[CurTargetHandle]["CurPathNum"] = PathList[CurTargetHandle]["CurPathNum"] + 1
						--DebugLog("다음 path : "..PathList[CurTargetHandle]["CurPathNum"] )

						Var["KC_WhirlWind"]["IsFollowState"] = false

						return ReturnAI["END"]
					end
				end

				-- 타겟 개별리스트 개수를 다 돌아서 빠져나온 상태,
				-- 다음 타겟으로 변경한다.

				PathList[CurTargetHandle] = nil
				Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
				Var["KC_WhirlWind"]["CurTargetHandle"]	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

				--DebugLog("현재 타겟의 path는 모두 돌았음!"..CurTargetHandle)
				--DebugLog("다음 타겟num은  : "..Var["KC_WhirlWind"]["CurTargetNum"] )

				return ReturnAI["END"]
			end

		end


		--------------------------------------------------------------------------------
		-- ▼ 타겟리스트에 있는 유저를 모두 추적완료한 경우
		--------------------------------------------------------------------------------
		--DebugLog("모든 타겟 추적완료")

		local AbStateList = SkillInfo["AbState_To_KingCrab"]

		-- 휠윈드 상태이상 해제
		cResetAbstate( Handle, AbStateList["SpinDamage"]["Index"] )
		cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

		Var["KC_WhirlWind"] 						= nil

		Var[Handle]["IsProgressSpecialSkill"] 		= false

		Var["KingCrabProcess"]["SkillStartTime"]	= 0
		Var["KingCrabProcess"]["SkillWorkTime"]		= 0
		Var["KingCrabProcess"]["SkillEndTime"]		= 0

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end
end


--------------------------------------------------------------------------------
-- KingCrab :: 소환
--------------------------------------------------------------------------------

function KC_SummonBubble( Handle, MapIndex )
cExecCheck "KC_SummonBubble"

	local Var = InstanceField[ MapIndex ]

	if Var["KingCrabProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_KingCrab["KC_SummonBubble"]

	--------------------------------------------------------------------------------
	-- ★ KC_SummonBubble 처리상, 한번만 해줘야 하는 부분(초기화)
	--------------------------------------------------------------------------------
	if Var["KC_SummonBubble"] == nil
	then
		Var["KC_SummonBubble"] = {}

		local AbStateList = SkillInfo["AbState_To_KingCrab"]

		cSetAbstate( Handle, AbStateList["NotTargetted"]["Index"], AbStateList["NotTargetted"]["Strength"], AbStateList["NotTargetted"]["KeepTime"], Handle )

		-- 미리 몹을 타겟팅하고있던 플레이어들의 타겟팅 해제
		local PlayerHandleList = { cGetPlayerList( Var["MapIndex"] ) }
		--DebugLog( "맵에 있는 유저의 수 : "..#PlayerHandleList )
		for i = 1, #PlayerHandleList
		do
			cTargetChangeNull( PlayerHandleList[i], Handle )
		end

		-- 몹을 소환할 좌표값 x, y를 SummonRegenLocate 테이블에 저장한다
		if Var["KC_SummonBubble"]["SummonRegenLocate"]  == nil
		then
			Var["KC_SummonBubble"]["SummonRegenLocate"] = {}

			local CurKingCrabX, CurKingCrabY = cObjectLocate( Handle )

			for i = 1, SkillInfo["SummonNum"]
			do
				Var["KC_SummonBubble"]["SummonRegenLocate"][i] 		= {}
				Var["KC_SummonBubble"]["SummonRegenLocate"][i]["x"],
				Var["KC_SummonBubble"]["SummonRegenLocate"][i]["y"] = cGetCoord_Circle( CurKingCrabX, CurKingCrabY, SkillInfo["SummonRadius"] )

				--[[
				-- 디버깅용, 몹이 소환될 좌표 정보를 출력
				DebugLog("----["..i.."]----")
				DebugLog("SummonRegenLocate X :"..Var["KC_SummonBubble"]["SummonRegenLocate"][i]["x"])
				DebugLog("SummonRegenLocate Y :"..Var["KC_SummonBubble"]["SummonRegenLocate"][i]["y"])
				--]]
			end
		end

		-- 소환할 시간과, 소환할 몹 순서정보를 초기화한다
		if Var["KC_SummonBubble"]["SummonTime"] == nil
		then
			Var["KC_SummonBubble"]["SummonTime"] 		= Var["CurSec"]
			Var["KC_SummonBubble"]["CurSummonSequence"] = 1

			--DebugLog("SummonTime : "		..Var["CurSec"])
			--DebugLog("CurSummonSequence : "	..Var["KC_SummonBubble"]["CurSummonSequence"])
		end
	end


	--------------------------------------------------------------------------------
	-- ★ Var["KC_SummonBubble"] 테이블 생성된 뒤 처리할 부분
	--------------------------------------------------------------------------------
	if Var["KC_SummonBubble"] ~= nil
	then
		if Var["KC_SummonBubble"]["SummonTime"] ~= nil
		then

			if Var["KC_SummonBubble"]["SummonTime"] > Var["CurSec"]
			then
				return ReturnAI["END"]
			end

			if Var["KC_SummonBubble"]["CurSummonSequence"] <= SkillInfo["SummonNum"]
			then
				local CurSummonMob = Var["KC_SummonBubble"]["SummonRegenLocate"][Var["KC_SummonBubble"]["CurSummonSequence"]]

				local CurSummonHandle = cMobRegen_XY( MapIndex, SkillInfo["SummonIndex"], CurSummonMob["x"], CurSummonMob["y"] )

				if CurSummonHandle == nil
				then
					-- DebugLog("몹 리젠 실패"..Var["KC_SummonBubble"]["CurSummonSequence"] )
					-- 랜덤으로 추출한 좌표가 블럭인 경우, 몹리젠이 실패하지만 별도의 예외처리는 하지않는다.
					-- 그냥 다음 몹 리젠하도록 넘어간다.
				end

				if CurSummonHandle ~= nil
				then
					if cSkillBlast( CurSummonHandle, CurSummonHandle, SkillInfo["SummonSkillIndex"] ) == nil
					then
						ErrorLog("몹 스킬사용실패"..Var["KC_SummonBubble"]["CurSummonSequence"] )
					end
				end

				-- 다음 몹 리젠을 위한 정보 세팅
				Var["KC_SummonBubble"]["CurSummonSequence"] 	= Var["KC_SummonBubble"]["CurSummonSequence"] + 1
				Var["KC_SummonBubble"]["SummonTime"]			= Var["KC_SummonBubble"]["SummonTime"] + SkillInfo["SummonTick"]

				--DebugLog("다음 리젠할 시간은 : "..Var["KC_SummonBubble"]["SummonTime"])

				return ReturnAI["END"]
			end

			-- 리젠테이블 다 돌았으니깐, 초기화
			Var["KC_SummonBubble"]["SummonTime"] 		= nil
			Var["KC_SummonBubble"]["CurSummonSequence"] = nil
		end

		--------------------------------------------------------------------------------
		-- ▼ 몹 소환 작업이 끝났으므로, 땅 위로 올라와도 되는 시간인지 체크한다
		--------------------------------------------------------------------------------
		if Var["KingCrabProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			--DebugLog("올라오기 대기중..")
			return ReturnAI["END"]
		end

		if Var["KingCrabProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("이제 땅위로 올라올 시간!")
			local AbStateList = SkillInfo["AbState_To_KingCrab"]

			cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

			Var["KC_SummonBubble"]						= nil

			-- 스킬 처리 다끝났으면,
			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingCrabProcess"]["SkillStartTime"]	= 0
			Var["KingCrabProcess"]["SkillWorkTime"]		= 0
			Var["KingCrabProcess"]["SkillEndTime"]		= 0

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end

	return ReturnAI["END"]

end
