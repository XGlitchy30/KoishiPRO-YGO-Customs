--Tutoranger ReSearcher (by XGlitchy30)
--In this section you will learn how to script some effects related to searching and adding cards to the hand
--In addition, there are also a few basic things about costs, filters, effect types etc...
--It is advisable to follow the script in the correct order by reading one effect at a time (also open the tutorial .cdb to see precisely the effect we're trying to script)

function c10101010.initial_effect(c)
	--We will start by learning two very simple things:
	--IGNITION EFFECTS and BASIC SEARCHING (aka "Add a card from ... to your hand")
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND) --Remember to ALWAYS put a category in your effects if possible. Without it, your cards will not interact correctly with some other cards, such as spells, traps and handtraps
	e1:SetType(EFFECT_TYPE_IGNITION) 				--Ignition = Once per turn, you can... / IGNITION effects do NOT need the SetCode function
	e1:SetRange(LOCATION_MZONE)						--The location from which we can trigger the effect
	e1:SetCountLimit(1)								--Soft Once per turn = The number of times we can activate the effect with this card
	e1:SetTarget(c10101010.target)	
	e1:SetOperation(c10101010.operation)
	c:RegisterEffect(e1)
	--Go to the BASIC SEARCHING block below if you want to know more about this effect
	
	--SINGLETRIGGER EFFECTS, SPECIAL SUMMONING and CLONING
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)		--Singletrigger = When\If THIS card... / SINGLETRIGGER effects need a SetCode but do not require SetRange, they can be optional(O) or forced(F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)	--If your card does NOT miss timing, then you must add the DELAY flag (+ the DAMAGE STEP one if the effect can also be activated during the Damage Step). If your card misses timing, you MUST NOT put these flags
	e2:SetCode(EVENT_SUMMON_SUCCESS)							--The event that needs to happen in order for the effect to trigger
	e2:SetCountLimit(1,10101010)								--Hard Once Per Turn = To enable it, just put a number (usually the card's ID) next to the first one.
	e2:SetTarget(c10101010.sptg)
	e2:SetOperation(c10101010.spop)
	c:RegisterEffect(e2)
	--Since we want the effect to activate even if the card is Special or Flip Summoned
	--normally we should also write 2 other effects. However we can also CLONE an effect to make things faster.
	local e2x=e2:Clone()
	e2x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2x)
	local e2y=e2:Clone()
	e2y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2y)
	--The Clone functions allows us to copy an effect (e2 in this case) and to change only the things that need to be modified (the SetCodes)
	--Go to the SPECIAL SUMMONING block below if you want to know more about this effect
	
	--FIELDTRIGGER EFFECTS, SPSUMMONING FROM EXTRA and RESTRICTED SUMMONINGS
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)			--Fieldtrigger = [When\If your opponents... while THIS card is on field\hand..., When\If a card(s)... while THIS card is on field\hand...]/ FIELDTRIGGER effects need a SetCode AND a SetRange, they can be optional(O) or forced(F)
	e3:SetCode(EVENT_LEAVE_FIELD)	
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10101010.xtrcon)	--The requirements that must be fulfilled in order to ACTIVATE the effects. Trigger, Continuous and Quick effects almost always have a condition function
	e3:SetTarget(c10101010.xtrtg)
	e3:SetOperation(c10101010.xtrop)
	c:RegisterEffect(e3)
	--Go to the SPSUMMONING FROM EXTRA block below if you want to know more about this effect
	
	
	--CONTINUOUS EFFECTS, ACTIVATING CONTINUOUS CARDS FROM A LOCATION and PLACING S/Ts FACE-UP and "THEN" STATEMENT
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)	--Continuous =	[Each time...]/ They can be SingleContinuous or FieldContinuous; these effects do NOT start a Chain (they do not need the target function) and are used for placing counters or paying continuous traps' costs (see "IMPERIAL ORDER"). FieldContinuous effects always require a SetCode and a SetRange.
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10101010.actcon)
	e4:SetOperation(c10101010.actop)
	c:RegisterEffect(e4)
	--Go to the ACTIVATE and PLACING block below if you want to know more about this effect
