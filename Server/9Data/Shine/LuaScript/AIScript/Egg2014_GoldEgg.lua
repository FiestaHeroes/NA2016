require( "common" )


-- Data
-- 보상 상태이상 KeepTime: 1000 = 1초
REWARD_ABSTATE =
{
	REVIVE	= { Index = "StaE_Egg2014_SelfRevive",	Strength = 1, KeepTime = (60*60*1000), },
	EXP_UP	= { Index = "StaE_Egg2014_ExpUp",		Strength = 1, KeepTime = (60*60*1000), },
	DROP_UP	= { Index = "StaE_Egg2014_DropRateUp",	Strength = 1, KeepTime = (60*60*1000), },
}

-- 큰달걀 충돌 횟수에 따른 보상 상태이상
REWARD_ABSTATE_TABLE =
{
--[[ 1 ]]	{ REWARD_ABSTATE["REVIVE"],	},
--[[ 2 ]]	{ REWARD_ABSTATE["REVIVE"],	REWARD_ABSTATE["EXP_UP"],	},
--[[ 3 ]]	{ REWARD_ABSTATE["REVIVE"],	REWARD_ABSTATE["DROP_UP"],	},
--[[ 4 ]]	{ REWARD_ABSTATE["REVIVE"],	REWARD_ABSTATE["EXP_UP"],	REWARD_ABSTATE["DROP_UP"],	},
}

-- 큰달걀 리젠 위치
BIGEGG_REGEN_DATA =
{
--[[ 1 ]]	{ Index = "Egg2014_BigEgg",	RegenX = 18427,	RegenY = 15754,	RegenD = 100, },
--[[ 2 ]]	{ Index = "Egg2014_BigEgg",	RegenX = 13598,	RegenY = 15727,	RegenD = 100, },
--[[ 3 ]]	{ Index = "Egg2014_BigEgg",	RegenX = 14685,	RegenY =  9746,	RegenD = 100, },
--[[ 4 ]]	{ Index = "Egg2014_BigEgg",	RegenX = 11327,	RegenY = 13423,	RegenD = 100, },
--[[ 5 ]]	{ Index = "Egg2014_BigEgg",	RegenX = 17004,	RegenY = 11435,	RegenD = 100, },
--[[ 6 ]]	{ Index = "Egg2014_BigEgg",	RegenX = 16066,	RegenY = 10320,	RegenD = 100, },
}

-- 황금달걀 애니 정보
GOLDEGG_BROKEN_ANIMATE_DATA =
{
--[[ 1 ]]	{ Index = "Egg2014_GoldEgg_1st_broken",	KeepTime = 1600, },
--[[ 2 ]]	{ Index = "Egg2014_GoldEgg_Stand01", 	KeepTime = 2000, },
}

-- 황금달걀 몹챗 인덱스
GOLDEGG_MOBCHAT_DATA =
{
	"Egg2014_MC01",
	"Egg2014_MC02",
}

-- 공지사항 인덱스
NOTICE_DATA =
{
	Hosheming_Regen	= "Egg2014_A01",
	GoldEgg_Regen	= "Egg2014_A02",
}



-- Define
BIGEGG_MOVE_DIST			= 200						-- 큰달걀 한번에 이동 거리
BIGEGG_MOVE_SPEED_RATE		= 2500						-- 큰달걀 이속 천분율
BIGEGG_RETURN_WAIT_TIME		= 30						-- 큰달걀 움직임 없을 시 다시 리젠 대기 시간
GOLDEGG_MOBCHAT_TICK		= 20						-- 황금달걀 몹챗 간격
GOLDEGG_DIRECT				= 135						-- 홍금달걀 바라보는 방향
REWARD_RANGE				= 2000						-- 보상 상태이상 범위
HOSHEMING_INDEX				= "Egg2014_Hosheming"		-- 호세밍 인덱스
HOSHEMING_ABSTATE			= "StaE_Egg2014_Hosheming"	-- 호세밍 상태이상 인덱스
HOSHEMING_DIRECT			= 135						-- 호세밍 바라보는 방향
CRUSH_RANGE					= 150						-- 충돌 범위
CRUSH_SOUND					= "interface/SFX_Critical01"-- 충돌 사운드


-- Global Variables
gGoldEgg = {}
gBigEgg = {}

gHoMobChatTick = 0			-- 호세밍 몹챗 관련 처리 추가


