require( "ID/WarLH/WarLHData" )


function EVNET_NO1_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO1_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO2_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO2_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO3_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO3_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO4_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO4_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO5_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO5_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO6_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO6_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO7_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO7_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO8_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO8_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO9_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO9_DEINIT_FUNC" )

	EventMemory["EM_STATE"]									= EM_STATE["Start"]

end

function EVNET_NO10_DEINIT_FUNC( EventMemory )
cExecCheck( "EVNET_NO10_DEINIT_FUNC" )

	InstanceDungeonClear( EventMemory["MapIndex"] )
	GATE_MAP_INDEX = nil

end



EVENT_DEINIT_FUNC = { }


EVENT_DEINIT_FUNC[1] = EVNET_NO1_DEINIT_FUNC
EVENT_DEINIT_FUNC[2] = EVNET_NO2_DEINIT_FUNC
EVENT_DEINIT_FUNC[3] = EVNET_NO3_DEINIT_FUNC
EVENT_DEINIT_FUNC[4] = EVNET_NO4_DEINIT_FUNC
EVENT_DEINIT_FUNC[5] = EVNET_NO5_DEINIT_FUNC
EVENT_DEINIT_FUNC[6] = EVNET_NO6_DEINIT_FUNC
EVENT_DEINIT_FUNC[7] = EVNET_NO7_DEINIT_FUNC
EVENT_DEINIT_FUNC[8] = EVNET_NO8_DEINIT_FUNC
EVENT_DEINIT_FUNC[9] = EVNET_NO9_DEINIT_FUNC
EVENT_DEINIT_FUNC[10] = EVNET_NO10_DEINIT_FUNC
