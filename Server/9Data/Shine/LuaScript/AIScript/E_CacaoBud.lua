require( "common" )




EVENT_DATA =
{ ----------------------

--[[  1~ 40 ]]
{
--[[최소레벨]]	MinLev		= 1,
--[[최대레벨]]	MaxLev		= 40,
--[[ 소환몹 ]]	MobIndex	= "E_CaCaoSlime",
--[[공격모션]]	AniIndex	= "Slime_Attack1_1",
--[[  장소  ]]	MapIndex	= "RouCos02",
--[[성공몹챗]]	SucChat		= "My favorite fruit! Raise some more and eat it later.",
--[[실패몹챗]]	FailChat	= "Well. That was nothing worth keeping.",
},

--[[ 41~ 80 ]]
{
--[[최소레벨]]	MinLev		= 41,
--[[최대레벨]]	MaxLev		= 80,
--[[ 소환몹 ]]	MobIndex	= "E_CaCaoPrisoner",
--[[공격모션]]	AniIndex	= "Prisoner_Attack1_1",
--[[  장소  ]]	MapIndex	= "EldCem01",
--[[성공몹챗]]	SucChat		= "What is this? Would it grow a Cacao fruit?",
--[[실패몹챗]]	FailChat	= "Hmm.. Well that was a failed attempt.",
},

--[[ 81~115 ]]
{
--[[최소레벨]]	MinLev		= 81,
--[[최대레벨]]	MaxLev		= 125,
--[[ 소환몹 ]]	MobIndex	= "E_CaCaoMineMole",
--[[공격모션]]	AniIndex	= "Mole_attack",
--[[  장소  ]]	MapIndex	= "UrgFire01",
--[[성공몹챗]]	SucChat		= "Wow, that's great. I was hungry. Raise it well.",
--[[실패몹챗]]	FailChat	= "Yuck! What flavor is this suppose to be?",
},

} ----------------------

EVENT_FAIL_MAP			= "ValenCaCao_UseFail_Map"
EVENT_FAIL_ITEM			= "ValenCaCao_UseFail_Item"
EVENT_MOB_REGEN_DIST	= 600
EVENT_MOB_STOP_INTERVAL	= 40
EVENT_MOB_STOP_CHK_DIST	= ((EVENT_MOB_STOP_INTERVAL + 10) * (EVENT_MOB_STOP_INTERVAL + 10))
EVENT_SUC_PERCENT		= 50
EVENT_SUC_DROP_ITEM		= "E_CacaoBean"
EVENT_MOB_DEF_DEAD_TIME	= 50
EVENT_MOB_END_DEAD_TIME	= 5



MemBlock = {}

