--Onde Gusciosigillo
--=£1G*
function c19800025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19800025+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c19800025.cost)
	e1:SetTarget(c19800025.target)
	e1:SetOperation(c19800025.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c19800025.handcon)
	c:RegisterEffect(e2)
end
--filters
function c19800025.checkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982)
end
function c19800025.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c19800025.hfilter(c)
	return c:IsFaceup() and c:IsCode(19800001)
end
--Activate
function c19800025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c19800025.checkfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19800025.filter(chkc) end
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingTarget(c19800025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local upg=Duel.GetMatchingGroup(c19800025.checkfilter,tp,LOCATION_MZONE,0,nil):GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19800025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,upg,nil)
end
function c19800025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
--act in hand
function c19800025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		if Duel.IsExistingMatchingCard(c19800025.hfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.PayLPCost(tp,2000)
		end
	end
end
function c19800025.handcon(e)
	return Duel.IsExistingMatchingCard(c19800025.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end