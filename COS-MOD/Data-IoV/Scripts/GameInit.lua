--[[
http://www.legion.zone.zg.pl/doku.php/modowanie/ja/art_ja_m_22_lua

- Global variables:
  - difficultyLevel
            1: easy, 2: experienced, 3: expert, 4: insane
        - gameStyle
            0: realistic, 1: scifi
        - is_networked (Multiplayer)
            0 - no , 1 - yes
        - enableCrepitus
            0 - no , 1 - yes  
        - startingCashNovice, startingCashExperienced, startingCashExpert, startingCashInsane
          Starting cash
		  
		- fMercDayOne
		  - true or false
		  see file ja2.ini -> Recruitment Settings -> MERC_WEBSITE_IMMEDIATELY_AVAILABLE
	
		- giHospitalTempBalance
		  set hospital balance
	
		- gbHospitalPriceModifier
		  set hospital modifier
	
		 -giHospitalRefund
		  
- Function :
          
 - AddAlternateSector, AddAltSector, AddAltSectorNew 
   add alternative sector
   
 - AddNPC or AddNPCtoSector
   add NPC\EPC\RPC to sector
   
 - AddAltUnderGroundSector, AddAltUGSector or AddAltUGSectorNew
   add alternative underground sector
   
 - SetNPCData1 ( ProfilID, value )
   set NPCData1
   
 - GetStartingCashNovice()
   get starting cash novice level
	
 - GetStartingCashExperienced()
   get starting cash experienced level
	 
 - GetStartingCashExpert()
   get starting cash expert level
	  
 - GetStartingCashInsane()
   get starting cash insane level
   
 - GetWorldTotalMin()
   get world time
	
 - AddTransactionToPlayersBook(ubCode, ubSecondCode, uiDate, iAmount)
   add transaction to player
   
 - AddPreReadEmail (iMessageOffset, iMessageLength, ubSender)
   iMessageOffset - record from email.edt
   iMessageLength - record from email.edt
   ubSender - uiIndex from SenderNameList.xml 
   
 - AddEmail (iMessageOffset, iMessageLength, ubSender, iCurrentIMPPosition)
   iMessageOffset - record from email.edt
   iMessageLength - record from email.edt
   ubSender - uiIndex from SenderNameList.xml
   iCurrentIMPPosition - -1 
	
   Example :
		-- Add Fatima to sector
   		Fatima = { }
		Fatima.MercProfiles = 101
		Fatima.sector = "A10-0"
		AddNPC(Fatima)
		
		-- Add Fatima to sector
		AddNPC( { MercProfiles = 101 , sector = "A10-0" } )
		
	-- Add Fatima to sector , only real game
	if gameStyle == 0 then
   		Fatima = { }
		Fatima.MercProfiles = 101
		Fatima.sector = "A10-0"
		AddNPC(Fatima)
		end
		
	-- Add alternative sector, only starting cash = 4000 and game styl s-f
	if (startingCashNovice == 4000 and gameStyle == 1) then
			Fatima = { }
			Fatima.MercProfiles = 101
			Fatima.sector = "A10-0"
			AddNPC(Fatima)
	end
	
	-- Add alternative sector, only real game
if gameStyle == 0 then
	SektorA9 = { }
	SektorA9.altSector = "A9"
	AddAlternateSector(SektorA9)
end

	-- Add alternative sector
	SektorA9 = { }
	SektorA9.altSector = "A9"
	AddAlternateSector(SektorA9)
	
	-- Add alternative sector
	SektorA9 = { }
	SektorA9.altSector = "A9"
	AddAlternateSector(SektorA9)
	
	-- Add alternative underground sector
	A10_b1 = { }
	A10_b1.altSector = "A10-1"
	AddAltUnderGroundSector(A10_b1)
	
	-- Add alternative underground sector
	A10_b1 = { }
	A10_b1.altSector = "A10-1"
	AddAltUGSector(A10_b1)	
	
	-- Add alternative underground sector
	AddAltUGSector( { altSector = "A10-1" } )	
	
		-- Add Skyrider to sector
	AddNPCtoSector(97,9,1,0)
	
	-- Add alternative sector C1
	AddAltSectorNew (3,1)
	
	-- Add alternative sector C1-3
	AddAltUGSectorNew(3,1,3)
	
   
]]


