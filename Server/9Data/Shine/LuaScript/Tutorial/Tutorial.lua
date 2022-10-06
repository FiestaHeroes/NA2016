require( "common" )
require( "Tutorial/TutorialData" )

function Main( Field )
cExecCheck( "Main" )

	local EventMemory = InstanceField[Field]

	if EventMemory == nil
	then
		InstanceField[Field] = { }

		EventMemory					= InstanceField[Field]
		EventMemory["MapIndex"]		= Field

		EventMemory["FirstTimeCheck"] 	= false
		EventMemory["CurrentTime"]		= cCurrentSecond()
		EventMemory["NetxtTime"]		= 0
		EventMemory["BattleList"]		= { }
		EventMemory["MobList"]			= { }
		EventMemory["PlayerList"]		= { }


		cSetFieldScript	( EventMemory["MapIndex"], SCRIPT_MAIN )

		cFieldScriptFunc( EventMemory["MapIndex"], "MapLogin", 	"PlayerMapLogin" )
		cFieldScriptFunc( EventMemory["MapIndex"], "MapLogout", "PlayerLogout" )
		cFieldScriptFunc( EventMemory["MapIndex"], "Tutorial", 	"TutorialProgress" )

		for index, value in pairs(NPC_DATA) do
			cNPCRegen( Field, value )
		end
	end

	EventMemory["CurrentTime"] = cCurrentSecond()

	MainRoutine( EventMemory )

end


function MainRoutine( EventMemory )
cExecCheck( "MainRoutine" )

	if EventMemory == nil
	then
		return
	end

	local BattleList


	BattleList = EventMemory["BattleList"]
	if BattleList == nil
	then
		return
	end

--[[
	���� ����Ʈ�� ����ִ� �÷��̾��� ��ƾ
	�� �ʿ� ���� �� �ִ� �ִ� �ο��� 100���̸�
	�� ����Ʈ ������ ���ؼ��� �ܰ谡 9, 15�ܰ迡 �ִ� �÷��̾��̹Ƿ�
	Ư���� �������� ���� ������ �����Ͽ� �۾���
--]]
	for PlayerHandle, value in pairs(BattleList) do

		local retval


		retval = BattlePlayerRoutine( PlayerHandle, EventMemory )
		if retval == true
		then
			DeleteBattleList( PlayerHandle, EventMemory )
			value["PI_Step"] = value["PI_Step"] + 1
			cSaveTutorialInfo( PlayerHandle, 0, value["PI_Step"] )
		end

	end

end


function TutorialProgress( Field, PlayerHandle, nType, nStep )
cExecCheck( "TutorialProgress" )

	local EventMemory 	= InstanceField[Field]


	if EventMemory == nil
	then

		return
	end


	local TutorialData
	local PlayerInfo


	TutorialData 	= TUTORIAL_STEP_DATA[nStep]
	if TutorialData == nil
	then
		return
	end

	PlayerInfo = EventMemory["PlayerList"][PlayerHandle]
	if PlayerInfo == nil
	then
		return
	end

	if PlayerInfo["PI_Step"] ~= nStep
	then

		return
	end

	-- Ŭ���̾�Ʈ���� ���ܿϷ�
	if nType == 0
	then
		if TutorialData["TSD_IS_LEVELUP"] == true
		then
			local nPlayerLevel = cGetLevel( PlayerHandle )
			if nPlayerLevel ~= nil
			then
				if nPlayerLevel < TUTORIAL_LEVEL_LIMIT
				then
					cLevelUp		( PlayerHandle )
				end
			end
		end

		-- �������� �ʱ�ȭ
		if nStep == FREESTAT_INIT_STEP_NO
		then
			local nPlayerLevel = cGetLevel( PlayerHandle )
			if nPlayerLevel ~= nil
			then
				if nPlayerLevel < TUTORIAL_LEVEL_LIMIT
				then
					cfreestatinit	( PlayerHandle )
				end
			end
		end


		-- Ŭ���̾�Ʈ���� ���� ���� ������ �� ���
		if nStep == #TUTORIAL_STEP_DATA
		then
			PlayerInfo["PI_Step"] = nStep
			cSaveTutorialInfo( PlayerHandle, 1, nStep )
			cLinkTo( PlayerHandle, LINK_DATA["MAP_INDEX"], LINK_DATA["REGEN_X"], LINK_DATA["REGEN_Y"] )
			return
		end

		-- �̴��Ͽ콺 ����� �����̻� Ǯ����
		if nStep == MINI_HOUSE_STEP_NO
		then
			cResetAbstate( PlayerHandle, STA_STUN )
		end

		nStep 					= nStep + 1
		PlayerInfo["PI_Step"] 	= nStep

		cSaveTutorialInfo( PlayerHandle, 0, nStep )

		return

	elseif nType == 1
	then
		-- ����Ʈ ����
		if TutorialData["TSD_STEP_DATA"] ~= nil
		then
			AddBattleList( PlayerHandle, nStep, PlayerInfo, EventMemory )
		end

		-- �̴��Ͽ콺�ܰ� ���ؼ� �̵� �Ұ� �����̻� �ɾ���
		if nStep == MINI_HOUSE_STEP_NO
		then
			cSetAbstate( PlayerHandle, STA_STUN, 1, 2000000000 )
		end

		cProgressTutorial( PlayerHandle, nStep )

	end

