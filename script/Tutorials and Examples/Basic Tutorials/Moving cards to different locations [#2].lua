--MOVING CARDS TO DIFFERENT LOCATIONS [#2]

--In this section, we will learn about more tricky effects that allow us to transfer our cards from a place to another
--Specifically, here are the effects we're about to script: SETTING CARDS, PLACING PENDULUMS, MODIFYING THE POSITION OF CARDS IN THE DECK
--In addition, I'll give you some general infos about: ACTIVATION EFFECTS, TARGETING, EFFECTS WITH MULTIPLE RESULTS, QUICK EFFECTS
--Let's begin

function c10101011.initial_effect(c)
	
	--ACTIVATION EFFECTS, TARGETING, EFFECTS WITH MULTIPLE RESULTS and SETTING CARDS
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)						-- Activation =	These effects are exclusive to Spell/Trap Cards, they always need a SetCode, but not a SetRange. Their main action is placing a card from the hand to the S/T Zone, thus activating it and resolving the effect specified in the functions below.
	e1:SetCode(EVENT_FREE_CHAIN)							-- Free-Chain =	These effects CAN start a Chain, so they can be activated whenever it is possible during a Duel.
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)					-- Card Target = If your card's effect is going to target a card(s), then you have to put this property.
	e1:SetCountLimit(1,10101011+EFFECT_COUNT_CODE_OATH)		-- To HOPT the activation of a Spell/Trap, you have to add EFFECT_COUNT_CODE_OATH next to the two usual numbers
	e1:SetTarget(c10101011.target)
	e1:SetOperation(c10101011.activate)
	c:RegisterEffect(e1)
	--Go to the SETTING CARDS block below if you want to know more about this effect	[Difficulty: 3/5]
	
	--QUICK EFFECTS and PLACING PENDULUMS
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10101011,0))					--If you script 2 or more effects that can be activated at the same time, it would be wise to put a description on those effects to avoid activating the wrong one during a Duel.
	e2:SetType(EFFECT_TYPE_QUICK_O)								--Quick Effects = They can be activated during either player's turn by default. Can be Optional(O) or Forced(F). Require a SetCode and a SetRange
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,20101011)								--If you have more HOPTed effects on 1 card. Be sure to put different numbers each time you use a SetCountLimit, unless you want to script a card that states "You can only activate 1 effect of this card's name per turn"
	e2:SetTarget(c10101011.pendtg)
	e2:SetOperation(c10101011.pendop)
	c:RegisterEffect(e2)
	--Go to the PLACING PENDULUMS block below if you want to know more about this effect	[Difficulty: 1/5]
	
	--TURN BASED EFFECTS, MODIFYING THE POSITION OF CARDS IN THE DECK and MAKING CHOICES
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10101011,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c10101011.cgcon)
	e3:SetTarget(c10101011.cgtg)
	e3:SetOperation(c10101011.cgop)
	c:RegisterEffect(e3)
	--Go to the MODIFYING THE POSITION OF CARDS IN THE DECK block below if you want to know more about this effect	[Difficulty: 1/5]
end

-----filters-----
--SETTING CARDS
function c10101011.filter(c,e,tp)
	--Our effect changes depending on the type of the target, so we can make a filter with different "return"
	--Let's start with the first case: our target is a monster who's going to be SpSum in face-down Defense Position
	if c:IsType(TYPE_MONSTER) then
		--Of course, we have to make sure we have a free monster zone, also we have to check if that monster can be spsummoned in face-down Defense Position; so our line will be:
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	
	--Now let's proceed with the second case: our target is a S/T card that is going to be Set
	--We use the "else" keyword which is the equivalent of "otherwise, if the card is not a monster...". ALWAYS REMEMBER TO PUT AN END WHEN YOU CLOSE A "if...else" BLOCK
	else
		--We have to make sure that there is a free S/T zone (or that our card is a Field Spell, because Field Spells can take the place of Field Spells already on the field)
		--Also, we check if the card is Settable
		local zone=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end		--This line serves to prevent this card from activating when there is only 1 free zone in the S/T, we'll analyze this later on
		return (zone>0 or c:IsType(TYPE_FIELD)) and c:IsSSetable()
	end
end

