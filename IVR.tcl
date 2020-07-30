#######################################################
# Cisco IVR TCL script by SiD v.3
#######################################################
#
#	Для дебага скрипта
#		debug voip application script
#	Более полный дебага (не рекомендуется, может привести к перегрузке)
# 		debug voip ivr
# 
# Скрипт должен быть запущен со следующими параметрами:
# 	param allowed_pattern 5[5-7]..
# 	param fastto_reception 1
# 	param reception_number 5501
#	param fastto_ckp 2
# 	param ckp_number 5604
# 	param fastto_fax 3
# 	param fax_number 5555
# 	param waiting_time 20
# 	param max_try 3
# 	param file_welcome flash:en_welcome.au
# 	param file_takenumber flash:en_takenumber.au
# 	param file_after flash:en_after.au
# 	param file_busy flash:en_busy.au
# 	param file_noexist flash:en_noexist.au
# 	param file_noanswer flash:en_noanswer.au
# 	param file_onhold flash:music-on-hold.au
#	param file_noworking flash:music-on-hold.au

proc init { } {
    puts "\n proc Init start"
    global param
}

proc init_perCallVars { } {
	global pattern
	global numbers
	global playng_files

	if {[infotag get cfg_avpair_exists allowed_pattern]} {
		set pattern(1) [string trim [infotag get cfg_avpair allowed_pattern]]
		puts "\n\n IVR - Allowed pattern set as: $pattern(1) \n\n"
		} else {
			set pattern(1) ....
			puts "\n\n IVR - Allowed pattern set as DEFAULT: $pattern(1) \n\n"
			}	

	if {[infotag get cfg_avpair_exists reception_number]} {
		set numbers(reception) [string trim [infotag get cfg_avpair reception_number]]
		puts "\n\n IVR - reception number set as: $numbers(reception) \n\n"
		} else {			
			set numbers(reception) 0000
			puts "\n\n IVR - reception number set as DEFAULT: $numbers(reception) \n\n"
			}	

	if {[infotag get cfg_avpair_exists ckp_number]} {
		set numbers(ckp) [string trim [infotag get cfg_avpair ckp_number]]
		puts "\n\n IVR - ckp number set as: $numbers(ckp) \n\n"
		} else {			
			set numbers(ckp) 0000
			puts "\n\n IVR - ckp number set as DEFAULT: $numbers(ckp) \n\n"
			}

	if {[infotag get cfg_avpair_exists fax_number]} {
		set numbers(fax) [string trim [infotag get cfg_avpair fax_number]]
		puts "\n\n IVR - fax number set as: $numbers(fax) \n\n"
		} else {			
			set numbers(fax) 0000
			puts "\n\n IVR - fax number set as DEFAULT: $numbers(fax) \n\n"
			}			

	if {[infotag get cfg_avpair_exists fastto_reception]} {
		set numbers(fast_reception) [string trim [infotag get cfg_avpair fastto_reception]]
		puts "\n\n IVR - fast to reception set as: $numbers(fast_reception) \n\n"
		} else {			
			set numbers(fast_reception) 1
			puts "\n\n IVR - fast to reception set as DEFAULT: $numbers(fast_reception) \n\n"
			}

	if {[infotag get cfg_avpair_exists fastto_ckp]} {
		set numbers(fast_ckp) [string trim [infotag get cfg_avpair fastto_ckp]]
		puts "\n\n IVR - fast to ckp set as: $numbers(fast_ckp) \n\n"
		} else {			
			set numbers(fast_ckp) 2
			puts "\n\n IVR - fast to ckp set as DEFAULT: $numbers(fast_ckp) \n\n"
			}

	if {[infotag get cfg_avpair_exists fastto_fax]} {
		set numbers(fast_fax) [string trim [infotag get cfg_avpair fastto_fax]]
		puts "\n\n IVR - fast to fax set as: $numbers(fast_fax) \n\n"
		} else {			
			set numbers(fast_fax) 3
			puts "\n\n IVR - fast to fax set as DEFAULT: $numbers(fast_fax) \n\n"
			}

	if {[infotag get cfg_avpair_exists waiting_time]} {
		set numbers(waiting_time) [string trim [infotag get cfg_avpair waiting_time]]
		puts "\n\n IVR - wait number set as: $numbers(waiting_time) \n\n"
		} else {			
			set numbers(waiting_time) 10
			puts "\n\n IVR - wait number set as DEFAULT: $numbers(waiting_time) \n\n"
			}

	if {[infotag get cfg_avpair_exists max_try]} {
		set numbers(max_try) [string trim [infotag get cfg_avpair max_try]]
		puts "\n\n IVR - max try set as: $numbers(max_try) \n\n"
		set numbers(cur_try) 0
		} else {			
			set numbers(max_try) 5
			puts "\n\n IVR - max try set as DEFAULT: $numbers(max_try) \n\n"
			set numbers(cur_try) 0
			}

	if {[infotag get cfg_avpair_exists file_welcome]} {
		set playng_files(welcome) [string trim [infotag get cfg_avpair file_welcome]]
		puts "\n\n IVR - file_welcome set as: $playng_files(welcome) \n\n"
		} else {
			set playng_files(welcome) %s1
			puts "\n\n IVR - file_welcome set as DEFAULT: $playng_files(welcome) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_takenumber]} {
		set playng_files(takenumber) [string trim [infotag get cfg_avpair file_takenumber]]
		puts "\n\n IVR - file_takenumber set as: $playng_files(takenumber) \n\n"
		} else {
			set playng_files(takenumber) %s1
			puts "\n\n IVR - file_takenumber set as DEFAULT: $playng_files(takenumber) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_after]} {
		set playng_files(callafter) [string trim [infotag get cfg_avpair file_after]]
		puts "\n\n IVR - file_after set as: $playng_files(callafter) \n\n"
		} else {
			set playng_files(callafter) %s1
			puts "\n\n IVR - file_after set as DEFAULT: $playng_files(callafter) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_busy]} {
		set playng_files(busy) [string trim [infotag get cfg_avpair file_busy]]
		puts "\n\n IVR - file_busy set as: $playng_files(busy) \n\n"
		} else {
			set playng_files(busy) %s1
			puts "\n\n IVR - file_busy set as DEFAULT: $playng_files(busy) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_noexist]} {
		set playng_files(noexist) [string trim [infotag get cfg_avpair file_noexist]]
		puts "\n\n IVR - file_noexist set as: $playng_files(noexist) \n\n"
		} else {
			set playng_files(noexist) %s1
			puts "\n\n IVR - file_noexist set as DEFAULT: $playng_files(noexist) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_toreception]} {
		set playng_files(toreception) [string trim [infotag get cfg_avpair file_toreception]]
		puts "\n\n IVR - file_toreception set as: $playng_files(toreception) \n\n"
		} else {
			set playng_files(toreception) %s1
			puts "\n\n IVR - file_toreception set as DEFAULT: $playng_files(toreception) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_noanswer]} {
		set playng_files(noanswer) [string trim [infotag get cfg_avpair file_noanswer]]
		puts "\n\n IVR - file_noanswer set as: $playng_files(noanswer) \n\n"
		} else {
			set playng_files(noanswer) %s1
			puts "\n\n IVR - file_noanswer set as DEFAULT: $playng_files(noanswer) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_onhold]} {
		set playng_files(onhold) [string trim [infotag get cfg_avpair file_onhold]]
		puts "\n\n IVR - file_onhold set as: $playng_files(onhold) \n\n"
		} else {
			set playng_files(onhold) %s1
			puts "\n\n IVR - file_onhold set as DEFAULT: $playng_files(onhold) \n\n"
			}

	if {[infotag get cfg_avpair_exists file_noworking]} {
		set playng_files(noworking) [string trim [infotag get cfg_avpair file_noworking]]
		puts "\n\n IVR - file_noworking set as: $playng_files(noworking) \n\n"
		} else {
			set playng_files(noworking) %s1
			puts "\n\n IVR - file_noworking set as DEFAULT: $playng_files(noworking) \n\n"
			}
}

