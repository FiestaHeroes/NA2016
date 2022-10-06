

--------------------------------------------------------------------------------
-- MiniDragon :: 리젠후 착륙
--------------------------------------------------------------------------------

function MD_ShowUp( Handle, MapIndex )
cExecCheck "MD_ShowUp"

	local Var = InstanceField[ MapIndex ]

	if Var["MiniDragonProcess"]["SkillEndTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	-- 스킬 처리 다끝났으면,
	Var[Handle]["IsProgressSpecialSkill"] 		= false
	Var["MiniDragonProcess"]["SkillStartTime"]	= 0
	Var["MiniDragonProcess"]["SkillEndTime"]	= 0

	cAIScriptSet( Handle )
	return ReturnAI["END"]

end

--------------------------------------------------------------------------------
-- MiniDragon :: 정령소환
--------------------------------------------------------------------------------

function MD_SummonSoul( Handle, MapIndex )
cExecCheck "MD_SummonSoul"

	local Var = InstanceField[ MapIndex ]

	if Var["MiniDragonProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_MiniDragon["MD_SummonSoul"]

	--------------------------------------------------------------------------------
	-- ★ MD_SummonSoul 처리상, 한번만 해줘야 하는 부분(초기화)
	--------------------------------------------------------------------------------
	if Var["MD_SummonSoul"] == nil
	then

		Var["MD_SummonSoul"] = {}
		--DebugLog("KS_BombSlimePiece 테이블 생성")

		-- 몹을 소환할 좌표값 x, y를 SummonRegenLocate 테이블에 저장한다
		if Var["MD_SummonSoul"]["SummonRegenLocate"]  == nil
		then
			Var["MD_SummonSoul"]["SummonRegenLocate"] = {}

			local CurDragonX, CurDragonY = cObjectLocate( Handle )

			for i = 1, SkillInfo["SummonNum"]
			do
				Var["MD_SummonSoul"]["SummonRegenLocate"][i] 		= {}
				Var["MD_SummonSoul"]["SummonRegenLocate"][i]["x"],
				Var["MD_SummonSoul"]["SummonRegenLocate"][i]["y"] 	= cGetCoord_Circle( CurDragonX, CurDragonY, SkillInfo["SummonRadius"] )

				--[[
				-- 디버깅용, 몹이 소환될 좌표 정보를 출력
				DebugLog("----["..i.."]----")
				DebugLog("SummonRegenLocate X :"..Var["MD_SummonSoul"]["SummonRegenLocate"][i]["x"])
				DebugLog("SummonRegenLocate Y :"..Var["MD_SummonSoul"]["SummonRegenLocate"][i]["y"])
				--]]
			end
		end

		-- 소환할 시간과, 소환할 몹 순서정보를 초기화한다
		if Var["MD_SummonSoul"]["SummonTime"] == nil
		then
			Var["MD_SummonSoul"]["SummonTime"] 			= Var["CurSec"]
			Var["MD_SummonSoul"]["CurSummonSequence"] 	= 1

			--DebugLog("SummonTime : "		..Var["CurSec"])
			--DebugLog("CurSummonSequence : "	..Var["MD_SummonSoul"]["CurSummonSequence"])
		end
	end


	--------------------------------------------------------------------------------
	-- ★ Var["KS_BombSlimePiece"] 테이블 생성된 뒤 처리할 부분
	--------------------------------------------------------------------------------
	if Var["MD_SummonSoul"] ~= nil
	then
		if Var["MD_SummonSoul"]["SummonTime"] ~= nil
		then

			if Var["MD_SummonSoul"]["SummonTime"] > Var["CurSec"]
			then
				return ReturnAI["END"]
			end

			if Var["MD_SummonSoul"]["CurSummonSequence"] <= SkillInfo["SummonNum"]
			then
				-- 소환몹이 리젠될 좌표를 저장하는 변수
				local CurSummonMob = Var["MD_SummonSoul"]["SummonRegenLocate"][Var["MD_SummonSoul"]["CurSummonSequence"]]

				-- 소환몹의 인덱스와 소환몹이 사용할 스킬인덱스. 보스몹이 사용한 스킬인덱스에 따라 다르다.
				local CurSummonMobIndex 		= nil
				local CurSummonSkillIndex 		= nil

				-- 미니드래곤이 SD_SpiritFire 만 소환하는 스킬 사용시.
				if Var["MiniDragonProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Fire"]
				then
					--DebugLog("미니드래곤 소환스킬.."..SkillInfo["SkillIndex_Fire"] )
					CurSummonMobIndex 		= SkillInfo["SummonFire"]["SummonIndex"]
					CurSummonSkillIndex 	= SkillInfo["SummonFire"]["SummonSkillIndex"]

				-- 미니드래곤이 SD_SpiritIce 만 소환하는 스킬 사용시.
				elseif Var["MiniDragonProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Ice"]
				then
					--DebugLog("미니드래곤 소환스킬.."..SkillInfo["SkillIndex_Ice"] )
					CurSummonMobIndex 		= SkillInfo["SummonIce"]["SummonIndex"]
					CurSummonSkillIndex 	= SkillInfo["SummonIce"]["SummonSkillIndex"]

				-- 미니드래곤이 둘 다 소환하는 스킬 사용시.( 짝수/홀수 교대로 소환몹 종류변경 )
				elseif Var["MiniDragonProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_All"]
				then
					--DebugLog("미니드래곤 소환스킬.."..SkillInfo["SkillIndex_All"] )

					if Var["MD_SummonSoul"]["CurSummonSequence"] % 2 == 0
					then
						CurSummonMobIndex 	= SkillInfo["SummonFire"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonFire"]["SummonSkillIndex"]

					elseif Var["MD_SummonSoul"]["CurSummonSequence"] % 2 == 1
					then
						CurSummonMobIndex 	= SkillInfo["SummonIce"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonIce"]["SummonSkillIndex"]
					end
				-- 이런 경우는 없지만.. 디버깅 테스트용도..
				else
					ErrorLog("MD_SummonSoul 루틴, 알수없는 스킬 사용중..")
				end


				-- 소환한 몹의 핸들값을 갖는다.
				local CurSummonHandle = cMobRegen_XY( MapIndex, CurSummonMobIndex, CurSummonMob["x"], CurSummonMob["y"] )

				if CurSummonHandle == nil
				then
					-- DebugLog("몹 리젠 실패"..Var["MD_SummonSoul"]["CurSummonSequence"] )
					-- 랜덤으로 추출한 좌표가 블럭인 경우, 몹리젠이 실패하지만 별도의 예외처리는 하지않는다.
					-- 그냥 다음 몹 리젠하도록 넘어간다.
				end

				if CurSummonHandle ~= nil
				then
					if cSkillBlast( CurSummonHandle, CurSummonHandle, CurSummonSkillIndex ) == nil
					then
						ErrorLog("몹 스킬사용실패"..Var["MD_SummonSoul"]["CurSummonSequence"] )
					end
				end

				-- 다음 몹 리젠을 위한 정보 세팅
				Var["MD_SummonSoul"]["CurSummonSequence"] 	= Var["MD_SummonSoul"]["CurSummonSequence"] + 1
				Var["MD_SummonSoul"]["SummonTime"]			= Var["MD_SummonSoul"]["SummonTime"] + SkillInfo["SummonTick"]

				--DebugLog("다음 리젠할 시간은 : "..Var["MD_SummonSoul"]["SummonTime"])

				return ReturnAI["END"]
			end

			-- 리젠테이블 다 돌았으니깐, 초기화
			Var["MD_SummonSoul"]["SummonTime"] 			= nil
			Var["MD_SummonSoul"]["CurSummonSequence"] 	= nil

		end


		--------------------------------------------------------------------------------
		-- ▼ 몹 소환 작업이 끝났으므로, 스킬 종료해도 되는 시간인지 체크한다
		--------------------------------------------------------------------------------
		-- 스킬 처리는 완료했지만, 아직 소환애니메이션 중이라면 대기
		if Var["MiniDragonProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			--DebugLog("애니메이션 끝까지 재생 대기중..")
			return ReturnAI["END"]
		end

		if Var["MiniDragonProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("MD_SummonSoul 모든 스킬처리완료!")
			Var["MD_SummonSoul"]					= nil

			-- 스킬 처리 다끝났으면,
			Var[Handle]["IsProgressSpecialSkill"] 			= false

			Var["MiniDragonProcess"]["SkillStartTime"]		= 0
			Var["MiniDragonProcess"]["SkillWorkTime"]		= 0
			Var["MiniDragonProcess"]["SkillEndTime"]		= 0

			Var["MiniDragonProcess"]["CurSkillIndex"]		= nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end

	return ReturnAI["END"]
end