--PLACING PENDULUMS
function c10101011.pendfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
	and (c:IsLocation(LOCATION_DECK) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))	--In case our cards is in the ED, we have to specify that it must be face-up. To do that, you can use brackets
end

--MODIFYING POSITION
function c10101011.cgfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)
end
function c10101011.changefilter(c)
	--To make a filter for a NORMAL SPELL, you use GetType instead of IsType. See at the bottom of the file for details
	return c:GetType()==TYPE_SPELL
end
-----------------

--SETTING CARDS
--Our effect is now going to target a card(s), so we have to make a few changes to the target function.
--First of all, we must add the CHKC parameter into the brackets below.
--Then, we're going to select the target in this function, NOT IN THE OPERATION ONE.
function c10101011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--The CHKC line is structured this way;
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10101011.filter(chkc,e,tp) end
	--As you can see, in this line we have to specify the characteristics of our target; the effect states "1 card in your GY" so:
	--We specify that WE CONTROL THE CARD with the Card.IsControler function, and we add that the target is in the GY with the Card.IsLocation function
	--In addition, we can also use a filter to give the correct infos. You just have to write the filter function name followed by a bracket containing ALL of its parameters
	--If you use this method, remember that the C parameter must be replaced with CHKC. Now let's proceed with the usual CHK block.
	
	if chk==0 then
		return Duel.IsExistingTarget(c10101011.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)	--IsExistingTarget =	It is equivalent to the IsExistingMatchingCard function, however we use this one when the card we are looking for IS GOING TO BE TARGETED
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c10101011.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)    --SelectTarget =	It is equivalent to the SelectMatchingCard function, however we use this one when the card we want to select is a TARGET
	
	--As always, since our script will have different effects, we have to give different infos depending on the card type
	if g:GetFirst():IsType(TYPE_MONSTER) then
		--In case of a monster, it is going to be Special Summoned
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		--In case of a S/T, since there is no category for setting cards, we're simply going to inform that the card is going to leave the GY
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end

function c10101011.activate(e,tp,eg,ep,ev,re,r,rp)
	--Since we chose EXACTLY ONE target in the previous function, we can recall it with the GetFirstTarget function
	local tc=Duel.GetFirstTarget()
	--Before proceeding, we use the Card.IsRelateToEffect function to check "tc"
	if not tc:IsRelateToEffect(e) then return end
	--Now we can give the instructions for the final effects
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	
	--In this case, it is better to use ELSEIF rather than ELSE, because the latter option does NOT allow us to make a further check
	elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SSet(tp,tc)			--SSet =	Set a Spell/Trap Card to the S/T Zone
		Duel.ConfirmCards(1-tp,tc)
		--Now if you want, you can follow the extra part of this effect to learn how to decide whether a card can be activate the turn it is set.
		--Let's start by making a Spell unactivatable until the end of the turn. Since this is a restriction, we must treat is as if it was an effect [See Tutorial 1]
		if tc:IsType(TYPE_SPELL) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		
		--If you want to make a Trap activatable during the turn it is Set instead...
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end


--PLACING PENDULUMS
function c10101011.pendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))						--Let's check if at least 1 of your PZones is available
		and Duel.IsExistingMatchingCard(c10101011.pendfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) 					--Then we can see if a suitable card(s) exists
	end
end
function c10101011.pendop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()							--Remember that "e:GetHandler()" always refers to THIS card
	if not c:IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10101011.pendfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end


--MODIFYING THE POSITION OF CARDS IN THE DECK
function c10101011.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10101011.cgfilter,1,nil,tp)
	and Duel.GetTurnPlayer()==tp						--To limit the effect's activation to a player's turn, you use the Duel.GetTurnPlayer function
end
function c10101011.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10101011.changefilter,tp,LOCATION_DECK,0,1,nil) end		--Check if there is a suitable card
end
function c10101011.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101011,2))
	local g=Duel.SelectMatchingCard(tp,c10101011.changefilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		--Now we have to make the game ask the player whether they want to place the card on top or at the bottom of their deck.
		--To do this, we create a variable "opt" and use the function Duel.SelectOption
		local opt=Duel.SelectOption(tp,aux.Stringid(10101011,3),aux.Stringid(10101011,4))						--SelectOption = See at the bottom of the file for details
		if opt==0 then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)					--To change the position of a card that is located inside the Deck, we use the MoveSequence function (0 places the card on top, 1 places the card at the bottom)
			Duel.ConfirmDecktop(tp,1)
		else
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,1)
		end
	end
