--Rinforzo Gusciosigillo
--=£lG*
function c19800016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19800016,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19800016+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c19800016.cost)
	e1:SetTarget(c19800016.target)
	e1:SetOperation(c19800016.activate)
	c:RegisterEffect(e1)
end
--filters
function c19800016.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c19800016.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982)
end
function c19800016.checkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
--Activate
function c19800016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c19800016.cfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c19800016.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c19800016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c19800016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19800016.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	--change attribute
	if Duel.IsExistingMatchingCard(c19800016.checkfilter,tp,0,LOCATION_MZONE,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(19800016,1)) then
			local op=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local tc2=op:GetFirst()
			while tc2 do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(ATTRIBUTE_DARK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc2:RegisterEffect(e2)
				tc2=op:GetNext()
			end
		end
	end
	--halve damage
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(c19800016.rdval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c19800016.rdval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return val/2
	elseif bit.band(r,REASON_EFFECT)~=0 then
		return val/2
	else
		return val
	end
end