function DummyRoutine( Handle, MapIndex )
	return ReturnAI["END"]
end



-- Main Function
function Egg2014_GoldEgg( Handle, MapIndex )
cExecCheck( "Egg2014_GoldEgg" )


	if MapIndex ~= "Eld"
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	local Var = gGoldEgg[Handle]

	if cIsObjectDead( Handle ) == 1
	then
		DeleteSubObject( Var )
		cAIScriptSet( Handle )
		gGoldEgg[Handle] = nil

		return ReturnAI["END"]
	end


	local CurSec = cCurrentSecond()

	if Var == nil
	then

		gGoldEgg[Handle]				= {}

		Var								= gGoldEgg[Handle]

		Var["MapIndex"] 				= MapIndex
		Var["Handle"]					= Handle


		Var["RoutineTick"]				= CurSec
		Var["MobChatTick"]				= CurSec
		Var["MobChatIndex"]				= 1

		Var["BigEggList"]				= {}		-- 큰달걀 리스트. Handle

		Var["BrokenStepStartTime"]		= nil		-- 황금달걀 부서짐 스탭 시작 시간.
		Var["BrokenStep"]				= nil		-- 황금달걀 부서짐 스탭 단계.
		Var["BrokenAni"]				= nil		-- 황금달걀 부서짐 애니 nil == 해야됨, nil ~= 대기
		Var["CrushCount"]				= 0			-- 황금달걀 큰달걀 충돌 횟수.


		-- 큰달걀 리젠 처리
		for i = 1, #BIGEGG_REGEN_DATA
		do
			local hBigEgg = cMobRegen_XY( Var["MapIndex"], BIGEGG_REGEN_DATA[i]["Index"],
															BIGEGG_REGEN_DATA[i]["RegenX"],
															BIGEGG_REGEN_DATA[i]["RegenY"],
															BIGEGG_REGEN_DATA[i]["RegenD"] )

			if hBigEgg == nil
			then
				DeleteSubObject( Var )
				cAIScriptSet( Var["Handle"] )
				cNPCVanish( Var["Handle"] )
				cNPCVanish( hBigEgg )
				gGoldEgg[Handle] = nil

				return ReturnAI["END"]
			end

			local CurX, CurY = cObjectLocate( hBigEgg )

			if CurX == nil or CurY == nil
			then
				DeleteSubObject( Var )
				cAIScriptSet( Var["Handle"] )
				cNPCVanish( Var["Handle"] )
				cNPCVanish( hBigEgg )
				gGoldEgg[Handle] = nil

				return ReturnAI["END"]
			end

			cAIScriptSet( hBigEgg, Var["Handle"] )
			cAIScriptFunc( hBigEgg, "Entrance",  "DummyRoutine" )
			cAIScriptFunc( hBigEgg, "NPCAction", "BigEgg_NPCAction" )


			Var["BigEggList"][i] = hBigEgg

			gBigEgg[hBigEgg] = {}

			gBigEgg[hBigEgg]["Handle"]			= hBigEgg
			gBigEgg[hBigEgg]["MapIndex"]		= Var["MapIndex"]
			gBigEgg[hBigEgg]["RegenX"]			= CurX
			gBigEgg[hBigEgg]["RegenY"]			= CurY
			gBigEgg[hBigEgg]["PrevX"]			= CurX
			gBigEgg[hBigEgg]["PrevY"]			= CurY
			gBigEgg[hBigEgg]["LastMoveTime"]	= CurSec

		end

		cScriptMsg( Var["MapIndex"], nil, NOTICE_DATA["GoldEgg_Regen"] )
		cSetObjectDirect( Var["Handle"], GOLDEGG_DIRECT )

	end


	-- 루틴 틱
	if Var["RoutineTick"] > CurSec
	then
		return ReturnAI["END"]
	end

	Var["RoutineTick"] = CurSec + 0.1




	-- 큰달걀 루틴 처리
	for i = 1, #BIGEGG_REGEN_DATA
	do
		if Var["BigEggList"][i] ~= nil
		then

			if cIsObjectDead( Var["BigEggList"][i] ) == 1
			then

				cAIScriptSet( Var["BigEggList"][i] )
				gBigEgg[ Var["BigEggList"][i] ] = nil
				Var["BigEggList"][i] = nil

			else

				local BigEgg = gBigEgg[ Var["BigEggList"][i] ]
				local CurX, CurY = cObjectLocate( BigEgg["Handle"] )

				if CurX == nil or CurY == nil
				then
					cAIScriptSet( BigEgg["Handle"] )
					cNPCVanish( BigEgg["Handle"] )
					gBigEgg[ Var["BigEggList"][i] ] = nil
					Var["BigEggList"][i] = nil
				else

					-- 현재 좌표가 리젠 좌표랑 같으면 시간 갱신
					if CurX == BigEgg["RegenX"] and CurY == BigEgg["RegenY"]
					then
						BigEgg["LastMoveTime"] = CurSec
					end

					-- 현재 좌표가 이전 좌표랑 다르면 시간 갱신
					if CurX ~= BigEgg["PrevX"] and CurY ~= BigEgg["PrevY"]
					then
						BigEgg["LastMoveTime"]	= CurSec
						BigEgg["PrevX"]			= CurX
						BigEgg["PrevY"]			= CurY
					end

					-- 가만히 있던 시간 확인
					if BigEgg["LastMoveTime"] + BIGEGG_RETURN_WAIT_TIME <= CurSec
					then

						local hBigEgg = cMobRegen_XY( Var["MapIndex"], BIGEGG_REGEN_DATA[i]["Index"],
																		BIGEGG_REGEN_DATA[i]["RegenX"],
																		BIGEGG_REGEN_DATA[i]["RegenY"],
																		BIGEGG_REGEN_DATA[i]["RegenD"] )

						local NewX, NewY = cObjectLocate( hBigEgg )

						if hBigEgg ~= nil and NewX ~= nil and NewY ~= nil
						then

							cAIScriptSet( BigEgg["Handle"] )
							cNPCVanish( BigEgg["Handle"] )
							gBigEgg[ Var["BigEggList"][i] ] = nil

							cAIScriptSet( hBigEgg, Var["Handle"] )
							cAIScriptFunc( hBigEgg, "Entrance",  "DummyRoutine" )
							cAIScriptFunc( hBigEgg, "NPCAction", "BigEgg_NPCAction" )

							Var["BigEggList"][i] = hBigEgg

							gBigEgg[hBigEgg] = {}

							gBigEgg[hBigEgg]["Handle"]			= hBigEgg
							gBigEgg[hBigEgg]["MapIndex"]		= Var["MapIndex"]
							gBigEgg[hBigEgg]["RegenX"]			= NewX
							gBigEgg[hBigEgg]["RegenY"]			= NewY
							gBigEgg[hBigEgg]["PrevX"]			= NewX
							gBigEgg[hBigEgg]["PrevY"]			= NewY
							gBigEgg[hBigEgg]["LastMoveTime"]	= CurSec

						end

					else
						-- 충돌 성공
						if cDistanceSquar( Var["Handle"], BigEgg["Handle"] ) <= (CRUSH_RANGE * CRUSH_RANGE)
						then

							cObjectSound( Var["Handle"], CRUSH_SOUND )
							cAIScriptSet( BigEgg["Handle"] )
							cKillObject( BigEgg["Handle"] )
							--cNPCVanish( BigEgg["Handle"] )
							gBigEgg[ Var["BigEggList"][i] ] = nil
							Var["BigEggList"][i] = nil

							Var["CrushCount"] = Var["CrushCount"] + 1
							if Var["BrokenStepStartTime"] == nil
							then
								Var["BrokenStepStartTime"] = CurSec
							end

						end
					end
				end

			end

		end

	end


	-- 부서짐 체크
	if Var["BrokenStepStartTime"] ~= nil
	then

		if Var["BrokenStep"] == nil
		then
			Var["BrokenStep"] = 1
		end


		if Var["BrokenStep"] <= #GOLDEGG_BROKEN_ANIMATE_DATA
		then

			if Var["BrokenAni"] == nil
			then
				cAnimate( Var["Handle"], "start", GOLDEGG_BROKEN_ANIMATE_DATA[ Var["BrokenStep"] ]["Index"] )
				Var["BrokenAni"] = 1
			end

			if Var["BrokenStepStartTime"] + (GOLDEGG_BROKEN_ANIMATE_DATA[ Var["BrokenStep"] ]["KeepTime"] / 1000) <= CurSec
			then
				Var["BrokenStepStartTime"]	= CurSec
				Var["BrokenStep"]			= Var["BrokenStep"] + 1
				Var["BrokenAni"]			= nil
			end

		end


		if Var["BrokenStep"] > #GOLDEGG_BROKEN_ANIMATE_DATA
		then

			local hHosheming = cMobRegen_Obj( HOSHEMING_INDEX, Var["Handle"] )

			if hHosheming ~= nil
			then
				cSetAbstate( hHosheming, HOSHEMING_ABSTATE, 1, 200000000 )
				cSetObjectDirect( hHosheming, HOSHEMING_DIRECT )
				cScriptMsg( Var["MapIndex"], nil, NOTICE_DATA["Hosheming_Regen"] )

				cAIScriptSet( hHosheming, Var["Handle"] )
				cAIScriptFunc( hHosheming, "Entrance",  "HoshemingRoutine" )
			end


			cKillObject( Var["Handle"] )

			local RewardIndex = Var["CrushCount"]

			if RewardIndex > #REWARD_ABSTATE_TABLE
			then
				RewardIndex = #REWARD_ABSTATE_TABLE
			end

			for i = 1, #REWARD_ABSTATE_TABLE[RewardIndex]
			do
				cSetAbstate_Range( Var["Handle"], REWARD_RANGE, ObjectType["Player"], REWARD_ABSTATE_TABLE[RewardIndex][i]["Index"],
																						REWARD_ABSTATE_TABLE[RewardIndex][i]["Strength"],
																						REWARD_ABSTATE_TABLE[RewardIndex][i]["KeepTime"] )
			end

		end

	else

		-- 부서지는중 아니면 몹챗 처리

		if #GOLDEGG_MOBCHAT_DATA >= 1
		then

			if Var["MobChatTick"] + GOLDEGG_MOBCHAT_TICK < CurSec
			then

				Var["MobChatTick"] = CurSec


				cScriptMsg( Var["MapIndex"], Var["Handle"], GOLDEGG_MOBCHAT_DATA[ Var["MobChatIndex"] ] )

				if Var["MobChatIndex"] >= #GOLDEGG_MOBCHAT_DATA
				then
					Var["MobChatIndex"] = 1
				else
					Var["MobChatIndex"] = Var["MobChatIndex"] + 1
				end

			end

		end

	end


	return ReturnAI["END"]

