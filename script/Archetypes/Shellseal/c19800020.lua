--Riavvio Gusciosigillo
--=£1G*
function c19800020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19800020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19800020.target)
	e1:SetOperation(c19800020.activate)
	c:RegisterEffect(e1)
end
--filters
function c19800020.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1982) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c19800020.checkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
--Activate
function c19800020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c19800020.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c19800020.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19800020.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		if Duel.IsExistingMatchingCard(c19800020.checkfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
			if Duel.SelectYesNo(tp,aux.Stringid(19800020,0)) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end