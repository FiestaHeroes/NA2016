--------------------------------------------------------------------------------
--                          Emperor Slime NPC Data                            --
--------------------------------------------------------------------------------

NPC_GuardChat =
{
	ScriptFileName = MsgScriptFileDefault,

	SpeakerIndex = "EldSpeGuard01",

	StartWarnDialog =
	{
		{ Index = "Guard_FaceCut01" },	-- 킹슬라임을 추적하여 여기까지 오셨군요.
		{ Index = "Guard_FaceCut02" },	-- 황제 슬라임이 곧 군대를 움직이려고 합니다.
		{ Index = "Guard_FaceCut03" },	-- 아직 충분한 수가 모이지 않았기 때문이 지금이 기회입니다!
		{ Index = "Guard_FaceCut04" },	-- 황제 슬라임과 잔당들을 처치하세요.
		{ Index = "Guard_FaceCut05" },	-- 저는 원군을 요청하러 가보겠습니다.
	},

	SuccessAndThenDialog =
	{
		{ Index = "Guard_FaceCut06" },	-- 원군을 데려오기 전에 벌써 끝내셨군요..
		{ Index = "Guard_FaceCut07" }, -- 이제 슬라임들은 큰 위협이 되지 못할 것입니다.
		{ Index = "Guard_FaceCut08" }, -- 감사합니다. 용사들이여..
	},

}
