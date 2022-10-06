require( "common" )




EVENT_DATA =
{ ----------------------

--[[  1~ 40 ]]
{
--[[�ּҷ���]]	MinLev		= 1,
--[[�ִ뷹��]]	MaxLev		= 40,
--[[ ��ȯ�� ]]	MobIndex	= "E_CaCaoSlime",
--[[���ݸ��]]	AniIndex	= "Slime_Attack1_1",
--[[  ���  ]]	MapIndex	= "RouCos02",
--[[������ê]]	SucChat		= "My favorite fruit! Raise some more and eat it later.",
--[[���и�ê]]	FailChat	= "Well. That was nothing worth keeping.",
},

--[[ 41~ 80 ]]
{
--[[�ּҷ���]]	MinLev		= 41,
--[[�ִ뷹��]]	MaxLev		= 80,
--[[ ��ȯ�� ]]	MobIndex	= "E_CaCaoPrisoner",
--[[���ݸ��]]	AniIndex	= "Prisoner_Attack1_1",
--[[  ���  ]]	MapIndex	= "EldCem01",
--[[������ê]]	SucChat		= "What is this? Would it grow a Cacao fruit?",
--[[���и�ê]]	FailChat	= "Hmm.. Well that was a failed attempt.",
},

--[[ 81~115 ]]
{
--[[�ּҷ���]]	MinLev		= 81,
--[[�ִ뷹��]]	MaxLev		= 125,
--[[ ��ȯ�� ]]	MobIndex	= "E_CaCaoMineMole",
--[[���ݸ��]]	AniIndex	= "Mole_attack",
--[[  ���  ]]	MapIndex	= "UrgFire01",
--[[������ê]]	SucChat		= "Wow, that's great. I was hungry. Raise it well.",
--[[���и�ê]]	FailChat	= "Yuck! What flavor is this suppose to be?",
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

		-- ���� ������ ��ȣ�� ���� ��ȣ�� �ٸ��� �ʱ�ȭ
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


		-- ������ üũ
		-- ���н� �޽��� ��� �˱� ���� �������ڵ���� ����

		Var["Master"] = cGetMaster( Var["Handle"] )

		if Var["Master"] == nil then

			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )
			MemBlock[Handle] = nil
			return ReturnAI["END"]

		end


		-- �� üũ

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


		-- ������ ���� üũ

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


		-- ��ȯ�� īī�������� ��ǥ
		--  ���� Ư�� �Ÿ��� ���� ������ ��ǥ�� ���ϰ�
		-- �� ��ǥ�� �̺�Ʈ���� ��ȯ�ϰ�
		-- īī���������� �̺�Ʈ�� �̵�

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



		-- �ʿ��� ���� �ʱ�ȭ

		Var["ChkTime"]			= cCurrentSecond()
		Var["EventStep"]		= 1
		Var["EventMobRegenX"]	= locX
		Var["EventMobRegenY"]	= locY

	end



	-- �̺�Ʈ�� üũ

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


	-- �Ÿ� üũ�ϸ� ���
	if Var["EventStep"] == 1 then

		if Var["ChkTime"] <= CurSec then

			Var["ChkTime"] = CurSec + 1

			if cDistanceSquar( Var["Handle"], Var["EventMob"] ) <= EVENT_MOB_STOP_CHK_DIST then

				cAnimate( Var["EventMob"], "start", EVENT_DATA[Var["GroupNum"]]["AniIndex"] )

				Var["ChkTime"]		= CurSec + 2
				Var["EventStep"]	= Var["EventStep"] + 1

			end

		end

	-- ���� ���� üũ
	elseif Var["EventStep"] == 2 then

		if Var["ChkTime"] <= CurSec then

			local rndNum = cRandomInt( 1, 100 )

			if rndNum >= EVENT_SUC_PERCENT then

				-- ����
				cNPCChatTest( Var["EventMob"], EVENT_DATA[Var["GroupNum"]]["SucChat"] )
				cDropItem( EVENT_SUC_DROP_ITEM, Var["Handle"], Var["Master"], 1000000 )

			else

				-- ����
				cNPCChatTest( Var["EventMob"], EVENT_DATA[Var["GroupNum"]]["FailChat"] )

			end

			cAnimate( Var["EventMob"], "stop" )

			Var["ChkTime"]		= CurSec + 2
			Var["EventStep"]	= Var["EventStep"] + 1

		end

	-- �� ����ġ, ����
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



-- �̺�Ʈ�� ó�� �Լ�
-- �ƹ� ó�� ���ϰ� DeadTime�� �����Ǹ� DeadTime ���Ŀ� ����
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