function E_CacaoBud( Handle, MapIndex )
cExecCheck( "E_CacaoBud" )

	if cIsObjectDead( Handle ) == 1 then

		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]

	end

	local Var = MemBlock[Handle]


	if Var ~= nil then

		-- 기존 마스터 번호랑 지금 번호랑 다르면 초기화
		local CurMaster = cGetMaster( Handle )

		if CurMaster == nil then

			cAIScriptSet( Handle )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil

			return ReturnAI["END"]

		end

		if Var["Master"] ~= CurMaster then

			MemBlock[Handle] = nil

			return ReturnAI["END"]

		end

		if cPlayerExist( Var["Master"] ) == nil then

			cAIScriptSet( Handle )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil

			return ReturnAI["END"]

		end

	end

	if Var == nil then

		MemBlock[Handle]	= {}

		Var					= MemBlock[Handle]

		Var["MapIndex"] 	= MapIndex
		Var["Handle"]		= Handle


		-- 마스터 체크
		-- 실패시 메시지 대상 알기 위해 마스터핸들부터 구함

		Var["Master"] = cGetMaster( Var["Handle"] )

		if Var["Master"] == nil then

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end


		-- 맵 체크

		for i = 1, #EVENT_DATA do

			if Var["MapIndex"] == EVENT_DATA[i]["MapIndex"] then

				Var["GroupNum"] = i

				break

			end

		end

		if Var["GroupNum"] == nil then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_MAP )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end


		-- 마스터 레벨 체크

		local MasterLv = cGetLevel( Var["Master"] )

		if MasterLv == nil then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_ITEM )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end


		if	MasterLv < EVENT_DATA[Var["GroupNum"]]["MinLev"] or
			MasterLv > EVENT_DATA[Var["GroupNum"]]["MaxLev"] then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_MAP )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end


		-- 소환된 카카오씨앗의 좌표
		--  부터 특정 거리의 랜덤 방향의 좌표를 구하고
		-- 그 좌표에 이벤트몹을 소환하고
		-- 카카오씨앗으로 이벤트몹 이동

		local dir			= cRandomInt( 1, 90 ) * 4
		local locX, locY	= cGetAroundCoord( Var["Handle"], dir, EVENT_MOB_REGEN_DIST )

		if locX == nil or locY == nil then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_ITEM )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end

		Var["EventMob"] = cMobRegen_XY( Var["MapIndex"], EVENT_DATA[Var["GroupNum"]]["MobIndex"], locX, locY, dir )

		if Var["EventMob"] == nil then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_ITEM )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end

		if cAIScriptSet( Var["EventMob"], Var["Handle"] ) == nil then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_ITEM )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			cNPCVanish( Var["EventMob"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end

		if cAIScriptFunc( Var["EventMob"], "Entrance", "EventMobMain" ) == nil then

			cScriptMessage_Obj( Var["Master"], EVENT_FAIL_ITEM )

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			cNPCVanish( Var["EventMob"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end

		MemBlock[Var["EventMob"]]				= {}
		MemBlock[Var["EventMob"]]["DeadTime"]	= cCurrentSecond() + EVENT_MOB_DEF_DEAD_TIME

		cFollow( Var["EventMob"], Var["Handle"], EVENT_MOB_STOP_INTERVAL, 10000 )



		-- 필요한 변수 초기화

		Var["ChkTime"]			= cCurrentSecond()
		Var["EventStep"]		= 1
		Var["EventMobRegenX"]	= locX
		Var["EventMobRegenY"]	= locY

	end



	-- 이벤트몹 체크

	if Var["EventMob"] == nil then

		cAIScriptSet( Var["Handle"] )
		cNPCVanish( Var["Handle"] )
		MemBlock[Handle] = nil
		return ReturnAI["END"]

	end

	if cIsObjectDead( Var["EventMob"] ) == 1 then

		cAIScriptSet( Var["Handle"] )
		cNPCVanish( Var["Handle"] )
		MemBlock[Handle] = nil
		return ReturnAI["END"]

	end



	local CurSec = cCurrentSecond()


	-- 거리 체크하며 대기
	if Var["EventStep"] == 1 then

		if Var["ChkTime"] <= CurSec then

			Var["ChkTime"] = CurSec + 1

			if cDistanceSquar( Var["Handle"], Var["EventMob"] ) <= EVENT_MOB_STOP_CHK_DIST then

				cAnimate( Var["EventMob"], "start", EVENT_DATA[Var["GroupNum"]]["AniIndex"] )

				Var["ChkTime"]		= CurSec + 2
				Var["EventStep"]	= Var["EventStep"] + 1

			end

		end

	-- 성공 실패 체크
	elseif Var["EventStep"] == 2 then

		if Var["ChkTime"] <= CurSec then

			local rndNum = cRandomInt( 1, 100 )

			if rndNum >= EVENT_SUC_PERCENT then

				-- 성공
				cNPCChatTest( Var["EventMob"], EVENT_DATA[Var["GroupNum"]]["SucChat"] )
				cDropItem( EVENT_SUC_DROP_ITEM, Var["Handle"], Var["Master"], 1000000 )

			else

				-- 실패
				cNPCChatTest( Var["EventMob"], EVENT_DATA[Var["GroupNum"]]["FailChat"] )

			end

			cAnimate( Var["EventMob"], "stop" )

			Var["ChkTime"]		= CurSec + 2
			Var["EventStep"]	= Var["EventStep"] + 1

		end

	-- 몹 원위치, 종료
	elseif Var["EventStep"] == 3 then

		if Var["ChkTime"] <= CurSec then

			cRunTo( Var["EventMob"], Var["EventMobRegenX"], Var["EventMobRegenY"] )

			MemBlock[Var["EventMob"]]["DeadTime"] = CurSec + EVENT_MOB_END_DEAD_TIME

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil

		end

	end


	return ReturnAI["END"]

end



-- 이벤트몹 처리 함수
-- 아무 처리 안하고 DeadTime이 설정되면 DeadTime 이후에 제거
function EventMobMain( Handle, MapIndex )
cExecCheck( "EventMobMain" )

	if cIsObjectDead( Handle ) == 1 then

		cAIScriptSet( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]

	end


	local Var = MemBlock[Handle]

	if Var == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MemBlock[Handle] = nil

		return ReturnAI["END"]

	end


	if Var["DeadTime"] ~= nil then

		if Var["DeadTime"] <= cCurrentSecond() then

			cAIScriptSet( Handle )
			cNPCVanish( Handle )
			MemBlock[Handle] = nil

			return ReturnAI["END"]

		end

	end


	return ReturnAI["END"]

end
