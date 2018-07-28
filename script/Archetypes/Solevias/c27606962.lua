--Solfenice Splendente, la Fenice Eterna
--Script by XGlitchy30
function c27606962.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,27606962)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--summon success
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_SUMMON_SUCCESS)
	e00:SetOperation(c27606962.sumsuc)
	c:RegisterEffect(e00)
	local e01=e00:Clone()
	e01:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e01)
	local e02=e00:Clone()
	e02:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e02)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c27606962.immunecon)
	e1:SetValue(c27606962.immune)
	c:RegisterEffect(e1)
	--to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27606962,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c27606962.tgcost)
	e2:SetTarget(c27606962.tgtg)
	e2:SetOperation(c27606962.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27606962,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetTarget(c27606962.sptg)
	e3:SetOperation(c27606962.spop)
	c:RegisterEffect(e3)
	--draw 1 card
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27606962,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,27606962)
	e4:SetCondition(c27606962.sccon)
	e4:SetTarget(c27606962.sctg)
	e4:SetOperation(c27606962.scop)
	c:RegisterEffect(e4)
end
--filters
function c27606962.tgfilter(c)
	return c:IsSetCard(0x3721) and c:IsAbleToGrave() and (not c:IsLocation(LOCATION_ONFIELD) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()))
end
function c27606962.spfilter(c,e,tp)
	return c:IsCode(27606963) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
--summon success
function c27606962.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
--immune
function c27606962.immunecon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<Duel.GetLP(1-e:GetHandlerPlayer())
end
function c27606962.immune(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--to GY
function c27606962.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c27606962.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606962.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end
function c27606962.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27606962.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--spsummon
function c27606962.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c27606962.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606962.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
--draw 1 card
function c27606962.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and e:GetHandler():IsReason(REASON_EFFECT)
		and re:GetHandler():IsSetCard(0x3721) and not re:GetHandler():IsCode(27606962)
end
function c27606962.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27606962.scop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end