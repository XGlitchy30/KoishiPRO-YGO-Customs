--Gusciosigillo Dormiente - Pellegrino
--=£1G*
function c19800004.initial_effect(c)
	c:SetUniqueOnField(1,0,19800004)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19800004.acttg)
	e1:SetOperation(c19800004.actop)
	c:RegisterEffect(e1)
	--target protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c19800004.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,19800004)
	e3:SetCost(c19800004.spcost)
	e3:SetTarget(c19800004.sptg)
	e3:SetOperation(c19800004.spop)
	c:RegisterEffect(e3)
	--check damage
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge1:SetCode(EVENT_DAMAGE)
	ge1:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	ge1:SetOperation(c19800004.checkop)
	c:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge2:SetCode(EVENT_DAMAGE)
	ge2:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	ge2:SetCondition(c19800004.preventcon)
	ge2:SetOperation(c19800004.preventop)
	c:RegisterEffect(ge2)
end
--filters
function c19800004.actfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove() and not c:IsSetCard(0x1982)
end
function c19800004.spfilter(c,e,tp)
	return c:IsCode(19800005) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
--Activate
function c19800004.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c19800004.actfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c19800004.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c19800004.actfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--target protection
function c19800004.tglimit(e,c)
	return c:IsSetCard(0x1982) and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c~=e:GetHandler()
end
--spsummon
function c19800004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c19800004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c19800004.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19800004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19800004.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if e:GetHandler():GetFlagEffect(19800002)>0 and e:GetHandler():GetFlagEffect(11800002)==0 then
		tc:RegisterFlagEffect(19800004,0,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
	end
	Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
end
--check damage
function c19800004.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and tp==rp and ev==800 and bit.band(r,REASON_EFFECT)~=0 then
		c:RegisterFlagEffect(19800002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end
function c19800004.preventcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800002)>0
end
function c19800004.preventop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and tp==rp then
		c:RegisterFlagEffect(11800002,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end