require( "common" )


----------------------------------------------------------------------------------------------------
-- �ҷ��� �̺�Ʈ ������
----------------------------------------------------------------------------------------------------

-- �ҷ��� �̺�Ʈ �� ���� ����
EVENT_MAP_DATA =
{
	-- �̵��� �̺�Ʈ �� ����
	EMD_INDEX			= "E_Hwin",
	EMD_REGEN_X			= 914,
	EMD_REGEN_Y			= 238,

	-- �̺�Ʈ �� ���� ����
	EMD_ENTRY_CONDITION =
	{
		"StaE_Slime",
		"StaE_Honeying",
		"StaE_Phino",
		"StaE_LizardMan",
		"StaE_KingCrab",
		"StaE_SparkDog",
		"StaE_LavaVivi",
		"StaE_PhinoFlie",
		"StaE_MushRoom",
		"StaE_Spider",
		"StaE_B_CrackerHumar",
		"StaE_Helga",
		"StaE_JackO",
	    "StaE_Kebing",
        "StaE_ForasChief",
		"StaE_Zombie",
		"StaE_MaraCrew",
		"StaE_MaraElite",
		"StaE_MaraSailor",
		"StaE_Psyken",
		"StaE_PsykenDog",
		"StaE_Megan",
		"StaE_Yeti",
		"StaE_Imp",
		"StaE_Robo",
		"StaE_Hob",
		"StaE_Pinky",
		"StaE_WarH_Devildom",
		"StaE_ArkNovice",
		"StaE_ArkTech",
		"StaE_Mandragora",
		"StaE_S_Hayreddin",
		"StaE_Mara",
	}
}

-- �̺�Ʈ ����Ʈ ���� �޽���
EVENT_ERROR_NOTICE =
{
	EEN_FILENAME 	= "Event",
	EEN_INDEX		= "SystemMsg_01",
}

-- �� �̵� �����޴� ����
SERVER_MENU_DATA =
{
	-- Ÿ��Ʋ
	SMD_TITLE 	= { TITLE_SCRIPT_FILENAME = "MenuString", TITLE_INDEX = "LinkTitle", TITLE_STRING = nil },

	-- ��ư
	SMD_BT_YES	= { BT_SCRIPT_FILENAME = "ETC", BT_INDEX = "Yes", BT_STRING = nil, BT_FUNC = "Click_Yes" },
	SMD_BT_NO	= { BT_SCRIPT_FILENAME = "ETC", BT_INDEX = "No",  BT_STRING = nil, BT_FUNC = "Click_No" }
}

-- �ιֿ� ���� ����
ROAMING_MOB_DATA =
{
	RMD_CHECK_INTERVAL = 0.1,

	{ RMD_INDEX = "E_HwinPhino", RMD_X = 13881, RMD_Y = 13411, RMG_REGEN_INTERVAL = 10 },		-- 1
	{ RMD_INDEX = "E_HwinFlie",  RMD_X = 13815, RMD_Y = 13411, RMG_REGEN_INTERVAL = 10 },		-- 2
}

-- �ι� ����
ROAMING_PATTERN_DATA =
{
	RPD_CHECK_INTERVAL	= 0.1,	-- �������� Ȯ�� �ð� ����
	RPD_GOAL_INTERVAL	= 10,	-- ������������ üũ �Ÿ�

	-- �̵� ��ǥ
	{ { X = 13881, Y = 13411 }, { X = 14915, Y = 13396 }, { X = 13881, Y = 13411 }, },										-- 1
	{ { X = 13815, Y = 13411 }, { X = 14721, Y = 13404 }, { X = 13815, Y = 13411 }, },										-- 2
}

-- ���� ä�� ����
MOB_CHAT_DATA =
{
	E_HwinPhino =
	{
		MCD_CHAT_INTERVAL 	= 10,
		MCD_SCRIPT_FILE		= "Event",

		"E_HwinPhino_Chat01",
		"E_HwinPhino_Chat02",
	},

	E_HwinFlie =
	{
		MCD_CHAT_INTERVAL 	= 10,
		MCD_SCRIPT_FILE		= "Event",

		"E_HwinFlie_Chat01",
		"E_HwinFlie_Chat02",
	},
}



----------------------------------------------------------------------------------------------------
-- �ҷ��� �̺�Ʈ ���� ����
----------------------------------------------------------------------------------------------------

