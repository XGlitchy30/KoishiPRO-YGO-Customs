--Operazione Gusciosigillo
--=£lG*
function c19800012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19800012,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19800012+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c19800012.cost)
	e1:SetTarget(c19800012.target)
	e1:SetOperation(c19800012.activate)
	c:RegisterEffect(e1)
end
--filters
function c19800012.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c19800012.checkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c19800012.checkfilter2(c)
	return c:GetFlagEffect(19800012)>0
end
function c19800012.thfilter(c)
	return c:IsSetCard(0x1982) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
--Activate
function c19800012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19800012.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c19800012.costfilter,tp,LOCATION_ONFIELD,0,1,2,e:GetHandler())
	if g:GetCount()<=0 then return end
	Duel.Destroy(g,REASON_COST)
	local op=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(op)
end
function c19800012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c19800012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local prevchk=g:Filter(c19800012.checkfilter,nil)
	if prevchk:GetCount()>0 then
		for chk in aux.Next(prevchk) do
			chk:RegisterFlagEffect(19800012,RESET_EVENT+EVENT_CUSTOM+19800012,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE,1)
		end
	end
	Duel.SendtoGrave(g,REASON_EFFECT)
	local op=Duel.GetOperatedGroup():Filter(c19800012.checkfilter2,1,nil)
	if op:GetCount()>0 and Duel.IsExistingMatchingCard(c19800012.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(19800012,1)) then
			local th=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19800012.thfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
			if th then
				Duel.SendtoHand(th,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,th)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
				th:RegisterEffect(e1)
			end
		end
	end
	--reset flag effect
	local reset=Duel.GetMatchingGroup(c19800012.checkfilter2,tp,0x10b,0x10b,nil)
	for res in aux.Next(reset) do
		res:ResetFlagEffect(19800012)
	end
end
