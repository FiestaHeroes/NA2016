--------------------------------------------------------------------------------
--                          KDFargels Main File                               --
--------------------------------------------------------------------------------


require( "common" )

require( "KQ/KDFargels/Data/Name" ) 			-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "KQ/KDFargels/Data/Regen" )			-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)
require( "KQ/KDFargels/Data/Process" )			-- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "KQ/KDFargels/Data/Boss" )			-- 던전 Boss의 행동 관련(채팅 및 보스전 페이즈 제어를 위한 데이터(몹소환 정보 포함))

require( "KQ/KDFargels/Functions/SubFunc" )	-- 전체적인 진행에 필요한 각종 Sub Functions
require( "KQ/KDFargels/Functions/Routine" )	-- 몹 등에 붙는 AI 관련 루틴들
require( "KQ/KDFargels/Functions/Progress" )	-- 각 단계가 정의된 진행 함수들

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --														-- --
-- --					    메인함수						-- --
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

	-- 0.1초 마다 실행
	if EventMemory["CurrentTime"] + 0.1 > cCurrentSecond() then

		return

	else

		EventMemory["CurrentTime"] = cCurrentSecond()

		-- 제한시간 체크
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