proc GetDate { } {
	global workingtime
	set houris [clock format [clock seconds] -format %H]
	set dayis [clock format [clock seconds] -format %A]
	if {$houris > 17 || $houris < 8 || $dayis=="Sunday" || $dayis=="Saturday"} {
	set workingtime 0
	} else {
	set workingtime 1
	}
}

proc Play_Welcome { } {
    puts "\n\n IVR - proc Play_Welcome start \n\n"
	global playng_files
	global param
	global pattern
	global numbers
	global workingtime
	
	init_perCallVars
	GetDate

	if {$workingtime} {
	set after_welcome $playng_files(takenumber)	
	} else {
	set after_welcome $playng_files(noworking)
	}
	set param(interruptPrompt) true
	set param(abortKey) *
	set param(terminationKey) #	
	
    leg setupack leg_incoming
    leg proceeding leg_incoming
    leg connect leg_incoming
	leg collectdigits leg_incoming param pattern
    media play leg_incoming %s500 $playng_files(welcome) $after_welcome $playng_files(onhold)
	timer start named_timer $numbers(waiting_time) t1
}

proc Play_TakeNumber { } {
    puts "\n\n IVR - proc Play_TakeNumber start \n\n"
	global playng_files
	global numbers
	global param
	global pattern
	
	if {$numbers(cur_try) <= $numbers(max_try)} {
	puts "\n\n IVR - proc Play_TakeNumber current try is: $numbers(cur_try) \n\n"
	incr numbers(cur_try)

	leg collectdigits leg_incoming param pattern
	media play leg_incoming $playng_files(takenumber)
	timer start named_timer $numbers(waiting_time) t1
	
	} else { 
		fsm setstate CALLDISCONNECTED
		media play leg_incoming $playng_files(callafter)	
	}
}

