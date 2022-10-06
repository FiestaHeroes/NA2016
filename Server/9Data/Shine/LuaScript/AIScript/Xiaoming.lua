require( "common" )
--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[											퍼즐게임 데이터										]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--

PG_INVALID_VALUE 		= -1
PG_SUFFLE_COUNT			= 500			-- 퍼즐 조각 섞는 횟수
PG_REWARD_RANGE			= 1200			-- 보상 상태이상 걸어줄 범위
PG_NO_CLICK_TIME		= 30			-- 게임 진행중 클릭 안하고 이 시간동안 대기시 게임 종료
PG_WATING_TIME			= 15			-- 게임 대기 시간
PG_PIECE_VANISH_TIME	= 0.2

-- 게임 모드
PG_PUZZLE_MODE =
{
	PGM_SLIME			= 1,
	PGM_HONEYING		= 2,
	PGM_ALL_PLAY		= 3,
}

-- 퍼즐 크기
-- ( 퍼즐 크기가 바뀐다면 PG_PIECE_INFO의 내용 수정이 필요함 )
PG_PUZZLE_SIZE =
{
	-- 슬라임 퍼즐
	{ PS_WIDTH = 4, PS_HEIGHT = 4 },
	-- 하닝 퍼즐
	{ PS_WIDTH = 4, PS_HEIGHT = 4 },
}



------------------------------------------------------------------------------------------
--**************************************************************************************--
--																						--
-- 캐릭터 타이틀 보상( 국가마다 캐릭터 타이틀 아이디가 다르기 때문에 주의해야 함 )		--
--																						--
--**************************************************************************************--
------------------------------------------------------------------------------------------

PG_GAME_DATA =
{
-- Slime
	{
		PGD_COST 			= 1000,		-- 게임 시작시 필요한 금액
		PGD_PLAYTIME 		= 150,
		PGD_REWARD_ABSTATE	=			-- 보상 상태이상
		{
			{ PRA_INDEX = "StaPzlReward_S", PRA_KEEPTIME = 60*60*1000 },
		},
		PGD_REWARD_CHARTITLE = { PRC_ID = 114, PRC_VALUE = 1 },
	},
-- Honeying
	{
		PGD_COST 			= 1000,
		PGD_PLAYTIME 		= 150,
		PGD_REWARD_ABSTATE	=
		{
			{ PRA_INDEX = "StaPzlReward_H", PRA_KEEPTIME = 60*60*1000 },
		},
		PGD_REWARD_CHARTITLE = { PRC_ID = 115, PRC_VALUE = 1 },
	},
-- All
	{
		PGD_COST 			= 1000,
		PGD_PLAYTIME 		= 300,
		PGD_REWARD_ABSTATE	=
		{
			{ PRA_INDEX = "StaPzlReward_SH1", PRA_KEEPTIME = 60*60*1000 },
			{ PRA_INDEX = "StaPzlReward_SH2", PRA_KEEPTIME = 60*60*1000 },
		},
		PGD_REWARD_CHARTITLE = { PRC_ID = 116, PRC_VALUE = 1 },
	},
}

PG_BASE_BOARD_DATA =
{
	{ BB_INDEX = "PzlBoard_4x4", BB_REGEN_POS = { RP_X = 11430, RP_Y = 13608, RP_DIR = 90 } },
	{ BB_INDEX = "PzlBoard_4x4", BB_REGEN_POS = { RP_X = 11430,	RP_Y = 13269, RP_DIR = 90 } },
}

PG_COMPLETION_PUZZLE_DATA =
{
	{ CP_INDEX = "PzlSlimeFull", CP_REGEN_POS = { RP_X = 11430, RP_Y = 13608, RP_DIR = 270 } },
	{ CP_INDEX = "PzlHoneyFull", CP_REGEN_POS = { RP_X = 11430, RP_Y = 13269, RP_DIR = 270 } },
}