local MAX_EMAIL_LINES = 10 -- max number of lines can be shown in a message
local MAX_MESSAGES_PAGE = 18 -- max number of messages per page

local IMP_EMAIL_INTRO = 0
local IMP_EMAIL_INTRO_LENGTH = 10
local ENRICO_CONGRATS = (IMP_EMAIL_INTRO + IMP_EMAIL_INTRO_LENGTH)					
local ENRICO_CONGRATS_LENGTH = 3
local IMP_EMAIL_AGAIN = (ENRICO_CONGRATS + ENRICO_CONGRATS_LENGTH)
local IMP_EMAIL_AGAIN_LENGTH = 6
local MERC_INTRO = (IMP_EMAIL_AGAIN + IMP_EMAIL_AGAIN_LENGTH)
local MERC_INTRO_LENGTH = 5
local MERC_NEW_SITE_ADDRESS = ( MERC_INTRO + MERC_INTRO_LENGTH )
local MERC_NEW_SITE_ADDRESS_LENGTH = 2
local AIM_MEDICAL_DEPOSIT_REFUND = ( MERC_NEW_SITE_ADDRESS + MERC_NEW_SITE_ADDRESS_LENGTH )
local AIM_MEDICAL_DEPOSIT_REFUND_LENGTH = 3
local IMP_EMAIL_PROFILE_RESULTS = ( AIM_MEDICAL_DEPOSIT_REFUND + AIM_MEDICAL_DEPOSIT_REFUND_LENGTH )
local IMP_EMAIL_PROFILE_RESULTS_LENGTH = 1
local MERC_WARNING = ( IMP_EMAIL_PROFILE_RESULTS_LENGTH + IMP_EMAIL_PROFILE_RESULTS )
local MERC_WARNING_LENGTH = 2
local MERC_INVALID = ( MERC_WARNING + MERC_WARNING_LENGTH )
local MERC_INVALID_LENGTH = 2							
local NEW_MERCS_AT_MERC = ( MERC_INVALID + MERC_INVALID_LENGTH )
local NEW_MERCS_AT_MERC_LENGTH = 2
local MERC_FIRST_WARNING = ( NEW_MERCS_AT_MERC + NEW_MERCS_AT_MERC_LENGTH )
local MERC_FIRST_WARNING_LENGTH = 2
-- merc up a level emails
local MERC_UP_LEVEL_BIFF = ( MERC_FIRST_WARNING + MERC_FIRST_WARNING_LENGTH )
local MERC_UP_LEVEL_LENGTH_BIFF = 2
local MERC_UP_LEVEL_HAYWIRE	 = ( MERC_UP_LEVEL_LENGTH_BIFF + MERC_UP_LEVEL_BIFF )
local MERC_UP_LEVEL_LENGTH_HAYWIRE = 2
local MERC_UP_LEVEL_GASKET = ( MERC_UP_LEVEL_LENGTH_HAYWIRE + MERC_UP_LEVEL_HAYWIRE )
local MERC_UP_LEVEL_LENGTH_GASKET = 2
local MERC_UP_LEVEL_RAZOR = ( MERC_UP_LEVEL_LENGTH_GASKET + MERC_UP_LEVEL_GASKET )
local MERC_UP_LEVEL_LENGTH_RAZOR = 2
local MERC_UP_LEVEL_FLO	 = ( MERC_UP_LEVEL_LENGTH_RAZOR + MERC_UP_LEVEL_RAZOR )
local MERC_UP_LEVEL_LENGTH_FLO = 2
local MERC_UP_LEVEL_GUMPY = ( MERC_UP_LEVEL_LENGTH_FLO + MERC_UP_LEVEL_FLO )
local MERC_UP_LEVEL_LENGTH_GUMPY = 2
local MERC_UP_LEVEL_LARRY = ( MERC_UP_LEVEL_LENGTH_GUMPY + MERC_UP_LEVEL_GUMPY )
local MERC_UP_LEVEL_LENGTH_LARRY = 2
local MERC_UP_LEVEL_COUGAR = ( MERC_UP_LEVEL_LENGTH_LARRY + MERC_UP_LEVEL_LARRY )
local MERC_UP_LEVEL_LENGTH_COUGAR = 2
local MERC_UP_LEVEL_NUMB = ( MERC_UP_LEVEL_LENGTH_COUGAR + MERC_UP_LEVEL_COUGAR )
local MERC_UP_LEVEL_LENGTH_NUMB = 2
local MERC_UP_LEVEL_BUBBA = ( MERC_UP_LEVEL_LENGTH_NUMB + MERC_UP_LEVEL_NUMB )
local MERC_UP_LEVEL_LENGTH_BUBBA = 2
-- merc left-me-a-message-and-now-I'm-back emails
local AIM_REPLY_BARRY = ( MERC_UP_LEVEL_LENGTH_BUBBA + MERC_UP_LEVEL_BUBBA )
local AIM_REPLY_LENGTH_BARRY = 2
local AIM_REPLY_MELTDOWN = (AIM_REPLY_BARRY + ( 39 * AIM_REPLY_LENGTH_BARRY ))
local AIM_REPLY_LENGTH_MELTDOWN	 = AIM_REPLY_LENGTH_BARRY

