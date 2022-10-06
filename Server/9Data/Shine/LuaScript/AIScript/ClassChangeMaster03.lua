require( "common" )

gIsInit 	= false		-- 초기화 되었나? ㄴㄴ
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function ClassChangeMaster03( Handle, MapIndex )
cExecCheck( "ClassChangeMaster03" )


	-- 이벤트 초기화
	if gIsInit == false
	then

		-- AISctipt Function 설정
		cAIScriptFunc( Handle, "NPCClick", "ClassChangeMaster03_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "ClassChangeMaster03_Menu"  )

		gIsInit = true;

	end

end


function ClassChangeMaster03_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "ClassChangeMaster03_Click" )

	-- 다이얼로그 메뉴 출력
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function ClassChangeMaster03_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "ClassChangeMaster03_Menu" )

	-- 클래스 변경? ㅇㅇ
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
