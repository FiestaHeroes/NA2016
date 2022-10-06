
--------------------------------------------------------------------------------
-- KingSlime :: 최초낙하( 리젠 후 스킬 )
--------------------------------------------------------------------------------

function KS_ShowUp( Handle, MapIndex )
cExecCheck "KS_ShowUp"

	local Var = InstanceField[ MapIndex ]

	if Var["KingSlimeProcess"]["SkillEndTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	-- 스킬 처리 다끝났으면,
	Var[Handle]["IsProgressSpecialSkill"] 		= false
	Var["KingSlimeProcess"]["SkillStartTime"]	= 0
	Var["KingSlimeProcess"]["SkillEndTime"]		= 0

	cAIScriptSet( Handle )
	return ReturnAI["END"]
end


--------------------------------------------------------------------------------
-- KingSlime :: 강림
--------------------------------------------------------------------------------
function KS_Warp( Handle, MapIndex )
cExecCheck "KS_Warp"

	local Var = InstanceField[ MapIndex ]

	if Var["KingSlimeProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo 	= SkillInfo_KingSlime["KS_Warp"]
	local AbStateList 	= SkillInfo["AbState_To_KingSlime"]
	--------------------------------------------------------------------------------
	-- ★ KS_Warp 처리상, 한번만 해줘야 하는 부분(초기화)
	--------------------------------------------------------------------------------
	if Var["KS_Warp"] == nil
	then
		DebugLog("KS_Warp 테이블 생성")
		Var["KS_Warp"] = {}

		-- 킹슬라임에 상태이상 걸어준다
		cSetAbstate( Handle, AbStateList["NotTargetted"]["Index"], 	AbStateList["NotTargetted"]["Strength"], 	AbStateList["NotTargetted"]["KeepTime"], 	Handle )

		-- 미리 몹을 타겟팅하고있던 플레이어들의 타겟팅 해제
		local PlayerHandleList = { cGetPlayerList( Var["MapIndex"] ) }
		-- DebugLog( "맵에 있는 유저의 수 : "..#PlayerHandleList )
		for i = 1, #PlayerHandleList
		do
			cTargetChangeNull( PlayerHandleList[i], Handle )
		end
	end

	--------------------------------------------------------------------------------
	-- ★ Var["KS_Warp"] 테이블 생성된 뒤 처리할 부분
	--------------------------------------------------------------------------------
	if Var["KS_Warp"] ~= nil
	then
		if Var["KingSlimeProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			return ReturnAI["END"]
		end

		if Var["KingSlimeProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			DebugLog("KS_Warp 모든 스킬처리완료!")
			--상태이상 해제
			cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

			Var["KS_Warp"]								= nil

			-- 스킬 처리 다끝났으면,
			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingSlimeProcess"]["SkillStartTime"]	= 0
			Var["KingSlimeProcess"]["SkillWorkTime"]	= 0
			Var["KingSlimeProcess"]["SkillEndTime"]		= 0

			Var["KingSlimeProcess"]["CurSkillIndex"]	= nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end
end






--------------------------------------------------------------------------------
-- KingSlime :: 폭격( 몹 소환 )
--------------------------------------------------------------------------------

function KS_BombSlimePiece( Handle, MapIndex )
cExecCheck "KS_BombSlimePiece"

	local Var = InstanceField[ MapIndex ]

	if Var["KingSlimeProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_KingSlime["KS_BombSlimePiece"]

	--------------------------------------------------------------------------------
	-- ★ KS_BombSlimePiece 처리상, 한번만 해줘야 하는 부분(초기화)
	--------------------------------------------------------------------------------
	if Var["KS_BombSlimePiece"] == nil
	then
		Var["KS_BombSlimePiece"] = {}
		--DebugLog("KS_BombSlimePiece 테이블 생성")

		-- 몹을 소환할 좌표값 x, y를 SummonRegenLocate 테이블에 저장한다
		if Var["KS_BombSlimePiece"]["SummonRegenLocate"]  == nil
		then
			Var["KS_BombSlimePiece"]["SummonRegenLocate"] = {}

			local CurKingSlimeX, CurKingSlimeY = cObjectLocate( Handle )

			for i = 1, SkillInfo["SummonNum"]
			do
				Var["KS_BombSlimePiece"]["SummonRegenLocate"][i] 		= {}
				Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["x"],
				Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["y"] = cGetCoord_Circle( CurKingSlimeX, CurKingSlimeY, SkillInfo["SummonRadius"] )

				--[[
				-- 디버깅용, 몹이 소환될 좌표 정보를 출력
				DebugLog("----["..i.."]----")
				DebugLog("SummonRegenLocate X :"..Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["x"])
				DebugLog("SummonRegenLocate Y :"..Var["KS_BombSlimePiece"]["SummonRegenLocate"][i]["y"])
				--]]
			end
		end

		-- 소환할 시간과, 소환할 몹 순서정보를 초기화한다
		if Var["KS_BombSlimePiece"]["SummonTime"] == nil
		then
			Var["KS_BombSlimePiece"]["SummonTime"] 			= Var["CurSec"]
			Var["KS_BombSlimePiece"]["CurSummonSequence"] 	= 1

			--DebugLog("SummonTime : "		..Var["CurSec"])
			--DebugLog("CurSummonSequence : "	..Var["KS_BombSlimePiece"]["CurSummonSequence"])
		end
	end


	--------------------------------------------------------------------------------
	-- ★ Var["KS_BombSlimePiece"] 테이블 생성된 뒤 처리할 부분
	--------------------------------------------------------------------------------
	if Var["KS_BombSlimePiece"] ~= nil
	then
		if Var["KS_BombSlimePiece"]["SummonTime"] ~= nil
		then

			if Var["KS_BombSlimePiece"]["SummonTime"] > Var["CurSec"]
			then
				return ReturnAI["END"]
			end

			if Var["KS_BombSlimePiece"]["CurSummonSequence"] <= SkillInfo["SummonNum"]
			then
				-- 소환몹이 리젠될 좌표를 저장하는 변수
				local CurSummonMob = Var["KS_BombSlimePiece"]["SummonRegenLocate"][Var["KS_BombSlimePiece"]["CurSummonSequence"]]

				-- 소환몹의 인덱스와 소환몹이 사용할 스킬인덱스. 보스몹이 사용한 스킬인덱스에 따라 다르다.
				local CurSummonMobIndex = nil
				local CurSummonSkillIndex = nil

				-- 킹슬라임이 SD_SlimeLump 만 소환하는 스킬 사용시.
				if Var["KingSlimeProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Lump"]
				then
					--DebugLog("킹슬라임 소환스킬.."..SkillInfo["SkillIndex_Lump"] )
					CurSummonMobIndex 	= SkillInfo["SummonLump"]["SummonIndex"]
					CurSummonSkillIndex = SkillInfo["SummonLump"]["SummonSkillIndex"]

				-- 킹슬라임이 SD_SlimeIce 만 소환하는 스킬 사용시.
				elseif Var["KingSlimeProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_Ice"]
				then
					--DebugLog("킹슬라임 소환스킬.."..SkillInfo["SkillIndex_Ice"] )
					CurSummonMobIndex 	= SkillInfo["SummonIce"]["SummonIndex"]
					CurSummonSkillIndex = SkillInfo["SummonIce"]["SummonSkillIndex"]

				-- 킹슬라임이 둘 다 소환하는 스킬 사용시.( 짝수/홀수 교대로 소환몹 종류변경 )
				elseif Var["KingSlimeProcess"]["CurSkillIndex"] == SkillInfo["SkillIndex_All"]
				then
					--DebugLog("킹슬라임 소환스킬.."..SkillInfo["SkillIndex_All"] )

					if Var["KS_BombSlimePiece"]["CurSummonSequence"] % 2 == 0
					then
						CurSummonMobIndex 	= SkillInfo["SummonLump"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonLump"]["SummonSkillIndex"]

					elseif Var["KS_BombSlimePiece"]["CurSummonSequence"] % 2 == 1
					then
						CurSummonMobIndex 	= SkillInfo["SummonIce"]["SummonIndex"]
						CurSummonSkillIndex = SkillInfo["SummonIce"]["SummonSkillIndex"]
					end
				-- 이런 경우는 없지만.. 디버깅 테스트용도..
				else
					ErrorLog("KS_BombSlimePiece 루틴, 알수없는 스킬 사용중..")
				end

				-- 소환한 몹의 핸들값을 갖는다.
				local CurSummonHandle = cMobRegen_XY( MapIndex, CurSummonMobIndex, CurSummonMob["x"], CurSummonMob["y"] )

				if CurSummonHandle == nil
				then
					-- DebugLog("몹 리젠 실패"..Var["KS_BombSlimePiece"]["CurSummonSequence"] )
					-- 랜덤으로 추출한 좌표가 블럭인 경우, 몹리젠이 실패하지만 별도의 예외처리는 하지않는다.
					-- 그냥 다음 몹 리젠하도록 넘어간다.
				end


				if CurSummonHandle ~= nil
				then
					if cSkillBlast( CurSummonHandle, CurSummonHandle, CurSummonSkillIndex ) == nil
					then
						ErrorLog("몹 스킬사용실패"..Var["KS_BombSlimePiece"]["CurSummonSequence"] )
					end
				end


				-- 다음 몹 리젠을 위한 정보 세팅
				Var["KS_BombSlimePiece"]["CurSummonSequence"] 	= Var["KS_BombSlimePiece"]["CurSummonSequence"] + 1
				Var["KS_BombSlimePiece"]["SummonTime"]			= Var["KS_BombSlimePiece"]["SummonTime"] + SkillInfo["SummonTick"]

				--DebugLog("다음 리젠할 시간은 : "..Var["KS_BombSlimePiece"]["SummonTime"])

				return ReturnAI["END"]
			end

			-- 리젠테이블 다 돌았으니깐, 초기화
			Var["KS_BombSlimePiece"]["SummonTime"] 			= nil
			Var["KS_BombSlimePiece"]["CurSummonSequence"] 	= nil
		end

		--------------------------------------------------------------------------------
		-- ▼ 몹 소환 작업이 끝났으므로, 스킬 종료해도 되는 시간인지 체크한다
		--------------------------------------------------------------------------------
		-- 스킬 처리는 완료했지만, 아직 소환애니메이션 중이라면 대기
		if Var["KingSlimeProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			--DebugLog("올라오기 대기중..")
			return ReturnAI["END"]
		end

		if Var["KingSlimeProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("KS_BombSlimePiece 모든 스킬처리완료!")
			Var["KS_BombSlimePiece"]					= nil

			-- 스킬 처리 다끝났으면,
			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingSlimeProcess"]["SkillStartTime"]	= 0
			Var["KingSlimeProcess"]["SkillWorkTime"]	= 0
			Var["KingSlimeProcess"]["SkillEndTime"]		= 0

			Var["KingSlimeProcess"]["CurSkillIndex"]	= nil

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end

	return ReturnAI["END"]
end
