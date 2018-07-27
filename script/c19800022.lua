--Codice Finale Gusciosigillo
--=£1G*
function c19800022.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c19800022.etarget)
	e1:SetValue(c19800022.efilter)
	c:RegisterEffect(e1)
	--spsummon effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,19800022)
	e2:SetCondition(c19800022.sccon)
	e2:SetCost(c19800022.sccost)
	e2:SetTarget(c19800022.sctg)
	e2:SetOperation(c19800022.scop)
	c:RegisterEffect(e2)
end
--filters
function c19800022.scfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP) and c:IsType(TYPE_LINK) and c:IsSetCard(0x1982)
end
--protection
function c19800022.etarget(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x1982) and not c:IsCode(19800022)
end
function c19800022.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
--spsummon effect
function c19800022.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c19800022.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c19800022.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 
		and Duel.IsExistingMatchingCard(c19800022.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19800022.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sp=Duel.SelectMatchingCard(tp,c19800022.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=sp:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end