end


function AddList( PlayerHandle, nStep, EventMemory )
cExecCheck( "AddList" )

	if EventMemory == nil
	then
		return
	end

	if EventMemory["PlayerList"] == nil
	then
		EventMemory["PlayerList"] = { }
	end

	local PlayerInfo = { }


	PlayerInfo["PI_Step"]			= nStep
	PlayerInfo["PI_GateHandle"]		= nil

	EventMemory["PlayerList"][PlayerHandle] = PlayerInfo

	AddBattleList( PlayerHandle, nStep, PlayerInfo, EventMemory )

end


function AddBattleList( PlayerHandle, nStep, PlayerInfo, EventMemory )
cExecCheck( "AddBattleList" )

	if EventMemory == nil
	then
		return
	end


	if PlayerInfo == nil
	then
		return
	end

	if EventMemory["BattleList"] == nil
	then
		EventMemory["BattleList"] = {}
	end


	local TutorialData


	TutorialData = TUTORIAL_STEP_DATA[nStep]
	if TutorialData == nil
	then
		return
	end

	if TutorialData["TSD_STEP_DATA"] == nil
	then
		return
	end


	local MobList		= { }


	PlayerInfo["PI_ProgressStep"] 	= 1
	PlayerInfo["PI_NextTime"]		= cCurrentSecond() + TutorialData["TSD_START_DELAY"]
	PlayerInfo["PI_MobList"]		= MobList
	PlayerInfo["PI_MobCount"]		= 1

	EventMemory["BattleList"][PlayerHandle]	= PlayerInfo

end


function DeleteList( PlayerHandle, EventMemory )
cExecCheck( "DeleteList" )

	if EventMemory == nil
	then
		return
	end

	if EventMemory["PlayerList"] == nil
	then
		return
	end


	local PlayerInfo


	PlayerInfo = EventMemory["PlayerList"][PlayerHandle]
	if PlayerInfo == nil
	then
		return
	end

	EventMemory["PlayerList"][PlayerHandle] = nil


	DeleteBattleList( PlayerHandle, EventMemory )

end


function DeleteBattleList( PlayerHandle, EventMemory )
cExecCheck( "DeleteBattleList" )

	if EventMemory == nil
	then
		return
	end

	if EventMemory["BattleList"] == nil
	then
		return
	end


	local PlayerInfo
	local MobList


	PlayerInfo = EventMemory["BattleList"][PlayerHandle]
	if PlayerInfo == nil
	then
		return
	end

	PlayerInfo["PI_MobList"]			 	= nil
	EventMemory["BattleList"][PlayerHandle] = nil

end