-- old EXISTING emails when player starts game. They must look "read"
local OLD_ENRICO_1 = ( AIM_REPLY_LENGTH_MELTDOWN + AIM_REPLY_MELTDOWN )
local OLD_ENRICO_1_LENGTH = 3
local OLD_ENRICO_2 = ( OLD_ENRICO_1 + OLD_ENRICO_1_LENGTH )
local OLD_ENRICO_2_LENGTH = 3
local RIS_REPORT = ( OLD_ENRICO_2 + OLD_ENRICO_2_LENGTH )
local RIS_REPORT_LENGTH	 = 2
local OLD_ENRICO_3 = ( RIS_REPORT + RIS_REPORT_LENGTH )
local OLD_ENRICO_3_LENGTH = 3

-- emails that occur from Enrico once player accomplishes things
local ENRICO_MIGUEL = ( OLD_ENRICO_3 + OLD_ENRICO_3_LENGTH )
local ENRICO_MIGUEL_LENGTH = 3
local ENRICO_PROG_20 = ( ENRICO_MIGUEL + ENRICO_MIGUEL_LENGTH )
local ENRICO_PROG_20_LENGTH = 3
local ENRICO_PROG_55 = ( ENRICO_PROG_20 + ENRICO_PROG_20_LENGTH )
local ENRICO_PROG_55_LENGTH = 3
local ENRICO_PROG_80 = ( ENRICO_PROG_55 + ENRICO_PROG_55_LENGTH )
local ENRICO_PROG_80_LENGTH = 3
local ENRICO_SETBACK = ( ENRICO_PROG_80 + ENRICO_PROG_80_LENGTH )
local ENRICO_SETBACK_LENGTH = 3
local ENRICO_SETBACK_2 = ( ENRICO_SETBACK + ENRICO_SETBACK_LENGTH )
local ENRICO_SETBACK_2_LENGTH = 3
local ENRICO_CREATURES = ( ENRICO_SETBACK_2 + ENRICO_SETBACK_2_LENGTH )
local ENRICO_CREATURES_LENGTH = 3

-- insurance company emails
local INSUR_PAYMENT = ( ENRICO_CREATURES + ENRICO_CREATURES_LENGTH )
local INSUR_PAYMENT_LENGTH = 3
local INSUR_SUSPIC = ( INSUR_PAYMENT + INSUR_PAYMENT_LENGTH )
local INSUR_SUSPIC_LENGTH = 3
local INSUR_INVEST_OVER	 = ( INSUR_SUSPIC + INSUR_SUSPIC_LENGTH )
local INSUR_INVEST_OVER_LENGTH = 3
local INSUR_SUSPIC_2 = ( INSUR_INVEST_OVER + INSUR_INVEST_OVER_LENGTH )
local INSUR_SUSPIC_2_LENGTH	 = 3

local BOBBYR_NOW_OPEN = ( INSUR_SUSPIC_2 + INSUR_SUSPIC_2_LENGTH )
local BOBBYR_NOW_OPEN_LENGTH = 3

local KING_PIN_LETTER = ( BOBBYR_NOW_OPEN + BOBBYR_NOW_OPEN_LENGTH )
local KING_PIN_LETTER_LENGTH = 4

local LACK_PLAYER_PROGRESS_1 = ( KING_PIN_LETTER + KING_PIN_LETTER_LENGTH )
local LACK_PLAYER_PROGRESS_1_LENGTH = 3

