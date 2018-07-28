--Gusciosigillo Dormiente - Inizializzatore
--=£1G*
function c19800006.initial_effect(c)
	c:SetUniqueOnField(1,0,19800006)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19800006.acttg)
	e1:SetOperation(c19800006.actop)
	c:RegisterEffect(e1)
	--original ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c19800006.atkcon)
	e2:SetTarget(c19800006.atktg)
	e2:SetValue(1800)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,19800006)
	e3:SetCost(c19800006.spcost)
	e3:SetTarget(c19800006.sptg)
	e3:SetOperation(c19800006.spop)
	c:RegisterEffect(e3)
	--check damage
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge1:SetCode(EVENT_DAMAGE)
	ge1:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	ge1:SetOperation(c19800006.checkop)
	c:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge2:SetCode(EVENT_DAMAGE)
	ge2:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	ge2:SetCondition(c19800006.preventcon)
	ge2:SetOperation(c19800006.preventop)
	c:RegisterEffect(ge2)
end
--filters
function c19800006.actfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove() and not c:IsSetCard(0x1982)
end
function c19800006.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982)
end
function c19800006.spfilter(c,e,tp)
	return c:IsCode(19800007) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
--Activate
function c19800006.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c19800006.actfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c19800006.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c19800006.actfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--original ATK
function c19800006.atkcon(e)
	return Duel.IsExistingMatchingCard(c19800006.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c19800006.atktg(e,c)
	return c19800006.cfilter(c)
end
--spsummon
function c19800006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c19800006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c19800006.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19800006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19800006.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if e:GetHandler():GetFlagEffect(19800002)>0 and e:GetHandler():GetFlagEffect(11800002)==0 then
		tc:RegisterFlagEffect(19800006,0,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
	end
	Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
end
--check damage
function c19800006.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and tp==rp and ev==800 and bit.band(r,REASON_EFFECT)~=0 then
		c:RegisterFlagEffect(19800002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end
function c19800006.preventcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800002)>0
end
function c19800006.preventop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and tp==rp then
		c:RegisterFlagEffect(11800002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end