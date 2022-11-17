;*****************************************
;* This is file macro.cnc version V4.02.00
;* It is automatically loaded
;* Customize this file yourself if you like
;* It contains:
;* - subroutine change_tool this is called on M6T..
;* - subroutine home_x .. home_z, called when home functions in GUI are activated
;* - subroutine home_all, called when home all button in GUI are activated
;* - subroutine user_1 .. user_11, called when user functions are activated
;*   user_1 contains an example of zeroing Z using a moveable tool setter
;*   user_2 contains an example of measuring the tool length using a fixed tool setter
;*
;* You may also add frequently used macro's in this file.
;****************************************


;User functions, F1..F11 in user menu

;Zero tool tip example
Sub user_1
    msg "user_1, Zero Z (G92) using toolsetter"
    (Start probe move, slow)
    f30
    g38.2 z-200
    (Move back to touch point)
    g0 z#5063
    (Set position, the measuring device is 43mm in height, adapt for your measuring device)
    G92 z43
    (move 5 mm above measuring device)
    g91 (incremental distance mode)
    g0 z5
    g90 (absolute distance mode)
Endsub

;Tool length measurement example
Sub user_2
    goSub m_tool ;See sub m_tool
Endsub

;############################################
;#### BEGIN SHOPFLOOR PROGRAMMER #######
;############################################

sub SHOPFLOOR_HEADER
LogMsg ";-------------------------------------------------------------------------------"
LogMsg "; www.saarloos.net  |  Eding-CNC Shopfloor programmer "
LogMsg "; v0.2.2"
		; Minor bugfixes:
		; Square contour coordinates changed to sizes instead. Overshootcompensation was calculated wrong.
		; Added brackets to variables conform interpreter needs.
		; Stepover Helix lead in changed to half the radius from centerpoint. 
		; v0.2.1
		; Stepover changed in percentage: 1 = 100%  0.5 = 50%
		; Circular drilling starting point moved from Y axis to X axis.
		; Toolcompensation was not read but filled by the number entered.
		; New features:
		; Tapping and machine warm-up.
LogMsg ";-------------------------------------------------------------------------------"
Endsub

Sub user_3
#1064=0
    gosub SHOPFLOOR_HEADERS
Endsub
Sub user_4
    gosub SHOPFLOOR_FLATTEN
Endsub
Sub user_5
    gosub SHOPFLOOR_SQUARECONTOUR
Endsub
Sub user_6
    gosub SHOPFLOOR_ROUNDCONTOUR
Endsub
Sub user_7
    gosub SHOPFLOOR_SQUAREPOCKET
Endsub
Sub user_8
    gosub SHOPFLOOR_ROUNDPOCKET
Endsub
Sub user_9
    gosub SHOPFLOOR_SLOTTING
Endsub
Sub user_10
    gosub SHOPFLOOR_PARTPROGRAM
Endsub
Sub user_11
    gosub SHOPFLOOR_DRILLING
Endsub
Sub user_12
    gosub SHOPFLOOR_CIRCULAR_DRILLING
Endsub
Sub user_13
    gosub SHOPFLOOR_TAPPING
Endsub
Sub user_20
    gosub WARM_UP
Endsub

;#### DIALOG SUBS ########

