--Gusciosigillo Dormiente - Comandante
--=£1G*
function c19800010.initial_effect(c)
	c:SetUniqueOnField(1,0,19800010)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19800010.acttg)
	e1:SetOperation(c19800010.actop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19800010,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c19800010.thcon)
	e2:SetTarget(c19800010.thtg)
	e2:SetOperation(c19800010.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19800010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,19800010)
	e3:SetCost(c19800010.spcost)
	e3:SetTarget(c19800010.sptg)
	e3:SetOperation(c19800010.spop)
	c:RegisterEffect(e3)
	--check damage
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge1:SetCode(EVENT_DAMAGE)
	ge1:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	ge1:SetOperation(c19800010.checkop)
	c:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge2:SetCode(EVENT_DAMAGE)
	ge2:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	ge2:SetCondition(c19800010.preventcon)
	ge2:SetOperation(c19800010.preventop)
	c:RegisterEffect(ge2)
end
--filters
function c19800010.actfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove() and not c:IsSetCard(0x1982)
end
function c19800010.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982)
end
function c19800010.spfilter(c,e,tp)
	return c:IsCode(19800011) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
--Activate
function c19800010.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c19800010.actfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c19800010.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c19800010.actfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--to hand
function c19800010.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:GetPreviousControler()==tp and tc:IsPreviousLocation(LOCATION_MZONE)
		and tc:IsControler(tp) and tc:IsPreviousSetCard(0x1982) and tc:IsType(TYPE_MONSTER)
		and ((not tc:IsType(TYPE_PENDULUM) and not tc:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)) 
		or (tc:IsType(TYPE_PENDULUM) and tc:IsFaceup() and not tc:IsLocation(LOCATION_DECK+LOCATION_HAND)))
end
function c19800010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsAbleToHand() end
	local clone=eg:Clone()
	local tc=clone:GetFirst()
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c19800010.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--spsummon
function c19800010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c19800010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c19800010.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19800010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19800010.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if e:GetHandler():GetFlagEffect(19800002)>0 and e:GetHandler():GetFlagEffect(11800002)==0 then
		tc:RegisterFlagEffect(19800010,0,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
	end
	Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
end
--check damage
function c19800010.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and tp==rp and ev==800 and bit.band(r,REASON_EFFECT)~=0 then
		c:RegisterFlagEffect(19800002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end
function c19800010.preventcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800002)>0
end
function c19800010.preventop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and tp==rp then
		c:RegisterFlagEffect(11800002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end