local LACK_PLAYER_PROGRESS_2 = ( LACK_PLAYER_PROGRESS_1 + LACK_PLAYER_PROGRESS_1_LENGTH )
local LACK_PLAYER_PROGRESS_2_LENGTH = 3

local LACK_PLAYER_PROGRESS_3 = ( LACK_PLAYER_PROGRESS_2 + LACK_PLAYER_PROGRESS_2_LENGTH )
local LACK_PLAYER_PROGRESS_3_LENGTH = 3

--A package from bobby r has arrived in Drassen
local BOBBYR_SHIPMENT_ARRIVED = ( LACK_PLAYER_PROGRESS_3 + LACK_PLAYER_PROGRESS_3_LENGTH )
local BOBBYR_SHIPMENT_ARRIVED_LENGTH = 4

-- John Kulba has left the gifts for theplayers in drassen
local JOHN_KULBA_GIFT_IN_DRASSEN = ( BOBBYR_SHIPMENT_ARRIVED + BOBBYR_SHIPMENT_ARRIVED_LENGTH )
local JOHN_KULBA_GIFT_IN_DRASSEN_LENGTH = 4

--when a merc dies on ANOTHER assignment ( ie not with the player )
local MERC_DIED_ON_OTHER_ASSIGNMENT = ( JOHN_KULBA_GIFT_IN_DRASSEN + JOHN_KULBA_GIFT_IN_DRASSEN_LENGTH )
local MERC_DIED_ON_OTHER_ASSIGNMENT_LENGTH = 5

local INSUR_1HOUR_FRAUD = ( MERC_DIED_ON_OTHER_ASSIGNMENT + MERC_DIED_ON_OTHER_ASSIGNMENT_LENGTH )
local INSUR_1HOUR_FRAUD_LENGTH = 3

--when a merc is fired, and is injured
local AIM_MEDICAL_DEPOSIT_PARTIAL_REFUND = ( INSUR_1HOUR_FRAUD + INSUR_1HOUR_FRAUD_LENGTH )
local AIM_MEDICAL_DEPOSIT_PARTIAL_REFUND_LENGTH = 3

--when a merc is fired, and is dead
local AIM_MEDICAL_DEPOSIT_NO_REFUND = ( AIM_MEDICAL_DEPOSIT_PARTIAL_REFUND + AIM_MEDICAL_DEPOSIT_PARTIAL_REFUND_LENGTH )
local AIM_MEDICAL_DEPOSIT_NO_REFUND_LENGTH = 3

local BOBBY_R_MEDUNA_SHIPMENT	 = 	( AIM_MEDICAL_DEPOSIT_NO_REFUND + AIM_MEDICAL_DEPOSIT_NO_REFUND_LENGTH )
local BOBBY_R_MEDUNA_SHIPMENT_LENGTH = 	4

local iStartingCash = 0

Fincances = {
	ACCRUED_INTEREST = 0,
	ANONYMOUS_DEPOSIT = 1,
	TRANSACTION_FEE = 2,
	HIRED_MERC = 3,
	BOBBYR_PURCHASE,
	PAY_SPECK_FOR_MERC = 4,
	MEDICAL_DEPOSIT = 5,
	IMP_PROFILE = 6,
	PURCHASED_INSURANCE = 7,
	REDUCED_INSURANCE = 8,
	EXTENDED_INSURANCE = 9,
	CANCELLED_INSURANCE = 10,
	INSURANCE_PAYOUT = 11,
	EXTENDED_CONTRACT_BY_1_DAY = 12,
	EXTENDED_CONTRACT_BY_1_WEEK = 13,
	EXTENDED_CONTRACT_BY_2_WEEKS = 14,
	DEPOSIT_FROM_GOLD_MINE = 15,
	DEPOSIT_FROM_SILVER_MINE = 16,
	PURCHASED_FLOWERS = 17,
	FULL_MEDICAL_REFUND = 18,
	PARTIAL_MEDICAL_REFUND = 19,
	NO_MEDICAL_REFUND = 20,
	PAYMENT_TO_NPC = 21,
	TRANSFER_FUNDS_TO_MERC = 22,
	TRANSFER_FUNDS_FROM_MERC = 23,
	TRAIN_TOWN_MILITIA = 24,
	PURCHASED_ITEM_FROM_DEALER = 25,
	MERC_DEPOSITED_MONEY_TO_PLAYER_ACCOUNT = 26,
	SOLD_ITEMS = 27,
	FACILITY_OPERATIONS = 28, -- HEADROCK HAM 3.6: Facility costs (daily payment)
	MILITIA_UPKEEP = 29, -- HEADROCK HAM 3.6: Militia Upkeep Costs (daily payment)
	}