-- �̺�Ʈ ����Ʈ �� ����
EventGateBuf = {}
--[[
EventGateBuf[ Handle ]["RoamingMobChackTime"]				= �ι� ���� Ȯ�� �ð�
EventGateBuf[ Handle ]["RoamingMobList"]					= �ι� ���� ����Ʈ
EventGateBuf[ Handle ]["RoamingMobList"][ i ]["MobHandle"] 	= �ι� ���� �ڵ�
EventGateBuf[ Handle ]["RoamingMobList"][ i ]["RegenTime"] 	= �ι� ���� ���� �ð�
--]]

-- �ι� ���� �� ����
RoamingMobBuf = {}
--[[
RoamingMobBuf[ Handle ]["ChatData"]					= ���� ä�� ����
RoamingMobBuf[ Handle ]["ChatTime"]					= ���� ä�� �ð�
RoamingMobBuf[ Handle ]["ChatStep"]					= ���� ä�� ����

RoamingMobBuf[ Handle ]["MovePattern"]				= �̵� ���� ����
RoamingMobBuf[ Handle ]["MoveBack"]					= �̵� ���� ���ư���
RoamingMobBuf[ Handle ]["MoveStep"] 				= �̵� ���� �ܰ�
RoamingMobBuf[ Handle ]["MoveCheckTime"] 			= �̵� ���� Ȯ�� �ð�
--]]

----------------------------------------------------------------------------------------------------
-- �ҷ��� �̺�Ʈ �Լ�
----------------------------------------------------------------------------------------------------

-- ����Ʈ �⺻�Լ�
function E_HwinIn( Handle, MapIndex )
cExecCheck "E_HwinIn"


	local CurSec = cCurrentSecond()


	-- ����Ʈ �ʱ�ȭ
	if EventGateBuf[ Handle ] == nil
	then
		EventGateBuf[ Handle ] = {}
		EventGateBuf[ Handle ]["RoamingMobChackTime"] 	= CurSec
		EventGateBuf[ Handle ]["RoamingMobList"]		= {}

		cAIScriptFunc( Handle, "NPCClick", "EventGateClick" )
		cSetObjectDirect( Handle, 0 )

		-- �����޴����� ����� ���ڿ� ��������
		if SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"] == nil
		then
			local MapName = cGetMapName( EVENT_MAP_DATA["EMD_INDEX"] )
			SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"] = cGetScriptString( SERVER_MENU_DATA["SMD_TITLE"]["TITLE_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_TITLE"]["TITLE_INDEX"], MapName )
			SERVER_MENU_DATA["SMD_BT_YES"]["BT_STRING"]	  = cGetScriptString( SERVER_MENU_DATA["SMD_BT_YES"]["BT_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_BT_YES"]["BT_INDEX"] )
			SERVER_MENU_DATA["SMD_BT_NO"]["BT_STRING"]	  = cGetScriptString( SERVER_MENU_DATA["SMD_BT_NO"]["BT_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_BT_NO"]["BT_INDEX"] )
		end

		-- �ι� ���� ��ȯ
		for i = 1, #ROAMING_MOB_DATA
		do
			local dataRoamingMob	= ROAMING_MOB_DATA[ i ]
			local MobHandle			= cMobRegen_XY( MapIndex, dataRoamingMob["RMD_INDEX"], dataRoamingMob["RMD_X"], dataRoamingMob["RMD_Y"], 0 )

			if MobHandle ~= nil
			then
				cAIScriptSet( MobHandle, Handle )
				cAIScriptFunc( MobHandle, "Entrance", "RoamingMobRoutine" )
				cResetAbstate( MobHandle, "StaImmortal" )

				RoamingMobBuf[ MobHandle ] = {}
				RoamingMobBuf[ MobHandle ]["ChatData"] 		= MOB_CHAT_DATA[ dataRoamingMob["RMD_INDEX"] ]
				RoamingMobBuf[ MobHandle ]["ChatTime"] 		= CurSec
				RoamingMobBuf[ MobHandle ]["ChatStep"] 		= 1

				RoamingMobBuf[ MobHandle ]["MovePattern"]	= ROAMING_PATTERN_DATA[ i ]
				RoamingMobBuf[ MobHandle ]["MoveBack"]		= false
				RoamingMobBuf[ MobHandle ]["MoveStep"] 		= 1
				RoamingMobBuf[ MobHandle ]["MoveCheckTime"] = CurSec

				EventGateBuf[ Handle ]["RoamingMobList"][ i ] = {}
				EventGateBuf[ Handle ]["RoamingMobList"][ i ]["MobHandle"] = MobHandle
				EventGateBuf[ Handle ]["RoamingMobList"][ i ]["RegenTime"] = 0

				cWalkTo( MobHandle, ROAMING_PATTERN_DATA[ i ][ 1 ]["X"], ROAMING_PATTERN_DATA[ i ][ 1 ]["Y"], 500 )
			else
				cAssertLog( "Init - RoamingMob regen fail "..i )
			end
		end
	end

	-- ����Ʈ ������ ��ũ��Ʈ ����
	if cIsObjectDead( Handle ) ~= nil
	then

		for i = 1, #EventGateBuf[ Handle ]["RoamingMobList"]
		do
			local MobHandle = EventGateBuf[ Handle ]["RoamingMobList"][ i ]["MobHandle"]

			RoamingMobBuf[ MobHandle ] = nil
			cAIScriptSet( MobHandle )
			cNPCVanish( MobHandle )
		end

		EventGateBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- �ι� ���� Ȯ��
	if EventGateBuf[ Handle ]["RoamingMobChackTime"] <= CurSec
	then
		local RoamingMobList = EventGateBuf[ Handle ]["RoamingMobList"]

		for i = 1, #RoamingMobList
		do

			if RoamingMobList[ i ]["RegenTime"] == 0			-- ���� �ð��� �����ȵ� ���
			then

				-- �ι� ���Ͱ� �׾����� ���� �ð� ����
				if cIsObjectDead( RoamingMobList[ i ]["MobHandle"] ) ~= nil
				then
					RoamingMobList[ i ]["RegenTime"] = CurSec + ROAMING_MOB_DATA[ i ]["RMG_REGEN_INTERVAL"]
				end

			elseif RoamingMobList[ i ]["RegenTime"] <= CurSec	-- ���� �ð� Ȯ��
			then
				-- �ι� ���� ��ȯ
				local dataRoamingMob	= ROAMING_MOB_DATA[ i ]
				local MobHandle			= cMobRegen_XY( MapIndex, dataRoamingMob["RMD_INDEX"], dataRoamingMob["RMD_X"], dataRoamingMob["RMD_Y"], 0 )

				if MobHandle ~= nil
				then
					cAIScriptSet( MobHandle, Handle )
					cAIScriptFunc( MobHandle, "Entrance", "RoamingMobRoutine" )
					cResetAbstate( MobHandle, "StaImmortal" )

					RoamingMobBuf[ MobHandle ] = {}
					RoamingMobBuf[ MobHandle ]["ChatData"] 		= MOB_CHAT_DATA[ dataRoamingMob["RMD_INDEX"] ]
					RoamingMobBuf[ MobHandle ]["ChatTime"] 		= CurSec
					RoamingMobBuf[ MobHandle ]["ChatStep"] 		= 1

					RoamingMobBuf[ MobHandle ]["MovePattern"]	= ROAMING_PATTERN_DATA[ i ]
					RoamingMobBuf[ MobHandle ]["MoveBack"]		= false
					RoamingMobBuf[ MobHandle ]["MoveStep"] 		= 1
					RoamingMobBuf[ MobHandle ]["MoveCheckTime"] = CurSec

					RoamingMobList[ i ]["MobHandle"] = MobHandle
					RoamingMobList[ i ]["RegenTime"] = 0
				else
					cAssertLog( "Init - RoamingMob regen fail "..i )
				end
			end
		end
	end

	return ReturnAI["END"]
