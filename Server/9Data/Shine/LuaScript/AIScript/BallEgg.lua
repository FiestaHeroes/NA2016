require( "common" )


-- ��ų ������
SKILL_DAMAGE		= 1000


function BallEgg( Handle, MapIndex )
cExecCheck( "BallEgg" )

	cStaticDamage_smo( Handle, SKILL_DAMAGE )
	cSetServantFlag( Handle, "MobCanDamageTo", 1 )
	cAIScriptSet( Handle )


	return ReturnAI["END"]

end