-- 퍼즐 조각 정보
PG_PIECE_INFO =
{
	-- 4 X 4 슬라임 퍼즐
	{
		{ PI_INDEX = "PzlSlime1_1", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13533, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime1_2", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13583, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime1_3", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13633, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime1_4", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13683, PI_DIR = 270 } },

		{ PI_INDEX = "PzlSlime2_1", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13533, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime2_2", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13583, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime2_3", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13633, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime2_4", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13683, PI_DIR = 270 } },

		{ PI_INDEX = "PzlSlime3_1", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13533, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime3_2", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13583, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime3_3", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13633, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime3_4", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13683, PI_DIR = 270 } },

		{ PI_INDEX = "PzlSlime4_1", 		PI_REGEN_POS = { PI_X = 11505, PI_Y = 13533, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime4_2", 		PI_REGEN_POS = { PI_X = 11505, PI_Y = 13583, PI_DIR = 270 } },
		{ PI_INDEX = "PzlSlime4_3", 		PI_REGEN_POS = { PI_X = 11505, PI_Y = 13633, PI_DIR = 270 } },
		{ PI_INDEX = nil, 					PI_REGEN_POS = { PI_X = 11505, PI_Y = 13683, PI_DIR = 270 } },
	},

	-- 4 X 4 허닝 퍼즐
	{
		{ PI_INDEX = "PzlHoney1_1", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13194, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney1_2", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13244, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney1_3", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13294, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney1_4", 		PI_REGEN_POS = { PI_X = 11355, PI_Y = 13344, PI_DIR = 270 } },

		{ PI_INDEX = "PzlHoney2_1", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13194, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney2_2", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13244, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney2_3", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13294, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney2_4", 		PI_REGEN_POS = { PI_X = 11405, PI_Y = 13344, PI_DIR = 270 } },

		{ PI_INDEX = "PzlHoney3_1", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13194, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney3_2", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13244, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney3_3", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13294, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney3_4", 		PI_REGEN_POS = { PI_X = 11455, PI_Y = 13344, PI_DIR = 270 } },

		{ PI_INDEX = "PzlHoney4_1", 		PI_REGEN_POS = { PI_X = 11505, PI_Y = 13194, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney4_2", 		PI_REGEN_POS = { PI_X = 11505, PI_Y = 13244, PI_DIR = 270 } },
		{ PI_INDEX = "PzlHoney4_3", 		PI_REGEN_POS = { PI_X = 11505, PI_Y = 13294, PI_DIR = 270 } },
		{ PI_INDEX = nil, 					PI_REGEN_POS = { PI_X = 11505, PI_Y = 13344, PI_DIR = 270 } },
	},
}

PG_TOPVIEW_DATA =
{
	PTD_CENTER_POS 	= { PCP_X = 11430, PCP_Y = 13439 },
	PTD_RANGE		= 530,
	PTD_DEGREE 		= 270,
}

-- 상황에 맞는 다이얼로그 정보
PG_CIRCUMSTANCE_DIALOG =
{
	MONEY_LACK			= { EFFECTMSG = nil, 	FACECUT = "Xiaoming", FILENAME = "Event",  INDEX = "Xiaoming_05" },
	GAME_ALREADY_PLAY	= { EFFECTMSG = nil, 	FACECUT = nil, 		  FILENAME = "Event",  INDEX = "SystemMsg_01" },
	GAME_WATING			= { EFFECTMSG = nil, 	FACECUT = nil, 		  FILENAME = "Event",  INDEX = "SystemMsg_02" },
	GAMEOVER_NO_CLICK	= { EFFECTMSG = nil, 	FACECUT = nil, 		  FILENAME = "Event",  INDEX = "SystemMsg_03" },
}

PG_ANNOUNCE_DATA =
{
	PLAY_TIME			= "Pzl_Success_CostTime"
}

-- 게임 진행시 필요한 상태이상
PG_ABSTATE_DATA	=
{
	PAD_USER_STUN 		= { INDEX = "StaAdlFStun", 		KEEPTIME = 9999999 	},
	PAD_FOMING_EFFECT	= { INDEX = "StaPzlOccupy", 	KEEPTIME = 9999999 	},
	PAD_GAME_SELECT		= { INDEX = "StaPzlHide", 		KEEPTIME = 1000 	},
}

-- 도어 블럭 정보
PG_DOOR_BLOCK =
{
	PDB_DOOR_INDEX 		= "GuildGate00",
	PDB_BLOCK_INDEX		= "Xiaoming",
	PDB_REGEN_POSITION 	= { X = 0, Y = 0, DIR = 0}
}

PG_MOVABLE_CELL =
{
	PMC_UP 		= 1,
	PMC_DOWN 	= 2,
	PMC_LEFT 	= 3,
	PMC_RIGHT 	= 4,
}

PG_GAME_STATE =
{
	PGS_WAIT		= 1,
	PGS_COUNT		= 2,
	PGS_PROGRESS	= 3,
	PGS_COMPLETE	= 4,
	PGS_FAIL		= 5,
}

PG_PUZZLE_STATE	=
{
	PPS_WAIT		= 1,
	PPS_PROGRESS	= 2,
	PPS_COMPLETE	= 3,
}

---------------------------------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************************************--
--																																	 --
-- 												게임 진행정보는 파일 맨 밑에 있음													 --
--																																	 --
--***********************************************************************************************************************************--
---------------------------------------------------------------------------------------------------------------------------------------


--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[											테이블 구조											]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--

--[[
	PuzzleMemory =
	{
		PM_CurrentTime 	= 현재 시간
		PM_EventMap		= "맵인덱스"
		PM_NPCHandle	= 메인NPC 핸들


		PM_State	= PG_GAME_STATE["PGS_WAIT"]
		PM_StepInfo	= {
						SI_Step				= 스텝의 세부단계
						SI_NextStepTime		= 다음 스텝 시간
					  },

		PM_GameInfo = {
						GI_GameMode		= 모드,
						GI_CharHandle	= 존 핸들
						GI_CharNumber	= 캐릭터 넘버,
						GI_StartTime	= 게임 시작 시간,
						GI_GameEndTime	= 게임 종료 시간,
						GI_NoClickTime	= 게임 클릭 안할 시 게임종료 되는 시간,
					  },

		PG_PrevGamePlayer = {
								PP_CharNumber 	= 캐릭터 넘버
								PP_WaitingTime	= 다음 플레이 가능한 시간
							}

		[게임타입]					= tPuzzleBoard( 아래 테이블 ),
		PM_PieceArray[PI_Handle] 	= CI_PieceInfo....
	}

	tPuzzleBoard =
	{
		PB_State		= 대기, 진행, 완료,
		PB_EmptyCellID 	= CI_ID,

		PB_MovableCell	= 	{
								PMC_UP		= CI_ID,
								PMC_DOWN	= CI_ID,
								PMC_LEFT	= CI_ID,
								PMC_RIGHT	= CI_ID,
							},

		-- 무슨게임인지 모르기 때문에 크기를 저장함
		PB_BoardSize 	=	{
								MaxCell		 	= ,
								MaxWidth		= ,
								MaxHeight		=
							},

		PB_CellArray 	=	{
								CellInfo = {
												CI_ID
												CI_PieceInfo =
																{
																	PI_ID,
																	PI_Handle,
																	PI_GameType,
																}
											}
										.......
							}
		PB_BaseBoard	=	{
								BB_Handle = BaseBoard 핸들
							}
		PB_CellList[PI_Handle] = CellInfo
	}
--]]


--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[											퍼즐게임 함수										]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--


-- 이벤트 정보를 저장할 메모리
g_PuzzleMemory 		= { }
g_EventNPCHandle	= { }
g_DieInfo			= { }


function Xiaoming( Handle, MapIndex )
cExecCheck( "Xiaoming" )

	if cIsObjectDead( Handle )
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		PuzzleMemory[Handle] = nil

		return ReturnAI["END"]
	end


	local PuzzleMemory


	PuzzleMemory = g_PuzzleMemory[Handle]
	if PuzzleMemory == nil
	then

		cAIScriptFunc( Handle, "NPCClick", "PG_MAIN_NPC_CLICK" 	)
		cAIScriptFunc( Handle, "NPCMenu", "PG_NPCMENU_ACK" 		)

		g_PuzzleMemory[Handle] 			= { }
		PuzzleMemory					= g_PuzzleMemory[Handle]

		PuzzleMemory["PM_NPCHandle"]		= Handle
		PuzzleMemory["PM_DoorBlockHandle"]	= PG_INVALID_VALUE
		PuzzleMemory["PM_CurrentTime"]		= cCurrentSecond()
		PuzzleMemory["PM_EventMap"]			= MapIndex
		PuzzleMemory["PM_State"]			= PG_GAME_STATE["PGS_WAIT"]

		PuzzleMemory["PM_StepInfo"] 		= { }
		PuzzleMemory["PM_GameInfo"] 		= { }
		PuzzleMemory["PG_PrevGamePlayer"]	= { }
		PuzzleMemory["PM_PieceArray"] 		= { }

		PuzzleMemory["PM_StepInfo"]["SI_Step"]			= 1
		PuzzleMemory["PM_StepInfo"]["SI_NextStepTime"]	= PuzzleMemory["PM_CurrentTime"]

		PuzzleMemory["PM_GameInfo"]["GI_GameMode"] 		= PG_INVALID_VALUE
		PuzzleMemory["PM_GameInfo"]["GI_CharNumber"] 	= PG_INVALID_VALUE
		PuzzleMemory["PM_GameInfo"]["GI_CharHandle"]	= PG_INVALID_VALUE
		PuzzleMemory["PM_GameInfo"]["GI_StartTime"] 	= PG_INVALID_VALUE
		PuzzleMemory["PM_GameInfo"]["GI_GameEndTime"] 	= PG_INVALID_VALUE
		PuzzleMemory["PM_GameInfo"]["GI_NoClickTime"]	= PG_INVALID_VALUE

		PuzzleMemory["PG_PrevGamePlayer"]["PP_CharNumber"]	= PG_INVALID_VALUE
		PuzzleMemory["PG_PrevGamePlayer"]["PP_WaitingTime"]	= PG_INVALID_VALUE

		PG_EVENT_OPEN( PuzzleMemory )

	end

	PuzzleMemory["PM_CurrentTime"]	= cCurrentSecond()

	PG_GAME_ROUTINE( PuzzleMemory )

end


function PG_EVENT_OPEN( PuzzleMemory )
cExecCheck( "PG_EVENT_OPEN" )

	if PuzzleMemory == nil
	then
		return
	end

--[[
	PuzzleMemory["PM_DoorBlockHandle"] = cDoorBuild( PuzzleMemory["PM_EventMap"], PG_DOOR_BLOCK["PDB_DOOR_INDEX"],
											PG_DOOR_BLOCK["PDB_REGEN_POSITION"]["X"], PG_DOOR_BLOCK["PDB_REGEN_POSITION"]["Y"], PG_DOOR_BLOCK["PDB_REGEN_POSITION"]["DIR"], 1000 )

	if PuzzleMemory["PM_DoorBlockHandle"] ~= nil
	then
		cDoorAction( PuzzleMemory["PM_DoorBlockHandle"], PG_DOOR_BLOCK["PDB_BLOCK_INDEX"], "close" )
	end
--]]

	for i = 1,  #PG_BASE_BOARD_DATA do

		local PuzzleBoard 	= { }
		local BaseBoard	= { }


		PuzzleBoard["PB_MovableCell"] 	= { }
		PuzzleBoard["PB_BoardSize"]		= { }
		PuzzleBoard["PB_BaseBoard"]		= { }
		PuzzleBoard["PB_CellArray"]		= { }
		PuzzleBoard["PB_CellList"]		= { }

		PuzzleBoard["PB_MovableCell"][PG_MOVABLE_CELL["PMC_UP"]]	= PG_INVALID_VALUE
		PuzzleBoard["PB_MovableCell"][PG_MOVABLE_CELL["PMC_DOWN"]]	= PG_INVALID_VALUE
		PuzzleBoard["PB_MovableCell"][PG_MOVABLE_CELL["PMC_LEFT"]]	= PG_INVALID_VALUE
		PuzzleBoard["PB_MovableCell"][PG_MOVABLE_CELL["PMC_RIGHT"]]	= PG_INVALID_VALUE

		PuzzleBoard["PB_BoardSize"]["MaxWidth"]		= PG_PUZZLE_SIZE[i]["PS_WIDTH"]
		PuzzleBoard["PB_BoardSize"]["MaxHeight"]	= PG_PUZZLE_SIZE[i]["PS_HEIGHT"]
		PuzzleBoard["PB_BoardSize"]["MaxCell"]		= PG_PUZZLE_SIZE[i]["PS_WIDTH"] * PG_PUZZLE_SIZE[i]["PS_HEIGHT"]

		PuzzleBoard["PB_State"] 		= PG_PUZZLE_STATE["PPS_WAIT"]
		PuzzleBoard["PB_EmptyCellID"]	= PuzzleBoard["PB_BoardSize"]["MaxCell"]

		PG_GET_MOVABLE_CELL( PuzzleBoard )


		-- 퍼즐판 생성
		local BaseBoardLoc


		BaseBoardLoc 								= PG_BASE_BOARD_DATA[i]["BB_REGEN_POS"]
		PuzzleBoard["PB_BaseBoard"]["BB_Handle"] 	= cMobRegen_XY( PuzzleMemory["PM_EventMap"], PG_BASE_BOARD_DATA[i]["BB_INDEX"],
																 BaseBoardLoc["RP_X"], BaseBoardLoc["RP_Y"], BaseBoardLoc["RP_DIR"] )

		if PuzzleBoard["PB_BaseBoard"]["BB_Handle"] ~= nil
		then
			cAIScriptSet	( PuzzleBoard["PB_BaseBoard"]["BB_Handle"], PuzzleMemory["PM_NPCHandle"] )
			cAIScriptFunc	( PuzzleBoard["PB_BaseBoard"]["BB_Handle"], "Entrance", "PG_PIECE_ROUTINE" )

			PuzzleMemory["PM_PieceArray"][PuzzleBoard["PB_BaseBoard"]["BB_Handle"]] = PuzzleBoard["PB_BaseBoard"]
			g_PuzzleMemory[PuzzleBoard["PB_BaseBoard"]["BB_Handle"]] 				= PuzzleMemory
		end


		-- 완료 퍼즐 생성
		local ComplPuzzleLoc
		local PieceInfo		= { }
		local CellInfo		= { }


		ComplPuzzleLoc 			= PG_COMPLETION_PUZZLE_DATA[i]["CP_REGEN_POS"]
		PieceInfo["PI_Handle"] 	= cMobRegen_XY( PuzzleMemory["PM_EventMap"], PG_COMPLETION_PUZZLE_DATA[i]["CP_INDEX"],
																 ComplPuzzleLoc["RP_X"], ComplPuzzleLoc["RP_Y"], ComplPuzzleLoc["RP_DIR"] )
		if PieceInfo["PI_Handle"] ~= nil
		then
			cAIScriptSet	( PieceInfo["PI_Handle"], PuzzleMemory["PM_NPCHandle"] )
			cAIScriptFunc	( PieceInfo["PI_Handle"], "Entrance", "PG_PIECE_ROUTINE" )


			g_PuzzleMemory[PieceInfo["PI_Handle"]] = PuzzleMemory

			PieceInfo["PI_ID"] 			= 1
			PieceInfo["PI_GameType"]	= i

			CellInfo["CI_ID"]				= 1
			CellInfo["CI_PieceInfo"]		= PieceInfo

			PuzzleBoard["PB_CellArray"][1] 						= CellInfo
			PuzzleBoard["PB_CellList"][PieceInfo["PI_Handle"]]	= CellInfo

			PuzzleMemory["PM_PieceArray"][PieceInfo["PI_Handle"]] = PieceInfo
		end

		PuzzleMemory[i] = PuzzleBoard

	end

end



--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[								메인 루틴 / 몬스터 루틴											]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--
function PG_GAME_ROUTINE( PuzzleMemory )
cExecCheck( "PG_GAME_ROUTINE" )

	if PuzzleMemory == nil
	then
		return
	end

	local PuzzleState
	local GameInfo
	local StepInfo
	local PuzzleStep
	local ProgressData
	local ProgressStepData


	PuzzleState = PuzzleMemory["PM_State"]

	GameInfo	= PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	StepInfo	= PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	PuzzleStep = StepInfo["SI_Step"]
	if PuzzleMemory["PM_CurrentTime"] < StepInfo["SI_NextStepTime"]
	then
		return
	end

	ProgressData 		= PG_PROGRESS_DATA[PuzzleState]
	ProgressStepData	= ProgressData["PPD_STEP_INFO"][PuzzleStep]


	if ProgressStepData["PPD_EFFECTMSG"] ~= nil
	then
		cEffectMsg( GameInfo["GI_CharHandle"], ProgressStepData["PPD_EFFECTMSG"] )
	end

	if ProgressStepData["PPD_MOBCHAT"] ~= nil
	then
		cMobChat( PuzzleMemory["PM_NPCHandle"], ProgressStepData["PPD_MOBCHAT"]["FILENAME"], ProgressStepData["PPD_MOBCHAT"]["INDEX"] )
	end

	if ProgressStepData["PPD_FACECUT"] ~= nil
	then
		cMobDialog_Obj( GameInfo["GI_CharHandle"], ProgressStepData["PPD_FACECUT"]["FACECUT"], ProgressStepData["PPD_FACECUT"]["FILENAME"], ProgressStepData["PPD_FACECUT"]["INDEX"] )
	end

	ProgressStepData["PPD_FUNC"]( PuzzleMemory )

	StepInfo["SI_Step"] = StepInfo["SI_Step"] + 1
	if StepInfo["SI_Step"] > ProgressData["PPD_STEP_COUNT"]
	then
		StepInfo["SI_Step"] = 1

		if ProgressData["PPD_STEP_ISLOOP"] == false
		then
			PuzzleMemory["PM_State"]	= PuzzleMemory["PM_State"] + 1
			if PuzzleMemory["PM_State"] > PG_GAME_STATE["PGS_COMPLETE"]
			then
				PuzzleMemory["PM_State"] 	= PG_GAME_STATE["PGS_WAIT"]
				StepInfo["SI_Step"] 		= 1
			end

			ProgressData 				= PG_PROGRESS_DATA[PuzzleState]
			ProgressStepData			= ProgressData["PPD_STEP_INFO"][PuzzleStep]
		end
	end
	StepInfo["SI_NextStepTime"] = PuzzleMemory["PM_CurrentTime"] + ProgressStepData["PPD_DELAY"]

end


function PG_DUMMY_FUNCTION( PuzzleMemory )
cExecCheck( "PG_DUMMY_FUNCTION" )

end


function PG_PIECE_ROUTINE( Handle, MapIndex )
cExecCheck( "PG_PIECE_ROUTINE" )

	local PuzzleMemory
	local PieceArray

	PuzzleMemory = g_PuzzleMemory[Handle]
	if PuzzleMemory == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle )
	then

		if g_DieInfo[Handle] < PuzzleMemory["PM_CurrentTime"]
		then
			cAIScriptSet	( Handle )
			cNPCVanish		( Handle )

			g_PuzzleMemory[Handle] 	= nil
			g_DieInfo[Handle]		= nil
		end

		return ReturnAI["END"]
	end

	PieceArray = PuzzleMemory["PM_PieceArray"]
	if PieceArray == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		g_PuzzleMemory[Handle] = nil

		return ReturnAI["END"]
	end

	if PieceArray[Handle] == nil
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		g_PuzzleMemory[Handle] = nil

		return ReturnAI["END"]
	end

	if cIsObjectDead( PuzzleMemory["PM_NPCHandle"] )
	then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		g_PuzzleMemory[Handle] = nil

		return ReturnAI["END"]
	end

	return ReturnAI["END"]

end


function PG_COUNT_DELETE_BOARD( PuzzleMemory )
cExecCheck( "PG_COUNT_DELETE_BOARD" )

	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PM_State"] ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	PuzzleState = PuzzleMemory["PM_State"]
	if PuzzleState ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	local StepInfo
	local PuzzleStep
	local GameInfo


	StepInfo 	= PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	PuzzleStep	= StepInfo["SI_Step"]
	if PuzzleStep == PG_INVALID_VALUE
	then
		return
	end

	GameInfo	= PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end


	if GameInfo["GI_GameMode"] == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
	then

		for i = 1, #PG_BASE_BOARD_DATA do

			local PuzzleBoard
			local BaseBoard


			PuzzleBoard = PuzzleMemory[i]
			if PuzzleBoard == nil
			then
				return
			end

			PG_DELETE_PUZZLEBOARD	( i, PuzzleMemory )
			PG_CREATE_BASE_CELL		( i, PuzzleMemory )
			PG_SUFFLE_PIECES		( PuzzleBoard )
			PG_GET_MOVABLE_CELL		( PuzzleBoard )

			BaseBoard = PuzzleBoard["PB_BaseBoard"]
			if BaseBoard == nil
			then
				return
			end

			cSetAbstate( BaseBoard["BB_Handle"], PG_ABSTATE_DATA["PAD_GAME_SELECT"]["INDEX"], 1, PG_ABSTATE_DATA["PAD_GAME_SELECT"]["KEEPTIME"] )

		end

	else

		local PuzzleBoard
		local BaseBoard


		PuzzleBoard = PuzzleMemory[GameInfo["GI_GameMode"]]
		if PuzzleBoard == nil
		then
			return
		end

		PG_DELETE_PUZZLEBOARD	( GameInfo["GI_GameMode"], PuzzleMemory )
		PG_CREATE_BASE_CELL		( GameInfo["GI_GameMode"], PuzzleMemory )
		PG_SUFFLE_PIECES		( PuzzleBoard )
		PG_GET_MOVABLE_CELL		( PuzzleBoard )

		BaseBoard = PuzzleBoard["PB_BaseBoard"]
		if BaseBoard == nil
		then
			return
		end

		cSetAbstate( BaseBoard["BB_Handle"], PG_ABSTATE_DATA["PAD_GAME_SELECT"]["INDEX"], 1, PG_ABSTATE_DATA["PAD_GAME_SELECT"]["KEEPTIME"] )

	end

end


function PG_COUNT_EFFECT_BOARD( PuzzleMemory )
cExecCheck( "PG_COUNT_EFFECT_BOARD" )

	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PM_State"] ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	PuzzleState = PuzzleMemory["PM_State"]
	if PuzzleState ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	local StepInfo
	local PuzzleStep
	local GameInfo


	StepInfo 	= PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	PuzzleStep	= StepInfo["SI_Step"]
	if PuzzleStep == PG_INVALID_VALUE
	then
		return
	end

	GameInfo	= PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	if GameInfo["GI_GameMode"] == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
	then

		for i = 1, #PG_BASE_BOARD_DATA do

			local PuzzleBoard
			local BaseBoard


			PuzzleBoard = PuzzleMemory[i]
			if PuzzleBoard == nil
			then
				return
			end

			BaseBoard = PuzzleBoard["PB_BaseBoard"]
			if BaseBoard == nil
			then
				return
			end

			cSetAbstate( BaseBoard["BB_Handle"], PG_ABSTATE_DATA["PAD_GAME_SELECT"]["INDEX"], 1, PG_ABSTATE_DATA["PAD_GAME_SELECT"]["KEEPTIME"] )

		end

	else

		local PuzzleBoard
		local BaseBoard


		PuzzleBoard = PuzzleMemory[GameInfo["GI_GameMode"]]
		if PuzzleBoard == nil
		then
			return
		end

		BaseBoard = PuzzleBoard["PB_BaseBoard"]
		if BaseBoard == nil
		then
			return
		end

		cSetAbstate( BaseBoard["BB_Handle"], PG_ABSTATE_DATA["PAD_GAME_SELECT"]["INDEX"], 1, PG_ABSTATE_DATA["PAD_GAME_SELECT"]["KEEPTIME"] )

	end

end


function PG_COUNT_REGEN_PIECES( PuzzleMemory )
cExecCheck( "PG_COUNT_REGEN_PIECES" )

	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PM_State"] ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	PuzzleState = PuzzleMemory["PM_State"]
	if PuzzleState ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	local StepInfo
	local PuzzleStep
	local GameInfo


	StepInfo 	= PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	PuzzleStep	= StepInfo["SI_Step"]
	if PuzzleStep == PG_INVALID_VALUE
	then
		return
	end

	GameInfo	= PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	if GameInfo["GI_GameMode"] == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
	then

		for i = 1, #PG_BASE_BOARD_DATA do

			local PuzzleBoard


			PuzzleBoard = PuzzleMemory[i]
			if PuzzleBoard == nil
			then
				return
			end

			PG_REGEN_PIECES( i, PuzzleMemory )

		end

	else

		local PuzzleBoard


		PuzzleBoard = PuzzleMemory[GameInfo["GI_GameMode"]]
		if PuzzleBoard == nil
		then
			return
		end

		PG_REGEN_PIECES( GameInfo["GI_GameMode"], PuzzleMemory )

	end

end


function PG_COUNT_GAME_START( PuzzleMemory )
cExecCheck( "PG_COUNT_GAME_START" )

	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PM_State"] ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end

	PuzzleState = PuzzleMemory["PM_State"]
	if PuzzleState ~= PG_GAME_STATE["PGS_COUNT"]
	then
		return
	end


	local StepInfo
	local PuzzleStep
	local GameInfo


	StepInfo 	= PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	PuzzleStep	= StepInfo["SI_Step"]
	if PuzzleStep == PG_INVALID_VALUE
	then
		return
	end

	GameInfo	= PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	local GameData


	GameData = PG_GAME_DATA[GameInfo["GI_GameMode"]]
	if GameData == nil
	then
		return
	end

	GameInfo["GI_GameEndTime"]	= PuzzleMemory["PM_CurrentTime"] + PG_GAME_DATA[GameInfo["GI_GameMode"]]["PGD_PLAYTIME"]

	if GameInfo["GI_GameMode"] == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
	then

		for i = 1, #PG_BASE_BOARD_DATA do

			local PuzzleBoard


			PuzzleBoard = PuzzleMemory[i]
			if PuzzleBoard == nil
			then
				return
			end

			PuzzleBoard["PB_State"] = PG_PUZZLE_STATE["PPS_PROGRESS"]

		end

	else

		local PuzzleBoard


		PuzzleBoard = PuzzleMemory[GameInfo["GI_GameMode"]]
		if PuzzleBoard == nil
		then
			return
		end

		PuzzleBoard["PB_State"] = PG_PUZZLE_STATE["PPS_PROGRESS"]

	end

	GameInfo["GI_StartTime"]	= PuzzleMemory["PM_CurrentTime"]
	GameInfo["GI_NoClickTime"] 	= PuzzleMemory["PM_CurrentTime"] + PG_NO_CLICK_TIME
	cEffectTimer( GameInfo["GI_CharHandle"], 0, PG_GAME_DATA[GameInfo["GI_GameMode"]]["PGD_PLAYTIME"] )

	return

end


function PG_PROGRESS_ISCOMPLETE( PuzzleMemory )
cExecCheck( "PG_PROGRESS_ISCOMPLETE" )

	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PM_State"] ~= PG_GAME_STATE["PGS_PROGRESS"]
	then
		return
	end

	local GameInfo
	local StepInfo


	GameInfo = PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	StepInfo = PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	if GameInfo["GI_NoClickTime"] < PuzzleMemory["PM_CurrentTime"]
	then
		cSystemMessage_Obj( GameInfo["GI_CharHandle"], PG_CIRCUMSTANCE_DIALOG["GAMEOVER_NO_CLICK"]["FILENAME"], PG_CIRCUMSTANCE_DIALOG["GAMEOVER_NO_CLICK"]["INDEX"] )
		PuzzleMemory["PM_State"] = PG_GAME_STATE["PGS_FAIL"]
		return

	end

	if GameInfo["GI_GameEndTime"] < PuzzleMemory["PM_CurrentTime"]
	then

		PuzzleMemory["PM_State"] = PG_GAME_STATE["PGS_FAIL"]
		return

	end


	if GameInfo["GI_GameMode"] == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
	then

		for i = 1, #PG_BASE_BOARD_DATA do

			local PuzzleBoard


			PuzzleBoard = PuzzleMemory[i]
			if PuzzleBoard == nil
			then
				return
			end

			if PuzzleBoard["PB_State"] ~= PG_PUZZLE_STATE["PPS_COMPLETE"]
			then
				return
			end

		end

	else

		local PuzzleBoard


		PuzzleBoard = PuzzleMemory[GameInfo["GI_GameMode"]]
		if PuzzleBoard == nil
		then
			return
		end

		if PuzzleBoard["PB_State"] ~= PG_PUZZLE_STATE["PPS_COMPLETE"]
		then
			return
		end

	end

	PuzzleMemory["PM_State"]	= PG_GAME_STATE["PGS_COMPLETE"]
	StepInfo["SI_Step"]			= 1

end


function PG_COMPLETE_INIT_GAME( PuzzleMemory )
cExecCheck( "PG_COMPLETE_INIT_GAME" )

	if PuzzleMemory == nil
	then
		return
	end

	local GameInfo
	local StepInfo


	GameInfo = PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	StepInfo = PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end

	if PuzzleMemory["PG_PrevGamePlayer"] == nil
	then
		return
	end

	PuzzleMemory["PG_PrevGamePlayer"]["PP_CharNumber"]	= GameInfo["GI_CharNumber"]
	PuzzleMemory["PG_PrevGamePlayer"]["PP_WaitingTime"]	= PuzzleMemory["PM_CurrentTime"] + PG_WATING_TIME


	if GameInfo["GI_GameMode"] == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
	then

		for i = 1, #PG_BASE_BOARD_DATA do

			local PuzzleBoard
			local BaseBoard


			PuzzleBoard		= PuzzleMemory[i]
			if PuzzleBoard == nil
			then
				return
			end

			BaseBoard = PuzzleBoard["PB_BaseBoard"]
			if BaseBoard == nil
			then
				return
			end

			PG_DELETE_PUZZLEBOARD	( i, PuzzleMemory )
			PG_REGEN_COMPLETION		( i, PuzzleMemory )

		end

	else

		local PuzzleBoard
		local BaseBoard


		PuzzleBoard		= PuzzleMemory[GameInfo["GI_GameMode"]]
		if PuzzleBoard == nil
		then
			return
		end

		BaseBoard = PuzzleBoard["PB_BaseBoard"]
		if BaseBoard == nil
		then
			return
		end

		PG_DELETE_PUZZLEBOARD	( GameInfo["GI_GameMode"], PuzzleMemory )
		PG_REGEN_COMPLETION		( GameInfo["GI_GameMode"], PuzzleMemory )

	end


	cTopView( GameInfo["GI_CharHandle"], 0, 0, 0, 0, 0 )
	cHideOtherPlayer( GameInfo["GI_CharHandle"], 0 )

	cResetAbstate( GameInfo["GI_CharHandle"], PG_ABSTATE_DATA["PAD_USER_STUN"]["INDEX"] )
	cResetAbstate( PuzzleMemory["PM_NPCHandle"], PG_ABSTATE_DATA["PAD_FOMING_EFFECT"]["INDEX"] )
	cEffectTimer( GameInfo["GI_CharHandle"], 1, 0 )

	PuzzleMemory["PM_State"] 	= PG_GAME_STATE["PGS_WAIT"]

	StepInfo["SI_Step"]			= 1
	StepInfo["SI_NextStepTime"]	= PuzzleMemory["PM_CurrentTime"]

	GameInfo["GI_GameMode"]		= PG_INVALID_VALUE
	GameInfo["GI_CharHandle"]	= PG_INVALID_VALUE
	GameInfo["GI_CharNumber"]	= PG_INVALID_VALUE
	GameInfo["GI_GameEndTime"]	= PG_INVALID_VALUE

end


function PG_COMPLETE_SUCCESS_GAME( PuzzleMemory )
cExecCheck( "PG_COMPLETE_SUCCESS_GAME" )

	if PuzzleMemory == nil
	then
		return
	end

	local GameInfo
	local StepInfo


	GameInfo = PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	StepInfo = PuzzleMemory["PM_StepInfo"]
	if StepInfo == nil
	then
		return
	end


	local RewardAbstateData
	local RewardCharTitleData
	local DialogData
	local PlayTime


	RewardAbstateData 	= PG_GAME_DATA[GameInfo["GI_GameMode"]]["PGD_REWARD_ABSTATE"]
	RewardCharTitleData	= PG_GAME_DATA[GameInfo["GI_GameMode"]]["PGD_REWARD_CHARTITLE"]
	PlayTime			= PuzzleMemory["PM_CurrentTime"] - GameInfo["GI_StartTime"]

	PlayTime = math.floor( PlayTime )
	cScriptMessage_Obj( GameInfo["GI_CharHandle"], PG_ANNOUNCE_DATA["PLAY_TIME"], PlayTime )

	for i = 1, #RewardAbstateData do
		cSetAbstate_Range( PuzzleMemory["PM_NPCHandle"], PG_REWARD_RANGE, ObjectType["Player"], RewardAbstateData[i]["PRA_INDEX"], 1, RewardAbstateData[i]["PRA_KEEPTIME"] )
	end

	cCharTitleAddValue( GameInfo["GI_CharHandle"], RewardCharTitleData["PRC_ID"], RewardCharTitleData["PRC_VALUE"] )

end


--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[									리젠 / 삭제 함수											]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--
function PG_REGEN_COMPLETION( nGameType, PuzzleMemory )
cExecCheck( "PG_REGEN_COMPLETION" )

	if PuzzleMemory == nil
	then
		return
	end


	local PuzzleBoard


	PuzzleBoard	= PuzzleMemory[nGameType]
	if PuzzleBoard == nil
	then
		return
	end

	if PuzzleMemory["PM_PieceArray"] == nil
	then
		PuzzleMemory["PM_PieceArray"] = { }
	end


	PuzzleBoard["PB_CellArray"] = { }
	PuzzleBoard["PB_CellList"]	= { }


	-- 완료 퍼즐 생성
	local ComplPuzzleLoc
	local PieceInfo		= { }
	local CellInfo		= { }


	ComplPuzzleLoc 			= PG_COMPLETION_PUZZLE_DATA[nGameType]["CP_REGEN_POS"]
	PieceInfo["PI_Handle"] 	= cMobRegen_XY( PuzzleMemory["PM_EventMap"], PG_COMPLETION_PUZZLE_DATA[nGameType]["CP_INDEX"],
															 ComplPuzzleLoc["RP_X"], ComplPuzzleLoc["RP_Y"], ComplPuzzleLoc["RP_DIR"] )
	if PieceInfo["PI_Handle"] ~= nil
	then
		cAIScriptSet	( PieceInfo["PI_Handle"], PuzzleMemory["PM_NPCHandle"] )
		cAIScriptFunc	( PieceInfo["PI_Handle"], "Entrance", "PG_PIECE_ROUTINE" )


		g_PuzzleMemory[PieceInfo["PI_Handle"]] = PuzzleMemory

		PieceInfo["PI_ID"] 			= 1
		PieceInfo["PI_GameType"]	= nGameType

		CellInfo["CI_ID"]				= 1
		CellInfo["CI_PieceInfo"]		= PieceInfo

		PuzzleBoard["PB_CellArray"][1] 							= CellInfo
		PuzzleBoard["PB_CellList"][PieceInfo["PI_Handle"]]		= CellInfo

		PuzzleMemory["PM_PieceArray"][PieceInfo["PI_Handle"]] 	= PieceInfo
	end

	PuzzleMemory[nGameType] = PuzzleBoard

end


function PG_CREATE_BASE_CELL( nGameType, PuzzleMemory )
cExecCheck( "PG_CREATE_BASE_CELL" )

	if PuzzleMemory == nil
	then
		return
	end


	local PuzzleBoard


	PuzzleBoard	= PuzzleMemory[nGameType]
	if PuzzleBoard == nil
	then
		return
	end

	PuzzleBoard["PB_EmptyCellID"]	= PuzzleBoard["PB_BoardSize"]["MaxCell"]
	PG_GET_MOVABLE_CELL( PuzzleBoard )

	if PuzzleMemory["PM_PieceArray"] == nil
	then
		PuzzleMemory["PM_PieceArray"] = { }
	end

	PuzzleBoard["PB_CellArray"] 	= { }
	PuzzleBoard["PB_CellList"]		= { }

	local PuzzleSize
	local MaxCell
	local PiecesData


	PuzzleSize 	= PuzzleBoard["PB_BoardSize"]
	if PuzzleSize == nil
	then
		return
	end

	MaxCell		= PuzzleSize["MaxCell"]
	PiecesData 	= PG_PIECE_INFO[nGameType]

	for i = 1, MaxCell do

		local PieceLoc
		local PieceIndex
		local PieceInfo		= { }
		local CellInfo			= { }


		-- 빈셀도 Piece정보를 만들어 준다.
		if i == MaxCell
		then
			PieceInfo["PI_Handle"]		= PG_INVALID_VALUE

			PieceInfo["PI_ID"] 			= i
			PieceInfo["PI_GameType"]	= nGameType

			CellInfo["CI_ID"]			= i
			CellInfo["CI_PieceInfo"]	= PieceInfo

			PuzzleBoard["PB_CellArray"][i] 	= CellInfo

		end


		PieceInfo["PI_Handle"]			= PG_INVALID_VALUE
		PieceInfo["PI_ID"] 				= i
		PieceInfo["PI_GameType"]		= nGameType

		CellInfo["CI_ID"]				= i
		CellInfo["CI_PieceInfo"]		= PieceInfo

		PuzzleMemory[nGameType]["PB_CellArray"][i] = CellInfo

	end

	PuzzleMemory[nGameType] = PuzzleBoard

end


function PG_REGEN_PIECES( nGameType, PuzzleMemory )
cExecCheck( "PG_REGEN_PIECES" )

	if PuzzleMemory == nil
	then
		return
	end


	local PuzzleBoard


	PuzzleBoard	= PuzzleMemory[nGameType]
	if PuzzleBoard == nil
	then
		return
	end

	PuzzleBoard["PB_CellList"]		= { }

	local PuzzleSize
	local MaxCell
	local PiecesData
	local CellArray


	PuzzleSize 	= PuzzleBoard["PB_BoardSize"]
	if PuzzleSize == nil
	then
		return
	end

	MaxCell		= PuzzleSize["MaxCell"]
	PiecesData 	= PG_PIECE_INFO[nGameType]

	CellArray	= PuzzleBoard["PB_CellArray"]
	if CellArray == nil
	then
		return
	end


	for i = 1, MaxCell do

		local CellInfo
		local PieceInfo
		local PieceID
		local PieceLoc
		local PieceIndex


		CellInfo = CellArray[i]
		if CellInfo == nil
		then
			return
		end

		PieceInfo = CellInfo["CI_PieceInfo"]
		if PieceInfo == nil
		then
			return
		end

		PieceID	= PieceInfo["PI_ID"]

		if PiecesData[PieceID]["PI_INDEX"] ~= nil
		then
			PieceLoc 					= PiecesData[i]["PI_REGEN_POS"]
			PieceInfo["PI_Handle"]		= cMobRegen_XY( PuzzleMemory["PM_EventMap"], PiecesData[PieceID]["PI_INDEX"],
																					 PieceLoc["PI_X"], PieceLoc["PI_Y"], PieceLoc["PI_DIR"] )
			if PieceInfo["PI_Handle"] ~= nil
			then
				cAIScriptSet	( PieceInfo["PI_Handle"], PuzzleMemory["PM_NPCHandle"] 		)
				cAIScriptFunc	( PieceInfo["PI_Handle"], "Entrance", "PG_PIECE_ROUTINE" 	)
				cAIScriptFunc	( PieceInfo["PI_Handle"], "NPCClick", "PG_CLICK_PIECE" 		)

				g_PuzzleMemory[PieceInfo["PI_Handle"]] = PuzzleMemory

				PuzzleBoard["PB_CellList"][PieceInfo["PI_Handle"]]		= CellInfo
				PuzzleMemory["PM_PieceArray"][PieceInfo["PI_Handle"]] 	= PieceInfo

			end
		end

	end

end

function PG_DELETE_PUZZLEBOARD( nGameType, PuzzleMemory )
cExecCheck( "PG_DELETE_PUZZLEBOARD" )

	if PuzzleMemory == nil
	then
		return
	end


	local PieceArray
	local PuzzleBoard
	local CellArray
	local CellList


	PieceArray 	= PuzzleMemory["PM_PieceArray"]
	if PieceArray == nil
	then
		return
	end

	PuzzleBoard	= PuzzleMemory[nGameType]
	if PuzzleBoard == nil
	then
		return
	end

	CellArray = PuzzleBoard["PB_CellArray"]
	if CellArray == nil
	then
		return
	end

	CellList = PuzzleBoard["PB_CellList"]
	if CellList == nil
	then
		return
	end


	-- 퍼즐조각 정보 전체 삭제
	for i = 1, #CellArray do

		local CellInfo
		local PieceInfo
		local PieceHandle


		CellInfo = CellArray[i]
		if CellInfo == nil
		then
			return
		end

		PieceInfo = CellInfo["CI_PieceInfo"]
		if PieceInfo == nil
		then
			return
		end


		PieceHandle = PieceInfo["PI_Handle"]

		PuzzleMemory["PM_PieceArray"][PieceHandle]					= nil
		PuzzleMemory[nGameType]["PB_CellArray"][i]["CI_PieceInfo"]	= nil
		PuzzleMemory[nGameType]["PB_CellArray"][i]					= nil
		PuzzleMemory[nGameType]["PB_CellList"][PieceHandle]			= nil

		g_PuzzleMemory[PieceHandle]									= nil

	end

	CellList 	= nil
	CellArray 	= nil

end



--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[									퍼즐 관련 함수												]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--

function PG_SUFFLE_PIECES( tPuzzleBoard )
cExecCheck( "PG_SUFFLE_PIECES" )

	if tPuzzleBoard == nil
	then
		return
	end


	local CellArray
	local BoardSize
	local MaxPieceNumber
	local PrevEmptyCellID


	CellArray 		= tPuzzleBoard["PB_CellArray"]
	if CellArray == nil
	then
		return
	end

	BoardSize		= tPuzzleBoard["PB_BoardSize"]
	MaxPieceNumber	= BoardSize["MaxCell"] - 1

	PrevEmptyCellID = MaxPieceNumber

	for i = 1, PG_SUFFLE_COUNT do

		local MovableCell
		local RandomID
		local SwapCellID
		local EmptyCellID
		local TempPieceInfo


		MovableCell = tPuzzleBoard["PB_MovableCell"]
		if MovableCell == nil
		then
			return
		end

		-- 움직일 수 있는 셀 중 한 곳을 랜덤으로 고른다.
		RandomID  	= cRandomInt( 1, 4 )
		SwapCellID	= MovableCell[RandomID]


		EmptyCellID 	= tPuzzleBoard["PB_EmptyCellID"]


		if ( SwapCellID ~= PG_INVALID_VALUE ) and ( PrevEmptyCellID ~= SwapCellID )
		then
			TempPieceInfo 							= CellArray[SwapCellID]["CI_PieceInfo"]
			CellArray[SwapCellID]["CI_PieceInfo"] 	= CellArray[EmptyCellID]["CI_PieceInfo"]
			CellArray[EmptyCellID]["CI_PieceInfo"]	= TempPieceInfo

			tPuzzleBoard["PB_EmptyCellID"]			= SwapCellID
			PG_GET_MOVABLE_CELL( tPuzzleBoard )

			PrevEmptyCellID 						= EmptyCellID
		end

	end

end


function PG_GET_MOVABLE_CELL( tPuzzleBoard )
cExecCheck( "PG_GET_MOVABLE_CELL" )

	if tPuzzleBoard == nil
	then
		return
	end


	local MovableCell
	local EmptyCell
	local MaxWidthSize
	local MaxHeightSize
	local MaxBorderSize


	MovableCell		= tPuzzleBoard["PB_MovableCell"]
	if MovableCell == nil
	then
		return
	end
	EmptyCell 		= tPuzzleBoard["PB_EmptyCellID"]
	MaxWidthSize	= tPuzzleBoard["PB_BoardSize"]["MaxWidth"]
	MaxHeightSize	= tPuzzleBoard["PB_BoardSize"]["MaxHeight"]
	MaxBorderSize	= tPuzzleBoard["PB_BoardSize"]["MaxCell"]


	if EmptyCell - MaxWidthSize  < 1 then
		MovableCell[PG_MOVABLE_CELL["PMC_UP"]] = PG_INVALID_VALUE
	else
		MovableCell[PG_MOVABLE_CELL["PMC_UP"]] = EmptyCell - MaxWidthSize
	end

	if EmptyCell + MaxWidthSize > MaxBorderSize then
		MovableCell[PG_MOVABLE_CELL["PMC_DOWN"]] = PG_INVALID_VALUE
	else
		MovableCell[PG_MOVABLE_CELL["PMC_DOWN"]] = EmptyCell + MaxWidthSize
	end

	if EmptyCell % MaxWidthSize == 1 then
		MovableCell[PG_MOVABLE_CELL["PMC_LEFT"]] = PG_INVALID_VALUE
	else
		MovableCell[PG_MOVABLE_CELL["PMC_LEFT"]] = EmptyCell - 1
	end

	if EmptyCell % MaxWidthSize == 0 then

		MovableCell[PG_MOVABLE_CELL["PMC_RIGHT"]] = PG_INVALID_VALUE
	else
		MovableCell[PG_MOVABLE_CELL["PMC_RIGHT"]] = EmptyCell + 1
	end


end


function PG_IS_COMPLETE_PUZZLE( tPuzzleBoard )
cExecCheck( "PG_IS_COMPLETE_PUZZLE" )

	if tPuzzleBoard == nil
	then
		return false
	end


	local CellArray
	local BorderSize
	local CheckBoardSize


	CellArray	= tPuzzleBoard["PB_CellArray"]
	if CellArray == nil
	then
		return
	end


	BorderSize = tPuzzleBoard["PB_BoardSize"]
	if BorderSize == nil
	then
		return
	end


	CheckBoardSize = BorderSize["MaxCell"]-1

	for i = 1, CheckBoardSize do

		local CellInfo
		local PieceInfo


		CellInfo = CellArray[i]
		if CellInfo == nil
		then
			return false
		end

		PieceInfo = CellInfo["CI_PieceInfo"]
		if PieceInfo == nil
		then
			return false
		end

		if PieceInfo["PI_ID"] ~= i
		then
			return false
		end

	end

	return true

end


function PG_PIECE_MOVE( PuzzleMemory, NPCGameType, NPCHandle )
cExecCheck( "PG_PIECE_MOVE" )

	if PuzzleMemory == nil
	then
		return false
	end

	local tPuzzleBoard


	tPuzzleBoard = PuzzleMemory[NPCGameType]
	if tPuzzleBoard == nil
	then
		return false
	end


	local PieceArray
	local CellList
	local CellArray
	local SelectedCell
	local MovableCell
	local GameInfo


	PieceArray = PuzzleMemory["PM_PieceArray"]
	if PieceArray == nil
	then
		return false
	end

	CellList = tPuzzleBoard["PB_CellList"]
	if CellList == nil
	then
		return false
	end


	CellArray = tPuzzleBoard["PB_CellArray"]
	if CellArray == nil
	then
		return false
	end


	SelectedCell = CellList[NPCHandle]
	if SelectedCell == nil
	then
		return false
	end


	MovableCell = tPuzzleBoard["PB_MovableCell"]
	if MovableCell == nil
	then
		return false
	end


	GameInfo = PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return false
	end

	for i = 1, #MovableCell do

		if MovableCell[i] == SelectedCell["CI_ID"]
		then

			local SelcetedPieceHandle
			local SelectedPieceID
			local EmptyCellID
			local EmptyCell
			local TempPieceInfo


			EmptyCellID	= tPuzzleBoard["PB_EmptyCellID"]
			EmptyCell 	= CellArray[EmptyCellID]
			if EmptyCell == nil
			then
				return false
			end

			-- 1. 빈셀을 선택된 셀으로 변경해준다.
			tPuzzleBoard["PB_EmptyCellID"] = SelectedCell["CI_ID"]

			-- 2. 선택된 Piece를 삭제해준다.
			SelcetedPieceHandle = SelectedCell["CI_PieceInfo"]["PI_Handle"]
			SelectedPieceID		= SelectedCell["CI_PieceInfo"]["PI_ID"]


			CellList[SelcetedPieceHandle]			= nil
			PieceArray["SelcetedPieceHandle"]		= nil

			if g_DieInfo == nil
			then
				g_DieInfo = { }
			end

			g_DieInfo[SelcetedPieceHandle] = PuzzleMemory["PM_CurrentTime"] + PG_PIECE_VANISH_TIME

			cKillObject( SelcetedPieceHandle, PG_INVALID_VALUE, GameInfo["GI_CharNumber"] )

			-- 3. PieceInfo Swap
			TempPieceInfo 					= EmptyCell["CI_PieceInfo"]
			EmptyCell["CI_PieceInfo"]		= SelectedCell["CI_PieceInfo"]
			SelectedCell["CI_PieceInfo"]	= TempPieceInfo

			-- 4. 새로운 퍼즐조각을 빈셀에 생성해준다.
			local PieceData
			local PieceIndex
			local PieceLoc
			local PieceInfo


			PieceData 	= PG_PIECE_INFO[NPCGameType]

			PieceIndex	= PieceData[SelectedPieceID]["PI_INDEX"]

			PieceLoc	= PieceData[EmptyCellID]["PI_REGEN_POS"]

			PieceInfo 	= EmptyCell["CI_PieceInfo"]
			if PieceInfo == nil
			then
				return false
			end

			PieceInfo["PI_Handle"] = cMobRegen_XY( PuzzleMemory["PM_EventMap"], PieceIndex,
																				PieceLoc["PI_X"], PieceLoc["PI_Y"], PieceLoc["PI_DIR"] )
			if PieceInfo["PI_Handle"] ~= nil
			then
				cAIScriptSet	( PieceInfo["PI_Handle"], PuzzleMemory["PM_NPCHandle"] 		)
				cAIScriptFunc	( PieceInfo["PI_Handle"], "Entrance", "PG_PIECE_ROUTINE" 	)
				cAIScriptFunc	( PieceInfo["PI_Handle"], "NPCClick", "PG_CLICK_PIECE" 		)

				g_PuzzleMemory[PieceInfo["PI_Handle"]] = PuzzleMemory

				CellList[PieceInfo["PI_Handle"]]		= EmptyCell
				PieceArray[PieceInfo["PI_Handle"]]		= PieceInfo

			end

			return true
		end

	end

	return false

end


--[[------------------------------------------------------------------------------------------------]]--
--[[																								]]--
--[[											NPC 클릭함수										]]--
--[[																								]]--
--[[------------------------------------------------------------------------------------------------]]--


--------------------------------------------------------------------------
--			  				메인 NPC 클릭 								--
--------------------------------------------------------------------------
function PG_MAIN_NPC_CLICK( NPCHandle, PlyHandle, PlyRegNum  )
cExecCheck( "PG_MAIN_NPC_CLICK" )

	local PuzzleMemory
	local GameState


	PuzzleMemory = g_PuzzleMemory[NPCHandle]
	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PG_PrevGamePlayer"] == nil
	then
		return
	end

	if ( PuzzleMemory["PG_PrevGamePlayer"]["PP_CharNumber"] == PlyRegNum ) and
	   ( PuzzleMemory["PG_PrevGamePlayer"]["PP_WaitingTime"] > PuzzleMemory["PM_CurrentTime"] )
	then

		cSystemMessage_Obj( PlyHandle, PG_CIRCUMSTANCE_DIALOG["GAME_WATING"]["FILENAME"], PG_CIRCUMSTANCE_DIALOG["GAME_WATING"]["INDEX"] )
		return
	end

	GameState = PuzzleMemory["PM_State"]
	if GameState == PG_GAME_STATE["PGS_WAIT"]
	then
		cNPCMenuOpen( NPCHandle, PlyHandle )
	else
		cSystemMessage_Obj( PlyHandle, PG_CIRCUMSTANCE_DIALOG["GAME_ALREADY_PLAY"]["FILENAME"], PG_CIRCUMSTANCE_DIALOG["GAME_ALREADY_PLAY"]["INDEX"] )
	end

	return
end


function PG_NPCMENU_ACK(  NPCHandle, PlyHandle, PlyRegNum, Value )
cExecCheck( "PG_NPCMENU_ACK" )

	local PuzzleMemory
	local GameState


	PuzzleMemory = g_PuzzleMemory[NPCHandle]
	if PuzzleMemory == nil
	then
		return
	end

	GameState = PuzzleMemory["PM_State"]
	if GameState ~= PG_GAME_STATE["PGS_WAIT"]
	then
		return
	end


	local GameData


	GameData = PG_GAME_DATA[Value]
	if GameData == nil
	then
		return
	end


	-- 1. 돈을 차감시킨다.
	if cUseMoney( PlyHandle, GameData["PGD_COST"] ) == nil then

		local DialogData


		DialogData = PG_CIRCUMSTANCE_DIALOG["MONEY_LACK"]
		cMobDialog_Obj( PlyHandle, DialogData["FACECUT"], DialogData["FILENAME"], DialogData["INDEX"] )

	else

		local StepInfo
		local GameInfo
		local BaseBoard


		PuzzleMemory["PM_State"] 	= PG_GAME_STATE["PGS_COUNT"]
		StepInfo 					= PuzzleMemory["PM_StepInfo"]
		if StepInfo == nil
		then
			return
		end

		GameInfo 					= PuzzleMemory["PM_GameInfo"]
		if GameInfo == nil
		then
			return
		end


		PuzzleMemory["PM_State"]	= PG_GAME_STATE["PGS_COUNT"]
		StepInfo["SI_Step"]			= 1
		StepInfo["SI_NextStepTime"]	= PuzzleMemory["PM_CurrentTime"]

		GameInfo["GI_GameMode"]		= Value
		GameInfo["GI_CharNumber"]	= PlyRegNum
		GameInfo["GI_CharHandle"]	= PlyHandle


		if Value == PG_PUZZLE_MODE["PGM_ALL_PLAY"]
		then

			for i = 1, #PG_BASE_BOARD_DATA do

				local PuzzleBoard
				local BaseBoard


				PuzzleBoard		= PuzzleMemory[i]
				if PuzzleBoard == nil
				then
					return
				end

				BaseBoard = PuzzleBoard["PB_BaseBoard"]
				if BaseBoard == nil
				then
					return
				end

				PG_DELETE_PUZZLEBOARD	( i, PuzzleMemory )
				PG_REGEN_COMPLETION		( i, PuzzleMemory )

			end

		else

			local PuzzleBoard
			local BaseBoard


			PuzzleBoard		= PuzzleMemory[Value]
			if PuzzleBoard == nil
			then
				return
			end

			BaseBoard = PuzzleBoard["PB_BaseBoard"]
			if BaseBoard == nil
			then
				return
			end

			PG_DELETE_PUZZLEBOARD	( Value, PuzzleMemory )
			PG_REGEN_COMPLETION		( Value, PuzzleMemory )

		end

		cSetAbstate( PuzzleMemory["PM_NPCHandle"], 	PG_ABSTATE_DATA["PAD_FOMING_EFFECT"]["INDEX"], 	1, PG_ABSTATE_DATA["PAD_FOMING_EFFECT"]["KEEPTIME"] )
		cSetAbstate( PlyHandle, 					PG_ABSTATE_DATA["PAD_USER_STUN"]["INDEX"], 		1, PG_ABSTATE_DATA["PAD_USER_STUN"]["KEEPTIME"] )

		cHideOtherPlayer( PlyHandle, 1 )
		cTopView( PlyHandle, 1, PG_TOPVIEW_DATA["PTD_CENTER_POS"]["PCP_X"], PG_TOPVIEW_DATA["PTD_CENTER_POS"]["PCP_Y"], PG_TOPVIEW_DATA["PTD_RANGE"], PG_TOPVIEW_DATA["PTD_DEGREE"] )

	end

end


--------------------------------------------------------------------------
--			  				퍼즐 조각 클릭								--
--------------------------------------------------------------------------
function PG_CLICK_PIECE( NPCHandle, PlyHandle, PlyRegNum  )
cExecCheck( "PG_CLICK_PIECE" )

	local PuzzleMemory
	local GameInfo
	local PieceArray
	local PieceInfo
	local NPCGameType
	local PuzzleBoard


	PuzzleMemory = g_PuzzleMemory[NPCHandle]
	if PuzzleMemory == nil
	then
		return
	end

	if PuzzleMemory["PM_State"] ~= PG_GAME_STATE["PGS_PROGRESS"]
	then
		return
	end

	GameInfo = PuzzleMemory["PM_GameInfo"]
	if GameInfo == nil
	then
		return
	end

	if GameInfo["GI_CharNumber"] ~= PlyRegNum
	then
		return
	end

	if GameInfo["GI_CharHandle"] ~= PlyHandle
	then
		return
	end

	if GameInfo["GI_GameMode"] == PG_INVALID_VALUE
	then
		return
	end

	PieceArray = PuzzleMemory["PM_PieceArray"]
	if PieceArray == nil
	then
		return
	end

	PieceInfo = PieceArray[NPCHandle]
	if PieceInfo == nil
	then
		return
	end

	NPCGameType = PieceInfo["PI_GameType"]
	if GameInfo["GI_GameMode"] ~= NPCGameType then

		if GameInfo["GI_GameMode"] ~= PG_PUZZLE_MODE["PGM_ALL_PLAY"]
		then
			return
		end

	end

	PuzzleBoard = PuzzleMemory[NPCGameType]
	if PuzzleBoard == nil
	then
		return
	end

	if PuzzleBoard["PB_State"] ~= PG_PUZZLE_STATE["PPS_PROGRESS"]
	then
		return
	end

	GameInfo["GI_NoClickTime"] = PuzzleMemory["PM_CurrentTime"] + PG_NO_CLICK_TIME

	-- 움직인게 성공했을 때만 퍼즐 완성되었는지 확인한다.
	if PG_PIECE_MOVE( PuzzleMemory, NPCGameType, NPCHandle ) == true
	then
		PG_GET_MOVABLE_CELL( PuzzleBoard )
		if PG_IS_COMPLETE_PUZZLE( PuzzleBoard ) == true
		then
			PuzzleBoard["PB_State"] = PG_PUZZLE_STATE["PPS_COMPLETE"]
		end
	end

end





---------------------------------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************************************--
--																																	 --
-- 															게임 진행 데이터														 --
--																																	 --
--***********************************************************************************************************************************--
---------------------------------------------------------------------------------------------------------------------------------------
PG_PROGRESS_DATA =
{
	-- WAIT
	{
		PPD_STEP_ISLOOP = true,		-- 특정상황 발생전까지 아래 스텝을 반복

		PPD_STEP_COUNT	= 3,		-- 아래 스텝의 수만큼 세팅해야 함
		PPD_STEP_INFO 	=			-- 스텝 정보
		{
			-- Step 1. NPC 대화 1
			{
				PPD_FUNC 		= PG_DUMMY_FUNCTION,									-- 현재 스텝에서 실행될 함수
				PPD_EFFECTMSG 	= nil,													-- 이펙트 메시지
				PPD_MOBCHAT		= { FILENAME = "Event", INDEX= "Xiaoming_Chat01" },		-- 몹챗 정보
				PPD_FACECUT		= nil,													-- 페이스 컷 정보
				PPD_DELAY 		= 4,													-- 다음 스텝까지 대기시간
			},

			-- Step 2. NPC 대화 2
			{
				PPD_FUNC 		= PG_DUMMY_FUNCTION,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= { FILENAME = "Event", INDEX= "Xiaoming_Chat02" },
				PPD_FACECUT		= nil,
				PPD_DELAY 		= 4,
			},

			-- Step 3. NPC 대화 3
			{
				PPD_FUNC 		= PG_DUMMY_FUNCTION,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= { FILENAME = "Event", INDEX= "Xiaoming_Chat03" },
				PPD_FACECUT		= nil,
				PPD_DELAY 		= 4,
			},
		}
	},

	-- COUNT
	{
		PPD_STEP_ISLOOP = false,	-- 아래 스텝을 전체 진행시 다음 상태로 변경
		PPD_STEP_COUNT	= 6,		-- 아래 스텝의 수만큼 세팅해야 함
		PPD_STEP_INFO 	=
		{
			-- Step 1. 카운트 다운 시작 전 딜레이
			{
				PPD_FUNC 		= PG_DUMMY_FUNCTION,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY 		= 1,
			},
			-- Step 2. 카운트 다운 시작
			{
				PPD_FUNC 		= PG_COUNT_EFFECT_BOARD,
				PPD_EFFECTMSG 	= EFFECT_MSG_TYPE["EMT_COUNT_8_SEC"],
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY 		= 2,
			},

			-- Step 3. NPC 페이스컷
			{
				PPD_FUNC 		= PG_DUMMY_FUNCTION,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= { FACECUT = "Xiaoming", FILENAME = "Event", INDEX = "Xiaoming_01" },
				PPD_DELAY		= 3,
			},

			-- Step 4. 퍼즐 조각 전체 삭제
			{
				PPD_FUNC 		= PG_COUNT_DELETE_BOARD,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY		= 0,
			},

			-- Step 5. 랜덤으로 생성된 퍼즐 소환 / 페이스컷
			{
				PPD_FUNC 		= PG_COUNT_REGEN_PIECES,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= { FACECUT = "Xiaoming", FILENAME ="Event", INDEX = "Xiaoming_02" },
				PPD_DELAY		= 3,
			},

			-- Step 6. 게임 스타트
			{
				PPD_FUNC 		= PG_COUNT_GAME_START,
				PPD_EFFECTMSG 	= EFFECT_MSG_TYPE["EMT_START"],
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY		= 0,
			},
		}
	},

--PROGRESS
	{
		PPD_STEP_ISLOOP = true,
		PPD_STEP_COUNT	= 1,
		PPD_STEP_INFO 	=
		{
			-- Step 1. 1초마다 한번씩 게임완료 했는지 확인
			{
				PPD_FUNC 		= PG_PROGRESS_ISCOMPLETE,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY 		= 1,
			},
		}
	},

--COMPLETE
	{
		PPD_STEP_ISLOOP = false,
		PPD_STEP_COUNT	= 2,
		PPD_STEP_INFO 	=
		{
			-- Step 1. 성공시 상태이상 / 캐릭터 타이틀 보상
			{
					PPD_FUNC 		= PG_COMPLETE_SUCCESS_GAME,
					PPD_EFFECTMSG 	= EFFECT_MSG_TYPE["EMT_SUCCESS"],
					PPD_MOBCHAT		= nil,
					PPD_FACECUT 	= { FACECUT = "Xiaoming", FILENAME ="Event", INDEX = "Xiaoming_03" },
					PPD_DELAY 		= 5,
			},

			-- Step 2. 게임 초기화
			{
				PPD_FUNC 		= PG_COMPLETE_INIT_GAME,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY 		= 1,
			},
		}
	},

--FAIL
	{
		PPD_STEP_ISLOOP = false,
		PPD_STEP_COUNT	= 2,
		PPD_STEP_INFO 	=
		{
			-- Step 1. 게임 실패시 이펙트 메시지, 페이스컷
			{
					PPD_FUNC 		= PG_DUMMY_FUNCTION,
					PPD_EFFECTMSG 	= EFFECT_MSG_TYPE["EMT_FAIL"],
					PPD_MOBCHAT		= nil,
					PPD_FACECUT 	= { FACECUT = "Xiaoming", FILENAME ="Event", INDEX = "Xiaoming_04" },
					PPD_DELAY 		= 2,
			},

			-- Step 2. 게임 초기화
			{
				PPD_FUNC 		= PG_COMPLETE_INIT_GAME,
				PPD_EFFECTMSG 	= nil,
				PPD_MOBCHAT		= nil,
				PPD_FACECUT 	= nil,
				PPD_DELAY 		= 1,
			},
		}
	},
}