end



function BigEgg_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "BigEgg_NPCAction" )

	local Var = gBigEgg[NPCHandle]

	if Var == nil
	then
		return
	end

	local PlayerMode = cGetObjectMode( PlyHandle )

	if PlayerMode == nil
	then
		return
	end

	if PlayerMode == "house" or PlayerMode == "booth"
	then
		return
	end

	local PlayerX, PlayerY = cObjectLocate( PlyHandle )
	local BigEggX, BigEggY = cObjectLocate( NPCHandle )

	if PlayerX == nil or PlayerY == nil or BigEggX == nil or BigEggY == nil
	then
		return
	end

	local Dist = cDistanceSquar( PlayerX, PlayerY, BigEggX, BigEggY )

	Dist = math.sqrt( Dist )


	local _x, _y

	_x = BigEggX - PlayerX
	_y = BigEggY - PlayerY

	_x = (_x / Dist) * BIGEGG_MOVE_DIST
	_y = (_y / Dist) * BIGEGG_MOVE_DIST

	_x = BigEggX + _x
	_y = BigEggY + _y


	cRunToUntilBlock( NPCHandle, _x, _y, BIGEGG_MOVE_SPEED_RATE )

end




function DeleteSubObject( Var )
cExecCheck( "DeleteSubObject" )

	if Var == nil
	then
		return
	end

	if Var["BigEggList"] ~= nil
	then

		for i = 1, #BIGEGG_REGEN_DATA
		do
			if Var["BigEggList"][i] ~= nil
			then
				cAIScriptSet( Var["BigEggList"][i] )
				cNPCVanish( Var["BigEggList"][i] )
				gBigEgg[ Var["BigEggList"][i] ] = nil
				Var["BigEggList"][i] = nil
			end
		end

		Var["BigEggList"] = nil
	end
end



-- 호세밍 처리 추가

function HoshemingRoutine( Handle, MapIndex )
cExecCheck( "HoshemingRoutine" )

	local CurSec = cCurrentSecond()

	if gHoMobChatTick <= CurSec
	then

		cScriptMsg( MapIndex, Handle, "Egg2014_MC03" )

		gHoMobChatTick = CurSec + 20

	end

	return ReturnAI["END"]

end