proc GoToReception { } {
	puts "\n\n IVR - proc GoToReception start \n\n"
	global numbers
	media stop leg_incoming
	fsm setstate CALLCONNECTED
	
	set digit $numbers(reception)
	
	CheckCallersAndConnect $digit
}

proc CheckDestanation { } {
    puts "\n\n IVR - proc CheckDestanation start \n\n"
	global playng_files
	global numbers
	global digit
	media stop leg_incoming
	
    set status [infotag get evt_status]
	set digit [infotag get evt_dcdigits]
	
	if {$digit == $numbers(fast_reception)} {
		puts "\n\n IVR - proc CheckDestanation digit = $digit\nGoing to next reception \n\n"
		fsm setstate CALLCONNECTED
		set digit $numbers(reception)
		CheckCallersAndConnect $digit
		
	} elseif {$digit == $numbers(fast_ckp)} {
		puts "\n\n IVR - proc CheckDestanation digit = $digit\nGoing to next CKP \n\n"
		fsm setstate CALLCONNECTED
		set digit $numbers(ckp)
		CheckCallersAndConnect $digit

	} elseif {$digit == $numbers(fast_fax)} {
		puts "\n\n IVR - proc CheckDestanation digit = $digit\nGoing to next fax \n\n"
		fsm setstate CALLCONNECTED
		set digit $numbers(fax)
		CheckCallersAndConnect $digit

	} elseif {$status == "cd_004"} {
		puts "\n\n IVR - proc CheckDestanation status = $status digit = $digit \n\n"
		fsm setstate CALLCONNECTED
		CheckCallersAndConnect $digit

	} elseif {$status == "cd_005"} {
		puts "\n\n IVR - proc CheckDestanation status = $status digit = $digit \n\n"
		fsm setstate CALLCONNECTED	
		CheckCallersAndConnect $digit	

	} elseif {$status == "cd_006"} {
		puts "\n\n IVR - proc CheckDestanation status = $status digit = $digit \n\n"
		fsm setstate TRYAGAIN
		media play leg_incoming $playng_files(noexist)

	} else {
		fsm setstate TORECEPTION
		media play leg_incoming $playng_files(toreception)		
		puts "\n\n IVR - proc CheckDestanation status = $status \n\n"
	}	
}

proc CheckCallersAndConnect {digit} {
	puts "\n\n IVR - proc CheckCallersAndConnect start \n\n"
	
	set callernumber [infotag get leg_ani]
	
	 switch $callernumber {
	 "9120000000" {set callInfo(displayInfo) "Director(mobile)"}
	 "9130000000" {set callInfo(displayInfo) "Buhgalter(mobile)"}  
	 default {} 	
	}
	
	leg setup $digit callInfo leg_incoming
}

proc CallIsConnect { } {
	puts "\n\n IVR - proc CallIsConnect start \n\n"
	global playng_files	

	set status [infotag get evt_status]
	
	if {$status == "ls_000"} {
	fsm setstate CALLACTIVE	

	} elseif {$status == "ls_002"} {
		fsm setstate TRYAGAIN
		media play leg_incoming $playng_files(noanswer)

	} elseif {$status == "ls_004" || $status == "ls_005" || $status == "ls_006"} {
		fsm setstate TRYAGAIN
		media play leg_incoming $playng_files(noexist)

	} elseif {$status == "ls_007"} {
		fsm setstate TRYAGAIN
		media play leg_incoming $playng_files(busy)
	}
}

proc AbortCall { } {
	puts "\n\n IVR - proc AbortCall start \n\n"
	call close
}

init
	set ivr_fsm(any_state,ev_disconnected)    			"AbortCall, 		same_state"
	set ivr_fsm(CALLCOMES,ev_setup_indication)  		"Play_Welcome, 		same_state"
	set ivr_fsm(CALLCOMES,ev_collectdigits_done)		"CheckDestanation, 	same_state"
	set ivr_fsm(CALLCOMES,ev_named_timer)				"GoToReception, 	same_state"
	set ivr_fsm(TORECEPTION,ev_media_done)         		"GoToReception, 	same_state"
	set ivr_fsm(TRYAGAIN,ev_media_done)         		"Play_TakeNumber, 	TRYING"
	set ivr_fsm(TRYING,ev_collectdigits_done)			"CheckDestanation, 	same_state"
	set ivr_fsm(TRYING,ev_named_timer)					"GoToReception, 	same_state"
	set ivr_fsm(CALLCONNECTED,ev_setup_done) 			"CallIsConnect,		same_state"
	set ivr_fsm(CALLACTIVE,ev_disconnected)   			"AbortCall,			CALLDISCONNECTED"
	set ivr_fsm(CALLDISCONNECTED,ev_disconnected) 		"AbortCall,			same_state"
	set ivr_fsm(CALLDISCONNECTED,ev_media_done)  		"AbortCall,			same_state"
	set ivr_fsm(CALLDISCONNECTED,ev_disconnect_done) 	"AbortCall,			same_state"

fsm define ivr_fsm CALLCOMES