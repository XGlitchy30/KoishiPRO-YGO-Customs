--Principessa Sacerdotessa della Solfenice
--Script by XGlitchy30
function c27606980.initial_effect(c)
	c:EnableReviveLimit()
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27606980,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27606980.protcon)
	e1:SetOperation(c27606980.protop)
	c:RegisterEffect(e1)
	--spsummon event
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c27606980.ctcon)
	e2:SetOperation(c27606980.ctop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,27606980)
	e3:SetCondition(c27606980.sccon)
	e3:SetTarget(c27606980.sctg)
	e3:SetOperation(c27606980.scop)
	c:RegisterEffect(e3)
end
--filters
function c27606980.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:GetSummonLocation()==LOCATION_EXTRA
end
function c27606980.scfilter(c)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
--protection
function c27606980.protcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c27606980.protop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetValue(aux.tgoval)
	e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
end
--spsummon event
function c27606980.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27606980.cfilter,1,nil,1-tp)
end
function c27606980.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ht2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht1<=0 or ht2<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	g:Merge(sg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
	g:Merge(sg)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
--search
function c27606980.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x3721) and not re:GetHandler():IsCode(27606980)
end
function c27606980.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606980.scfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c27606980.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606980.scfilter),tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end