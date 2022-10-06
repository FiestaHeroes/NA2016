--------------------------------------------------------------------------------
--                Promote Job2_Gamb Process Data                              --
--------------------------------------------------------------------------------

INVALID_HANDEL				= -1
ROULETTEGAME_PLAY_NUM 		= 5					-- ������ �� Ƚ������ ���� �귿 ���ȴٸ�, 100% ��÷�� �� �ֵ��� �Ѵ�


-- ��ũ ��ġ ����( ��� ������ �ñ⿡ �°� ������ �� �������� )
LinkInfo =
{
	ReturnMap = { MapIndex = "RouN", X = 7310, Y = 7102 },
}


-- ���� �ð� ����
DelayTime =
{
	LimitTime				= 1200,		-- �÷��� ���ѽð�( 20�� )

	GapDialog				= 2.5,		-- ���̽��� ��½ð�����
	GapReturnNotice			= 5,		-- ReturnToHome()�� �����޽��� ��½ð�����

	WaitMobRegen			= 1,		-- �� ��ȯ�� ��, WaitMobRegen��ŭ ��ٷȴٰ� �� ī����
	WaitSeconds				= 1.5,		-- ��� �Ϸ��� �� �ð���ŭ �ִٰ� �����ܰ� ����

	WaitBeforeWinOrLose		= 12,		-- ResultRouletteGame() -> WinRouletteGame Or LoseRouletteGame ���� ���ð�
	WaitReturnToHome		= 3,		-- ReturnToHome() ���ð�
}


-- ��� ����
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


-- ReturnToHome ����
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "RouReturn30", },		-- 30�� ����
		{ Index = nil,          },		-- 25�� ���� : �޼��� ����
		{ Index = "RouReturn20", },		-- 20�� ����
		{ Index = nil,          },		-- 15�� ���� : �޼��� ����
		{ Index = "RouReturn10", },		-- 10�� ����
		{ Index = "RouReturn5" , },		-- 05�� ����
	},
}


-- ����Ʈ ����
EffectInfo =
{
	Roullete_start 			= { FileName = "Job2_Gamble", 	PlayTime = 10000 },
	Roullete_Match_Success 	= { FileName = "Job2_GamS", 	PlayTime = 1000 },
	Roullete_Match_Fail		= { FileName = "Job2_GamF", 	PlayTime = 1000 },
}


-- �귿, �ֻ��� �ִϸ��̼� ����
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


-- ���� ����
AreaInfo =
{
	ToBossRoom = "Job2_Zone00"
}

-- ī�޶� ����
CameraMoveInfo =
{
	AngleY 			= 10,
	Distance 		= 800,
	KeepTime 		= 6,
	AbstateIndex 	= "StaAdlFStun",
	AbstateTime 	= 7000,
}
