--------------------------------------------------------------------------------
--                         Crystal Castle Chat Data                           --
--------------------------------------------------------------------------------

ChatInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	EachPattern =
	{
		Pattern_KillAll =
		{
			-- 1,2,3,4,5,6,7,8,-,MR,17,18,AC,19,20,-,24,25,-,29,30,Hard,31,
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "KQ_G_BossTombRaider", Index = "ChatC1_1" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC2_1" },
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC2_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC3_1" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC3_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "HairDesignerB", Index = "ChatC4_1" },
					{ SpeakerIndex = "HairDesignerB", Index = "ChatC4_2" },
					{ SpeakerIndex = "HairDesignerB", Index = "ChatC4_3" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "Job2_BraveR", Index = "ChatC5_1" },
					{ SpeakerIndex = "Job2_BraveR", Index = "ChatC5_2" },
					{ SpeakerIndex = "Job2_BraveR", Index = "ChatC5_3" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "UruItemMctVellon", Index = "ChatC6_1" },
					{ SpeakerIndex = "UruItemMctVellon", Index = "ChatC6_2" },
					{ SpeakerIndex = "UruItemMctVellon", Index = "ChatC6_3" },
					{ SpeakerIndex = "UruItemMctVellon", Index = "ChatC6_4" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC7_1" },
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC7_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC8_1" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC8_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC17_1" },
					{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC17_3" },
					{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC17_4" },
					{ SpeakerIndex = "EldGuardCaptainShutian", Index = "ChatC17_5" },
					{ SpeakerIndex = "EldGuardCaptainShutian", Index = "ChatC17_6" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC18_1" },
					{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC18_2" },
					{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC18_3" },
					{ SpeakerIndex = "EldGuardCaptainShutian", Index = "ChatC18_4" },
					{ SpeakerIndex = "EldGuardCaptainShutian", Index = "ChatC18_5" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldItemMctKenton", Index = "ChatC19_1" },
					{ SpeakerIndex = "EldItemMctKenton", Index = "ChatC19_2" },
					{ SpeakerIndex = "RouGaianMaria", Index = "ChatC19_3" },
					{ SpeakerIndex = "RouGaianMaria", Index = "ChatC19_4" },
					{ SpeakerIndex = "RouGaianMaria", Index = "ChatC19_5" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldItemMctKenton", Index = "ChatC20_1" },
					{ SpeakerIndex = "EldItemMctKenton", Index = "ChatC20_2" },
					{ SpeakerIndex = "RouGaianMaria", Index = "ChatC20_3" },
					{ SpeakerIndex = "RouGaianMaria", Index = "ChatC20_4" },
					{ SpeakerIndex = "RouGaianMaria", Index = "ChatC20_5" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC24_1" },
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC24_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldScoSkillDeikid", Index = "ChatC25_1" },
					{ SpeakerIndex = "EldScoSkillDeikid", Index = "ChatC25_1" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC29_1" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldArcGuard01", Index = "ChatC30_1" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "KQ_G_Marlone", Index = "ChatC31_1" },
					{ SpeakerIndex = "KQ_G_Marlone", Index = "ChatC31_2" },
					{ SpeakerIndex = "RouSkillRubi", Index = "ChatC31_3" },
					{ SpeakerIndex = "RouSkillRubi", Index = "ChatC31_4" },
				},

				After =
				{
					{ SpeakerIndex = "KQ_G_Marlone",     Index = "ChatC31_5" },
					{ SpeakerIndex = "KQ_G_Marlone",     Index = "ChatC31_6" },
					{ SpeakerIndex = "UruItemMctVellon", Index = "ChatC31_7" },
					{ SpeakerIndex = "UruItemMctVellon", Index = "ChatC31_8" },
				},
			},
			---------------------------------------------------------------------
			---------------------------------------------------------------------
		},

		Pattern_KillBoss =
		{
			-- 9,10,11,12,13,14,15,16,-,26,
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC9_1" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC9_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldGuardNus", Index = "ChatC10_1" },
					{ SpeakerIndex = "EldGuardNus", Index = "ChatC10_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "RouSkillRubi", Index = "ChatC11_1" },
					{ SpeakerIndex = "RouSkillRubi", Index = "ChatC11_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "UruGuildLump", Index = "ChatC12_1" },
					{ SpeakerIndex = "UruGuildLump", Index = "ChatC12_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "UruSmithHans", Index = "ChatC13_1" },
					{ SpeakerIndex = "UruSmithHans", Index = "ChatC13_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "UruStoreCurly", Index = "ChatC14_1" },
					{ SpeakerIndex = "UruStoreCurly", Index = "ChatC14_2" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "UruTownChiefAdrien", Index = "ChatC15_1" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldFurnitureForestTall", Index = "ChatC16_1" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC26_1" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC26_2" },
				},
			},
			---------------------------------------------------------------------
			---------------------------------------------------------------------
		},


		-- 몹 상자를 열때 나타나는 몹 그룹
		Pattern_OnlyOneIsKey =
		{
			-- 27,28,32
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC27_1" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC27_2" },
				},

				OpenKey =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC27_4" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC27_5" },
				},

				OpenMob =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC27_3" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "RouDiggerPalmers", Index = "ChatC28_1" },
					{ SpeakerIndex = "RouDiggerPalmers", Index = "ChatC28_2" },
				},

				OpenKey =
				{
					{ SpeakerIndex = "RouDiggerPalmers", Index = "ChatC28_4" },
					{ SpeakerIndex = "RouDiggerPalmers", Index = "ChatC28_5" },
				},

				OpenMob =
				{
					{ SpeakerIndex = "RouDiggerPalmers", Index = "ChatC28_3" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC35_1" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC35_2" },
				},

				OpenKey =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC35_4" },
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC35_5" },
				},

				OpenMob =
				{
					{ SpeakerIndex = "EldWarSkillMarty", Index = "ChatC35_3" },
				},
			},
			---------------------------------------------------------------------
			---------------------------------------------------------------------
		},

		Pattern_KamarisTrap =
		{
			-- 21,22,23
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC21_1" },
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC21_2" },
				},

				AppearMob =
				{
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC21_3" },
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC21_4" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC22_1" },
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC22_2" },
				},

				AppearMob =
				{
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC22_3" },
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC22_4" },
				},
			},
			---------------------------------------------------------------------
			{
				Before =
				{
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC23_1" },
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC23_2" },
				},

				AppearMob =
				{
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC23_3" },
					{ SpeakerIndex = "RouTownChiefRoumenus", Index = "ChatC23_4" },
				},
			},
			---------------------------------------------------------------------
			---------------------------------------------------------------------
		},

