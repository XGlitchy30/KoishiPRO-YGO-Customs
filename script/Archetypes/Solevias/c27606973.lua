--Discesa della Solfenice
--Script by XGlitchy30
function c27606973.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27606973)
	e1:SetCondition(c27606973.condition)
	e1:SetTarget(c27606973.target)
	e1:SetOperation(c27606973.activate)
	c:RegisterEffect(e1)
end
--filters
function c27606973.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c27606973.thfilter(c)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
--Activate
function c27606973.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local ct=g:GetCount()
	local tg=g:GetFirst()
	return ct==1 and tg:IsFaceup() and tg:IsType(TYPE_RITUAL) and tg:IsSetCard(0x3721)
end
function c27606973.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606973.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	--chain limit
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		Duel.SetChainLimit(c27606973.chainlm)
	end
end
function c27606973.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c27606973.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,27606973)		
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c27606973.thtg)
	e1:SetOperation(c27606973.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c27606973.chainlm(e,rp,tp)
	return tp==rp
end
--search
function c27606973.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606973.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27606973.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27606973.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end