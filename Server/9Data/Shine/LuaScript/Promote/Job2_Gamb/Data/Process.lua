--------------------------------------------------------------------------------
--                Promote Job2_Gamb Process Data                              --
--------------------------------------------------------------------------------

INVALID_HANDEL				= -1
ROULETTEGAME_PLAY_NUM 		= 5					-- 유저가 이 횟수보다 많이 룰렛 돌렸다면, 100% 당첨될 수 있도록 한다


-- 링크 위치 정보( 루멘 개선안 시기에 맞게 데이터 값 수정예정 )
LinkInfo =
{
	ReturnMap = { MapIndex = "RouN", X = 7310, Y = 7102 },
}


-- 지연 시간 정보
DelayTime =
{
	LimitTime				= 1200,		-- 플레이 제한시간( 20분 )

	GapDialog				= 2.5,		-- 페이스컷 출력시간간격
	GapReturnNotice			= 5,		-- ReturnToHome()의 공지메시지 출력시간간격

	WaitMobRegen			= 1,		-- 몹 소환한 뒤, WaitMobRegen만큼 기다렸다가 몹 카운팅
	WaitSeconds				= 1.5,		-- 대사 완료후 이 시간만큼 있다가 다음단계 진행

	WaitBeforeWinOrLose		= 12,		-- ResultRouletteGame() -> WinRouletteGame Or LoseRouletteGame 시작 대기시간
	WaitReturnToHome		= 3,		-- ReturnToHome() 대기시간
}


-- 대사 정보
ChatInfo =
{
	ScriptFileName 		= MsgScriptFileDefault,

	WelcomeGamble =
	{
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro00", },					--...6! Equals 720, 6C2 equals 9, in this case the standard deviation of the distribution is 2.43...Yes!!
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro01", },					--Uh? Oh, you are finally here. I was expecting you to come with the 97.5% of degree of confidence.
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro02", },					--What I did just now? This is a probability of you winning and taking my Precious.
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro03", },					--Unfortunately, your winning rate is just 1.03%. Do you still want to go for it??
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro04", },					--This is a very simple game, you pick one die and spin the roulette.
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro05", },					--If your choice is wrong, you will have some fun time with my slaves.
	},

	PlayRouletteGame =
	{
		Roulette1 	= { SpeakerIndex = "Job2_JokerTm", MsgIndex = "Roulette1",},	-- Pick the die first and then spin the roulette.
		Luck 		= { SpeakerIndex = "Job2_JokerTm", MsgIndex = "Luck",},			-- Good luck to you... and best luck to me...hahaha
	},

	Roulette_Click =
	{
		SpeakerIndex = "Job2_JokerTm", MsgIndex = "NotSelect", 						-- Pick the die first and then spin the roulette.
	},

	Roulette_Result =
	{
		PlayerWin = { SpeakerIndex = "Job2_JokerTm", MsgIndex = "PlayerWin",},		-- Seems like I am out of luck.
	},

	BeforeBossBattle =
	{
		Reward = { SpeakerIndex = "Job2_JokerTm", MsgIndex = "Reward",},			-- I do what I said. Enter that door and take the Precious.
	},

	BossBattle =
	{
		Betray  = { SpeakerIndex = "Job2_JokerTm", MsgIndex = "Betray",},			-- Let's start the second game. Only the winner survives. What do you think??
	},

	QuestSuccess =
	{
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "LastScript0",},				-- From where my calculation has been wrong?? That piece of time-space! That must have blinded me!
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "LastScript1",},				-- Yes, take that piece of time-space, so that it can blind your eyes too.
	},

}


-- ReturnToHome 공지
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "RouReturn30", },		-- 30초 남음
		{ Index = nil,          },		-- 25초 남음 : 메세지 없음
		{ Index = "RouReturn20", },		-- 20초 남음
		{ Index = nil,          },		-- 15초 남음 : 메세지 없음
		{ Index = "RouReturn10", },		-- 10초 남음
		{ Index = "RouReturn5" , },		-- 05초 남음
	},
}


-- 이펙트 정보
EffectInfo =
{
	Roullete_start 			= { FileName = "Job2_Gamble", 	PlayTime = 10000 },
	Roullete_Match_Success 	= { FileName = "Job2_GamS", 	PlayTime = 1000 },
	Roullete_Match_Fail		= { FileName = "Job2_GamF", 	PlayTime = 1000 },
}


-- 룰렛, 주사위 애니메이션 정보
AnimationInfo =
{
	Roulette =
	{
		"Stop1",
		"Stop2",
		"Stop3",
		"Stop4",
		"Stop5",
		"Stop6",
	},

	Dice =
	{
		AniMove = "dice_move",
		AniOff 	= "dice_off",
		AniOn 	= "dice_on",
	},
}


-- 영역 정보
AreaInfo =
{
	ToBossRoom = "Job2_Zone00"
}

-- 카메라 정보
CameraMoveInfo =
{
	AngleY 			= 10,
	Distance 		= 800,
	KeepTime 		= 6,
	AbstateIndex 	= "StaAdlFStun",
	AbstateTime 	= 7000,
}