Sender = {
	MAIL_ENRICO = 0,
	CHAR_PROFILE_SITE = 1,
	GAME_HELP = 2,
	IMP_PROFILE_RESULTS = 3,
	SPECK_FROM_MERC = 4,
	RIS_EMAIL = 5,
	BARRY_MAIL = 6,
	INSURANCE_COMPANY = 46,
	BOBBY_R = 47,
	KING_PIN = 48,
	JOHN_KULBA = 49,
	AIM_SITE = 50,
}

 Modifier = {  
    HOSPITAL_UNSET = 0,
    HOSPITAL_NORMAL = 1,
    HOSPITAL_BREAK = 2,
    HOSPITAL_COST = 3,
    HOSPITAL_FREEBIE = 4,
    HOSPITAL_RANDOM_FREEBIE = 5,
}

SectorY = {
	MAP_ROW_A = 1,
	MAP_ROW_B = 2,
	MAP_ROW_C = 3,
	MAP_ROW_D = 4,
	MAP_ROW_E = 5,
	MAP_ROW_F = 6,
	MAP_ROW_G = 7,
	MAP_ROW_H = 8,
	MAP_ROW_I = 9,
	MAP_ROW_J = 10,
	MAP_ROW_K = 11,
	MAP_ROW_L = 12,
	MAP_ROW_M = 13,
	MAP_ROW_N = 14,
	MAP_ROW_O = 15,
	MAP_ROW_P = 16,
}

Profil = {
	Skyrider = 97,
	Micky = 96,
	Gabby = 104,
	Bob = 84,
	Devin = 61,
}

local DIF_LEVEL_EASY = 1
local DIF_LEVEL_MEDIUM = 2
local DIF_LEVEL_HARD = 3
local DIF_LEVEL_INSANE = 4