end

-- ����Ʈ Ŭ��
function EventGateClick( NPCHandle, PlyHandle, PlyCharNo  )
cExecCheck "EventGateClick"

	-- ���� ���� Ȯ��
	local dataEntryCondition = EVENT_MAP_DATA[ "EMD_ENTRY_CONDITION" ]
	for i = 1, #dataEntryCondition
	do
		if cAbstateRestTime( PlyHandle, dataEntryCondition[ i ] ) ~= nil
		then
			cServerMenu( PlyHandle, NPCHandle, SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"],
											   SERVER_MENU_DATA["SMD_BT_YES"]["BT_STRING"], SERVER_MENU_DATA["SMD_BT_YES"]["BT_FUNC"],
											   SERVER_MENU_DATA["SMD_BT_NO"]["BT_STRING"],  SERVER_MENU_DATA["SMD_BT_NO"]["BT_FUNC"] )
			return
		end
	end

	-- ���� ������ �������� ������ ���
	local MapIndex = cGetCurMapIndex( NPCHandle )
	if MapIndex ~= nil
	then
		cNotice_Obj( PlyHandle, EVENT_ERROR_NOTICE["EEN_FILENAME"], EVENT_ERROR_NOTICE["EEN_INDEX"] )
	end
end

-- �� Ŭ��( �̺�Ʈ �� ���� )
function Click_Yes( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Click_Yes"

	-- ���� ���� Ȯ��
	local dataEntryCondition = EVENT_MAP_DATA[ "EMD_ENTRY_CONDITION" ]
	for i = 1, #dataEntryCondition
	do
		if cAbstateRestTime( PlyHandle, dataEntryCondition[ i ] ) ~= nil
		then
			cLinkTo( PlyHandle, EVENT_MAP_DATA["EMD_INDEX"], EVENT_MAP_DATA["EMD_REGEN_X"], EVENT_MAP_DATA["EMD_REGEN_Y"] )
			return
		end
	end

	-- ���� ������ �������� ������ ���
	local MapIndex = cGetCurMapIndex( NPCHandle )
	if MapIndex ~= nil
	then
		cNotice_Obj( PlyHandle, EVENT_ERROR_NOTICE["EEN_FILENAME"], EVENT_ERROR_NOTICE["EEN_INDEX"] )
	end
end

-- �ƴϿ� Ŭ��
function Click_No( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Click_No"
end


-- �ι� ���� �⺻ �Լ�
function RoamingMobRoutine( Handle, MapIndex )
cExecCheck "RoamingMobRoutine"

	local CurSec = cCurrentSecond()


	-- ���� ��� �ִ��� Ȯ��
	if cIsObjectDead( Handle ) ~= nil
	then
		RoamingMobBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- ���� ���� Ȯ��
	local infoMobBuf = RoamingMobBuf[ Handle ]
	if infoMobBuf == nil
	then
		RoamingMobBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- ���� ���� Ȯ��
	if infoMobBuf["ChatData"] == nil			-- �⺻ ����
	then
		cAssertLog( "Mob ChatData nil" )
		RoamingMobBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- ���� ä��
	if infoMobBuf["ChatTime"] <= CurSec
	then

		if infoMobBuf["ChatStep"] > #infoMobBuf["ChatData"]
		then
			infoMobBuf["ChatStep"] = 1
		end

		cMobChat( Handle, infoMobBuf["ChatData"]["MCD_SCRIPT_FILE"], infoMobBuf["ChatData"][ infoMobBuf["ChatStep"] ], false )

		infoMobBuf["ChatStep"] = infoMobBuf["ChatStep"] + 1
		infoMobBuf["ChatTime"] = CurSec + infoMobBuf["ChatData"]["MCD_CHAT_INTERVAL"]
	end

	-- �̵�
	if infoMobBuf["MoveCheckTime"] <= CurSec
	then
		local MoveStep 					= infoMobBuf["MoveStep"]
		local GoalInterval				= ROAMING_PATTERN_DATA["RPD_GOAL_INTERVAL"] * ROAMING_PATTERN_DATA["RPD_GOAL_INTERVAL"]
		local CurLocate_X, CurLocate_Y 	= cObjectLocate( Handle )
		local MaxMovePattern			= #infoMobBuf["MovePattern"]

		if cDistanceSquar( CurLocate_X, CurLocate_Y, infoMobBuf["MovePattern"][ MoveStep ]["X"], infoMobBuf["MovePattern"][ MoveStep ]["Y"] ) < GoalInterval
		then
			-- �̵� �ܰ� ���
			if infoMobBuf["MoveBack"] == false
			then
				MoveStep = MoveStep + 1

				if MoveStep > MaxMovePattern
				then
					MoveStep 				= MaxMovePattern - 1
					infoMobBuf["MoveBack"]	= true
				end
			else
				MoveStep = MoveStep - 1

				if MoveStep < 1
				then
					MoveStep 				= 2
					infoMobBuf["MoveBack"]	= false
				end
			end

			cWalkTo( Handle, infoMobBuf["MovePattern"][ MoveStep ]["X"], infoMobBuf["MovePattern"][ MoveStep ]["Y"], 500 )

			infoMobBuf["MoveStep"] 	= MoveStep
		else
			local AggroListSize = cAggroListSize( Handle )
			if AggroListSize <= 0
			then
				--if cGetMoveState( Handle ) == 0
				local MoveState, MoveStateTime, MoveStateSetTime = cGetMoveState( Handle )
				if MoveState == 0
				then
					cWalkTo( Handle, infoMobBuf["MovePattern"][ MoveStep ]["X"], infoMobBuf["MovePattern"][ MoveStep ]["Y"], 500 )
				end
			end
		end

		infoMobBuf["MoveCheckTime"] = CurSec + ROAMING_PATTERN_DATA["RPD_CHECK_INTERVAL"]
	end

	return ReturnAI["CPP"]
end