end



-----EXTRA SECTION-----

--Duel.SetOperationInfo
--This function can be written in different ways depending on the type of effect you're trying to create. Here are the basic differences between the formats:
-- 1 = Non-Targeting Effects, look at the search effect of Tutorial 1 (0, "Put the effect's category", nil, "Put the MINIMUM NUMBER of cards that will be affected by the effect", "Put the player who owns the cards", "Put the location in which the cards are currently located")
-- 2 = Targeting Effects, look above (0, "Put the effect's category", "Put the GROUP that will be affected", "Put the MINIMUM NUMBER of cards that will be affected, 0, 0)
-- 3 = LP-related Effects (0, CATEGORY_RECOVER or CATEGORY_DAMAGE, nil, 0, "Player Affected", "Amount of LP gained or damaged")
-- 4 = Draw Effects (0, CATEGORY_DRAW, nil, 0, "Player Affected", "Number of cards that will be drawn")
-- 5 = Deck Destruction Effects, see Lightsworns (0, CATEGORY_DECKDES, nil, 0, "Player Affected", "Number of cards affected")

--Remember that in the "Player Affected" spots, you will have to put "tp" (for yourself), "1-tp" (for your opponent) or "PLAYER_ALL" (for all the players)



--As you may have noticed, Card functions can be divided in two main categories: "Get" Functions and "Is" Functions. Here are the main differences.
--Let's take Card.IsType(TYPE_NORMAL+TYPE_MONSTER) and Card.GetType()==TYPE_NORMAL+TYPE_MONSTER
--First of all, they must be written in different ways. "Is" Functions must have the values INSIDE THE FUNCTION BRACKETS. "Get" Functions must be followed by "equivalence signs" (==, >, >=, <, <=, ~=), and then by the values
--Card.IsType(TYPE_NORMAL+TYPE_MONSTER) is the same of [Card.IsType(TYPE_NORMAL) "OR" Card.IsType(TYPE_MONSTER)]
--Card.GetType()==TYPE_NORMAL+TYPE_MONSTER is the same of [Card.IsType(TYPE_NORMAL) "AND" Card.IsType(TYPE_MONSTER)

--REMEMBER THIS CAREFULLY: 
--Card.IsType(TYPE_NORMAL+TYPE_MONSTER) comprehends all cards that correspond to AT LEAST ONE of the values inserted
--Card.GetType()==TYPE_NORMAL+TYPE_MONSTER comprehends all cards that correspond to ALL of the values inserted

--Example:
--c:IsType(TYPE_SPELL) =	Searches for all SPELL CARDS, disregarding their Type (Quickplays, Continuous...)
--c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) =	Searches for all SPELL CARDS, disregarding of their Type, and for all CONTINUOUS CARDS, which include Continuous Traps!
--c:GetType()==TYPE_SPELL	=	Searches for all NORMAL SPELL CARDS, there are no other Types inserted
--c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS =		Searches for all CONTINUOUS SPELL CARDS only; other Spells and Continuous Traps are EXCLUDED



--Duel.SelectOption(1,...,...,...)
-- 1 = Player that will have to make the choice
-- 2 = Choice 0
-- 3 = Choice 1
-- 4 = Choice 2
-- ...

--If you set this function as a variable, for example:	opt=Duel.SelectOption(tp,aux.Stringid(10101011,1),aux.Stringid(10101011,8),aux.Stringid(10101011,3))
--If you select the first option, opt becomes 0
--If you select the second one, opt becomes 1
--If you select the third one, opt becomes 2
--And it goes on this way, keep that in mind.

--If you do this, however:	opt=Duel.SelectOption(tp,aux.Stringid(10101011,1),aux.Stringid(10101011,8),aux.Stringid(10101011,3)) + "number"
--If you select the first option, opt becomes 0 + "number"
--If you select the second one, opt becomes 1 + "number"
--If you select the third one, opt becomes 2 + "number"