end


--------filters---------
--(In this section we will put the different filters, you can skip it for the moment)

--BASIC SEARCH FILTER
function c10101010.filter(c)
	return c:IsSetCard(0x5754)	and c:IsAbleToHand()	--IsSetCard =	Checks the archetype
end
--SPSUMMON FILTER
function c10101010.spfilter(c,e,tp)
	return c:GetLevel()<=4 and c:GetAttack()<=1500 and c:GetDefense()<=1500 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	--Whenever we put a variable that isn't "c" in the filter block, we MUST put that same variable in the parameter brackets next to the filter name
	--Example: in the filter block there appear two NON-C variables ("e" and "tp"). The brackets become (c,e,tp)
end
--SPSUMMONING FROM EXTRA
function c10101010.xtrcheck(c,tp)
	return c:GetPreviousControler()==tp
	--In the filter block there appears one NON-C variable (tp). The brackets become (c,tp).
	--Remember to write the NON-C variables every time you call a filter functions (see line 147)
end
function c10101010.xtrfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--ACTIVATE CONTINUOUS S/Ts
function c10101010.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:GetSummonLocation()==LOCATION_EXTRA
end
function c10101010.actfilter(c,tp)
	return c:GetType()==0x20002 and c:GetActivateEffect():IsActivatable(tp)
end
function c10101010.placefilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
------------------------

--BASIC SEARCHING
function c10101010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--In the target functions, we need to place some settings in order for the effect to work
	--As for the parameters you see in the round brackets (e,tp,eg...), be sure to remember them, because we need to write them every time we start a function
	--Almost all target functions contain this "IF CHK statement". Its purpose is to check if the functions we put after the "return" are TRUE, if even one of them returns "FALSE" then the effect won't RESOLVE
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10101010.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)	--IsExistingMatchingCard = Checks if a card(s) currently exists in the locations we put (go to the bottom of the page to see the parameters)
	end
	--Now we set the infos
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	--There are different "formats" for the Duel.SetOperationInfo function. Let's use this one for the searching effect and finish the function
end

function c10101010.operation(e,tp,eg,ep,ev,re,r,rp)		--Note that the "chk" is not in the brackets. CHK (and CHKC as we'll see later) are needed only in the target functions
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)																			-- Hint =	Allows to give infos on what to do in order to resolve the effect. If you pay attention, while you are targeting a card during a Duel, there appears a blue square on the top of the window with some words on it. This is the hint function's doing. IT IS NOT MANDATORY
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10101010.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)	-- SelectMatchingCard =   It lets you select a card; when you're moving a card from the GY to another place, you also put the NecroValleyFilter auxiliary as shown before.
	if g:GetCount()>0 then
		--If we managed to select at least 1 card, the effect will finally resolve
		Duel.SendtoHand(g,nil,REASON_EFFECT)	--SendtoHand =	Add a card(s) to the hand
		Duel.ConfirmCards(1-tp,g)				--ConfirmCards =	Reveal a card(s) to a player(s)
	end
end


--SPECIAL SUMMONING
function c10101010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0												  	--GetLocationCount =	Counts how many free zones are there. You almost always put it in the target functions for special summoning effects
		and Duel.IsExistingMatchingCard(c10101010.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)	--Note that now we put more parameters after the "nil", this is because the filter requires 2 more parameters other than "c". Try not to forget about this, since it's one of the most common causes of bugs 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function c10101010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end	--It is good practice to put this line in the operation function of a special summoning effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10101010.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)	--Again, we put the NecroValleyFilter since our effect involves monsters in the GY too.
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	--SpecialSummon =	It lets you Special Summon a monster(s) (see below for more details)
	end
end