function BattlePlayerRoutine( PlayerHandle, EventMemory )
cExecCheck( "BattlePlayerRoutine" )

	if EventMemory == nil
	then
		return false
	end

	local BattleList
	local PlayerInfo


	BattleList = EventMemory["BattleList"]
	if BattleList == nil
	then
		return false
	end

	PlayerInfo = BattleList[PlayerHandle]
	if PlayerInfo == nil
	then
		return false
	end

	if PlayerInfo["PI_NextTime"] > EventMemory["CurrentTime"]
	then
		return false
	end

	PlayerInfo["PI_NextTime"] = EventMemory["CurrentTime"] + 1

	if PlayerInfo["PI_ProgressStep"] == 1
	then

		local TutorialData
		local StepData
		local GateInfo


		TutorialData = TUTORIAL_STEP_DATA[PlayerInfo["PI_Step"]]
		if TutorialData == nil
		then
			return false
		end

		StepData = TutorialData["TSD_STEP_DATA"]
		if StepData == nil
		then
			return false
		end

		GateInfo = StepData["GATE_INFO"]
		if GateInfo == nil
		then
			return false
		end

		-- ����Ʈ ����
		PlayerInfo["PI_GateHandle"] = cMobRegen_XY_Layer( EventMemory["MapIndex"], GateInfo["GATE_INDEX"], GateInfo["REGEN_POSITION"]["X"], GateInfo["REGEN_POSITION"]["Y"],
																				   GateInfo["REGEN_POSITION"]["DIR"], TUTORIAL_LAYER_DATA["LAYER_TYPE"], TUTORIAL_LAYER_DATA["LAYER_NUMBER_TYPE"], PlayerHandle )

		if PlayerInfo["PI_GateHandle"] ~= nil
		then
			cSetSightState	( PlayerInfo["PI_GateHandle"], 1 )
			cSetAIScript	( SCRIPT_MAIN, PlayerInfo["PI_GateHandle"] )
			cAIScriptFunc	( PlayerInfo["PI_GateHandle"], "Entrance", "GateRoutine" )
		end

		PlayerInfo["PI_ProgressStep"] = PlayerInfo["PI_ProgressStep"] + 1

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 2
	then
		-- ī�޶� �̵�
		local TutorialData
		local StepData
		local GateInfo
		local CameraInfo


		TutorialData = TUTORIAL_STEP_DATA[PlayerInfo["PI_Step"]]
		if TutorialData == nil
		then
			return false
		end

		StepData = TutorialData["TSD_STEP_DATA"]
		if StepData == nil
		then
			return false
		end

		GateInfo = StepData["GATE_INFO"]
		if GateInfo == nil
		then
			return false
		end

		CameraInfo = StepData["CAMERA_INFO"]
		if CameraInfo == nil
		then
			return false
		end

		cSetSightState	( PlayerHandle, 1 )
		cSetAbstate		( PlayerHandle, STA_STUN, 1, 100000 )
		cCameraMove_Obj	( PlayerHandle, GateInfo["REGEN_POSITION"]["X"], GateInfo["REGEN_POSITION"]["Y"], CameraInfo["AngleXZ"], CameraInfo["AngleY"], CameraInfo["Distance"], 1 )
		PlayerInfo["PI_ProgressStep"] = PlayerInfo["PI_ProgressStep"] + 1

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 3
	then
		-- ���� ����
		local TutorialData
		local StepData
		local MobInfo


		TutorialData = TUTORIAL_STEP_DATA[PlayerInfo["PI_Step"]]
		if TutorialData == nil
		then
			return false
		end

		StepData = TutorialData["TSD_STEP_DATA"]
		if StepData == nil
		then
			return false
		end

		MobInfo = StepData["MOB_INFO"]
		if MobInfo == nil
		then
			return false
		end


		local MobHandle


		MobHandle = cMobRegen_XY_Layer( EventMemory["MapIndex"], MobInfo["MOB_INDEX"], MobInfo["REGEN_POSITION"][PlayerInfo["PI_MobCount"]]["START_POS"]["X"],  MobInfo["REGEN_POSITION"][PlayerInfo["PI_MobCount"]]["START_POS"]["Y"],
																				    MobInfo["REGEN_POSITION"][PlayerInfo["PI_MobCount"]]["START_POS"]["DIR"], TUTORIAL_LAYER_DATA["LAYER_TYPE"], TUTORIAL_LAYER_DATA["LAYER_NUMBER_TYPE"], PlayerHandle )
		if MobHandle ~= nil
		then
			cSetAIScript	( SCRIPT_MAIN, MobHandle )
			cAIScriptFunc	( MobHandle, "Entrance", "MobRoutine" )

			cSetSightState	( MobHandle, 1 )

			if EventMemory["MobList"] == nil
			then
				EventMemory["MobList"] = {}

			end
			PlayerInfo["PI_MobList"][MobHandle] = MobHandle
			EventMemory["MobList"][MobHandle] 	= PlayerInfo

			cRunTo( MobHandle, MobInfo["REGEN_POSITION"][PlayerInfo["PI_MobCount"]]["GOAL_POS"]["X"], MobInfo["REGEN_POSITION"][PlayerInfo["PI_MobCount"]]["GOAL_POS"]["Y"] )

		end

		if PlayerInfo["PI_MobCount"] == #MobInfo["REGEN_POSITION"]
		then
			PlayerInfo["PI_ProgressStep"] 	= PlayerInfo["PI_ProgressStep"] + 1
			PlayerInfo["PI_NextTime"] 		= PlayerInfo["PI_NextTime"] + 1
			return false

		end

		PlayerInfo["PI_MobCount"] = PlayerInfo["PI_MobCount"] + 1

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 4
	then

		cCameraMove_Obj		( PlayerHandle, 0, 0, 0, 0, 0, 0 )
		cResetAbstate		( PlayerHandle, STA_STUN )
		cSetSightState		( PlayerHandle, 0 )
		cProgressTutorial	( PlayerHandle, PlayerInfo["PI_Step"] )

		PlayerInfo["PI_ProgressStep"] = PlayerInfo["PI_ProgressStep"] + 1

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 5
	then

		if PlayerInfo["PI_Step"] == FIRST_BATTLE_STEP_NO
		then

			local HP, MaxHP = cObjectHP( PlayerHandle )
			local HPRate


			HPRate = HP / MaxHP * 100

			if HPRate < 100
			then
				cSetAbstate( PlayerHandle, STA_DAMAGESHIELD, 1, 300000 )
			end

			if cGetBaseClass( PlayerHandle ) == BasicClass.Mage
			then
				cSetAbstate( PlayerHandle, STA_MAGEATKUP, 1, 300000 )
			end

		elseif PlayerInfo["PI_Step"] == LAST_BATTLE_STEP_NO
		then

			cSetAbstate( PlayerHandle, STA_DAMAGESHIELD, 1, 600000 )

			if cGetBaseClass( PlayerHandle ) == BasicClass.Mage
			then
				cSetAbstate( PlayerHandle, STA_MAGEATKUP, 1, 600000 )
			end

		end

		if PlayerInfo["PI_MobCount"] == 0
		then
			cResetAbstate( PlayerHandle, STA_DAMAGESHIELD )

			if cGetBaseClass( PlayerHandle ) == BasicClass.Mage
			then
				cResetAbstate( PlayerHandle, STA_MAGEATKUP )
			end

			PlayerInfo["PI_ProgressStep"] = PlayerInfo["PI_ProgressStep"] + 1
		end

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 6
	then
		-- ī�޶� �̵�
		local TutorialData
		local StepData
		local GateInfo
		local CameraInfo


		TutorialData = TUTORIAL_STEP_DATA[PlayerInfo["PI_Step"]]
		if TutorialData == nil
		then
			return false
		end

		StepData = TutorialData["TSD_STEP_DATA"]
		if StepData == nil
		then
			return false
		end

		GateInfo = StepData["GATE_INFO"]
		if GateInfo == nil
		then
			return false
		end

		CameraInfo = StepData["CAMERA_INFO"]
		if CameraInfo == nil
		then
			return false
		end

		cSetSightState		( PlayerHandle, 1 )
		cSetAbstate			( PlayerHandle, STA_STUN, 1, 100000 )
		cCameraMove_Obj		( PlayerHandle, GateInfo["REGEN_POSITION"]["X"], GateInfo["REGEN_POSITION"]["Y"], CameraInfo["AngleXZ"], CameraInfo["AngleY"], CameraInfo["Distance"], 1 )

		PlayerInfo["PI_ProgressStep"] = PlayerInfo["PI_ProgressStep"] + 1

		return false


	elseif PlayerInfo["PI_ProgressStep"] == 7
	then

		cKillObject( PlayerInfo["PI_GateHandle"] )

		PlayerInfo["PI_ProgressStep"] 	= PlayerInfo["PI_ProgressStep"] + 1
		PlayerInfo["PI_NextTime"] 		= PlayerInfo["PI_NextTime"] + 1

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 8
	then

		cNPCVanish			( PlayerInfo["PI_GateHandle"] )

		PlayerInfo["PI_ProgressStep"] 	= PlayerInfo["PI_ProgressStep"] + 1
		PlayerInfo["PI_NextTime"] 		= PlayerInfo["PI_NextTime"] + 1

		return false

	elseif PlayerInfo["PI_ProgressStep"] == 9
	then

		-- ī�޶� �̵�
		cCameraMove_Obj		( PlayerHandle, 0, 0, 0, 0, 0, 0 )
		cResetAbstate		( PlayerHandle, STA_STUN )
		cResetAbstate		( PlayerHandle, STA_DAMAGESHIELD )
		cSetSightState		( PlayerHandle, 0 )

	end

	return true