sub SHOPFLOOR_PARTPROGRAM
#1064=1
DLGMSG "Shopfloor new program" "1=YES 0=NO" 1063
	GOSUB DLGCHECK
	if [#1063==1]
		LOGFILE _shopfloor_part.cnc 0
		LOGFILE _shopfloor_part.cnc 1
		gosub SHOPFLOOR_HEADER
	ENDIF
	#1063=0
	if [#1060==1]
		GOSUB SHOPFLOOR_HEADERS
	ENDIF
	if [#1060==2]
		GOSUB SHOPFLOOR_FLATTEN
	ENDIF
	if [#1060==3]
		GOSUB SHOPFLOOR_SQUARECONTOUR
	ENDIF
	if [#1060==4]
		GOSUB SHOPFLOOR_ROUNDCONTOUR
	ENDIF
	if [#1060==5]
		GOSUB SHOPFLOOR_SQUAREPOCKET
	ENDIF
	if [#1060==6]
		GOSUB SHOPFLOOR_ROUNDPOCKET
	ENDIF
	if [#1060==7]
		GOSUB SHOPFLOOR_SLOTTING
	ENDIF
	if [#1060==8]
		GOSUB SHOPFLOOR_DRILLING
	ENDIF
	if [#1060==9]
		GOSUB SHOPFLOOR_CIRCULAR_DRILLING
	ENDIF
	if [#1060==10]
		GOSUB SHOPFLOOR_TAPPING
	ENDIF
	if [#1060<1]
	DLGMSG "NO CYCLE SPECIFIED"
	ENDIF
	#1064=0
EndSub	

sub SHOPFLOOR_HEADERS
	#1060=1
	DlgMsg "shopfloor Header" "Select" 4001 
	GOSUB DLGCHECK
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Headers)"
		LOGMSG "	#1100=1			(CYCLE INDEX)"
		LOGMSG "	#4001=" [#4001] "	(Header)"
		LOGMSG "M99"
		GoSub FileEnd
	endif
EndSub	
	
sub SHOPFLOOR_FLATTEN
	#1060=2
	dlgmsg "shopfloor Flatten" "X start" 4101 "Y start" 4102 "X size" 4111 "Y size" 4112 "Z start" 4103 "Z end" 4113 "Stepover" 4105 "Z Increment" 4106 "Tool" 4114 "Speed" 4116 "Flood" 4117 "Mist" 4118 "Feed" 4104 "Safe Z" 4107
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Flatten)"
		LOGMSG "	#1100=2			(CYCLE INDEX)"
		LOGMSG "	#4101=" [#4101] "	(X start)"
		LOGMSG "	#4102=" [#4102] "	(Y start)"
		LOGMSG "	#4111=" [#4111] "	(X size)"
		LOGMSG "	#4112=" [#4112] "	(Y size)"
		LOGMSG "	#4105=" [#4105] "	(Stepover)"
		LOGMSG "	#4103=" [#4103] "	(Z start)"
		LOGMSG "	#4113=" [#4113] "	(Z end)"
		LOGMSG "	#4106=" [#4106] "	(Z Increment)"
		LOGMSG "	#4114=" [#4114] "	(Tool)"
		LOGMSG "	#4116=" [#4116] "	(Speed)"
		LOGMSG "	#4117=" [#4117] "	(Flood)"
		LOGMSG "	#4118=" [#4118] "	(Mist)"
		LOGMSG "	#4104=" [#4104] "	(Feed)"
		LOGMSG "	#4107=" [#4107] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
endsub 

sub SHOPFLOOR_SQUARECONTOUR
	#1060=3
	dlgmsg "shopfloor SQUARECONTOUR" "X start" 4201 "Y start" 4202 "X size" 4211 "Y size" 4212 "Z start" 4203 "Z end" 4213 "Z Increment" 4206 "Tool" 4214 "Outside" 4215 "Speed" 4216 "Flood" 4217 "Mist" 4218 "Feed" 4204 "Safe Z" 4207
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Square Contour)"
		LOGMSG "	#1100=3			(CYCLE INDEX)"
		LOGMSG "	#4201=" [#4201] "	(X start)"
		LOGMSG "	#4202=" [#4202] "	(Y start)"
		LOGMSG "	#4211=" [#4211] "	(X size)"
		LOGMSG "	#4212=" [#4212] "	(Y Size)"
		LOGMSG "	#4203=" [#4203] "	(Z start)"
		LOGMSG "	#4213=" [#4213] "	(Z end)"
		LOGMSG "	#4206=" [#4206] "	(Z Increment)"
		LOGMSG "	#4214=" [#4214] "	(Tool)"
		LOGMSG "	#4215=" [#4215] "	(Outside)"
		LOGMSG "	#4216=" [#4216] "	(Speed)"
		LOGMSG "	#4217=" [#4217] "	(Flood)"
		LOGMSG "	#4218=" [#4218] "	(Mist)"
		LOGMSG "	#4204=" [#4204] "	(Feed)"
		LOGMSG "	#4207=" [#4207] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
EndSub

sub SHOPFLOOR_ROUNDCONTOUR
	#1060=4
	dlgmsg "shopfloor ROUNDCONTOUR" "Diameter " 4305 "X center" 4311 "Y center" 4312 "Z start" 4303 "Z end" 4313 "Z Increment " 4306 "Tool" 4314 "CW_Outside" 4315 "Speed" 4316 "Flood" 4317 "Mist" 4318 "Feed" 4304 "Safe Z " 4307 ;#/# values
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Round Contour)"
		LOGMSG "	#1100=4			(CYCLE INDEX)"
		LOGMSG "	#4305=" [#4305] "	(diameter)"
		LOGMSG "	#4311=" [#4311] "	(X center)"
		LOGMSG "	#4312=" [#4312] "	(Y center)"
		LOGMSG "	#4303=" [#4303] "	(Z start)"
		LOGMSG "	#4313=" [#4313] "	(Z end)"
		LOGMSG "	#4306=" [#4306] "	(Z Increment)"
		LOGMSG "	#4314=" [#4314] "	(Tool)"
		LOGMSG "	#4315=" [#4315] "	(Outside)"
		LOGMSG "	#4316=" [#4316] "	(Speed)"
		LOGMSG "	#4317=" [#4317] "	(Flood)"
		LOGMSG "	#4318=" [#4318] "	(Mist)"
		LOGMSG "	#4304=" [#4304] "	(Feed)"
		LOGMSG "	#4307=" [#4307] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
EndSub

sub SHOPFLOOR_SQUAREPOCKET
	#1060=5
	dlgmsg "shopfloor SQUAREPOCKET" "X start" 4411 "Y start" 4412 "X size" 4401 "Y size" 4402 "Tool" 4414 "Feed" 4404 "Stepover" 4405 "Z start" 4403 "Z end" 4413 "Z increment" 4406 "Z feed" 4420 "Z lead in increment" 4419 
	dlgmsg "shopfloor SQUAREPOCKET" "Speed" 4416 "Flood" 4417 "Mist" 4418 "Safe Z" 4407
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Square Pocket)"
		LOGMSG "	#1100=5			(CYCLE INDEX)"
		LOGMSG "	#4411=" [#4411] "	(X start)"
		LOGMSG "	#4412=" [#4412] "	(Y start)"
		LOGMSG "	#4401=" [#4401] "	(X Size)"
		LOGMSG "	#4402=" [#4402] "	(Y Size)"
		LOGMSG "	#4403=" [#4403] "	(Z Start)"
		LOGMSG "	#4413=" [#4413] "	(Z End)"
		LOGMSG "	#4406=" [#4406] "	(Z Increment)"
		LOGMSG "	#4405=" [#4405] "	(Stepover)"
		LOGMSG "	#4414=" [#4414] "	(Tool)"
		LOGMSG "	#4416=" [#4416] "	(Speed)"
		LOGMSG "	#4417=" [#4417] "	(Flood)"
		LOGMSG "	#4418=" [#4418] "	(Mist)"
		LOGMSG "	#4404=" [#4404] "	(Feed)"
		LOGMSG "	#4407=" [#4407] "	(Safe Z)"
		LOGMSG "	#4419=" [#4419] "	(Z lead in increment)"
		LOGMSG "	#4420=" [#4420] "	(Z feed)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd	
	Endif
endsub

sub SHOPFLOOR_ROUNDPOCKET
	#1060=6
	dlgmsg "shopfloor ROUNDPOCKET" "Diameter" 4501 "X center" 4511 "Y center" 4512 "Z Start" 4503 "Z End" 4513 "Feed" 4504 "Stepover" 4505 "Z Increment" 4506 "Z lead in increment" 4519 "Z feed" 4520 "Tool" 4514 "Speed" 4516 "Flood" 4517 "Mist" 4518 "Safe Z" 4507
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Round Pocket"
		LOGMSG "	#1100=6			(CYCLE INDEX)"
		LOGMSG "	#4501=" [#4501] "	(diameter)"
		LOGMSG "	#4511=" [#4511] "	(X center)"
		LOGMSG "	#4512=" [#4512] "	(Y center)"
		LOGMSG "	#4503=" [#4503] "	(Z start)"
		LOGMSG "	#4513=" [#4513] "	(Z end)"
		LOGMSG "	#4506=" [#4506] "	(Z Increment)"
		LOGMSG "	#4505=" [#4505] "	(Stepover)"
		LOGMSG "	#4514=" [#4514] "	(Tool)"
		LOGMSG "	#4516=" [#4516] "	(Speed)"
		LOGMSG "	#4517=" [#4517] "	(Flood)"
		LOGMSG "	#4518=" [#4518] "	(Mist)"
		LOGMSG "	#4504=" [#4504] "	(Feed)"
		LOGMSG "	#4519=" [#4519] "	(Z lead in increment)"
		LOGMSG "	#4520=" [#4520] "	(Z feed)"
		LOGMSG "	#4507=" [#4507] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
endsub

sub SHOPFLOOR_SLOTTING
	#1060=7
	dlgmsg "shopfloor SLOTTING" "X center" 4611 "Y center" 4612 "X size" 4601 "Y size" 4602 "Z start" 4603 "Z end" 4613 "Z Increment" 4606 "Tool" 4614 "Speed" 4616 "Flood" 4617 "Mist" 4618 "Feed" 4604 "Safe Z" 4607
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Slotting"
		LOGMSG "	#1100=7			(CYCLE INDEX)"
		LOGMSG "	#4611=" [#4611] "	(X center)"
		LOGMSG "	#4612=" [#4612] "	(Y center)"
		LOGMSG "	#4601=" [#4601] "	(X size)"
		LOGMSG "	#4602=" [#4602] "	(Y size)"
		LOGMSG "	#4603=" [#4603] "	(Z start)"
		LOGMSG "	#4613=" [#4613] "	(Z end)"
		LOGMSG "	#4606=" [#4606] "	(Z Increment)"
		LOGMSG "	#4614=" [#4614] "	(Tool)"
		LOGMSG "	#4616=" [#4616] "	(Speed)"
		LOGMSG "	#4617=" [#4617] "	(Flood)"
		LOGMSG "	#4618=" [#4618] "	(Mist)"
		LOGMSG "	#4604=" [#4604] "	(Feed)"
		LOGMSG "	#4607=" [#4607] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
endsub

sub SHOPFLOOR_DRILLING
	#1060=8
	Dlgmsg "shopfloor DRILLING" "X" 4711 "Y" 4712 "Z start" 4703 "Z end" 4713  "Retract (R)" 4702 "Peck increment (Q)" 4706 "Tool" 4714 "Speed" 4716 "Flood" 4717 "Mist" 4718 "Feed" 4704 "Safe Z" 4707
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION drilling"
		LOGMSG "	#1100=8			(CYCLE INDEX)"
		LOGMSG "	#4711=" [#4711] "	(X center)"
		LOGMSG "	#4712=" [#4712] "	(Y center)"
		LOGMSG "	#4701=" [#4701] "	(Diameter)"
		LOGMSG "	#4702=" [#4702] "	(Retract R)"
		LOGMSG "	#4703=" [#4703] "	(Z start)"
		LOGMSG "	#4713=" [#4713] "	(Z end)"
		LOGMSG "	#4706=" [#4706] "	(IPeck Increment Q)"
		LOGMSG "	#4714=" [#4714] "	(Tool)"
		LOGMSG "	#4716=" [#4716] "	(Speed)"
		LOGMSG "	#4717=" [#4717] "	(Flood)"
		LOGMSG "	#4718=" [#4718] "	(Mist)"
		LOGMSG "	#4704=" [#4704] "	(Feed)"
		LOGMSG "	#4707=" [#4707] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
endsub

sub SHOPFLOOR_CIRCULAR_DRILLING
	#1060=9
	dlgmsg "shopfloor CIRCULAR DRILLING" "X center" 4811 "Y center" 4812 "Diameter" 4801 "No. of holes" 4802 "Start degrees" 4805 "Z start" 4803 "Z end" 4813 "Peck increment (Q)" 4806 "Retract (R)" 4819 "Tool" 4814 "Speed" 4816 "Flood" 4817 "Mist" 4818 "Feed" 4804 "Safe Z" 4807
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Circular drilling)"
		LOGMSG "	#1100=9			(CYCLE INDEX)"
		LOGMSG "	#4811=" [#4811] "	(X center)"
		LOGMSG "	#4812=" [#4812] "	(Y center)"
		LOGMSG "	#4801=" [#4801] "	(Diameter)"
		LOGMSG "	#4802=" [#4802] "	(Number of holes)"
		LOGMSG "	#4805=" [#4805] "	(Startposition degrees)"
		LOGMSG "	#4803=" [#4803] "	(Z start)"
		LOGMSG "	#4813=" [#4813] "	(Z end)"
		LOGMSG "	#4806=" [#4806] "	(Peck increment (Q)"
		LOGMSG "	#4819=" [#4819] "	(Retract (R)"
		LOGMSG "	#4814=" [#4814] "	(Tool)"
		LOGMSG "	#4816=" [#4816] "	(Speed)"
		LOGMSG "	#4817=" [#4817] "	(Flood)"
		LOGMSG "	#4818=" [#4818] "	(Mist)"
		LOGMSG "	#4804=" [#4804] "	(Feed)"
		LOGMSG "	#4807=" [#4807] "	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
endsub

sub SHOPFLOOR_TAPPING
	#1060=10
	Dlgmsg "shopfloor Tapping" "X" 4761 "Y" 4762 "Z start" 4753 "Z end" 4763  "Lead" 4752 "Retract" 4769  "Tool" 4764 "Speed" 4766 "Flood" 4767 "Mist" 4768 "Safe Z" 4757
	if [#5398 == 1]
		if [#1064==1]
			LOGFILE _shopfloor_part.cnc 1
		else
			GOSUB FileNew
			LOGFILE _shopfloor_teach.cnc 1
		endif
		LOGMSG "(CYCLE DEFINITION Tapping"
		LOGMSG "	#1100=10		(CYCLE INDEX)"
		LOGMSG "	#4761=" [#4761] "	(X center)"
		LOGMSG "	#4762=" [#4762] "	(Y center)"
		LOGMSG "	#4752=" [#4752] "	(Lead)"
		LOGMSG "	#4769=" [#4769] "	(Retract)"
		LOGMSG "	#4753=" [#4753] "	(Z start)"
		LOGMSG "	#4763=" [#4763] "	(Z end)"
		LOGMSG "	#4764=" [#4764] "	(Tool)"
		LOGMSG "	#4766=" [#4766] "	(Speed)"
		LOGMSG "	#4767=" [#4767] "	(Flood)"
		LOGMSG "	#4768=" [#4768] "	(Mist)"
		LOGMSG "	#4757=" [#4757]"	(Safe Z)"
		LOGMSG "(END CYCLE)"
		LOGMSG "M99"
		GoSub FileEnd
	Endif
endsub

;#### CODE BASE SUBS ########

sub SHOPFLOOR_HEADERS_CODE
	msg "Selection: " [#4001] 
	if [#4001 == 1]
		;########## Header XY plane, Cancel cutter comp, mm mode, Absolute distance, Work preset 1
		G17 G40 G21 G90 G54
		M5 M9 M27 M90
	endif
	if [#4001 == 2]
		
	endif
	if [#4001 == 3]
	
	endif
	if [#4001 == 4]
	
	endif
	if [#4001 == 5]
	
	endif
	if [#4001 == 6]
	
	endif
	if [#4001 == 7]
	
	endif
	if [#4001 == 8]
		;########## Cyclus end
		M5 M9
	endif
	if [#4001 == 9]
		;########## Program end stop spindle, coolant, G28 and reset
		M5 M9 G28
		M30
	endif
EndSub

sub SHOPFLOOR_FLATTEN_CODE
	#3015 = #[5500+#4114]	;tool comp
	#3070 = [#3015*#4105]	;stepover value
	#3015 = [#3015/2]	;half diameter
	#3008 = [#4101]	;reset x increment
	#3009 = [#4102-#3015+#3070 ]	;reset y increment
	#3018 = [#4103]	;reset z increment
	#3001 = [#4111]	;X size
	#3002 = [#4112]	;y size
	#3028 = [#4303]	;reset z increment
	#3029 = [#4303]	;reset z half increment
	#3048 = 0	; reset counter max range
	#3049 = 0	;reset counter safe z quick move
	if [#4111>#4112]
		#3047 = [#4112 ]
	else
		#3047 = [#4111]
	endif
	M6 T[#4114] 
	if [#4117<>0]
		M8
	Endif
	if [#4118<>0]
		M7
	Endif
	M3 S[#4116]
	while [#3018>#4113]
		G0 Z[#4107]	;safe Z
		G0 X[#4101-#3015] Y[#3009]	; startposition xy
		G1 F[#4104] Z[#4103]	; startposition z
		#3018 = [#3018-#4106] 	; Z increment
		if [#3018<#4113]	; Z overshoot compensation
			#3018 = [#4113]
		endif
		G1 F[#4104] Z[#3018]
		while [[#4102+#4112]>#3009]
			G1 X[#4101+#4111]
			#3009 = [#3009+#3070]
			if [[#4102+#4112]>#3009]
				G3 Y[#3009] R[ #3070/2]
				G1 X[#4101]
			endif
			#3009 = [#3009+#3070]
			if [[#4102+#4112]>#3009]
				G2 Y[#3009] R[ #3070/2]
			endif
		endwhile
		G0 Z[#4107]	;safe Z
		#3009 = [#4102-#3015+#3070 ]	;reset y increment
	endwhile
	G0 Z[#4107]	;safe Z
Endsub

sub SHOPFLOOR_SQUARECONTOUR_CODE

	#3018 = [#4203]	;reset z increment
	#3001 = [#4211]	;X size
	#3002 = [#4212]	;Y size
	#3003 = [[#3001 *2]+[#3002*2]]	;total length toolpath
	#3004 = [#4206/#3003]	;Z lead in calculation
	#3011 = [#3004*#3001]	;Z lead in X
	#3012 = [#3004*#3002]	;Z lead in Y
	#3028 = [#4303]	;reset z increment
	#3029 = [#4303]	;reset z half increment
	if [#4215 == 1]	;calulate tool number for dia comp
		#3015 = -#[5500+#4214]	;outside comp
		#3015 = [#3015/2]
	else
		#3015 = #[5500+#4214]	;inside comp
		#3015 = [#3015/2]
	endif
	M6 T[#4214] 
	if [#4217<>0]
		M8
	Endif
	if [#4218<>0]
		M7
	Endif
	M3 S[#4216]	;Spindle on
	G0 Z[#4207]	;safe Z
	G0 X[#4201+#3015] Y[#4202+#3015]	; startposition xy outside
	G1 F[#4204] Z[#4203]	; startposition z
	while [#3018>#4213]	; loop to Z target
		if [#4213<>0]	; Z single pass (Z0)?
			if [#3018 >= #4213]	; Ztarget reached?
				G1 F[#4204]
				if [#4215 == 1]	; inside 
					#3018 = [#3018-#3012]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 Y[#4202+#4212-#3015] Z[#3018]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					#3018 = [#3018-#3011]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 X[#4201+#4211-#3015] Z[#3018] 
					#3018 = [#3018-#3012]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 Y[#4202+#3015] Z[#3018]
					#3018 = [#3018-#3011]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 X[#4201+#3015] Z[#3018] 
				else ;outside
					#3018 = [#3018-#3012]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 X[#4201+#4211-#3015] Z[#3018]
					#3018 = [#3018-#3011]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 Y[#4202+#4212-#3015] Z[#3018] 
					#3018 = [#3018-#3012]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 X[#4201+#3015] Z[#3018] 
					#3018 = [#3018-#3011]
					if [#3018<#4213]
						#3018 = [#4213]
					endif
					G1 Y[#4202+#3015] Z[#3018] 
				endif
			endif
		else
			#3018 = [#3018-1]
		endif
	endwhile
	G1 Z[#4213]
	;  finalize cyclus
	if [#4215 == 1]	; outside?
		G1 Y[#4202+#4212-#3015]
		G1 X[#4201+#4211-#3015]
		G1 Y[#4202+#3015] 
		G1 X[#4201+#3015]
	else
		G1 X[#4201+#4211-#3015]
		G1 Y[#4202+#4212-#3015]
		G1 X[#4201+#3015] 
		G1 Y[#4202+#3015]
	endif
	G0 Z[#4207]	;safe Z
endsub

sub SHOPFLOOR_ROUNDCONTOUR_CODE
	if [#4315 == 1]	;calulate tool number for dia comp
		#3015 = #[5500+#4314];outside comp
		#3015 = [#3015/2]
	else
		#3015 = -#[5500+#4314]	;inside comp
		#3015 = [#3015/2]
	endif
	#3028 = [#4303]	;reset z increment
	#3029 = [#4303]	;reset z half increment
	#3025 = [#4311-[#4305/2]-#3015]	;negative circle start
	#3026 = [#4311+[#4305/2]+#3015]	;positive circle start
	#3027 = [[#4305 /2]+#3015]	;radius
	M6 T[#4314] 
	if [#4317<>0]
		M8
	Endif
	if [#4318<>0]
		M7
	Endif
	M3 S[#4316]
	G0 Z[#4307]	;safe Z
	G0 X #3026 Y[#4312]	; startposition xy
	G1 F[#4304] Z[#4303]	; startposition z
	while [#3028>#4313]	; loop to Z target
		if [#4313<>0]	; Z single pass (Z0)?
			if [#3028 >= #4313]	; Ztarget reached?
				#3028 = [#3028-#4306]	; Z increment
				G0 X[#3026] Y[#4312]
				if [#3028<#4313]	; z overshoot?
					#3028 = [#4313]
					#3029 = [#3028+[#4306/2]]
					if [#4315 == 1]	; outside
						G2 X[#3025] Y[#4312] R[#3027] Z[#3029]
						G2 X[#3026] Y[#4312] R[#3027] Z[#3028]
					else ;inside
						G3 X[#3025] Y[#4312] R[#3027] Z[#3029]
						G3 X[#3026] Y[#4312] R[#3027] Z[#3028]
					endif
					#3028 = [#3028 -1]
				endif
				if [#3028 >= #4313]	; Z normal
					#3029 = [#3028+[#4306/2]]
					if [#4315 == 1]	;outside
						G2 X[#3025] Y[#4312] R[#3027] Z[#3029]
						G2 X[#3026] Y[#4312] R[#3027] Z[#3028]
					else ;inside
						G3 X[#3025] Y[#4312] R[#3027] Z[#3029]
						G3 X[#3026] Y[#4312] R[#3027] Z[#3028]
					endif
				endif
			endif
		else
			#3028 = [#3028 -1]
		endif
	endwhile
	;finalize cyclus
	if [#4315 == 1]	;outside
		G2 X[#3025] Y[#4312] R[#3027] Z[#4313]
		G2 X[#3026] Y[#4312] R[#3027] 
	else ;inside
		G3 X[#3025] Y[#4312] R[#3027] Z[#4313]
		G3 X[#3026] Y[#4312] R[#3027] 
		endif
	G0 Z[#4307]	;safe Z
endsub

sub SHOPFLOOR_SQUAREPOCKET_CODE
	#3015 = #[5500+#4414]	;Tool size
	#3070 = [#3015*#4405]	;stepover value
	#3015 = [#3015/2]	;radius
	#3068 = [#4403]	;reset z increment
	#3039 = 0	;reset stepover
	#3041 = [#4401-[2*#3015]]	;toolcomp X
	#3042 = [#4402-[2*#3015]]	;toolcomp Y
	#3043 = [#4411+#3015]	; start pos X
	#3044 = [#4412+#3015]	; start pos Y
	#3031 = [#3041/2]	; half X
	#3032 = [#3042/2]	; half Y
	#3033 = [#3041/2]	;X neg
	#3034 = [#3041/2]	;X pos
	#3035 = [#3042/2]	;Y neg
	#3036 = [#3042/2]	;Y pos
	#3048 = 0	; reset counter max range
	#3049 = 0	;reset counter safe z quick move
	;maxsize?
	if [#3041>#3042]
		#3047 = [#3041/2]
	else
		#3047 = [#3042/2]
	endif
	M6 T[#4414] 
	if [#4417<>0]
		M8
	Endif
	if [#4418<>0]
		M7
	Endif
	M3 S[#4416]
	G0 Z[#4407]	;safe Z
	G0 X[#3031+#3043] Y[#3032+#3044]	;startposition xy
	G1 Z[#4403] F[#4404]	;startposition z
	while [#3068>#4413]	;loop to Z target
		if [#3068 >= #4413]	;ztarget reached?
			#3040 = [#3068]
			if [#3068<#4413]	;z overshoot?
				#3068 = [#4413]
			endif
			if [#3068 >= #4413]	;z normal
				#3040 = [#3068]
				#3068 = [#3068-#4406]	;z increment
				if [#3068<#4413]	;z overshoot?
					#3068 = [#4413]
				endif
				#3806 = [#3031+#3043]	;centerpoint x
				#3804 = [#4420]	;feed 
				#3805 = [#4419]	;lead)
				#3808= [#3070/2]	;stepover leadin
				Gosub HELIX_LEAD_IN
				G1 X[#3031+#3043] F[#4404] 
			endif
		endif
		;reset center vars
		#3033 = [[#3041/2]]	;X pos
		#3034 = [[#3041/2]]	;X neg
		#3035 = [[#3042/2]]	;Y pos
		#3036 = [[#3042/2]]	;Y neg
		while [#3048 <= #3047]
			; XYcyclus
			#3048 = [#3048+#3070]; add stepover
			if [#3033 >= 0]
				#3033 = [#3033-#3070]	;X neg
				if [#3033<0]
				#3033 = 0
				endif
			endif
			if [#3034 <= #3041]
				#3034 = [#3034+#3070]	;X pos
				if [#3034>#3041]
				#3034 = [#3041]
				endif
			endif
			if [#3035 >= 0 ]
				#3035 = [#3035-#3070]	;Y neg
				if [#3035<0]
				#3035 = 0
				endif
			endif
			if [#3036 <= #3042]
				#3036 = [#3036+#3070]	;Y pos
				if [#3036>#3042]
				#3036 = [#3042]
				endif
			endif
			if [#3036<>[#3042/2]]
				G1 Y[#3036+#3044] F[#4404]	;move Y positive stepover start
			else
				G1 Y[#3036+#3044+#3015] F[#4404]	;move Y positive stepover
			endif
			G1 X[#3033+#3043] F[#4404]	;move X  neg
			G1 Y[#3035+#3044]		;move Y neg
			G1 X[#3034+#3043]		;move X pos
			G1 Y[#3036+#3044]		;move Y pos
			G1 X[#3031+#3043]		;move X center
		endwhile
		G1 X[#3031+#3043] Y[#3032+#3044]	; startposition xy
		#3048 = 0	; reset counter max range
	endwhile
	G0 Z[#4407]	;safe Z
endsub

sub SHOPFLOOR_ROUNDPOCKET_CODE
	#3015 = #[5500+#4514]	;Tool size
	#3070 = [#3015*#4505]	;stepover value
	#3015 = [#3015/2]	;radius
	#3068 = [#4503]	;reset z increment
	#3069 = 0	;reset stepover
	#3078 = 0	;counter diameter
	#3079 = 0	;reset counter safe z quick move
	M6 T[#4514] 
	if [#4517<>0]
		M8
	Endif
	if [#4518<>0]
		M7
	Endif
	M3 S[#4516]	;Spindle on
	G0 Z[#4507]	;safe Z
	G0 X[#4511] Y[#4512]	; startposition xy
	G1 F[#4520] Z[#4503]	; startposition z
	while [#3068>#4513]	; loop to Z target
		if [#3068 >= #4513]	; Ztarget reached?
			#3040 = [#3068]
			#3068 = [#3068-#4506]	; Z increment
			if [#3068<#4513]	; z overshoot?
				#3068 = [#4513]
			endif
			#3806 = [#4511]	(centerpoint x)
			#3804 = [#4520]	(feed) 
			#3805 = [#4519]	(lead) 
			#3808 = [#3070/2]	;stepover leadin
			Gosub HELIX_LEAD_IN
		endif
		#3905 = [#4501/2]	;convert to radius
		#3810 = [#3905-#3015]	;max radius size
		#3803 = [#3070]	;stepover value
		#3814 = [#3808]	;stepover counter
		#3816 = [#4511+#3803]	;start radius
		if [#3803>#3810] 
			#3816 = [#4511+#3810]
			#3803 = [#3810]
		ENDIF
			G03 X[#4511-#3808] Y[#4512] Z[#3068] R[#3808] F[#4520]
			G03 X[#4511+#3808] Y[#4512] R[#3808] F[#4504]
			G03 X[#4511-#3808] Y[#4512] R[#3808] F[#4504]
		#3814 = [#3814+#3803] 
		#3815 = [#3808]
		WHILE [#3814<#3810]	;max radius?
			#3816 = [#3814]
			G03 X[#4511+#3816] Y[#4512] R[[#3816+#3815]/2] F[#4504]
			G03 X[#4511-#3816] Y[#4512] R[#3816] F[#4504]
			#3815 = [#3816]
			#3814 = [#3814+#3803] 
		ENDWHILE
		#3816 = [#3810] 
		G03 X[#4511+#3816] Y[#4512] R[[#3816+#3815]/2] F[#4504]
		G03 X[#4511-#3816] Y[#4512] R[#3816] F[#4504]
		#3815 = [#3816] 
		G03 X[#4511+#3810] Y[#4512] R[#3810]	;leadout
		G03 X[#4511] Y[#4512] R[#3810/2] 
		#3078 = 0 ; reset counter
		G0 X[#4511] Y[#4512]	; startposition xy
	endwhile
	G0 Z[#4507]	;safe Z
endsub

sub SHOPFLOOR_SLOTTING_CODE
	#3015 = #[5500+#4614]	;Tool size
	#3015 = [#3015/2]	;radius
	#3088 = [#4603]	;reset z increment
	#3081 = [#4601/2]	; half x
	#3082 = [#4602/2]	; half y
	#3083 = [#3081-#3082]	;comp h
	#3084 = [#3082-#3081]	;comp v
	#3095 = [#4611-#3081]	;left
	#3096 = [#4611+#3081]	;right
	#3097 = [#4612-#3082]	;bottom
	#3098 = [#4612+#3082]	;top
	; Total length per pass:  #3003
	; Z lead-in G1:  #3011
	; Z lead-in R:  #3012
	M6 T[#4614]
	if [#4617<>0]
		M8 ;Flood coolant on
	Endif
	if [#4618<>0]
		M7 ;Mist on
	Endif
	M3 S[#4616]	;Spindle on
	G0 Z[#4607]	;safe Z
	if [#4601>#4602]
		; Shape is horizontal shaped slot
		G0 X[#3095+#3082] Y[#3097+#3015]	; startposition xy ;x wider horizontal
		#3003 = [[[[#3096-#3082]-[#3095+#3082]]*2]+[[#3082-#3015]*3.14159265359*2]];total length
		#3004 = [#4606/#3003]	;Z lead in calculation
		#3011 = [[[#3096-#3082]-[#3095+#3082]] *#3004]	;Z lead in X
		#3012 = [[[#3082-#3015]*3.14159265359]*#3004]	;Z lead in radius 
	else
		; Shape is vertical shaped slot
		G0 X[#3096-#3015] Y[#3097+#3081]	; startposition xy ;y wider vertical
		#3003 = [[[[#3098-#3081]-[#3097+#3081]]*2]+[[#3081-#3015]*3.14159265359*2]];total length
		#3004 = [#4606/#3003]	;Z lead in calculation
		#3011 = [[[#3098-#3081]-[#3097+#3081]] *#3004]	;Z lead in Y
		#3012 = [[[#3081-#3015]*3.14159265359]*#3004]	;Z lead in radius 
	endif
	G0 X[#3095+#3082] Y[#3097+#3015]
	G1 F[#4604] Z[#4603]	; startposition z
	while [#3088>#4613]	; loop to Z target
		if [#4613<>0]	; Z single pass (Z0)?
			if [#3088 >= #4613]	; Ztarget reached?
				if [#3088<[#4613+#4606]]	; z overshoot?
					;overshoot pass
					#3088 = [#4613+#4606]
					if [#4601>#4602]
						; single pass cyclus horizontal
						;G1 Z #3088
						;G1 X[#3095+#3082] Y[#3097+#3015]
						G1 X[#3096-#3082] Z[#3088-#3011]
						G3 X[#3096-#3082] Y[#3098-#3015] Z[#3088-#3011-#3012] R[#3082-#3015]
						G1 X[#3095+#3082] Z[#3088-#3011-#3012-#3011]
						G3 X[#3095+#3082] Y[#3097+#3015] Z[#3088-#3011-#3012-#3011-#3012] R[#3082-#3015]
					else
						; single pass cyclus vertical
						;G1 X[#3096-#3015] Y[#3097+#3081]
						G1 Y[#3098-#3081] Z[#3088-#3011]
						G3 X[#3095+#3015] Y[#3098-#3081] Z[#3088-#3011-#3012] R[#3081-#3015]
						G1 Y[#3097+#3081] Z[#3088-#3011-#3012-#3011]
						G3 X[#3096-#3015] Y[#3097+#3081] Z[#3088-#3011-#3012-#3011-#3012] R[#3081-#3015]
					endif
					#3088 = [#3088-#4601-1]
				endif
				if [#3088 >= #4613]	; Z normal
					if [#4601>#4602]
					; single pass cyclus horizontal
						G1 X[#3096-#3082] Z[#3088-#3011]
						G3 X[#3096-#3082] Y[#3098-#3015] Z[#3088-#3011-#3012] R[#3082-#3015]
						G1 X[#3095+#3082] Z[#3088-#3011-#3012-#3011]
						G3 X[#3095+#3082] Y[#3097+#3015] Z[#3088-#3011-#3012-#3011-#3012] R[#3082-#3015]
					else
						; single pass cyclus vertical
						G1 Y[#3098-#3081] Z[#3088-#3011]
						G3 X[#3095+#3015] Y[#3098-#3081] Z[#3088-#3011-#3012] R[#3081-#3015]
						G1 Y[#3097+#3081] Z[#3088-#3011-#3012-#3011]
						G3 X[#3096-#3015] Y[#3097+#3081] Z[#3088-#3011-#3012-#3011-#3012] R[#3081-#3015]
					endif
					#3088 = [#3088-#4606]	; Z increment
				endif
			endif
		else
			#3088 = [#3088 -1]
		endif
	endwhile
	if [#4601>#4602]
		; finalize cyclus horizontal
		G1 Z[#4613]
		G1 X[#3096-#3082]
		G3 X[#3096-#3082] Y[#3098-#3015] R[#3082-#3015]
		G1 X[#3095+#3082]
		G3 X[#3095+#3082] Y[#3097+#3015] R[#3082-#3015]
	else
		; finalize cyclus vertical
		G1 Y[#3098-#3081]
		G3 X[#3095+#3015] Y[#3098-#3081] R[#3081-#3015]
		G1 Y[#3097+#3081]
		G3 X[#3096-#3015] Y[#3097+#3081] R[#3081-#3015]
	endif
	G0 X[#4611] Y[#4612] Z[#4607]	;safe Z
endsub

Sub SHOPFLOOR_DRILLING_CODE
	M6 T[#4714] 
	if [#4717<>0]
		M8
	Endif
	if [#4718<>0]
		M7
	Endif
	M3 S[#4716]
	G0 Z[#4707]	;safe Z
	G0 x[#4711] y[#4712]
	G0 Z[#4703]	; fast startposition z
	g83 z[#4713] F[#4704] R[#4702] Q[#4706]	;drill cycle
	G80
Endsub

Sub SHOPFLOOR_CIRCULAR_DRILLING_CODE
	M6 T[#4814] 
	if [#4817<>0]
		M8
	Endif
	if [#4818<>0]
		M7
	Endif
	M3 S[#4816]
	G0 Z[#4807]	;safe Z
	G0 x[#4811] y[#4812]
	#4=[-#4805]	; start postion comp
	#1=[0-#4]
	while [#1<[360-#4]]
		#2 = [[[#4801/2]*sin[#1]]+#4812]
		#3 = [[[#4801/2]*cos[#1]]+#4811]
		g0 x[#3] y[#2]	;locate
		G1 Z[#4803] F[#4804]	; fast startposition z
		g83 z[#4813] F[#4804] R[#4818] Q[#4806]	;drill cycle
		g0 z[#4807]	; safe Z
		#1 = [#1+[360/#4802]]	;next hole
	endwhile
	G80
Endsub

Sub SHOPFLOOR_TAPPING_CODE
	M6 T[#4764] 
	if [#4767<>0]
		M8
	Endif
	if [#4768<>0]
		M7
	Endif
	M3 S[#4766]
	G0 Z[#4757]	;safe Z
	G0 x[#4761] y[#4762]
	G0 Z[#4769]
	F[#4752]
	g84 z[#4763] R[#4769]	;tap cycle
	G80
Endsub

SUB WARM_UP
	Dlgmsg "shopfloor WARMUP" 
	if [#5398 == 1]
		GoSub home_all
		M6 T0
		TCAGuard off
		G53 G0 Z#5113	;Move Z up
		M3 S1000
		G53 G0 X#5101 Y#5102	;Move negative
		G53 G0 X#5111 Y#5112	;Move positive
		G53 G0 Z#5103		;Move Z down
		G53 G0 Z#5113		;Move Z up
		G53 G0 X#5081 Y#5082	;Move XY home
		TCAGuard on
		G4 P60
		S2000
		G4 P300
		S4000
		G4 P300
		M5
		GoSub home_all
		M30
	Endif
ENDSUB

;#### SPECIAL M CODES ########

SUB M99 ;OPERATION
	if [#1100==1]
		GOSUB SHOPFLOOR_HEADERS_CODE
	ENDIF
	if [#1100==2]
		GOSUB SHOPFLOOR_FLATTEN_CODE
	ENDIF
	if [#1100==3]
		GOSUB SHOPFLOOR_SQUARECONTOUR_CODE
	ENDIF
	if [#1100==4]
		GOSUB SHOPFLOOR_ROUNDCONTOUR_CODE
	ENDIF
	if [#1100==5]
		GOSUB SHOPFLOOR_SQUAREPOCKET_CODE
	ENDIF
	if [#1100==6]
		GOSUB SHOPFLOOR_ROUNDPOCKET_CODE
	ENDIF
	if [#1100==7]
		GOSUB SHOPFLOOR_SLOTTING_CODE
	ENDIF
	if [#1100==8]
		GOSUB SHOPFLOOR_DRILLING_CODE
	ENDIF
	if [#1100==9]
		GOSUB SHOPFLOOR_CIRCULAR_DRILLING_CODE
	ENDIF
	if [#1100==10]
		GOSUB SHOPFLOOR_TAPPING_CODE
	ENDIF
ENDSUB

SUB HELIX_LEAD_IN
	G1 X[#3806+#3808] F[#3804]
	while [#3040>#3068]	; loop to Z SubTargettarget
		if [#3040 >= #3068]	; ZSubTarget reached?
			if [#3040>#3068] 
			#3040 = [#3040-#3805/2]	; ZLeadin increment
				if [#3040<#3068] 
				#3040 = [#3068]
				endif
			endif
			G3 X[#3806-#3808] Z[#3040] R[#3808]
			if [#3040>#3068] 
			#3040 = [#3040-#3805/2]	; ZLeadin increment
				if [#3040<#3068] 
				#3040 = [#3068]
				endif
			endif
			G3 X[#3806+#3808] Z[#3040] R[#3808]
		endif
	endwhile
	#3807 = [#3806+#3808]; end pass location
Endsub

SUB DLGCHECK
	if [#5398 <1]
		MSG "USER CANCELLED OPERATION!"
		#1064=0
		M2
	ENDIF
ENDSUB

SUB FileNew
LOGFILE "_shopfloor_teach.cnc" 0
gosub SHOPFLOOR_HEADER
ENDSUB

SUB FileEnd
	if [#1064==0]
		LOGMSG "M2"
	ENDIF
ENDSUB

;############################################
;#### END  SHOPFLOOR PROGRAMMER ########
;############################################

;Homing per axis
Sub home_x
    home x
    ;;if A is slave of X uncomment next lines and comment previous line
    ;homeTandem X
Endsub

Sub home_y
    home y
Endsub

Sub home_z
    home z
Endsub

Sub home_a
    home a
Endsub

Sub home_b
    home b
Endsub

Sub home_c
    home c
Endsub

;Home all axes, uncomment or comment the axes you want.
sub home_all
    gosub home_z
    gosub home_y
    gosub home_x
    gosub home_a
    gosub home_b
    gosub home_c
    msg "Home complete"
endsub

Sub zero_set_rotation
    msg "move to first point, press control-G to continue"
    m0
    #5020 = #5071 ;x1
    #5021 = #5072 ;y1
    msg "move to second point, press control-G to continue"
    m0
    #5022 = #5071 ;x2
    #5023 = #5072 ;y2
    #5024 = ATAN[#5023 - #5021]/[#5022 - #5020]
    if [#5024 > 45]
      #5024 = [#5024 - 90] ;points are in Y direction
    endif
    g68 R#5024
    msg "G68 R"#5024" applied, now zero XYZ normally"
Endsub

;This example shows how to make your own tool_changer work.
;It is made for 6 tools
;First current tool is dropped, then the new tool is picked
;There is a check whether selected tool is already in the spindle
;Also a check that the tool is within 1-6
;There is a picktool subroutine for each tool and a droptool subroutine for each tool.
;These routines need to be modified to fit your machine and tool changer

sub change_tool
    ;Switch off guard for tool change area collision
    TCAGuard off 

    ;Check ZHeight comp and switch off when on, remember the state in #5019
    ;#5151 indicates that ZHeight comp is on    
    #5019 = #5151
    if [#5019 == 1]
        ZHC off
    endif
    
   ;Switch off spindle
    m5

    ;Use #5015 to indicate succesfull toolchange
    #5015 = 0 ; Tool change not performed

    ; check tool in spindle and exit sub
    If [ [#5011] <> [#5008] ]
        if [[#5011] > 6 ]
            errmsg "Please select a tool from 1 to 6." 
        else
            ;Drop current tool
            If [[#5008] == 0] 
                GoSub DropTool0
            endif
            If [[#5008] == 1] 
                GoSub DropTool1
            endif
            If [[#5008] == 2] 
                GoSub DropTool2
            endif
            If [[#5008] == 3] 
                GoSub DropTool3
            endif
            If [[#5008] == 4] 
                GoSub DropTool4
            endif
            If [[#5008] == 5] 
                GoSub DropTool5
            endif
            If [[#5008] == 6] 
                GoSub DropTool6
            endif
            
            ;Pick new tool
            if [[#5011] == 0]
                GoSub PickTool0
            endif
            if [[#5011] == 1]
                GoSub PickTool1
            endif
            if [[#5011] == 2]
                GoSub PickTool2
            endif
            if [[#5011] == 3]
                GoSub PickTool3
            endif
            if [[#5011] == 4]
                GoSub PickTool4
            endif
            if [[#5011] == 5]
                GoSub PickTool5
            endif
            if [[#5011] == 6]
                GoSub PickTool6
            endif

        endif
    else
        msg "Tool already in spindle"
        #5015 = 1 ;indicate tool change performed
    endif    
                
    If [[#5015] == 1]   
        msg "Tool "#5008" Replaced by tool "#5011" G43 switched on"
        m6t[#5011]

        if [#5011 <> 0]
            G43  ;we use tool-length compensation.
        else
            G49  ;tool length compensation off for tool 0.
        endif
    else
        errmsg "tool change failed"
    endif
        
    ;Set default motion type to G1   
    g1
    
    ;Switch on guard for tool change area collision
    TCAGuard on
    
    ;Check if ZHeight comp was on before and switch ON again if it was.
    if [#5019 == 1]
        ZHC on
    endif
        
EndSub      
     


;Drop tool subroutines
Sub DropTool0
    ;Tool 0 is nothing, we could open the tool 
    ;magazine here if needed for the following PickTool
    msg "Dropping tool 0"
endsub

Sub DropTool1
    msg "Dropping tool 1"
endsub

Sub DropTool2
    msg "Dropping tool 2"
endsub

Sub DropTool3
    msg "Dropping tool 3"
endsub

Sub DropTool4
    msg "Dropping tool 4"
endsub

Sub DropTool5
    msg "Dropping tool 5"
endsub

Sub DropTool6
    msg "Dropping tool 6"
endsub



;Pick tool subroutines
Sub PickTool0
    msg "Picking tool 0"
    ;Tool 0 is nothing, so we just close the 
    ;tool magazine here if needed.
    #5015 = 1 ; toolchange succes
endsub

Sub PickTool1
    msg "Picking tool 1"
    #5015 = 1 ; toolchange succes
endsub

Sub PickTool2
    msg "Picking tool 2"
    #5015 = 1 ; Tool change succes
endsub

Sub PickTool3
    msg "Picking tool 3"
    #5015 = 1 ; Tool change succes
endsub

Sub PickTool4
    msg "Picking tool 4"
    #5015 = 1 ; Tool change succes
endsub

Sub PickTool5
    msg "Picking tool 5"
    #5015 = 1 ; toolchange succes
endsub

Sub PickTool6
    msg "Picking tool 6"
    #5015 = 1 ; Tool change succes
endsub



Sub calibrate_tool_setter
    warnmsg "close MDI, check correct calibr. tool nr 99 in tool table, press ctrl-g"
    warnmsg "jog to toolchange safe height, when done press ctrl-g"
    #4996=#5073 ;Store toolchange safe height machine coordinates
    warnmsg "insert cal. tool 99 len="#5499", jog above tool setter, press ctrl-g"
    ;store x y in non volatile parameters (4000 - 4999)
    #4997=#5071 ;machine pos X
    #4998=#5072 ;machine pos Y
    ;Determine minimum toochuck height and store into #4999
    g38.2 g91 z-20 f30
    #4999=[#5053 - #5499] ;probepos Z - calibration tool length = toolchuck height
    g90
    g0 g53 z#4996
    msg "calib. done safe height="#4996 " X="#4997 " Y="#4998 " Chuck height="#4999
endSub

sub m_tool
    if [[#5380==0] and [#5397==0]] ;do this only when not simulating and not rendering
        ;Check if toolsetter is calibrated
        if [[#4996 == 0] and [#4997 == 0] and [#4998 == 0] and [#4999 == 0]]
            errmsg "calibrate first, MDI: gosub calibrate_tool_setter"
        else
            g0 g53 z#4996 ; move to safe z
            dlgmsg "enter tool dimensions" "tool number" 5016 "approx tool length" 5017 "tool diameter" 5018
            ;Check user pressed OK
            if [#5398 == 1] 
                if [[#5016 < 1] OR [#5016 > 99]]
                    ErrMsg "Tool must be in range of 0 .. 99"
                endif
        
                ;move to toolsetter coordinates
                g00 g53 x#4997 y#4998 
                ;move to 10mm above chuck height + approx tool length + 10
                g00 g53 z[#4999+10+#5017]
                ;measure tool length and pull 5mm back up
                g38.2 g91 z-20 f30
                g90
                ;back to safe height
                g0 g53 z#4996
                ;Store tool length, diameter in tool table
                ;but only if actually measured, 
                ;so leave tool table as is while rendering 
                if [#5397 == 0]
                    #[5400 + #5016] = [#5053-#4999]
                    #[5500 + #5016] = #5018
                    #[5600 + #5016] = 0 ;Tool X offset is 0
                    msg "tool length measured="#[5400 + #5016]" stored at tool "#5016
			    endif
            endif
        endif
    endif
endsub



sub zhcmgrid
;;;;;;;;;;;;;
;probe scanning routine for eneven surface milling
;scanning starts at x=0, y=0

  if [#4100 == 0]
   #4100 = 10  ;nx
   #4101 = 5   ;ny
   #4102 = 40  ;max z 
   #4103 = 10  ;min z 
   #4104 = 1.0 ;step size
   #4105 = 100 ;probing feed
  endif    

  #110 = 0    ;Actual nx
  #111 = 0    ;Actual ny
  #112 = 0    ;Missed measurements counter
  #113 = 0    ;Number of points added
  #114 = 1    ;0: odd x row, 1: even xrow

  ;Dialog
  dlgmsg "gridMeas" "nx" 4100 "ny" 4101 "maxZ" 4102 "minZ" 4103 "gridSize" 4104 "Feed" 4105 
    
  if [#5398 == 1] ; user pressed OK
    ;Move to startpoint
    g0 z[#4102];to upper Z
    g0 x0 y0 ;to start point
        
    ;ZHCINIT gridSize nx ny
    ZHCINIT [#4104] [#4100] [#4101] 
    
    #111 = 0    ;Actual ny value
    while [#111 < #4101]
        if [#114 == 1]
          ;even x row, go from 0 to nx
          #110 = 0 ;start nx
          while [#110 < #4100]
            ;Go up, goto xy, measure
            g0 z[#4102];to upper Z
            g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
            g38.2 F[#4105] z[#4103];probe down until touch
                    
            ;Add point to internal table if probe has touched
            if [#5067 == 1]
              ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" added"
              #113 = [#113+1]
            else
              ;ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" not added"
              #112 = [#112+1]
            endif

            #110 = [#110 + 1] ;next nx
          endwhile
          #114=0
        else
          ;odd x row, go from nx to 0
          #110 = [#4100 - 1] ;start nx
          while [#110 > -1]
            ;Go up, goto xy, measure
            g0 z[#4102];to upper Z
            g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
            g38.2 F[#4105] z[#4103];probe down until touch
                    
            ;Add point to internal table if probe has touched
            if [#5067 == 1]
              ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" added"
              #113 = [#113+1]
            else
              ;ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" not added"
              #112 = [#112+1]
            endif

            #110 = [#110 - 1] ;next nx
          endwhile
          #114=1
        endif
	  
      #111 = [#111 + 1] ;next ny
    endwhile
        
    g0 z[#4102];to upper Z
    ;Save measured table
    ZHCS zHeightCompTable.txt
    msg "Done, "#113" points added, "#112" not added" 
        
  else
    ;user pressed cancel in dialog
    msg "Operation canceled"
  endif
endsub

;Remove comments if you want additional reset actions
;when reset button was pressed in UI
;sub user_reset
;    msg "Ready for operation"
;endsub 