--[[
		Pattern_TrapPrisonType =
		{
			-- 33 번 패턴 : 기존 PS Script에서 구현이 되다 만 패턴이고 실제 적용 되지도 않은 패턴이므로 루아버전에서는 넣지 않는다.
			nil,
		},
--]]


	},


	BossBattle =
	{
		Boss1 =
		{
			SummonDialog =
			{
				HP750 = { SpeakerIndex = "RouSkillRubi", Index = "ChatC32_8" },
				HP500 = { SpeakerIndex = "RouSkillRubi", Index = "ChatC32_8" },
				HP250 = { SpeakerIndex = "RouSkillRubi", Index = "ChatC32_8" },
			},


			InitDialog =
			{
				{ SpeakerIndex = "RouSkillRubi", Index = "ChatC32_1" },
				{ SpeakerIndex = "RouSkillRubi", Index = "ChatC32_2" },
				{ SpeakerIndex = "RouSkillRubi", Index = "ChatC32_3" },
			},

			ReInitDialog =
			{
				{ SpeakerIndex = "Iyzel", Index = "ChatC32_6" },
				{ SpeakerIndex = "Iyzel", Index = "ChatC32_7" },
			},


			ShutDoorDialog =
			{
				{ SpeakerIndex = "RouSkillRubi", Index = "ChatC32_4" },
			},

			ShutDoorNotice =
			{
				{ SpeakerIndex = nil, Index = "ChatC32_5" },
			},


			ClearNotice =
			{
				{ SpeakerIndex = nil, Index = "ChatC32_9" },
			},

			ClearDialog =
			{
				{ SpeakerIndex = "RouSkillRubi", Index = "ChatC32_10" },
				{ SpeakerIndex = "RouSkillRubi", Index = "ChatC32_11" },
			},
		},

		Boss2 =
		{
			SummonDialog =
			{
				HP750 = { SpeakerIndex = "UruGuildLump", Index = "ChatC33_9" },
				HP500 = { SpeakerIndex = "UruGuildLump", Index = "ChatC33_9" },
				HP250 = { SpeakerIndex = "UruGuildLump", Index = "ChatC33_9" },
			},


			InitDialog =
			{
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_1" },
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_2" },
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_3" },
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_4" },
			},

			ReInitDialog =
			{
				{ SpeakerIndex = "Iyzel", Index = "ChatC33_7" },
				{ SpeakerIndex = "Iyzel", Index = "ChatC33_8" },
			},


			ShutDoorDialog =
			{
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_5" },
			},

			ShutDoorNotice =
			{
				{ SpeakerIndex = nil, Index = "ChatC33_6" },
			},


			ClearNotice =
			{
				{ SpeakerIndex = nil, Index = "ChatC33_10" },
			},

			ClearDialog =
			{
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_11" },
				{ SpeakerIndex = "UruGuildLump", Index = "ChatC33_12" },
			},
		},

		Boss3 =
		{
			SummonDialog =
			{
				HP750 = { SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_9"  },
				HP500 = { SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_9"  },
				HP250 = { SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_9"  },
				HP200 = { SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_25" },
				HP150 = { SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_10" },
			},


			InitDialog =
			{
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_1" },
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_2" },
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_3" },
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_4" },
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_5" },
			},

			ReInitDialog =
			{
				{ SpeakerIndex = "Iyzel", Index = "ChatC34_7" },
				{ SpeakerIndex = "Iyzel", Index = "ChatC34_8" },
			},


			ShutDoorDialog =
			{
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_6" },
			},

			ShutDoorNotice =
			{
				{ SpeakerIndex = nil, Index = "ChatC34_24" },
			},


			ClearNotice =
			{
				{ SpeakerIndex = nil, Index = "ChatC34_11" },
			},

			ClearDialog =
			{
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_12" },
				{ SpeakerIndex = "EldCastleLordElderiss", Index = "ChatC34_13" },
			},
		},
	},


	IyzelReward =
	{
		SpeakerIndex = "Iyzel",

		Boss1 =
		{
			IyzelAppearDialog =
			{
				{ Index = "ChatC32_12" },
				{ Index = "ChatC32_13" },
				{ Index = "ChatC32_14" },
			},

			OpenBoxTimeOverDialog =
			{
				{ Index = "ChatC32_16" },
				{ Index = "ChatC32_17" },
				{ Index = "ChatC32_18" },
				{ Index = "ChatC32_19" },
			},
		},

		Boss2 =
		{
			IyzelAppearDialog =
			{
				{ Index = "ChatC33_13" },
				{ Index = "ChatC33_14" },
				{ Index = "ChatC33_15" },
			},

			OpenBoxTimeOverDialog =
			{
				{ Index = "ChatC33_17" },
				{ Index = "ChatC33_18" },
				{ Index = "ChatC33_19" },
				{ Index = "ChatC33_20" },
				{ Index = "ChatC33_21" },
			},
		},

		Boss3 =
		{
			IyzelAppearDialog =
			{
				{ Index = "ChatC34_21" },
				{ Index = "ChatC34_22" },
				{ Index = "ChatC34_23" },
			},

			OpenBoxTimeOverDialog =
			{
				{ Index = "ChatC34_14" },
				{ Index = "ChatC34_15" },
				{ Index = "ChatC34_16" },
				{ Index = "ChatC34_17" },
				{ Index = "ChatC34_18" },
				{ Index = "ChatC34_19" },
			},
		},

		-- Prestring 에는 해당 보물(아이템)을 발견한 캐릭터 이름을 넣어 공지한다.
		FoundTreasureNotice = { String = " has found the treasure!", },
	},

}