end


function PlayerMapLogin( Field, PlayerHandle )
cExecCheck( "PlayerMapLogin" )

	local EventMemory = InstanceField[Field]
	if EventMemory == nil
	then
		return
	end

	local nStep
	local TutorialData


	nStep = cGetTutorialInfo( PlayerHandle )

	AddList( PlayerHandle, nStep, EventMemory )

	cProgressTutorial	( PlayerHandle, nStep )
	cMoveLayer			( PlayerHandle, 1, 1 )

	-- �̴��Ͽ콺�ܰ� ���ؼ� �̵� �Ұ� �����̻� �ɾ���
	if nStep == MINI_HOUSE_STEP_NO
	then
		cSetAbstate( PlayerHandle, STA_STUN, 1, 2000000000 )
	end

end


function PlayerLogout( Field, PlayerHandle )
cExecCheck( "PlayerLogout" )

	local EventMemory = InstanceField[Field]


	if EventMemory == nil
	then
		return
	end

	DeleteList( PlayerHandle, EventMemory )

end


function MobRoutine( Handle, MapIndex )
cExecCheck( "MobRoutine" )

	local EventMemory 	= InstanceField[MapIndex]


	if EventMemory == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	local MobList
	local PlayerInfo
	local PlayerMobList


	MobList = EventMemory["MobList"]
	if MobList == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	PlayerInfo = MobList[Handle]
	if PlayerInfo == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	PlayerMobList = PlayerInfo["PI_MobList"]
	if PlayerMobList == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MobList[Handle]			= nil

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle )
	then
		cAIScriptSet( Handle )
		PlayerMobList[Handle] 		= nil
		MobList[Handle]				= nil
		PlayerInfo["PI_MobCount"] 	= PlayerInfo["PI_MobCount"] - 1

		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]