--SPSUMMONING FROM EXTRA
function c10101010.xtrcon(e,tp,eg,ep,ev,re,r,rp)
	--In condition functions, we will often need the EG parameter. EG is basically the group of all cards that have been affected by the last effect that was activated
	--For example, if your opponent's Raigeki resolves, EG will consist of all the monsters destroyed by Raigeki's effect
	
	return eg:IsExists(c10101010.xtrcheck,1,nil,tp)    --IsExists = It is a group function. Checks if there is a card(s) in the GROUP that meets the filters conditions.
end
function c10101010.xtrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0		--GetLocationCountFromEx =	Counts how many zones in which you can summon a monster from the ED are available
		and Duel.IsExistingMatchingCard(c10101010.xtrfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10101010.xtrop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10101010.xtrfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then														--This means "if tc (the card we selected) still exists then..."
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)	--SpecialSummonStep =	Equivalent to the Spsummon function. It is often used when scripting special summon effects that put restrictions on the monsters. Always requires a "Duel.SpecialSummonComplete" function (see below)
			
			--When putting restrictions on a monster, we follow the same procedure we use when adding effects to our cards. There are a few differences though
			local e1=Effect.CreateEffect(e:GetHandler())	--Here we put "e:GetHandler()"
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)				--Since these effects are temporary we need to add a RESET. The most used one is "RESET_EVENT+0x1fe0000" which basically resets the effect when the monster leaves the field or is set facedown
			tc:RegisterEffect(e1,true)						--We put "tc" rather than "c" because we are not giving these effects on THIS card.
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			--To destroy the card during the EP, we will create a DUEL EFFECT instead (not a CARD EFFECT)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)		--We will talk about Continuous effects later on
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_PHASE+PHASE_END)							--To make an effect trigger at a specified moment, we use EVENT_PHASE+...
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)	
			e3:SetCountLimit(1)											--IMPORTANT: When you write effects that trigger during a phase, ALWAYS put the CountLimit(1). If you don't do this, the effect will activate over and over, thus softlocking the game.
			e3:SetCondition(c10101010.drycon)
			e3:SetOperation(c10101010.dryop)
			e3:SetLabelObject(tc)										--SetLabelObject =	This function is really important when scripting more complicated effects so we won't talk about this very much. Basically it allows us to "COPY" an object and "PASTE" it in the functions listed on the effects (in this case "drycon" and "dryop").
			Duel.RegisterEffect(e3,tp)									--You use the following line to register a Duel Effect, so remember it.
			tc:RegisterFlagEffect(10101010,RESET_EVENT+0x1fe0000,0,1)	--Flag effects allow us to MARK a specific card(s), they are not used on simple effects like these so we won't waste much time on them.
			Duel.SpecialSummonComplete()								--ALWAYS put this when using SpecialSummonStep
		end
	end
end
function c10101010.drycon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()				--GetLabelObject() =	It "copies" the object and allows you to use it inside the CURRENT FUNCTION ONLY.
	if tc:GetFlagEffect(10101010)==0 then	--GetFlagEffect() =		Checks if the card is "marked" with the number you put in the brackets
		e:Reset()
		return false
	end
	return true
end
function c10101010.dryop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end


--ACTIVATE FROM A LOCATION and PLACE S/Ts FACE-UP
function c10101010.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10101010.cfilter,1,nil,1-tp)
	--Now you may ask: "Why did you put 1-tp rather than tp?". 
	--The reason for this is that I gave the variable "tp" the correct value; (the effect states "when YOUR OPPONENT...", not "WHEN YOU...")
	--Filter Functions are unrelated to effects function so we cannot always put the values we want since they are located in the condition, target, operation ... functions.
	--To solve this, we put a variable in the filter (value unknown) and we give it a value once we call the filter function.
	--We'll focus on this in a different tutorial.
