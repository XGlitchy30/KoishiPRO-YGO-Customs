--Richiamo della Solfenice
--Script by XGlitchy30
function c27606966.initial_effect(c)
	--Activate 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27606966,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27606966)
	e1:SetCost(c27606966.info)
	e1:SetTarget(c27606966.target1)
	e1:SetOperation(c27606966.activate1)
	c:RegisterEffect(e1)
	--Activate 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27606966,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,21606966)
	e2:SetCost(c27606966.info)
	e2:SetTarget(c27606966.target2)
	e2:SetOperation(c27606966.activate2)
	c:RegisterEffect(e2)
end
--filters
function c27606966.filter(c)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_MONSTER) and c:GetLevel()<=6 and c:IsAbleToHand()
end
function c27606966.filter2(c)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_MONSTER) and c:GetLevel()<=6 and c:IsAbleToGrave()
end
--Activate 1
function c27606966.info(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c27606966.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606966.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c27606966.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606966.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Activate 2
function c27606966.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606966.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c27606966.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27606966.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end