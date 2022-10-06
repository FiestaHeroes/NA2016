--------------------------------------------------------------------------------
--                          KDFargels Main File                               --
--------------------------------------------------------------------------------


require( "common" )

require( "KQ/KDFargels/Data/Name" ) 			-- ���ϰ��, �����̸�, �������� ���� ���� ���̺�
require( "KQ/KDFargels/Data/Regen" )			-- ���� ������(�׷�, ��, NPC, ��, ������ ���� ���� ����, ��ġ �� �Ӽ� ����)
require( "KQ/KDFargels/Data/Process" )			-- ���� ������Ÿ�Ӱ� ��ũ ����, ����, ����Ʈ ���� ���� ���� ������
require( "KQ/KDFargels/Data/Boss" )			-- ���� Boss�� �ൿ ����(ä�� �� ������ ������ ��� ���� ������(����ȯ ���� ����))

require( "KQ/KDFargels/Functions/SubFunc" )	-- ��ü���� ���࿡ �ʿ��� ���� Sub Functions
require( "KQ/KDFargels/Functions/Routine" )	-- �� � �ٴ� AI ���� ��ƾ��
require( "KQ/KDFargels/Functions/Progress" )	-- �� �ܰ谡 ���ǵ� ���� �Լ���

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    �����Լ�						-- --
-- --														-- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Main( Field )
cExecCheck( "Main" )

	local EventMemory = InstanceField[Field]

	if EventMemory == nil then

		cDebugLog( "EventMemory == nil" )

		InstanceField[Field] = { }


		EventMemory	= InstanceField[Field]

		EventMemory["MapIndex"]						= Field
		EventMemory["CurrentTime"]					= 0
		EventMemory["EventNumber"]					= 1
		EventMemory["EventData"] 					= { }
		EventMemory["CheckTime"]					= 1

		EventMemory["EM_STATE"]						= EM_STATE["Start"]
		EventMemory["EventState"]					= ES_STATE["STATE_1"]

		EventMemory["CameraMove"]					= { }
		EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["NORMAL"]
		EventMemory["CameraMove"]["CheckTime"]		= 0
		EventMemory["CameraMove"]["Number"]			= 1

		EventMemory["CameraMove"]["Focus"]			= { }
		EventMemory["CameraMove"]["Focus"]["X"] 	= 0
		EventMemory["CameraMove"]["Focus"]["Y"] 	= 0
		EventMemory["CameraMove"]["Focus"]["DIR"] 	= 0

		EventMemory["FaceCut"]						= { }
		EventMemory["FaceCut"]["Number"]			= 1
		EventMemory["FaceCut"]["CheckTime"]			= 0

		EventMemory["PlayerList"]					= { }
		EventMemory["PlayerLogin"]					= false

		EventMemory["CheckLimitTime"]				= 999999999;

		DoorCreate( EventMemory )

		cSetFieldScript( Field, SCRIPT_MAIN )
		cFieldScriptFunc( EventMemory["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end

	MainRoutine( EventMemory )

end


function MainRoutine( EventMemory )
cExecCheck( "MainRoutine" )

	if EventMemory == nil then

		return

	end

	if EventMemory["PlayerLogin"] == false then

		return

	end

	if EVENT_GAME_OVER == true then

		return

	end

	-- 0.1�� ���� ����
	if EventMemory["CurrentTime"] + 0.1 > cCurrentSecond() then

		return

	else

		EventMemory["CurrentTime"] = cCurrentSecond()

		-- ���ѽð� üũ
		if EventMemory["CheckLimitTime"] ~= nil then

			if EventMemory["CheckLimitTime"] <= EventMemory["CurrentTime"] then

				cTimer( EventMemory["MapIndex"], 0 )
				cLinkToAll( EventMemory["MapIndex"], LINK_INFO["RETURNMAP1"]["MAP_INDEX"], LINK_INFO["RETURNMAP1"]["X"], LINK_INFO["RETURNMAP1"]["Y"])
				cEndOfKingdomQuest( EventMemory["MapIndex"] )

			end

		end

	end

	if EventMemory["EM_STATE"] == EM_STATE["Play"] then

		local ReturnValue = EVENT_ROUTINE[EventMemory["EventNumber"]]( EventMemory )

		if ReturnValue == EVENT_ROUTINE_END then

			EventMemory["EM_STATE"] = EM_STATE["End"]

		end

		return

	elseif EventMemory["EM_STATE"] == EM_STATE["Start"] then

		EVENT_INIT_FUCTION[EventMemory["EventNumber"]]( EventMemory )

		EventMemory["EM_STATE"] = EM_STATE["Play"]

		return

	elseif EventMemory["EM_STATE"] == EM_STATE["End"] then

		EVENT_DEINIT_FUNCTION( EventMemory )

		return

	end

end