end


function GateRoutine( Handle, MapIndex )
cExecCheck( "GateRoutine" )

	local EventMemory 	= InstanceField[MapIndex]


	if EventMemory == nil
	then
		cAIScriptSet( Handle )
		PlayerMobList[Handle] 		= nil

		return ReturnAI["END"]
	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--[[					Ʃ�丮�� ��������									]]--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

TUTORIAL_STEP_DATA 		= { }


TUTORIAL_STEP_DATA[0] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 	0 : ��Ʈ��
TUTORIAL_STEP_DATA[1] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 	1 : Ƽ������ �̵�
TUTORIAL_STEP_DATA[2] 	= { TSD_IS_LEVELUP = true, 		TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				--	2 : ������ο��� �̵�
TUTORIAL_STEP_DATA[3] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				--	3 : ��������
TUTORIAL_STEP_DATA[4] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 	4 : ���� / �� ����
TUTORIAL_STEP_DATA[5] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				--	5 : ���� / �� ����
TUTORIAL_STEP_DATA[6]	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				--	6 : �̴ϸ�
TUTORIAL_STEP_DATA[7] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				--	7 : ������ο��� �̵�
TUTORIAL_STEP_DATA[8] 	= { TSD_IS_LEVELUP = true, 		TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 	8 : ȸ������ ����
TUTORIAL_STEP_DATA[9] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				--	9 : ����Ʈ ���
TUTORIAL_STEP_DATA[10] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = TSD_STEP_DATA_1ST, 	TSD_START_DELAY = 0, }				-- 10 : ����
TUTORIAL_STEP_DATA[11] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 11 : �̴��Ͽ콺
TUTORIAL_STEP_DATA[12] 	= { TSD_IS_LEVELUP = true, 		TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 12 : ����Ʈ �Ϸ�
TUTORIAL_STEP_DATA[13] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 13 : ��ų���ο��� �̵�
TUTORIAL_STEP_DATA[14] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 14 : ��ų ����
TUTORIAL_STEP_DATA[15] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 15 : ��ų ����
TUTORIAL_STEP_DATA[16] 	= { TSD_IS_LEVELUP = true, 		TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 16 : ��ų ������ ���
TUTORIAL_STEP_DATA[17] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 17 : ��ų ������ ���
TUTORIAL_STEP_DATA[18] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = TSD_STEP_DATA_2ND,	TSD_START_DELAY = 0, }				-- 18 : ����
TUTORIAL_STEP_DATA[19] 	= { TSD_IS_LEVELUP = true, 		TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 19 : ������ ���� ����
TUTORIAL_STEP_DATA[20] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 20 : ������
TUTORIAL_STEP_DATA[21] 	= { TSD_IS_LEVELUP = false, 	TSD_STEP_DATA = nil, 				TSD_START_DELAY = 0, }				-- 21 : ��������
