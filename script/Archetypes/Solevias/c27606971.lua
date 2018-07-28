--Preparativi per la Solfenice
--Script by XGlitchy30
function c27606971.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27606971,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27606971+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c27606971.condition)
	e1:SetTarget(c27606971.target)
	e1:SetOperation(c27606971.activate)
	c:RegisterEffect(e1)
	--excavate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27606971)
	e2:SetCondition(c27606971.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c27606971.thop)
	c:RegisterEffect(e2)
end
--filters
function c27606971.cfilter(c,lv)
	return c:GetLevel()==lv
end
function c27606971.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3721) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c27606971.cfilter,tp,LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,c:GetLevel())
end
function c27606971.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3721) and c:IsAbleToHand() and not c:IsCode(27606971)
end
function c27606971.efilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
--Activate
function c27606971.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=0
end
function c27606971.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27606971.filter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27606971.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27606971.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)~=0 then
			if Duel.IsExistingMatchingCard(c27606971.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(27606971,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606971.thfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
				if tc then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
					Duel.ShuffleHand(tp)
				end
			end
		end
	end
end
--excavate
function c27606971.thcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c27606971.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27606971.efilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToGrave() then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(spcard,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	else Duel.ShuffleDeck(tp) end
end