end
function c10101010.actop(e,tp,eg,ep,ev,re,r,rp)
	--Since there is not a target function, we will put some requirements in the operation one.
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(c10101010.actfilter,tp,LOCATION_DECK,0,1,nil) then
		return
	end
	if Duel.SelectYesNo(tp,aux.Stringid(10101010,1)) then										--SelectYesNo =	Allows a player(s) to choose whether to perform an action or not
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101010,0))									--As you can see, we can also put a card string in the Hint Function
		local g=Duel.SelectMatchingCard(tp,c10101010.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			if tc:GetActivateEffect():IsActivatable(tp) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)	--MoveToField: Move a card(s) from a location to the correct zone on LOCATION_ONFIELD
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c10101010.placefilter,tp,LOCATION_HAND,0,1,nil,tp) then
					if Duel.SelectYesNo(tp,aux.Stringid(10101010,1)) then
						--Now we encounter another effect which is chained to the previous one with the word THEN
						--When this happens we must put the following function (Duel.BreakEffect)
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
						local pc=Duel.SelectMatchingCard(tp,c10101010.placefilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()		--We can also combine two functions together with ":" (In this case, SelectMatchingCard and GetFirst). It is indeed faster to do this, however, sometimes, you will want to follow the standard procedure and write the 2 functions on different lines
						if pc then 
							Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
							--Here is the difference between ACTIVATING and PLACING;
							--When you want to activate a card you need to write some extra lines to deal with the cost and other things
							--When placing a card, you just need to invoke the MoveToField function
						end
					end
				end
			end
		end
	end
end




--Function Parameters--
--For those who are interested in these, let's take a look at the parameters of some fundamental functions...

--Duel.IsExistingMatchingCard(1,2,3,4,5,6,...)
-- 1 = Put a filter function (sometimes you can also directly call a Card Function or an auxiliary, but we'll see this another time)
-- 2 = You will usually put "tp" in here (tp means YOU, 1-tp means your OPPONENT)
-- 3 = The location(s) belonging to the player inserted in the param 2
-- 4 = The location(s) belonging to the opponent of the player inserted in the param 2
-- 5 = The minimum number of cards that need to be found in order to proceed
-- 6 = Here you will put the "excluded card". If there are no cards excluded from the check, you put "nil". In case you're dealing with an effect like this (...,except this card), you will put "e:GetHandler()" instead. There are many other cases for this parameter but for now we'll stop with these two
-- ... = Here go the values/functions in case the filter has more than one parameter


--Duel.SelectMatchingCard(1,2,3,4,5,6,7,8,...)
-- 1 = Put tp if YOU're gonna select the cards. 1-tp for your OPPONENT
-- 2,3,4,5 == 1,2,3,4 of the previous function
-- 6 = The minimum number of cards to select
-- 7 = The maximum number of cards that can be selected
-- 8 = Excluded card
-- ... = Here go the values/functions in case the filter has more than one parameter


--Card.IsCanBeSpecialSummoned(1,2,3,4,5,...)
-- 1 = Put "e"
-- 2 = The type of SpecialSummon. For regular SpSums you put 0, for Fusion Summons you put SUMMON_TYPE_FUSION etc. You can also put a custom number to specify that a monster was Special Summoned by a specific card or if you used a special procedure (see Gladiator Beasts\Pandemonium Monsters)
-- 3 = You usually put "tp" here
-- 4,5 = You can only put booleans here (TRUE or FALSE). Here are two common combinations: FALSE/FALSE lets you Special Summon normally; TRUE/FALSE lets you Special Summon ignoring the summoning conditions
-- ... = You can put additional conditions such as the position in which the monster will be summoned


--Duel.SpecialSummon(1,2,3,4,5,6,7)
-- 1 = Card(s) that will be Special Summoned
-- 2 = See previous function
-- 3 = The player that summons the monster
-- 4 = The player that will receive the monster
-- 5,6 == 4,5 of the previous function
-- 7 = The position of the monster. Default is POS_FACEUP


--Group.IsExists(1,2,3,...)
-- 1 = Filter
-- 2 = Minimum number of cards that need to be in the group
-- 3 = Excluded card


--Duel.Hint(1,2,3)
-- 1 = Type of Hint
-- 2 = Player that will receive the hint
-- 3 = Specify the hint

--Duel.SelectYesNo(1,2)
-- 1 = The player that will have to answer the question
-- 2 = Text of the question (use aux.Stringid)