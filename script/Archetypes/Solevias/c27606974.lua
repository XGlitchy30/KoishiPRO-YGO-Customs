--Cucciolo di Solfenice
--Script by XGlitchy30
function c27606974.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(27606974,0))
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(c27606974.sptg)
	e0:SetOperation(c27606974.spop)
	c:RegisterEffect(e0)
	--spsummon 2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27606974,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,27606974)
	e1:SetCondition(c27606974.sccon)
	e1:SetTarget(c27606974.sctg)
	e1:SetOperation(c27606974.scop)
	c:RegisterEffect(e1)
end
--filters
function c27606974.filter(c,tp,e)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c27606974.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c27606974.spfilter(c,e,tp)
	return c:IsSetCard(0x3721) and not c:IsCode(27606974) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c27606974.shfilter(c)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
--spsummon
function c27606974.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606974.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c27606974.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27606974.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp,e)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606974.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end
--spsummon 2
function c27606974.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
		and re:GetHandler():IsSetCard(0x3721) and not re:GetHandler():IsCode(27606974)
end
function c27606974.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.IsExistingMatchingCard(c27606974.shfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27606974.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606974.shfilter),tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			local lv=Duel.GetOperatedGroup():GetFirst():GetLevel()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
		end
	end
end