function InitNPCs()

	-- add the pilot at a random location!
	if is_networked == 0 then
		o = math.random(1, 4)
		if o == 1 then
			-- B15 - Skyrider
			AddNPCtoSector( Profil.Skyrider, 15, SectorY.MAP_ROW_B, 0 )
			AddAltSectorNew( 15, SectorY.MAP_ROW_B )
		elseif o == 2 then
			-- E14 - Skyrider
			AddNPCtoSector( Profil.Skyrider, 14, SectorY.MAP_ROW_E, 0 )
			AddAltSectorNew( 14, SectorY.MAP_ROW_E )
		elseif o == 3 then	
			-- D12 - Skyrider
			AddNPCtoSector( Profil.Skyrider, 12, SectorY.MAP_ROW_D, 0 )
			AddAltSectorNew( 12,SectorY.MAP_ROW_D )
		elseif o == 4 then
		-- C16 - Skyrider
			AddNPCtoSector( Profil.Skyrider, 16, SectorY.MAP_ROW_C, 0 )
			AddAltSectorNew( 16, SectorY.MAP_ROW_C )
		end
	end

	if is_networked == 1 then
			-- B15 - Skyrider
			AddNPCtoSector( Profil.Skyrider, 15, SectorY.MAP_ROW_B, 0 )
			AddAltSectorNew( 15, SectorY.MAP_ROW_B )
	end

	-- set up Madlab's secret lab (he'll be added when the meanwhile scene occurs)
	-- use alternate map in this sector
	if is_networked == 0 then
		i = math.random(1, 4)
		if i == 1 then
			--H7
			AddAltSectorNew( 7, SectorY.MAP_ROW_H )
		elseif i == 2 then
			--H16
			AddAltSectorNew( 16, SectorY.MAP_ROW_H )
		elseif i == 3 then	
			--I11
			AddAltSectorNew( 11, SectorY.MAP_ROW_I )
		elseif i == 4 then
			--E4
			AddAltSectorNew( 4, SectorY.MAP_ROW_E )
		end
	end
	
	if is_networked == 1 then
			--H7
			AddAltSectorNew( 7, SectorY.MAP_ROW_H )
	end

	-- add Micky in random location
	if is_networked == 0 then
		i = math.random(1, 5)
		if i == 1 then
			-- G9
			AddNPCtoSector( Profil.Micky, 9, SectorY.MAP_ROW_G, 0 ) 
		elseif i == 2 then
			-- D14
			AddNPCtoSector( Profil.Micky, 14, SectorY.MAP_ROW_D, 0 ) 
		elseif i == 3 then	
			-- C5
			AddNPCtoSector( Profil.Micky, 5, SectorY.MAP_ROW_C, 0 )
		elseif i == 4 then
			-- H2
			AddNPCtoSector( Profil.Micky, 2, SectorY.MAP_ROW_H, 0 )
		elseif i == 5 then
			-- C6
			AddNPCtoSector( Profil.Micky, 6, SectorY.MAP_ROW_C, 0 )
		end
	end

	if is_networked == 1 then
			-- G9
			AddNPCtoSector( Profil.Micky, 9, SectorY.MAP_ROW_G, 0 )
	end

	-- 0 - false 1 - true
	PlayerTeamSawJoey(false)

	-- add Bob
	if 	(gameStyle == 1 and enableCrepitus == 1) then
			-- F8
			AddNPCtoSector( Profil.Bob, 8, SectorY.MAP_ROW_F, 0 )
	end

	-- add Gabby in random location
	if 	(gameStyle == 1 and enableCrepitus == 1) then	
		i = math.random(1, 2)
			if i == 1 then
				-- H11
				AddNPCtoSector( Profil.Gabby, 11, SectorY.MAP_ROW_H, 0 )
				AddAltSectorNew( 11, SectorY.MAP_ROW_H )
			elseif i == 2 then
				-- I4
				AddNPCtoSector( Profil.Gabby, 4, SectorY.MAP_ROW_I, 0 )
				AddAltSectorNew( 4, SectorY.MAP_ROW_I )	
		end
	end

	--not scifi, so use alternate map in Tixa's b1 level that doesn't have the stairs going down to the caves.
	if 	(gameStyle == 0 and enableCrepitus == 0) then
				--J9-1
				AddAltUGSectorNew( 9, SectorY.MAP_ROW_J, 1 )
	end

	-- init hospital variables
	HospitalTempBalance( 0 )
	HospitalRefund( 0 )
	HospitalPriceModifier( Modifier.HOSPITAL_UNSET )

	-- set up Devin so he will be placed ASAP
	SetNPCData1 ( Profil.Devin, 3 )
end

function InitNewGame()
  	if ( is_networked == 0 ) then
		--Setup two new messages!
		AddPreReadEmail(OLD_ENRICO_1,OLD_ENRICO_1_LENGTH,Sender.MAIL_ENRICO)
		AddPreReadEmail(OLD_ENRICO_2,OLD_ENRICO_2_LENGTH,Sender.MAIL_ENRICO)
		AddPreReadEmail(RIS_REPORT,RIS_REPORT_LENGTH,Sender.RIS_EMAIL)
		AddPreReadEmail(OLD_ENRICO_3,OLD_ENRICO_3_LENGTH,Sender.MAIL_ENRICO )

		AddEmail (IMP_EMAIL_INTRO, IMP_EMAIL_INTRO_LENGTH, Sender.CHAR_PROFILE_SITE, -1)
		
		if( fMercDayOne == true ) then
			AddEmail (MERC_INTRO, MERC_INTRO_LENGTH, Sender.SPECK_FROM_MERC, -1)
		end
	end	
		if ( difficultyLevel == DIF_LEVEL_EASY ) then
			iStartingCash = GetStartingCashNovice()
		elseif ( difficultyLevel == DIF_LEVEL_MEDIUM ) then
			iStartingCash = GetStartingCashExperienced()
		elseif ( difficultyLevel == DIF_LEVEL_HARD ) then	
			iStartingCash = GetStartingCashExpert()
		elseif ( difficultyLevel == DIF_LEVEL_INSANE ) then
			iStartingCash = GetStartingCashInsane()
		end
		
		AddTransactionToPlayersBook( Fincances.ANONYMOUS_DEPOSIT, 0, GetWorldTotalMin(), iStartingCash )

	
end